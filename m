Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF589C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 11:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F6542083D
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 11:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbfB1LqC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 06:46:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56920 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfB1LqC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 06:46:02 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2E3D630A0515;
        Thu, 28 Feb 2019 11:46:02 +0000 (UTC)
Received: from localhost (unknown [10.43.2.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C938760F94;
        Thu, 28 Feb 2019 11:45:57 +0000 (UTC)
Date:   Thu, 28 Feb 2019 12:45:52 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH] mt76: introduce q->stopped parameter
Message-ID: <20190228114551.GB6072@redhat.com>
References: <cover.1551301983.git.lorenzo@kernel.org>
 <ec189b4ec030646d4dbfd0b7c41944ab383edc4e.1551301983.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec189b4ec030646d4dbfd0b7c41944ab383edc4e.1551301983.git.lorenzo@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 28 Feb 2019 11:46:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Feb 27, 2019 at 10:40:41PM +0100, Lorenzo Bianconi wrote:
> @@ -289,9 +290,14 @@ mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
>  	dev->queue_ops->tx_queue_skb(dev, q, skb, wcid, sta);
>  	dev->queue_ops->kick(dev, q);
>  
> -	if (q->queued > q->ndesc - 8)
> -		ieee80211_stop_queue(dev->hw, skb_get_queue_mapping(skb));
> +	stop = q->queued > q->ndesc - 8 && !q->stopped;
> +	if (stop)
> +		q->stopped = true;
> +
>  	spin_unlock_bh(&q->lock);
> +
> +	if (stop)
> +		ieee80211_stop_queue(dev->hw, skb_get_queue_mapping(skb));

I don't think taking this outside of spin_lock section is beneficial.
Actually is better to do this faster than slower to prevent enqueue
frames by mac80211 and then dropped them due to lack of space in
mt76 queue.

Stanislaw
