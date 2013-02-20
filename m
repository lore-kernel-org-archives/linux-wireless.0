Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50360 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab3BTKAE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 05:00:04 -0500
Message-ID: <1361354394.8629.11.camel@jlt4.sipsolutions.net> (sfid-20130220_110010_972785_9525A200)
Subject: Re: [PATCH] mac80211:  Clean up work-queues on disassociation.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 Feb 2013 10:59:54 +0100
In-Reply-To: <1361326267-16847-1-git-send-email-greearb@candelatech.com> (sfid-20130220_031220_995074_BF5628B4)
References: <1361326267-16847-1-git-send-email-greearb@candelatech.com>
	 (sfid-20130220_031220_995074_BF5628B4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> In addition, re-order the quiesce code so that timers are
> always stopped before work-items are flushed.  This was
> not the problem I saw, but I think it may still be more
> correct.

I'd prefer this to be a separate patch, and then might not apply that
one for 3.9

> NOTE:  Please do not apply this until it is reviewed by Johannes,
> at least.

No worries - I have my own mac80211 tree so nobody else will apply it
anyway :)

> @@ -2618,6 +2625,12 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
>  	}
>  	mutex_unlock(&ifmgd->mtx);
>  
> +	if (cancel_work) {
> +		/* Have to do this outside the ifmgd->mtx lock. */
> +		cancel_work_sync(&ifmgd->monitor_work);
> +		cancel_work_sync(&ifmgd->beacon_connection_loss_work);
> +	}

It might make more sense to move this into the disassoc/deauth case
below?

>  	switch (rma) {
>  	case RX_MGMT_NONE:
>  		/* no action */

> @@ -2668,6 +2681,10 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
>  			       false, frame_buf);
>  	mutex_unlock(&ifmgd->mtx);
>  
> +	/* Have to do this outside the ifmgd->mtx lock. */
> +	cancel_work_sync(&ifmgd->monitor_work);
> +	cancel_work_sync(&ifmgd->beacon_connection_loss_work);

OTOH, you do this many many times, and that doesn't seem necessary...

If the work structs run when we disconnected, that's ok, they just
musn't run after we destroy the interface, so I think it'd be much
better to just put the two lines into ieee80211_mgd_stop() instead of
all the other places.

johannes

