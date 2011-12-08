Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:59880 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab1LHPaC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 10:30:02 -0500
Subject: [PATCH 6/6] ath6kl: implement scheduled scan
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Thu, 08 Dec 2011 17:29:47 +0200
Message-ID: <20111208152947.16924.44640.stgit@x201> (sfid-20111208_163009_699869_115A7BF3)
In-Reply-To: <20111208152824.16924.31984.stgit@x201>
References: <20111208152824.16924.31984.stgit@x201>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  144 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    3 -
 drivers/net/wireless/ath/ath6kl/core.h     |    7 +
 drivers/net/wireless/ath/ath6kl/init.c     |    5 +
 drivers/net/wireless/ath/ath6kl/sdio.c     |   26 +++++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   27 +++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |    2 
 7 files changed, 211 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 2bab65f..484da6e 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -125,6 +125,37 @@ static struct ieee80211_supported_band ath6kl_band_5ghz = {
 
 #define CCKM_KRK_CIPHER_SUITE 0x004096ff /* use for KRK */
 
+/* returns true if scheduled scan was stopped */
+static bool __ath6kl_cfg80211_sscan_stop(struct ath6kl_vif *vif)
+{
+	struct ath6kl *ar = vif->ar;
+
+	if (ar->state != ATH6KL_STATE_SCHED_SCAN)
+		return false;
+
+	del_timer_sync(&vif->sched_scan_timer);
+
+	ath6kl_wmi_set_host_sleep_mode_cmd(ar->wmi, vif->fw_vif_idx,
+					   ATH6KL_HOST_MODE_AWAKE);
+
+	ar->state = ATH6KL_STATE_ON;
+
+	return true;
+}
+
+static void ath6kl_cfg80211_sscan_disable(struct ath6kl_vif *vif)
+{
+	struct ath6kl *ar = vif->ar;
+	bool stopped;
+
+	stopped = __ath6kl_cfg80211_sscan_stop(vif);
+
+	if (!stopped)
+		return;
+
+	cfg80211_sched_scan_stopped(ar->wiphy);
+}
+
 static int ath6kl_set_wpa_version(struct ath6kl_vif *vif,
 				  enum nl80211_wpa_versions wpa_version)
 {
@@ -385,6 +416,8 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	struct ath6kl_vif *vif = netdev_priv(dev);
 	int status;
 
+	ath6kl_cfg80211_sscan_disable(vif);
+
 	vif->sme_state = SME_CONNECTING;
 
 	if (!ath6kl_cfg80211_ready(vif))
@@ -712,6 +745,8 @@ static int ath6kl_cfg80211_disconnect(struct wiphy *wiphy,
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: reason=%u\n", __func__,
 		   reason_code);
 
+	ath6kl_cfg80211_sscan_disable(vif);
+
 	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
@@ -814,6 +849,8 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
+	ath6kl_cfg80211_sscan_disable(vif);
+
 	if (!ar->usr_bss_filter) {
 		clear_bit(CLEAR_BSSFILTER_ON_BEACON, &vif->flags);
 		ret = ath6kl_wmi_bssfilter_cmd(
@@ -839,6 +876,10 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 						  request->ssids[i].ssid);
 	}
 
+	/*
+	 * FIXME: we should clear the IE in fw if it's not set so just
+	 * remove the check altogether
+	 */
 	if (request->ie) {
 		ret = ath6kl_wmi_set_appie_cmd(ar->wmi, vif->fw_vif_idx,
 					       WMI_FRAME_PROBE_REQ,
@@ -1836,6 +1877,13 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 
 		break;
 
+	case ATH6KL_CFG_SUSPEND_SCHED_SCAN:
+		/*
+		 * Nothing needed for schedule scan, firmware is already in
+		 * wow mode and sleeping most of the time.
+		 */
+		break;
+
 	default:
 		break;
 	}
@@ -1884,6 +1932,9 @@ int ath6kl_cfg80211_resume(struct ath6kl *ar)
 		}
 		break;
 
+	case ATH6KL_STATE_SCHED_SCAN:
+		break;
+
 	default:
 		break;
 	}
@@ -2330,6 +2381,90 @@ static void ath6kl_mgmt_frame_register(struct wiphy *wiphy,
 	}
 }
 
+static int ath6kl_cfg80211_sscan_start(struct wiphy *wiphy,
+			struct net_device *dev,
+			struct cfg80211_sched_scan_request *request)
+{
+	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
+	u16 interval;
+	int ret;
+	u8 i;
+
+	if (ar->state != ATH6KL_STATE_ON)
+		return -EIO;
+
+	if (vif->sme_state != SME_DISCONNECTED)
+		return -EBUSY;
+
+	for (i = 0; i < ar->wiphy->max_sched_scan_ssids; i++) {
+		ath6kl_wmi_probedssid_cmd(ar->wmi, vif->fw_vif_idx,
+					  i, DISABLE_SSID_FLAG,
+					  0, NULL);
+	}
+
+	/* fw uses seconds, also make sure that it's >0 */
+	interval = max_t(u16, 1, request->interval / 1000);
+
+	ath6kl_wmi_scanparams_cmd(ar->wmi, vif->fw_vif_idx,
+				  interval, interval,
+				  10, 0, 0, 0, 3, 0, 0, 0);
+
+	if (request->n_ssids && request->ssids[0].ssid_len) {
+		for (i = 0; i < request->n_ssids; i++) {
+			ath6kl_wmi_probedssid_cmd(ar->wmi, vif->fw_vif_idx,
+						  i, SPECIFIC_SSID_FLAG,
+						  request->ssids[i].ssid_len,
+						  request->ssids[i].ssid);
+		}
+	}
+
+	ret = ath6kl_wmi_set_wow_mode_cmd(ar->wmi, vif->fw_vif_idx,
+					  ATH6KL_WOW_MODE_ENABLE,
+					  WOW_FILTER_SSID,
+					  WOW_HOST_REQ_DELAY);
+	if (ret) {
+		ath6kl_warn("Failed to enable wow with ssid filter: %d\n", ret);
+		return ret;
+	}
+
+	/* this also clears IE in fw if it's not set */
+	ret = ath6kl_wmi_set_appie_cmd(ar->wmi, vif->fw_vif_idx,
+				       WMI_FRAME_PROBE_REQ,
+				       request->ie, request->ie_len);
+	if (ret) {
+		ath6kl_warn("Failed to set probe request IE for scheduled scan: %d",
+			    ret);
+		return ret;
+	}
+
+	ret = ath6kl_wmi_set_host_sleep_mode_cmd(ar->wmi, vif->fw_vif_idx,
+						 ATH6KL_HOST_MODE_ASLEEP);
+	if (ret) {
+		ath6kl_warn("Failed to enable host sleep mode for sched scan: %d\n",
+			    ret);
+		return ret;
+	}
+
+	ar->state = ATH6KL_STATE_SCHED_SCAN;
+
+	return ret;
+}
+
+static int ath6kl_cfg80211_sscan_stop(struct wiphy *wiphy,
+				      struct net_device *dev)
+{
+	struct ath6kl_vif *vif = netdev_priv(dev);
+	bool stopped;
+
+	stopped = __ath6kl_cfg80211_sscan_stop(vif);
+
+	if (!stopped)
+		return -EIO;
+
+	return 0;
+}
+
 static const struct ieee80211_txrx_stypes
 ath6kl_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 	[NL80211_IFTYPE_STATION] = {
@@ -2387,10 +2522,14 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.cancel_remain_on_channel = ath6kl_cancel_remain_on_channel,
 	.mgmt_tx = ath6kl_mgmt_tx,
 	.mgmt_frame_register = ath6kl_mgmt_frame_register,
+	.sched_scan_start = ath6kl_cfg80211_sscan_start,
+	.sched_scan_stop = ath6kl_cfg80211_sscan_stop,
 };
 
 void ath6kl_cfg80211_stop(struct ath6kl_vif *vif)
 {
+	ath6kl_cfg80211_sscan_disable(vif);
+
 	switch (vif->sme_state) {
 	case SME_DISCONNECTED:
 		break;
@@ -2547,6 +2686,8 @@ int ath6kl_register_ieee80211_hw(struct ath6kl *ar)
 	wiphy->wowlan.pattern_min_len = 1;
 	wiphy->wowlan.pattern_max_len = WOW_PATTERN_SIZE;
 
+	wiphy->max_sched_scan_ssids = 10;
+
 	ret = wiphy_register(wiphy);
 	if (ret < 0) {
 		ath6kl_err("couldn't register wiphy device\n");
@@ -2566,6 +2707,9 @@ static int ath6kl_init_if_data(struct ath6kl_vif *vif)
 
 	setup_timer(&vif->disconnect_timer, disconnect_timer_handler,
 		    (unsigned long) vif->ndev);
+	setup_timer(&vif->sched_scan_timer, ath6kl_wmi_sscan_timer,
+		    (unsigned long) vif);
+
 	set_bit(WMM_ENABLED, &vif->flags);
 	spin_lock_init(&vif->if_lock);
 
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index 226a734..81f20a5 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -20,7 +20,8 @@
 enum ath6kl_cfg_suspend_mode {
 	ATH6KL_CFG_SUSPEND_DEEPSLEEP,
 	ATH6KL_CFG_SUSPEND_CUTPOWER,
-	ATH6KL_CFG_SUSPEND_WOW
+	ATH6KL_CFG_SUSPEND_WOW,
+	ATH6KL_CFG_SUSPEND_SCHED_SCAN,
 };
 
 struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 96f65c9..3d2abdb 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -76,6 +76,7 @@ enum ath6kl_fw_ie_type {
 
 enum ath6kl_fw_capability {
 	ATH6KL_FW_CAPABILITY_HOST_P2P = 0,
+	ATH6KL_FW_CAPABILITY_SCHED_SCAN = 1,
 
 	/* this needs to be last */
 	ATH6KL_FW_CAPABILITY_MAX,
@@ -447,7 +448,10 @@ struct ath6kl_vif {
 	struct ath6kl_wep_key wep_key_list[WMI_MAX_KEY_INDEX + 1];
 	struct ath6kl_key keys[WMI_MAX_KEY_INDEX + 1];
 	struct aggr_info *aggr_cntxt;
+
 	struct timer_list disconnect_timer;
+	struct timer_list sched_scan_timer;
+
 	struct cfg80211_scan_request *scan_req;
 	enum sme_state sme_state;
 	int reconnect_flag;
@@ -465,6 +469,8 @@ struct ath6kl_vif {
 #define WOW_LIST_ID		0
 #define WOW_HOST_REQ_DELAY	500 /* ms */
 
+#define ATH6KL_SCHED_SCAN_RESULT_DELAY 5000 /* ms */
+
 /* Flag info */
 enum ath6kl_dev_state {
 	WMI_ENABLED,
@@ -483,6 +489,7 @@ enum ath6kl_state {
 	ATH6KL_STATE_DEEPSLEEP,
 	ATH6KL_STATE_CUTPOWER,
 	ATH6KL_STATE_WOW,
+	ATH6KL_STATE_SCHED_SCAN,
 };
 
 struct ath6kl {
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 5753f00..510dee0 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -920,6 +920,8 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 				   "found firmware capabilities ie (%zd B)\n",
 				   ie_len);
 
+			/* FIXME: check ie_len */
+
 			for (i = 0; i < ATH6KL_FW_CAPABILITY_MAX; i++) {
 				index = i / 8;
 				bit = i % 8;
@@ -1644,6 +1646,9 @@ int ath6kl_core_init(struct ath6kl *ar)
 			    WIPHY_FLAG_HAVE_AP_SME |
 			    WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
 
+	if (test_bit(ATH6KL_FW_CAPABILITY_SCHED_SCAN, ar->fw_capabilities))
+		ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
+
 	ar->wiphy->probe_resp_offload =
 		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
 		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 |
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 5f19910..15c3f56 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -807,7 +807,28 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 		return ret;
 	}
 
-	if ((flags & MMC_PM_WAKE_SDIO_IRQ) && wow) {
+	if (!(flags & MMC_PM_WAKE_SDIO_IRQ))
+		goto deepsleep;
+
+	/* sdio irq wakes up host */
+
+	if (ar->state == ATH6KL_STATE_SCHED_SCAN) {
+		ret =  ath6kl_cfg80211_suspend(ar,
+					       ATH6KL_CFG_SUSPEND_SCHED_SCAN,
+					       NULL);
+		if (ret) {
+			ath6kl_warn("Schedule scan suspend failed: %d", ret);
+			return ret;
+		}
+
+		ret = sdio_set_host_pm_flags(func, MMC_PM_WAKE_SDIO_IRQ);
+		if (ret)
+			ath6kl_warn("set sdio wake irq flag failed: %d\n", ret);
+
+		return ret;
+	}
+
+	if (wow) {
 		/*
 		 * The host sdio controller is capable of keep power and
 		 * sdio irq wake up at this point. It's fine to continue
@@ -824,6 +845,7 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 		return ret;
 	}
 
+deepsleep:
 	return ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_DEEPSLEEP, NULL);
 }
 
@@ -847,6 +869,8 @@ static int ath6kl_sdio_resume(struct ath6kl *ar)
 
 	case ATH6KL_STATE_WOW:
 		break;
+	case ATH6KL_STATE_SCHED_SCAN:
+		break;
 	}
 
 	ath6kl_cfg80211_resume(ar);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index aa1a252..75e0f5e 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -977,6 +977,13 @@ static int ath6kl_wmi_tkip_micerr_event_rx(struct wmi *wmi, u8 *datap, int len,
 	return 0;
 }
 
+void ath6kl_wmi_sscan_timer(unsigned long ptr)
+{
+	struct ath6kl_vif *vif = (struct ath6kl_vif *) ptr;
+
+	cfg80211_sched_scan_results(vif->ar->wiphy);
+}
+
 static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len,
 				       struct ath6kl_vif *vif)
 {
@@ -1066,6 +1073,21 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len,
 		return -ENOMEM;
 	cfg80211_put_bss(bss);
 
+	/*
+	 * Firmware doesn't return any event when scheduled scan has
+	 * finished, so we need to use a timer to find out when there are
+	 * no more results.
+	 *
+	 * The timer is started from the first bss info received, otherwise
+	 * the timer would not ever fire if the scan interval is short
+	 * enough.
+	 */
+	if (ar->state == ATH6KL_STATE_SCHED_SCAN &&
+	    !timer_pending(&vif->sched_scan_timer)) {
+		mod_timer(&vif->sched_scan_timer, jiffies +
+			  msecs_to_jiffies(ATH6KL_SCHED_SCAN_RESULT_DELAY));
+	}
+
 	return 0;
 }
 
@@ -2940,7 +2962,10 @@ int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 if_idx, u8 mgmt_frm_type,
 	p = (struct wmi_set_appie_cmd *) skb->data;
 	p->mgmt_frm_type = mgmt_frm_type;
 	p->ie_len = ie_len;
-	memcpy(p->ie_info, ie, ie_len);
+
+	if (ie != NULL && ie_len > 0)
+		memcpy(p->ie_info, ie, ie_len);
+
 	return ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SET_APPIE_CMDID,
 				   NO_SYNC_WMIFLAG);
 }
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index cbde79c..85dcdad 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2349,6 +2349,8 @@ int ath6kl_wmi_cancel_remain_on_chnl_cmd(struct wmi *wmi, u8 if_idx);
 int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 if_idx, u8 mgmt_frm_type,
 			     const u8 *ie, u8 ie_len);
 
+void ath6kl_wmi_sscan_timer(unsigned long ptr);
+
 struct ath6kl_vif *ath6kl_get_vif_by_index(struct ath6kl *ar, u8 if_idx);
 void *ath6kl_wmi_init(struct ath6kl *devt);
 void ath6kl_wmi_shutdown(struct wmi *wmi);

