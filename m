Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:25672 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbbFVOyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 10:54:37 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH v2 7/8] ath10k: set max spatial stream to 4 for 10.4 fw
Date: Mon, 22 Jun 2015 20:22:26 +0530
Message-ID: <1434984747-24294-8-git-send-email-rmani@qti.qualcomm.com> (sfid-20150622_165452_261590_881EF313)
In-Reply-To: <1434984747-24294-1-git-send-email-rmani@qti.qualcomm.com>
References: <1434984747-24294-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

10.4 fw supports upto 4 spatial stream. Limit max spatial
stream to 4 for 10.4 firmware and to 3 for non 10.4 firmware.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 4 ++++
 drivers/net/wireless/ath/ath10k/core.h | 1 +
 drivers/net/wireless/ath/ath10k/wmi.c  | 6 +++---
 drivers/net/wireless/ath/ath10k/wmi.h  | 3 ++-
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index b43565d..3c8d5c5 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1095,6 +1095,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->htt.max_num_pending_tx = TARGET_NUM_MSDU_DESC;
 		ar->fw_stats_req_mask = WMI_STAT_PDEV | WMI_STAT_VDEV |
 			WMI_STAT_PEER;
+		ar->max_spatial_stream = WMI_MAX_SPATIAL_STREAM;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_1:
 	case ATH10K_FW_WMI_OP_VERSION_10_2:
@@ -1104,6 +1105,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->max_num_vdevs = TARGET_10X_NUM_VDEVS;
 		ar->htt.max_num_pending_tx = TARGET_10X_NUM_MSDU_DESC;
 		ar->fw_stats_req_mask = WMI_STAT_PEER;
+		ar->max_spatial_stream = WMI_MAX_SPATIAL_STREAM;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_TLV:
 		ar->max_num_peers = TARGET_TLV_NUM_PEERS;
@@ -1114,6 +1116,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->wow.max_num_patterns = TARGET_TLV_NUM_WOW_PATTERNS;
 		ar->fw_stats_req_mask = WMI_STAT_PDEV | WMI_STAT_VDEV |
 			WMI_STAT_PEER;
+		ar->max_spatial_stream = WMI_MAX_SPATIAL_STREAM;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_4:
 		ar->max_num_peers = TARGET_10_4_NUM_PEERS;
@@ -1123,6 +1126,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->num_tids = TARGET_10_4_TGT_NUM_TIDS;
 		ar->htt.max_num_pending_tx = TARGET_10_4_NUM_MSDU_DESC;
 		ar->fw_stats_req_mask = WMI_STAT_PEER;
+		ar->max_spatial_stream = WMI_10_4_MAX_SPATIAL_STREAM;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_UNSET:
 	case ATH10K_FW_WMI_OP_VERSION_MAX:
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 86c4015..f0811d0 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -546,6 +546,7 @@ struct ath10k {
 	u32 ht_cap_info;
 	u32 vht_cap_info;
 	u32 num_rf_chains;
+	u32 max_spatial_stream;
 	/* protected by conf_mutex */
 	bool ani_enabled;
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index fffdae1..a00e3ca 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3911,10 +3911,10 @@ void ath10k_wmi_event_service_ready(struct ath10k *ar, struct sk_buff *skb)
 	if (ar->fw_api == 1 && ar->fw_version_build > 636)
 		set_bit(ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX, ar->fw_features);
 
-	if (ar->num_rf_chains > WMI_MAX_SPATIAL_STREAM) {
+	if (ar->num_rf_chains > ar->max_spatial_stream) {
 		ath10k_warn(ar, "hardware advertises support for more spatial streams than it should (%d > %d)\n",
-			    ar->num_rf_chains, WMI_MAX_SPATIAL_STREAM);
-		ar->num_rf_chains = WMI_MAX_SPATIAL_STREAM;
+			    ar->num_rf_chains, ar->max_spatial_stream);
+		ar->num_rf_chains = ar->max_spatial_stream;
 	}
 
 	ar->supp_tx_chainmask = (1 << ar->num_rf_chains) - 1;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 6e806cb..0d4efc9 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1747,7 +1747,8 @@ enum wmi_channel_change_cause {
 /* Indicate reason for channel switch */
 #define WMI_CHANNEL_CHANGE_CAUSE_CSA (1 << 13)
 
-#define WMI_MAX_SPATIAL_STREAM   3
+#define WMI_MAX_SPATIAL_STREAM        3 /* default max ss */
+#define WMI_10_4_MAX_SPATIAL_STREAM   4
 
 /* HT Capabilities*/
 #define WMI_HT_CAP_ENABLED                0x0001   /* HT Enabled/ disabled */
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
