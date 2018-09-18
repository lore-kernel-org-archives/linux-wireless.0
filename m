Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60730 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbeIRMDC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 08:03:02 -0400
From: Maharaja Kennadyrajan <mkenna@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>
Subject: [PATCH] ath10k: Add debugfs support to get power save state change  of STA
Date: Tue, 18 Sep 2018 12:04:27 +0530
Message-Id: <1537252467-17353-1-git-send-email-mkenna@codeaurora.org> (sfid-20180918_083158_251494_AC844DF4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch helps to get the power save state change of each peer
connected to the AP. With WMI_10_4_PEER_STA_PS_STATECHG_EVENTID
event, ps state of each peer is reported to user space via
debugfs.

Use the below command to get the ps state of each sta:
cat /sys/kernel/debug/ieee80211/phyX/netdev::wlanX/stations/
XX:XX:XX:XX:XX:XX/peer_ps_state

If STA is in power save state, we get the peer_ps_state value as 1.
if STA is not in power save state, we get the peer_ps_state value as 0.
If ps_state event is disabled, we get the peer_ps_state value as 2.

We can enable/disable the ps_state events using the debugfs flag
"ps_state_enable"

echo Y > /sys/kernel/debug/ieee80211/phyX/ath10k/ps_state_enable

Y = 1 to enable and Y = 0 to disable

Tested in QCA4019 with firmware ver 10.4-3.2.1.1-00011

Signed-off-by: Maharaja Kennadyrajan <mkenna@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.h        |  4 ++
 drivers/net/wireless/ath/ath10k/debug.c       | 82 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/debugfs_sta.c | 29 ++++++++++
 drivers/net/wireless/ath/ath10k/mac.c         |  1 +
 drivers/net/wireless/ath/ath10k/wmi.c         | 39 ++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h         |  7 +++
 6 files changed, 161 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index f6e5c29..66f50f3 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -505,6 +505,8 @@ struct ath10k_sta {
 	/* Protected with ar->data_lock */
 	struct ath10k_sta_tid_stats tid_stats[IEEE80211_NUM_TIDS + 1];
 #endif
+	/* Protected with ar->data_lock */
+	u32 peer_ps_state;
 };
 
 #define ATH10K_VDEV_SETUP_TIMEOUT_HZ (5 * HZ)
@@ -946,6 +948,8 @@ struct ath10k {
 	u32 low_5ghz_chan;
 	u32 high_5ghz_chan;
 	bool ani_enabled;
+	/* protected by conf_mutex */
+	u8 ps_state_enable;
 
 	bool p2p;
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index ada29a4..2c0cb67 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2398,6 +2398,85 @@ static ssize_t ath10k_write_warm_hw_reset(struct file *file,
 	.llseek = default_llseek,
 };
 
+static void ath10k_peer_ps_state_disable(void *data,
+					 struct ieee80211_sta *sta)
+{
+	struct ath10k *ar = data;
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+
+	spin_lock_bh(&ar->data_lock);
+	arsta->peer_ps_state = WMI_PEER_PS_STATE_DISABLED;
+	spin_unlock_bh(&ar->data_lock);
+}
+
+static ssize_t ath10k_write_ps_state_enable(struct file *file,
+					    const char __user *user_buf,
+					    size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	int ret;
+	u32 param;
+	u8 ps_state_enable;
+
+	if (kstrtou8_from_user(user_buf, count, 0, &ps_state_enable))
+		return -EINVAL;
+
+	if (ps_state_enable > 1 || ps_state_enable < 0)
+		return -EINVAL;
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (ar->ps_state_enable == ps_state_enable) {
+		ret = count;
+		goto exit;
+	}
+
+	param = ar->wmi.pdev_param->peer_sta_ps_statechg_enable;
+	ret = ath10k_wmi_pdev_set_param(ar, param, ps_state_enable);
+	if (ret) {
+		ath10k_warn(ar, "failed to enable ps_state_enable: %d\n",
+			    ret);
+		goto exit;
+	}
+	ar->ps_state_enable = ps_state_enable;
+
+	if (!ar->ps_state_enable)
+		ieee80211_iterate_stations_atomic(ar->hw,
+						  ath10k_peer_ps_state_disable,
+						  ar);
+
+	ret = count;
+
+exit:
+	mutex_unlock(&ar->conf_mutex);
+
+	return ret;
+}
+
+static ssize_t ath10k_read_ps_state_enable(struct file *file,
+					   char __user *user_buf,
+					   size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	int len = 0;
+	char buf[32];
+
+	mutex_lock(&ar->conf_mutex);
+	len = scnprintf(buf, sizeof(buf) - len, "%d\n",
+			ar->ps_state_enable);
+	mutex_unlock(&ar->conf_mutex);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_ps_state_enable = {
+	.read = ath10k_read_ps_state_enable,
+	.write = ath10k_write_ps_state_enable,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath10k_debug_create(struct ath10k *ar)
 {
 	ar->debug.cal_data = vzalloc(ATH10K_DEBUG_CAL_DATA_LEN);
@@ -2534,6 +2613,9 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("warm_hw_reset", 0600, ar->debug.debugfs_phy, ar,
 			    &fops_warm_hw_reset);
 
+	debugfs_create_file("ps_state_enable", 0600, ar->debug.debugfs_phy, ar,
+			    &fops_ps_state_enable);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index 929f2f6..b09cdc69 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -460,6 +460,33 @@ static ssize_t ath10k_dbg_sta_read_peer_debug_trigger(struct file *file,
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_dbg_sta_read_peer_ps_state(struct file *file,
+						 char __user *user_buf,
+						 size_t count, loff_t *ppos)
+{
+	struct ieee80211_sta *sta = file->private_data;
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	struct ath10k *ar = arsta->arvif->ar;
+	char buf[20];
+	int len = 0;
+
+	spin_lock_bh(&ar->data_lock);
+
+	len = scnprintf(buf, sizeof(buf) - len, "%d\n",
+			arsta->peer_ps_state);
+
+	spin_unlock_bh(&ar->data_lock);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_peer_ps_state = {
+	.open = simple_open,
+	.read = ath10k_dbg_sta_read_peer_ps_state,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static char *get_err_str(enum ath10k_pkt_rx_err i)
 {
 	switch (i) {
@@ -738,4 +765,6 @@ void ath10k_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	    ath10k_debug_is_extd_tx_stats_enabled(ar))
 		debugfs_create_file("tx_stats", 0400, dir, sta,
 				    &fops_tx_stats);
+	debugfs_create_file("peer_ps_state", 0400, dir, sta,
+			    &fops_peer_ps_state);
 }
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 532fc5d..60489c2 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6216,6 +6216,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 	    new_state == IEEE80211_STA_NONE) {
 		memset(arsta, 0, sizeof(*arsta));
 		arsta->arvif = arvif;
+		arsta->peer_ps_state = WMI_PEER_PS_STATE_DISABLED;
 		INIT_WORK(&arsta->update_wk, ath10k_sta_rc_update_wk);
 
 		for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 0f9fccc..182717e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1307,7 +1307,8 @@
 	.set_mcast2ucast_mode = WMI_PDEV_PARAM_UNSUPPORTED,
 	.set_mcast2ucast_buffer = WMI_PDEV_PARAM_UNSUPPORTED,
 	.remove_mcast2ucast_buffer = WMI_PDEV_PARAM_UNSUPPORTED,
-	.peer_sta_ps_statechg_enable = WMI_PDEV_PARAM_UNSUPPORTED,
+	.peer_sta_ps_statechg_enable =
+				WMI_10X_PDEV_PARAM_PEER_STA_PS_STATECHG_ENABLE,
 	.igmpmld_ac_override = WMI_PDEV_PARAM_UNSUPPORTED,
 	.block_interbss = WMI_PDEV_PARAM_UNSUPPORTED,
 	.set_disable_reset_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
@@ -5030,6 +5031,36 @@ void ath10k_wmi_event_tpc_final_table(struct ath10k *ar, struct sk_buff *skb)
 	}
 }
 
+void
+ath10k_wmi_event_peer_sta_ps_state_chg(struct ath10k *ar, struct sk_buff *skb)
+{
+	struct wmi_peer_sta_ps_state_chg_event *ev;
+	struct ieee80211_sta *sta;
+	struct ath10k_sta *arsta;
+	u8 peer_addr[ETH_ALEN];
+
+	lockdep_assert_held(&ar->data_lock);
+
+	ev = (struct wmi_peer_sta_ps_state_chg_event *)skb->data;
+	ether_addr_copy(peer_addr, ev->peer_macaddr.addr);
+
+	rcu_read_lock();
+
+	sta = ieee80211_find_sta_by_ifaddr(ar->hw, peer_addr, NULL);
+
+	if (!sta) {
+		ath10k_warn(ar, "failed to find station entry %pM\n",
+			    peer_addr);
+		goto exit;
+	}
+
+	arsta = (struct ath10k_sta *)sta->drv_priv;
+	arsta->peer_ps_state = __le32_to_cpu(ev->peer_ps_state);
+
+exit:
+	rcu_read_unlock();
+}
+
 void ath10k_wmi_event_pdev_ftm_intg(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_PDEV_FTM_INTG_EVENTID\n");
@@ -5960,6 +5991,9 @@ static void ath10k_wmi_10_2_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_dbg(ar, ATH10K_DBG_WMI,
 			   "received event id %d not implemented\n", id);
 		break;
+	case WMI_10_2_PEER_STA_PS_STATECHG_EVENTID:
+		ath10k_wmi_event_peer_sta_ps_state_chg(ar, skb);
+		break;
 	default:
 		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
@@ -6077,6 +6111,9 @@ static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_10_4_DFS_STATUS_CHECK_EVENTID:
 		ath10k_wmi_event_dfs_status_check(ar, skb);
 		break;
+	case WMI_10_4_PEER_STA_PS_STATECHG_EVENTID:
+		ath10k_wmi_event_peer_sta_ps_state_chg(ar, skb);
+		break;
 	default:
 		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 126eb17..36f80ae 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4170,6 +4170,13 @@ enum wmi_tpc_pream_5ghz {
 	WMI_TPC_PREAM_5GHZ_HTCUP,
 };
 
+#define	WMI_PEER_PS_STATE_DISABLED	2
+
+struct wmi_peer_sta_ps_state_chg_event {
+	struct wmi_mac_addr peer_macaddr;
+	__le32 peer_ps_state;
+} __packed;
+
 struct wmi_pdev_chanlist_update_event {
 	/* number of channels */
 	__le32 num_chan;
-- 
1.9.1
