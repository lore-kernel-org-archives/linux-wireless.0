Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48762 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933135Ab3ECIBK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 04:01:10 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3.10] mac80211: fix spurious RCU warning and update documentation
Date: Fri,  3 May 2013 10:01:03 +0200
Message-Id: <1367568063-24859-1-git-send-email-nbd@openwrt.org> (sfid-20130503_100114_389997_C5F4C681)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Document rx vs tx status concurrency requirements.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h | 12 ++++++++----
 net/mac80211/rate.c    |  9 ++++++++-
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 04c2d46..885898a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3043,7 +3043,8 @@ void ieee80211_napi_complete(struct ieee80211_hw *hw);
  * This function may not be called in IRQ context. Calls to this function
  * for a single hardware must be synchronized against each other. Calls to
  * this function, ieee80211_rx_ni() and ieee80211_rx_irqsafe() may not be
- * mixed for a single hardware.
+ * mixed for a single hardware. Must not run concurrently with
+ * ieee80211_tx_status() or ieee80211_tx_status_ni().
  *
  * In process context use instead ieee80211_rx_ni().
  *
@@ -3059,7 +3060,8 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb);
  * (internally defers to a tasklet.)
  *
  * Calls to this function, ieee80211_rx() or ieee80211_rx_ni() may not
- * be mixed for a single hardware.
+ * be mixed for a single hardware.Must not run concurrently with
+ * ieee80211_tx_status() or ieee80211_tx_status_ni().
  *
  * @hw: the hardware this frame came in on
  * @skb: the buffer to receive, owned by mac80211 after this call
@@ -3073,7 +3075,8 @@ void ieee80211_rx_irqsafe(struct ieee80211_hw *hw, struct sk_buff *skb);
  * (internally disables bottom halves).
  *
  * Calls to this function, ieee80211_rx() and ieee80211_rx_irqsafe() may
- * not be mixed for a single hardware.
+ * not be mixed for a single hardware. Must not run concurrently with
+ * ieee80211_tx_status() or ieee80211_tx_status_ni().
  *
  * @hw: the hardware this frame came in on
  * @skb: the buffer to receive, owned by mac80211 after this call
@@ -3196,7 +3199,8 @@ void ieee80211_get_tx_rates(struct ieee80211_vif *vif,
  * This function may not be called in IRQ context. Calls to this function
  * for a single hardware must be synchronized against each other. Calls
  * to this function, ieee80211_tx_status_ni() and ieee80211_tx_status_irqsafe()
- * may not be mixed for a single hardware.
+ * may not be mixed for a single hardware. Must not run concurrently with
+ * ieee80211_rx() or ieee80211_rx_ni().
  *
  * @hw: the hardware the frame was transmitted by
  * @skb: the frame that was transmitted, owned by mac80211 after this call
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 0d51877..923f85b 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -688,8 +688,15 @@ int rate_control_set_rates(struct ieee80211_hw *hw,
 			   struct ieee80211_sta *pubsta,
 			   struct ieee80211_sta_rates *rates)
 {
-	struct ieee80211_sta_rates *old = rcu_dereference(pubsta->rates);
+	struct ieee80211_sta_rates *old;
 
+	/*
+	 * mac80211 guarantees that this function will not be called
+	 * concurrently, so the following RCU access is safe, even outside
+	 * of a rcu_read_lock section. This can not be checked easily, so
+	 * we just set the condition to true
+	 */
+	old = rcu_dereference_protected(pubsta->rates, true);
 	rcu_assign_pointer(pubsta->rates, rates);
 	if (old)
 		kfree_rcu(old, rcu_head);
-- 
1.8.0.2

