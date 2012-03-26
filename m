Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:50321 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab2CZM3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 08:29:25 -0400
Message-ID: <4F706122.6080107@tieto.com> (sfid-20120326_142927_641361_63873139)
Date: Mon, 26 Mar 2012 14:29:22 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 00/12] multi-channel support
References: <06edaf32-5a4f-4887-8b22-6bec31c2c7c6@FIVLA-EXHUB02.eu.tieto.com>		 (sfid-20120320_154008_038091_B257E507) <1332494945.3506.23.camel@jlt3.sipsolutions.net>	 <4F6C82A5.5080302@tieto.com> (sfid-20120323_150333_004349_1A5648D7) <1332514895.10384.40.camel@jlt3.sipsolutions.net>
In-Reply-To: <1332514895.10384.40.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2012-03-23 at 15:03 +0100, Michał Kazior wrote:
>
>> What if we create a new structure that would be a channel
>> stream/reservation? Driver could then report multiple such objects.
>> Each such would have a tx queue and it's own locking. Let's assume
>> something like:
>>
>>     struct ieee80211_channel_stream {
>>       struct list_head vif; // list of vifs we're attached to
>>       struct ieee80211_channel *ch;
>>       struct sk_buff_head pending;
>>       int stop_reasons[IEEE80211_MAX_QUEUES];
>>       // .. other stuff
>>       u8 *drv_priv[0] __attribute__((__aligned__((void *))));
>>     };
>
> I'm not sure I see the need to have the driver register these, but it
> seems useful to maintain this abstraction somehow in mac80211.
>
> Due to the interface combinations advertising, we already know (*) what
> is supported by the driver, so there's no need for the driver to
> register this again.
>
> Like I said earlier, I see basically two ways of handling this.
>
> The explicit way would essentially consist of something like this:
>
> struct ieee80211_channel_context {
> 	struct ieee80211_channel *chan;
> 	enum nl80211_channel_type type;
> };
>
> with API to add/remove such contexts from/to the device:
>
> struct ieee80211_ops {
> 	...
> 	void (*add_channel_context)(hw, ctx),
> 	void (*remove_channel_context)(hw, ctx),
> 	void (*change_channel_type)(hw, ctx),
> 	void (*assign_vif_channel_context)(hw, vif, ctx),
> };
>
> The assign function would have rather strange semantics though -- it can
> be called only when the interface is up (added to the driver), but it
> can't be called while the interface is associated, active as an AP, etc.
> EXCEPT ... maybe it can in CSA scenarios. But I said that before: CSA is
> a bit of a mess to handle.

Are we going to assume that "add_channel_context" always succeeds?
So I understand you want to use interface combinations to control when 
these functions are valid to be called.

But can we express the "off-channel only" channel context through 
interface combinations? Is it valid for a driver to say the following?

struct ieee80211_iface_limit limits[] = {
    { .max = 1, .types = BIT(NL80211_IFTYPE_AP) },
    { .max = 1, .types = BIT(NL80211_IFTYPE_STATION) },
    { .max = 1, .types = 0 }
};

struct ieee80211_iface_combination combination = {
   .limits = limits,
   .n_limits = 3,
   .max_interfaces = 2,
   .num_different_channels = 3,
};


You also assume that a driver can do a generic "add_channel_context" 
that would allow it to prepare the device. This may not be true for all 
devices. It is unknown whether this channel context is going to be used 
for off-channel, STA or AP. Especially off-channel is broken this way 
since it isn't bound to vif - in fact it can't be. The same goes for 
CSA. Or maybe I didn't get the idea behind "add_channel_context"?


How about:

struct ieee80211_ops {
   // ..
   void (*changed_channel_type)(hw, ctx);
   void (*detach_channel_context)(ctx);
   void (*attach_channel_context_to_vif)(hw, vif, ctx);
   void (*attach_channel_context_to_hw)(hw, ctx);
};

This way mac80211 immediately states it's intention - and we can use 
"attach_channel_context_to_hw" to do off-channel, and 
"attach_channel_context_to_vif" to do CSA as well as normal interface 
start up. We could maybe split detach_* into two different functions if 
necessary. The "attach_channel_context_to_vif" would be allowed even 
when associated for the purpose of dealing with CSA.

What do you think?


The off-channel flow would be then:

  * hw supports 1 interface on 1 channel
  * we're connected as STA
  1. scan request
  2. stop sta
  3. detach_channel_context(oper) without freeing it of course
  4. create channel context "tmp"
     5. set next scan channel in channel context "tmp"
     6. attach_channel_context_to_hw(tmp)
     7. work
     8. detach_channel_context(tmp)
     9. go to 5 if more work needed
10. detach_channel_context(tmp)
11. attach_channel_context(oper)

Are we okay with this?

Also if the device were to support at least 1 extra channel that can do 
(offloaded) off-channel we wouldn't have to do steps: 2, 3, 11.


> Now that I think about it, the implicit way I previously thought was
> quite a separate mechanism is really very similar: you'd still have to
> have the assign_vif_channel_context function, maybe as part of
> bss_info_changed, but not have explicit add/remove. I think the
> add/remove is useful so let's not consider implicit methods any more :)

I'm unsure about the add/remove. See above. We can't just add a channel 
context without stating the purpose of that channel context. A driver 
might need to know of the purpose beforehand.


> The internal handling in mac80211 might have a linked list of the
> channel contexts, or just a static array of a handful of them, doesn't
> really matter. It would, however, make sure that there aren't more than
> the current interface combination advertised as supported (see (*)
> again.)
>
> Of course mac80211 would also assign the interfaces to channel contexts
> as needed -- if a given interface is already on channel 1, the next one
> wouldn't need a new channel context if it also uses channel 1 and the
> channel types are compatible. But that reminds me -- when we do that we
> may have to update the channel context to change its channel type, so
> add an operation for that.
>
>
> Wrt. off-channel, I'm not sure I've understood you correctly. The
> current off-channel is a very short-lived thing that doesn't really use
> a "complete" channel context. In fact, in our implementation it is
> completely separate since it's temporary (**).

Maybe you're right, but how can we then express off-channel in a neat 
clean way? If we use channel contexts we get software AND hardware 
off-channel (as long as the device supports it) at the same time.

If it's a concern that userspace may want to start a new interface on a 
different channel while off-channel is taking up "a precious channel 
context", we may either do -EBUSY or just sleep a few seconds/defer the 
work if the off-channel is really short-lived.

Also if we consider channel contexts that can't do normal operation at 
all - there wouldn't be such problem since they would never be used for 
anything but off-channel.


>
> As far as scanning is concerned, I'm not really sure. I haven't spent
> much time thinking about it since we have hardware offload for it (and
> also off-channel) -- I'm not sure what a good solution would be.
>
> johannes
>
>
> (*) after we refactor cfg80211_can_change_interface() and export
> cfg80211_get_current_combination() that returns the pointer to the
> combination that's currently in use, or something like that. We'd have
> to figure out if another combination is available that has more channels
> though, if needed.

Is there a lot of work to be done?


> (**) However, we're thinking about implementing a P2P-device context
> that would allow offloading things like periodic listen
> (discoverability) or find (search + listen). That would probably use a
> channel context then.

But that wouldn't need a permanent channel context, would it? It'll 
probably be cheap to attach/detach channel contexts.


 >> Should we add capability
 >> flags for each ieee80211_channel_stream? Or we could add new driver
 >> callback, eg. "set_channel_try" and allow the driver to decide
 >> whether it allows a certain hardware state or not.
 >
 > This is not a fully feasible "stream" anyway. Think of it more like a
 > single scan dwell -- you wouldn't express that as a separate "stream"
 > I think?

Why not? Should we care what vif we're working with, or hw for that 
matter? Off-channel, as well as other operation means we want to do 
something on a certain channel. It shouldn't matter how long we use that 
channel (except if we're borrowing time from another operational mode).


Another question would be if we could do software multi-channel 
operation. Do you think it's even possible and worth exploring?



-- Pozdrawiam / Best regards, Michal Kazior.

