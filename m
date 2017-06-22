Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57742 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752563AbdFVIsb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 04:48:31 -0400
Message-ID: <1498121308.2246.5.camel@sipsolutions.net> (sfid-20170622_104835_466630_4884114B)
Subject: Re: [RFC 5/6] mac80211: add a general fallback TXQ
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name
Date: Thu, 22 Jun 2017 10:48:28 +0200
In-Reply-To: <20170621235022.25362-5-johannes@sipsolutions.net> (sfid-20170622_015033_568541_05A27CAD)
References: <20170621235022.25362-1-johannes@sipsolutions.net>
         <20170621235022.25362-5-johannes@sipsolutions.net>
         (sfid-20170622_015033_568541_05A27CAD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-06-22 at 01:50 +0200, Johannes Berg wrote:

> In a number of cases, like management frames, mac80211 will not
> put the frame on any TXQ but immediately TX it to the driver.
> It'd be nicer to be able to use TXQs for all frames, so add a
> "fallback" TXQ. This will serve as a container to be able to
> remove all the non-TXQ queueing in mac80211.

This patch is completely broken right now.

When TXQs are enabled, there's still buffering of frames that are *not*
marked with IEEE80211_TX_INTFL_OFFCHAN_TX_OK, and that happens on the
ieee80211_tx_frags() path, using the queue_stop_reasons etc. In fact,
even the drivers can still ask to buffer such frames by stopping their
queues...

I want to move all of that over to the TXQs instead, so that we can get
rid of that buffering logic.

The way to do that would be to not return any frames from TXQs when
they're in off-channel state (and drivers can also stop scheduling the
queues in those cases).

However, if *everything* moves to TXQs, that means we need another TXQ
for those frames that are marked with IEEE80211_TX_INTFL_OFFCHAN_TX_OK,
so that they can go out at any time.

So I think the solution is to add *two* new TXQs in this patch, one for
on-channel frames and one for off-channel frames.

But that's also awkward when you take into account channel contexts,
since all those frames might still need to go to different ones.

Perhaps then the better solution would be to have a TXQ per channel
context, and one for more the remaining frames that. Yeah, this feels
slightly odd - why bother putting frames on a TXQ that shouldn't really
be buffered - but it fits better with the model (the hybrid push/pull
model we have now is somewhat awkward), and there are other reasons
than being off-channel to buffer frames, e.g. if the driver queue got
full, or the driver is doing something else where it can't easily
handle data frames etc.

Thoughts, anyone?

johannes
