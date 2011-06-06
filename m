Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48685 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883Ab1FFOcA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 10:32:00 -0400
Subject: Re: sta_find_ibss (active_ibss=1) in a loop?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ignacy Gawedzki <i@lri.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110606110429.GA18775@zenon.in.qult.net> (sfid-20110606_130435_455828_E01BDAF0)
References: <20110603201644.GA7836@zenon.in.qult.net>
	 <20110603204939.GA12854@zenon.in.qult.net>
	 <20110606110429.GA18775@zenon.in.qult.net>
	 (sfid-20110606_130435_455828_E01BDAF0)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 16:31:56 +0200
Message-ID: <1307370716.3894.10.camel@jlt3.sipsolutions.net> (sfid-20110606_163205_234084_CC660C8D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-06 at 13:04 +0200, Ignacy Gawedzki wrote:

> After looking more in details at the code, I think I'm getting closer to a
> proper diagnostic.

Thanks for digging into this.

> The state is changed to MLME_SEARCH when ieee80211_ibss_join() is called from
> ieee80211_join_ibss() in cfg.c.  I suppose this is what's called when an
> application asks the kernel to make the interface join an IBSS.  Since in that
> state no new STA can be added to local->sta_list, if there were no STA at all,
> there's no last_rx to update and consequently ieee80211_sta_active_ibss()
> returns 0 and ieee80211_sta_find_ibss() may proceed.
> 
> But apparently, if there are still some remaining STAs in local->sta_list,
> their last_rx is updated upon reception of a frame from them, so if they are
> transmitting frames often enough, ieee80211_sta_active_ibss() won't ever
> return 0 and ieee80211_sta_find_ibss() won't be able to proceed at all, which
> will keep the interface in the MLME_SEARCH state and hence the loop.
> 
> So how comes there are remaining STAs in local->sta_list?  When
> ieee80211_ibss_leave() is called from ieee80211_leave_ibss() in cfg.c,
> sta_info_flush() is called and there are no remaining STAs.  But what if
> ieee80211_ibss_join() is called without prior call to ieee80211_ibss_leave()?
> I suppose this is when it goes wrong.

I don't think this can happen.

> Is flushing the local->sta_list in ieee80211_ibss_join() a good solution?

I think we should see how this situation happens. cfg80211 shouldn't be
allowing a join while an IBSS is already joined, so the above situation
you describe shouldn't be possible. Also, I don't see that it is
possible that a station is added while in search state or not joined
(BSSID should be zeroes).

Then again, it looks like it could be a race. A station could be added
while _leave() is in the middle of the flush. This is because
ieee80211_ibss_add_sta() can't hold the mutex.

Thus, the proper fix might be this:

--- wireless-testing.orig/net/mac80211/ibss.c	2011-06-06 12:25:06.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2011-06-06 16:31:26.000000000 +0200
@@ -965,6 +965,9 @@ int ieee80211_ibss_leave(struct ieee8021
 
 	mutex_lock(&sdata->u.ibss.mtx);
 
+	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
+	sdata->u.ibss.state = IEEE80211_IBSS_MLME_SEARCH;
+
 	active_ibss = ieee80211_sta_active_ibss(sdata);
 
 	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
@@ -999,7 +1002,6 @@ int ieee80211_ibss_leave(struct ieee8021
 	kfree_skb(skb);
 
 	skb_queue_purge(&sdata->skb_queue);
-	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
 	sdata->u.ibss.ssid_len = 0;
 
 	del_timer_sync(&sdata->u.ibss.timer);


johannes

