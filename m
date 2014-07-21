Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45393 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392AbaGUKbG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 06:31:06 -0400
Message-ID: <1405938640.32255.20.camel@jlt4.sipsolutions.net> (sfid-20140721_123110_957580_7631F41B)
Subject: Re: [PATCH] mac80211: Requeue work for all iftypes after scan
 completion
From: Johannes Berg <johannes@sipsolutions.net>
To: Sachin Kulkarni <Sachin.Kulkarni@imgtec.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 21 Jul 2014 12:30:40 +0200
In-Reply-To: <53CCEAD6.7030205@imgtec.com>
References: <82A67CC48AF04D43A69EB66645975134218BA7EE@hbmail01.hb.imgtec.org>
	  <53BEB909.3030802@imgtec.com>
	 <1405935434.32255.2.camel@jlt4.sipsolutions.net>
	 <53CCEAD6.7030205@imgtec.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-07-21 at 15:56 +0530, Sachin Kulkarni wrote:
> On 07/21/2014 03:07 PM, Johannes Berg wrote:
> > On Thu, 2014-07-10 at 21:32 +0530, Sachin Kulkarni wrote:
> >> From: Sachin Kulkarni<sachin.kulkarni@imgtec.com>
> >>
> >> During a hw scan ieee80211_iface_work ignores work items for all vifs. However
> >> after the scan complete work is requeued only for STA, ADHOC and MESH iftypes.
> >> This occasionally results in event processing getting delayed for iftype AP when
> >> it coexists with a STA, and when the scan durations are very long.
> >>
> >> Signed-off-by: Sachin Kulkarni<sachin.kulkarni@imgtec.com>
> >> Cc: linux-wireless@vger.kernel.org
> >> Cc: johannes@sipsolutions.net
> >> ---
> >> We have a test scenario where there are 2 VIFs: one STA and one AP. The STA is
> >> not connected to anyone while the AP has a station connected to it. The hardware
> >> we are using currently has scan durations of ~8 sec and a new scan request is
> >> generated every 10 s. This results in a window of only 2 s when work items can
> >> be processed by ieee80211_iface_work. We came across scenarios where the AP is
> >> trying to tear down a AMPDU session, and the IEEE80211_SDATA_QUEUE_AGG_STOP
> >> event gets queued. However the work item for this gets ignored by the ieee80211_iface_work
> >> since a hw scan is in progress most of the time. When the scan completes however
> >> the work item for the AP does not get requeued, and by the time the
> >> IEEE80211_SDATA_QUEUE_AGG_STOP gets processed in some other work items context,
> >> the TX frames just keep getting queued up, since the tid has not been destroyed.
> >> This results in disconnections since things like ARP timeouts etc start
> >> happening.
> >> ---
> >>    net/mac80211/mlme.c |    5 +++--
> >>    1 files changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> >> index 931330b..49af420 100644
> >> --- a/net/mac80211/mlme.c
> >> +++ b/net/mac80211/mlme.c
> >> @@ -3647,9 +3647,10 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
> >>    		if (!(flags&   IEEE80211_HW_CONNECTION_MONITOR))
> >>    			ieee80211_queue_work(&sdata->local->hw,
> >>    					&sdata->u.mgd.monitor_work);
> >> -		/* and do all the other regular work too */
> >> -		ieee80211_queue_work(&sdata->local->hw,&sdata->work);
> >>    	}
> >> +
> >> +	/* and do all the other regular work too */
> >> +	ieee80211_queue_work(&sdata->local->hw,&sdata->work);
> > Please fix the space while at it. :)
> Thanks for getting back Johannes. Just a quick question. When you said 
> "..fix the space.." did you mean the spaces in the following lines:
> 
>    		if (!(flags&   IEEE80211_HW_CONNECTION_MONITOR))
>    			ieee80211_queue_work(&sdata->local->hw,
>    					&sdata->u.mgd.monitor_work);
> 
> 
> or the newline I introduced here:
> 
> +
> +	/* and do all the other regular work too */
> +	ieee80211_queue_work(&sdata->local->hw,&sdata->work);

You should have a space after the comma

johannes

