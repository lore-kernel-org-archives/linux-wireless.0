Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36195 "EHLO
        mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758649AbcIWJPd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Sep 2016 05:15:33 -0400
Received: by mail-pa0-f49.google.com with SMTP id qn7so21080149pac.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Sep 2016 02:15:33 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: fix memory leak in brcmf_fill_bss_param
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20160921062327.28729-1-zajec5@gmail.com>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d02288e7-5a45-703c-ce57-f5bc60583797@broadcom.com> (sfid-20160923_111650_720371_29216453)
Date: Fri, 23 Sep 2016 11:15:18 +0200
MIME-Version: 1.0
In-Reply-To: <20160921062327.28729-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21-9-2016 8:23, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This function is called from get_station callback which means that every
> time user space was getting/dumping station(s) we were leaking 2 KiB.
> 

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Fixes: 1f0dc59a6de ("brcmfmac: rework .get_station() callback")
> Cc: stable@vger.kernel.org # 4.2+
> ---
> Kalle, ideally this should go as 4.8 fix, but I'm aware it's quite late.
> If you are not planning to send another pull request, just get it for
> the next release and let's let stable guys backport it.
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index b8aec5e5..62a7675 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -2533,7 +2533,7 @@ static void brcmf_fill_bss_param(struct brcmf_if *ifp, struct station_info *si)
>  				     WL_BSS_INFO_MAX);
>  	if (err) {
>  		brcmf_err("Failed to get bss info (%d)\n", err);
> -		return;
> +		goto out_kfree;
>  	}
>  	si->filled |= BIT(NL80211_STA_INFO_BSS_PARAM);
>  	si->bss_param.beacon_interval = le16_to_cpu(buf->bss_le.beacon_period);
> @@ -2545,6 +2545,9 @@ static void brcmf_fill_bss_param(struct brcmf_if *ifp, struct station_info *si)
>  		si->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_PREAMBLE;
>  	if (capability & WLAN_CAPABILITY_SHORT_SLOT_TIME)
>  		si->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
> +
> +out_kfree:
> +	kfree(buf);
>  }
>  
>  static s32
> 
