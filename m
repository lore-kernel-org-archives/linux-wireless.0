Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54814 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756558AbcKCQVG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Nov 2016 12:21:06 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: John Heenan <john@zgus.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] rtl8xxxu: Fix for agressive power saving by rtl8723bu wireless IC
References: <20161101072447.GA21575@cube>
Date: Thu, 03 Nov 2016 12:21:03 -0400
In-Reply-To: <20161101072447.GA21575@cube> (John Heenan's message of "Tue, 1
        Nov 2016 17:24:47 +1000")
Message-ID: <wrfj1syso7ps.fsf@redhat.com> (sfid-20161103_172109_655711_E006D286)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John Heenan <john@zgus.com> writes:
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

I am at Linux Plumbers this week, so my response time is slow. Next week
I am on PTO, so I will not respond.

First of all, why do you keep CC'ing multiple mailing lists that do not
matter? This discussion belongs on linux-wireless not on netdev or lkml.
CC'ing Kalle directly is not going to get him to apply this broken patch
for you.

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

Why oh why do you insist on not using the *standard* way of coping with
this? 'priv-rtl_chip' is used everywhere else, but you just have to do
something awful like this?

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

Read Documentation/CodingStyle - as others already pointed you at.

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

Again coding style violation.

Second, I am NOT going to accept any patches that fundamentally changes
the init sequence of the code for just one device.

I already told you I want to find out *why* this matters, and what part
of rtl8xxxu_init_device() is the culprit. I want to understand the
actual problem, not just blindly move stuff around.

Jes
