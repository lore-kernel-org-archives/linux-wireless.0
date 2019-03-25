Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54623C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 14:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23AD920850
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 14:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbfCYOcB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 10:32:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51088 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbfCYOcB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 10:32:01 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DD5FC2D7E7;
        Mon, 25 Mar 2019 14:32:00 +0000 (UTC)
Received: from localhost (unknown [10.43.2.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 059FD1001E67;
        Mon, 25 Mar 2019 14:31:54 +0000 (UTC)
Date:   Mon, 25 Mar 2019 15:31:52 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: usb: reduce locking in mt76u_tx_tasklet
Message-ID: <20190325143152.GB13884@redhat.com>
References: <cover.1553437543.git.lorenzo@kernel.org>
 <1f489df8bc635660a1d1fb72400e5562504c0555.1553437543.git.lorenzo@kernel.org>
 <20190325125032.GB17956@redhat.com>
 <20190325130035.GA12885@localhost.localdomain>
 <20190325131019.GA19204@redhat.com>
 <20190325134734.GB12885@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190325134734.GB12885@localhost.localdomain>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 25 Mar 2019 14:32:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Mar 25, 2019 at 02:47:35PM +0100, Lorenzo Bianconi wrote:
> > On Mon, Mar 25, 2019 at 02:00:36PM +0100, Lorenzo Bianconi wrote:
> > > > On Sun, Mar 24, 2019 at 03:51:43PM +0100, Lorenzo Bianconi wrote:
> > > > > +		int idx;
> > > > > +
> > > > >  		sq = &dev->q_tx[i];
> > > > >  		q = sq->q;
> > > > >  
> > > > > -		spin_lock_bh(&q->lock);
> > > > > -		while (true) {
> > > > > -			if (!q->entry[q->head].done || !q->queued)
> > > > > +		while (q->queued > n_queued) {
> > > > > +			if (!q->entry[q->head].done)
> > > > >  				break;
> > > > If you place done = false here you will not need additional idx
> > > > variable.
> > > 
> > > As Felix suggested, I would set done to false at the end of the loop, after
> > > tx_complete_skb
> > Why this is needed? 
> 
> logically I think it should be the last thing to do on the current skb but
Why? This is only marker that urb complete was done.

> probably moving it before tx_complete_skb will not make any difference
It will not, since code is performed in the same tasklet.

Stanislaw
