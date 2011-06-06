Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:56403 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757837Ab1FFQBU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 12:01:20 -0400
Date: Mon, 6 Jun 2011 18:01:15 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: sta_find_ibss (active_ibss=1) in a loop?
Message-ID: <20110606160115.GA31258@zenon.in.qult.net> (sfid-20110606_180128_355704_4074C9BA)
References: <20110603201644.GA7836@zenon.in.qult.net>
 <20110603204939.GA12854@zenon.in.qult.net>
 <20110606110429.GA18775@zenon.in.qult.net>
 <1307370716.3894.10.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1307370716.3894.10.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 06, 2011 at 04:31:56PM +0200, thus spake Johannes Berg:
> On Mon, 2011-06-06 at 13:04 +0200, Ignacy Gawedzki wrote:
> > Is flushing the local->sta_list in ieee80211_ibss_join() a good solution?
> 
> I think we should see how this situation happens. cfg80211 shouldn't be
> allowing a join while an IBSS is already joined, so the above situation
> you describe shouldn't be possible. Also, I don't see that it is
> possible that a station is added while in search state or not joined
> (BSSID should be zeroes).
> 
> Then again, it looks like it could be a race.

Given how difficult it is to reproduce, it smells like a race to me.

>                                               A station could be added
> while _leave() is in the middle of the flush. This is because
> ieee80211_ibss_add_sta() can't hold the mutex.

I see.

> Thus, the proper fix might be this:
> 
> --- wireless-testing.orig/net/mac80211/ibss.c	2011-06-06 12:25:06.000000000 +0200
> +++ wireless-testing/net/mac80211/ibss.c	2011-06-06 16:31:26.000000000 +0200
> @@ -965,6 +965,9 @@ int ieee80211_ibss_leave(struct ieee8021
>  
>  	mutex_lock(&sdata->u.ibss.mtx);
>  
> +	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
> +	sdata->u.ibss.state = IEEE80211_IBSS_MLME_SEARCH;
> +
>  	active_ibss = ieee80211_sta_active_ibss(sdata);
>  
>  	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
> @@ -999,7 +1002,6 @@ int ieee80211_ibss_leave(struct ieee8021
>  	kfree_skb(skb);
>  
>  	skb_queue_purge(&sdata->skb_queue);
> -	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
>  	sdata->u.ibss.ssid_len = 0;

Shouldn't that second line also move up with the memset?

>  
>  	del_timer_sync(&sdata->u.ibss.timer);

So this fix relies on the fact that reading sdata->i.ibss.state is an atomic
operation, right?

Thanks for the patch, I'll give it a try, though it may be some time until I
report further on this, since the problem is difficult to reproduce.

-- 
The groove will take you through times without money
much better than money will take you through times without groove.
