Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12629 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751628AbcJ2Fvt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Oct 2016 01:51:49 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 4/7] wil6210: add support for abort scan
Date: Sat, 29 Oct 2016 08:51:24 +0300
Message-Id: <1477720287-17606-5-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20161029_075153_952631_752CD72B)
In-Reply-To: <1477720287-17606-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1477720287-17606-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement cfg80211 abort_scan op to allow the upper layer to
abort an ongoing scan request.
In addition, notify wil6210 device on scan abort request instead
of just ignoring the scan response.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 31 ++++++++++++++++
 drivers/net/wireless/ath/wil6210/main.c     | 56 ++++++++++++++++-------------
 drivers/net/wireless/ath/wil6210/p2p.c      | 10 ++----
 drivers/net/wireless/ath/wil6210/wil6210.h  |  3 ++
 drivers/net/wireless/ath/wil6210/wmi.c      | 21 +++++++++--
 5 files changed, 87 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index c6dd7a3..533872a 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -469,6 +469,34 @@ out:
 	return rc;
 }
 
+static void wil_cfg80211_abort_scan(struct wiphy *wiphy,
+				    struct wireless_dev *wdev)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_dbg_misc(wil, "wdev=0x%p iftype=%d\n", wdev, wdev->iftype);
+
+	mutex_lock(&wil->mutex);
+	mutex_lock(&wil->p2p_wdev_mutex);
+
+	if (!wil->scan_request)
+		goto out;
+
+	if (wdev != wil->scan_request->wdev) {
+		wil_dbg_misc(wil, "abort scan was called on the wrong iface\n");
+		goto out;
+	}
+
+	if (wil->radio_wdev == wil->p2p_wdev)
+		wil_p2p_stop_radio_operations(wil);
+	else
+		wil_abort_scan(wil, true);
+
+out:
+	mutex_unlock(&wil->p2p_wdev_mutex);
+	mutex_unlock(&wil->mutex);
+}
+
 static void wil_print_crypto(struct wil6210_priv *wil,
 			     struct cfg80211_crypto_settings *c)
 {
@@ -1419,8 +1447,10 @@ static void wil_cfg80211_stop_p2p_device(struct wiphy *wiphy,
 
 	wil_dbg_misc(wil, "%s: entered\n", __func__);
 	mutex_lock(&wil->mutex);
+	mutex_lock(&wil->p2p_wdev_mutex);
 	wil_p2p_stop_radio_operations(wil);
 	p2p->p2p_dev_started = 0;
+	mutex_unlock(&wil->p2p_wdev_mutex);
 	mutex_unlock(&wil->mutex);
 }
 
@@ -1456,6 +1486,7 @@ static struct cfg80211_ops wil_cfg80211_ops = {
 	.add_virtual_intf = wil_cfg80211_add_iface,
 	.del_virtual_intf = wil_cfg80211_del_iface,
 	.scan = wil_cfg80211_scan,
+	.abort_scan = wil_cfg80211_abort_scan,
 	.connect = wil_cfg80211_connect,
 	.disconnect = wil_cfg80211_disconnect,
 	.change_virtual_intf = wil_cfg80211_change_iface,
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index a9bbd0b..65a487c 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -24,6 +24,7 @@
 #include "boot_loader.h"
 
 #define WAIT_FOR_HALP_VOTE_MS 100
+#define WAIT_FOR_SCAN_ABORT_MS 1000
 
 bool debug_fw; /* = false; */
 module_param(debug_fw, bool, S_IRUGO);
@@ -808,6 +809,34 @@ static int wil_wait_for_fw_ready(struct wil6210_priv *wil)
 	return 0;
 }
 
+void wil_abort_scan(struct wil6210_priv *wil, bool sync)
+{
+	int rc;
+	struct cfg80211_scan_info info = {
+		.aborted = true,
+	};
+
+	lockdep_assert_held(&wil->p2p_wdev_mutex);
+
+	if (!wil->scan_request)
+		return;
+
+	wil_dbg_misc(wil, "Abort scan_request 0x%p\n", wil->scan_request);
+	del_timer_sync(&wil->scan_timer);
+	mutex_unlock(&wil->p2p_wdev_mutex);
+	rc = wmi_abort_scan(wil);
+	if (!rc && sync)
+		wait_event_interruptible_timeout(wil->wq, !wil->scan_request,
+						 msecs_to_jiffies(
+						 WAIT_FOR_SCAN_ABORT_MS));
+
+	mutex_lock(&wil->p2p_wdev_mutex);
+	if (wil->scan_request) {
+		cfg80211_scan_done(wil->scan_request, &info);
+		wil->scan_request = NULL;
+	}
+}
+
 /*
  * We reset all the structures, and we reset the UMAC.
  * After calling this routine, you're expected to reload
@@ -860,17 +889,7 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 	mutex_unlock(&wil->wmi_mutex);
 
 	mutex_lock(&wil->p2p_wdev_mutex);
-	if (wil->scan_request) {
-		struct cfg80211_scan_info info = {
-			.aborted = true,
-		};
-
-		wil_dbg_misc(wil, "Abort scan_request 0x%p\n",
-			     wil->scan_request);
-		del_timer_sync(&wil->scan_timer);
-		cfg80211_scan_done(wil->scan_request, &info);
-		wil->scan_request = NULL;
-	}
+	wil_abort_scan(wil, false);
 	mutex_unlock(&wil->p2p_wdev_mutex);
 
 	wil_mask_irq(wil);
@@ -1063,20 +1082,9 @@ int __wil_down(struct wil6210_priv *wil)
 	}
 	wil_enable_irq(wil);
 
-	wil_p2p_stop_radio_operations(wil);
-
 	mutex_lock(&wil->p2p_wdev_mutex);
-	if (wil->scan_request) {
-		struct cfg80211_scan_info info = {
-			.aborted = true,
-		};
-
-		wil_dbg_misc(wil, "Abort scan_request 0x%p\n",
-			     wil->scan_request);
-		del_timer_sync(&wil->scan_timer);
-		cfg80211_scan_done(wil->scan_request, &info);
-		wil->scan_request = NULL;
-	}
+	wil_p2p_stop_radio_operations(wil);
+	wil_abort_scan(wil, false);
 	mutex_unlock(&wil->p2p_wdev_mutex);
 
 	wil_reset(wil, false);
diff --git a/drivers/net/wireless/ath/wil6210/p2p.c b/drivers/net/wireless/ath/wil6210/p2p.c
index 4087785..4f0eab0 100644
--- a/drivers/net/wireless/ath/wil6210/p2p.c
+++ b/drivers/net/wireless/ath/wil6210/p2p.c
@@ -272,8 +272,7 @@ void wil_p2p_stop_radio_operations(struct wil6210_priv *wil)
 	};
 
 	lockdep_assert_held(&wil->mutex);
-
-	mutex_lock(&wil->p2p_wdev_mutex);
+	lockdep_assert_held(&wil->p2p_wdev_mutex);
 
 	if (wil->radio_wdev != wil->p2p_wdev)
 		goto out;
@@ -281,10 +280,8 @@ void wil_p2p_stop_radio_operations(struct wil6210_priv *wil)
 	if (!p2p->discovery_started) {
 		/* Regular scan on the p2p device */
 		if (wil->scan_request &&
-		    wil->scan_request->wdev == wil->p2p_wdev) {
-			cfg80211_scan_done(wil->scan_request, &info);
-			wil->scan_request = NULL;
-		}
+		    wil->scan_request->wdev == wil->p2p_wdev)
+			wil_abort_scan(wil, true);
 		goto out;
 	}
 
@@ -307,5 +304,4 @@ void wil_p2p_stop_radio_operations(struct wil6210_priv *wil)
 
 out:
 	wil->radio_wdev = wil->wdev;
-	mutex_unlock(&wil->p2p_wdev_mutex);
 }
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 4b22ea4..d65a5e6 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -873,6 +873,9 @@ int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype,
 		  u8 chan, u8 hidden_ssid, u8 is_go);
 int wmi_pcp_stop(struct wil6210_priv *wil);
 int wmi_led_cfg(struct wil6210_priv *wil, bool enable);
+int wmi_abort_scan(struct wil6210_priv *wil);
+void wil_abort_scan(struct wil6210_priv *wil, bool sync);
+
 void wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
 			u16 reason_code, bool from_event);
 void wil_probe_client_flush(struct wil6210_priv *wil);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 8c60437..e726548 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -427,18 +427,20 @@ static void wmi_evt_scan_complete(struct wil6210_priv *wil, int id,
 	mutex_lock(&wil->p2p_wdev_mutex);
 	if (wil->scan_request) {
 		struct wmi_scan_complete_event *data = d;
+		int status = le32_to_cpu(data->status);
 		struct cfg80211_scan_info info = {
-			.aborted = (data->status != WMI_SCAN_SUCCESS),
+			.aborted = ((status != WMI_SCAN_SUCCESS) &&
+				(status != WMI_SCAN_ABORT_REJECTED)),
 		};
 
-		wil_dbg_wmi(wil, "SCAN_COMPLETE(0x%08x)\n", data->status);
+		wil_dbg_wmi(wil, "SCAN_COMPLETE(0x%08x)\n", status);
 		wil_dbg_misc(wil, "Complete scan_request 0x%p aborted %d\n",
 			     wil->scan_request, info.aborted);
-
 		del_timer_sync(&wil->scan_timer);
 		cfg80211_scan_done(wil->scan_request, &info);
 		wil->radio_wdev = wil->wdev;
 		wil->scan_request = NULL;
+		wake_up_interruptible(&wil->wq);
 	} else {
 		wil_err(wil, "SCAN_COMPLETE while not scanning\n");
 	}
@@ -1597,6 +1599,19 @@ int wmi_ps_dev_profile_cfg(struct wil6210_priv *wil,
 	return rc;
 }
 
+int wmi_abort_scan(struct wil6210_priv *wil)
+{
+	int rc;
+
+	wil_dbg_wmi(wil, "sending WMI_ABORT_SCAN_CMDID\n");
+
+	rc = wmi_send(wil, WMI_ABORT_SCAN_CMDID, NULL, 0);
+	if (rc)
+		wil_err(wil, "Failed to abort scan (%d)\n", rc);
+
+	return rc;
+}
+
 void wmi_event_flush(struct wil6210_priv *wil)
 {
 	struct pending_wmi_event *evt, *t;
-- 
1.9.1
