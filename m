Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3986 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967935Ab3DSINJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 04:13:09 -0400
Message-ID: <5170FC8A.5020306@broadcom.com> (sfid-20130419_101314_796191_B5FDB6EF)
Date: Fri, 19 Apr 2013 10:12:58 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Wei Yongjun" <weiyj.lk@gmail.com>
cc: brudley@broadcom.com, frankyl@broadcom.com, meuleman@broadcom.com,
	linville@tuxdriver.com, pieterpg@broadcom.com, phaber@broadcom.com,
	yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH -next] brcmfmac: fix potential NULL pointer
 dereference in brcmf_fws_flow_control_check()
References: <CAPgLHd8KiH+BGZJ704yk2ZsiVQC8GH4FUZhC-_rstdoaA4BOaA@mail.gmail.com>
In-Reply-To: <CAPgLHd8KiH+BGZJ704yk2ZsiVQC8GH4FUZhC-_rstdoaA4BOaA@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/19/2013 04:14 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> The dereference to 'ifp' in debug code should be moved below the NULL test.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
> index 1bcd58c..69d5ad2 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
> @@ -821,11 +821,12 @@ brcmf_fws_flow_control_check(struct brcmf_fws_info *fws, struct pktq *pq,
>   {
>   	struct brcmf_if *ifp = fws->drvr->iflist[if_id];
>
> -	brcmf_dbg(TRACE,
> -		  "enter: bssidx=%d, ifidx=%d\n", ifp->bssidx, ifp->ifidx);
>   	if (WARN_ON(!ifp))
>   		return;
>
> +	brcmf_dbg(TRACE,
> +		  "enter: bssidx=%d, ifidx=%d\n", ifp->bssidx, ifp->ifidx);
> +
>   	if ((ifp->netif_stop & BRCMF_NETIF_STOP_REASON_FWS_FC) &&
>   	    pq->len <= BRCMF_FWS_FLOWCONTROL_LOWATER)
>   		brcmf_txflowblock_if(ifp,
>
>


