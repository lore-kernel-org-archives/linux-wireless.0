Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53440 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878Ab3AQA2j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 19:28:39 -0500
Message-ID: <1358382542.15012.109.camel@jlt4.sipsolutions.net> (sfid-20130117_012844_264203_0DEE0104)
Subject: Re: [RFC] Fixes for problems with off-channel powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 17 Jan 2013 01:29:02 +0100
In-Reply-To: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com> (sfid-20130108_191052_778281_BC63FCDC)
References: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com>
	 (sfid-20130108_191052_778281_BC63FCDC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Seth, all,

> [points 1-5, go to the previous email to read them]

All of these issues, btw, are, I think, shortcomings of the way
powersave and scanning is currently implemented in mac80211.

First, I think it is instructive to compare it to HW scan/powersave:
mac80211 can transmit/receive quite normally, process everything pretty
much just as it normally would, etc. Queues might be stopped by the
driver while it's scanning or become full quicker while, but
fundamentally that's not really different from regular operation.

Now let's go back to the software case: the real cause of all of these
problems is that mac80211 does the scan/PS TX via the regular TX
mechanism. This is *wrong*, it's not a regular TX that should be
subjected to stopped queues etc., it's *special*. For this reason we
can't properly stop the queues, and thus the saga of all these bugs
begins, with flushing, etc.

I actually think that our (your) time would be much better spent
implementing a new powersave/scan/offchannel module that, in a way, sits
between the driver and mac80211. Using that module, drivers could
implement the HW scan and HW offchannel callbacks, and powersave.

Obviously, all of this could be implemented directly in mac80211, with
if()s etc. However, I think splitting it out would actually create a
cleaner and easier to understand solution -- I'm hoping you might agree
by the end of this email :-)

So let's see what such a module would look like. I'm going to call it
"swpso" for "software Powersave/Scan/Offchannel" for now.

Obviously, it has to provide helper functions to implement
 * hw_scan
 * cancel_hw_scan
 * remain_on_channel
 * cancel_remain_on_channel

If we allow this module to have a single pointer in "struct
ieee80211_hw" (which we can, it should be logically part of mac80211)
then we can even have the module export functions that can directly be
assigned, so let's say it does that:

int ieee80211_swpso_scan(...) // prototype matching hw_scan
// etc.

Then drivers can just do
	.hw_scan = ieee80211_swpso_scan,
	.remain_on_channel = ieee80211_swpso_roc,
etc.

The module also needs to provide a function that the driver can call in
the TX path, for dynamic powersave. This would adjust the timers in the
TX path etc.

Additionally, the module might require queue control wrappers, so
drivers would call ieee80211_swpso_stop_queue() and
ieee80211_swpso_wake_queue() instead of the normal versions, obviously
it would forward there, but only after some own internal checking.


So how would this work? Let's consider remain-on-channel, instead of
scan, since scan is really just a bunch of remain-on-channels one after
another.

On receiving ROC, it would first call mac80211 to stop all queues
(except the, possibly entirely virtual, offchannel queue!), and
internally mark the queues as SWPSO-stopped. It also has to continually
maintain driver-stopped, hence the wrappers I talked about earlier. If
the queues are SWPSO-stopped, and the driver wakes it, this wake doesn't
propagate to mac80211. This really works much like
__ieee80211_wake_queue() and it could actually be combined into that
function since SWPSO would be a part of mac80211. Then drivers also
wouldn't need the wrappers here, that seems sensible.

Then, it would flush all queues in the driver, to make sure that nothing
is there. (1) After that, it would call ->tx() to send out any nulldata
frame(s). Since the queues are empty, this must succeed (2). If the
flush caused the driver to wake a queue because it was stopped, this
won't propagate to mac80211, where it would cause all kinds of issues.

Now switch channel, obviously.

This is ROC, so SWPSO has done its job. Any packets that now get
transmitted on the offchannel queue by mac80211 are transmitted
normally, on the normal queue, by the driver (it needs a bit of extra
logic for that). If it was scanning, it would now also transmit the
probe request.

Upon finishing with the channel, it just has to switch the channel back,
send nulldata frames and re-enable the queues.


Ok and now that I've typed it all up, I think it points to how we can do
it much more easily without a separate module and without really
changing the drivers.

Do a few things:
 * introduce IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL
 * stop all queues, using the new reason, before going offchannel
 * then flush
 * then *directly* tell the driver to transmit the nulldata packets,
   checking only if the driver has the queue stopped, in which case we
   have IEEE80211_QUEUE_STOP_REASON_DRIVER set; if it does, fail going
   off channel
 * similarly, *directly* tell the driver to transmit probe requests and
   offchannel packets from cfg80211, if it fails (stop reason driver)
   then do nothing (probe request) or return a failure to userspace
   (offchannel TX)

In fact the last two bullets should probably be implemented by passing
some sort of "offchan_tx_ok" to ieee80211_tx_skb() and friends, and
checking queue_stop_reasons more carefully in ieee80211_tx_frags().

I'll address powersave another day, but it also needs major rework. I
also think that the framework should somehow better integrate with
multi-channel, although I'm not sure anyone really wants to implement
that in software. It should be possible with some HW though, if it has
enough queues etc.

johannes


(1) Actually ... this whole queue stopping business could be improved
even further, if the driver has a hardware queue it can dedicate to the
transmissions we need here. Then, the driver could stop the *hardware*
queues, possibly leaving frames sitting on them. However, for ROC/scan
this really isn't interesting. It becomes interesting only for SW
multi-channel. It also cannot be implemented with all drivers, certainly
not with USB devices I think.

(2) I think there's a single driver that only accepts one packet at a
time, but that's not a big deal, since it also only support a single
virtual interface

