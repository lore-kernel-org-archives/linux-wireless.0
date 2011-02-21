Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55240 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab1BUWcc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 17:32:32 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat: backport usb_pipe_endpoint()
Date: Mon, 21 Feb 2011 23:32:22 +0100
Message-Id: <1298327544-18943-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.35.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.35.h b/include/linux/compat-2.6.35.h
index c4de169..857a521 100644
--- a/include/linux/compat-2.6.35.h
+++ b/include/linux/compat-2.6.35.h
@@ -7,6 +7,7 @@
 #include <linux/etherdevice.h>
 #include <net/sock.h>
 #include <linux/types.h>
+#include <linux/usb.h>
 
 /* added on linux/kernel.h */
 #define USHRT_MAX      ((u16)(~0U))
@@ -31,6 +32,14 @@ extern loff_t noop_llseek(struct file *file, loff_t offset, int origin);
 
 #define pm_qos_request(_qos) pm_qos_requirement(_qos)
 
+static inline struct usb_host_endpoint *
+usb_pipe_endpoint(struct usb_device *dev, unsigned int pipe)
+{
+	struct usb_host_endpoint **eps;
+	eps = usb_pipein(pipe) ? dev->ep_in : dev->ep_out;
+	return eps[usb_pipeendpoint(pipe)];
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)) */
 
 #endif /* LINUX_26_35_COMPAT_H */
-- 
1.7.1

