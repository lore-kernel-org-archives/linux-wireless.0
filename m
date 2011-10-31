Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:38310 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab1JaJz6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 05:55:58 -0400
Subject: [PATCH 1/5] ath6kl: add aborted parameter to
	ath6kl_cfg80211_scan_complete_event()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 31 Oct 2011 11:55:50 +0200
Message-ID: <20111031095550.3598.52653.stgit@localhost6.localdomain6> (sfid-20111031_105600_796984_3B3C5B4F)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently it takes error code as status, but what we really want to
tell is if the scan was aborted or not.

Also fix a bug where we were comparing firmware scan status values
with kernel error codes, which is naturally wrong. This meant
that ath6kl didn't detect when firmware informed about failed scans. I
doubt that this fix doesn't make any difference in practise but it
still needs to be fixed. This is fixed by adding an enum for the success
status code and checking for that.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   12 ++++--------
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    2 +-
 drivers/net/wireless/ath/ath6kl/main.c     |   10 +++++++---
 drivers/net/wireless/ath/ath6kl/wmi.h      |    4 ++++
 4 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 994c646..188fded 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -871,23 +871,19 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	return ret;
 }
 
-void ath6kl_cfg80211_scan_complete_event(struct ath6kl_vif *vif, int status)
+void ath6kl_cfg80211_scan_complete_event(struct ath6kl_vif *vif, bool aborted)
 {
 	struct ath6kl *ar = vif->ar;
-	bool aborted;
 	int i;
 
-	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: status %d\n", __func__, status);
+	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: status%s\n", __func__,
+		   aborted ? " aborted" : "");
 
 	if (!vif->scan_req)
 		return;
 
-	if ((status == -ECANCELED) || (status == -EBUSY)) {
-		aborted = true;
+	if (aborted)
 		goto out;
-	}
-
-	aborted = false;
 
 	if (vif->scan_req->n_ssids && vif->scan_req->ssids[0].ssid_len) {
 		for (i = 0; i < vif->scan_req->n_ssids; i++) {
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index d1a0216..f323a49 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -24,7 +24,7 @@ int ath6kl_register_ieee80211_hw(struct ath6kl *ar);
 struct ath6kl *ath6kl_core_alloc(struct device *dev);
 void ath6kl_deinit_ieee80211_hw(struct ath6kl *ar);
 
-void ath6kl_cfg80211_scan_complete_event(struct ath6kl_vif *vif, int status);
+void ath6kl_cfg80211_scan_complete_event(struct ath6kl_vif *vif, bool aborted);
 
 void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
 				   u8 *bssid, u16 listen_intvl,
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index def0b7f..d2822d0 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -624,7 +624,7 @@ void ath6kl_deep_sleep_enable(struct ath6kl *ar)
 		printk(KERN_WARNING "ath6kl: failed to disable scan "
 		       "during suspend\n");
 
-	ath6kl_cfg80211_scan_complete_event(vif, -ECANCELED);
+	ath6kl_cfg80211_scan_complete_event(vif, true);
 
 	/* save the current power mode before enabling power save */
 	ar->wmi->saved_pwr_mode = ar->wmi->pwr_mode;
@@ -684,8 +684,12 @@ void ath6kl_ready_event(void *devt, u8 *datap, u32 sw_ver, u32 abi_ver)
 void ath6kl_scan_complete_evt(struct ath6kl_vif *vif, int status)
 {
 	struct ath6kl *ar = vif->ar;
+	bool aborted = false;
 
-	ath6kl_cfg80211_scan_complete_event(vif, status);
+	if (status != WMI_SCAN_STATUS_SUCCESS)
+		aborted = true;
+
+	ath6kl_cfg80211_scan_complete_event(vif, aborted);
 
 	if (!ar->usr_bss_filter) {
 		clear_bit(CLEAR_BSSFILTER_ON_BEACON, &vif->flags);
@@ -1149,7 +1153,7 @@ static int ath6kl_close(struct net_device *dev)
 
 	}
 
-	ath6kl_cfg80211_scan_complete_event(vif, -ECANCELED);
+	ath6kl_cfg80211_scan_complete_event(vif, true);
 
 	/* FIXME: how to handle multi vif support? */
 	ret = ath6kl_init_hw_stop(ar);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index ae514cb..cf0462a 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1472,6 +1472,10 @@ struct wmi_tkip_micerr_event {
 	u8 is_mcast;
 } __packed;
 
+enum wmi_scan_status {
+	WMI_SCAN_STATUS_SUCCESS = 0,
+};
+
 /* WMI_SCAN_COMPLETE_EVENTID */
 struct wmi_scan_complete_event {
 	a_sle32 status;

