Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47707 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752263AbcKPNJr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 08:09:47 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v3 1/5] mwifiex: don't wait for main_process in shutdown_drv
Date: Wed, 16 Nov 2016 18:39:05 +0530
Message-ID: <1479301749-14803-1-git-send-email-akarwar@marvell.com> (sfid-20161116_140951_831508_20F2FDD4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

main_process is not expected to be running when shutdown_drv function
is called. currently we wait for main_process completion in the
function.

Actually the caller has already made sure main_process is completed by
performing below actions.
(1) disable interrupts in if_ops->disable_int.
(2) set adapter->surprise_removed = true, main_process wont be queued.
(3) mwifiex_terminate_workqueue(adapter), wait for workqueue to be
completed.

This patch removes redundant wait code and takes care of related
cleanup.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v3: a) This patch is introduced in v3. It replaces "[v2,2/5] mwifiex: use spinlock for
    'mwifiex_processing' in shutdown_drv" patch.
    b) "[v2,1/5] mwifiex: remove redundant condition in main process" is dropped in
    this patch series.
---
 drivers/net/wireless/marvell/mwifiex/init.c | 19 ++--------
 drivers/net/wireless/marvell/mwifiex/main.c | 55 ++++++++++-------------------
 drivers/net/wireless/marvell/mwifiex/main.h |  5 +--
 drivers/net/wireless/marvell/mwifiex/util.c | 15 --------
 4 files changed, 22 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index b36cb3f..f581a15 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -656,10 +656,9 @@ void mwifiex_free_priv(struct mwifiex_private *priv)
  *      - Free the adapter
  *      - Notify completion
  */
-int
+void
 mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 {
-	int ret = -EINPROGRESS;
 	struct mwifiex_private *priv;
 	s32 i;
 	unsigned long flags;
@@ -667,15 +666,7 @@ void mwifiex_free_priv(struct mwifiex_private *priv)
 
 	/* mwifiex already shutdown */
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_NOT_READY)
-		return 0;
-
-	adapter->hw_status = MWIFIEX_HW_STATUS_CLOSING;
-	/* wait for mwifiex_process to complete */
-	if (adapter->mwifiex_processing) {
-		mwifiex_dbg(adapter, WARN,
-			    "main process is still running\n");
-		return ret;
-	}
+		return;
 
 	/* cancel current command */
 	if (adapter->curr_cmd) {
@@ -726,11 +717,7 @@ void mwifiex_free_priv(struct mwifiex_private *priv)
 	mwifiex_adapter_cleanup(adapter);
 
 	spin_unlock(&adapter->mwifiex_lock);
-
-	/* Notify completion */
-	ret = mwifiex_shutdown_fw_complete(adapter);
-
-	return ret;
+	adapter->hw_status = MWIFIEX_HW_STATUS_NOT_READY;
 }
 
 /*
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index eac44fe..379e084 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -248,15 +248,14 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 	if (adapter->mwifiex_processing || adapter->main_locked) {
 		adapter->more_task_flag = true;
 		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
-		goto exit_main_proc;
+		return 0;
 	} else {
 		adapter->mwifiex_processing = true;
 		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
 	}
 process_start:
 	do {
-		if ((adapter->hw_status == MWIFIEX_HW_STATUS_CLOSING) ||
-		    (adapter->hw_status == MWIFIEX_HW_STATUS_NOT_READY))
+		if (adapter->hw_status == MWIFIEX_HW_STATUS_NOT_READY)
 			break;
 
 		/* For non-USB interfaces, If we process interrupts first, it
@@ -464,9 +463,6 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 	adapter->mwifiex_processing = false;
 	spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
 
-exit_main_proc:
-	if (adapter->hw_status == MWIFIEX_HW_STATUS_CLOSING)
-		mwifiex_shutdown_drv(adapter);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mwifiex_main_process);
@@ -648,16 +644,14 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	if (adapter->if_ops.unregister_dev)
 		adapter->if_ops.unregister_dev(adapter);
 
+	adapter->surprise_removed = true;
+	mwifiex_terminate_workqueue(adapter);
+
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_READY) {
 		pr_debug("info: %s: shutdown mwifiex\n", __func__);
-		adapter->init_wait_q_woken = false;
-
-		if (mwifiex_shutdown_drv(adapter) == -EINPROGRESS)
-			wait_event_interruptible(adapter->init_wait_q,
-						 adapter->init_wait_q_woken);
+		mwifiex_shutdown_drv(adapter);
 	}
-	adapter->surprise_removed = true;
-	mwifiex_terminate_workqueue(adapter);
+
 	init_failed = true;
 done:
 	if (adapter->cal_data) {
@@ -1402,11 +1396,8 @@ static void mwifiex_main_work_queue(struct work_struct *work)
 	}
 
 	mwifiex_dbg(adapter, CMD, "cmd: calling mwifiex_shutdown_drv...\n");
-	adapter->init_wait_q_woken = false;
 
-	if (mwifiex_shutdown_drv(adapter) == -EINPROGRESS)
-		wait_event_interruptible(adapter->init_wait_q,
-					 adapter->init_wait_q_woken);
+	mwifiex_shutdown_drv(adapter);
 	if (adapter->if_ops.down_dev)
 		adapter->if_ops.down_dev(adapter);
 
@@ -1512,19 +1503,16 @@ static void mwifiex_main_work_queue(struct work_struct *work)
 	mwifiex_dbg(adapter, ERROR, "info: %s: unregister device\n", __func__);
 	if (adapter->if_ops.unregister_dev)
 		adapter->if_ops.unregister_dev(adapter);
+
+err_kmalloc:
+	adapter->surprise_removed = true;
+	mwifiex_terminate_workqueue(adapter);
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_READY) {
 		mwifiex_dbg(adapter, ERROR,
 			    "info: %s: shutdown mwifiex\n", __func__);
-		adapter->init_wait_q_woken = false;
-
-		if (mwifiex_shutdown_drv(adapter) == -EINPROGRESS)
-			wait_event_interruptible(adapter->init_wait_q,
-						 adapter->init_wait_q_woken);
+		mwifiex_shutdown_drv(adapter);
 	}
 
-err_kmalloc:
-	mwifiex_terminate_workqueue(adapter);
-	adapter->surprise_removed = true;
 	complete_all(adapter->fw_done);
 	mwifiex_dbg(adapter, INFO, "%s, error\n", __func__);
 
@@ -1684,17 +1672,13 @@ static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
 	pr_debug("info: %s: unregister device\n", __func__);
 	if (adapter->if_ops.unregister_dev)
 		adapter->if_ops.unregister_dev(adapter);
-	if (adapter->hw_status == MWIFIEX_HW_STATUS_READY) {
-		pr_debug("info: %s: shutdown mwifiex\n", __func__);
-		adapter->init_wait_q_woken = false;
-
-		if (mwifiex_shutdown_drv(adapter) == -EINPROGRESS)
-			wait_event_interruptible(adapter->init_wait_q,
-						 adapter->init_wait_q_woken);
-	}
 err_registerdev:
 	adapter->surprise_removed = true;
 	mwifiex_terminate_workqueue(adapter);
+	if (adapter->hw_status == MWIFIEX_HW_STATUS_READY) {
+		pr_debug("info: %s: shutdown mwifiex\n", __func__);
+		mwifiex_shutdown_drv(adapter);
+	}
 err_kmalloc:
 	mwifiex_free_adapter(adapter);
 
@@ -1744,11 +1728,8 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter)
 
 	mwifiex_dbg(adapter, CMD,
 		    "cmd: calling mwifiex_shutdown_drv...\n");
-	adapter->init_wait_q_woken = false;
 
-	if (mwifiex_shutdown_drv(adapter) == -EINPROGRESS)
-		wait_event_interruptible(adapter->init_wait_q,
-					 adapter->init_wait_q_woken);
+	mwifiex_shutdown_drv(adapter);
 	mwifiex_dbg(adapter, CMD,
 		    "cmd: mwifiex_shutdown_drv done\n");
 	if (atomic_read(&adapter->rx_pending) ||
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 5c9bd94..fd56b5d 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -248,7 +248,6 @@ enum MWIFIEX_HARDWARE_STATUS {
 	MWIFIEX_HW_STATUS_INITIALIZING,
 	MWIFIEX_HW_STATUS_INIT_DONE,
 	MWIFIEX_HW_STATUS_RESET,
-	MWIFIEX_HW_STATUS_CLOSING,
 	MWIFIEX_HW_STATUS_NOT_READY
 };
 
@@ -1041,9 +1040,7 @@ void mwifiex_wake_up_net_dev_queue(struct net_device *netdev,
 
 int mwifiex_init_fw_complete(struct mwifiex_adapter *adapter);
 
-int mwifiex_shutdown_drv(struct mwifiex_adapter *adapter);
-
-int mwifiex_shutdown_fw_complete(struct mwifiex_adapter *adapter);
+void mwifiex_shutdown_drv(struct mwifiex_adapter *adapter);
 
 int mwifiex_dnld_fw(struct mwifiex_adapter *, struct mwifiex_fw_image *);
 
diff --git a/drivers/net/wireless/marvell/mwifiex/util.c b/drivers/net/wireless/marvell/mwifiex/util.c
index 18fbb96..b1ab8da 100644
--- a/drivers/net/wireless/marvell/mwifiex/util.c
+++ b/drivers/net/wireless/marvell/mwifiex/util.c
@@ -146,21 +146,6 @@ int mwifiex_init_fw_complete(struct mwifiex_adapter *adapter)
 }
 
 /*
- * Firmware shutdown complete callback handler.
- *
- * This function sets the hardware status to not ready and wakes up
- * the function waiting on the init wait queue for the firmware
- * shutdown to complete.
- */
-int mwifiex_shutdown_fw_complete(struct mwifiex_adapter *adapter)
-{
-	adapter->hw_status = MWIFIEX_HW_STATUS_NOT_READY;
-	adapter->init_wait_q_woken = true;
-	wake_up_interruptible(&adapter->init_wait_q);
-	return 0;
-}
-
-/*
  * This function sends init/shutdown command
  * to firmware.
  */
-- 
1.9.1
