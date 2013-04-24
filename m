Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sipsolutions.net ([144.76.43.152]:50168 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231Ab3DXLYI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 07:24:08 -0400
Message-ID: <1366802638.21854.11.camel@jlt4.sipsolutions.net> (sfid-20130424_132413_694423_B399900A)
Subject: Re: [PATCH] mac80211: fix spurious use of rcu_dereference
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	karl.beldan@gmail.com
Date: Wed, 24 Apr 2013 13:23:58 +0200
In-Reply-To: <201304231526.47996.chunkeey@googlemail.com> (sfid-20130423_152714_476409_02299025)
References: <1366640083-1054-1-git-send-email-nbd@openwrt.org>
	 <201304230258.08359.chunkeey@googlemail.com>
	 <1366699708.8385.1.camel@jlt4.sipsolutions.net>
	 <201304231526.47996.chunkeey@googlemail.com>
	 (sfid-20130423_152714_476409_02299025)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-04-23 at 15:26 +0200, Christian Lamparter wrote:

> > > Actually, rcu_read_lock() might not be necessary in this special
> > > case [the RC is not yet initialized, so nothing bad can happen].
> > > 
> > > But, since the rcu_read_lock() has a low overhead and
> > > rate_control_set_rates mac80211.h doc does not mention
> > > anything about locking, I think this is a viable way. 
> > 
> > I think that, on the contrary, it's completely strange/wrong. ;-)

> Sorry, I think I cut too much from the stack trace and I didn't
> explain how the code end up in this case. This time, I commented out
> the rcu_read_(un)lock() [=> rate.c:694 is rate.c:691 in wireless-testing.git]
> and started hostapd and let a station connect. (see attached log)

Yes, I understand how you can get here. But every time the assignment
here happens, the value is completely overwritten. And when we free it
here, we don't look at the value.

> > > +       rcu_read_lock();
> > > +       old = rcu_dereference(pubsta->rates);
> > 
> > Here's have a dereference.
> >  
> > >         rcu_assign_pointer(pubsta->rates, rates);
> > 
> > and here's an assignment. The assignment ought to be protected already
> > by some locking, presumably, so similarly is the rcu_dereference() which
> > then should just be rcu_dereference_protected()?

> The issue seems to be in ieee80211_add_station in net/mac80211/cfg.c.
> This function allocates, initializes and adds the new station for
> hostapd. And of course: the alloc and (rate_)init part is done without
> acquiring any special mac80211 locks. (just rtnl, genl and rdev->mtx).
> 
> [And why should it? After all, during initialization, the station is
> not yet in the station hash table.]
> 
> So, what else can be done? 
> 
> Obviously, the locking requirement needs to be added to the
> doc entry for rate_control_set_rates in include/net/mac80211.h.

I don't see that any bug can happen here right now, even without
locking.

> And one of the following changes:
> 
> 1. move the rate_control_rate_init after sta_info_insert_rcu
>    and remove the rcu_read_locks from rate_control_set_rates.
>    However then we would add an incomplete station (this can't be right?!).
> 
> 2. add rcu or other lock around rate_control_set_rates in
>    minstrel_update_rates() and minstrel_ht_update_rates().

Both seem wrong.

> 3. add a new function: rate_control_init_rates which is
>    reserved for this case and only does the assignment.

I like that.

> (4. use rcu_dereference_protected and test the rtnl_lock - really?)

Nah that'll never work anyway.

> (5. some other way?)

The problem here is that even the rcu_read_lock() around here that's
actually there in most cases *isn't* what's protecting this code. What's
protecting this assignment is the fact that we require drivers to not
call ieee80211_tx_status() concurrently (and if they call
ieee80211_tx_status_irqsafe() then we serialize via the tasklet.)

If this wasn't the case, then calling the function could cause
double-free or so by having two CPUs read the old pointer and both call
kfree_rcu() on it.

Actually, looking at this code, this does seem possible in minstrel_ht
because it also calls this from minstrel_ht_rate_update() (indirectly),
which is called from the RX path which I'm not sure we require to be not
concurrent with the TX status path? Most drivers probably don't call
them concurrently, but I haven't checked all of them.


So as you can see, the RCU warning is just the tip of the iceberg.

johannes


