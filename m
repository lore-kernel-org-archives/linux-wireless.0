Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:7312 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbbISJn2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Sep 2015 05:43:28 -0400
Message-ID: <55FD2E3E.4020804@broadcom.com> (sfid-20150919_114331_037954_F156B168)
Date: Sat, 19 Sep 2015 11:43:26 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 01/16] brcmfmac: Fix exception handling.
References: <1442606899-31872-1-git-send-email-arend@broadcom.com> <1442606899-31872-2-git-send-email-arend@broadcom.com>
In-Reply-To: <1442606899-31872-2-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/18/2015 10:08 PM, Arend van Spriel wrote:
> From: Hante Meuleman <meuleman@broadcom.com>
>
> In some exception situations the ifp->vif was not properly assigned
> which could result in crash.

Tested-by: Rafał Miłecki <zajec5@gmail.com>
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
> index 600098d..da24bf0 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
> @@ -6332,6 +6332,7 @@ wiphy_unreg_out:
>   priv_out:
>   	wl_deinit_priv(cfg);
>   	brcmf_free_vif(vif);
> +	ifp->vif = NULL;
>   wiphy_out:
>   	brcmf_free_wiphy(wiphy);
>   	return NULL;
>

