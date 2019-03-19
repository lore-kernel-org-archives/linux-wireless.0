Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E31C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 16:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E86C2085A
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 16:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfCSQEl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 12:04:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35134 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726612AbfCSQEl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 12:04:41 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D9134307C940;
        Tue, 19 Mar 2019 16:04:40 +0000 (UTC)
Received: from localhost (ovpn-204-101.brq.redhat.com [10.40.204.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FB1E28991;
        Tue, 19 Mar 2019 16:04:29 +0000 (UTC)
Date:   Tue, 19 Mar 2019 17:04:27 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC] mt76: usb: reduce locking in mt76u_tx_tasklet
Message-ID: <20190319160426.GA15616@redhat.com>
References: <cover.1552907276.git.lorenzo@kernel.org>
 <1ee5ce7818f9d45c9713ce99e810cb84f50dcf03.1552907276.git.lorenzo@kernel.org>
 <20190319110708.GA5360@redhat.com>
 <20190319125812.GA21821@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319125812.GA21821@localhost.localdomain>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 19 Mar 2019 16:04:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Mar 19, 2019 at 01:58:13PM +0100, Lorenzo Bianconi wrote:
> > On Mon, Mar 18, 2019 at 12:09:32PM +0100, Lorenzo Bianconi wrote:
> > > Similar to pci counterpart, reduce locking in mt76u_tx_tasklet since
> > > q->head is managed just in mt76u_tx_tasklet and q->queued is updated
> > > holding q->lock
> > > 
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  drivers/net/wireless/mediatek/mt76/usb.c | 18 +++++++++++-------
> > >  1 file changed, 11 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
> > > index ac03acdae279..8cd70c32d77a 100644
> > > --- a/drivers/net/wireless/mediatek/mt76/usb.c
> > > +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> > > @@ -634,29 +634,33 @@ static void mt76u_tx_tasklet(unsigned long data)
> > >  	int i;
> > >  
> > >  	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
> > > +		u32 n_queued = 0, n_sw_queued = 0;
> > > +
> > >  		sq = &dev->q_tx[i];
> > >  		q = sq->q;
> > >  
> > > -		spin_lock_bh(&q->lock);
> > > -		while (true) {
> > > +		while (q->queued > n_queued) {
> > >  			buf = &q->entry[q->head].ubuf;
> > > -			if (!buf->done || !q->queued)
> > > +			if (!buf->done)
> > >  				break;
> > 
> > I'm still thinking if this is safe or not. Is somewhat tricky to
> > read variable outside the lock because in such case there is no time
> > guarantee when variable written on one CPU gets updated value on
> > different CPU. And for USB is not only q->queued but also buf->done.
> 
> Hi Stanislaw,
> 
> I was wondering if this is safe as well, but q->queued is updated holding q->lock
> and I guess it will ensure to not overlap tx and status code path.

Overlap will not happen, at worst what can happen is q->queued will be
smaller on tx_tasklet than on tx_queue_skb.

> Regarding buf->done, it is already updated without holding the lock in mt76u_complete_tx

That's actually a bug, but it's not important, if tx_tasklet will not
see updated buf->done <- true value by mt76u_complete_tx on different
cpu, it will not complete skb. It will be done on next tx_tasklet iteration.
Worse thing would be opposite situation.

Stanislaw
