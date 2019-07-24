Return-Path: <SRS0=rB3s=VV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB45C7618F
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Jul 2019 11:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8082522387
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Jul 2019 11:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfGXLDv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Jul 2019 07:03:51 -0400
Received: from smtprelay0228.hostedemail.com ([216.40.44.228]:52747 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726070AbfGXLDv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jul 2019 07:03:51 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id A888718037D48;
        Wed, 24 Jul 2019 11:03:49 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: tax54_21268d0501225
X-Filterd-Recvd-Size: 2072
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Wed, 24 Jul 2019 11:03:47 +0000 (UTC)
Message-ID: <54692f19e845a74650c1d24cbe7b79c5dad7b061.camel@perches.com>
Subject: Re: [PATCH v1 5/6] mt76: fix some checkpatch warnings
From:   Joe Perches <joe@perches.com>
To:     Ryder Lee <ryder.lee@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Roy Luo <royluo@google.com>, YF Luo <yf.luo@mediatek.com>,
        Yiwei Chung <yiwei.chung@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 24 Jul 2019 04:03:46 -0700
In-Reply-To: <0afa87cc70b34ee17d6c2247dfc8dac92c36852f.1563944758.git.ryder.lee@mediatek.com>
References: <cover.1563944758.git.ryder.lee@mediatek.com>
         <0afa87cc70b34ee17d6c2247dfc8dac92c36852f.1563944758.git.ryder.lee@mediatek.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-07-24 at 16:58 +0800, Ryder Lee wrote:
> This fixes the following checkpatch warnings:
[]
> diff --git a/drivers/net/wireless/mediatek/mt76/agg-rx.c b/drivers/net/wireless/mediatek/mt76/agg-rx.c
[]
> @@ -74,15 +75,14 @@ mt76_rx_aggr_check_release(struct mt76_rx_tid *tid, struct sk_buff_head *frames)
>  	for (idx = (tid->head + 1) % tid->size;
>  	     idx != start && nframes;
>  	     idx = (idx + 1) % tid->size) {
> -
>  		skb = tid->reorder_buf[idx];
>  		if (!skb)
>  			continue;
>  
>  		nframes--;
> -		status = (struct mt76_rx_status *) skb->cb;
> +		status = (struct mt76_rx_status *)skb->cb;
>  		if (!time_after(jiffies, status->reorder_time +
> -					 REORDER_TIMEOUT))
> +				REORDER_TIMEOUT))

trivia/bikeshedding:  perhaps better slightly differently:

 		if (!time_after(jiffies,
				status->reorder_time + REORDER_TIMEOUT))


