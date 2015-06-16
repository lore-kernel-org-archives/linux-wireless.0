Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22047 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbbFPFsV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 01:48:21 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 09/10] ath10k: adjust default peer limits if qcache enabled in 10.4 fw
Date: Tue, 16 Jun 2015 11:15:22 +0530
Message-ID: <1434433523-8357-10-git-send-email-rmani@qti.qualcomm.com> (sfid-20150616_074824_538036_A1F96042)
In-Reply-To: <1434433523-8357-1-git-send-email-rmani@qti.qualcomm.com>
References: <1434433523-8357-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

10.4 firmware supports upto 512 clients when qcache feature is enabled.
Make adjustment on default max peer count, active peers, number of tid in
such case to meet qcache requirement. 10.4 fw has extra unit info flag
NUM_UNITS_IS_NUM_ACTIVE_PEERS which is also handled in this patch.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/hw.h  |  6 ++++++
 drivers/net/wireless/ath/ath10k/wmi.c | 27 +++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/wmi.h |  5 +++--
 3 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index d76b52a..799ab8a 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -361,6 +361,12 @@ enum ath10k_hw_rate_cck {
 #define TARGET_10_4_NUM_PEERS			((TARGET_10_4_NUM_STATIONS) + \
 						 (TARGET_10_4_NUM_VDEVS))
 #define TARGET_10_4_ACTIVE_PEERS		0
+
+/* TODO: increase qcache max client limit to 512 after
+ * testing with 512 client.
+ */
+#define TARGET_10_4_NUM_QCACHE_PEERS_MAX	256
+#define TARGET_10_4_QCACHE_ACTIVE_PEERS		50
 #define TARGET_10_4_NUM_OFFLOAD_PEERS		0
 #define TARGET_10_4_NUM_OFFLOAD_REORDER_BUFFS	0
 #define TARGET_10_4_NUM_PEER_KEYS		2
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 07231c2..e5d948e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3740,20 +3740,39 @@ void ath10k_wmi_event_service_ready(struct ath10k *ar, struct sk_buff *skb)
 		return;
 	}
 
+	if (test_bit(WMI_SERVICE_PEER_CACHING, ar->wmi.svc_map)) {
+		ar->max_num_peers = TARGET_10_4_NUM_QCACHE_PEERS_MAX +
+				    TARGET_10_4_NUM_VDEVS;
+		ar->num_active_peers = TARGET_10_4_QCACHE_ACTIVE_PEERS +
+				       TARGET_10_4_NUM_VDEVS;
+		ar->num_tids = ar->num_active_peers * 2;
+		ar->max_num_stations = TARGET_10_4_NUM_QCACHE_PEERS_MAX;
+	}
+
+	/* TODO: Adjust max peer count for cases like WMI_SERVICE_RATECTRL_CACHE
+	 * and WMI_SERVICE_IRAM_TIDS, etc.
+	 */
+
 	for (i = 0; i < num_mem_reqs; ++i) {
 		req_id = __le32_to_cpu(arg.mem_reqs[i]->req_id);
 		num_units = __le32_to_cpu(arg.mem_reqs[i]->num_units);
 		unit_size = __le32_to_cpu(arg.mem_reqs[i]->unit_size);
 		num_unit_info = __le32_to_cpu(arg.mem_reqs[i]->num_unit_info);
 
-		if (num_unit_info & NUM_UNITS_IS_NUM_PEERS)
+		if (num_unit_info & NUM_UNITS_IS_NUM_ACTIVE_PEERS) {
+			if (ar->num_active_peers)
+				num_units = ar->num_active_peers + 1;
+			else
+				num_units = ar->max_num_peers + 1;
+		} else if (num_unit_info & NUM_UNITS_IS_NUM_PEERS) {
 			/* number of units to allocate is number of
 			 * peers, 1 extra for self peer on target */
 			/* this needs to be tied, host and target
 			 * can get out of sync */
-			num_units = TARGET_10X_NUM_PEERS + 1;
-		else if (num_unit_info & NUM_UNITS_IS_NUM_VDEVS)
-			num_units = TARGET_10X_NUM_VDEVS + 1;
+			num_units = ar->max_num_peers + 1;
+		} else if (num_unit_info & NUM_UNITS_IS_NUM_VDEVS) {
+			num_units = ar->max_num_vdevs + 1;
+		}
 
 		ath10k_dbg(ar, ATH10K_DBG_WMI,
 			   "wmi mem_req_id %d num_units %d num_unit_info %d unit size %d actual units %d\n",
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 5e67c27..1371c8a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2332,8 +2332,9 @@ struct wmi_resource_config_10_2 {
 	__le32 feature_mask;
 } __packed;
 
-#define NUM_UNITS_IS_NUM_VDEVS   0x1
-#define NUM_UNITS_IS_NUM_PEERS   0x2
+#define NUM_UNITS_IS_NUM_VDEVS         BIT(0)
+#define NUM_UNITS_IS_NUM_PEERS         BIT(1)
+#define NUM_UNITS_IS_NUM_ACTIVE_PEERS  BIT(2)
 
 struct wmi_resource_config_10_4 {
 	/* Number of virtual devices (VAPs) to support */
-- 
1.8.1.2

