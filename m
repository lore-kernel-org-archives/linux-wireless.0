Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:46513 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751063AbdLaRbk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 31 Dec 2017 12:31:40 -0500
Received: by mail-lf0-f68.google.com with SMTP id a12so15971694lfe.13
        for <linux-wireless@vger.kernel.org>; Sun, 31 Dec 2017 09:31:39 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v4 06/18] ath10k: per target config of max_num_peers
Date: Sun, 31 Dec 2017 18:29:13 +0100
Message-Id: <20171231172925.24014-7-erik.stromdahl@gmail.com> (sfid-20171231_183206_068716_9388AF98)
In-Reply-To: <20171231172925.24014-1-erik.stromdahl@gmail.com>
References: <20171231172925.24014-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes sure the value of max_num_peers matches
num_peers in hw_params (if set to a non zero value).

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c    | 17 ++++++++++++-----
 drivers/net/wireless/ath/ath10k/hw.h      |  3 +++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  3 +--
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 41e6b5a08885..4e849ec924c6 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1905,6 +1905,7 @@ static void ath10k_core_set_coverage_class_work(struct work_struct *work)
 static int ath10k_core_init_firmware_features(struct ath10k *ar)
 {
 	struct ath10k_fw_file *fw_file = &ar->normal_mode_fw.fw_file;
+	int max_num_peers;
 
 	if (test_bit(ATH10K_FW_FEATURE_WMI_10_2, fw_file->fw_features) &&
 	    !test_bit(ATH10K_FW_FEATURE_WMI_10X, fw_file->fw_features)) {
@@ -1984,7 +1985,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 
 	switch (fw_file->wmi_op_version) {
 	case ATH10K_FW_WMI_OP_VERSION_MAIN:
-		ar->max_num_peers = TARGET_NUM_PEERS;
+		max_num_peers = TARGET_NUM_PEERS;
 		ar->max_num_stations = TARGET_NUM_STATIONS;
 		ar->max_num_vdevs = TARGET_NUM_VDEVS;
 		ar->htt.max_num_pending_tx = TARGET_NUM_MSDU_DESC;
@@ -1996,10 +1997,10 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 	case ATH10K_FW_WMI_OP_VERSION_10_2:
 	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
 		if (ath10k_peer_stats_enabled(ar)) {
-			ar->max_num_peers = TARGET_10X_TX_STATS_NUM_PEERS;
+			max_num_peers = TARGET_10X_TX_STATS_NUM_PEERS;
 			ar->max_num_stations = TARGET_10X_TX_STATS_NUM_STATIONS;
 		} else {
-			ar->max_num_peers = TARGET_10X_NUM_PEERS;
+			max_num_peers = TARGET_10X_NUM_PEERS;
 			ar->max_num_stations = TARGET_10X_NUM_STATIONS;
 		}
 		ar->max_num_vdevs = TARGET_10X_NUM_VDEVS;
@@ -2008,7 +2009,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->max_spatial_stream = WMI_MAX_SPATIAL_STREAM;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_TLV:
-		ar->max_num_peers = TARGET_TLV_NUM_PEERS;
+		max_num_peers = TARGET_TLV_NUM_PEERS;
 		ar->max_num_stations = TARGET_TLV_NUM_STATIONS;
 		ar->max_num_vdevs = TARGET_TLV_NUM_VDEVS;
 		ar->max_num_tdls_vdevs = TARGET_TLV_NUM_TDLS_VDEVS;
@@ -2019,7 +2020,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->max_spatial_stream = WMI_MAX_SPATIAL_STREAM;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_4:
-		ar->max_num_peers = TARGET_10_4_NUM_PEERS;
+		max_num_peers = TARGET_10_4_NUM_PEERS;
 		ar->max_num_stations = TARGET_10_4_NUM_STATIONS;
 		ar->num_active_peers = TARGET_10_4_ACTIVE_PEERS;
 		ar->max_num_vdevs = TARGET_10_4_NUM_VDEVS;
@@ -2037,10 +2038,16 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_UNSET:
 	case ATH10K_FW_WMI_OP_VERSION_MAX:
+	default:
 		WARN_ON(1);
 		return -EINVAL;
 	}
 
+	if (ar->hw_params.num_peers)
+		ar->max_num_peers = ar->hw_params.num_peers;
+	else
+		ar->max_num_peers = max_num_peers;
+
 	/* Backwards compatibility for firmwares without
 	 * ATH10K_FW_IE_HTT_OP_VERSION.
 	 */
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 3043fd17942e..53276950c95c 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -692,6 +692,9 @@ ath10k_rx_desc_get_l3_pad_bytes(struct ath10k_hw_params *hw,
 #define TARGET_HL_10_TLV_AST_SKID_LIMIT		6
 #define TARGET_HL_10_TLV_NUM_WDS_ENTRIES	2
 
+/* Target specific defines for QCA9377 high latency firmware */
+#define TARGET_QCA9377_HL_NUM_PEERS		15
+
 /* Diagnostic Window */
 #define CE_DIAG_PIPE	7
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index ae77a007ae07..6b58bcbb36c1 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1439,7 +1439,6 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	cmd->num_host_mem_chunks = __cpu_to_le32(ar->wmi.num_mem_chunks);
 
 	cfg->num_vdevs = __cpu_to_le32(TARGET_TLV_NUM_VDEVS);
-
 	cfg->num_peers = __cpu_to_le32(ar->hw_params.num_peers);
 	cfg->ast_skid_limit = __cpu_to_le32(ar->hw_params.ast_skid_limit);
 	cfg->num_wds_entries = __cpu_to_le32(ar->hw_params.num_wds_entries);
@@ -1453,7 +1452,7 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	}
 
 	cfg->num_peer_keys = __cpu_to_le32(2);
-	cfg->num_tids = __cpu_to_le32(TARGET_TLV_NUM_TIDS);
+	cfg->num_tids = __cpu_to_le32(ar->hw_params.num_peers * 2);
 	cfg->tx_chain_mask = __cpu_to_le32(0x7);
 	cfg->rx_chain_mask = __cpu_to_le32(0x7);
 	cfg->rx_timeout_pri[0] = __cpu_to_le32(0x64);
-- 
2.15.1
