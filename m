Return-Path: <SRS0=hJv2=OF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E0A8C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 09:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5539320850
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 09:38:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5539320850
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbeKZUcG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 26 Nov 2018 15:32:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60756 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbeKZUcG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Nov 2018 15:32:06 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A84DE3082A24;
        Mon, 26 Nov 2018 09:38:33 +0000 (UTC)
Received: from localhost (unknown [10.43.2.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40E5460BE8;
        Mon, 26 Nov 2018 09:38:32 +0000 (UTC)
Date:   Mon, 26 Nov 2018 10:38:27 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Daniel Santos <daniel.santos@pobox.com>,
        linux-wireless@vger.kernel.org
Subject: Re: rt2800 tx frame dropping issue.
Message-ID: <20181126093826.GB2047@redhat.com>
References: <bc0bc5ea-dd10-a5a5-87ff-00a93bcf814c@pobox.com>
 <3e8017792ea5eaa63f7795d9d37e7dcf85cdc612.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e8017792ea5eaa63f7795d9d37e7dcf85cdc612.camel@sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 26 Nov 2018 09:38:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Nov 23, 2018 at 08:45:54PM +0100, Johannes Berg wrote:
> On Tue, 2018-11-20 at 15:20 -0600, Daniel Santos wrote:
> 
> > I believe I have the answer as to why we're getting frames after we stop
> > the queue.  I had a little chat about this in #kernelnewbies and some
> > other devs believe it is intentional.
> > 
> > There is a race in ieee80211_tx_frags (net/mac80211/tx.c) between
> > releasing local->queue_stop_reason_lock and calling the driver's tx
> > until we lock queue->tx_lock in rt2x00queue_write_tx_frame -- in between
> > these two points the thread can be preempted.  So while we stop the
> > queue in one thread, there can be 20 other threads in between that have
> > already checked that the queue was running and have a frame buffer
> > sitting on their stacks.
> 
> Not 20, only 1 per netdev queue. I suspect that means just 1 per
> hardware queue, but I don't know how rt2x00 maps netdev queues to
> hardware queues. If you have lots of netdevs, that might actually be 20,
> but I suspect that's not what's going on here.
> 
> >   I think it could be fixed with the below
> > patch, but I'm being told that it doesn't need it and that the driver
> > should just *quietly* drop the frame:
> 
> [snip patch]
> 
> > Could anybody illuminate for me why this isn't done?  I know that there
> > has to be a point where we realize there are too many items in the queue
> > and we can't keep up, but this would seem to be a terrible way to do
> > that.  Is it one of those things where it isn't worth the performance
> > degradation?  Any insights would be most appreciated!! :)
> 
> There's just not much point, and doing the locking here will mean it's
> across _all_ queues, whereas if you have multiple hardware queues you
> wouldn't really need it.
> 
> Note that with internal TXQs with fq/codel support etc. we actually have
> the fq->lock and it's global, and it turns out that's still a better
> deal than actually doing parallel TX. So this may not matter so much.
> 
> In any case, while this might solve the problem for the specific case
> you're thinking about, as soon as you have something else starting or
> stopping queues from outside the TX path it still wouldn't actually
> help.
> 
> By the way, one thing that can likely exacerbate the problem is
> fragmentation, once you have that you're more likely to trigger lots of
> frames in close succession.
> 
> What I would suggest doing in the driver is actually stop the queues
> once a *threshold* is reached, rather than being full. Say if you have
> 128 entries in the HW queue, you can stop once you reach 120 (you
> probably don't really need the other 8 places). If you get a 121st
> frame, then you can still put it on the queue (until you filled 128),
> but you can also stop the queue again (stopping queues is idempotent).

That what rt2x00 does, but we have 64 entries on tx queues and
because of that threshold is small. In:

https://bugzilla.kernel.org/show_bug.cgi?id=82751

I proposed increase of queue size to 256 and hence make threshold
bigger. However I was concerned about bufferbloat and requested
testing from users how this affect latency. Never get testing 
results :-(

Thanks
Stanislaw
