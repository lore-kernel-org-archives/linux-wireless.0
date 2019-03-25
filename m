Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68488C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 13:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40C8C20830
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 13:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731292AbfCYNKZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 09:10:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57684 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731200AbfCYNKY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 09:10:24 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D5CB0C04BD35;
        Mon, 25 Mar 2019 13:10:24 +0000 (UTC)
Received: from localhost (unknown [10.43.2.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CC6C80952;
        Mon, 25 Mar 2019 13:10:22 +0000 (UTC)
Date:   Mon, 25 Mar 2019 14:10:20 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: usb: reduce locking in mt76u_tx_tasklet
Message-ID: <20190325131019.GA19204@redhat.com>
References: <cover.1553437543.git.lorenzo@kernel.org>
 <1f489df8bc635660a1d1fb72400e5562504c0555.1553437543.git.lorenzo@kernel.org>
 <20190325125032.GB17956@redhat.com>
 <20190325130035.GA12885@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190325130035.GA12885@localhost.localdomain>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 25 Mar 2019 13:10:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Mar 25, 2019 at 02:00:36PM +0100, Lorenzo Bianconi wrote:
> > On Sun, Mar 24, 2019 at 03:51:43PM +0100, Lorenzo Bianconi wrote:
> > > +		int idx;
> > > +
> > >  		sq = &dev->q_tx[i];
> > >  		q = sq->q;
> > >  
> > > -		spin_lock_bh(&q->lock);
> > > -		while (true) {
> > > -			if (!q->entry[q->head].done || !q->queued)
> > > +		while (q->queued > n_queued) {
> > > +			if (!q->entry[q->head].done)
> > >  				break;
> > If you place done = false here you will not need additional idx
> > variable.
> 
> As Felix suggested, I would set done to false at the end of the loop, after
> tx_complete_skb
Why this is needed? 

> > >  			dev->drv->tx_complete_skb(dev, i, &entry);
> > > -			spin_lock_bh(&q->lock);
> > > +			q->entry[idx].done = false;
> > >  		}
> > >  
> > > +		spin_lock_bh(&q->lock);
> > This patch does not apply for me as there is missing
> > mt76_txq_schedule(dev, sq);
> 
> Sorry I forgot to mention this patch is based on
> https://patchwork.kernel.org/patch/10856027/. Have you applied it?
No.

Stanislaw

