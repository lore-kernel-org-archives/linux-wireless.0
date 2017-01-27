Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:33712 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754447AbdA0Mtt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 07:49:49 -0500
Received: by mail-pg0-f41.google.com with SMTP id 204so81351509pge.0
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jan 2017 04:49:28 -0800 (PST)
Subject: Re: [PATCH 4/5] brcmfmac: allow wowlan support to be per device
To: Kalle Valo <kvalo@codeaurora.org>
References: <1485518971-28183-1-git-send-email-arend.vanspriel@broadcom.com>
 <1485518971-28183-5-git-send-email-arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <88583716-3c6c-2a4b-f8a0-e6689b3a8943@broadcom.com> (sfid-20170127_135122_451387_14B58931)
Date: Fri, 27 Jan 2017 13:22:39 +0100
MIME-Version: 1.0
In-Reply-To: <1485518971-28183-5-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27-1-2017 13:09, Arend van Spriel wrote:
> The wowlan support is (partially) determined dynamic by checking the
> device/firmware capabilities. So they can differ per device. So it
> is not possible to use a static global. Instead use the global as a
> template and use kmemdup(). When kmemdup() fails the template is used
> unmodified.
> 
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 26 ++++++++++++++++------
>  1 file changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index c81d78f..9d5a561 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -6339,7 +6339,7 @@ static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
>  }
>  
>  #ifdef CONFIG_PM
> -static struct wiphy_wowlan_support brcmf_wowlan_support = {
> +static const struct wiphy_wowlan_support brcmf_wowlan_support = {
>  	.flags = WIPHY_WOWLAN_MAGIC_PKT | WIPHY_WOWLAN_DISCONNECT,
>  	.n_patterns = BRCMF_WOWL_MAXPATTERNS,
>  	.pattern_max_len = BRCMF_WOWL_MAXPATTERNSIZE,
> @@ -6352,21 +6352,29 @@ static void brcmf_wiphy_wowl_params(struct wiphy *wiphy, struct brcmf_if *ifp)
>  {
>  #ifdef CONFIG_PM
>  	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
> +	struct wiphy_wowlan_support *wowlan_support;
> +
> +	wowlan_support = kmemdup(&brcmf_wowlan_support,
> +				 sizeof(brcmf_wowlan_support), GFP_KERNEL);
> +	if (!wowlan_support) {
> +		brcmf_err("only support basic wowlan features\n");
> +		wiphy->wowlan = &brcmf_wowlan_support;
> +		return;
> +	}
>  
>  	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PNO)) {
>  		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_WOWL_ND)) {
> -			brcmf_wowlan_support.flags |= WIPHY_WOWLAN_NET_DETECT;
> -			brcmf_wowlan_support.max_nd_match_sets =
> -				BRCMF_PNO_MAX_PFN_COUNT;
> +			wowlan_support->flags |= WIPHY_WOWLAN_NET_DETECT;
> +			wowlan_support->max_nd_match_sets = BRCMF_PNO_MAX_PFN_COUNT;

Did not checkpatch these before sending. This is over 80 chars so please
drop this series and I will send a V2.

Regards,
Arend
