Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F55C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 19:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 247042087E
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 19:45:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 247042087E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732776AbeKXGbi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 24 Nov 2018 01:31:38 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:53650 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729872AbeKXGbi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Nov 2018 01:31:38 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gQHOl-00047U-Lh; Fri, 23 Nov 2018 20:45:55 +0100
Message-ID: <3e8017792ea5eaa63f7795d9d37e7dcf85cdc612.camel@sipsolutions.net>
Subject: Re: rt2800 tx frame dropping issue.
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Daniel Santos <daniel.santos@pobox.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
Date:   Fri, 23 Nov 2018 20:45:54 +0100
In-Reply-To: <bc0bc5ea-dd10-a5a5-87ff-00a93bcf814c@pobox.com> (sfid-20181120_222138_372708_BE6DFB8B)
References: <bc0bc5ea-dd10-a5a5-87ff-00a93bcf814c@pobox.com>
         (sfid-20181120_222138_372708_BE6DFB8B)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-11-20 at 15:20 -0600, Daniel Santos wrote:

> I believe I have the answer as to why we're getting frames after we stop
> the queue.  I had a little chat about this in #kernelnewbies and some
> other devs believe it is intentional.
> 
> There is a race in ieee80211_tx_frags (net/mac80211/tx.c) between
> releasing local->queue_stop_reason_lock and calling the driver's tx
> until we lock queue->tx_lock in rt2x00queue_write_tx_frame -- in between
> these two points the thread can be preempted.  So while we stop the
> queue in one thread, there can be 20 other threads in between that have
> already checked that the queue was running and have a frame buffer
> sitting on their stacks.

Not 20, only 1 per netdev queue. I suspect that means just 1 per
hardware queue, but I don't know how rt2x00 maps netdev queues to
hardware queues. If you have lots of netdevs, that might actually be 20,
but I suspect that's not what's going on here.

>   I think it could be fixed with the below
> patch, but I'm being told that it doesn't need it and that the driver
> should just *quietly* drop the frame:

[snip patch]

> Could anybody illuminate for me why this isn't done?  I know that there
> has to be a point where we realize there are too many items in the queue
> and we can't keep up, but this would seem to be a terrible way to do
> that.  Is it one of those things where it isn't worth the performance
> degradation?  Any insights would be most appreciated!! :)

There's just not much point, and doing the locking here will mean it's
across _all_ queues, whereas if you have multiple hardware queues you
wouldn't really need it.

Note that with internal TXQs with fq/codel support etc. we actually have
the fq->lock and it's global, and it turns out that's still a better
deal than actually doing parallel TX. So this may not matter so much.

In any case, while this might solve the problem for the specific case
you're thinking about, as soon as you have something else starting or
stopping queues from outside the TX path it still wouldn't actually
help.

By the way, one thing that can likely exacerbate the problem is
fragmentation, once you have that you're more likely to trigger lots of
frames in close succession.

What I would suggest doing in the driver is actually stop the queues
once a *threshold* is reached, rather than being full. Say if you have
128 entries in the HW queue, you can stop once you reach 120 (you
probably don't really need the other 8 places). If you get a 121st
frame, then you can still put it on the queue (until you filled 128),
but you can also stop the queue again (stopping queues is idempotent).

johannes

