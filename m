Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35024 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbZLZVqJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Dec 2009 16:46:09 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: backport kfifo for libertas
Date: Sat, 26 Dec 2009 22:45:59 +0100
Message-Id: <1261863960-2789-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First part of the kfifo backport.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/19-kfifo.patch |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)
 create mode 100644 patches/19-kfifo.patch

diff --git a/patches/19-kfifo.patch b/patches/19-kfifo.patch
new file mode 100644
index 0000000..d59f76e
--- /dev/null
+++ b/patches/19-kfifo.patch
@@ -0,0 +1,47 @@
+These parts of the new generic kernel FIFO implementation (kfifo) can
+not be backported easily with defines in the compat module.
+
+--- a/drivers/net/wireless/libertas/dev.h
++++ b/drivers/net/wireless/libertas/dev.h
+@@ -119,7 +119,11 @@ struct lbs_private {
+ 	u32 resp_len[2];
+ 
+ 	/* Events sent from hardware to driver */
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33))
+ 	struct kfifo event_fifo;
++#else
++	struct kfifo *event_fifo;
++#endif
+ 
+ 	/** thread to service interrupts */
+ 	struct task_struct *main_thread;
+--- a/drivers/net/wireless/libertas/main.c
++++ b/drivers/net/wireless/libertas/main.c
+@@ -872,8 +872,14 @@ static int lbs_init_adapter(struct lbs_private *priv)
+ 	priv->resp_len[0] = priv->resp_len[1] = 0;
+ 
+ 	/* Create the event FIFO */
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33))
+ 	ret = kfifo_alloc(&priv->event_fifo, sizeof(u32) * 16, GFP_KERNEL);
+ 	if (ret) {
++#else
++	priv->event_fifo = kfifo_alloc(sizeof(u32) * 16, GFP_KERNEL, NULL);
++	if (IS_ERR(priv->event_fifo)) {
++		ret = -ENOMEM;
++#endif
+ 		lbs_pr_err("Out of memory allocating event FIFO buffer\n");
+ 		goto out;
+ 	}
+@@ -889,7 +895,12 @@ static void lbs_free_adapter(struct lbs_private *priv)
+ 	lbs_deb_enter(LBS_DEB_MAIN);
+ 
+ 	lbs_free_cmd_buffer(priv);
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33))
+ 	kfifo_free(&priv->event_fifo);
++#else
++	if (priv->event_fifo)
++		kfifo_free(priv->event_fifo);
++#endif
+ 	del_timer(&priv->command_timer);
+ 	del_timer(&priv->auto_deepsleep_timer);
+ 	kfree(priv->networks);
-- 
1.6.3.3

