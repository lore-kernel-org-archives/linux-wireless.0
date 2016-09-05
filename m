Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36330 "EHLO
        mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932249AbcIEKh7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Sep 2016 06:37:59 -0400
Received: by mail-pa0-f52.google.com with SMTP id id6so2692625pad.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Sep 2016 03:37:59 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: avoid potential stack overflow in
 brcmf_cfg80211_start_ap()
To: Kalle Valo <kvalo@codeaurora.org>
References: <1473068749-22487-1-git-send-email-arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <36836ecb-e44c-086c-bc84-6dcf16a9981a@broadcom.com> (sfid-20160905_123803_227543_730ACC81)
Date: Mon, 5 Sep 2016 12:37:44 +0200
MIME-Version: 1.0
In-Reply-To: <1473068749-22487-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5-9-2016 11:45, Arend van Spriel wrote:
> User-space can choose to omit NL80211_ATTR_SSID and only provide raw
> IE TLV data. When doing so it can provide SSID IE with length exceeding
> the allowed size. The driver further processes this IE copying it
> into a local variable without checking the length. Hence stack can be
> corrupted and used as exploit.

This patch is intended for wireless-drivers repository, ie. for v4.8.

Regards,
Arend

> Cc: stable@vger.kernel.org # v4.7
> Reported-by: Daxing Guo <freener.gdx@gmail.com>
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 5db56a7..b8aec5e5 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -4527,7 +4527,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
>  				(u8 *)&settings->beacon.head[ie_offset],
>  				settings->beacon.head_len - ie_offset,
>  				WLAN_EID_SSID);
> -		if (!ssid_ie)
> +		if (!ssid_ie || ssid_ie->len > IEEE80211_MAX_SSID_LEN)
>  			return -EINVAL;
>  
>  		memcpy(ssid_le.SSID, ssid_ie->data, ssid_ie->len);
> 
