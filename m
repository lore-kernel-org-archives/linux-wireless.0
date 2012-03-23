Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:61498 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119Ab2CWODU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 10:03:20 -0400
Message-ID: <4F6C82A5.5080302@tieto.com> (sfid-20120323_150333_004349_1A5648D7)
Date: Fri, 23 Mar 2012 15:03:17 +0100
From: =?UTF-8?B?TWljaGHFgiBLYXppb3I=?= <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 00/12] multi-channel support
References: <06edaf32-5a4f-4887-8b22-6bec31c2c7c6@FIVLA-EXHUB02.eu.tieto.com>	 (sfid-20120320_154008_038091_B257E507) <1332494945.3506.23.camel@jlt3.sipsolutions.net>
In-Reply-To: <1332494945.3506.23.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Hi,
>
>> The following patches prepare mac80211 to support multi-channel capable
>> hardware. The patchset prepares to channel per-vif split.
>>
>> Work still needs to be done:
>>   * powersave per-vif
>>   * queue locking per-vif
>>   * offchannel rework (hw_config, work_work)
>>   * and a bit more
>>
>> Questions:
>>
>>   * monitor interfaces:
>>     Currently ieee80211_set_channel gets netdev==NULL when iface is
>>     a monitor. Is there a particular reason behind it?
>>
>>   * ieee80211_hw_config:
>>     Should we extend it to take ieee80211_sub_if_data or should we
>>     use ieee80211_bss_info_change_notify? If so, is ieee80211_hw_config
>>     eventually to be removed?
>>
>> What do you think of this approach?
>
>
> So I took a closer look at this now.
>
> I think we should probably apply the first two patches now, and the
> third with changes. After that, I'm not so sure.

You mean the following, right?

          mac80211: prepare ieee80211_mandatory_rates to per-vif
          mac80211: prepare ieee80211_sta_get_rates to per-vif
[tofix]  mac80211: prepare ieee80211_frame_duration to per-vif

Should I resend them all, or just the 3rd one once I fix it?


> Overall, I think the approach isn't sufficient. At the very least, the
> (unstated!) assumption that one channel per interface can always be done
> is bad. Modifying this with the structure you gave it though seems to be
> problematic.
>
> We should also handle the queue mapping first I think. This isn't a
> feature you can implement overnight :-)

I've been thinking more on queue handling in multi-channel. Here are my 
thoughts.

If we assume that off-channel should be a global thing then we should 
rethink the whole queue thing first.

What if we create a new structure that would be a channel 
stream/reservation? Driver could then report multiple such objects. Each 
such would have a tx queue and it's own locking. Let's assume something 
like:

   struct ieee80211_channel_stream {
     struct list_head vif; // list of vifs we're attached to
     struct ieee80211_channel *ch;
     struct sk_buff_head pending;
     int stop_reasons[IEEE80211_MAX_QUEUES];
     // .. other stuff
     u8 *drv_priv[0] __attribute__((__aligned__((void *))));
   };

   struct ieee80211_vif {
     struct ieee80211_channel_stream *channel_stream;
     // .. rest of struct
   };

  * We could then reject set_channel() based on number of different
    oper_channels and channel reservations
  * We could handle off-channel through a channel reservation by either
    using an unused one (which would result in hardware offloaded
    off-channel) or we would lock&flush it, switch to off-channel, do
    work, and get back

We should however consider that a device may not support certain 
interface combinations. One thing that comes immediately to my mind is 
the following: suppose we support STA+STA on different channels, AP+AP 
on the same channel, but do not support AP+AP on different channels:

   1. create wlan0, set channel=1, and start AP
   2. create wlan1, set channel=1, and start AP
   3. do set_channel(wlan1, 3) <-- oops

This would probably be fixed easily with:

   1. forbid changing channels on a running interface (i'm aware that's
      the same case for mac addr)
   2. thus we would require: ifdown + setchannel + ifup

But that's just one case. Are there any others? This needs investigation.

Other issue I'm thinking would be: what if a device supports specialized 
off-channel queue (is there one we know? iwlwifi?) ? We can't advertise 
this as a fully-usable ieee80211_channel_stream (again, is there 
anything that has a shortcoming like that?). Should we add capability 
flags for each ieee80211_channel_stream? Or we could add new driver 
callback, eg. "set_channel_try" and allow the driver to decide whether 
it allows a certain hardware state or not.

What is still missing here is the CAB queue (and possible other that may 
come up in the future) you mentioned in the other thread. I'm not sure 
whether we may use queue_mapping for our own evil purposes here. If not, 
then how about this:

   struct ieee80211_queue_types { // or tx_queue_types?
     IEEE80211_QUEUE_VO,
     IEEE80211_QUEUE_VI,
     IEEE80211_QUEUE_BE,
     IEEE80211_QUEUE_BK,
     IEEE80211_QUEUE_CAB,

     IEEE80211_QUEUE_LAST
   };

   enum ieee80211_queue_types
   ieee80211_ac_number_to_queue_type(enum ieee80211_ac_numbers ac);

   struct ieee80211_channel_stream_queue {
     enum ieee80211_queue_types type;
     u8 drv_priv[0];
   };

   struct XYZ_channel_stream_queue { // example driver priv
     int internal_queue_id;
     // other stuff, like driver queues, stats, etc.
   };

   struct ieee80211_channel_stream {
     struct ieee80211_channel_stream_queue *queues[IEEE80211_QUEUE_LAST];
     // ..
   };

   struct ieee80211_vif_queue {
     struct ieee80211_vif *vif;
     struct ieee80211_channel_stream_queue *queue;
   };

   struct ieee80211_vif {
     // this is going to be just a helper
     // we can't refer to ieee80211_channel_stream_queue directly since
     // it wouldn't know what vif it belongs to (it may belong to
     // multiple vifs)
     struct ieee80211_vif_queue queues[IEEE80211_QUEUE_LAST];
     // ..
   };

   struct ieee80211_tx_info {
     // instead of ieee80211_vif* we use ieee80211_vif_queue*
   };

This looks kind of ugly, but oh well. This way the driver will be able 
to setup mapping between mac80211 and internal device queues. It should 
also be possible to map one hardware queue to multiple 
ieee80211_channel_stream structures (queues is a list of pointers) so 
multiple vifs on the same channel is okay.


What are your thoughts on this? Is this terribly wrong or is it the way 
to go? Have I missed something?


-- Pozdrawiam / Best Regards, Michal Kazior.
