Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59710 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbdESEuE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 00:50:04 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Wright Feng <wright.feng@cypress.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Chi-hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: Re: [PATCH] brcmfmac: remove setting IBSS mode when stopping AP
References: <1495099339-7626-1-git-send-email-wright.feng@cypress.com>
Date: Fri, 19 May 2017 07:49:58 +0300
In-Reply-To: <1495099339-7626-1-git-send-email-wright.feng@cypress.com>
        (Wright Feng's message of "Thu, 18 May 2017 17:22:19 +0800")
Message-ID: <87efvla1s9.fsf@codeaurora.org> (sfid-20170519_065014_119333_899B9D53)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wright Feng <wright.feng@cypress.com> writes:

> From: Chi-hsien Lin <Chi-Hsien.Lin@cypress.com>
>
> Setting IBSS mode when stopping AP may affect functionality of INFRA
> mode on another interface. For instance, if user creates and stops
> hostap daemon on virtual interface, then association cannot work on
> primary interface because default BSS has been set to IBSS mode in
> firmware side. The IBSS mode should be set when cfg80211 changes the
> interface.
>
> Reviewed-by: Wright Feng <wright.feng@cypress.com>
> Signed-off-by: Chi-hsien Lin <Chi-Hsien.Lin@cypress.com>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 944b83c..ce2a5b6 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -4658,9 +4658,6 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
>  		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 0);
>  		if (err < 0)
>  			brcmf_err("setting AP mode failed %d\n", err);
> -		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, 0);
> -		if (err < 0)
> -			brcmf_err("setting INFRA mode failed %d\n", err);

The title talks about setting IBSS mode but the code looks to be about
setting INFRA mode. Is this correct?

-- 
Kalle Valo
