Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:33882 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966310AbcCPKPy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 06:15:54 -0400
Received: by mail-lf0-f47.google.com with SMTP id e138so14824918lfe.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2016 03:15:53 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, johannes@sipsolutions.net,
	netdev@vger.kernel.org, dave.taht@gmail.com,
	emmanuel.grumbach@intel.com, nbd@openwrt.org,
	Tim Shepard <shep@alum.mit.edu>,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFCv2 2/3] ath10k: report per-station tx/rate rates to mac80211
Date: Wed, 16 Mar 2016 11:17:57 +0100
Message-Id: <1458123478-1795-3-git-send-email-michal.kazior@tieto.com> (sfid-20160316_111619_342199_B7F9EBB8)
In-Reply-To: <1458123478-1795-1-git-send-email-michal.kazior@tieto.com>
References: <1458123478-1795-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rate control is offloaded by firmware so it's
challanging to provide expected throughput value
for given station.

This approach is naive as it reports last tx rate
used for given station as provided by firmware
stat event.

This should be sufficient for airtime estimation
used for fq-codel-in-mac80211 tx scheduling
purposes now.

This patch uses a very hacky way to get the stats.
This is sufficient for proof-of-concept but must
be cleaned up properly eventually.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |  5 +++
 drivers/net/wireless/ath/ath10k/debug.c | 61 +++++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/mac.c   | 26 ++++++++------
 drivers/net/wireless/ath/ath10k/wmi.h   |  2 +-
 4 files changed, 76 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 23ba03fb7a5f..3f76669d44cf 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -331,6 +331,9 @@ struct ath10k_sta {
 	/* protected by conf_mutex */
 	bool aggr_mode;
 	u64 rx_duration;
+
+	u32 tx_rate_kbps;
+	u32 rx_rate_kbps;
 #endif
 };
 
@@ -372,6 +375,8 @@ struct ath10k_vif {
 	s8 def_wep_key_idx;
 
 	u16 tx_seq_no;
+	u32 tx_rate_kbps;
+	u32 rx_rate_kbps;
 
 	union {
 		struct {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 076d29b53ddf..cc7ebf04ae00 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -316,6 +316,58 @@ static void ath10k_debug_fw_stats_reset(struct ath10k *ar)
 	spin_unlock_bh(&ar->data_lock);
 }
 
+static void ath10k_mac_update_txrx_rate_iter(void *data,
+					     u8 *mac,
+					     struct ieee80211_vif *vif)
+{
+	struct ath10k_fw_stats_peer *peer = data;
+	struct ath10k_vif *arvif;
+
+	if (memcmp(vif->addr, peer->peer_macaddr, ETH_ALEN))
+		return;
+
+	arvif = (void *)vif->drv_priv;
+	arvif->tx_rate_kbps = peer->peer_tx_rate;
+	arvif->rx_rate_kbps = peer->peer_rx_rate;
+}
+
+static void ath10k_mac_update_txrx_rate(struct ath10k *ar,
+					struct ath10k_fw_stats *stats)
+{
+	struct ieee80211_hw *hw = ar->hw;
+	struct ath10k_fw_stats_peer *peer;
+	struct ath10k_sta *arsta;
+	struct ieee80211_sta *sta;
+	const u8 *localaddr = NULL;
+
+	rcu_read_lock();
+
+	list_for_each_entry(peer, &stats->peers, list) {
+		/* This doesn't account for multiple STA connected on different
+		 * vifs. Unfortunately there's no way to derive that from the available
+		 * information.
+		 */
+		sta = ieee80211_find_sta_by_ifaddr(hw,
+						   peer->peer_macaddr,
+						   localaddr);
+		if (!sta) {
+			/* This tries to update multicast rates */
+			ieee80211_iterate_active_interfaces_atomic(
+					hw,
+					IEEE80211_IFACE_ITER_NORMAL,
+					ath10k_mac_update_txrx_rate_iter,
+					peer);
+			continue;
+		}
+
+		arsta = (void *)sta->drv_priv;
+		arsta->tx_rate_kbps = peer->peer_tx_rate;
+		arsta->rx_rate_kbps = peer->peer_rx_rate;
+	}
+
+	rcu_read_unlock();
+}
+
 void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ath10k_fw_stats stats = {};
@@ -335,6 +387,8 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 		goto free;
 	}
 
+	ath10k_mac_update_txrx_rate(ar, &stats);
+
 	/* Stat data may exceed htc-wmi buffer limit. In such case firmware
 	 * splits the stats data and delivers it in a ping-pong fashion of
 	 * request cmd-update event.
@@ -351,13 +405,6 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 	if (peer_stats_svc)
 		ath10k_sta_update_rx_duration(ar, &stats.peers);
 
-	if (ar->debug.fw_stats_done) {
-		if (!peer_stats_svc)
-			ath10k_warn(ar, "received unsolicited stats update event\n");
-
-		goto free;
-	}
-
 	num_peers = ath10k_wmi_fw_stats_num_peers(&ar->debug.fw_stats.peers);
 	num_vdevs = ath10k_wmi_fw_stats_num_vdevs(&ar->debug.fw_stats.vdevs);
 	is_start = (list_empty(&ar->debug.fw_stats.pdevs) &&
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ebff9c0a0784..addef9179dbe 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4427,16 +4427,14 @@ static int ath10k_start(struct ieee80211_hw *hw)
 
 	ar->ani_enabled = true;
 
-	if (test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map)) {
-		param = ar->wmi.pdev_param->peer_stats_update_period;
-		ret = ath10k_wmi_pdev_set_param(ar, param,
-						PEER_DEFAULT_STATS_UPDATE_PERIOD);
-		if (ret) {
-			ath10k_warn(ar,
-				    "failed to set peer stats period : %d\n",
-				    ret);
-			goto err_core_stop;
-		}
+	param = ar->wmi.pdev_param->peer_stats_update_period;
+	ret = ath10k_wmi_pdev_set_param(ar, param,
+					PEER_DEFAULT_STATS_UPDATE_PERIOD);
+	if (ret) {
+		ath10k_warn(ar,
+			    "failed to set peer stats period : %d\n",
+			    ret);
+		goto err_core_stop;
 	}
 
 	ar->num_started_vdevs = 0;
@@ -7215,6 +7213,13 @@ ath10k_mac_op_switch_vif_chanctx(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static u32
+ath10k_mac_op_get_expected_throughput(struct ieee80211_sta *sta)
+{
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	return arsta->tx_rate_kbps;
+}
+
 static const struct ieee80211_ops ath10k_ops = {
 	.tx				= ath10k_mac_op_tx,
 	.wake_tx_queue			= ath10k_mac_op_wake_tx_queue,
@@ -7254,6 +7259,7 @@ static const struct ieee80211_ops ath10k_ops = {
 	.assign_vif_chanctx		= ath10k_mac_op_assign_vif_chanctx,
 	.unassign_vif_chanctx		= ath10k_mac_op_unassign_vif_chanctx,
 	.switch_vif_chanctx		= ath10k_mac_op_switch_vif_chanctx,
+	.get_expected_throughput	= ath10k_mac_op_get_expected_throughput,
 
 	CFG80211_TESTMODE_CMD(ath10k_tm_cmd)
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 4d3cbc44fcd2..2877a3a27b95 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3296,7 +3296,7 @@ struct wmi_csa_event {
 /* the definition of different PDEV parameters */
 #define PDEV_DEFAULT_STATS_UPDATE_PERIOD    500
 #define VDEV_DEFAULT_STATS_UPDATE_PERIOD    500
-#define PEER_DEFAULT_STATS_UPDATE_PERIOD    500
+#define PEER_DEFAULT_STATS_UPDATE_PERIOD    100
 
 struct wmi_pdev_param_map {
 	u32 tx_chain_mask;
-- 
2.1.4

