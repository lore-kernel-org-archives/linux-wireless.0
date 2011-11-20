Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57200 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab1KTJjb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 04:39:31 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com
Subject: [PATCH] compat: fix misplaced #ifdef for the workqueue backport
Date: Sun, 20 Nov 2011 10:39:22 +0100
Message-Id: <1321781962-92285-1-git-send-email-nbd@openwrt.org> (sfid-20111120_103934_886579_57711A71)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 compat/compat-2.6.36.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/compat/compat-2.6.36.c b/compat/compat-2.6.36.c
index fe24da8..dfab2ea 100644
--- a/compat/compat-2.6.36.c
+++ b/compat/compat-2.6.36.c
@@ -93,6 +93,8 @@ void compat_usb_scuttle_anchored_urbs(struct usb_anchor *anchor)
 }
 EXPORT_SYMBOL_GPL(compat_usb_scuttle_anchored_urbs);
 
+#endif /* CONFIG_COMPAT_USB_URB_THREAD_FIX */
+
 struct workqueue_struct *system_nrt_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_nrt_wq);
 
@@ -106,6 +108,3 @@ void compat_system_workqueue_destroy()
 {
 	destroy_workqueue(system_nrt_wq);
 }
-
-#endif /* CONFIG_COMPAT_USB_URB_THREAD_FIX */
-
-- 
1.7.3.2

