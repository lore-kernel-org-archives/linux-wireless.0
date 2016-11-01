Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35122 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1168359AbcKAKCW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Nov 2016 06:02:22 -0400
Received: by mail-pf0-f195.google.com with SMTP id s8so11283165pfj.2
        for <linux-wireless@vger.kernel.org>; Tue, 01 Nov 2016 03:02:21 -0700 (PDT)
Date: Tue, 1 Nov 2016 19:54:35 +1000
From: Barry Day <briselec@gmail.com>
To: John Heenan <john@zgus.com>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] rtl8xxxu: Fix for agressive power saving by rtl8723bu
 wireless IC
Message-ID: <20161101095433.GA15859@testbox> (sfid-20161101_110226_065716_DE02D34F)
References: <20161101072447.GA21575@cube>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161101072447.GA21575@cube>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 01, 2016 at 05:24:47PM +1000, John Heenan wrote:
> The rtl8723bu wireless IC shows evidence of a more agressive approach to
> power saving, powering down its RF side when there is no wireless
> interfacing but leaving USB interfacing intact. This makes the wireless
> IC more suitable for use in devices which need to keep their power use
> as low as practical, such as tablets and Surface Pro type devices.
> 
> In effect this means that a full initialisation must be performed
> whenever a wireless interface is brought up. It also means that
> interpretations of power status from general wireless registers should
> not be relied on to influence an init sequence.
> 
> The patch works by forcing a fuller initialisation and forcing it to
> occur more often in code paths (such as occurs during a low level
> authentication that initiates wireless interfacing).
> 
> The initialisation sequence is now more consistent with code based
> directly on vendor code. For example while the vendor derived code
> interprets a register as indcating a particular powered state, it does
> not use this information to influence its init sequence.
> 
> Only devices that use the rtl8723bu driver are affected by this patch.
> 
> With this patch wpa_supplicant reliably and consistently connects with
> an AP. Before a workaround such as executing rmmod and modprobe before
> each call to wpa_supplicant worked with some distributions.
> 
> Signed-off-by: John Heenan <john@zgus.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index 04141e5..ab2f2ef 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -3900,7 +3900,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
>  	 * Fix 92DU-VC S3 hang with the reason is that secondary mac is not
>  	 * initialized. First MAC returns 0xea, second MAC returns 0x00
>  	 */
> -	if (val8 == 0xea)
> +	if (val8 == 0xea || priv->fops == &rtl8723bu_fops)
>  		macpower = false;
>  	else
>  		macpower = true;
> @@ -5779,6 +5779,12 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
>  
>  	ret = 0;
>  
> +	if(priv->fops == &rtl8723bu_fops) {
> +		ret = rtl8xxxu_init_device(hw);
> +		if (ret)
> +			goto error_out;
> +	}
> +
>  	init_usb_anchor(&priv->rx_anchor);
>  	init_usb_anchor(&priv->tx_anchor);
>  	init_usb_anchor(&priv->int_anchor);
> @@ -6080,9 +6086,11 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
>  		goto exit;
>  	}
>  
> -	ret = rtl8xxxu_init_device(hw);
> -	if (ret)
> -		goto exit;
> +	if(priv->fops != &rtl8723bu_fops) {
> +		ret = rtl8xxxu_init_device(hw);
> +		if (ret)
> +			goto exit;
> +	}
>  
>  	hw->wiphy->max_scan_ssids = 1;
>  	hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
> -- 
> 2.10.1
> 

I've been trying similar modifications, testing them with the 8192eu and cu.
Basically I moved all the usb stuff out of start and stop and into probe and
disconnect. I moved the call to rtl8xxxu_init_device() from probe to
start.
Doing wpa_supplicant restart tests, the 8192cu still works everytime as it did
before. The 8192eu now works at least 50% of the time, and when it fails it's
now during the 4-way handshake phase which may be a separate issue confined to
the 8192eu only.
Note these results rely on changing the macpower test to this -
	if(val8 == 0xea || val8 == 0xff)
which is different again from what you are using so I'm of the opinion we
need to come up with a different way of telling whether the mac is powered.
