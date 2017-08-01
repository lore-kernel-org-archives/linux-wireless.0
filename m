Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:33387 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751857AbdHAMlH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 08:41:07 -0400
Received: by mail-qt0-f173.google.com with SMTP id a18so8124533qta.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Aug 2017 05:41:07 -0700 (PDT)
Subject: Re: [PATCH 1/3] brcmfmac: set wpa_auth to WPA_AUTH_DISABLED in
 AP/opensecurity mode
To: Wright Feng <wright.feng@cypress.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <1501577287-28904-1-git-send-email-wright.feng@cypress.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <bbe8b942-fba4-8c26-eff5-203b192528f2@broadcom.com> (sfid-20170801_144114_516438_464B2CF7)
Date: Tue, 1 Aug 2017 14:41:02 +0200
MIME-Version: 1.0
In-Reply-To: <1501577287-28904-1-git-send-email-wright.feng@cypress.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01-08-17 10:48, Wright Feng wrote:
> When setting wpa_auth to WPA_AUTH_NONE(1) in AP mode with WEP secuirty,
> firmware will set privacy bit and add WPA OUI in VENDOR IE in beacon and
> probe response. It confuses the supplicant in sation client by the
> security type from softAP beacon and we will see [WPA-?] in scan result.
> So we set WPA_AUTH_DISABLED in softAP mode with opensecurity.
> 
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index a31ea10..54588d2 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -3854,6 +3854,7 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
>  static s32 brcmf_configure_opensecurity(struct brcmf_if *ifp)
>  {
>  	s32 err;
> +	s32 wpa_val;
>  
>  	/* set auth */
>  	err = brcmf_fil_bsscfg_int_set(ifp, "auth", 0);
> @@ -3868,7 +3869,11 @@ static s32 brcmf_configure_opensecurity(struct brcmf_if *ifp)
>  		return err;
>  	}
>  	/* set upper-layer auth */
> -	err = brcmf_fil_bsscfg_int_set(ifp, "wpa_auth", WPA_AUTH_NONE);
> +	if (brcmf_is_ibssmode(ifp->vif))
> +		wpa_val = WPA_AUTH_NONE;
> +	else
> +		wpa_val = WPA_AUTH_DISABLED;
> +	err = brcmf_fil_bsscfg_int_set(ifp, "wpa_auth", wpa_val);

Is WPA_AUTH_NONE ok for IBSS mode? Not sure why it is handled
differently. Is it because you do not want to change things for IBSS
mode as you did not try that?

Regards,
Arend
