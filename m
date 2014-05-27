Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55608 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaE0Lqj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 07:46:39 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 5/7] wil6210: detect scan timeouts
Date: Tue, 27 May 2014 14:45:48 +0300
Message-ID: <1401191150-29037-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140527_134643_125497_BC548CE3)
In-Reply-To: <1401191150-29037-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1401191150-29037-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If scan has not finished in some reasonable time (10sec), interpret it as
if firmware error occurs but was not reported. Firmware should report
scan completion for every scan request, so it is error condition indeed.
Perform firmware recovery procedure.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  1 +
 drivers/net/wireless/ath/wil6210/main.c     | 13 +++++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h  |  2 ++
 drivers/net/wireless/ath/wil6210/wmi.c      |  1 +
 4 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 6e699d0..820d4eb 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -288,6 +288,7 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 	}
 
 	wil->scan_request = request;
+	mod_timer(&wil->scan_timer, jiffies + WIL6210_SCAN_TO);
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.cmd.num_channels = 0;
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index f24cb92..11e6d9d 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -150,6 +150,15 @@ static void wil_connect_timer_fn(ulong x)
 	schedule_work(&wil->disconnect_worker);
 }
 
+static void wil_scan_timer_fn(ulong x)
+{
+	struct wil6210_priv *wil = (void *)x;
+
+	clear_bit(wil_status_fwready, &wil->status);
+	wil_err(wil, "Scan timeout detected, start fw error recovery\n");
+	schedule_work(&wil->fw_error_worker);
+}
+
 static void wil_fw_error_worker(struct work_struct *work)
 {
 	struct wil6210_priv *wil = container_of(work,
@@ -248,6 +257,7 @@ int wil_priv_init(struct wil6210_priv *wil)
 
 	wil->pending_connect_cid = -1;
 	setup_timer(&wil->connect_timer, wil_connect_timer_fn, (ulong)wil);
+	setup_timer(&wil->scan_timer, wil_scan_timer_fn, (ulong)wil);
 
 	INIT_WORK(&wil->connect_worker, wil_connect_worker);
 	INIT_WORK(&wil->disconnect_worker, wil_disconnect_worker);
@@ -280,6 +290,7 @@ void wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid)
 
 void wil_priv_deinit(struct wil6210_priv *wil)
 {
+	del_timer_sync(&wil->scan_timer);
 	cancel_work_sync(&wil->disconnect_worker);
 	cancel_work_sync(&wil->fw_error_worker);
 	mutex_lock(&wil->mutex);
@@ -411,6 +422,7 @@ int wil_reset(struct wil6210_priv *wil)
 	if (wil->scan_request) {
 		wil_dbg_misc(wil, "Abort scan_request 0x%p\n",
 			     wil->scan_request);
+		del_timer_sync(&wil->scan_timer);
 		cfg80211_scan_done(wil->scan_request, true);
 		wil->scan_request = NULL;
 	}
@@ -540,6 +552,7 @@ static int __wil_down(struct wil6210_priv *wil)
 	napi_disable(&wil->napi_tx);
 
 	if (wil->scan_request) {
+		del_timer_sync(&wil->scan_timer);
 		cfg80211_scan_done(wil->scan_request, true);
 		wil->scan_request = NULL;
 	}
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index f8c598e..e25edc5 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -42,6 +42,7 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
 #define WIL6210_ITR_TRSH	(10000) /* arbitrary - about 15 IRQs/msec */
 #define WIL6210_FW_RECOVERY_RETRIES	(5) /* try to recover this many times */
 #define WIL6210_FW_RECOVERY_TO	msecs_to_jiffies(5000)
+#define WIL6210_SCAN_TO		msecs_to_jiffies(10000)
 
 /* Hardware definitions begin */
 
@@ -386,6 +387,7 @@ struct wil6210_priv {
 	struct work_struct disconnect_worker;
 	struct work_struct fw_error_worker;	/* for FW error recovery */
 	struct timer_list connect_timer;
+	struct timer_list scan_timer; /* detect scan timeout */
 	int pending_connect_cid;
 	struct list_head pending_wmi_ev;
 	/*
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index abcba5a..76b6657 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -351,6 +351,7 @@ static void wmi_evt_scan_complete(struct wil6210_priv *wil, int id,
 		bool aborted = (data->status != WMI_SCAN_SUCCESS);
 
 		wil_dbg_wmi(wil, "SCAN_COMPLETE(0x%08x)\n", data->status);
+		del_timer_sync(&wil->scan_timer);
 		cfg80211_scan_done(wil->scan_request, aborted);
 		wil->scan_request = NULL;
 	} else {
-- 
1.9.1

