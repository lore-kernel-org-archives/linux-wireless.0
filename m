Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59047 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330Ab2HFWfE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 18:35:04 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat-wireless: remove usage of dismantle in net_device
Date: Tue,  7 Aug 2012 00:34:46 +0200
Message-Id: <1344292486-25736-3-git-send-email-hauke@hauke-m.de> (sfid-20120807_003508_392046_5BAE6E4E)
In-Reply-To: <1344292486-25736-1-git-send-email-hauke@hauke-m.de>
References: <1344292486-25736-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patch makes use of the dismantle member in struct
net_device, this patch removes that access on older kernels.

commit 9d5d496c3464b7ad0ba942b4ada5f27c07e07079
Author: Daniel Drake <dsd@laptop.org>
Date:   Mon Jul 30 22:58:04 2012 +0100

    libertas: don't reset card on error when it is being removed

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/65-ignore-dismantle.patch |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 patches/65-ignore-dismantle.patch

diff --git a/patches/65-ignore-dismantle.patch b/patches/65-ignore-dismantle.patch
new file mode 100644
index 0000000..fde4ce2
--- /dev/null
+++ b/patches/65-ignore-dismantle.patch
@@ -0,0 +1,23 @@
+The following patch makes use of the dismantle member in struct 
+net_device, this patch removes that access on older kernels.
+
+commit 9d5d496c3464b7ad0ba942b4ada5f27c07e07079
+Author: Daniel Drake <dsd@laptop.org>
+Date:   Mon Jul 30 22:58:04 2012 +0100
+
+    libertas: don't reset card on error when it is being removed
+
+--- a/drivers/net/wireless/libertas/main.c
++++ b/drivers/net/wireless/libertas/main.c
+@@ -592,7 +592,11 @@ static int lbs_thread(void *data)
+ 
+ 			/* Reset card, but only when it isn't in the process
+ 			 * of being shutdown anyway. */
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,0,0))
+ 			if (!dev->dismantle && priv->reset_card)
++#else
++			if (priv->reset_card)
++#endif
+ 				priv->reset_card(priv);
+ 		}
+ 		priv->cmd_timed_out = 0;
-- 
1.7.9.5

