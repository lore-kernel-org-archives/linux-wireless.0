Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41709 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab2IJQiN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 12:38:13 -0400
Received: by eekc1 with SMTP id c1so1316649eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Sep 2012 09:38:11 -0700 (PDT)
From: Florian Fainelli <florian@openwrt.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 06/10] brcmfmac: fix big endian bug in i-scan.
Date: Mon, 10 Sep 2012 18:37:32 +0200
Message-ID: <3265895.MSDQPtTcs3@flexo> (sfid-20120910_183816_284163_5FCE82C4)
In-Reply-To: <1347283018-24223-7-git-send-email-arend@broadcom.com>
References: <1347283018-24223-1-git-send-email-arend@broadcom.com> <1347283018-24223-7-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Monday 10 September 2012 15:16:54 Arend van Spriel wrote:
> From: Hante Meuleman <meuleman@broadcom.com>
> 
> ssid len is 32 bit and needs endian conversion for big endian systems.
> 
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

This looks like a candidate for stable.

> ---
>  .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c 
b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> index 4a27ca0..6623f48 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> @@ -501,8 +501,10 @@ static void brcmf_iscan_prep(struct 
brcmf_scan_params_le *params_le,
>  	params_le->active_time = cpu_to_le32(-1);
>  	params_le->passive_time = cpu_to_le32(-1);
>  	params_le->home_time = cpu_to_le32(-1);
> -	if (ssid && ssid->SSID_len)
> -		memcpy(&params_le->ssid_le, ssid, sizeof(struct brcmf_ssid));
> +	if (ssid && ssid->SSID_len) {
> +		params_le->ssid_le.SSID_len = cpu_to_le32(ssid->SSID_len);
> +		memcpy(&params_le->ssid_le.SSID, ssid->SSID, ssid->SSID_len);
> +	}
>  }
>  
>  static s32
> -- 
> 1.7.9.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
