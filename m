Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15214 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab2HOXvd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2012 19:51:33 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [PATCH] ath6kl: rework scheduled scan
Date: Wed, 15 Aug 2012 16:51:24 -0700
Message-ID: <1345074684-4662-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120816_015137_732609_359F0DBF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch reflects changes in the firmware scheduled scan
implementation to behave better in cases with multiple concurrent vifs.
Major changes:

	- scheduled scan filters and state are now programmed per-vif.
	- decouple scheduled scan from host sleep.

To maintain graceful failure with old firmwares, a new firmware
capability bit is introduced: ATH6KL_FW_CAPABILITY_SCHED_SCAN_V2.
ath6kl simply won't advertise scheduled scan to cfg80211 if the
SCHED_SCAN_V2 is not supported.

Since firmwares from here on out won't support the previous implicit API
for scheduled scan (set WoW filters and host sleep), bump the firmware
API to protect old drivers.

Unfortunately, due to firmware RAM constraints ath6kl still cannot
expect a scan complete event at the end of a scheduled scan results
cycle, so the sched_scan_timer is retained.

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   45 ++++-----------------------
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    1 -
 drivers/net/wireless/ath/ath6kl/core.h     |    6 +++-
 drivers/net/wireless/ath/ath6kl/init.c     |    6 ++++
 drivers/net/wireless/ath/ath6kl/sdio.c     |   19 ------------
 drivers/net/wireless/ath/ath6kl/wmi.c      |   23 +++++++++++++-
 drivers/net/wireless/ath/ath6kl/wmi.h      |   10 ++++++
 7 files changed, 50 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 80fa423..bd003fe 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -147,15 +147,11 @@ static bool __ath6kl_cfg80211_sscan_stop(struct ath6kl_vif *vif)
 {
 	struct ath6kl *ar = vif->ar;
 
-	if (ar->state != ATH6KL_STATE_SCHED_SCAN)
+	if (!test_and_clear_bit(SCHED_SCANNING, &vif->flags))
 		return false;
 
 	del_timer_sync(&vif->sched_scan_timer);
-
-	ath6kl_wmi_set_host_sleep_mode_cmd(ar->wmi, vif->fw_vif_idx,
-					   ATH6KL_HOST_MODE_AWAKE);
-
-	ar->state = ATH6KL_STATE_ON;
+	ath6kl_wmi_enable_sched_scan_cmd(ar->wmi, vif->fw_vif_idx, false);
 
 	return true;
 }
@@ -2449,13 +2445,6 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 
 		break;
 
-	case ATH6KL_CFG_SUSPEND_SCHED_SCAN:
-		/*
-		 * Nothing needed for schedule scan, firmware is already in
-		 * wow mode and sleeping most of the time.
-		 */
-		break;
-
 	default:
 		break;
 	}
@@ -2503,9 +2492,6 @@ int ath6kl_cfg80211_resume(struct ath6kl *ar)
 		}
 		break;
 
-	case ATH6KL_STATE_SCHED_SCAN:
-		break;
-
 	default:
 		break;
 	}
@@ -3246,10 +3232,6 @@ static int ath6kl_cfg80211_sscan_start(struct wiphy *wiphy,
 	if (vif->sme_state != SME_DISCONNECTED)
 		return -EBUSY;
 
-	/* The FW currently can't support multi-vif WoW properly. */
-	if (ar->num_vif > 1)
-		return -EIO;
-
 	ath6kl_cfg80211_scan_complete_event(vif, true);
 
 	ret = ath6kl_set_probed_ssids(ar, vif, request->ssids,
@@ -3295,15 +3277,6 @@ static int ath6kl_cfg80211_sscan_start(struct wiphy *wiphy,
 				  interval, interval,
 				  vif->bg_scan_period, 0, 0, 0, 3, 0, 0, 0);
 
-	ret = ath6kl_wmi_set_wow_mode_cmd(ar->wmi, vif->fw_vif_idx,
-					  ATH6KL_WOW_MODE_ENABLE,
-					  WOW_FILTER_SSID,
-					  WOW_HOST_REQ_DELAY);
-	if (ret) {
-		ath6kl_warn("Failed to enable wow with ssid filter: %d\n", ret);
-		return ret;
-	}
-
 	/* this also clears IE in fw if it's not set */
 	ret = ath6kl_wmi_set_appie_cmd(ar->wmi, vif->fw_vif_idx,
 				       WMI_FRAME_PROBE_REQ,
@@ -3314,17 +3287,13 @@ static int ath6kl_cfg80211_sscan_start(struct wiphy *wiphy,
 		return ret;
 	}
 
-	ret = ath6kl_wmi_set_host_sleep_mode_cmd(ar->wmi, vif->fw_vif_idx,
-						 ATH6KL_HOST_MODE_ASLEEP);
-	if (ret) {
-		ath6kl_warn("Failed to enable host sleep mode for sched scan: %d\n",
-			    ret);
+	ret = ath6kl_wmi_enable_sched_scan_cmd(ar->wmi, vif->fw_vif_idx, true);
+	if (ret)
 		return ret;
-	}
 
-	ar->state = ATH6KL_STATE_SCHED_SCAN;
+	set_bit(SCHED_SCANNING, &vif->flags);
 
-	return ret;
+	return 0;
 }
 
 static int ath6kl_cfg80211_sscan_stop(struct wiphy *wiphy,
@@ -3794,7 +3763,7 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
 			    WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
 
-	if (test_bit(ATH6KL_FW_CAPABILITY_SCHED_SCAN, ar->fw_capabilities))
+	if (test_bit(ATH6KL_FW_CAPABILITY_SCHED_SCAN_V2, ar->fw_capabilities))
 		ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
 
 	if (test_bit(ATH6KL_FW_CAPABILITY_INACTIVITY_TIMEOUT,
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index 56b1ebe..3d6a0b5 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -22,7 +22,6 @@ enum ath6kl_cfg_suspend_mode {
 	ATH6KL_CFG_SUSPEND_DEEPSLEEP,
 	ATH6KL_CFG_SUSPEND_CUTPOWER,
 	ATH6KL_CFG_SUSPEND_WOW,
-	ATH6KL_CFG_SUSPEND_SCHED_SCAN,
 };
 
 struct wireless_dev *ath6kl_interface_add(struct ath6kl *ar, char *name,
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index eb86b31..3dbbd37 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -127,6 +127,9 @@ enum ath6kl_fw_capability {
 	/* supports WMI_SET_REGDOMAIN_CMDID command */
 	ATH6KL_FW_CAPABILITY_REGDOMAIN,
 
+	/* Firmware supports sched scan decoupled from host sleep */
+	ATH6KL_FW_CAPABILITY_SCHED_SCAN_V2,
+
 	/* this needs to be last */
 	ATH6KL_FW_CAPABILITY_MAX,
 };
@@ -145,6 +148,7 @@ enum ath6kl_hw_flags {
 
 #define ATH6KL_FW_API2_FILE "fw-2.bin"
 #define ATH6KL_FW_API3_FILE "fw-3.bin"
+#define ATH6KL_FW_API4_FILE "fw-4.bin"
 
 /* AR6003 1.0 definitions */
 #define AR6003_HW_1_0_VERSION                 0x300002ba
@@ -555,6 +559,7 @@ enum ath6kl_vif_state {
 	HOST_SLEEP_MODE_CMD_PROCESSED,
 	NETDEV_MCAST_ALL_ON,
 	NETDEV_MCAST_ALL_OFF,
+	SCHED_SCANNING,
 };
 
 struct ath6kl_vif {
@@ -639,7 +644,6 @@ enum ath6kl_state {
 	ATH6KL_STATE_DEEPSLEEP,
 	ATH6KL_STATE_CUTPOWER,
 	ATH6KL_STATE_WOW,
-	ATH6KL_STATE_SCHED_SCAN,
 };
 
 struct ath6kl {
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 8bd4299..eb3677b 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1108,6 +1108,12 @@ int ath6kl_init_fetch_firmwares(struct ath6kl *ar)
 	if (ret)
 		return ret;
 
+	ret = ath6kl_fetch_fw_apin(ar, ATH6KL_FW_API4_FILE);
+	if (ret == 0) {
+		ar->fw_api = 4;
+		goto out;
+	}
+
 	ret = ath6kl_fetch_fw_apin(ar, ATH6KL_FW_API3_FILE);
 	if (ret == 0) {
 		ar->fw_api = 3;
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 65e9983..cc17fe0 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -844,22 +844,6 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 	bool try_deepsleep = false;
 	int ret;
 
-	if (ar->state == ATH6KL_STATE_SCHED_SCAN) {
-		ath6kl_dbg(ATH6KL_DBG_SUSPEND, "sched scan is in progress\n");
-
-		ret = ath6kl_set_sdio_pm_caps(ar);
-		if (ret)
-			goto cut_pwr;
-
-		ret =  ath6kl_cfg80211_suspend(ar,
-					       ATH6KL_CFG_SUSPEND_SCHED_SCAN,
-					       NULL);
-		if (ret)
-			goto cut_pwr;
-
-		return 0;
-	}
-
 	if (ar->suspend_mode == WLAN_POWER_STATE_WOW ||
 	    (!ar->suspend_mode && wow)) {
 
@@ -942,9 +926,6 @@ static int ath6kl_sdio_resume(struct ath6kl *ar)
 	case ATH6KL_STATE_WOW:
 		break;
 
-	case ATH6KL_STATE_SCHED_SCAN:
-		break;
-
 	case ATH6KL_STATE_SUSPENDING:
 		break;
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index cf91348..ee445a1 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1116,7 +1116,7 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len,
 	 * the timer would not ever fire if the scan interval is short
 	 * enough.
 	 */
-	if (ar->state == ATH6KL_STATE_SCHED_SCAN &&
+	if (test_bit(SCHED_SCANNING, &vif->flags) &&
 	    !timer_pending(&vif->sched_scan_timer)) {
 		mod_timer(&vif->sched_scan_timer, jiffies +
 			  msecs_to_jiffies(ATH6KL_SCHED_SCAN_RESULT_DELAY));
@@ -2024,6 +2024,27 @@ int ath6kl_wmi_beginscan_cmd(struct wmi *wmi, u8 if_idx,
 	return ret;
 }
 
+int ath6kl_wmi_enable_sched_scan_cmd(struct wmi *wmi, u8 if_idx, bool enable)
+{
+	struct sk_buff *skb;
+	struct wmi_enable_sched_scan_cmd *sc;
+	int ret;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*sc));
+	if (!skb)
+		return -ENOMEM;
+
+	ath6kl_dbg(ATH6KL_DBG_WMI, "%s scheduled scan on vif %d\n",
+		   enable ? "enabling" : "disabling", if_idx);
+	sc = (struct wmi_enable_sched_scan_cmd *) skb->data;
+	sc->enable = enable ? 1 : 0;
+
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb,
+				  WMI_ENABLE_SCHED_SCAN_CMDID,
+				  NO_SYNC_WMIFLAG);
+	return ret;
+}
+
 int ath6kl_wmi_scanparams_cmd(struct wmi *wmi, u8 if_idx,
 			      u16 fg_start_sec,
 			      u16 fg_end_sec, u16 bg_sec,
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 1d510ba..95a97f5 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -638,6 +638,10 @@ enum wmi_cmd_id {
 	WMI_VOICE_DETECTION_ENABLE_CMDID,
 
 	WMI_SET_TXE_NOTIFY_CMDID,
+
+	WMI_SET_RECOVERY_TEST_PARAMETER_CMDID, /*0xf094*/
+
+	WMI_ENABLE_SCHED_SCAN_CMDID,
 };
 
 enum wmi_mgmt_frame_type {
@@ -951,6 +955,11 @@ struct wmi_scan_params_cmd {
 	__le32 max_dfsch_act_time;
 } __packed;
 
+/* WMI_ENABLE_SCHED_SCAN_CMDID */
+struct wmi_enable_sched_scan_cmd {
+	u8 enable;
+} __packed;
+
 /* WMI_SET_BSS_FILTER_CMDID */
 enum wmi_bss_filter {
 	/* no beacons forwarded */
@@ -2559,6 +2568,7 @@ int ath6kl_wmi_beginscan_cmd(struct wmi *wmi, u8 if_idx,
 			     u32 home_dwell_time, u32 force_scan_interval,
 			     s8 num_chan, u16 *ch_list, u32 no_cck,
 			     u32 *rates);
+int ath6kl_wmi_enable_sched_scan_cmd(struct wmi *wmi, u8 if_idx, bool enable);
 
 int ath6kl_wmi_scanparams_cmd(struct wmi *wmi, u8 if_idx, u16 fg_start_sec,
 			      u16 fg_end_sec, u16 bg_sec,
-- 
1.7.4.1

