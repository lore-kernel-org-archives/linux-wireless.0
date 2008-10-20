Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.186]:12848 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbYJTSGZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 14:06:25 -0400
Received: by ti-out-0910.google.com with SMTP id b6so887078tic.23
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 11:06:21 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18684.51206.771543.514682@localhost.localdomain> (sfid-20081020_200630_331084_88EB8FD4)
Date: Mon, 20 Oct 2008 23:33:50 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sujith <Sujith.Manoharan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
Subject: Re: [RFC] mac80211: Re-enable aggregation
In-Reply-To: <1224505349.27899.17.camel@johannes.berg>
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	<1224491480.18024.32.camel@johannes.berg>
	<18684.18492.94865.480736@gargle.gargle.HOWL>
	<1224493957.18024.47.camel@johannes.berg>
	<18684.20459.335157.171344@gargle.gargle.HOWL>
	<1224495531.18024.55.camel@johannes.berg>
	<18684.24323.743610.871307@gargle.gargle.HOWL>
	<1224505349.27899.17.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> > Probably because 11n aggregation have more rigorous timing requirements
> > between frames.
> 
> What kind? I can only find the ampdu spacing/length exponent stuff.
> 

I am not sure, either.

> > > I guess there's no clear answer here. How about "whichever you want"?
> > > Though I think I prefer pushing them down as that makes the model easier
> > > to understand. It probably also makes the Intel case easier to
> > > implement.
> > 
> > A way to pull down buffered frames for each TID (like ieee80211_get_buffered_bc() )
> > would be really useful for ath9k.
> 
> I'm not sure, that seems like a useful thing initially, but leaves a lot
> of stuff for the driver. We should probably think about moving more
> things *up* into mac80211 rather than giving the driver more access to
> low-level details. This would also allow us possibly even send A-MPDU
> mcast when acting as an HT AP, something the driver cannot easily do.
> 
> Can you explain the way it currently works in ath9k?
> 

Alright, it goes something like this:

* mac80211 sends down a frame
   * Initiate an aggregation session for the <RA,TID> if one isn't already in progress.
   * Pause the TID, i.e, add further frames to the TID's queue.
      * If ADDBA exchange is successful, resume TID.
         * Form aggregates from the TID's buffer list, send them out.
           ( Take care to maintain minimum HW queue depth for aggregation )
      * If ADDBA exchange fails, flush TID.
         * Send TID's pending frames as normal frames (non-ampdu)

Now, assuming we have a successful aggregation session going,
frame handling looks like this:

* mac80211 sends down a frame
   * Append to TID's buffer list.

On TX Completion,

* Process all TX queues
   * Process all complete descriptors.
      * Complete all sub-frames of an aggregate that were ACKed (send status to mac80211).
      * Re-queue sub-frames that were not ACKed back to the TID's pending queue.
          * Schedule this TID for processing.
   * Run through all scheduled TIDs
      * Form aggregates from the pending buffers and send them out.
        ( Again, maintain minimum HW depth )

So, aggregation is currently done on a need-to basis, and changing this
to a flow where mac80211 sends down frames with A-MPDU related control information
would mean a complete rewrite of ath9k's TX path. :-)

> Also, I'm trying to understand the relation between a block-ack
> agreement and A-MDPU, I understand that without a block-ack-agreement
> aggregation isn't very useful, but could we not, for example, implement
> (regular) delayed block-ack with much the same infrastructure?
> 

Immediate Block-Ack is mandatory for 11n, delayed BA is optional.
ath9k currently maintains the BA window state internally too.
Another candidate that can be moved to mac80211, IMO.

> What I could also imagine is that mac80211 simply does pretty much
> everything and hands a number of skbs to the driver at once with some
> additional information about how to aggregate them, what sort of spacing
> to use, etc. It should be able to calculate all the required stuff since
> it knows from the rate control algorithm what's happening there. That
> might leave Intel out a bit, but I'm starting to think that we want to
> special-case them a bit anyway.

Well, I really don't know how this would affect performance, but
I think this _might_ be a better model.

Sujith
