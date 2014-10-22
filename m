Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:43652 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbaJVQbf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 12:31:35 -0400
Received: by mail-pd0-f182.google.com with SMTP id y10so3842322pdj.13
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 09:31:34 -0700 (PDT)
Message-ID: <5447DBDB.3040706@lwfinger.net> (sfid-20141022_183139_147851_E0954097)
Date: Wed, 22 Oct 2014 11:31:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Karsten Wiese <fzuuzf@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] rtl8192cu: Call ieee80211_register_hw from rtl_usb_probe
References: <1413985654-25070-1-git-send-email-fzuuzf@googlemail.com> <1413985654-25070-3-git-send-email-fzuuzf@googlemail.com>
In-Reply-To: <1413985654-25070-3-git-send-email-fzuuzf@googlemail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/22/2014 08:47 AM, Karsten Wiese wrote:
> In a previous patch the call to ieee80211_register_hw was moved from the
> load firmware callback to the rtl_pci_probe only.
> rt8192cu also uses this callback. Currently it doesnt create a wlan%d device.
> Fill in the call to ieee80211_register_hw in rtl_usb_probe.
>
> Signed-off-by: Karsten Wiese <fzuuzf@googlemail.com>
> ---
>   drivers/net/wireless/rtlwifi/usb.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)

Sorry that I missed this one.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry


>
> diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
> index 10cf69c..46ee956 100644
> --- a/drivers/net/wireless/rtlwifi/usb.c
> +++ b/drivers/net/wireless/rtlwifi/usb.c
> @@ -1117,7 +1117,18 @@ int rtl_usb_probe(struct usb_interface *intf,
>   	}
>   	rtlpriv->cfg->ops->init_sw_leds(hw);
>
> +	err = ieee80211_register_hw(hw);
> +	if (err) {
> +		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
> +			 "Can't register mac80211 hw.\n");
> +		err = -ENODEV;
> +		goto error_out;
> +	}
> +	rtlpriv->mac80211.mac80211_registered = 1;
> +
> +	set_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
>   	return 0;
> +
>   error_out:
>   	rtl_deinit_core(hw);
>   	_rtl_usb_io_handler_release(hw);
>

