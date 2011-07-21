Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:16964 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab1GURgb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 13:36:31 -0400
Subject: [PATCH 1/3] ath5k: merge ath5k_{init,
 deinit}_hw() with their thin wrappers
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Thu, 21 Jul 2011 13:36:28 -0400
Message-ID: <20110721173628.30989.19587.stgit@mj.roinet.com> (sfid-20110721_193635_931266_5B5BE012)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h        |    4 ++--
 drivers/net/wireless/ath/ath5k/base.c         |   10 ++++------
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |   14 --------------
 3 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 0289584..c6fb44c 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1372,8 +1372,8 @@ void ath5k_set_beacon_filter(struct ieee80211_hw *hw, bool enable);
 bool ath5k_any_vif_assoc(struct ath5k_hw *ah);
 void ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 		    struct ath5k_txq *txq);
-int ath5k_init_hw(struct ath5k_hw *ah);
-int ath5k_stop_hw(struct ath5k_hw *ah);
+int ath5k_start(struct ieee80211_hw *hw);
+void ath5k_stop(struct ieee80211_hw *hw);
 void ath5k_mode_setup(struct ath5k_hw *ah, struct ieee80211_vif *vif);
 void ath5k_update_bssid_mask_and_opmode(struct ath5k_hw *ah,
 					struct ieee80211_vif *vif);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 20e4ef4..a74d286 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2526,9 +2526,9 @@ ath5k_stop_locked(struct ath5k_hw *ah)
 	return 0;
 }
 
-int
-ath5k_init_hw(struct ath5k_hw *ah)
+int ath5k_start(struct ieee80211_hw *hw)
 {
+	struct ath5k_hw *ah = hw->priv;
 	struct ath_common *common = ath5k_hw_common(ah);
 	int ret, i;
 
@@ -2602,9 +2602,9 @@ static void ath5k_stop_tasklets(struct ath5k_hw *ah)
  * if another thread does a system call and the thread doing the
  * stop is preempted).
  */
-int
-ath5k_stop_hw(struct ath5k_hw *ah)
+void ath5k_stop(struct ieee80211_hw *hw)
 {
+	struct ath5k_hw *ah = hw->priv;
 	int ret;
 
 	mutex_lock(&ah->lock);
@@ -2644,8 +2644,6 @@ ath5k_stop_hw(struct ath5k_hw *ah)
 	cancel_delayed_work_sync(&ah->tx_complete_work);
 
 	ath5k_rfkill_hw_stop(ah);
-
-	return ret;
 }
 
 /*
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 7aa2a63..2a715ca 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -66,20 +66,6 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 
 static int
-ath5k_start(struct ieee80211_hw *hw)
-{
-	return ath5k_init_hw(hw->priv);
-}
-
-
-static void
-ath5k_stop(struct ieee80211_hw *hw)
-{
-	ath5k_stop_hw(hw->priv);
-}
-
-
-static int
 ath5k_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct ath5k_hw *ah = hw->priv;
