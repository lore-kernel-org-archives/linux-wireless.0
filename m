Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44626 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab1CNQYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 12:24:11 -0400
Subject: Re: bug: iwlwifi, aggregation, and mac80211's reorder buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=taszKd9-kyijN100oEegnFi=0u5L4WCp7R_sJ@mail.gmail.com>
References: <AANLkTi=taszKd9-kyijN100oEegnFi=0u5L4WCp7R_sJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Mar 2011 17:24:02 +0100
Message-ID: <1300119843.3802.21.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-03-11 at 00:11 -0800, Daniel Halperin wrote:

> One thing that Intel does that ath9k does not is transmit packets out
> of sequence number order inside a batch.  (This is legal in the 802.11
> standard).

Even if that's legal it seems very strange? Do you have packet captures
of this by any chance?

> I figured that one explanation for the TCP SACKs would be
> if, somehow, frames got released to the network stack out of order;
> indeed, many of the "holes" covered by the SACKs are filled quickly
> (within ~4ms, about the length of one aggregation batch).  Note that
> iwlwifi defaults to an aggregation frame limit, hence buffer size, of
> 31 frames.  mac80211 honors this buffer size specification by
> releasing frames to the network stack that are >= 31 sequence numbers
> below the highest received frame.
> 
> It looks like Intel doesn't honor its own frame limit, as I often saw
> it have more than 31 frames outstanding, causing mac80211 on the
> receiver to release many frames early.  Changing iwlwifi's default agg
> limit to 63 frames on both ends dramatically reduced the prevalence of
> SACKs/TCP retransmissions and improved avg TCP performance to ~100
> Mbps (ranging 83-110).

Great ... what if you just change the mac80211 code like you suggested?
Does that already help, by making the receiver have a larger window?

> (1) Why does iwlwifi default to an aggregation frame limit of 31? I
> didn't see any negative effects from 63 frame limit and performance
> improved dramatically

Wey-Yi answered this fully afaik.

> (2) Is there a way to make iwlwifi honor the aggregation limit?  I
> know that agg is controlled by a hardware scheduler, so this may be
> difficult.

Heh. I'd hope it already does but I guess if it doesn't then there's
little we can do (but internally report a bug). This is actually not
just a throughput problem, but also a correctness issue, since some
devices do not allow for receiving long aggregates!

> (3) mac80211's reorder buffer code could probably also be relaxed.  It
> probably wouldn't hurt to have the buffer be twice the transmitter's
> advertised buffer, and might compensate for devices that don't
> properly honor frame limits.

Well, it doesn't make sense to go above 64, no? Can't have reordering
across aggregates.

> Also, mac80211 only flushes the reorder
> buffer every 100 ms.  That seems like a LONG time given that batches
> are limited to 4ms -- 100ms is room for at least 10, maybe 20
> retransmissions to attempt to fill in the holes(!).

Yeah that's true, but you don't really know how much time there is
between retries, bluetooth for example might block the retransmission
for quite a while.

> (4) even after this fix, I see a few SACKs, and even when there aren't
> SACKs I still see TCP "dead time" up to ~100ms.  What else would you
> use to debug this setup?

What's "after this fix"?

johannes


