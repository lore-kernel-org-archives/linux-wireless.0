Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53965 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2EKMLe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 08:11:34 -0400
Message-ID: <1336738290.5819.23.camel@jlt3.sipsolutions.net> (sfid-20120511_141137_957037_16962830)
Subject: Re: [RFC/PATCH] multi-channel preparation work
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	Thomas Pedersen <thomas@cozybit.com>
Date: Fri, 11 May 2012 14:11:30 +0200
In-Reply-To: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
References: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michal,

> Here's some work on multi-channel operation. It refactors channel
> switching logic with regard to ieee80211_hw_config and moves
> oper_channel stuff to sdata.

This could be useful, but it's hard to tell really. For example, if you
have a channel context, why would you need to store the channel/channel
type per sdata? Each sdata would just point to the channel context, I
think?

> I plan on doing channel contexts next. Monitor interface stuff probably
> needs to be addressed as well since it's tied tightly with set_channel.

Maybe we need to take a more radical approach in introducing
multi-channel and channel contexts :-)

You've started with very small changes like this patchset, but I can't
get a good feeling for how it'll be in the end with channel contexts.
For example, see the question above.

I think we should think about the end result / design more.

You saw my patches for managing the AP channel differently. I think we
should do the same for mesh, Thomas might actually be working on it but
if not it's pretty easy to do really. There are some questions about how
it would work though that Thomas and I may have to discuss [1].

The reason for all this is to get rid of the set_channel call. It's not
really how things should look like with multi-channel, since there we
need a clear indication of when we start and stop using a certain
channel. With the AP mode changes, we'll start using it in start_ap()
(and obviously stop using it in stop_ap()), which simplifies things.

Felix says WDS is completely broken today, so I don't think I care about
it, we should probably just remove the ability to set the channel on WDS
interfaces. Maybe even force them to be slaved to AP mode interfaces.
Felix, any thoughts? I had a patch to introduce explicit start-wds and
stop-wds operations but there were issues with error handling since I'd
have to call start-wds in NETDEV_UP for compatibility... and that can't
return errors any more [2].

That leaves monitor mode, and setting the channel when there's no
interface at all. Monitor mode is special, but we have a nice way out:
when a driver supports multi-channel it will probably need to use the
new queue scheme. Then, if _injection_ is desired, the driver needs to
implement support for explicit monitor mode interfaces anyway. So I
think we can force multi-channel capable drivers to implement explicit
monitor mode, if they want to support a real monitor mode at all.
Depending on what mesh needs, we may be able to equate "phy channel" to
"monitor mode channel", the cfg80211 callbacks pretty much make that
assumption today but inside cfg80211 it may not be true.

In any case, the result of all of this is that the cfg80211 set_channel
operation is no longer used by anything but monitor mode, we could
rename it to set_monitor_channel. This operation would only be available
when only monitor interfaces, if any interfaces at all, are active.
Internally in mac80211, the channel context for monitor interfaces would
be attached to the explicit monitor interface.

Now, if we have a driver that supports only a single channel and maybe
doesn't even support the explicit monitor interface API, then obviously
we have to translate all this to the explicit channel setting with
hw_config. However, that's not terribly difficult I think? We need to
have a limit on channel contexts anyway, so we don't create too many, so
here the limit is 1 and when we change that context we program the
hardware.

The only other difficult thing is software scanning/remain-on-channel,
i.e. the temporary channel. But this is only supported for drivers that
don't have multi-channel, so we can essentially keep it the same with
the tmp_channel variable, it just overrides the context.

I'm probably glossing over a lot of details, but at least I now have a
clearer picture of how we can do this. :-) I hope it helps explain my
thinking.

johannes

[1] The question is whether or not setting the channel on the *phy* is
needed for mesh, and if it has to support bringing up mesh without
having any channel set at all. These are backward compatibility
considerations.

[2] Alternatively, we could change the userspace API and require that
you set the WDS peer *after* bringing up the interface. Today, you have
to set it *before*. Then setting the peer could actually be the signal
to establish the "link". Given that it all doesn't work, maybe that's an
alternative? I'd have patches for this almost ready.

