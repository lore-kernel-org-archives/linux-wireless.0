Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:42544 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab3IMMRK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 08:17:10 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 5/7] ath10k: improve beacon submission latency
Date: Fri, 13 Sep 2013 14:16:56 +0200
Message-ID: <1379074618-30534-6-git-send-email-michal.kazior@tieto.com> (sfid-20130913_141720_490215_D03B5C46)
In-Reply-To: <1379074618-30534-1-git-send-email-michal.kazior@tieto.com>
References: <1378821003-22925-1-git-send-email-michal.kazior@tieto.com>
 <1379074618-30534-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch prevents beacon misses in some case of
heavy load on a system.

If a beacon can't be transmitted directly from an
SWBA event it will be left in arvif->beacon and
transmission will be retried once TX credits
become available.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * add comments on ath10k_wmi_tx_beacons_nowait() usage

 drivers/net/wireless/ath/ath10k/core.h |    1 +
 drivers/net/wireless/ath/ath10k/mac.c  |    7 +++
 drivers/net/wireless/ath/ath10k/wmi.c  |   74 ++++++++++++++++++++++++++------
 drivers/net/wireless/ath/ath10k/wmi.h  |    3 +-
 4 files changed, 71 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index c953a33..14b7d3d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -204,6 +204,7 @@ struct ath10k_vif {
 	enum wmi_vdev_subtype vdev_subtype;
 	u32 beacon_interval;
 	u32 dtim_period;
+	struct sk_buff *beacon;
 
 	struct ath10k *ar;
 	struct ieee80211_vif *vif;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 8b9fb66..6c3e9d1 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2075,6 +2075,13 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&ar->conf_mutex);
 
+	spin_lock_bh(&ar->data_lock);
+	if (arvif->beacon) {
+		dev_kfree_skb_any(arvif->beacon);
+		arvif->beacon = NULL;
+	}
+	spin_unlock_bh(&ar->data_lock);
+
 	ar->free_vdev_map |= 1 << (arvif->vdev_id);
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ff407c2..9152dae 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -120,8 +120,53 @@ err_pull:
 	return ret;
 }
 
+static void ath10k_wmi_tx_beacon_nowait(struct ath10k_vif *arvif)
+{
+	struct wmi_bcn_tx_arg arg = {0};
+	int ret;
+
+	lockdep_assert_held(&arvif->ar->data_lock);
+
+	if (arvif->beacon == NULL)
+		return;
+
+	arg.vdev_id = arvif->vdev_id;
+	arg.tx_rate = 0;
+	arg.tx_power = 0;
+	arg.bcn = arvif->beacon->data;
+	arg.bcn_len = arvif->beacon->len;
+
+	ret = ath10k_wmi_beacon_send_nowait(arvif->ar, &arg);
+	if (ret)
+		return;
+
+	dev_kfree_skb_any(arvif->beacon);
+	arvif->beacon = NULL;
+}
+
+static void ath10k_wmi_tx_beacons_iter(void *data, u8 *mac,
+				       struct ieee80211_vif *vif)
+{
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+
+	ath10k_wmi_tx_beacon_nowait(arvif);
+}
+
+static void ath10k_wmi_tx_beacons_nowait(struct ath10k *ar)
+{
+	spin_lock_bh(&ar->data_lock);
+	ieee80211_iterate_active_interfaces_atomic(ar->hw,
+						   IEEE80211_IFACE_ITER_NORMAL,
+						   ath10k_wmi_tx_beacons_iter,
+						   NULL);
+	spin_unlock_bh(&ar->data_lock);
+}
+
 static void ath10k_wmi_op_ep_tx_credits(struct ath10k *ar)
 {
+	/* try to send pending beacons first. they take priority */
+	ath10k_wmi_tx_beacons_nowait(ar);
+
 	wake_up(&ar->wmi.tx_credits_wq);
 }
 
@@ -131,6 +176,9 @@ static int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb,
 	int ret = -EINVAL;
 
 	wait_event_timeout(ar->wmi.tx_credits_wq, ({
+		/* try to send pending beacons first. they take priority */
+		ath10k_wmi_tx_beacons_nowait(ar);
+
 		ret = ath10k_wmi_cmd_send_nowait(ar, skb, cmd_id);
 		(ret != -EAGAIN);
 	}), 3*HZ);
@@ -760,10 +808,8 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 	int i = -1;
 	struct wmi_bcn_info *bcn_info;
 	struct ath10k_vif *arvif;
-	struct wmi_bcn_tx_arg arg;
 	struct sk_buff *bcn;
 	int vdev_id = 0;
-	int ret;
 
 	ath10k_dbg(ATH10K_DBG_MGMT, "WMI_HOST_SWBA_EVENTID\n");
 
@@ -820,17 +866,17 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_wmi_update_tim(ar, arvif, bcn, bcn_info);
 		ath10k_wmi_update_noa(ar, arvif, bcn, bcn_info);
 
-		arg.vdev_id = arvif->vdev_id;
-		arg.tx_rate = 0;
-		arg.tx_power = 0;
-		arg.bcn = bcn->data;
-		arg.bcn_len = bcn->len;
+		spin_lock_bh(&ar->data_lock);
+		if (arvif->beacon) {
+			ath10k_warn("SWBA overrun on vdev %d\n",
+				    arvif->vdev_id);
+			dev_kfree_skb_any(arvif->beacon);
+		}
 
-		ret = ath10k_wmi_beacon_send(ar, &arg);
-		if (ret)
-			ath10k_warn("could not send beacon (%d)\n", ret);
+		arvif->beacon = bcn;
 
-		dev_kfree_skb_any(bcn);
+		ath10k_wmi_tx_beacon_nowait(arvif);
+		spin_unlock_bh(&ar->data_lock);
 	}
 }
 
@@ -1181,6 +1227,7 @@ static void ath10k_wmi_process_rx(struct ath10k *ar, struct sk_buff *skb)
 	 * thus can't be defered to a worker thread */
 	switch (event_id) {
 	case WMI_MGMT_RX_EVENTID:
+	case WMI_HOST_SWBA_EVENTID:
 		ath10k_wmi_event_process(ar, skb);
 		return;
 	default:
@@ -2138,7 +2185,8 @@ int ath10k_wmi_peer_assoc(struct ath10k *ar,
 	return ath10k_wmi_cmd_send(ar, skb, WMI_PEER_ASSOC_CMDID);
 }
 
-int ath10k_wmi_beacon_send(struct ath10k *ar, const struct wmi_bcn_tx_arg *arg)
+int ath10k_wmi_beacon_send_nowait(struct ath10k *ar,
+				  const struct wmi_bcn_tx_arg *arg)
 {
 	struct wmi_bcn_tx_cmd *cmd;
 	struct sk_buff *skb;
@@ -2154,7 +2202,7 @@ int ath10k_wmi_beacon_send(struct ath10k *ar, const struct wmi_bcn_tx_arg *arg)
 	cmd->hdr.bcn_len  = __cpu_to_le32(arg->bcn_len);
 	memcpy(cmd->bcn, arg->bcn, arg->bcn_len);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_BCN_TX_CMDID);
+	return ath10k_wmi_cmd_send_nowait(ar, skb, WMI_BCN_TX_CMDID);
 }
 
 static void ath10k_wmi_pdev_set_wmm_param(struct wmi_wmm_params *params,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index ab46582..b100431 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3110,7 +3110,8 @@ int ath10k_wmi_set_ap_ps_param(struct ath10k *ar, u32 vdev_id, const u8 *mac,
 			       enum wmi_ap_ps_peer_param param_id, u32 value);
 int ath10k_wmi_scan_chan_list(struct ath10k *ar,
 			      const struct wmi_scan_chan_list_arg *arg);
-int ath10k_wmi_beacon_send(struct ath10k *ar, const struct wmi_bcn_tx_arg *arg);
+int ath10k_wmi_beacon_send_nowait(struct ath10k *ar,
+				  const struct wmi_bcn_tx_arg *arg);
 int ath10k_wmi_pdev_set_wmm_params(struct ath10k *ar,
 			const struct wmi_pdev_set_wmm_params_arg *arg);
 int ath10k_wmi_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id);
-- 
1.7.9.5

