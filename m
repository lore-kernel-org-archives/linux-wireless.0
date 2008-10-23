Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39999 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbYJWJeZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 05:34:25 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 02:34:25 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18688.17545.136327.991699@gargle.gargle.HOWL> (sfid-20081023_113432_369557_8198EFD2)
Date: Thu, 23 Oct 2008 15:01:53 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
Subject: Re: [RFC] mac80211: Re-enable aggregation
In-Reply-To: <1224669612.28639.49.camel@johannes.berg>
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	<1224491480.18024.32.camel@johannes.berg>
	<18684.18492.94865.480736@gargle.gargle.HOWL>
	<1224493957.18024.47.camel@johannes.berg>
	<18684.20459.335157.171344@gargle.gargle.HOWL>
	<1224495531.18024.55.camel@johannes.berg>
	<18684.24323.743610.871307@gargle.gargle.HOWL>
	<1224505349.27899.17.camel@johannes.berg>
	<18684.51206.771543.514682@localhost.localdomain>
	<1224669612.28639.49.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> It seems that should be a rate control decision? Possibly taking into
> account more than just always doing aggregation sessions. Then again, I
> suppose aggregation sessions are cheap. What about latency here?
> 

Well, that is what Luis seems to think too, but our RC
doesn't do much now, so we try to setup an aggregation session with any
associated STA.

> "maintain minimum HW queue depth"? In what way? You mean put in enough
> frames?

I was talking about this:
(txq->axq_depth < ATH_AGGR_MIN_QDEPTH) in ath_tx_sched_aggr()@xmit.c

> > On TX Completion,
> > 
> > * Process all TX queues
> >    * Process all complete descriptors.
> >       * Complete all sub-frames of an aggregate that were ACKed (send status to mac80211).
> >       * Re-queue sub-frames that were not ACKed back to the TID's pending queue.
> >           * Schedule this TID for processing.
> 
> Those have to go in front of the queue, right? So they're sent out next?

Yep, they are spliced back to the beginning of the queue.

> 
> >    * Run through all scheduled TIDs
> >       * Form aggregates from the pending buffers and send them out.
> >         ( Again, maintain minimum HW depth )
> 
> Which TIDs are "scheduled"?

All of the TIDs that have pending buffers.

> > So, aggregation is currently done on a need-to basis, and changing this
> > to a flow where mac80211 sends down frames with A-MPDU related control information
> > would mean a complete rewrite of ath9k's TX path. :-)
> 
> So what? :) I'm trying to avoid having to do all this again and again in
> b43, rt2x00 etc. The hw really behaves very similarly.
> 

Agreed.

> > Well, I really don't know how this would affect performance, but
> > I think this _might_ be a better model.
> 
> Where would you see it have a noticeable effect on performance?

How would mac80211 buffer frames ? Would it wait for enough sub-frames
to fill an A-MPDU ? When does it decide that buffered frames have to
be pushed down to the driver ?

Sujith
