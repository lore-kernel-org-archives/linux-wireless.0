Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www17.your-server.de ([213.133.104.17]:45267 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790Ab1KIVB7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 16:01:59 -0500
References: <1320431074.29441.25.camel@localhost.localdomain> <1320434727.3969.124.camel@jlt3.sipsolutions.net> <1320436165.29441.28.camel@localhost.localdomain> <1320837059.3845.35.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320837059.3845.35.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0 (iPod Mail 8C148)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <2DB46763-5AA5-478C-AA35-CA47F8BE4896@m3y3r.de> (sfid-20111109_220203_555714_B0DDE6EC)
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: v3.1 - WARNING: at net/mac80211/util.c:540 ieee80211_can_queue_work
Date: Wed, 9 Nov 2011 22:01:06 +0100
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 09.11.2011 um 12:10 schrieb Johannes Berg <johannes@sipsolutions.net>:

> On Fri, 2011-11-04 at 20:49 +0100, Thomas Meyer wrote:
>> Am Freitag, den 04.11.2011, 20:25 +0100 schrieb Johannes Berg:
>>> A little more ... anything really ... would be helpful.
>>> 
>> 
>> First time that I ever saw this WARNING. happened after 9 days uptime,
>> while suspending the machine to ram.
> 
> I don't suppose you can reproduce, can you? :-)

I can't reproduce the warning, sorry!

> 
>>>> [281558.898592] Pid: 0, comm: swapper Tainted: G        W   3.1.0 #3
>>>> [281558.898595] Call Trace:
>>>> [281558.898597]  <IRQ>  [<ffffffff8103024a>] warn_slowpath_common+0x7a/0xb0
>>>> [281558.898610]  [<ffffffff8105731d>] ? clockevents_program_event+0x5d/0xa0
>>>> [281558.898614]  [<ffffffff81030321>] warn_slowpath_fmt+0x41/0x50
>>>> [281558.898619]  [<ffffffff81058259>] ? tick_program_event+0x19/0x20
>>>> [281558.898624]  [<ffffffff8104d46e>] ? hrtimer_interrupt+0xfe/0x1f0
>>>> [281558.898633]  [<ffffffffa017fe45>] ieee80211_can_queue_work+0x35/0x40 [mac80211]
>>>> [281558.898642]  [<ffffffffa017ff9b>] ieee80211_queue_work+0x1b/0x40 [mac80211]
>>>> [281558.898651]  [<ffffffffa016bfdf>] ieee80211_sta_timer+0x2f/0x40 [mac80211]
>>>> [281558.898657]  [<ffffffff8103bb8f>] run_timer_softirq+0xef/0x210
>>>> [281558.898666]  [<ffffffffa016bfb0>] ? ieee80211_sta_bcn_mon_timer+0x40/0x40 [mac80211]
> 
> Interestingly, sta_bcn_mon_timer was there -- but I don't see how *that*
> caused it. I do, however, see how conn_mon_timer could cause it:
> 
> conn_mon_timer fired and queued monitor_work
> you suspended, invoking sta_quiesce, which *first* disables the timer
> and *then* cancels monitor_work synchronously -- that will run
> monitor_work and re-enable the timer ...
> 
> Mostly theoretical, if you can reproduce it (which I very much doubt)
> you could try the patch below.

Thanks. Will try the patch and see if this happens again.

> 
> johannes
> 
> --- wireless-testing.orig/net/mac80211/mlme.c    2011-11-09 12:05:44.000000000 +0100
> +++ wireless-testing/net/mac80211/mlme.c    2011-11-09 12:07:11.000000000 +0100
> @@ -2288,6 +2288,7 @@ void ieee80211_sta_quiesce(struct ieee80
> 
>    cancel_work_sync(&ifmgd->request_smps_work);
> 
> +    cancel_work_sync(&ifmgd->monitor_work);
>    cancel_work_sync(&ifmgd->beacon_connection_loss_work);
>    if (del_timer_sync(&ifmgd->timer))
>        set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
> @@ -2296,7 +2297,6 @@ void ieee80211_sta_quiesce(struct ieee80
>    if (del_timer_sync(&ifmgd->chswitch_timer))
>        set_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running);
> 
> -    cancel_work_sync(&ifmgd->monitor_work);
>    /* these will just be re-established on connection */
>    del_timer_sync(&ifmgd->conn_mon_timer);
>    del_timer_sync(&ifmgd->bcn_mon_timer);
> 
> 
