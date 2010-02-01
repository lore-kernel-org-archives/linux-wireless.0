Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34882 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942Ab0BAWdN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 17:33:13 -0500
From: y@hauke-m.de
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat-wireless-stable-2.6.33.y: Activate libertas
Date: Mon,  1 Feb 2010 23:25:32 +0100
Message-Id: <1265063133-29682-2-git-send-email-y>
In-Reply-To: <1265063133-29682-1-git-send-email-y>
References: <1265063133-29682-1-git-send-email-y>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hauke Mehrtens <hauke@hauke-m.de>

This is a backport of compat-wireless commit 67228098e77852a0cf50c7c6c413fa601bd6f5b1 and 79cfcf76ef0f275146f0cd0a9ad55134310fdfb3

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/19-kfifo.patch            |   47 +++++++++++++++++++++++++++++++++++++
 patches/99-change-makefiles.patch |    9 ++----
 2 files changed, 50 insertions(+), 6 deletions(-)
 create mode 100644 patches/19-kfifo.patch

diff --git a/patches/19-kfifo.patch b/patches/19-kfifo.patch
new file mode 100644
index 0000000..341ef09
--- /dev/null
+++ b/patches/19-kfifo.patch
@@ -0,0 +1,47 @@
+These parts of the new generic kernel FIFO implementation (kfifo) can
+not be backported easily with defines in the compat module.
+
+--- a/drivers/net/wireless/libertas/dev.h
++++ b/drivers/net/wireless/libertas/dev.h
+@@ -120,7 +120,11 @@ struct lbs_private {
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
+@@ -886,8 +886,14 @@ static int lbs_init_adapter(struct lbs_p
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
+@@ -903,7 +909,12 @@ static void lbs_free_adapter(struct lbs_
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
diff --git a/patches/99-change-makefiles.patch b/patches/99-change-makefiles.patch
index ea19a86..2de20be 100644
--- a/patches/99-change-makefiles.patch
+++ b/patches/99-change-makefiles.patch
@@ -40,7 +40,7 @@ only the wireless stuff.
  
 --- a/drivers/net/wireless/Makefile
 +++ b/drivers/net/wireless/Makefile
-@@ -5,36 +5,16 @@
+@@ -5,33 +5,16 @@
  obj-$(CONFIG_IPW2100) += ipw2x00/
  obj-$(CONFIG_IPW2200) += ipw2x00/
  
@@ -71,12 +71,9 @@ only the wireless stuff.
  obj-$(CONFIG_USB_NET_RNDIS_WLAN)	+= rndis_wlan.o
  
 -obj-$(CONFIG_USB_ZD1201)	+= zd1201.o
--obj-$(CONFIG_LIBERTAS)		+= libertas/
--
--obj-$(CONFIG_LIBERTAS_THINFIRM)	+= libertas_tf/
- 
- obj-$(CONFIG_ADM8211)	+= adm8211.o
+ obj-$(CONFIG_LIBERTAS)		+= libertas/
  
+ obj-$(CONFIG_LIBERTAS_THINFIRM)	+= libertas_tf/
 --- a/net/wireless/Makefile
 +++ b/net/wireless/Makefile
 @@ -4,11 +4,6 @@ obj-$(CONFIG_LIB80211_CRYPT_WEP) += lib8
-- 
1.6.3.3

