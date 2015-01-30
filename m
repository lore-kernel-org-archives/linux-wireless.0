Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:43247 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268AbbA3Mdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 07:33:37 -0500
Received: by mail-we0-f176.google.com with SMTP id w62so26843562wes.7
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 04:33:36 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 5/7] ath10k: rework tx queue locking
Date: Fri, 30 Jan 2015 13:31:24 +0100
Message-Id: <1422621086-28970-6-git-send-email-michal.kazior@tieto.com> (sfid-20150130_133350_121744_288B187D)
In-Reply-To: <1422621086-28970-1-git-send-email-michal.kazior@tieto.com>
References: <1422607287-12289-1-git-send-email-michal.kazior@tieto.com>
 <1422621086-28970-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tx queue locking was very simple until now.
Multi-channel support will require a more flexible
and fine grained control.

This introduces a per-hw and per-vif (each with a
bitmask of reasons) tx queue locking.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h   |  8 +++++
 drivers/net/wireless/ath/ath10k/htt_tx.c | 11 ++++--
 drivers/net/wireless/ath/ath10k/mac.c    | 20 ++++++++++-
 drivers/net/wireless/ath/ath10k/mac.h    | 57 ++++++++++++++++++++++++++++++++
 4 files changed, 92 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index cf7963d..68df646 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -280,6 +280,7 @@ struct ath10k_vif {
 	bool beacon_sent;
 	void *beacon_buf;
 	dma_addr_t beacon_paddr;
+	unsigned long tx_paused; /* arbitrary values defined by target */
 
 	struct ath10k *ar;
 	struct ath10k_chanctx *arctx;
@@ -472,6 +473,11 @@ static inline const char *ath10k_scan_state_str(enum ath10k_scan_state state)
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
@@ -631,6 +637,8 @@ struct ath10k {
 
 	struct dfs_pattern_detector *dfs_detector;
 
+	unsigned long tx_paused; /* see ATH10K_TX_PAUSE_ */
+
 #ifdef CONFIG_ATH10K_DEBUGFS
 	struct ath10k_debug debug;
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index c1961e7..fcc52c1 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -24,9 +24,14 @@
 
 void __ath10k_htt_tx_dec_pending(struct ath10k_htt *htt)
 {
+	struct ath10k *ar = htt->ar;
+
 	htt->num_pending_tx--;
-	if (htt->num_pending_tx == htt->max_num_pending_tx - 1)
-		ieee80211_wake_queues(htt->ar->hw);
+	if (htt->num_pending_tx == htt->max_num_pending_tx - 1) {
+		spin_lock_bh(&ar->data_lock);
+		ath10k_mac_tx_unlock(htt->ar, ATH10K_TX_PAUSE_Q_FULL);
+		spin_unlock_bh(&ar->data_lock);
+	}
 }
 
 static void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt)
@@ -49,7 +54,7 @@ static int ath10k_htt_tx_inc_pending(struct ath10k_htt *htt)
 
 	htt->num_pending_tx++;
 	if (htt->num_pending_tx == htt->max_num_pending_tx)
-		ieee80211_stop_queues(htt->ar->hw);
+		ath10k_mac_tx_lock(htt->ar, ATH10K_TX_PAUSE_Q_FULL);
 
 exit:
 	spin_unlock_bh(&htt->tx_lock);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ba66a67..92355f1 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2811,6 +2811,7 @@ void ath10k_halt(struct ath10k *ar)
 		ath10k_monitor_stop(ar);
 
 	ar->monitor_started = false;
+	ar->tx_paused = 0;
 
 	ath10k_scan_finish(ar);
 	ath10k_peer_cleanup_all(ar);
@@ -3233,6 +3234,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	int ret = 0;
 	u32 value;
 	int bit;
+	int i;
 	u32 vdev_param;
 
 	vif->driver_flags |= IEEE80211_VIF_SUPPORTS_UAPSD;
@@ -3288,6 +3290,15 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
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
@@ -5785,6 +5796,7 @@ int ath10k_mac_register(struct ath10k *ar)
 			IEEE80211_HW_HAS_RATE_CONTROL |
 			IEEE80211_HW_AP_LINK_PS |
 			IEEE80211_HW_WANT_MONITOR_VIF |
+			IEEE80211_HW_QUEUE_CONTROL |
 			IEEE80211_HW_SPECTRUM_MGMT;
 
 	ar->hw->wiphy->features |= NL80211_FEATURE_STATIC_SMPS;
@@ -5830,7 +5842,13 @@ int ath10k_mac_register(struct ath10k *ar)
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
index 6829611..76776f6 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -69,4 +69,61 @@ static inline void ath10k_tx_h_seq_no(struct ieee80211_vif *vif,
 	}
 }
 
+static inline void ath10k_mac_tx_lock(struct ath10k *ar, int reason)
+{
+	lockdep_assert_held(&ar->htt.tx_lock);
+
+	WARN_ON(reason >= ATH10K_TX_PAUSE_MAX);
+	ar->tx_paused |= BIT(reason);
+	ieee80211_stop_queues(ar->hw);
+}
+
+static inline void ath10k_mac_tx_unlock(struct ath10k *ar, int reason)
+{
+	struct ath10k_vif *arvif;
+
+	lockdep_assert_held(&ar->htt.tx_lock);
+	lockdep_assert_held(&ar->data_lock);
+
+	WARN_ON(reason >= ATH10K_TX_PAUSE_MAX);
+	ar->tx_paused &= ~BIT(reason);
+
+	if (ar->tx_paused)
+		return;
+
+	list_for_each_entry(arvif, &ar->arvifs, list)
+		if (!arvif->tx_paused)
+			ieee80211_wake_queue(ar->hw, arvif->vdev_id);
+}
+
+static inline void ath10k_mac_vif_tx_lock(struct ath10k_vif *arvif, int reason)
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
+static inline void ath10k_mac_vif_tx_unlock(struct ath10k_vif *arvif,
+					    int reason)
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
 #endif /* _MAC_H_ */
-- 
1.8.5.3

