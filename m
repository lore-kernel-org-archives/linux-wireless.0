Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36707 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab0EKOAs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 10:00:48 -0400
Subject: Re: [PATCH v2 1/2] mac80211: add offload channel switch support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: wey-yi.w.guy@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <x2z43e72e891005061458uabf4a6cxae3f5dd4067f0fbb@mail.gmail.com>
References: <1273159552-5579-1-git-send-email-wey-yi.w.guy@intel.com>
	 <x2z43e72e891005061458uabf4a6cxae3f5dd4067f0fbb@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 16:00:43 +0200
Message-ID: <1273586443.20312.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think I'll adopt this patchset.

On Thu, 2010-05-06 at 14:58 -0700, Luis R. Rodriguez wrote:
> On Thu, May 6, 2010 at 8:25 AM,  <wey-yi.w.guy@intel.com> wrote:
> > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> >
> > Adding support to offload the channel switch operation to driver if
> > driver can support the function.
> 
> Can you please reword this a little, maybe, "This adds support for a
> driver specific channel switch callback to be used by drivers which
> might require a finer grain control of the operation, typically if you
> have a respective firmware API call".

Easy enough.

> > The original approach, mac80211 utilize the mac_config callback function
> 
> Do you mean the mac80211 config() callback?

Yeah, mac_config (or rather iwl_mac_config) is the iwlwifi callback
function's name.

> > and set the CHANNEL_CHANGE flag which is difficult to separate the true
> > channel switch request from all the other channel changes condition;
> 
> Good point, but why is this needed? More below.

Mostly because we get much better timing with firmware assist.

> > with this offload approach, driver has more control on how to handle the
> > channel switch request from AP, also can provide more accurate timing
> > calculation
> 
> Is the current timing insufficient, and if so can you provide more
> details. If the real reason for this callback is not timing
> considerations is the real reason a firmware API thing? If so it
> doesn't hurt to just say that to avoid confusing developer in deciding
> which approach to take.

The current mac80211 approach is flawed, for various reasons which I
won't get into here, most of which we can fix. However, due to
regulatory concerns our firmware also wants to have more control, like
checking that the AP is beaconing again after a channel switch before
letting us transmit frames. Timing is obviously also a consideration,
since the firmware can re-enable transmission quickly after the channel
switch, regardless of the delay in processing the frame or the timer on
the host.

> > The drivers like to support the channel switch offloading function
> 
> Maybe: "The drivers that require a dedicated channel switch callback"...
> 
> > will have
> > to provide the mactime information (at least for mgmt and action frames)
> 
> Might be good to specify why, or at least in the documentation code below.

Actually, it's up to them. But if you implement the callback, you'll
want to know precisely when to expect the channel switch, so you'll want
to know when the frame that contained the CSA was received, which you
have to provide to mac80211 in the "mactime" rx status field.

> > + * @timestamp: value in microseconds of the 64-bit Time Synchronization
> > + *     Function (TSF) timer when the channel switch ie received.
> 
> Might be good to indicate this is derived from the rx status mactime
> and the beacon interval from the BSS.

It's not derived from the beacon interval, it's just the plain mactime
passed through. As such, where else would it come from? But yeah I guess
it could say that.

> > +/**
> > + * ieee80211_chswitch_done - Complete channel switch process
> > + * @vif: &struct ieee80211_vif pointer from the add_interface callback.
> > + * @is_seccess: make the channel switch successful or not
> 
> Typo, is_seccess, not success. Also, I don't get what this is for, can
> you elaborate?

Channel switching could fail, for instance if the AP doesn't show up on
the new channel. We don't have a way to handle that yet in mac80211, but
why not let it know.

> > + *
> > + * Complete the channel switch post-process: set the new operational channel
> > + * and wake up the suspended queues.
> 
> I don't get it.. who calls this and why, under what conditions?
> 
> If drivers have to call this once they are done with the channel
> switch operation callback then you might want to specify that and/or
> check for the existance of the op upon it being called and warn if it
> is not.

Can't check that since it's also called by mac80211 itself for software
implemented channel switch.

> > --- a/net/mac80211/mlme.c
> > +++ b/net/mac80211/mlme.c
> > @@ -340,7 +340,11 @@ static void ieee80211_chswitch_work(struct work_struct *work)
> >                goto out;
> >
> >        sdata->local->oper_channel = sdata->local->csa_channel;
> 
> If the new driver callback for channel switch failed this operation
> channel is still being set to the csa_channel. This *only* works
> because on the channels witch done routine you write below you
> overwrite the csa_channel variable to the existing operation channel.
> This seem rather hackish... if the channel switch callback failed why
> would we call the work to do the channel switch?

Not the callback failed .. the switch itself failed. Ap not showing up,
or advertising the wrong channel could be reasons.

> > -       ieee80211_hw_config(sdata->local, IEEE80211_CONF_CHANGE_CHANNEL);
> > +       if (!sdata->local->ops->channel_switch) {
> > +               /* call "hw_config" only if doing sw channel switch */
> > +               ieee80211_hw_config(sdata->local,
> > +                       IEEE80211_CONF_CHANGE_CHANNEL);
> > +       }
> 
> Notice how the existing implementation also addresses quiescing in the
> timer, how will you address this with this new driver API?

The timer is not started when the callback exists. It can still be
deleted even if it was never started, right? What's the question?

> > +void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool is_success)
> > +{
> > +       struct ieee80211_sub_if_data *sdata;
> > +       struct ieee80211_if_managed *ifmgd;
> > +
> > +       sdata = vif_to_sdata(vif);
> > +       ifmgd = &sdata->u.mgd;
> > +
> > +       trace_api_chswitch_done(sdata, is_success);
> > +       if (!is_success)
> > +               sdata->local->csa_channel = sdata->local->oper_channel;
> 
> If this routine is to be called by drivers once they complete the
> channel switch operation why do we continue by queuing the channel
> switch work below?
> 
> > +
> > +       ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
> > +}
> > +EXPORT_SYMBOL(ieee80211_chswitch_done);


because that will complete the channel switch. I think you're getting
confused by the name, chswitch_work should be called chswitch_done_work
but blame that on Sujith :P

> > +       if (sdata->local->ops->channel_switch) {
> > +               /* use driver's channel switch callback */
> > +               struct ieee80211_channel_switch ch_switch;
> > +               memset(&ch_switch, 0, sizeof(ch_switch));
> > +               ch_switch.timestamp = timestamp;
> 
> If timestamp is 0 (when the driver does not set it) then this is all
> busted and I can see a few bug reports coming out due to it. These bug
> reports could be avoided if you check for the timestamp to be
> reasonable here and fail otherwise, in fact if the we know the channel
> switch operation is busted we may just want to disassociate given the
> DFS considerations are sensitive. What do you think?

I don't follow? The mactime only gets back to the driver, so if the
driver didn't report it properly it will get bogus values, mac80211
won't ever care. As such, in the unlikely event that the driver doesn't
need it, it wouldn't have to provide it, so any such checking doesn't
seem proper?

> I'd appreciate more feedback on the why this is being done. Its not
> clear to me how we are limited by the current implementation. 

Ok like I said -- timing is a big thing. Regulatory enforcement in our
firmware is another.

> If you
> have a firmware API need that is different and I think that should be
> made clear, but if you do need it we need to ensure both methods are
> properly documented and their different use cases outlined. I also
> think the way these method are split are rather hacky right now.

I'm not sure how you could split it better?

I'll fix up some docs and stuff and respin.

johannes

