Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39530 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab1KILLE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 06:11:04 -0500
Subject: Re: v3.1 - WARNING: at net/mac80211/util.c:540
 ieee80211_can_queue_work
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1320436165.29441.28.camel@localhost.localdomain>
References: <1320431074.29441.25.camel@localhost.localdomain>
	 <1320434727.3969.124.camel@jlt3.sipsolutions.net>
	 <1320436165.29441.28.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Nov 2011 12:10:59 +0100
Message-ID: <1320837059.3845.35.camel@jlt3.sipsolutions.net> (sfid-20111109_121108_801987_FFA0BE17)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-04 at 20:49 +0100, Thomas Meyer wrote:
> Am Freitag, den 04.11.2011, 20:25 +0100 schrieb Johannes Berg:
> > A little more ... anything really ... would be helpful.
> > 
> 
> First time that I ever saw this WARNING. happened after 9 days uptime,
> while suspending the machine to ram.

I don't suppose you can reproduce, can you? :-)

> > > [281558.898592] Pid: 0, comm: swapper Tainted: G        W   3.1.0 #3
> > > [281558.898595] Call Trace:
> > > [281558.898597]  <IRQ>  [<ffffffff8103024a>] warn_slowpath_common+0x7a/0xb0
> > > [281558.898610]  [<ffffffff8105731d>] ? clockevents_program_event+0x5d/0xa0
> > > [281558.898614]  [<ffffffff81030321>] warn_slowpath_fmt+0x41/0x50
> > > [281558.898619]  [<ffffffff81058259>] ? tick_program_event+0x19/0x20
> > > [281558.898624]  [<ffffffff8104d46e>] ? hrtimer_interrupt+0xfe/0x1f0
> > > [281558.898633]  [<ffffffffa017fe45>] ieee80211_can_queue_work+0x35/0x40 [mac80211]
> > > [281558.898642]  [<ffffffffa017ff9b>] ieee80211_queue_work+0x1b/0x40 [mac80211]
> > > [281558.898651]  [<ffffffffa016bfdf>] ieee80211_sta_timer+0x2f/0x40 [mac80211]
> > > [281558.898657]  [<ffffffff8103bb8f>] run_timer_softirq+0xef/0x210
> > > [281558.898666]  [<ffffffffa016bfb0>] ? ieee80211_sta_bcn_mon_timer+0x40/0x40 [mac80211]

Interestingly, sta_bcn_mon_timer was there -- but I don't see how *that*
caused it. I do, however, see how conn_mon_timer could cause it:

conn_mon_timer fired and queued monitor_work
you suspended, invoking sta_quiesce, which *first* disables the timer
and *then* cancels monitor_work synchronously -- that will run
monitor_work and re-enable the timer ...

Mostly theoretical, if you can reproduce it (which I very much doubt)
you could try the patch below.

johannes

--- wireless-testing.orig/net/mac80211/mlme.c	2011-11-09 12:05:44.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2011-11-09 12:07:11.000000000 +0100
@@ -2288,6 +2288,7 @@ void ieee80211_sta_quiesce(struct ieee80
 
 	cancel_work_sync(&ifmgd->request_smps_work);
 
+	cancel_work_sync(&ifmgd->monitor_work);
 	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
 	if (del_timer_sync(&ifmgd->timer))
 		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
@@ -2296,7 +2297,6 @@ void ieee80211_sta_quiesce(struct ieee80
 	if (del_timer_sync(&ifmgd->chswitch_timer))
 		set_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running);
 
-	cancel_work_sync(&ifmgd->monitor_work);
 	/* these will just be re-established on connection */
 	del_timer_sync(&ifmgd->conn_mon_timer);
 	del_timer_sync(&ifmgd->bcn_mon_timer);


