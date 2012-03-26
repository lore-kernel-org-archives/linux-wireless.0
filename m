Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36336 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306Ab2CZNTy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 09:19:54 -0400
Message-ID: <1332767991.5435.34.camel@jlt3.sipsolutions.net> (sfid-20120326_151958_186813_8CB1E0A6)
Subject: Re: [RFC 00/12] multi-channel support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 26 Mar 2012 15:19:51 +0200
In-Reply-To: <4F706122.6080107@tieto.com>
References: <06edaf32-5a4f-4887-8b22-6bec31c2c7c6@FIVLA-EXHUB02.eu.tieto.com>
			 (sfid-20120320_154008_038091_B257E507) <1332494945.3506.23.camel@jlt3.sipsolutions.net>
		 <4F6C82A5.5080302@tieto.com>
	 (sfid-20120323_150333_004349_1A5648D7) <1332514895.10384.40.camel@jlt3.sipsolutions.net>
	 <4F706122.6080107@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-26 at 14:29 +0200, Michal Kazior wrote:
> Johannes Berg wrote:
> > On Fri, 2012-03-23 at 15:03 +0100, Michał Kazior wrote:
> >
> >> What if we create a new structure that would be a channel
> >> stream/reservation? Driver could then report multiple such objects.
> >> Each such would have a tx queue and it's own locking. Let's assume
> >> something like:
> >>
> >>     struct ieee80211_channel_stream {
> >>       struct list_head vif; // list of vifs we're attached to
> >>       struct ieee80211_channel *ch;
> >>       struct sk_buff_head pending;
> >>       int stop_reasons[IEEE80211_MAX_QUEUES];
> >>       // .. other stuff
> >>       u8 *drv_priv[0] __attribute__((__aligned__((void *))));
> >>     };
> >
> > I'm not sure I see the need to have the driver register these, but it
> > seems useful to maintain this abstraction somehow in mac80211.
> >
> > Due to the interface combinations advertising, we already know (*) what
> > is supported by the driver, so there's no need for the driver to
> > register this again.
> >
> > Like I said earlier, I see basically two ways of handling this.
> >
> > The explicit way would essentially consist of something like this:
> >
> > struct ieee80211_channel_context {
> > 	struct ieee80211_channel *chan;
> > 	enum nl80211_channel_type type;
> > };
> >
> > with API to add/remove such contexts from/to the device:
> >
> > struct ieee80211_ops {
> > 	...
> > 	void (*add_channel_context)(hw, ctx),
> > 	void (*remove_channel_context)(hw, ctx),
> > 	void (*change_channel_type)(hw, ctx),
> > 	void (*assign_vif_channel_context)(hw, vif, ctx),
> > };
> >
> > The assign function would have rather strange semantics though -- it can
> > be called only when the interface is up (added to the driver), but it
> > can't be called while the interface is associated, active as an AP, etc.
> > EXCEPT ... maybe it can in CSA scenarios. But I said that before: CSA is
> > a bit of a mess to handle.
> 
> Are we going to assume that "add_channel_context" always succeeds?
> So I understand you want to use interface combinations to control when 
> these functions are valid to be called.

I think we have to assume that. The driver is able to express its
restrictions through the interface combinations, and hopefully it can
live up to those expectations?


> But can we express the "off-channel only" channel context through 
> interface combinations? Is it valid for a driver to say the following?
> 
> struct ieee80211_iface_limit limits[] = {
>     { .max = 1, .types = BIT(NL80211_IFTYPE_AP) },
>     { .max = 1, .types = BIT(NL80211_IFTYPE_STATION) },
>     { .max = 1, .types = 0 }
> };
> 
> struct ieee80211_iface_combination combination = {
>    .limits = limits,
>    .n_limits = 3,
>    .max_interfaces = 2,
>    .num_different_channels = 3,
> };

This doesn't make much sense, the third limit entry would never be used
since the off-channel code doesn't consider channel contexts here.

> You also assume that a driver can do a generic "add_channel_context" 
> that would allow it to prepare the device. This may not be true for all 
> devices. It is unknown whether this channel context is going to be used 
> for off-channel, STA or AP. Especially off-channel is broken this way 
> since it isn't bound to vif - in fact it can't be. The same goes for 
> CSA. Or maybe I didn't get the idea behind "add_channel_context"?

I'm thinking that the channel context would always be bound to a vif. If
the driver didn't need this to prepare the device, then it would simply
do the entire device setup when the context is bound to the vif? Or even
later when the vif is in use?


> How about:
> 
> struct ieee80211_ops {
>    // ..
>    void (*changed_channel_type)(hw, ctx);
>    void (*detach_channel_context)(ctx);
>    void (*attach_channel_context_to_vif)(hw, vif, ctx);
>    void (*attach_channel_context_to_hw)(hw, ctx);
> };
> 
> This way mac80211 immediately states it's intention - and we can use 
> "attach_channel_context_to_hw" to do off-channel, and 
> "attach_channel_context_to_vif" to do CSA as well as normal interface 
> start up. We could maybe split detach_* into two different functions if 
> necessary. The "attach_channel_context_to_vif" would be allowed even 
> when associated for the purpose of dealing with CSA.
> 
> What do you think?

I'm not sure I understand your desire to handle off-channel within this
framework. An off-channel period is, by definition, very time-limited.
As such, I don't see why it matters whether you do:

	ctx = add_channel_context(off-channel channel)
	attach_channel_context_to_hw(hw, ctx)
	remain_on_channel(hw, ctx, duration)
	delete_channel_context(ctx)

or this:
	remain_on_channel(hw, channel, duration)

In the latter case, the driver can set up and tear down the context
internally just as well, since it's only temporary?


> The off-channel flow would be then:
> 
>   * hw supports 1 interface on 1 channel
>   * we're connected as STA
>   1. scan request
>   2. stop sta
>   3. detach_channel_context(oper) without freeing it of course
>   4. create channel context "tmp"
>      5. set next scan channel in channel context "tmp"
>      6. attach_channel_context_to_hw(tmp)
>      7. work
>      8. detach_channel_context(tmp)
>      9. go to 5 if more work needed
> 10. detach_channel_context(tmp)
> 11. attach_channel_context(oper)
> 
> Are we okay with this?
> 
> Also if the device were to support at least 1 extra channel that can do 
> (offloaded) off-channel we wouldn't have to do steps: 2, 3, 11.


Ok, so ... I think we're getting to the bottom of our misunderstanding &
confusion. I've completely ignored scan/off-channel in this because I
don't have to handle it in software, our device handles it itself. It
seems from this that you do need it handled in software.

The question is -- do we want mac80211 to handle it? I'll get back to
that later after I reply to the other points, see below.


> > Now that I think about it, the implicit way I previously thought was
> > quite a separate mechanism is really very similar: you'd still have to
> > have the assign_vif_channel_context function, maybe as part of
> > bss_info_changed, but not have explicit add/remove. I think the
> > add/remove is useful so let's not consider implicit methods any more :)
> 
> I'm unsure about the add/remove. See above. We can't just add a channel 
> context without stating the purpose of that channel context. A driver 
> might need to know of the purpose beforehand.

Yes, I was only thinking of "for vif" contexts.


> > Wrt. off-channel, I'm not sure I've understood you correctly. The
> > current off-channel is a very short-lived thing that doesn't really use
> > a "complete" channel context. In fact, in our implementation it is
> > completely separate since it's temporary (**).
> 
> Maybe you're right, but how can we then express off-channel in a neat 
> clean way? If we use channel contexts we get software AND hardware 
> off-channel (as long as the device supports it) at the same time.

I'm not sure. The detach logic etc. you proposed above will really not
be implementable in our device's context handling.


> If it's a concern that userspace may want to start a new interface on a 
> different channel while off-channel is taking up "a precious channel 
> context", we may either do -EBUSY or just sleep a few seconds/defer the 
> work if the off-channel is really short-lived.

Yeah, *handwaving*, I wouldn't be concerned about that either :-)


> > (*) after we refactor cfg80211_can_change_interface() and export
> > cfg80211_get_current_combination() that returns the pointer to the
> > combination that's currently in use, or something like that. We'd have
> > to figure out if another combination is available that has more channels
> > though, if needed.
> 
> Is there a lot of work to be done?

Nah, the biggest problem is probably figuring out what we need/want and
how we use it.


> > (**) However, we're thinking about implementing a P2P-device context
> > that would allow offloading things like periodic listen
> > (discoverability) or find (search + listen). That would probably use a
> > channel context then.
> 
> But that wouldn't need a permanent channel context, would it? It'll 
> probably be cheap to attach/detach channel contexts.

This would actually want a permanent context since you'd want the device
to schedule the periodic listen on that context.

We haven't really talked about this, but obviously there's going to have
to be some scheduler that tells the device how to switch between
multiple channel contexts, probably only by some sort of "quota".


>  >> Should we add capability
>  >> flags for each ieee80211_channel_stream? Or we could add new driver
>  >> callback, eg. "set_channel_try" and allow the driver to decide
>  >> whether it allows a certain hardware state or not.
>  >
>  > This is not a fully feasible "stream" anyway. Think of it more like a
>  > single scan dwell -- you wouldn't express that as a separate "stream"
>  > I think?
> 
> Why not? Should we care what vif we're working with, or hw for that 
> matter? Off-channel, as well as other operation means we want to do 
> something on a certain channel. It shouldn't matter how long we use that 
> channel (except if we're borrowing time from another operational mode).

I'm not sure how your device works, but it seems that the device would
require binding vifs to a channel context so that it knows which is
active where? When to synchronise with beacons, for example?


> Another question would be if we could do software multi-channel 
> operation. Do you think it's even possible and worth exploring?

I don't think it's feasible to implement in mac80211 because of timing
constraints. With devices like ath9k it can probably be done by relying
on hardware timers, interrupts and queue blocking/opening, but because
mac80211 has to deal with USB and SDIO chips too which can be really
slow it can't really do this. So no, I wouldn't think it's worth
exploring at least not directly in mac80211 -- maybe as a separate
helper library or something.


Now let's go back to the question of off-channel/scan -- this seems to
be the fundamental difference in how we look at things. First, the same
thing applies here. SW scanning in mac80211 right now is very
inefficient when you try to do background scanning, since it doesn't
synchronise with beacons etc. With multiple virtual interfaces, this
will only get worse. With multiple channels, probably more so.

Then also I'm in a bit of a luxurious position -- our device implements
scanning and off-channel all by itself. For this reason, but also
because of the timing, I've always wanted to ignore off-channel and
scanning in the multi-channel code as much as possible.

Your proposal to add temporary channel contexts might be feasible, but I
wonder how complex it would become and how much of it can really be
shared? I expect that ath9k will implement multi-channel completely in
software, and any scheduler there would probably also roll in
scanning/off-channel. (Not that I know, I don't work for QCA :) )

Also, I'm a bit afraid that doing so would make the channel context API
even more complex, and it's not really easy anyway.

I think I need to know more about how you would need to use those
temporary channel contexts, but I have a feeling that we might be better
off by splitting it into a separate helper library. I'm thinking this
would essentially sit between mac80211 and the driver, and offer
"translation services", i.e. it would have a "remain_on_channel"
function that the driver could call for mac80211's remain_on_channel
callback, and then this separate code could do something like your
temporary channel context detach/attach etc.

Would that seem okay to you? I'd rather leave this complexity out of
mac80211, not just for complexity reasons but also to make the API have
easier semantics.

This helper library could also make more assumptions and have timing
inputs, so if asked to scan (the scan state machine would move into it)
it could drive the scan state machine off timing inputs from the
hardware rather than today's essentially random behaviour (wrt. beacons
etc.)

johannes

