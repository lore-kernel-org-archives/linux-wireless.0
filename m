Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:58045 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab2CZM1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 08:27:50 -0400
Message-ID: <4F7060C2.9070206@tieto.com> (sfid-20120326_142754_035748_6DF3E3D9)
Date: Mon, 26 Mar 2012 14:27:46 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 00/12] multi-channel support
References: <06edaf32-5a4f-4887-8b22-6bec31c2c7c6@FIVLA-EXHUB02.eu.tieto.com>		 (sfid-20120320_154008_038091_B257E507) <1332494945.3506.23.camel@jlt3.sipsolutions.net>	 <4F6C82A5.5080302@tieto.com> <1332513075.10384.20.camel@jlt3.sipsolutions.net>
In-Reply-To: <1332513075.10384.20.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sorry for my late reply.


Johannes Berg wrote:
> On Fri, 2012-03-23 at 15:03 +0100, Michał Kazior wrote:
>>> So I took a closer look at this now.
>>>
>>> I think we should probably apply the first two patches now, and the
>>> third with changes. After that, I'm not so sure.
>>
>> You mean the following, right?
>>
>>            mac80211: prepare ieee80211_mandatory_rates to per-vif
>>            mac80211: prepare ieee80211_sta_get_rates to per-vif
>> [tofix]  mac80211: prepare ieee80211_frame_duration to per-vif
>>
>> Should I resend them all, or just the 3rd one once I fix it?
>
> You should probably send them as [PATCH].

Okay.


>> What if we create a new structure that would be a channel
>> stream/reservation? Driver could then report multiple such objects. Each
>> such would have a tx queue and it's own locking. Let's assume something
>> like:
>>
>>     struct ieee80211_channel_stream {
>>       struct list_head vif; // list of vifs we're attached to
>>       struct ieee80211_channel *ch;
>>       struct sk_buff_head pending;
>>       int stop_reasons[IEEE80211_MAX_QUEUES];
>>       // .. other stuff
>>       u8 *drv_priv[0] __attribute__((__aligned__((void *))));
>>     };
>>
>>     struct ieee80211_vif {
>>       struct ieee80211_channel_stream *channel_stream;
>>       // .. rest of struct
>>     };
>>
>>    * We could then reject set_channel() based on number of different
>>      oper_channels and channel reservations
>>    * We could handle off-channel through a channel reservation by either
>>      using an unused one (which would result in hardware offloaded
>>      off-channel) or we would lock&flush it, switch to off-channel, do
>>      work, and get back
>
> I'm not sure we can easily use such a "stream" for off-channel
> operation. In particular, that "stream" might not support multiple
> queues.

Does it need to? It could as well just map all queues to a single hw 
queue with this design. I'm not sure if I get your point here.


Is it okay for us to not care if the driver supports real queues for 
ACs? Should we care if a driver maps all ACs from a channel context (or 
vif for that matter) onto a single hw queue? I'm wondering whether that 
would simplify code paths?


>> We should however consider that a device may not support certain
>> interface combinations. One thing that comes immediately to my mind is
>> the following: suppose we support STA+STA on different channels, AP+AP
>> on the same channel, but do not support AP+AP on different channels:
>>
>>     1. create wlan0, set channel=1, and start AP
>>     2. create wlan1, set channel=1, and start AP
>>     3. do set_channel(wlan1, 3)<-- oops
>>
>> This would probably be fixed easily with:
>>
>>     1. forbid changing channels on a running interface (i'm aware that's
>>        the same case for mac addr)
>>     2. thus we would require: ifdown + setchannel + ifup
>>
>> But that's just one case. Are there any others? This needs investigation.
>
> So my interface combinations advertising already supports
> "num_different_channels" per combination, so that would be easy to
> express. Switching the channel while the AP interface is up is probably
> not desirable anyway.

You're right. I've looked at the combination structures and they seem 
quite nice.


>
>> What is still missing here is the CAB queue (and possible other that may
>> come up in the future) you mentioned in the other thread.
>
> Ah, I see you did see my other thread :-)
>
>> I'm not sure
>> whether we may use queue_mapping for our own evil purposes here. If not,
>> then how about this:
>>
>>     struct ieee80211_queue_types { // or tx_queue_types?
>>       IEEE80211_QUEUE_VO,
>>       IEEE80211_QUEUE_VI,
>>       IEEE80211_QUEUE_BE,
>>       IEEE80211_QUEUE_BK,
>>       IEEE80211_QUEUE_CAB,
>>
>>       IEEE80211_QUEUE_LAST
>>     };
> [...]
>> This looks kind of ugly, but oh well. This way the driver will be able
>> to setup mapping between mac80211 and internal device queues. It should
>> also be possible to map one hardware queue to multiple
>> ieee80211_channel_stream structures (queues is a list of pointers) so
>> multiple vifs on the same channel is okay.
>
> I don't think this makes a lot of sense, tbh. This isn't a separate AC,
> I'd rather keep them separated.

You mean the CAB queue separated from ACs?


>
>> What are your thoughts on this? Is this terribly wrong or is it the way
>> to go? Have I missed something?
>
> I think that this is all a bit overkill :)
>
> I'm looking at the code right now, and I think we should treat ACs,
> queues and channels separately. If we combine queue sets&  channels into
> one, I think we'll find drivers that don't work correctly with this.
> Some devices for instance might have a set of queues for each interface,
> even if they're on the same channel. I don't want to lose flexibility to
> handle that.

You mean a driver that can handle two vifs simultaneously but on the 
same channel and have two separate queue sets for that?

Then we need to move queues to ieee80211_vif and create callbacks to 
bind channels contexts with a vif (just you mentioned that in other email).


>
> I think we'd hold the AC in skb_queue_mapping, since that's assigned
> early in the virtual interface queues already, and we need it to be the
> AC there for proper queue selection.
>
> The hardware queue we can put into a separate field in tx_info, I've
> made space for a u8 for this in a patch I have pending (but not sent to
> the list yet.)
>
> Ignoring the monitor mode interface, I think the simplest thing we can
> do is
>
> struct ieee80211_hw {
> 	...
> 	u8 offchannel_queue;
> };
>
> struct ieee80211_vif {
> 	...
> 	u8 hw_queue[IEEE80211_NUM_ACS];
> 	u8 after_dtim_queue;
> };
>
> For any of these (offchannel_queue, after_dtim_queue, hw_queue[i]), the
> queue number Q must be 0<= Q<  hw.queues. This allows us to keep all
> per-hw-queue state "flattened" in ieee80211_local's pending,
> queue_stop_reasons, etc. instead of separating all of it out into
> separate structures.

So you want "offchannel_queue", "hw_queue[]" and "after_dtim_queue" to 
point to driver/device hw queue id?


>
> When a queue is stopped, we do:
>
> void queue_stop(int q)
> {
> 	for_each_interface(vif) {
> 		if (vif->hw_queue[AC] == q) // for all 4 ACs
> 			stop netdev queue (vif->dev, AC)
> 		if (vif->after_dtim_queue == q)
> 			stop_all_queues(vif->dev)
> 	}
> }
>
> Or so ... after_dtim_queue is kinda a special case.

Oh, I see. So stopping CAB would be like "stop all the things".

But how do we then check if we need to stop given queue or not? Let's 
say a driver stops q=2 which corresponds to BE on vif0 and vif1. But 
then comes mac80211 aggregation and stops BE on vif0. I can only think 
of a single solution to that: "u8 lock_reasons[256];" in ieee80211_local 
but it seems like an overkill or is it not?

>
>
> If offchannel_queue is stopped, we'll have to refuse offchannel TX from
> nl80211 -- that seems *very* unlikely though.
>
>
> Do you think this would work?
>
> I think that covers the queue part -- I'll split the thread and will
> talk about multi-channel in a separate email.
>
>
> johannes
>


-- Pozdrawiam / Best regards, Michal Kazior.

