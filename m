Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B8FC3E8A4
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C70BE20880
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:42:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfA1Pmy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:42:54 -0500
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:25405 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726859AbfA1Pmy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:42:54 -0500
X-IronPort-AV: E=Sophos;i="5.56,534,1539640800"; 
   d="scan'208";a="1881360"
Received: from ironmsg03-ams.qualcomm.com ([10.251.56.4])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 28 Jan 2019 16:36:35 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9150"; a="7037510"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg03-ams.qualcomm.com with ESMTP; 28 Jan 2019 16:36:35 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH v2 12/12] wil6210: prevent device memory access while in reset or suspend
Date:   Mon, 28 Jan 2019 17:36:26 +0200
Message-Id: <1548689786-23288-13-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
References: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ahmad Masri <amasri@codeaurora.org>

Accessing some of the memory of the device while the device is
resetting or suspending may cause unexpected error as the HW is still
not in a stable state. Prevent this access to guarantee successful
read/write memory operations.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c        | 26 +++++++++++---
 drivers/net/wireless/ath/wil6210/main.c           | 41 +++++++++++++++++------
 drivers/net/wireless/ath/wil6210/pm.c             | 27 +++++++++------
 drivers/net/wireless/ath/wil6210/wil6210.h        |  5 ++-
 drivers/net/wireless/ath/wil6210/wil_crash_dump.c | 18 ++++------
 5 files changed, 80 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index e8f6d76..d1c3fe8 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -258,6 +258,11 @@ static void wil_print_mbox_ring(struct seq_file *s, const char *prefix,
 
 	wil_halp_vote(wil);
 
+	if (wil_mem_access_lock(wil)) {
+		wil_halp_unvote(wil);
+		return;
+	}
+
 	wil_memcpy_fromio_32(&r, off, sizeof(r));
 	wil_mbox_ring_le2cpus(&r);
 	/*
@@ -323,6 +328,7 @@ static void wil_print_mbox_ring(struct seq_file *s, const char *prefix,
 	}
  out:
 	seq_puts(s, "}\n");
+	wil_mem_access_unlock(wil);
 	wil_halp_unvote(wil);
 }
 
@@ -601,6 +607,12 @@ static int memread_show(struct seq_file *s, void *data)
 	if (ret < 0)
 		return ret;
 
+	ret = wil_mem_access_lock(wil);
+	if (ret) {
+		wil_pm_runtime_put(wil);
+		return ret;
+	}
+
 	a = wmi_buffer(wil, cpu_to_le32(mem_addr));
 
 	if (a)
@@ -608,6 +620,8 @@ static int memread_show(struct seq_file *s, void *data)
 	else
 		seq_printf(s, "[0x%08x] = INVALID\n", mem_addr);
 
+	wil_mem_access_unlock(wil);
+
 	wil_pm_runtime_put(wil);
 
 	return 0;
@@ -626,10 +640,6 @@ static ssize_t wil_read_file_ioblob(struct file *file, char __user *user_buf,
 	size_t unaligned_bytes, aligned_count, ret;
 	int rc;
 
-	if (test_bit(wil_status_suspending, wil_blob->wil->status) ||
-	    test_bit(wil_status_suspended, wil_blob->wil->status))
-		return 0;
-
 	if (pos < 0)
 		return -EINVAL;
 
@@ -656,11 +666,19 @@ static ssize_t wil_read_file_ioblob(struct file *file, char __user *user_buf,
 		return rc;
 	}
 
+	rc = wil_mem_access_lock(wil);
+	if (rc) {
+		kfree(buf);
+		wil_pm_runtime_put(wil);
+		return rc;
+	}
+
 	wil_memcpy_fromio_32(buf, (const void __iomem *)
 			     wil_blob->blob.data + aligned_pos, aligned_count);
 
 	ret = copy_to_user(user_buf, buf + unaligned_bytes, count);
 
+	wil_mem_access_unlock(wil);
 	wil_pm_runtime_put(wil);
 
 	kfree(buf);
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index bd933a0..2563076 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -139,6 +139,28 @@ void wil_memcpy_toio_32(volatile void __iomem *dst, const void *src,
 	}
 }
 
+/* Device memory access is prohibited while reset or suspend.
+ * wil_mem_access_lock protects accessing device memory in these cases
+ */
+int wil_mem_access_lock(struct wil6210_priv *wil)
+{
+	if (!down_read_trylock(&wil->mem_lock))
+		return -EBUSY;
+
+	if (test_bit(wil_status_suspending, wil->status) ||
+	    test_bit(wil_status_suspended, wil->status)) {
+		up_read(&wil->mem_lock);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+void wil_mem_access_unlock(struct wil6210_priv *wil)
+{
+	up_read(&wil->mem_lock);
+}
+
 static void wil_ring_fini_tx(struct wil6210_priv *wil, int id)
 {
 	struct wil_ring *ring = &wil->ring_tx[id];
@@ -678,6 +700,7 @@ int wil_priv_init(struct wil6210_priv *wil)
 	spin_lock_init(&wil->wmi_ev_lock);
 	spin_lock_init(&wil->net_queue_lock);
 	init_waitqueue_head(&wil->wq);
+	init_rwsem(&wil->mem_lock);
 
 	wil->wmi_wq = create_singlethread_workqueue(WIL_NAME "_wmi");
 	if (!wil->wmi_wq)
@@ -1577,15 +1600,6 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 	}
 
 	set_bit(wil_status_resetting, wil->status);
-	if (test_bit(wil_status_collecting_dumps, wil->status)) {
-		/* Device collects crash dump, cancel the reset.
-		 * following crash dump collection, reset would take place.
-		 */
-		wil_dbg_misc(wil, "reject reset while collecting crash dump\n");
-		rc = -EBUSY;
-		goto out;
-	}
-
 	mutex_lock(&wil->vif_mutex);
 	wil_abort_scan_all_vifs(wil, false);
 	mutex_unlock(&wil->vif_mutex);
@@ -1760,7 +1774,9 @@ int __wil_up(struct wil6210_priv *wil)
 
 	WARN_ON(!mutex_is_locked(&wil->mutex));
 
+	down_write(&wil->mem_lock);
 	rc = wil_reset(wil, true);
+	up_write(&wil->mem_lock);
 	if (rc)
 		return rc;
 
@@ -1834,6 +1850,7 @@ int wil_up(struct wil6210_priv *wil)
 
 int __wil_down(struct wil6210_priv *wil)
 {
+	int rc;
 	WARN_ON(!mutex_is_locked(&wil->mutex));
 
 	set_bit(wil_status_resetting, wil->status);
@@ -1853,7 +1870,11 @@ int __wil_down(struct wil6210_priv *wil)
 	wil_abort_scan_all_vifs(wil, false);
 	mutex_unlock(&wil->vif_mutex);
 
-	return wil_reset(wil, false);
+	down_write(&wil->mem_lock);
+	rc = wil_reset(wil, false);
+	up_write(&wil->mem_lock);
+
+	return rc;
 }
 
 int wil_down(struct wil6210_priv *wil)
diff --git a/drivers/net/wireless/ath/wil6210/pm.c b/drivers/net/wireless/ath/wil6210/pm.c
index 9c59bc5..2f74ff9 100644
--- a/drivers/net/wireless/ath/wil6210/pm.c
+++ b/drivers/net/wireless/ath/wil6210/pm.c
@@ -195,14 +195,18 @@ static int wil_suspend_keep_radio_on(struct wil6210_priv *wil)
 	wil_dbg_pm(wil, "suspend keep radio on\n");
 
 	/* Prevent handling of new tx and wmi commands */
-	set_bit(wil_status_suspending, wil->status);
-	if (test_bit(wil_status_collecting_dumps, wil->status)) {
-		/* Device collects crash dump, cancel the suspend */
-		wil_dbg_pm(wil, "reject suspend while collecting crash dump\n");
-		clear_bit(wil_status_suspending, wil->status);
+	rc = down_write_trylock(&wil->mem_lock);
+	if (!rc) {
+		wil_err(wil,
+			"device is busy. down_write_trylock failed, returned (0x%x)\n",
+			rc);
 		wil->suspend_stats.rejected_by_host++;
 		return -EBUSY;
 	}
+
+	set_bit(wil_status_suspending, wil->status);
+	up_write(&wil->mem_lock);
+
 	wil_pm_stop_all_net_queues(wil);
 
 	if (!wil_is_tx_idle(wil)) {
@@ -310,15 +314,18 @@ static int wil_suspend_radio_off(struct wil6210_priv *wil)
 
 	wil_dbg_pm(wil, "suspend radio off\n");
 
-	set_bit(wil_status_suspending, wil->status);
-	if (test_bit(wil_status_collecting_dumps, wil->status)) {
-		/* Device collects crash dump, cancel the suspend */
-		wil_dbg_pm(wil, "reject suspend while collecting crash dump\n");
-		clear_bit(wil_status_suspending, wil->status);
+	rc = down_write_trylock(&wil->mem_lock);
+	if (!rc) {
+		wil_err(wil,
+			"device is busy. down_write_trylock failed, returned (0x%x)\n",
+			rc);
 		wil->suspend_stats.rejected_by_host++;
 		return -EBUSY;
 	}
 
+	set_bit(wil_status_suspending, wil->status);
+	up_write(&wil->mem_lock);
+
 	/* if netif up, hardware is alive, shut it down */
 	mutex_lock(&wil->vif_mutex);
 	active_ifaces = wil_has_active_ifaces(wil, true, false);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index de97c4e..c7ab6c6 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -646,7 +646,6 @@ enum { /* for wil6210_priv.status */
 	wil_status_suspending, /* suspend in progress */
 	wil_status_suspended, /* suspend completed, device is suspended */
 	wil_status_resuming, /* resume in progress */
-	wil_status_collecting_dumps, /* crashdump collection in progress */
 	wil_status_last /* keep last */
 };
 
@@ -979,6 +978,8 @@ struct wil6210_priv {
 	struct wil_txrx_ops txrx_ops;
 
 	struct mutex mutex; /* for wil6210_priv access in wil_{up|down} */
+	/* for synchronizing device memory access while reset or suspend */
+	struct rw_semaphore mem_lock;
 	/* statistics */
 	atomic_t isr_count_rx, isr_count_tx;
 	/* debugfs */
@@ -1176,6 +1177,8 @@ void wil_memcpy_fromio_32(void *dst, const volatile void __iomem *src,
 			  size_t count);
 void wil_memcpy_toio_32(volatile void __iomem *dst, const void *src,
 			size_t count);
+int wil_mem_access_lock(struct wil6210_priv *wil);
+void wil_mem_access_unlock(struct wil6210_priv *wil);
 
 struct wil6210_vif *
 wil_vif_alloc(struct wil6210_priv *wil, const char *name,
diff --git a/drivers/net/wireless/ath/wil6210/wil_crash_dump.c b/drivers/net/wireless/ath/wil6210/wil_crash_dump.c
index dc33a0b..772cb00 100644
--- a/drivers/net/wireless/ath/wil6210/wil_crash_dump.c
+++ b/drivers/net/wireless/ath/wil6210/wil_crash_dump.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2015,2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -57,7 +57,7 @@ static int wil_fw_get_crash_dump_bounds(struct wil6210_priv *wil,
 
 int wil_fw_copy_crash_dump(struct wil6210_priv *wil, void *dest, u32 size)
 {
-	int i;
+	int i, rc;
 	const struct fw_map *map;
 	void *data;
 	u32 host_min, dump_size, offset, len;
@@ -73,14 +73,9 @@ int wil_fw_copy_crash_dump(struct wil6210_priv *wil, void *dest, u32 size)
 		return -EINVAL;
 	}
 
-	set_bit(wil_status_collecting_dumps, wil->status);
-	if (test_bit(wil_status_suspending, wil->status) ||
-	    test_bit(wil_status_suspended, wil->status) ||
-	    test_bit(wil_status_resetting, wil->status)) {
-		wil_err(wil, "cannot collect fw dump during suspend/reset\n");
-		clear_bit(wil_status_collecting_dumps, wil->status);
-		return -EINVAL;
-	}
+	rc = wil_mem_access_lock(wil);
+	if (rc)
+		return rc;
 
 	/* copy to crash dump area */
 	for (i = 0; i < ARRAY_SIZE(fw_mapping); i++) {
@@ -100,8 +95,7 @@ int wil_fw_copy_crash_dump(struct wil6210_priv *wil, void *dest, u32 size)
 		wil_memcpy_fromio_32((void * __force)(dest + offset),
 				     (const void __iomem * __force)data, len);
 	}
-
-	clear_bit(wil_status_collecting_dumps, wil->status);
+	wil_mem_access_unlock(wil);
 
 	return 0;
 }
-- 
1.9.1

