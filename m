Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45364 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933491AbaCQNfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:35:09 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 15/21] wil6210: fw error recovery
Date: Mon, 17 Mar 2014 15:34:19 +0200
Message-ID: <1395063265-6522-16-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_145650_226928_9523D200)
In-Reply-To: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

upon fw error interrupt - in STA mode, disconnect/cancel scan and
then reset FW/HW
added module param - no_fw_recovery which is false by default

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c  |  8 ++++-
 drivers/net/wireless/ath/wil6210/interrupt.c |  1 +
 drivers/net/wireless/ath/wil6210/main.c      | 48 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h   |  2 ++
 4 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 848ed85..f6a12e7 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -265,6 +265,7 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 		u16 chnl[4];
 	} __packed cmd;
 	uint i, n;
+	int rc;
 
 	if (wil->scan_request) {
 		wil_err(wil, "Already scanning\n");
@@ -305,8 +306,13 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 			     request->channels[i]->center_freq);
 	}
 
-	return wmi_send(wil, WMI_START_SCAN_CMDID, &cmd, sizeof(cmd.cmd) +
+	rc = wmi_send(wil, WMI_START_SCAN_CMDID, &cmd, sizeof(cmd.cmd) +
 			cmd.cmd.num_channels * sizeof(cmd.cmd.channel_list[0]));
+
+	if (rc)
+		wil->scan_request = NULL;
+
+	return rc;
 }
 
 static int wil_cfg80211_connect(struct wiphy *wiphy,
diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 201cf06..5824cd4 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -328,6 +328,7 @@ static irqreturn_t wil6210_irq_misc_thread(int irq, void *cookie)
 	if (isr & ISR_MISC_FW_ERROR) {
 		wil_notify_fw_error(wil);
 		isr &= ~ISR_MISC_FW_ERROR;
+		wil_fw_error_recovery(wil);
 	}
 
 	if (isr & ISR_MISC_MBOX_EVT) {
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 0831d4c..32ac1b9 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -21,6 +21,10 @@
 #include "wil6210.h"
 #include "txrx.h"
 
+static bool no_fw_recovery;
+module_param(no_fw_recovery, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(no_fw_recovery, " disable FW error recovery");
+
 /*
  * Due to a hardware issue,
  * one has to read/write to/from NIC in 32-bit chunks;
@@ -144,6 +148,36 @@ static void wil_connect_timer_fn(ulong x)
 	schedule_work(&wil->disconnect_worker);
 }
 
+static void wil_fw_error_worker(struct work_struct *work)
+{
+	struct wil6210_priv *wil = container_of(work,
+			struct wil6210_priv, fw_error_worker);
+	struct wireless_dev *wdev = wil->wdev;
+
+	wil_dbg_misc(wil, "fw error worker\n");
+
+	if (no_fw_recovery)
+		return;
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_MONITOR:
+		wil_info(wil, "fw error recovery started...\n");
+		wil_reset(wil);
+
+		/* need to re-allocate Rx ring after reset */
+		wil_rx_init(wil);
+		break;
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+		/* recovery in these modes is done by upper layers */
+		break;
+	default:
+		break;
+	}
+}
+
 static int wil_find_free_vring(struct wil6210_priv *wil)
 {
 	int i;
@@ -196,6 +230,7 @@ int wil_priv_init(struct wil6210_priv *wil)
 	INIT_WORK(&wil->connect_worker, wil_connect_worker);
 	INIT_WORK(&wil->disconnect_worker, wil_disconnect_worker);
 	INIT_WORK(&wil->wmi_event_worker, wmi_event_worker);
+	INIT_WORK(&wil->fw_error_worker, wil_fw_error_worker);
 
 	INIT_LIST_HEAD(&wil->pending_wmi_ev);
 	spin_lock_init(&wil->wmi_ev_lock);
@@ -222,6 +257,7 @@ void wil6210_disconnect(struct wil6210_priv *wil, void *bssid)
 void wil_priv_deinit(struct wil6210_priv *wil)
 {
 	cancel_work_sync(&wil->disconnect_worker);
+	cancel_work_sync(&wil->fw_error_worker);
 	wil6210_disconnect(wil, NULL);
 	wmi_event_flush(wil);
 	destroy_workqueue(wil->wmi_wq_conn);
@@ -335,6 +371,13 @@ int wil_reset(struct wil6210_priv *wil)
 		napi_synchronize(&wil->napi_tx);
 	}
 
+	if (wil->scan_request) {
+		wil_dbg_misc(wil, "Abort scan_request 0x%p\n",
+			     wil->scan_request);
+		cfg80211_scan_done(wil->scan_request, true);
+		wil->scan_request = NULL;
+	}
+
 	cancel_work_sync(&wil->disconnect_worker);
 	wil6210_disconnect(wil, NULL);
 
@@ -363,6 +406,11 @@ int wil_reset(struct wil6210_priv *wil)
 	return rc;
 }
 
+void wil_fw_error_recovery(struct wil6210_priv *wil)
+{
+	wil_dbg_misc(wil, "starting fw error recovery\n");
+	schedule_work(&wil->fw_error_worker);
+}
 
 void wil_link_on(struct wil6210_priv *wil)
 {
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 89cbdc3..80573f7 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -370,6 +370,7 @@ struct wil6210_priv {
 	struct workqueue_struct *wmi_wq_conn; /* for connect worker */
 	struct work_struct connect_worker;
 	struct work_struct disconnect_worker;
+	struct work_struct fw_error_worker;	/* for FW error recovery */
 	struct timer_list connect_timer;
 	int pending_connect_cid;
 	struct list_head pending_wmi_ev;
@@ -447,6 +448,7 @@ void wil_if_remove(struct wil6210_priv *wil);
 int wil_priv_init(struct wil6210_priv *wil);
 void wil_priv_deinit(struct wil6210_priv *wil);
 int wil_reset(struct wil6210_priv *wil);
+void wil_fw_error_recovery(struct wil6210_priv *wil);
 void wil_link_on(struct wil6210_priv *wil);
 void wil_link_off(struct wil6210_priv *wil);
 int wil_up(struct wil6210_priv *wil);
-- 
1.8.3.2

