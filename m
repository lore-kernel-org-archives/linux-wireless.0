Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41510 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbbC0RTe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2015 13:19:34 -0400
From: Yanbo Li <yanbol@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <dreamfly281@gmail.com>, <michal.kazior@tieto.com>,
	<ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath10k: Change the fw stats access mask
Date: Fri, 27 Mar 2015 10:18:00 -0700
Message-ID: <1427476680-5532-1-git-send-email-yanbol@qca.qualcomm.com> (sfid-20150327_181937_452963_44EC04EF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fix the regerssion introduced after "ath10k_wmi_requests_stats()
call to use more stat bits", both the 10.2.X FW and community FW 10.1.X
will return time out when access the fw_stats with the STAT_VDEV and
STAT_PDEV. Add the condition to use different fw_stats mask for different
FW versions.

Fixes:7777d8c7ef6f("ath10k: implement fw stats for wmi-tlv")
Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c0e454bb6a8d..e1db4d018e90 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -958,6 +958,8 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->max_num_stations = TARGET_NUM_STATIONS;
 		ar->max_num_vdevs = TARGET_NUM_VDEVS;
 		ar->htt.max_num_pending_tx = TARGET_NUM_MSDU_DESC;
+		ar->fw_stats_req_mask = WMI_STAT_PDEV | WMI_STAT_VDEV |
+			WMI_STAT_PEER;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_1:
 	case ATH10K_FW_WMI_OP_VERSION_10_2:
@@ -966,12 +968,15 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->max_num_stations = TARGET_10X_NUM_STATIONS;
 		ar->max_num_vdevs = TARGET_10X_NUM_VDEVS;
 		ar->htt.max_num_pending_tx = TARGET_10X_NUM_MSDU_DESC;
+		ar->fw_stats_req_mask = WMI_STAT_PEER;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_TLV:
 		ar->max_num_peers = TARGET_TLV_NUM_PEERS;
 		ar->max_num_stations = TARGET_TLV_NUM_STATIONS;
 		ar->max_num_vdevs = TARGET_TLV_NUM_VDEVS;
 		ar->htt.max_num_pending_tx = TARGET_TLV_NUM_MSDU_DESC;
+		ar->fw_stats_req_mask = WMI_STAT_PDEV | WMI_STAT_VDEV |
+			WMI_STAT_PEER;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_UNSET:
 	case ATH10K_FW_WMI_OP_VERSION_MAX:
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index cfd37a6e8931..1545a37c6360 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -514,6 +514,7 @@ struct ath10k {
 	u32 fw_version_minor;
 	u16 fw_version_release;
 	u16 fw_version_build;
+	u32 fw_stats_req_mask;
 	u32 phy_capability;
 	u32 hw_min_tx_power;
 	u32 hw_max_tx_power;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 51cf536fd014..544c22e0a1d8 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -395,10 +395,7 @@ static int ath10k_debug_fw_stats_request(struct ath10k *ar)
 
 		reinit_completion(&ar->debug.fw_stats_complete);
 
-		ret = ath10k_wmi_request_stats(ar,
-					       WMI_STAT_PDEV |
-					       WMI_STAT_VDEV |
-					       WMI_STAT_PEER);
+		ret = ath10k_wmi_request_stats(ar, ar->fw_stats_req_mask);
 		if (ret) {
 			ath10k_warn(ar, "could not request stats (%d)\n", ret);
 			return ret;
-- 
1.9.1

