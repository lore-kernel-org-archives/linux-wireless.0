Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:3553 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbbISJng (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Sep 2015 05:43:36 -0400
Message-ID: <55FD2E46.4030304@broadcom.com> (sfid-20150919_114338_700211_5B7F1B65)
Date: Sat, 19 Sep 2015 11:43:34 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 16/16] brcmfmac: Accept events when TDLS is used in combination
 with p2p.
References: <1442606899-31872-1-git-send-email-arend@broadcom.com> <1442606899-31872-17-git-send-email-arend@broadcom.com>
In-Reply-To: <1442606899-31872-17-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/18/2015 10:08 PM, Arend van Spriel wrote:
> From: Hante Meuleman <meuleman@broadcom.com>
>
> TDLS events are mapped back to primary interface but when p2p is in
> use then this fails because the check was incorrect by checking
> bsscfg number. Which can be different when a p2p device has been
> created.

Tested-by: Rafał Miłecki <zajec5@gmail.com>
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/fweh.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
> index 81542e0..383d6fa 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
> @@ -300,8 +300,7 @@ static void brcmf_fweh_event_worker(struct work_struct *work)
>   			goto event_free;
>   		}
>
> -		if ((event->code == BRCMF_E_TDLS_PEER_EVENT) &&
> -		    (emsg.bsscfgidx == 1))
> +		if (event->code == BRCMF_E_TDLS_PEER_EVENT)
>   			ifp = drvr->iflist[0];
>   		else
>   			ifp = drvr->iflist[emsg.bsscfgidx];
>

