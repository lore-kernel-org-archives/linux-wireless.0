Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59666 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbcDTQpa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2016 12:45:30 -0400
Subject: [PATCH v2 4/8] ath10k: move fw_features to struct ath10k_fw_file
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 20 Apr 2016 19:45:18 +0300
Message-ID: <20160420164518.8801.70083.stgit@potku.adurom.net> (sfid-20160420_184533_595555_6965F56A)
In-Reply-To: <20160420164301.8801.12099.stgit@potku.adurom.net>
References: <20160420164301.8801.12099.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preparation for testmode.c to use ath10k_core_fetch_board_data_api_n().

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c     |   28 +++++++++++++++-------------
 drivers/net/wireless/ath/ath10k/core.h     |    5 ++---
 drivers/net/wireless/ath/ath10k/htt_rx.c   |    2 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c   |    9 ++++++---
 drivers/net/wireless/ath/ath10k/mac.c      |   14 ++++++++------
 drivers/net/wireless/ath/ath10k/testmode.c |   14 --------------
 drivers/net/wireless/ath/ath10k/wmi.c      |    5 +++--
 drivers/net/wireless/ath/ath10k/wow.c      |    7 ++++---
 8 files changed, 39 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 015241aec608..71b8ca71d1da 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -261,7 +261,7 @@ void ath10k_core_get_fw_features_str(struct ath10k *ar,
 	int i;
 
 	for (i = 0; i < ATH10K_FW_FEATURE_COUNT; i++) {
-		if (test_bit(i, ar->fw_features)) {
+		if (test_bit(i, ar->normal_mode_fw.fw_file.fw_features)) {
 			if (len > 0)
 				len += scnprintf(buf + len, buf_len - len, ",");
 
@@ -627,7 +627,7 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot otp execute result %d\n", result);
 
 	if (!(skip_otp || test_bit(ATH10K_FW_FEATURE_IGNORE_OTP_RESULT,
-				   ar->fw_features)) &&
+				   ar->running_fw->fw_file.fw_features)) &&
 	    result != 0) {
 		ath10k_err(ar, "otp calibration failed: %d", result);
 		return -EINVAL;
@@ -1074,13 +1074,13 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
 					ath10k_dbg(ar, ATH10K_DBG_BOOT,
 						   "Enabling feature bit: %i\n",
 						   i);
-					__set_bit(i, ar->fw_features);
+					__set_bit(i, fw_file->fw_features);
 				}
 			}
 
 			ath10k_dbg_dump(ar, ATH10K_DBG_BOOT, "features", "",
-					ar->fw_features,
-					sizeof(ar->fw_features));
+					ar->running_fw->fw_file.fw_features,
+					sizeof(fw_file->fw_features));
 			break;
 		case ATH10K_FW_IE_FW_IMAGE:
 			ath10k_dbg(ar, ATH10K_DBG_BOOT,
@@ -1430,8 +1430,10 @@ static void ath10k_core_restart(struct work_struct *work)
 
 static int ath10k_core_init_firmware_features(struct ath10k *ar)
 {
-	if (test_bit(ATH10K_FW_FEATURE_WMI_10_2, ar->fw_features) &&
-	    !test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
+	struct ath10k_fw_file *fw_file = &ar->normal_mode_fw.fw_file;
+
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10_2, fw_file->fw_features) &&
+	    !test_bit(ATH10K_FW_FEATURE_WMI_10X, fw_file->fw_features)) {
 		ath10k_err(ar, "feature bits corrupted: 10.2 feature requires 10.x feature to be set as well");
 		return -EINVAL;
 	}
@@ -1450,7 +1452,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		break;
 	case ATH10K_CRYPT_MODE_SW:
 		if (!test_bit(ATH10K_FW_FEATURE_RAW_MODE_SUPPORT,
-			      ar->fw_features)) {
+			      fw_file->fw_features)) {
 			ath10k_err(ar, "cryptmode > 0 requires raw mode support from firmware");
 			return -EINVAL;
 		}
@@ -1469,7 +1471,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 
 	if (rawmode) {
 		if (!test_bit(ATH10K_FW_FEATURE_RAW_MODE_SUPPORT,
-			      ar->fw_features)) {
+			      fw_file->fw_features)) {
 			ath10k_err(ar, "rawmode = 1 requires support from firmware");
 			return -EINVAL;
 		}
@@ -1495,9 +1497,9 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 	 * ATH10K_FW_IE_WMI_OP_VERSION.
 	 */
 	if (ar->wmi.op_version == ATH10K_FW_WMI_OP_VERSION_UNSET) {
-		if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
+		if (test_bit(ATH10K_FW_FEATURE_WMI_10X, fw_file->fw_features)) {
 			if (test_bit(ATH10K_FW_FEATURE_WMI_10_2,
-				     ar->fw_features))
+				     fw_file->fw_features))
 				ar->wmi.op_version = ATH10K_FW_WMI_OP_VERSION_10_2;
 			else
 				ar->wmi.op_version = ATH10K_FW_WMI_OP_VERSION_10_1;
@@ -1553,7 +1555,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->max_spatial_stream = ar->hw_params.max_spatial_stream;
 
 		if (test_bit(ATH10K_FW_FEATURE_PEER_FLOW_CONTROL,
-			     ar->fw_features))
+			     fw_file->fw_features))
 			ar->htt.max_num_pending_tx = TARGET_10_4_NUM_MSDU_DESC_PFC;
 		else
 			ar->htt.max_num_pending_tx = TARGET_10_4_NUM_MSDU_DESC;
@@ -1621,7 +1623,7 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 	 * to set the clock source once the target is initialized.
 	 */
 	if (test_bit(ATH10K_FW_FEATURE_SUPPORTS_SKIP_CLOCK_INIT,
-		     ar->fw_features)) {
+		     ar->running_fw->fw_file.fw_features)) {
 		status = ath10k_bmi_write32(ar, hi_skip_clock_init, 1);
 		if (status) {
 			ath10k_err(ar, "could not write to skip_clock_init: %d\n",
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index e99f664bde9e..0ee6ae4fbae0 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -632,6 +632,8 @@ struct ath10k_fw_file {
 
 	char fw_version[ETHTOOL_FWVERS_LEN];
 
+	DECLARE_BITMAP(fw_features, ATH10K_FW_FEATURE_COUNT);
+
 	const void *firmware_data;
 	size_t firmware_len;
 
@@ -675,8 +677,6 @@ struct ath10k {
 	/* protected by conf_mutex */
 	bool ani_enabled;
 
-	DECLARE_BITMAP(fw_features, ATH10K_FW_FEATURE_COUNT);
-
 	bool p2p;
 
 	struct {
@@ -895,7 +895,6 @@ struct ath10k {
 	struct {
 		/* protected by conf_mutex */
 		struct ath10k_fw_components utf_mode_fw;
-		DECLARE_BITMAP(orig_fw_features, ATH10K_FW_FEATURE_COUNT);
 		enum ath10k_fw_wmi_op_version orig_wmi_op_version;
 		enum ath10k_fw_wmi_op_version op_version;
 
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 079fef5b7ef2..cc979a4faeb0 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -966,7 +966,7 @@ static int ath10k_htt_rx_nwifi_hdrlen(struct ath10k *ar,
 	int len = ieee80211_hdrlen(hdr->frame_control);
 
 	if (!test_bit(ATH10K_FW_FEATURE_NO_NWIFI_DECAP_4ADDR_PADDING,
-		      ar->fw_features))
+		      ar->running_fw->fw_file.fw_features))
 		len = round_up(len, 4);
 
 	return len;
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 9baa2e677f8a..6269c610b0a3 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -267,7 +267,8 @@ static void ath10k_htt_tx_free_txq(struct ath10k_htt *htt)
 	struct ath10k *ar = htt->ar;
 	size_t size;
 
-	if (!test_bit(ATH10K_FW_FEATURE_PEER_FLOW_CONTROL, ar->fw_features))
+	if (!test_bit(ATH10K_FW_FEATURE_PEER_FLOW_CONTROL,
+		      ar->running_fw->fw_file.fw_features))
 		return;
 
 	size = sizeof(*htt->tx_q_state.vaddr);
@@ -282,7 +283,8 @@ static int ath10k_htt_tx_alloc_txq(struct ath10k_htt *htt)
 	size_t size;
 	int ret;
 
-	if (!test_bit(ATH10K_FW_FEATURE_PEER_FLOW_CONTROL, ar->fw_features))
+	if (!test_bit(ATH10K_FW_FEATURE_PEER_FLOW_CONTROL,
+		      ar->running_fw->fw_file.fw_features))
 		return 0;
 
 	htt->tx_q_state.num_peers = HTT_TX_Q_STATE_NUM_PEERS;
@@ -513,7 +515,8 @@ int ath10k_htt_send_frag_desc_bank_cfg(struct ath10k_htt *htt)
 	info |= SM(htt->tx_q_state.type,
 		   HTT_FRAG_DESC_BANK_CFG_INFO_Q_STATE_DEPTH_TYPE);
 
-	if (test_bit(ATH10K_FW_FEATURE_PEER_FLOW_CONTROL, ar->fw_features))
+	if (test_bit(ATH10K_FW_FEATURE_PEER_FLOW_CONTROL,
+		     ar->running_fw->fw_file.fw_features))
 		info |= HTT_FRAG_DESC_BANK_CFG_INFO_Q_STATE_VALID;
 
 	cfg = &cmd->frag_desc_bank_cfg;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e2c6322396ca..a0464bc0a8b0 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1772,7 +1772,7 @@ static int ath10k_mac_vif_setup_ps(struct ath10k_vif *arvif)
 
 	if (enable_ps && ath10k_mac_num_vifs_started(ar) > 1 &&
 	    !test_bit(ATH10K_FW_FEATURE_MULTI_VIF_PS_SUPPORT,
-		      ar->fw_features)) {
+		      ar->running_fw->fw_file.fw_features)) {
 		ath10k_warn(ar, "refusing to enable ps on vdev %i: not supported by fw\n",
 			    arvif->vdev_id);
 		enable_ps = false;
@@ -2060,7 +2060,8 @@ static void ath10k_peer_assoc_h_crypto(struct ath10k *ar,
 	}
 
 	if (sta->mfp &&
-	    test_bit(ATH10K_FW_FEATURE_MFP_SUPPORT, ar->fw_features)) {
+	    test_bit(ATH10K_FW_FEATURE_MFP_SUPPORT,
+		     ar->running_fw->fw_file.fw_features)) {
 		arg->peer_flags |= ar->wmi.peer_flags->pmf;
 	}
 }
@@ -3207,7 +3208,8 @@ ath10k_mac_tx_h_get_txmode(struct ath10k *ar,
 	 */
 	if (ar->htt.target_version_major < 3 &&
 	    (ieee80211_is_nullfunc(fc) || ieee80211_is_qos_nullfunc(fc)) &&
-	    !test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX, ar->fw_features))
+	    !test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX,
+		      ar->running_fw->fw_file.fw_features))
 		return ATH10K_HW_TXRX_MGMT;
 
 	/* Workaround:
@@ -3394,7 +3396,7 @@ ath10k_mac_tx_h_get_txpath(struct ath10k *ar,
 		return ATH10K_MAC_TX_HTT;
 	case ATH10K_HW_TXRX_MGMT:
 		if (test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX,
-			     ar->fw_features))
+			     ar->running_fw->fw_file.fw_features))
 			return ATH10K_MAC_TX_WMI_MGMT;
 		else if (ar->htt.target_version_major >= 3)
 			return ATH10K_MAC_TX_HTT;
@@ -4435,7 +4437,7 @@ static int ath10k_start(struct ieee80211_hw *hw)
 	}
 
 	if (test_bit(ATH10K_FW_FEATURE_SUPPORTS_ADAPTIVE_CCA,
-		     ar->fw_features)) {
+		     ar->running_fw->fw_file.fw_features)) {
 		ret = ath10k_wmi_pdev_enable_adaptive_cca(ar, 1,
 							  WMI_CCA_DETECT_LEVEL_AUTO,
 							  WMI_CCA_DETECT_MARGIN_AUTO);
@@ -7694,7 +7696,7 @@ int ath10k_mac_register(struct ath10k *ar)
 	ar->hw->wiphy->available_antennas_rx = ar->cfg_rx_chainmask;
 	ar->hw->wiphy->available_antennas_tx = ar->cfg_tx_chainmask;
 
-	if (!test_bit(ATH10K_FW_FEATURE_NO_P2P, ar->fw_features))
+	if (!test_bit(ATH10K_FW_FEATURE_NO_P2P, ar->normal_mode_fw.fw_file.fw_features))
 		ar->hw->wiphy->interface_modes |=
 			BIT(NL80211_IFTYPE_P2P_DEVICE) |
 			BIT(NL80211_IFTYPE_P2P_CLIENT) |
diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
index 2c4a5d31cf0c..102539409f54 100644
--- a/drivers/net/wireless/ath/ath10k/testmode.c
+++ b/drivers/net/wireless/ath/ath10k/testmode.c
@@ -362,14 +362,8 @@ static int ath10k_tm_cmd_utf_start(struct ath10k *ar, struct nlattr *tb[])
 	spin_lock_bh(&ar->data_lock);
 	ar->testmode.utf_monitor = true;
 	spin_unlock_bh(&ar->data_lock);
-	BUILD_BUG_ON(sizeof(ar->fw_features) !=
-		     sizeof(ar->testmode.orig_fw_features));
 
-	memcpy(ar->testmode.orig_fw_features, ar->fw_features,
-	       sizeof(ar->fw_features));
 	ar->testmode.orig_wmi_op_version = ar->wmi.op_version;
-	memset(ar->fw_features, 0, sizeof(ar->fw_features));
-
 	ar->wmi.op_version = ar->testmode.op_version;
 
 	ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "testmode wmi version %d\n",
@@ -407,9 +401,6 @@ err_power_down:
 	ath10k_hif_power_down(ar);
 
 err_fw_features:
-	/* return the original firmware features */
-	memcpy(ar->fw_features, ar->testmode.orig_fw_features,
-	       sizeof(ar->fw_features));
 	ar->wmi.op_version = ar->testmode.orig_wmi_op_version;
 
 	release_firmware(ar->testmode.utf_mode_fw.fw_file.firmware);
@@ -434,11 +425,6 @@ static void __ath10k_tm_cmd_utf_stop(struct ath10k *ar)
 
 	spin_unlock_bh(&ar->data_lock);
 
-	/* return the original firmware features */
-	memcpy(ar->fw_features, ar->testmode.orig_fw_features,
-	       sizeof(ar->fw_features));
-	ar->wmi.op_version = ar->testmode.orig_wmi_op_version;
-
 	release_firmware(ar->testmode.utf_mode_fw.fw_file.firmware);
 	ar->testmode.utf_mode_fw.fw_file.firmware = NULL;
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index e711346b6ca9..130d4efa59f4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2149,7 +2149,8 @@ static int ath10k_wmi_op_pull_mgmt_rx_ev(struct ath10k *ar, struct sk_buff *skb,
 	u32 msdu_len;
 	u32 len;
 
-	if (test_bit(ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX, ar->fw_features)) {
+	if (test_bit(ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX,
+		     ar->running_fw->fw_file.fw_features)) {
 		ev_v2 = (struct wmi_mgmt_rx_event_v2 *)skb->data;
 		ev_hdr = &ev_v2->hdr.v1;
 		pull_len = sizeof(*ev_v2);
@@ -4634,7 +4635,7 @@ static void ath10k_wmi_event_service_ready_work(struct work_struct *work)
 
 	if (test_bit(WMI_SERVICE_PEER_CACHING, ar->wmi.svc_map)) {
 		if (test_bit(ATH10K_FW_FEATURE_PEER_FLOW_CONTROL,
-			     ar->fw_features))
+			     ar->running_fw->fw_file.fw_features))
 			ar->num_active_peers = TARGET_10_4_QCACHE_ACTIVE_PEERS_PFC +
 					       ar->max_num_vdevs;
 		else
diff --git a/drivers/net/wireless/ath/ath10k/wow.c b/drivers/net/wireless/ath/ath10k/wow.c
index 8e02b381990f..77100d42f401 100644
--- a/drivers/net/wireless/ath/ath10k/wow.c
+++ b/drivers/net/wireless/ath/ath10k/wow.c
@@ -233,7 +233,7 @@ int ath10k_wow_op_suspend(struct ieee80211_hw *hw,
 	mutex_lock(&ar->conf_mutex);
 
 	if (WARN_ON(!test_bit(ATH10K_FW_FEATURE_WOWLAN_SUPPORT,
-			      ar->fw_features))) {
+			      ar->running_fw->fw_file.fw_features))) {
 		ret = 1;
 		goto exit;
 	}
@@ -285,7 +285,7 @@ int ath10k_wow_op_resume(struct ieee80211_hw *hw)
 	mutex_lock(&ar->conf_mutex);
 
 	if (WARN_ON(!test_bit(ATH10K_FW_FEATURE_WOWLAN_SUPPORT,
-			      ar->fw_features))) {
+			      ar->running_fw->fw_file.fw_features))) {
 		ret = 1;
 		goto exit;
 	}
@@ -325,7 +325,8 @@ exit:
 
 int ath10k_wow_init(struct ath10k *ar)
 {
-	if (!test_bit(ATH10K_FW_FEATURE_WOWLAN_SUPPORT, ar->fw_features))
+	if (!test_bit(ATH10K_FW_FEATURE_WOWLAN_SUPPORT,
+		      ar->running_fw->fw_file.fw_features))
 		return 0;
 
 	if (WARN_ON(!test_bit(WMI_SERVICE_WOW, ar->wmi.svc_map)))

