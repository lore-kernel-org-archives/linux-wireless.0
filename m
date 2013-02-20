Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933631Ab3BTO1v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 09:27:51 -0500
Message-ID: <1361370467.8629.21.camel@jlt4.sipsolutions.net> (sfid-20130220_152759_341984_BE117470)
Subject: Re: [PATCH] mac80211:  Clean up work-queues on disassociation.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 Feb 2013 15:27:47 +0100
In-Reply-To: <5124DCA0.6030106@candelatech.com>
References: <1361326267-16847-1-git-send-email-greearb@candelatech.com>
	   (sfid-20130220_031220_995074_BF5628B4) <1361354394.8629.11.camel@jlt4.sipsolutions.net>
	  <5124D90E.7070307@candelatech.com>
	 <1361369637.8629.20.camel@jlt4.sipsolutions.net>
	 <5124DCA0.6030106@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-20 at 06:24 -0800, Ben Greear wrote:
> On 02/20/2013 06:13 AM, Johannes Berg wrote:
> > On Wed, 2013-02-20 at 06:09 -0800, Ben Greear wrote:
> >
> >>>> @@ -2668,6 +2681,10 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
> >>>>    			       false, frame_buf);
> >>>>    	mutex_unlock(&ifmgd->mtx);
> >>>>
> >>>> +	/* Have to do this outside the ifmgd->mtx lock. */
> >>>> +	cancel_work_sync(&ifmgd->monitor_work);
> >>>> +	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
> >>>
> >>> OTOH, you do this many many times, and that doesn't seem necessary...
> >>>
> >>> If the work structs run when we disconnected, that's ok, they just
> >>> musn't run after we destroy the interface, so I think it'd be much
> >>> better to just put the two lines into ieee80211_mgd_stop() instead of
> >>> all the other places.
> >>
> >> Ok, that sounds promising to me.  For that matter, could we just call the sta_quiesce
> >> method in mgd_stop?  It would be nice to have all of the final timer and work-queue cleanup
> >> in a single place.
> >
> > That might be interesting, but I think we'd have to clear the
> > timer_pending thing afterwards?
> 
> Are you talking about this code?
> 
> 	if (del_timer_sync(&ifmgd->timer))
> 		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
> 
> 	if (del_timer_sync(&ifmgd->chswitch_timer))
> 		set_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running);
> 
> If so, maybe make a helper method that does all of the first part of the sta_quiesce()
> logic, call that from both mgd_stop and the new sta_quiesce() method, and then have
> sta_quiesce look like:
> 
>          sta_cleanup_timers_and_work();
>          if (del_timer_sync(&ifmgd->timer))
> 		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
> 
> 	if (del_timer_sync(&ifmgd->chswitch_timer))
> 		set_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running);

What part of that would then be "cleanup_timers"?

No, I think you should just look at it and set timers_running = 0 after
calling the function, or so.

johannes

