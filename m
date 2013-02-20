Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51074 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934593Ab3BTOOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 09:14:04 -0500
Message-ID: <1361369637.8629.20.camel@jlt4.sipsolutions.net> (sfid-20130220_151408_025211_3FDE6D1C)
Subject: Re: [PATCH] mac80211:  Clean up work-queues on disassociation.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 Feb 2013 15:13:57 +0100
In-Reply-To: <5124D90E.7070307@candelatech.com>
References: <1361326267-16847-1-git-send-email-greearb@candelatech.com>
	  (sfid-20130220_031220_995074_BF5628B4) <1361354394.8629.11.camel@jlt4.sipsolutions.net>
	 <5124D90E.7070307@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-20 at 06:09 -0800, Ben Greear wrote:

> >> @@ -2668,6 +2681,10 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
> >>   			       false, frame_buf);
> >>   	mutex_unlock(&ifmgd->mtx);
> >>
> >> +	/* Have to do this outside the ifmgd->mtx lock. */
> >> +	cancel_work_sync(&ifmgd->monitor_work);
> >> +	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
> >
> > OTOH, you do this many many times, and that doesn't seem necessary...
> >
> > If the work structs run when we disconnected, that's ok, they just
> > musn't run after we destroy the interface, so I think it'd be much
> > better to just put the two lines into ieee80211_mgd_stop() instead of
> > all the other places.
> 
> Ok, that sounds promising to me.  For that matter, could we just call the sta_quiesce
> method in mgd_stop?  It would be nice to have all of the final timer and work-queue cleanup
> in a single place.

That might be interesting, but I think we'd have to clear the
timer_pending thing afterwards?

> And, maybe add some checks in the work-callback methods to bail early if the station
> isn't connected?

They already do :)

johannes

