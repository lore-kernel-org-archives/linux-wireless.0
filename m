Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:32897 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbcDTIbL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2016 04:31:11 -0400
Received: by mail-pa0-f45.google.com with SMTP id zm5so15729529pac.0
        for <linux-wireless@vger.kernel.org>; Wed, 20 Apr 2016 01:31:10 -0700 (PDT)
Subject: Re: [patch] brcmfmac: testing the wrong variable in
 brcmf_rx_hdrpull()
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
References: <20160419142543.GC4876@mwanda>
Cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	kernel-janitors@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <57173E44.6050306@broadcom.com> (sfid-20160420_103131_429980_02EF2D50)
Date: Wed, 20 Apr 2016 10:31:00 +0200
MIME-Version: 1.0
In-Reply-To: <20160419142543.GC4876@mwanda>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19-4-2016 16:25, Dan Carpenter wrote:
> Smatch complains about this code:
> 
>     drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:335 brcmf_rx_hdrpull()
>     error: we previously assumed '*ifp' could be null (see line 333)
> 
> The problem is that we recently changed these from "ifp" to "*ifp" but
> there was one that we didn't update.
> 
> -       if (ret || !ifp || !ifp->ndev) {
> +       if (ret || !(*ifp) || !(*ifp)->ndev) {
>                 if (ret != -ENODATA && ifp)
>                                        ^^^
> -                       ifp->stats.rx_errors++;
> +                       (*ifp)->stats.rx_errors++;
> 
> I have updated it to *ifp as well.  We always call this function is a
> non-NULL "ifp" pointer, btw.

Great. Maybe we (Broadcom) should consider running smatch on our patch
series or simply rely on your excellent work :-p. Thanks for catching this.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Fixes: c462ebcdfe42 ('brcmfmac: create common function for handling brcmf_proto_hdrpull()')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index 1b476d1..b590499 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> @@ -331,7 +331,7 @@ static int brcmf_rx_hdrpull(struct brcmf_pub *drvr, struct sk_buff *skb,
>  	ret = brcmf_proto_hdrpull(drvr, true, skb, ifp);
>  
>  	if (ret || !(*ifp) || !(*ifp)->ndev) {
> -		if (ret != -ENODATA && ifp)
> +		if (ret != -ENODATA && *ifp)
>  			(*ifp)->stats.rx_errors++;
>  		brcmu_pkt_buf_free_skb(skb);
>  		return -ENODATA;
> 
