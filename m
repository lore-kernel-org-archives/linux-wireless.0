Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51046 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756402Ab0JGVVZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 17:21:25 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat-wireless: backport kfifo for rt2x00
Date: Thu,  7 Oct 2010 23:21:09 +0200
Message-Id: <1286486469-18904-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1286486469-18904-1-git-send-email-hauke@hauke-m.de>
References: <1286486469-18904-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/19-kfifo.patch |   36 ++++++++++++++++++++++++++++--------
 1 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/patches/19-kfifo.patch b/patches/19-kfifo.patch
index 2a97ca0..1d04304 100644
--- a/patches/19-kfifo.patch
+++ b/patches/19-kfifo.patch
@@ -32,16 +32,36 @@ not be backported easily with defines in the compat module.
  		lbs_pr_err("Out of memory allocating event FIFO buffer\n");
  		goto out;
  	}
-@@ -763,7 +769,12 @@ static void lbs_free_adapter(struct lbs_
- 	lbs_deb_enter(LBS_DEB_MAIN);
+--- a/drivers/net/wireless/rt2x00/rt2x00.h
++++ b/drivers/net/wireless/rt2x00/rt2x00.h
+@@ -896,7 +896,11 @@ struct rt2x00_dev {
+ 	/*
+ 	 * FIFO for storing tx status reports between isr and tasklet.
+ 	 */
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33))
+ 	struct kfifo txstatus_fifo;
++#else
++	struct kfifo *txstatus_fifo;
++#endif
  
- 	lbs_free_cmd_buffer(priv);
+ 	/*
+ 	 * Tasklet for processing tx status reports (rt2800pci).
+--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
++++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
+@@ -824,10 +824,16 @@ static int rt2x00lib_probe_hw(struct rt2
+ 		 * queues gets reported before we've got a chance to handle
+ 		 * them) 24*4=384 tx status reports need to be cached.
+ 		 */
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33))
- 	kfifo_free(&priv->event_fifo);
+ 		status = kfifo_alloc(&rt2x00dev->txstatus_fifo, 512,
+ 				     GFP_KERNEL);
+ 		if (status)
+ 			return status;
 +#else
-+	if (priv->event_fifo)
-+		kfifo_free(priv->event_fifo);
++		rt2x00dev->txstatus_fifo = kfifo_alloc(512, GFP_KERNEL, NULL);
++		if (IS_ERR(rt2x00dev->txstatus_fifo))
++			return PTR_ERR(rt2x00dev->txstatus_fifo);
 +#endif
- 	del_timer(&priv->command_timer);
- 	del_timer(&priv->auto_deepsleep_timer);
  
+ 		/* tasklet for processing the tx status reports. */
+ 		tasklet_init(&rt2x00dev->txstatus_tasklet,
-- 
1.7.0.4

