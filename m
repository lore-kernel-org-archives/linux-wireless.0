Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:53385 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaJAMFw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 08:05:52 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 1/2] wil6210: manual FW error recovery mode
Date: Wed, 1 Oct 2014 15:05:24 +0300
Message-ID: <1412165125-30435-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141001_140556_211362_C770C622)
In-Reply-To: <1412165125-30435-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1412165125-30435-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce manual FW recovery mode. It is activated if module parameter
@no_fw_recovery set to true. May be changed at runtime.

Recovery information provided by new "recovery" debugfs file. It prints:

mode = [auto|manual]
state = [idle|pending|running]

In manual mode, after FW error, recovery won't start automatically. Instead,
after notification to user space, recovery waits in "pending" state, as indicated by the
"recovery" debugfs file. User space tools may perform data collection and allow to
continue recovery by writing "run" to the "recovery" debugfs file.
Alternatively, recovery pending may be canceled by stopping network interface
i.e. 'ifconfig wlan0 down'

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  4 ++
 drivers/net/wireless/ath/wil6210/debugfs.c  | 67 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/main.c     | 46 ++++++++++++++++----
 drivers/net/wireless/ath/wil6210/wil6210.h  | 12 +++++-
 drivers/net/wireless/ath/wil6210/wmi.c      |  1 +
 5 files changed, 121 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index f3a31e8..d9f4b30 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -728,6 +728,8 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 		wil_print_bcon_data(bcon);
 	}
 
+	wil_set_recovery_state(wil, fw_recovery_idle);
+
 	mutex_lock(&wil->mutex);
 
 	__wil_down(wil);
@@ -775,6 +777,8 @@ static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
+	wil_set_recovery_state(wil, fw_recovery_idle);
+
 	mutex_lock(&wil->mutex);
 
 	rc = wmi_pcp_stop(wil);
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index eb2204e..54a6ddc 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1041,6 +1041,71 @@ static const struct file_operations fops_info = {
 	.llseek		= seq_lseek,
 };
 
+/*---------recovery------------*/
+/* mode = [manual|auto]
+ * state = [idle|pending|running]
+ */
+static ssize_t wil_read_file_recovery(struct file *file, char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct wil6210_priv *wil = file->private_data;
+	char buf[80];
+	int n;
+	static const char * const sstate[] = {"idle", "pending", "running"};
+
+	n = snprintf(buf, sizeof(buf), "mode = %s\nstate = %s\n",
+		     no_fw_recovery ? "manual" : "auto",
+		     sstate[wil->recovery_state]);
+
+	n = min_t(int, n, sizeof(buf));
+
+	return simple_read_from_buffer(user_buf, count, ppos,
+				       buf, n);
+}
+
+static ssize_t wil_write_file_recovery(struct file *file,
+				       const char __user *buf_,
+				       size_t count, loff_t *ppos)
+{
+	struct wil6210_priv *wil = file->private_data;
+	static const char run_command[] = "run";
+	char buf[sizeof(run_command) + 1]; /* to detect "runx" */
+	ssize_t rc;
+
+	if (wil->recovery_state != fw_recovery_pending) {
+		wil_err(wil, "No recovery pending\n");
+		return -EINVAL;
+	}
+
+	if (*ppos != 0) {
+		wil_err(wil, "Offset [%d]\n", (int)*ppos);
+		return -EINVAL;
+	}
+
+	if (count > sizeof(buf)) {
+		wil_err(wil, "Input too long, len = %d\n", (int)count);
+		return -EINVAL;
+	}
+
+	rc = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, buf_, count);
+	if (rc < 0)
+		return rc;
+
+	buf[rc] = '\0';
+	if (0 == strcmp(buf, run_command))
+		wil_set_recovery_state(wil, fw_recovery_running);
+	else
+		wil_err(wil, "Bad recovery command \"%s\"\n", buf);
+
+	return rc;
+}
+
+static const struct file_operations fops_recovery = {
+	.read = wil_read_file_recovery,
+	.write = wil_write_file_recovery,
+	.open  = simple_open,
+};
+
 /*---------Station matrix------------*/
 static void wil_print_rxtid(struct seq_file *s, struct wil_tid_ampdu_rx *r)
 {
@@ -1152,6 +1217,7 @@ static const struct {
 	{"freq",	S_IRUGO,		&fops_freq},
 	{"link",	S_IRUGO,		&fops_link},
 	{"info",	S_IRUGO,		&fops_info},
+	{"recovery",	S_IRUGO | S_IWUSR,	&fops_recovery},
 };
 
 static void wil6210_debugfs_init_files(struct wil6210_priv *wil,
@@ -1194,6 +1260,7 @@ static const struct dbg_off dbg_wil_off[] = {
 	WIL_FIELD(status,	S_IRUGO | S_IWUSR,	doff_ulong),
 	WIL_FIELD(fw_version,	S_IRUGO,		doff_u32),
 	WIL_FIELD(hw_version,	S_IRUGO,		doff_x32),
+	WIL_FIELD(recovery_count, S_IRUGO,		doff_u32),
 	{},
 };
 
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 0424763..6500caf 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -25,9 +25,9 @@
 #define WAIT_FOR_DISCONNECT_TIMEOUT_MS 2000
 #define WAIT_FOR_DISCONNECT_INTERVAL_MS 10
 
-static bool no_fw_recovery;
+bool no_fw_recovery;
 module_param(no_fw_recovery, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(no_fw_recovery, " disable FW error recovery");
+MODULE_PARM_DESC(no_fw_recovery, " disable automatic FW error recovery");
 
 static bool no_fw_load = true;
 module_param(no_fw_load, bool, S_IRUGO | S_IWUSR);
@@ -191,17 +191,38 @@ static void wil_scan_timer_fn(ulong x)
 	schedule_work(&wil->fw_error_worker);
 }
 
+static int wil_wait_for_recovery(struct wil6210_priv *wil)
+{
+	if (wait_event_interruptible(wil->wq, wil->recovery_state !=
+				     fw_recovery_pending)) {
+		wil_err(wil, "Interrupt, canceling recovery\n");
+		return -ERESTARTSYS;
+	}
+	if (wil->recovery_state != fw_recovery_running) {
+		wil_info(wil, "Recovery cancelled\n");
+		return -EINTR;
+	}
+	wil_info(wil, "Proceed with recovery\n");
+	return 0;
+}
+
+void wil_set_recovery_state(struct wil6210_priv *wil, int state)
+{
+	wil_dbg_misc(wil, "%s(%d -> %d)\n", __func__,
+		     wil->recovery_state, state);
+
+	wil->recovery_state = state;
+	wake_up_interruptible(&wil->wq);
+}
+
 static void wil_fw_error_worker(struct work_struct *work)
 {
-	struct wil6210_priv *wil = container_of(work,
-			struct wil6210_priv, fw_error_worker);
+	struct wil6210_priv *wil = container_of(work, struct wil6210_priv,
+						fw_error_worker);
 	struct wireless_dev *wdev = wil->wdev;
 
 	wil_dbg_misc(wil, "fw error worker\n");
 
-	if (no_fw_recovery)
-		return;
-
 	/* increment @recovery_count if less then WIL6210_FW_RECOVERY_TO
 	 * passed since last recovery attempt
 	 */
@@ -224,8 +245,13 @@ static void wil_fw_error_worker(struct work_struct *work)
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_MONITOR:
-		wil_info(wil, "fw error recovery started (try %d)...\n",
+		wil_info(wil, "fw error recovery requested (try %d)...\n",
 			 wil->recovery_count);
+		if (!no_fw_recovery)
+			wil->recovery_state = fw_recovery_running;
+		if (0 != wil_wait_for_recovery(wil))
+			break;
+
 		__wil_down(wil);
 		__wil_up(wil);
 		break;
@@ -302,6 +328,7 @@ int wil_priv_init(struct wil6210_priv *wil)
 
 	INIT_LIST_HEAD(&wil->pending_wmi_ev);
 	spin_lock_init(&wil->wmi_ev_lock);
+	init_waitqueue_head(&wil->wq);
 
 	wil->wmi_wq = create_singlethread_workqueue(WIL_NAME"_wmi");
 	if (!wil->wmi_wq)
@@ -331,6 +358,7 @@ void wil_priv_deinit(struct wil6210_priv *wil)
 {
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
+	wil_set_recovery_state(wil, fw_recovery_idle);
 	del_timer_sync(&wil->scan_timer);
 	cancel_work_sync(&wil->disconnect_worker);
 	cancel_work_sync(&wil->fw_error_worker);
@@ -573,6 +601,7 @@ int wil_reset(struct wil6210_priv *wil)
 void wil_fw_error_recovery(struct wil6210_priv *wil)
 {
 	wil_dbg_misc(wil, "starting fw error recovery\n");
+	wil->recovery_state = fw_recovery_pending;
 	schedule_work(&wil->fw_error_worker);
 }
 
@@ -724,6 +753,7 @@ int wil_down(struct wil6210_priv *wil)
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
+	wil_set_recovery_state(wil, fw_recovery_idle);
 	mutex_lock(&wil->mutex);
 	rc = __wil_down(wil);
 	mutex_unlock(&wil->mutex);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 00c4f0a..2991609 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -23,6 +23,7 @@
 #include <linux/timex.h>
 #include "wil_platform.h"
 
+extern bool no_fw_recovery;
 
 #define WIL_NAME "wil6210"
 #define WIL_FW_NAME "wil6210.fw"
@@ -379,6 +380,12 @@ struct wil_sta_info {
 	unsigned long tid_rx_stop_requested[BITS_TO_LONGS(WIL_STA_TID_NUM)];
 };
 
+enum {
+	fw_recovery_idle = 0,
+	fw_recovery_pending = 1,
+	fw_recovery_running = 2,
+};
+
 struct wil6210_priv {
 	struct pci_dev *pdev;
 	int n_msi;
@@ -389,8 +396,10 @@ struct wil6210_priv {
 	u32 hw_version;
 	struct wil_board *board;
 	u8 n_mids; /* number of additional MIDs as reported by FW */
-	int recovery_count; /* num of FW recovery attempts in a short time */
+	u32 recovery_count; /* num of FW recovery attempts in a short time */
+	u32 recovery_state; /* FW recovery state machine */
 	unsigned long last_fw_recovery; /* jiffies of last fw recovery */
+	wait_queue_head_t wq; /* for all wait_event() use */
 	/* profile */
 	u32 monitor_flags;
 	u32 secure_pcp; /* create secure PCP? */
@@ -507,6 +516,7 @@ void wil_priv_deinit(struct wil6210_priv *wil);
 int wil_reset(struct wil6210_priv *wil);
 void wil_set_itr_trsh(struct wil6210_priv *wil);
 void wil_fw_error_recovery(struct wil6210_priv *wil);
+void wil_set_recovery_state(struct wil6210_priv *wil, int state);
 void wil_link_on(struct wil6210_priv *wil);
 void wil_link_off(struct wil6210_priv *wil);
 int wil_up(struct wil6210_priv *wil);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index bd781c7..4311df9 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -299,6 +299,7 @@ static void wmi_evt_fw_ready(struct wil6210_priv *wil, int id, void *d,
 {
 	wil_dbg_wmi(wil, "WMI: got FW ready event\n");
 
+	wil_set_recovery_state(wil, fw_recovery_idle);
 	set_bit(wil_status_fwready, &wil->status);
 	/* let the reset sequence continue */
 	complete(&wil->wmi_ready);
-- 
1.9.1

