Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19346 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbZLWSdx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 13:33:53 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 10:33:53 -0800
Date: Wed, 23 Dec 2009 10:33:51 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Asus eeepc 1008HA suspend issue and mac80211 suspend corner
 case
Message-ID: <20091223183351.GF2609@tux>
References: <20091222022355.GA32508@bombadil.infradead.org>
 <19248.19829.293087.367661@gargle.gargle.HOWL>
 <20091222155005.GA4385@tux>
 <20091222162055.GC4385@tux>
 <20091222165528.GE4385@tux>
 <20091222175939.GF4385@tux>
 <43e72e890912221716r64ea4542qd747302b536a3156@mail.gmail.com>
 <19249.34294.19925.963051@gargle.gargle.HOWL>
 <43e72e890912221854s5f06a0d2jcfffb1cc8d857347@mail.gmail.com>
 <19249.41596.778604.908714@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <19249.41596.778604.908714@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 22, 2009 at 08:54:20PM -0800, Sujith Manoharan wrote:
> Luis Rodriguez wrote:
> > Did you see the last one? It turns out its the only config option
> > passed by mac8021 I've seen so far so my commit log should change.
> 
> Right, that patch should work.
> So the one I sent out and this one fixes the issue ?

Actually the last one alone fixes the issue, likely because harware is not
failing on the routines during the stop() callback when stopping harware, that
is theese guys don't fail if in NETWORK_SLEEP it seems:

        ath9k_hw_disable(ah);
        ath9k_hw_configpcipowersave(ah, 1, 1);
        ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);

This is likely due to lack of proper documentation on our part of which
hardware blocks exactly cannot be accessed when the devices is in
NETWORK_SLEEP. But to be safe its better to just sprinkly the ps_awake
/resume calls where we do see harware being poked. If we find details
on this question though we can likely enhance power saving more
and do some operations even while in NETWORK_SLEEP.

Then as for the core of the issue -- it was not ath9k anyway, the last
patch I posted indeed fixes the issue but mac80211 drivers should not have
to worry about such issues.

As it turns out mac80211 is scheduling the dynamic_ps_disable_work work
after the driver stop() call has been called. This exposes two issues then
on mac80211. But to elaborate on those let me paste the some relevants
parts of pm.c __ieee80211_suspend():

int __ieee80211_suspend(struct ieee80211_hw *hw)
{
	...
        ieee80211_stop_queues_by_reason(hw,
                        IEEE80211_QUEUE_STOP_REASON_SUSPEND);

        /* flush out all packets */
        synchronize_net();

        local->quiescing = true;
        /* make quiescing visible to timers everywhere */
        mb();

        flush_workqueue(local->workqueue);
	...

        /* stop hardware - this must stop RX */
        if (local->open_count)
                ieee80211_stop_device(local);

        local->suspended = true;
        /* need suspended to be visible before quiescing is false */
        barrier();
        local->quiescing = false;

        return 0;
}

The issues are as follows:

1) We stop TX and flush all packets out, and then call the driver stop().
   Unfortunately there is a failed assumption that even ieee80211_xmit()
   would not be called after stopping TX as __ieee80211_suspend() does
   above.
2) Since ieee80211_xmit() is being called even after the driver stop()
   callback it means mac80211 can potentially schedule work. Now the
   new rework on the mac80211 workqueue pushes us to WARN when either
   a driver or mac80211 tried to queue work onto the mac80211 workqueue
   and we're suspended. A new patch from Johannes futher enhances this
   to take into consideration resume so that we can allow drivers / mac80211
   to queue work if we were suspended but now resuming. Even with these
   checks in place I note that currently we do slip work through after
   the driver stop() callback is called and before loacl->suspended is
   set to true. So there seems to be a race here.

The first issue is not so clear to resolve as although we likely do prevent
the networking core from calling ieee80211_subif_start_xmit() it doesn't
mean ieee80211_xmit() internally will not be called by other parts of
mac80211 and indeed I do believe this is what is happening. I'll try
pin point the exact spot where this happens though, but I'll note though
that checking for local->suspended will *not* work since we already know
some work is being queued *and running!* and it wouldn't have if
local->suspended was true already.

static bool ieee80211_can_queue_work(struct ieee80211_local *local)
{
        if (WARN(local->suspended && !local->resuming,
                 "queueing ieee80211 work while going to suspend\n"))
                return false;

        return true;
}

void ieee80211_queue_work(struct ieee80211_hw *hw, struct work_struct *work)
{
        struct ieee80211_local *local = hw_to_local(hw);

        if (!ieee80211_can_queue_work(local))
                return;

        queue_work(local->workqueue, work);
}
EXPORT_SYMBOL(ieee80211_queue_work);

The second issue can likely be fixed by fixing the first one.

  Luis
