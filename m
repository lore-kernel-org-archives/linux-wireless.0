Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38266 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab1I2OGL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 10:06:11 -0400
Message-Id: <20110929140458.861780480@sipsolutions.net> (sfid-20110929_160615_698246_9717B86E)
Date: Thu, 29 Sep 2011 16:04:27 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 02/16] mac80211: unify TIM bit handling
References: <20110929140425.390322480@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, the TIM bit for a given station is set
and cleared all over the place. Since the logic to
set/clear it will become much more complex when we
add uAPSD support, as a first step let's collect
the entire logic in one place. This requires a few
small adjustments to other places.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c |  101 ++++++++++++++++++++----------------------------
 net/mac80211/sta_info.h |    3 -
 net/mac80211/status.c   |    1 
 net/mac80211/tx.c       |   15 ++-----
 4 files changed, 51 insertions(+), 69 deletions(-)

--- a/net/mac80211/sta_info.h	2011-09-29 15:57:18.000000000 +0200
+++ b/net/mac80211/sta_info.h	2011-09-29 15:57:29.000000000 +0200
@@ -528,8 +528,7 @@ int sta_info_destroy_addr(struct ieee802
 int sta_info_destroy_addr_bss(struct ieee80211_sub_if_data *sdata,
 			      const u8 *addr);
 
-void sta_info_set_tim_bit(struct sta_info *sta);
-void sta_info_clear_tim_bit(struct sta_info *sta);
+void sta_info_recalc_tim(struct sta_info *sta);
 
 void sta_info_init(struct ieee80211_local *local);
 void sta_info_stop(struct ieee80211_local *local);
--- a/net/mac80211/tx.c	2011-09-29 15:57:18.000000000 +0200
+++ b/net/mac80211/tx.c	2011-09-29 15:57:29.000000000 +0200
@@ -469,15 +469,6 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 		} else
 			tx->local->total_ps_buffered++;
 
-		/*
-		 * Queue frame to be sent after STA wakes up/polls,
-		 * but don't set the TIM bit if the driver is blocking
-		 * wakeup or poll response transmissions anyway.
-		 */
-		if (skb_queue_empty(&sta->ps_tx_buf) &&
-		    !(staflags & WLAN_STA_PS_DRIVER))
-			sta_info_set_tim_bit(sta);
-
 		info->control.jiffies = jiffies;
 		info->control.vif = &tx->sdata->vif;
 		info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
@@ -488,6 +479,12 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 				  round_jiffies(jiffies +
 						STA_INFO_CLEANUP_INTERVAL));
 
+		/*
+		 * We queued up some frames, so the TIM bit might
+		 * need to be set, recalculate it.
+		 */
+		sta_info_recalc_tim(sta);
+
 		return TX_QUEUED;
 	}
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
--- a/net/mac80211/sta_info.c	2011-09-29 15:57:18.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-09-29 15:58:07.000000000 +0200
@@ -641,54 +641,42 @@ static inline void __bss_tim_clear(struc
 	bss->tim[aid / 8] &= ~(1 << (aid % 8));
 }
 
-static void __sta_info_set_tim_bit(struct ieee80211_if_ap *bss,
-				   struct sta_info *sta)
-{
-	BUG_ON(!bss);
-
-	__bss_tim_set(bss, sta->sta.aid);
-
-	if (sta->local->ops->set_tim) {
-		sta->local->tim_in_locked_section = true;
-		drv_set_tim(sta->local, &sta->sta, true);
-		sta->local->tim_in_locked_section = false;
-	}
-}
-
-void sta_info_set_tim_bit(struct sta_info *sta)
+void sta_info_recalc_tim(struct sta_info *sta)
 {
+	struct ieee80211_local *local = sta->local;
+	struct ieee80211_if_ap *bss = sta->sdata->bss;
 	unsigned long flags;
+	bool have_data = false;
 
-	BUG_ON(!sta->sdata->bss);
-
-	spin_lock_irqsave(&sta->local->sta_lock, flags);
-	__sta_info_set_tim_bit(sta->sdata->bss, sta);
-	spin_unlock_irqrestore(&sta->local->sta_lock, flags);
-}
+	if (WARN_ON_ONCE(!sta->sdata->bss))
+		return;
 
-static void __sta_info_clear_tim_bit(struct ieee80211_if_ap *bss,
-				     struct sta_info *sta)
-{
-	BUG_ON(!bss);
+	/* No need to do anything if the driver does all */
+	if (local->hw.flags & IEEE80211_HW_AP_LINK_PS)
+		return;
 
-	__bss_tim_clear(bss, sta->sta.aid);
+	if (sta->dead)
+		goto done;
 
-	if (sta->local->ops->set_tim) {
-		sta->local->tim_in_locked_section = true;
-		drv_set_tim(sta->local, &sta->sta, false);
-		sta->local->tim_in_locked_section = false;
-	}
-}
+	have_data = test_sta_flags(sta, WLAN_STA_PS_DRIVER_BUF) ||
+		    !skb_queue_empty(&sta->tx_filtered) ||
+		    !skb_queue_empty(&sta->ps_tx_buf);
 
-void sta_info_clear_tim_bit(struct sta_info *sta)
-{
-	unsigned long flags;
+ done:
+	spin_lock_irqsave(&local->sta_lock, flags);
 
-	BUG_ON(!sta->sdata->bss);
+	if (have_data)
+		__bss_tim_set(bss, sta->sta.aid);
+	else
+		__bss_tim_clear(bss, sta->sta.aid);
+
+	if (local->ops->set_tim) {
+		local->tim_in_locked_section = true;
+		drv_set_tim(local, &sta->sta, have_data);
+		local->tim_in_locked_section = false;
+	}
 
-	spin_lock_irqsave(&sta->local->sta_lock, flags);
-	__sta_info_clear_tim_bit(sta->sdata->bss, sta);
-	spin_unlock_irqrestore(&sta->local->sta_lock, flags);
+	spin_unlock_irqrestore(&local->sta_lock, flags);
 }
 
 static bool sta_info_buffer_expired(struct sta_info *sta, struct sk_buff *skb)
@@ -717,6 +705,10 @@ static bool sta_info_cleanup_expire_buff
 	unsigned long flags;
 	struct sk_buff *skb;
 
+	/* This is only necessary for stations on BSS interfaces */
+	if (!sta->sdata->bss)
+		return false;
+
 	for (;;) {
 		spin_lock_irqsave(&sta->ps_tx_buf.lock, flags);
 		skb = skb_peek(&sta->ps_tx_buf);
@@ -736,9 +728,9 @@ static bool sta_info_cleanup_expire_buff
 #endif
 		dev_kfree_skb(skb);
 
-		if (skb_queue_empty(&sta->ps_tx_buf) &&
-		    !test_sta_flags(sta, WLAN_STA_PS_DRIVER_BUF))
-			sta_info_clear_tim_bit(sta);
+		/* if the queue is now empty recalc TIM bit */
+		if (skb_queue_empty(&sta->ps_tx_buf))
+			sta_info_recalc_tim(sta);
 	}
 
 	return !skb_queue_empty(&sta->ps_tx_buf);
@@ -748,7 +740,6 @@ static int __must_check __sta_info_destr
 {
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
-	struct sk_buff *skb;
 	unsigned long flags;
 	int ret, i;
 
@@ -792,7 +783,7 @@ static int __must_check __sta_info_destr
 		BUG_ON(!sdata->bss);
 
 		atomic_dec(&sdata->bss->num_sta_ps);
-		sta_info_clear_tim_bit(sta);
+		sta_info_recalc_tim(sta);
 	}
 
 	local->num_sta--;
@@ -818,6 +809,10 @@ static int __must_check __sta_info_destr
 	 */
 	synchronize_rcu();
 
+	local->total_ps_buffered -= skb_queue_len(&sta->ps_tx_buf);
+	__skb_queue_purge(&sta->ps_tx_buf);
+	__skb_queue_purge(&sta->tx_filtered);
+
 #ifdef CONFIG_MAC80211_MESH
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_accept_plinks_update(sdata);
@@ -840,14 +835,6 @@ static int __must_check __sta_info_destr
 	}
 #endif
 
-	while ((skb = skb_dequeue(&sta->ps_tx_buf)) != NULL) {
-		local->total_ps_buffered--;
-		dev_kfree_skb_any(skb);
-	}
-
-	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL)
-		dev_kfree_skb_any(skb);
-
 	__sta_info_free(local, sta);
 
 	return 0;
@@ -1027,9 +1014,6 @@ void ieee80211_sta_ps_deliver_wakeup(str
 	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS))
 		drv_sta_notify(local, sdata, STA_NOTIFY_AWAKE, &sta->sta);
 
-	if (!skb_queue_empty(&sta->ps_tx_buf))
-		sta_info_clear_tim_bit(sta);
-
 	/* Send all buffered frames to the station */
 	sent = ieee80211_add_pending_skbs(local, &sta->tx_filtered);
 	buffered = ieee80211_add_pending_skbs_fn(local, &sta->ps_tx_buf,
@@ -1037,6 +1021,8 @@ void ieee80211_sta_ps_deliver_wakeup(str
 	sent += buffered;
 	local->total_ps_buffered -= buffered;
 
+	sta_info_recalc_tim(sta);
+
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %pM aid %d sending %d filtered/%d PS frames "
 	       "since STA not sleeping anymore\n", sdata->name,
@@ -1086,8 +1072,7 @@ void ieee80211_sta_ps_deliver_poll_respo
 
 		ieee80211_add_pending_skb(local, skb);
 
-		if (no_pending_pkts)
-			sta_info_clear_tim_bit(sta);
+		sta_info_recalc_tim(sta);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	} else {
 		/*
@@ -1126,6 +1111,6 @@ void ieee80211_sta_set_buffered(struct i
 		return;
 
 	set_sta_flags(sta, WLAN_STA_PS_DRIVER_BUF);
-	sta_info_set_tim_bit(sta);
+	sta_info_recalc_tim(sta);
 }
 EXPORT_SYMBOL(ieee80211_sta_set_buffered);
--- a/net/mac80211/status.c	2011-09-29 15:57:18.000000000 +0200
+++ b/net/mac80211/status.c	2011-09-29 15:58:07.000000000 +0200
@@ -106,6 +106,7 @@ static void ieee80211_handle_filtered_fr
 	if (test_sta_flags(sta, WLAN_STA_PS_STA) &&
 	    skb_queue_len(&sta->tx_filtered) < STA_MAX_TX_BUFFER) {
 		skb_queue_tail(&sta->tx_filtered, skb);
+		sta_info_recalc_tim(sta);
 		return;
 	}
 


