Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34173 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826Ab1AFRRA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 12:17:00 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: use backported kfifo
Date: Thu,  6 Jan 2011 18:16:52 +0100
Message-Id: <1294334212-20530-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1294334212-20530-1-git-send-email-hauke@hauke-m.de>
References: <1294334212-20530-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now compat contains a backport of the kfifo implementation and we do
not have to patch the driver to use the old interface.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk              |    4 +++
 patches/19-kfifo.patch |   53 ------------------------------------------------
 2 files changed, 4 insertions(+), 53 deletions(-)
 delete mode 100644 patches/19-kfifo.patch

diff --git a/config.mk b/config.mk
index 1f95908..7a29d46 100644
--- a/config.mk
+++ b/config.mk
@@ -107,6 +107,10 @@ ifdef CONFIG_FW_LOADER
 endif #CONFIG_FW_LOADER
 endif #CONFIG_COMPAT_KERNEL_33
 
+ifdef CONFIG_COMPAT_KERNEL_36
+CONFIG_COMPAT_KFIFO=m
+endif #CONFIG_COMPAT_KERNEL_36
+
 
 # Wireless subsystem stuff
 CONFIG_MAC80211=m
diff --git a/patches/19-kfifo.patch b/patches/19-kfifo.patch
deleted file mode 100644
index d9d25ee..0000000
--- a/patches/19-kfifo.patch
+++ /dev/null
@@ -1,53 +0,0 @@
-These parts of the new generic kernel FIFO implementation (kfifo) can
-not be backported easily with defines in the compat module.
-
---- a/drivers/net/wireless/libertas/dev.h
-+++ b/drivers/net/wireless/libertas/dev.h
-@@ -121,7 +121,11 @@ struct lbs_private {
- 	u32 resp_len[2];
- 
- 	/* Events sent from hardware to driver */
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33))
- 	struct kfifo event_fifo;
-+#else
-+	struct kfifo *event_fifo;
-+#endif
- 
- 	/** thread to service interrupts */
- 	struct task_struct *main_thread;
---- a/drivers/net/wireless/libertas/main.c
-+++ b/drivers/net/wireless/libertas/main.c
-@@ -753,8 +753,14 @@ static int lbs_init_adapter(struct lbs_p
- 	priv->resp_len[0] = priv->resp_len[1] = 0;
- 
- 	/* Create the event FIFO */
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33))
- 	ret = kfifo_alloc(&priv->event_fifo, sizeof(u32) * 16, GFP_KERNEL);
- 	if (ret) {
-+#else
-+	priv->event_fifo = kfifo_alloc(sizeof(u32) * 16, GFP_KERNEL, NULL);
-+	if (IS_ERR(priv->event_fifo)) {
-+		ret = -ENOMEM;
-+#endif
- 		lbs_pr_err("Out of memory allocating event FIFO buffer\n");
- 		goto out;
- 	}
---- a/drivers/net/wireless/rt2x00/rt2x00dev.c
-+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
-@@ -808,10 +808,16 @@ static int rt2x00lib_probe_hw(struct rt2
- 		 * queues gets reported before we've got a chance to handle
- 		 * them) 24*4=384 tx status reports need to be cached.
- 		 */
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33))
- 		status = kfifo_alloc(&rt2x00dev->txstatus_fifo, 512,
- 				     GFP_KERNEL);
- 		if (status)
- 			return status;
-+#else
-+		rt2x00dev->txstatus_fifo = kfifo_alloc(512, GFP_KERNEL, NULL);
-+		if (IS_ERR(rt2x00dev->txstatus_fifo))
-+			return PTR_ERR(rt2x00dev->txstatus_fifo);
-+#endif
- 
- 		/* tasklet for processing the tx status reports. */
- 		if (rt2x00dev->ops->lib->txstatus_tasklet)
-- 
1.7.1

