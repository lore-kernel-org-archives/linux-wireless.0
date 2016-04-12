Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12994 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383AbcDLOm4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 10:42:56 -0400
From: <c_traja@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>,
	Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCH] ath10k: add dynamic tx mode switch config support for qca4019
Date: Tue, 12 Apr 2016 20:15:53 +0530
Message-ID: <1460472353-4317-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20160412_164301_071993_FCE5189C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qti.qualcomm.com>

push-pull mode needs certain amount the host driver involvement for
managing queues in the host memory and packet delivery to firmware.
qca4019 wifi firmware has an option to stay in push mode for less
number of active traffic flow and then switch to push-pull mode when
the active traffic flow goes beyond the certain limit.

The advantage of staying in push mode for less active traffic is, the
host cpu consumption is reduced. qca4019 firmware supports this
flexibility of the mode switch. It takes the host driver interest
(LOW_PERF/HIGH_PERF) via WMI_EXT_RESOURCE_CFG_CMDID,

 LOW_PERF  - fw would stay in push mode and switch to push-pull
               based on demand.
 HIGH_PERF - fw would stay in push-pull mode from the boot.

To make this configuration generic, new WMI services
WMI_SERVICE_TX_MODE_PUSH_ONLY, WMI_SERVICE_TX_MODE_PUSH_PULL,
WMI_SERVICE_TX_MODE_DYNAMIC are introduced to take dynamic tx mode
switch support availability in firmware.
Based on WMI_SERVICE_TX_MODE_DYNAMIC, LOW_PERF or HIGHT_PERF is
configured to the firmware.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |  3 +--
 drivers/net/wireless/ath/ath10k/mac.c  | 20 ++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.h  |  1 +
 drivers/net/wireless/ath/ath10k/wmi.h  | 15 +++++++++++++++
 4 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index b2c7fe3..1c4106b 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1787,8 +1787,7 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
 		if (ath10k_peer_stats_enabled(ar))
 			val = WMI_10_4_PEER_STATS;
 
-		status = ath10k_wmi_ext_resource_config(ar,
-							WMI_HOST_PLATFORM_HIGH_PERF, val);
+		status = ath10k_mac_ext_resource_config(ar, val);
 		if (status) {
 			ath10k_err(ar,
 				   "failed to send ext resource cfg command : %d\n",
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b0e613b..de6d1a8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -157,6 +157,26 @@ ath10k_mac_max_vht_nss(const u16 vht_mcs_mask[NL80211_VHT_NSS_MAX])
 	return 1;
 }
 
+int ath10k_mac_ext_resource_config(struct ath10k *ar, u32 val)
+{
+	enum wmi_host_platform_type platform_type;
+	int ret;
+
+	if (test_bit(WMI_SERVICE_TX_MODE_DYNAMIC, ar->wmi.svc_map))
+		platform_type = WMI_HOST_PLATFORM_LOW_PERF;
+	else
+		platform_type = WMI_HOST_PLATFORM_HIGH_PERF;
+
+	ret = ath10k_wmi_ext_resource_config(ar, platform_type, val);
+
+	if (ret && ret != -EOPNOTSUPP) {
+		ath10k_warn(ar, "failed to configure ext resource: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 /**********/
 /* Crypto */
 /**********/
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index 2c3327b..1bd29ec 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -81,6 +81,7 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 struct ieee80211_txq *ath10k_mac_txq_lookup(struct ath10k *ar,
 					    u16 peer_id,
 					    u8 tid);
+int ath10k_mac_ext_resource_config(struct ath10k *ar, u32 val);
 
 static inline struct ath10k_vif *ath10k_vif_to_arvif(struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index feebd19..a3f1534 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -180,6 +180,9 @@ enum wmi_service {
 	WMI_SERVICE_MESH_NON_11S,
 	WMI_SERVICE_PEER_STATS,
 	WMI_SERVICE_RESTRT_CHNL_SUPPORT,
+	WMI_SERVICE_TX_MODE_PUSH_ONLY,
+	WMI_SERVICE_TX_MODE_PUSH_PULL,
+	WMI_SERVICE_TX_MODE_DYNAMIC,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -302,6 +305,9 @@ enum wmi_10_4_service {
 	WMI_10_4_SERVICE_RESTRT_CHNL_SUPPORT,
 	WMI_10_4_SERVICE_PEER_STATS,
 	WMI_10_4_SERVICE_MESH_11S,
+	WMI_10_4_SERVICE_TX_MODE_PUSH_ONLY,
+	WMI_10_4_SERVICE_TX_MODE_PUSH_PULL,
+	WMI_10_4_SERVICE_TX_MODE_DYNAMIC,
 };
 
 static inline char *wmi_service_name(int service_id)
@@ -396,6 +402,9 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_MESH_NON_11S);
 	SVCSTR(WMI_SERVICE_PEER_STATS);
 	SVCSTR(WMI_SERVICE_RESTRT_CHNL_SUPPORT);
+	SVCSTR(WMI_SERVICE_TX_MODE_PUSH_ONLY);
+	SVCSTR(WMI_SERVICE_TX_MODE_PUSH_PULL);
+	SVCSTR(WMI_SERVICE_TX_MODE_DYNAMIC);
 	default:
 		return NULL;
 	}
@@ -643,6 +652,12 @@ static inline void wmi_10_4_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_PEER_STATS, len);
 	SVCMAP(WMI_10_4_SERVICE_MESH_11S,
 	       WMI_SERVICE_MESH_11S, len);
+	SVCMAP(WMI_10_4_SERVICE_TX_MODE_PUSH_ONLY,
+	       WMI_SERVICE_TX_MODE_PUSH_ONLY, len);
+	SVCMAP(WMI_10_4_SERVICE_TX_MODE_PUSH_PULL,
+	       WMI_SERVICE_TX_MODE_PUSH_PULL, len);
+	SVCMAP(WMI_10_4_SERVICE_TX_MODE_DYNAMIC,
+	       WMI_SERVICE_TX_MODE_DYNAMIC, len);
 }
 
 #undef SVCMAP
-- 
1.9.1

