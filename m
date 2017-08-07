Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36865 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751364AbdHGMng (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 08:43:36 -0400
Received: by mail-wm0-f53.google.com with SMTP id t201so6155364wmt.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 05:43:36 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: add setting carrier state ON for successful
 roaming
To: Wright Feng <wright.feng@cypress.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org,
        chi-hsien.lin@cypress.com
References: <1502093812-5011-1-git-send-email-wright.feng@cypress.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <59886076.5080600@broadcom.com> (sfid-20170807_144339_914207_FCD5A861)
Date: Mon, 7 Aug 2017 14:43:34 +0200
MIME-Version: 1.0
In-Reply-To: <1502093812-5011-1-git-send-email-wright.feng@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/7/2017 10:16 AM, Wright Feng wrote:
> From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
>
> After association, ping is not working when sweeping the channel at the
> AP side. It is caused by having incorrect carrier state (OFF) for the STA
> in successful roaming. This patch sets the carrier state ON for the case.

This seems a specific scenario where the initial connect attempt by the 
host actually results in the firmware roaming, ie. switching to another 
AP, before completing the connection. Still it is needed here so ...

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 617199c..71f18b9 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -5552,10 +5552,13 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
>   	u32 status = e->status;
>
>   	if (event == BRCMF_E_ROAM && status == BRCMF_E_STATUS_SUCCESS) {
> -		if (test_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state))
> +		if (test_bit(BRCMF_VIF_STATUS_CONNECTED,
> +			     &ifp->vif->sme_state)) {
>   			brcmf_bss_roaming_done(cfg, ifp->ndev, e);
> -		else
> +		} else {
>   			brcmf_bss_connect_done(cfg, ifp->ndev, e, true);
> +			brcmf_net_setcarrier(ifp, true);
> +		}
>   	}
>
>   	return 0;
>
