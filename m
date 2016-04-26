Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54128 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbcDZJaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 05:30:11 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: brcmfmac: testing the wrong variable in brcmf_rx_hdrpull()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160419142543.GC4876@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	kernel-janitors@vger.kernel.org
Message-Id: <20160426093010.1EFA76029D@smtp.codeaurora.org> (sfid-20160426_113016_928704_6138303C)
Date: Tue, 26 Apr 2016 09:30:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


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
> 
> Fixes: c462ebcdfe42 ('brcmfmac: create common function for handling brcmf_proto_hdrpull()')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Acked-by: Arend van Spriel <arend@broadcom.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
