Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60387 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbaBTKyW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 05:54:22 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 3.14] mac80211: fix station wakeup powersave race
Date: Thu, 20 Feb 2014 11:54:17 +0100
Message-Id: <1392893657-26487-1-git-send-email-johannes@sipsolutions.net> (sfid-20140220_115439_806653_31B9AC50)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Consider the following (relatively unlikely) scenario:
 1) station goes to sleep while frames are buffered in driver
 2) driver blocks wakeup (until no more frames are buffered)
 3) station wakes up again
 4) driver unblocks wakeup

In this case, the current mac80211 code will do the following:
 1) WLAN_STA_PS_STA set
 2) WLAN_STA_PS_DRIVER set
 3) - nothing -
 4) WLAN_STA_PS_DRIVER cleared

As a result, no frames will be delivered to the client, even
though it is awake, until it sends another frame to us that
triggers ieee80211_sta_ps_deliver_wakeup() in sta_ps_end().

Since we now take the PS spinlock, we can fix this while at
the same time removing the complexity with the pending skb
queue function. This was broken since my commit 50a9432daeec
("mac80211: fix powersaving clients races") due to removing
the clearing of WLAN_STA_PS_STA in the RX path.

While at it, fix a cleanup path issue when a station is
removed while the driver is still blocking its wakeup.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 10 ++--------
 net/mac80211/rx.c          |  7 +++++++
 net/mac80211/sta_info.c    | 32 ++++++++++++++------------------
 net/mac80211/util.c        |  8 ++------
 4 files changed, 25 insertions(+), 32 deletions(-)

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
index c24ca0d0f469..3e57f96c9666 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1128,6 +1128,13 @@ static void sta_ps_end(struct sta_info *sta)
 	       sta->sta.addr, sta->sta.aid);
 
 	if (test_sta_flag(sta, WLAN_STA_PS_DRIVER)) {
+		/*
+		 * Clear the flag only if the other one is still set
+		 * so that the TX path won't start TX'ing new frames
+		 * directly ... In the case that the driver flag isn't
+		 * set ieee80211_sta_ps_deliver_wakeup() will clear it.
+		 */
+		clear_sta_flag(sta, WLAN_STA_PS_STA);
 		ps_dbg(sta->sdata, "STA %pM aid %d driver-ps-blocked\n",
 		       sta->sta.addr, sta->sta.aid);
 		return;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index ffc1ee6a2ec1..a023b432143b 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -99,7 +99,8 @@ static void __cleanup_single_sta(struct sta_info *sta)
 	struct ieee80211_local *local = sdata->local;
 	struct ps_data *ps;
 
-	if (test_sta_flag(sta, WLAN_STA_PS_STA)) {
+	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
+	    test_sta_flag(sta, WLAN_STA_PS_DRIVER)) {
 		if (sta->sdata->vif.type == NL80211_IFTYPE_AP ||
 		    sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 			ps = &sdata->bss->ps;
@@ -109,6 +110,7 @@ static void __cleanup_single_sta(struct sta_info *sta)
 			return;
 
 		clear_sta_flag(sta, WLAN_STA_PS_STA);
+		clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
 
 		atomic_dec(&ps->num_sta_ps);
 		sta_info_recalc_tim(sta);
@@ -1090,10 +1092,14 @@ struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL(ieee80211_find_sta);
 
-static void clear_sta_ps_flags(void *_sta)
+/* powersave support code */
+void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 {
-	struct sta_info *sta = _sta;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff_head pending;
+	int filtered = 0, buffered = 0, ac;
+	unsigned long flags;
 	struct ps_data *ps;
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP ||
@@ -1104,20 +1110,6 @@ static void clear_sta_ps_flags(void *_sta)
 	else
 		return;
 
-	clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
-	if (test_and_clear_sta_flag(sta, WLAN_STA_PS_STA))
-		atomic_dec(&ps->num_sta_ps);
-}
-
-/* powersave support code */
-void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
-{
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct ieee80211_local *local = sdata->local;
-	struct sk_buff_head pending;
-	int filtered = 0, buffered = 0, ac;
-	unsigned long flags;
-
 	clear_sta_flag(sta, WLAN_STA_SP);
 
 	BUILD_BUG_ON(BITS_TO_LONGS(IEEE80211_NUM_TIDS) > 1);
@@ -1148,9 +1140,13 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 		buffered += tmp - count;
 	}
 
-	ieee80211_add_pending_skbs_fn(local, &pending, clear_sta_ps_flags, sta);
+	ieee80211_add_pending_skbs(local, &pending);
+	clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
+	clear_sta_flag(sta, WLAN_STA_PS_STA);
 	spin_unlock(&sta->ps_lock);
 
+	atomic_dec(&ps->num_sta_ps);
+
 	/* This station just woke up and isn't aware of our SMPS state */
 	if (!ieee80211_smps_is_restrictive(sta->known_smps_mode,
 					   sdata->smps_mode) &&
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
-- 
1.8.5.3

