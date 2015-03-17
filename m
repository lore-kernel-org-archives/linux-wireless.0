Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:35014 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbbCQMd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 08:33:27 -0400
Received: by lbcgn8 with SMTP id gn8so5772410lbc.2
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2015 05:33:25 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 4/7] ath10k: rework tx queue locking
Date: Tue, 17 Mar 2015 12:30:45 +0000
Message-Id: <1426595448-1630-5-git-send-email-michal.kazior@tieto.com> (sfid-20150317_133335_414466_E9F20690)
In-Reply-To: <1426595448-1630-1-git-send-email-michal.kazior@tieto.com>
References: <1426595448-1630-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tx queue locking was very simple until now.
Multi-channel support will require a more flexible
and fine grained control.

This introduces a per-hw and per-vif (each with a
bitmask of reasons) tx queue locking.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v4:
     * use ieee80211_iterate_active_interfaces_atomic() instead of ar->arvifs

 drivers/net/wireless/ath/ath10k/core.h   |  8 +++
 drivers/net/wireless/ath/ath10k/htt_tx.c |  4 +-
 drivers/net/wireless/ath/ath10k/mac.c    | 88 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/mac.h    |  5 ++
 4 files changed, 101 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index d54e12d..b99871a 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -311,6 +311,7 @@ struct ath10k_vif {
 	enum ath10k_beacon_state beacon_state;
 	void *beacon_buf;
 	dma_addr_t beacon_paddr;
+	unsigned long tx_paused; /* arbitrary values defined by target */
 
 	struct ath10k *ar;
 	struct ieee80211_vif *vif;
@@ -510,6 +511,11 @@ static inline const char *ath10k_scan_state_str(enum ath10k_scan_state state)
 	return "unknown";
 }
 
+enum ath10k_tx_pause_reason {
+	ATH10K_TX_PAUSE_Q_FULL,
+	ATH10K_TX_PAUSE_MAX,
+};
+
 struct ath10k {
 	struct ath_common ath_common;
 	struct ieee80211_hw *hw;
@@ -668,6 +674,8 @@ struct ath10k {
 
 	struct dfs_pattern_detector *dfs_detector;
 
+	unsigned long tx_paused; /* see ATH10K_TX_PAUSE_ */
+
 #ifdef CONFIG_ATH10K_DEBUGFS
 	struct ath10k_debug debug;
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index cbd2bc9..c67b385 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -26,7 +26,7 @@ void __ath10k_htt_tx_dec_pending(struct ath10k_htt *htt)
 {
 	htt->num_pending_tx--;
 	if (htt->num_pending_tx == htt->max_num_pending_tx - 1)
-		ieee80211_wake_queues(htt->ar->hw);
+		ath10k_mac_tx_unlock(htt->ar, ATH10K_TX_PAUSE_Q_FULL);
 }
 
 static void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt)
@@ -49,7 +49,7 @@ static int ath10k_htt_tx_inc_pending(struct ath10k_htt *htt)
 
 	htt->num_pending_tx++;
 	if (htt->num_pending_tx == htt->max_num_pending_tx)
-		ieee80211_stop_queues(htt->ar->hw);
+		ath10k_mac_tx_lock(htt->ar, ATH10K_TX_PAUSE_Q_FULL);
 
 exit:
 	spin_unlock_bh(&htt->tx_lock);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 8b64313..185be19 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2707,6 +2707,72 @@ static void ath10k_reg_notifier(struct wiphy *wiphy,
 /* TX handlers */
 /***************/
 
+void ath10k_mac_tx_lock(struct ath10k *ar, int reason)
+{
+	lockdep_assert_held(&ar->htt.tx_lock);
+
+	WARN_ON(reason >= ATH10K_TX_PAUSE_MAX);
+	ar->tx_paused |= BIT(reason);
+	ieee80211_stop_queues(ar->hw);
+}
+
+static void ath10k_mac_tx_unlock_iter(void *data, u8 *mac,
+				      struct ieee80211_vif *vif)
+{
+	struct ath10k *ar = data;
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+
+	if (arvif->tx_paused)
+		return;
+
+	ieee80211_wake_queue(ar->hw, arvif->vdev_id);
+}
+
+void ath10k_mac_tx_unlock(struct ath10k *ar, int reason)
+{
+	lockdep_assert_held(&ar->htt.tx_lock);
+
+	WARN_ON(reason >= ATH10K_TX_PAUSE_MAX);
+	ar->tx_paused &= ~BIT(reason);
+
+	if (ar->tx_paused)
+		return;
+
+	ieee80211_iterate_active_interfaces_atomic(ar->hw,
+						   IEEE80211_IFACE_ITER_RESUME_ALL,
+						   ath10k_mac_tx_unlock_iter,
+						   ar);
+}
+
+void ath10k_mac_vif_tx_lock(struct ath10k_vif *arvif, int reason)
+{
+	struct ath10k *ar = arvif->ar;
+
+	lockdep_assert_held(&ar->htt.tx_lock);
+
+	WARN_ON(reason >= BITS_PER_LONG);
+	arvif->tx_paused |= BIT(reason);
+	ieee80211_stop_queue(ar->hw, arvif->vdev_id);
+}
+
+void ath10k_mac_vif_tx_unlock(struct ath10k_vif *arvif, int reason)
+{
+	struct ath10k *ar = arvif->ar;
+
+	lockdep_assert_held(&ar->htt.tx_lock);
+
+	WARN_ON(reason >= BITS_PER_LONG);
+	arvif->tx_paused &= ~BIT(reason);
+
+	if (ar->tx_paused)
+		return;
+
+	if (arvif->tx_paused)
+		return;
+
+	ieee80211_wake_queue(ar->hw, arvif->vdev_id);
+}
+
 static u8 ath10k_tx_h_get_tid(struct ieee80211_hdr *hdr)
 {
 	if (ieee80211_is_mgmt(hdr->frame_control))
@@ -3200,6 +3266,7 @@ void ath10k_halt(struct ath10k *ar)
 		ath10k_monitor_stop(ar);
 
 	ar->monitor_started = false;
+	ar->tx_paused = 0;
 
 	ath10k_scan_finish(ar);
 	ath10k_peer_cleanup_all(ar);
@@ -3609,6 +3676,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	int ret = 0;
 	u32 value;
 	int bit;
+	int i;
 	u32 vdev_param;
 
 	vif->driver_flags |= IEEE80211_VIF_SUPPORTS_UAPSD;
@@ -3666,6 +3734,15 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		break;
 	}
 
+	/* Using vdev_id as queue number will make it very easy to do per-vif
+	 * tx queue locking. This shouldn't wrap due to interface combinations
+	 * but do a modulo for correctness sake and prevent using offchannel tx
+	 * queues for regular vif tx.
+	 */
+	vif->cab_queue = arvif->vdev_id % (IEEE80211_MAX_QUEUES - 1);
+	for (i = 0; i < ARRAY_SIZE(vif->hw_queue); i++)
+		vif->hw_queue[i] = arvif->vdev_id % (IEEE80211_MAX_QUEUES - 1);
+
 	/* Some firmware revisions don't wait for beacon tx completion before
 	 * sending another SWBA event. This could lead to hardware using old
 	 * (freed) beacon data in some cases, e.g. tx credit starvation
@@ -6261,7 +6338,8 @@ int ath10k_mac_register(struct ath10k *ar)
 			IEEE80211_HW_SW_CRYPTO_CONTROL |
 			IEEE80211_HW_CONNECTION_MONITOR |
 			IEEE80211_HW_WANT_MONITOR_VIF |
-			IEEE80211_HW_CHANCTX_STA_CSA;
+			IEEE80211_HW_CHANCTX_STA_CSA |
+			IEEE80211_HW_QUEUE_CONTROL;
 
 	ar->hw->wiphy->features |= NL80211_FEATURE_STATIC_SMPS;
 
@@ -6306,7 +6384,13 @@ int ath10k_mac_register(struct ath10k *ar)
 	 * on LL hardware queues are managed entirely by the FW
 	 * so we only advertise to mac we can do the queues thing
 	 */
-	ar->hw->queues = 4;
+	ar->hw->queues = IEEE80211_MAX_QUEUES;
+
+	/* vdev_ids are used as hw queue numbers. Make sure offchan tx queue is
+	 * something that vdev_ids can't reach so that we don't stop the queue
+	 * accidentally.
+	 */
+	ar->hw->offchannel_tx_hw_queue = IEEE80211_MAX_QUEUES - 1;
 
 	switch (ar->wmi.op_version) {
 	case ATH10K_FW_WMI_OP_VERSION_MAIN:
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index 0f2061a..9d3d9e75 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -48,6 +48,11 @@ bool ath10k_mac_is_peer_wep_key_set(struct ath10k *ar, const u8 *addr,
 void ath10k_mac_handle_beacon(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_mac_handle_beacon_miss(struct ath10k *ar, u32 vdev_id);
 
+void ath10k_mac_tx_lock(struct ath10k *ar, int reason);
+void ath10k_mac_tx_unlock(struct ath10k *ar, int reason);
+void ath10k_mac_vif_tx_lock(struct ath10k_vif *arvif, int reason);
+void ath10k_mac_vif_tx_unlock(struct ath10k_vif *arvif, int reason);
+
 static inline struct ath10k_vif *ath10k_vif_to_arvif(struct ieee80211_vif *vif)
 {
 	return (struct ath10k_vif *)vif->drv_priv;
-- 
2.1.4

