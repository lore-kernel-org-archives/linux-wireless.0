Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:37409 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab3DWN0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 09:26:55 -0400
Received: by mail-bk0-f52.google.com with SMTP id it16so259923bkc.39
        for <linux-wireless@vger.kernel.org>; Tue, 23 Apr 2013 06:26:54 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix spurious use of rcu_dereference
Date: Tue, 23 Apr 2013 15:26:47 +0200
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	karl.beldan@gmail.com
References: <1366640083-1054-1-git-send-email-nbd@openwrt.org> <201304230258.08359.chunkeey@googlemail.com> <1366699708.8385.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1366699708.8385.1.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201304231526.47996.chunkeey@googlemail.com> (sfid-20130423_152701_844367_A194E484)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, April 23, 2013 08:48:28 AM Johannes Berg wrote:
> On Tue, 2013-04-23 at 02:58 +0200, Christian Lamparter wrote:
> > This patch fixes the following RCU debug splat:
> > 
> > ===============================
> > [ INFO: suspicious RCU usage. ]
> > 3.9.0-rc8-wl+ #31 Tainted: G           O
> > -------------------------------
> > net/mac80211/rate.c:691 suspicious rcu_dereference_check() usage!
> > 
> > other info that might help us debug this:
> >  
> > rcu_scheduler_active = 1, debug_locks = 1
> >  3 locks held by hostapd/9451:
> >  #0:  (genl_mutex){+.+.+.}, at: [<c1326365>] genl_lock+0xf/0x11
> >  #1:  (rtnl_mutex){+.+.+.}, at: [<c13133c4>] rtnl_lock+0xf/0x11
> >  #2:  (&rdev->mtx){+.+.+.}, at: [<f853395e>] nl80211_pre_doit+0x166/0x180 [cfg80211]
> > 
> > stack backtrace:
> > Pid: 9451, comm: hostapd Tainted: G           O 3.9.0-rc8-wl+ #31
> > Call Trace:
> >  [<c107da0b>] lockdep_rcu_suspicious+0xe6/0xee
> >  [<f8bf82ad>] rate_control_set_rates+0x43/0x5a [mac80211]
> >  [<f8c2cacb>] minstrel_update_rates+0xdc/0xe2 [mac80211]
> >  [<f8c2cfb0>] minstrel_rate_init+0x24c/0x33d [mac80211]
> >  [<f8c2d9d3>] minstrel_ht_update_caps+0x206/0x234 [mac80211]
> >  [<c1080a8d>] ? lock_release+0x1c9/0x226
> >  [<f8c2da25>] minstrel_ht_rate_init+0x10/0x14 [mac80211]
> >  [...]
> > 
> > Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> > ---
> > Actually, rcu_read_lock() might not be necessary in this special
> > case [the RC is not yet initialized, so nothing bad can happen].
> > 
> > But, since the rcu_read_lock() has a low overhead and
> > rate_control_set_rates mac80211.h doc does not mention
> > anything about locking, I think this is a viable way. 
> 
> I think that, on the contrary, it's completely strange/wrong. ;-)
Sorry, I think I cut too much from the stack trace and I didn't
explain how the code end up in this case. This time, I commented out
the rcu_read_(un)lock() [=> rate.c:694 is rate.c:691 in wireless-testing.git]
and started hostapd and let a station connect. (see attached log)
 
> > +       rcu_read_lock();
> > +       old = rcu_dereference(pubsta->rates);
> 
> Here's have a dereference.
>  
> >         rcu_assign_pointer(pubsta->rates, rates);
> 
> and here's an assignment. The assignment ought to be protected already
> by some locking, presumably, so similarly is the rcu_dereference() which
> then should just be rcu_dereference_protected()?
The issue seems to be in ieee80211_add_station in net/mac80211/cfg.c.
This function allocates, initializes and adds the new station for
hostapd. And of course: the alloc and (rate_)init part is done without
acquiring any special mac80211 locks. (just rtnl, genl and rdev->mtx).

[And why should it? After all, during initialization, the station is
not yet in the station hash table.]

So, what else can be done? 

Obviously, the locking requirement needs to be added to the
doc entry for rate_control_set_rates in include/net/mac80211.h.

And one of the following changes:

1. move the rate_control_rate_init after sta_info_insert_rcu
   and remove the rcu_read_locks from rate_control_set_rates.
   However then we would add an incomplete station (this can't be right?!).

2. add rcu or other lock around rate_control_set_rates in
   minstrel_update_rates() and minstrel_ht_update_rates().

3. add a new function: rate_control_init_rates which is
   reserved for this case and only does the assignment.

(4. use rcu_dereference_protected and test the rtnl_lock - really?)

(5. some other way?)
 
Regards,
	Christian

---
===============================
[ INFO: suspicious RCU usage. ]
3.9.0-rc8-wl+ #32 Tainted: G           O
------------------------------
net/mac80211/rate.c:694 suspicious rcu_dereference_check() usage!
 
other info that might help us debug this:
 
rcu_scheduler_active = 1, debug_locks = 1
3 locks held by hostapd/2906:
  #0:  (genl_mutex){+.+.+.}, at: [<c1326365>] genl_lock+0xf/0x11
  #1:  (rtnl_mutex){+.+.+.}, at: [<c13133c4>] rtnl_lock+0xf/0x11
  #2:  (&rdev->mtx){+.+.+.}, at: [<f852195e>] nl80211_pre_doit+0x166/0x180 [cfg80211]
 
stack backtrace:
Pid: 2906, comm: hostapd Tainted: G           O 3.9.0-rc8-wl+ #32
Call Trace:
  [<c107da0b>] lockdep_rcu_suspicious+0xe6/0xee
  [<f884835f>] rate_control_set_rates+0x43/0x5a [mac80211]
  [<f8882e52>] minstrel_ht_update_rates+0x9f/0xa7 [mac80211]
  [<f88833ec>] minstrel_ht_update_caps+0x1cf/0x234 [mac80211]
  [<c1080a8d>] ? lock_release+0x1c9/0x226
  [<f8883475>] minstrel_ht_rate_init+0x10/0x14 [mac80211]
  [<f884d326>] rate_control_rate_init+0xc4/0xd8 [mac80211]
  [<f884e219>] ieee80211_add_station+0xdc/0x11b [mac80211]
  [<f8526595>] nl80211_new_station+0x27e/0x2c7 [cfg80211]
  [<c132653d>] genl_rcv_msg+0x1b6/0x1ee
  [<c1326387>] ? genl_rcv+0x20/0x20

[The full unaltered trace is available at: <http://pastebin.com/gYc8yAqB>]
