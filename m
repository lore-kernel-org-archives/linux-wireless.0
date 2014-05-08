Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51784 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbaEHQS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2014 12:18:28 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 2/2] ath10k:  support get/set antenna configurations.
Date: Thu,  8 May 2014 09:18:16 -0700
Message-Id: <1399565896-29791-1-git-send-email-greearb@candelatech.com> (sfid-20140508_181837_811502_193590E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Tested with CT firmware, but should work on standard
firmware as well.

Verified that target's tx/rx chain register is set appropriately,
and that the tx rate goes down as number of chains
decrease, but I did not actually try to verify antenna
ceased to transmit when disabled.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Fixes suggested by Michal Kazior.

 drivers/net/wireless/ath/ath10k/core.h |  6 +++
 drivers/net/wireless/ath/ath10k/mac.c  | 72 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c  |  5 +++
 3 files changed, 83 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 7050c47..791d76d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -472,6 +472,12 @@ struct ath10k {
 	u32 dfs_block_radar_events;
 	int install_key_rv; /* Store error code from key-install */
 
+	/* Protected by conf-mutex */
+	unsigned char supp_tx_chainmask;
+	unsigned char supp_rx_chainmask;
+	unsigned char cfg_tx_chainmask;
+	unsigned char cfg_rx_chainmask;
+
 	struct wmi_pdev_set_wmm_params_arg wmm_params;
 	struct completion install_key_done;
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index dcb147d..01ba41e 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2483,6 +2483,69 @@ void ath10k_halt(struct ath10k *ar)
 	spin_unlock_bh(&ar->data_lock);
 }
 
+static int ath10k_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant)
+{
+	struct ath10k *ar = hw->priv;
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (ar->cfg_tx_chainmask) {
+		*tx_ant = ar->cfg_tx_chainmask;
+		*rx_ant = ar->cfg_rx_chainmask;
+	} else {
+		*tx_ant = ar->supp_tx_chainmask;
+		*rx_ant = ar->supp_rx_chainmask;
+	}
+
+	mutex_unlock(&ar->conf_mutex);
+
+	return 0;
+}
+
+static int __ath10k_set_antenna(struct ath10k *ar, u32 tx_ant, u32 rx_ant)
+{
+	int ret;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	ar->cfg_tx_chainmask = tx_ant;
+	ar->cfg_rx_chainmask = rx_ant;
+
+	if ((ar->state != ATH10K_STATE_ON) &&
+	    (ar->state != ATH10K_STATE_RESTARTED))
+		return 0;
+
+	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->tx_chain_mask,
+					tx_ant);
+	if (ret) {
+		ath10k_warn("failed to set tx-chainmask: %d, req 0x%x\n",
+			    ret, tx_ant);
+		return ret;
+	}
+
+	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->rx_chain_mask,
+					rx_ant);
+	if (ret) {
+		ath10k_warn("failed to set rx-chainmask: %d, req 0x%x\n",
+			    ret, rx_ant);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ath10k_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant)
+{
+	struct ath10k *ar = hw->priv;
+	int ret;
+
+	mutex_lock(&ar->conf_mutex);
+	ret = __ath10k_set_antenna(ar, tx_ant, rx_ant);
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
+
 static int ath10k_start(struct ieee80211_hw *hw)
 {
 	struct ath10k *ar = hw->priv;
@@ -2530,6 +2593,10 @@ static int ath10k_start(struct ieee80211_hw *hw)
 	if (ret)
 		ath10k_warn("failed to enable dynamic BW: %d\n", ret);
 
+	if (ar->cfg_tx_chainmask)
+		__ath10k_set_antenna(ar, ar->cfg_tx_chainmask,
+				     ar->cfg_rx_chainmask);
+
 	/*
 	 * By default FW set ARP frames ac to voice (6). In that case ARP
 	 * exchange is not working properly for UAPSD enabled AP. ARP requests
@@ -4437,6 +4504,8 @@ static const struct ieee80211_ops ath10k_ops = {
 	.set_frag_threshold		= ath10k_set_frag_threshold,
 	.flush				= ath10k_flush,
 	.tx_last_beacon			= ath10k_tx_last_beacon,
+	.set_antenna			= ath10k_set_antenna,
+	.get_antenna			= ath10k_get_antenna,
 	.restart_complete		= ath10k_restart_complete,
 	.get_survey			= ath10k_get_survey,
 	.set_bitrate_mask		= ath10k_set_bitrate_mask,
@@ -4818,6 +4887,9 @@ int ath10k_mac_register(struct ath10k *ar)
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_AP);
 
+	ar->hw->wiphy->available_antennas_rx = ar->supp_rx_chainmask;
+	ar->hw->wiphy->available_antennas_tx = ar->supp_tx_chainmask;
+
 	if (!test_bit(ATH10K_FW_FEATURE_NO_P2P, ar->fw_features))
 		ar->hw->wiphy->interface_modes |=
 			BIT(NL80211_IFTYPE_P2P_CLIENT) |
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 82a827e..d82b740 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2601,6 +2601,8 @@ static int ath10k_wmi_main_cmd_init(struct ath10k *ar)
 	config.ast_skid_limit = __cpu_to_le32(TARGET_AST_SKID_LIMIT);
 	config.tx_chain_mask = __cpu_to_le32(TARGET_TX_CHAIN_MASK);
 	config.rx_chain_mask = __cpu_to_le32(TARGET_RX_CHAIN_MASK);
+	ar->supp_tx_chainmask = TARGET_TX_CHAIN_MASK;
+	ar->supp_rx_chainmask = TARGET_RX_CHAIN_MASK;
 	config.rx_timeout_pri_vo = __cpu_to_le32(TARGET_RX_TIMEOUT_LO_PRI);
 	config.rx_timeout_pri_vi = __cpu_to_le32(TARGET_RX_TIMEOUT_LO_PRI);
 	config.rx_timeout_pri_be = __cpu_to_le32(TARGET_RX_TIMEOUT_LO_PRI);
@@ -2721,6 +2723,9 @@ static int ath10k_wmi_10x_cmd_init(struct ath10k *ar)
 	config.num_tids = __cpu_to_le32(TARGET_10X_NUM_TIDS);
 	config.tx_chain_mask = __cpu_to_le32(TARGET_10X_TX_CHAIN_MASK);
 	config.rx_chain_mask = __cpu_to_le32(TARGET_10X_RX_CHAIN_MASK);
+	/* TODO:  Have to deal with 2x2 chips if/when the come out. */
+	ar->supp_tx_chainmask = TARGET_10X_TX_CHAIN_MASK;
+	ar->supp_rx_chainmask = TARGET_10X_RX_CHAIN_MASK;
 	config.rx_timeout_pri_vo = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
 	config.rx_timeout_pri_vi = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
 	config.rx_timeout_pri_be = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
-- 
1.7.11.7

