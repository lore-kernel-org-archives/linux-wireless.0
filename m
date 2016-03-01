Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:36177 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbcCAMPW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 07:15:22 -0500
Received: by mail-lb0-f173.google.com with SMTP id x1so97773824lbj.3
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2016 04:15:21 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: change htt tx desc/qcache peer limit config
Date: Tue,  1 Mar 2016 13:16:11 +0100
Message-Id: <1456834571-9847-2-git-send-email-michal.kazior@tieto.com> (sfid-20160301_131531_036412_458F0777)
In-Reply-To: <1456834571-9847-1-git-send-email-michal.kazior@tieto.com>
References: <1456834571-9847-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The number of HTT Tx descriptors and qcache peer
limit aren't hw-specific. In fact they are
firmware specific and should not be placed in
hw_params.

The QCA4019 limits were submitted with the peer
flow control firmware only and to my understanding
there's no non-peer-flow-ctrl QCA4019 firmware.

However QCA99X0 is planned to run firmware
supporting the feature as well. Therefore this
patch enables QCA99X0 to use 2500 tx descriptors
whenever possible instead of just 1424.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 11 ++++++-----
 drivers/net/wireless/ath/ath10k/core.h |  2 --
 drivers/net/wireless/ath/ath10k/hw.h   |  4 ++++
 drivers/net/wireless/ath/ath10k/wmi.c  | 10 ++++++++--
 4 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 4d3176492ae7..d7d94bf7e0db 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -156,8 +156,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.channel_counters_freq_hz = 150000,
 		.max_probe_resp_desc_thres = 24,
 		.hw_4addr_pad = ATH10K_HW_4ADDR_PAD_BEFORE,
-		.num_msdu_desc = 1424,
-		.qcache_active_peers = 50,
 		.tx_chain_mask = 0xf,
 		.rx_chain_mask = 0xf,
 		.max_spatial_stream = 4,
@@ -217,8 +215,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.channel_counters_freq_hz = 125000,
 		.max_probe_resp_desc_thres = 24,
 		.hw_4addr_pad = ATH10K_HW_4ADDR_PAD_BEFORE,
-		.num_msdu_desc = 2500,
-		.qcache_active_peers = 35,
 		.tx_chain_mask = 0x3,
 		.rx_chain_mask = 0x3,
 		.max_spatial_stream = 2,
@@ -1533,9 +1529,14 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->num_active_peers = TARGET_10_4_ACTIVE_PEERS;
 		ar->max_num_vdevs = TARGET_10_4_NUM_VDEVS;
 		ar->num_tids = TARGET_10_4_TGT_NUM_TIDS;
-		ar->htt.max_num_pending_tx = ar->hw_params.num_msdu_desc;
 		ar->fw_stats_req_mask = WMI_STAT_PEER;
 		ar->max_spatial_stream = ar->hw_params.max_spatial_stream;
+
+		if (test_bit(ATH10K_FW_FEATURE_PEER_FLOW_CONTROL,
+			     ar->fw_features))
+			ar->htt.max_num_pending_tx = TARGET_10_4_NUM_MSDU_DESC_PFC;
+		else
+			ar->htt.max_num_pending_tx = TARGET_10_4_NUM_MSDU_DESC;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_UNSET:
 	case ATH10K_FW_WMI_OP_VERSION_MAX:
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index a62b62a62266..1f116edbdf28 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -680,8 +680,6 @@ struct ath10k {
 		/* The padding bytes's location is different on various chips */
 		enum ath10k_hw_4addr_pad hw_4addr_pad;
 
-		u32 num_msdu_desc;
-		u32 qcache_active_peers;
 		u32 tx_chain_mask;
 		u32 rx_chain_mask;
 		u32 max_spatial_stream;
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 2dece8db83f8..d5939a99dc45 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -426,10 +426,14 @@ enum ath10k_hw_4addr_pad {
 #define TARGET_10_4_ACTIVE_PEERS		0
 
 #define TARGET_10_4_NUM_QCACHE_PEERS_MAX	512
+#define TARGET_10_4_QCACHE_ACTIVE_PEERS		50
+#define TARGET_10_4_QCACHE_ACTIVE_PEERS_PFC	35
 #define TARGET_10_4_NUM_OFFLOAD_PEERS		0
 #define TARGET_10_4_NUM_OFFLOAD_REORDER_BUFFS	0
 #define TARGET_10_4_NUM_PEER_KEYS		2
 #define TARGET_10_4_TGT_NUM_TIDS		((TARGET_10_4_NUM_PEERS) * 2)
+#define TARGET_10_4_NUM_MSDU_DESC		(1024 + 400)
+#define TARGET_10_4_NUM_MSDU_DESC_PFC		2500
 #define TARGET_10_4_AST_SKID_LIMIT		32
 
 /* 100 ms for video, best-effort, and background */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 1ce67423224a..fee27b2ca6c0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4617,10 +4617,16 @@ static void ath10k_wmi_event_service_ready_work(struct work_struct *work)
 	}
 
 	if (test_bit(WMI_SERVICE_PEER_CACHING, ar->wmi.svc_map)) {
+		if (test_bit(ATH10K_FW_FEATURE_PEER_FLOW_CONTROL,
+			     ar->fw_features))
+			ar->num_active_peers = TARGET_10_4_QCACHE_ACTIVE_PEERS_PFC +
+					       ar->max_num_vdevs;
+		else
+			ar->num_active_peers = TARGET_10_4_QCACHE_ACTIVE_PEERS +
+					       ar->max_num_vdevs;
+
 		ar->max_num_peers = TARGET_10_4_NUM_QCACHE_PEERS_MAX +
 				    ar->max_num_vdevs;
-		ar->num_active_peers = ar->hw_params.qcache_active_peers +
-				       ar->max_num_vdevs;
 		ar->num_tids = ar->num_active_peers * 2;
 		ar->max_num_stations = TARGET_10_4_NUM_QCACHE_PEERS_MAX;
 	}
-- 
2.1.4

