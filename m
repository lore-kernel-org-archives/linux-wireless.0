Return-Path: <SRS0=d7P/=6H=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B229C2BA19
	for <linux-wireless@archiver.kernel.org>; Thu, 23 Apr 2020 08:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05843208E4
	for <linux-wireless@archiver.kernel.org>; Thu, 23 Apr 2020 08:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgDWIOo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 23 Apr 2020 04:14:44 -0400
Received: from smtprelay0200.hostedemail.com ([216.40.44.200]:47392 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgDWIOo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Apr 2020 04:14:44 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id F3D221801A88C;
        Thu, 23 Apr 2020 08:14:42 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: foot95_6332a6b883714
X-Filterd-Recvd-Size: 2131
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Thu, 23 Apr 2020 08:14:41 +0000 (UTC)
Message-ID: <39759644335be80aa259f20f7cfc6108bd9de363.camel@perches.com>
Subject: Re: [PATCH] ipw2x00: Remove a memory allocation failure log message
From:   Joe Perches <joe@perches.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        stas.yakovlev@gmail.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date:   Thu, 23 Apr 2020 01:12:24 -0700
In-Reply-To: <20200423075825.18206-1-christophe.jaillet@wanadoo.fr>
References: <20200423075825.18206-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2020-04-23 at 09:58 +0200, Christophe JAILLET wrote:
> Axe a memory allocation failure log message. This message is useless and
> incorrect (vmalloc is not used here for the memory allocation)
> 
> This has been like that since the very beginning of this driver in
> commit 43f66a6ce8da ("Add ipw2200 wireless driver.")
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/wireless/intel/ipw2x00/ipw2200.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> index 60b5e08dd6df..30c4f041f565 100644
> --- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> +++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> @@ -3770,10 +3770,9 @@ static int ipw_queue_tx_init(struct ipw_priv *priv,
>  	struct pci_dev *dev = priv->pci_dev;
>  
>  	q->txb = kmalloc_array(count, sizeof(q->txb[0]), GFP_KERNEL);
> -	if (!q->txb) {
> -		IPW_ERROR("vmalloc for auxiliary BD structures failed\n");
> +	if (!q->txb)
>  		return -ENOMEM;
> -	}
> +

This might avoid possible defects by using kcalloc instead too



