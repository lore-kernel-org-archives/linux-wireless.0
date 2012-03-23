Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51441 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab2CWObQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 10:31:16 -0400
Message-ID: <1332513075.10384.20.camel@jlt3.sipsolutions.net> (sfid-20120323_153121_035803_CEE29FE5)
Subject: Re: [RFC 00/12] multi-channel support
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Micha=C5=82?= Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 23 Mar 2012 15:31:15 +0100
In-Reply-To: <4F6C82A5.5080302@tieto.com>
References: <06edaf32-5a4f-4887-8b22-6bec31c2c7c6@FIVLA-EXHUB02.eu.tieto.com>
		 (sfid-20120320_154008_038091_B257E507) <1332494945.3506.23.camel@jlt3.sipsolutions.net>
	 <4F6C82A5.5080302@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-23 at 15:03 +0100, Michał Kazior wrote:
> > So I took a closer look at this now.
> >
> > I think we should probably apply the first two patches now, and the
> > third with changes. After that, I'm not so sure.
> 
> You mean the following, right?
> 
>           mac80211: prepare ieee80211_mandatory_rates to per-vif
>           mac80211: prepare ieee80211_sta_get_rates to per-vif
> [tofix]  mac80211: prepare ieee80211_frame_duration to per-vif
> 
> Should I resend them all, or just the 3rd one once I fix it?

You should probably send them as [PATCH].


> > Overall, I think the approach isn't sufficient. At the very least, the
> > (unstated!) assumption that one channel per interface can always be done
> > is bad. Modifying this with the structure you gave it though seems to be
> > problematic.
> >
> > We should also handle the queue mapping first I think. This isn't a
> > feature you can implement overnight :-)
> 
> I've been thinking more on queue handling in multi-channel. Here are my 
> thoughts.

Did you see my previous mail?
http://mid.gmane.org/1330343374.3483.46.camel@jlt3.sipsolutions.net


> If we assume that off-channel should be a global thing then we should 
> rethink the whole queue thing first.

I think we need to rethink the queues first even if off-channel isn't
global -- right now you can only stop a given AC across all interfaces
but that's really not what you want if you're on multiple channels...


> What if we create a new structure that would be a channel 
> stream/reservation? Driver could then report multiple such objects. Each 
> such would have a tx queue and it's own locking. Let's assume something 
> like:
> 
>    struct ieee80211_channel_stream {
>      struct list_head vif; // list of vifs we're attached to
>      struct ieee80211_channel *ch;
>      struct sk_buff_head pending;
>      int stop_reasons[IEEE80211_MAX_QUEUES];
>      // .. other stuff
>      u8 *drv_priv[0] __attribute__((__aligned__((void *))));
>    };
> 
>    struct ieee80211_vif {
>      struct ieee80211_channel_stream *channel_stream;
>      // .. rest of struct
>    };
> 
>   * We could then reject set_channel() based on number of different
>     oper_channels and channel reservations
>   * We could handle off-channel through a channel reservation by either
>     using an unused one (which would result in hardware offloaded
>     off-channel) or we would lock&flush it, switch to off-channel, do
>     work, and get back

I'm not sure we can easily use such a "stream" for off-channel
operation. In particular, that "stream" might not support multiple
queues.

> We should however consider that a device may not support certain 
> interface combinations. One thing that comes immediately to my mind is 
> the following: suppose we support STA+STA on different channels, AP+AP 
> on the same channel, but do not support AP+AP on different channels:
> 
>    1. create wlan0, set channel=1, and start AP
>    2. create wlan1, set channel=1, and start AP
>    3. do set_channel(wlan1, 3) <-- oops
> 
> This would probably be fixed easily with:
> 
>    1. forbid changing channels on a running interface (i'm aware that's
>       the same case for mac addr)
>    2. thus we would require: ifdown + setchannel + ifup
> 
> But that's just one case. Are there any others? This needs investigation.

So my interface combinations advertising already supports
"num_different_channels" per combination, so that would be easy to
express. Switching the channel while the AP interface is up is probably
not desirable anyway.

The biggest challenge here is CSA functionality I think.


> Other issue I'm thinking would be: what if a device supports specialized 
> off-channel queue (is there one we know? iwlwifi?) ? 

Yeah we do have this.

> We can't advertise 
> this as a fully-usable ieee80211_channel_stream (again, is there 
> anything that has a shortcoming like that?). 

Yup.

> Should we add capability 
> flags for each ieee80211_channel_stream? Or we could add new driver 
> callback, eg. "set_channel_try" and allow the driver to decide whether 
> it allows a certain hardware state or not.

This is not a fully feasible "stream" anyway. Think of it more like a
single scan dwell -- you wouldn't express that as a separate "stream" I
think?

> What is still missing here is the CAB queue (and possible other that may 
> come up in the future) you mentioned in the other thread. 

Ah, I see you did see my other thread :-)

> I'm not sure 
> whether we may use queue_mapping for our own evil purposes here. If not, 
> then how about this:
> 
>    struct ieee80211_queue_types { // or tx_queue_types?
>      IEEE80211_QUEUE_VO,
>      IEEE80211_QUEUE_VI,
>      IEEE80211_QUEUE_BE,
>      IEEE80211_QUEUE_BK,
>      IEEE80211_QUEUE_CAB,
> 
>      IEEE80211_QUEUE_LAST
>    };
[...]
> This looks kind of ugly, but oh well. This way the driver will be able 
> to setup mapping between mac80211 and internal device queues. It should 
> also be possible to map one hardware queue to multiple 
> ieee80211_channel_stream structures (queues is a list of pointers) so 
> multiple vifs on the same channel is okay.

I don't think this makes a lot of sense, tbh. This isn't a separate AC,
I'd rather keep them separated.

> What are your thoughts on this? Is this terribly wrong or is it the way 
> to go? Have I missed something?

I think that this is all a bit overkill :)

I'm looking at the code right now, and I think we should treat ACs,
queues and channels separately. If we combine queue sets & channels into
one, I think we'll find drivers that don't work correctly with this.
Some devices for instance might have a set of queues for each interface,
even if they're on the same channel. I don't want to lose flexibility to
handle that.

I think we'd hold the AC in skb_queue_mapping, since that's assigned
early in the virtual interface queues already, and we need it to be the
AC there for proper queue selection.

The hardware queue we can put into a separate field in tx_info, I've
made space for a u8 for this in a patch I have pending (but not sent to
the list yet.)

Ignoring the monitor mode interface, I think the simplest thing we can
do is

struct ieee80211_hw {
	...
	u8 offchannel_queue;
};

struct ieee80211_vif {
	...
	u8 hw_queue[IEEE80211_NUM_ACS];
	u8 after_dtim_queue;
};

For any of these (offchannel_queue, after_dtim_queue, hw_queue[i]), the
queue number Q must be 0 <= Q < hw.queues. This allows us to keep all
per-hw-queue state "flattened" in ieee80211_local's pending,
queue_stop_reasons, etc. instead of separating all of it out into
separate structures.

When a queue is stopped, we do:

void queue_stop(int q)
{
	for_each_interface(vif) {
		if (vif->hw_queue[AC] == q) // for all 4 ACs
			stop netdev queue (vif->dev, AC)
		if (vif->after_dtim_queue == q)
			stop_all_queues(vif->dev)
	}
}

Or so ... after_dtim_queue is kinda a special case.


If offchannel_queue is stopped, we'll have to refuse offchannel TX from
nl80211 -- that seems *very* unlikely though.


Do you think this would work?

I think that covers the queue part -- I'll split the thread and will
talk about multi-channel in a separate email.


johannes

