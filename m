Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212Ab2CZMpV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 08:45:21 -0400
Message-ID: <1332765914.5435.7.camel@jlt3.sipsolutions.net> (sfid-20120326_144524_882420_15F405E6)
Subject: Re: [RFC 00/12] multi-channel support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 26 Mar 2012 14:45:14 +0200
In-Reply-To: <4F7060C2.9070206@tieto.com>
References: <06edaf32-5a4f-4887-8b22-6bec31c2c7c6@FIVLA-EXHUB02.eu.tieto.com>
			 (sfid-20120320_154008_038091_B257E507) <1332494945.3506.23.camel@jlt3.sipsolutions.net>
		 <4F6C82A5.5080302@tieto.com>
	 <1332513075.10384.20.camel@jlt3.sipsolutions.net>
	 <4F7060C2.9070206@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > I'm not sure we can easily use such a "stream" for off-channel
> > operation. In particular, that "stream" might not support multiple
> > queues.
> 
> Does it need to? It could as well just map all queues to a single hw 
> queue with this design. I'm not sure if I get your point here.
> 
> 
> Is it okay for us to not care if the driver supports real queues for 
> ACs? Should we care if a driver maps all ACs from a channel context (or 
> vif for that matter) onto a single hw queue? I'm wondering whether that 
> would simplify code paths?

Well, ok, that would be possible, but I'm not sure I see the point in
using a stream for off-channel. Today, we completely offload off-channel
to the device, and I don't see how that could change? Having temporary
context allocations all the time seems like a lot of thrash?

> >>     struct ieee80211_queue_types { // or tx_queue_types?
> >>       IEEE80211_QUEUE_VO,
> >>       IEEE80211_QUEUE_VI,
> >>       IEEE80211_QUEUE_BE,
> >>       IEEE80211_QUEUE_BK,
> >>       IEEE80211_QUEUE_CAB,
> >>
> >>       IEEE80211_QUEUE_LAST
> >>     };
> > [...]
> >> This looks kind of ugly, but oh well. This way the driver will be able
> >> to setup mapping between mac80211 and internal device queues. It should
> >> also be possible to map one hardware queue to multiple
> >> ieee80211_channel_stream structures (queues is a list of pointers) so
> >> multiple vifs on the same channel is okay.
> >
> > I don't think this makes a lot of sense, tbh. This isn't a separate AC,
> > I'd rather keep them separated.
> 
> You mean the CAB queue separated from ACs?

Yeah. I don't see CAB as a separate AC. It's just a separate queue.


> > I'm looking at the code right now, and I think we should treat ACs,
> > queues and channels separately. If we combine queue sets&  channels into
> > one, I think we'll find drivers that don't work correctly with this.
> > Some devices for instance might have a set of queues for each interface,
> > even if they're on the same channel. I don't want to lose flexibility to
> > handle that.
> 
> You mean a driver that can handle two vifs simultaneously but on the 
> same channel and have two separate queue sets for that?

Yes, that's a possibility we have to consider, I think our device might
end up behaving like that.

> Then we need to move queues to ieee80211_vif and create callbacks to 
> bind channels contexts with a vif (just you mentioned that in other email).

Right.


> > struct ieee80211_hw {
> > 	...
> > 	u8 offchannel_queue;
> > };
> >
> > struct ieee80211_vif {
> > 	...
> > 	u8 hw_queue[IEEE80211_NUM_ACS];
> > 	u8 after_dtim_queue;
> > };
> >
> > For any of these (offchannel_queue, after_dtim_queue, hw_queue[i]), the
> > queue number Q must be 0<= Q<  hw.queues. This allows us to keep all
> > per-hw-queue state "flattened" in ieee80211_local's pending,
> > queue_stop_reasons, etc. instead of separating all of it out into
> > separate structures.
> 
> So you want "offchannel_queue", "hw_queue[]" and "after_dtim_queue" to 
> point to driver/device hw queue id?

The driver is free to point it to anything it want, but typically it
would point it to the real HW queue ID -- this would be the same ID it
has to give to ieee80211_stop_queue()/wake_queue() as well.


> > When a queue is stopped, we do:
> >
> > void queue_stop(int q)
> > {
> > 	for_each_interface(vif) {
> > 		if (vif->hw_queue[AC] == q) // for all 4 ACs
> > 			stop netdev queue (vif->dev, AC)
> > 		if (vif->after_dtim_queue == q)
> > 			stop_all_queues(vif->dev)
> > 	}
> > }
> >
> > Or so ... after_dtim_queue is kinda a special case.
> 
> Oh, I see. So stopping CAB would be like "stop all the things".

CAB is really special -- not sure what the best thing here is. But
technically frames from any AC can be multicast so I suppose this is the
best way to handle it after all. I wouldn't really worry too much about
CAB though :)


> But how do we then check if we need to stop given queue or not? Let's 
> say a driver stops q=2 which corresponds to BE on vif0 and vif1. But 
> then comes mac80211 aggregation and stops BE on vif0. I can only think 
> of a single solution to that: "u8 lock_reasons[256];" in ieee80211_local 
> but it seems like an overkill or is it not?

Essentially that's what I was considering, we'd maintain all the queue
state per HW queue ID. I said it would be a u8 for the HW queue ID, but
I don't see anyone using more than say 32 or so, so we wouldn't really
need 256. But we could go up to 256 if needed (though at that point we
should probably do dynamic allocation instead.)


johannes

