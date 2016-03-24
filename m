Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21219 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbcCXOXg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2016 10:23:36 -0400
Subject: [PATCH 1/4] ath10k: fix checkpatch warnings related to spaces
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Thu, 24 Mar 2016 16:23:22 +0200
Message-ID: <20160324142322.15808.34823.stgit@potku.adurom.net> (sfid-20160324_152340_104006_73049452)
In-Reply-To: <20160324142217.15808.22638.stgit@potku.adurom.net>
References: <20160324142217.15808.22638.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix checkpatch warnings about use of spaces with operators:

spaces preferred around that '*' (ctx:VxV)

This has been recently added to checkpatch.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ce.c        |    6 +++---
 drivers/net/wireless/ath/ath10k/ce.h        |    2 +-
 drivers/net/wireless/ath/ath10k/core.h      |    6 +++---
 drivers/net/wireless/ath/ath10k/debug.h     |    2 +-
 drivers/net/wireless/ath/ath10k/htc.h       |    4 ++--
 drivers/net/wireless/ath/ath10k/htt.c       |    2 +-
 drivers/net/wireless/ath/ath10k/mac.c       |    8 ++++----
 drivers/net/wireless/ath/ath10k/targaddrs.h |    2 +-
 drivers/net/wireless/ath/ath10k/thermal.h   |    2 +-
 drivers/net/wireless/ath/ath10k/txrx.c      |    2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h   |    4 ++--
 drivers/net/wireless/ath/ath10k/wmi.c       |    2 +-
 drivers/net/wireless/ath/ath10k/wmi.h       |   18 +++++++++---------
 13 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index edf3629288bc..52ac97bf8a4d 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1048,11 +1048,11 @@ int ath10k_ce_alloc_pipe(struct ath10k *ar, int ce_id,
 	 *
 	 * For the lack of a better place do the check here.
 	 */
-	BUILD_BUG_ON(2*TARGET_NUM_MSDU_DESC >
+	BUILD_BUG_ON(2 * TARGET_NUM_MSDU_DESC >
 		     (CE_HTT_H2T_MSG_SRC_NENTRIES - 1));
-	BUILD_BUG_ON(2*TARGET_10X_NUM_MSDU_DESC >
+	BUILD_BUG_ON(2 * TARGET_10X_NUM_MSDU_DESC >
 		     (CE_HTT_H2T_MSG_SRC_NENTRIES - 1));
-	BUILD_BUG_ON(2*TARGET_TLV_NUM_MSDU_DESC >
+	BUILD_BUG_ON(2 * TARGET_TLV_NUM_MSDU_DESC >
 		     (CE_HTT_H2T_MSG_SRC_NENTRIES - 1));
 
 	ce_state->ar = ar;
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index dac676817532..a3b9473ff667 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -413,7 +413,7 @@ static inline u32 ath10k_ce_base_address(struct ath10k *ar, unsigned int ce_id)
 
 /* Ring arithmetic (modulus number of entries in ring, which is a pwr of 2). */
 #define CE_RING_DELTA(nentries_mask, fromidx, toidx) \
-	(((int)(toidx)-(int)(fromidx)) & (nentries_mask))
+	(((int)(toidx) - (int)(fromidx)) & (nentries_mask))
 
 #define CE_RING_IDX_INCR(nentries_mask, idx) (((idx) + 1) & (nentries_mask))
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index b6c157ef705a..908ab1834f26 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -44,8 +44,8 @@
 
 #define ATH10K_SCAN_ID 0
 #define WMI_READY_TIMEOUT (5 * HZ)
-#define ATH10K_FLUSH_TIMEOUT_HZ (5*HZ)
-#define ATH10K_CONNECTION_LOSS_HZ (3*HZ)
+#define ATH10K_FLUSH_TIMEOUT_HZ (5 * HZ)
+#define ATH10K_CONNECTION_LOSS_HZ (3 * HZ)
 #define ATH10K_NUM_CHANS 39
 
 /* Antenna noise floor */
@@ -334,7 +334,7 @@ struct ath10k_sta {
 #endif
 };
 
-#define ATH10K_VDEV_SETUP_TIMEOUT_HZ (5*HZ)
+#define ATH10K_VDEV_SETUP_TIMEOUT_HZ (5 * HZ)
 
 enum ath10k_beacon_state {
 	ATH10K_BEACON_SCHEDULED = 0,
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 6206edd7c49f..75c89e3625ef 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -57,7 +57,7 @@ enum ath10k_dbg_aggr_mode {
 };
 
 /* FIXME: How to calculate the buffer size sanely? */
-#define ATH10K_FW_STATS_BUF_SIZE (1024*1024)
+#define ATH10K_FW_STATS_BUF_SIZE (1024 * 1024)
 
 extern unsigned int ath10k_debug_mask;
 
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index e70aa38e6e05..cc827185d3e9 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -297,10 +297,10 @@ struct ath10k_htc_svc_conn_resp {
 #define ATH10K_NUM_CONTROL_TX_BUFFERS 2
 #define ATH10K_HTC_MAX_LEN 4096
 #define ATH10K_HTC_MAX_CTRL_MSG_LEN 256
-#define ATH10K_HTC_WAIT_TIMEOUT_HZ (1*HZ)
+#define ATH10K_HTC_WAIT_TIMEOUT_HZ (1 * HZ)
 #define ATH10K_HTC_CONTROL_BUFFER_SIZE (ATH10K_HTC_MAX_CTRL_MSG_LEN + \
 					sizeof(struct ath10k_htc_hdr))
-#define ATH10K_HTC_CONN_SVC_TIMEOUT_HZ (1*HZ)
+#define ATH10K_HTC_CONN_SVC_TIMEOUT_HZ (1 * HZ)
 
 struct ath10k_htc_ep {
 	struct ath10k_htc *htc;
diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index 7561f22f10f9..42a4c18a3806 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -208,7 +208,7 @@ int ath10k_htt_init(struct ath10k *ar)
 	return 0;
 }
 
-#define HTT_TARGET_VERSION_TIMEOUT_HZ (3*HZ)
+#define HTT_TARGET_VERSION_TIMEOUT_HZ (3 * HZ)
 
 static int ath10k_htt_verify_version(struct ath10k_htt *htt)
 {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ed00853ea9cc..74a0e25183d0 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3846,7 +3846,7 @@ static int ath10k_scan_stop(struct ath10k *ar)
 		goto out;
 	}
 
-	ret = wait_for_completion_timeout(&ar->scan.completed, 3*HZ);
+	ret = wait_for_completion_timeout(&ar->scan.completed, 3 * HZ);
 	if (ret == 0) {
 		ath10k_warn(ar, "failed to receive scan abortion completion: timed out\n");
 		ret = -ETIMEDOUT;
@@ -3926,7 +3926,7 @@ static int ath10k_start_scan(struct ath10k *ar,
 	if (ret)
 		return ret;
 
-	ret = wait_for_completion_timeout(&ar->scan.started, 1*HZ);
+	ret = wait_for_completion_timeout(&ar->scan.started, 1 * HZ);
 	if (ret == 0) {
 		ret = ath10k_scan_stop(ar);
 		if (ret)
@@ -6168,7 +6168,7 @@ exit:
 	return ret;
 }
 
-#define ATH10K_ROC_TIMEOUT_HZ (2*HZ)
+#define ATH10K_ROC_TIMEOUT_HZ (2 * HZ)
 
 static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
@@ -6232,7 +6232,7 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 		goto exit;
 	}
 
-	ret = wait_for_completion_timeout(&ar->scan.on_channel, 3*HZ);
+	ret = wait_for_completion_timeout(&ar->scan.on_channel, 3 * HZ);
 	if (ret == 0) {
 		ath10k_warn(ar, "failed to switch to channel for roc scan\n");
 
diff --git a/drivers/net/wireless/ath/ath10k/targaddrs.h b/drivers/net/wireless/ath/ath10k/targaddrs.h
index 361f143b019c..8e24099fa936 100644
--- a/drivers/net/wireless/ath/ath10k/targaddrs.h
+++ b/drivers/net/wireless/ath/ath10k/targaddrs.h
@@ -438,7 +438,7 @@ Fw Mode/SubMode Mask
 	((HOST_INTEREST->hi_pwr_save_flags & HI_PWR_SAVE_LPL_ENABLED))
 #define HI_DEV_LPL_TYPE_GET(_devix) \
 	(HOST_INTEREST->hi_pwr_save_flags & ((HI_PWR_SAVE_LPL_DEV_MASK) << \
-	 (HI_PWR_SAVE_LPL_DEV0_LSB + (_devix)*2)))
+	 (HI_PWR_SAVE_LPL_DEV0_LSB + (_devix) * 2)))
 
 #define HOST_INTEREST_SMPS_IS_ALLOWED() \
 	((HOST_INTEREST->hi_smps_options & HI_SMPS_ALLOW_MASK))
diff --git a/drivers/net/wireless/ath/ath10k/thermal.h b/drivers/net/wireless/ath/ath10k/thermal.h
index c9223e9e962f..3abb97f63b1e 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.h
+++ b/drivers/net/wireless/ath/ath10k/thermal.h
@@ -20,7 +20,7 @@
 #define ATH10K_QUIET_PERIOD_MIN         25
 #define ATH10K_QUIET_START_OFFSET       10
 #define ATH10K_HWMON_NAME_LEN           15
-#define ATH10K_THERMAL_SYNC_TIMEOUT_HZ (5*HZ)
+#define ATH10K_THERMAL_SYNC_TIMEOUT_HZ (5 * HZ)
 #define ATH10K_THERMAL_THROTTLE_MAX     100
 
 struct ath10k_thermal {
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 48e26cdfe9a5..31335c510f1e 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -166,7 +166,7 @@ static int ath10k_wait_for_peer_common(struct ath10k *ar, int vdev_id,
 
 			(mapped == expect_mapped ||
 			 test_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags));
-		}), 3*HZ);
+		}), 3 * HZ);
 
 	if (time_left == 0)
 		return -ETIMEDOUT;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index dd678590531a..b8aa6000573c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -968,8 +968,8 @@ enum wmi_tlv_service {
 
 #define WMI_SERVICE_IS_ENABLED(wmi_svc_bmap, svc_id, len) \
 	((svc_id) < (len) && \
-	 __le32_to_cpu((wmi_svc_bmap)[(svc_id)/(sizeof(u32))]) & \
-	 BIT((svc_id)%(sizeof(u32))))
+	 __le32_to_cpu((wmi_svc_bmap)[(svc_id) / (sizeof(u32))]) & \
+	 BIT((svc_id) % (sizeof(u32))))
 
 #define SVCMAP(x, y, len) \
 	do { \
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 91375664dc35..ffb300823376 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1803,7 +1803,7 @@ int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id)
 			ret = -ESHUTDOWN;
 
 		(ret != -EAGAIN);
-	}), 3*HZ);
+	}), 3 * HZ);
 
 	if (ret)
 		dev_kfree_skb_any(skb);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index bb42f7a6ba23..ff861045394f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -405,8 +405,8 @@ static inline char *wmi_service_name(int service_id)
 
 #define WMI_SERVICE_IS_ENABLED(wmi_svc_bmap, svc_id, len) \
 	((svc_id) < (len) && \
-	 __le32_to_cpu((wmi_svc_bmap)[(svc_id)/(sizeof(u32))]) & \
-	 BIT((svc_id)%(sizeof(u32))))
+	 __le32_to_cpu((wmi_svc_bmap)[(svc_id) / (sizeof(u32))]) & \
+	 BIT((svc_id) % (sizeof(u32))))
 
 #define SVCMAP(x, y, len) \
 	do { \
@@ -1308,7 +1308,7 @@ enum wmi_10x_event_id {
 	WMI_10X_PDEV_TPC_CONFIG_EVENTID,
 
 	WMI_10X_GPIO_INPUT_EVENTID,
-	WMI_10X_PDEV_UTF_EVENTID = WMI_10X_END_EVENTID-1,
+	WMI_10X_PDEV_UTF_EVENTID = WMI_10X_END_EVENTID - 1,
 };
 
 enum wmi_10_2_cmd_id {
@@ -2041,8 +2041,8 @@ struct wmi_10x_service_ready_event {
 	struct wlan_host_mem_req mem_reqs[0];
 } __packed;
 
-#define WMI_SERVICE_READY_TIMEOUT_HZ (5*HZ)
-#define WMI_UNIFIED_READY_TIMEOUT_HZ (5*HZ)
+#define WMI_SERVICE_READY_TIMEOUT_HZ (5 * HZ)
+#define WMI_UNIFIED_READY_TIMEOUT_HZ (5 * HZ)
 
 struct wmi_ready_event {
 	__le32 sw_version;
@@ -4342,14 +4342,14 @@ enum wmi_vdev_subtype_10_4 {
 /*
  * Indicates that AP VDEV uses hidden ssid. only valid for
  *  AP/GO */
-#define WMI_VDEV_START_HIDDEN_SSID  (1<<0)
+#define WMI_VDEV_START_HIDDEN_SSID  (1 << 0)
 /*
  * Indicates if robust management frame/management frame
  *  protection is enabled. For GO/AP vdevs, it indicates that
  *  it may support station/client associations with RMF enabled.
  *  For STA/client vdevs, it indicates that sta will
  *  associate with AP with RMF enabled. */
-#define WMI_VDEV_START_PMF_ENABLED  (1<<1)
+#define WMI_VDEV_START_PMF_ENABLED  (1 << 1)
 
 struct wmi_p2p_noa_descriptor {
 	__le32 type_count; /* 255: continuous schedule, 0: reserved */
@@ -5287,7 +5287,7 @@ enum wmi_sta_ps_param_pspoll_count {
 #define WMI_UAPSD_AC_TYPE_TRIG 1
 
 #define WMI_UAPSD_AC_BIT_MASK(ac, type) \
-	((type ==  WMI_UAPSD_AC_TYPE_DELI) ? (1<<(ac<<1)) : (1<<((ac<<1)+1)))
+	((type ==  WMI_UAPSD_AC_TYPE_DELI) ? (1 << (ac << 1)) : (1 << ((ac << 1) + 1)))
 
 enum wmi_sta_ps_param_uapsd {
 	WMI_STA_PS_UAPSD_AC0_DELIVERY_EN = (1 << 0),
@@ -5702,7 +5702,7 @@ struct wmi_rate_set {
 	 * the rates are filled from least significant byte to most
 	 * significant byte.
 	 */
-	__le32 rates[(MAX_SUPPORTED_RATES/4)+1];
+	__le32 rates[(MAX_SUPPORTED_RATES / 4) + 1];
 } __packed;
 
 struct wmi_rate_set_arg {

