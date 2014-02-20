Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60227 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaBTKGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 05:06:13 -0500
Message-ID: <1392890764.5073.24.camel@jlt4.sipsolutions.net> (sfid-20140220_110618_183544_FDEAA1E5)
Subject: Re: [PATCH 3.14] mac80211: fix AP powersave TX vs. wakeup race
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Thu, 20 Feb 2014 11:06:04 +0100
In-Reply-To: <1392889368.5073.17.camel@jlt4.sipsolutions.net> (sfid-20140220_104256_666518_C373168B)
References: <1392886365-31206-1-git-send-email-johannes@sipsolutions.net>
	 <20140220092154.GD23439@redhat.com>
	 <1392888468.5073.11.camel@jlt4.sipsolutions.net>
	 <20140220094057.GE23439@redhat.com>
	 <1392889368.5073.17.camel@jlt4.sipsolutions.net>
	 (sfid-20140220_104256_666518_C373168B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 10:42 +0100, Johannes Berg wrote:
> On Thu, 2014-02-20 at 10:40 +0100, Stanislaw Gruszka wrote:
> 
> > > This area is a bit confusing, but I don't think WLAN_STA_PS_STA will be
> > > clear until after WLAN_STA_PS_DRIVER is?
> > 
> > Hmm, actually looks like we call ps_deliver_wakeup() with WLAN_STA_PS_STA
> > flag currently cleared.
> > 
> > tatic void sta_unblock(struct work_struct *wk)
> > {
> >         if (!test_sta_flag(sta, WLAN_STA_PS_STA)) {
> >                 local_bh_disable();
> >                 ieee80211_sta_ps_deliver_wakeup(sta);
> >                 local_bh_enable();
> > 
> > so on TX we should rather check WLAN_STA_PS_DRIVER flag .
> 
> But that flag may never be set if the driver doesn't support/use it
> (which means it's racy, but anyway), so we need to check both.
> 
> Now I'm confused though. It seems the intent here was to clear the
> WLAN_STA_PS_STA flag in something like sta_ps_end() in the RX path, but
> we don't do that. I'm not sure how it works now, but I know from testing
> that it does ;-)

Looks like I broke that in commit
50a9432daeece6fc1309bef1dc0a7b8fde8204cb ("mac80211: fix powersaving
clients races") and simply don't have a test case for the following
scenario:
 1. client goes to sleep with frames on HW queue
 2. driver blocks wakeup
 3. client wakes up
 4. driver unblocks wakeup

Instead, we always get the steps 3/4 reversed, so nothing happens.

I'll try to write a test for that, but the fix would have to be
something like the below.

johannes

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3701930c6649..5e44e3179e02 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1692,14 +1692,8 @@ void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
 void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue);
 void ieee80211_add_pending_skb(struct ieee80211_local *local,
 			       struct sk_buff *skb);
-void ieee80211_add_pending_skbs_fn(struct ieee80211_local *local,
-				   struct sk_buff_head *skbs,
-				   void (*fn)(void *data), void *data);
-static inline void ieee80211_add_pending_skbs(struct ieee80211_local *local,
-					      struct sk_buff_head *skbs)
-{
-	ieee80211_add_pending_skbs_fn(local, skbs, NULL, NULL);
-}
+void ieee80211_add_pending_skbs(struct ieee80211_local *local,
+				struct sk_buff_head *skbs);
 void ieee80211_flush_queues(struct ieee80211_local *local,
 			    struct ieee80211_sub_if_data *sdata);
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c24ca0d0f469..841636e657ab 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1127,6 +1127,8 @@ static void sta_ps_end(struct sta_info *sta)
 	ps_dbg(sta->sdata, "STA %pM aid %d exits power save mode\n",
 	       sta->sta.addr, sta->sta.aid);
 
+	ieee80211_clear_sta_ps_flag(sta);
+
 	if (test_sta_flag(sta, WLAN_STA_PS_DRIVER)) {
 		ps_dbg(sta->sdata, "STA %pM aid %d driver-ps-blocked\n",
 		       sta->sta.addr, sta->sta.aid);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index ffc1ee6a2ec1..86840c2f984a 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1090,9 +1090,8 @@ struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL(ieee80211_find_sta);
 
-static void clear_sta_ps_flags(void *_sta)
+void ieee80211_clear_sta_ps_flag(struct sta_info *sta)
 {
-	struct sta_info *sta = _sta;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ps_data *ps;
 
@@ -1104,7 +1103,6 @@ static void clear_sta_ps_flags(void *_sta)
 	else
 		return;
 
-	clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
 	if (test_and_clear_sta_flag(sta, WLAN_STA_PS_STA))
 		atomic_dec(&ps->num_sta_ps);
 }
@@ -1148,7 +1146,9 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 		buffered += tmp - count;
 	}
 
-	ieee80211_add_pending_skbs_fn(local, &pending, clear_sta_ps_flags, sta);
+	ieee80211_add_pending_skbs(local, &pending);
+	ieee80211_clear_sta_ps_flag(sta);
+	clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
 	spin_unlock(&sta->ps_lock);
 
 	/* This station just woke up and isn't aware of our SMPS state */
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index d3a6d8208f2f..afe8d43dff14 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -630,6 +630,7 @@ void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 			  unsigned long exp_time);
 u8 sta_info_tx_streams(struct sta_info *sta);
 
+void ieee80211_clear_sta_ps_flag(struct sta_info *sta);
 void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta);
 void ieee80211_sta_ps_deliver_poll_response(struct sta_info *sta);
 void ieee80211_sta_ps_deliver_uapsd(struct sta_info *sta);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 1d1bb7084c05..b8700d417a9c 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -435,9 +435,8 @@ void ieee80211_add_pending_skb(struct ieee80211_local *local,
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
-void ieee80211_add_pending_skbs_fn(struct ieee80211_local *local,
-				   struct sk_buff_head *skbs,
-				   void (*fn)(void *data), void *data)
+void ieee80211_add_pending_skbs(struct ieee80211_local *local,
+				struct sk_buff_head *skbs)
 {
 	struct ieee80211_hw *hw = &local->hw;
 	struct sk_buff *skb;
@@ -461,9 +460,6 @@ void ieee80211_add_pending_skbs_fn(struct ieee80211_local *local,
 		__skb_queue_tail(&local->pending[queue], skb);
 	}
 
-	if (fn)
-		fn(data);
-
 	for (i = 0; i < hw->queues; i++)
 		__ieee80211_wake_queue(hw, i,
 			IEEE80211_QUEUE_STOP_REASON_SKB_ADD);


