Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53768 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab2BOVqq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 16:46:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] compat-wireless: remove olpc_ec_wakeup_* calls for pre-3.1 kernels
Date: Wed, 15 Feb 2012 16:37:52 -0500
Message-Id: <1329341872-12872-1-git-send-email-linville@tuxdriver.com> (sfid-20120215_224650_877862_383EA8EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This section of the libertas driver calls functions that simply don't
exist before the release of 3.1.  This code in question was an addition,
not a change from any existing code.  It is safe to simply remove it for
older kernels.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 patches/50-libertas-olpc-ec-wakeup.patch |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)
 create mode 100644 patches/50-libertas-olpc-ec-wakeup.patch

diff --git a/patches/50-libertas-olpc-ec-wakeup.patch b/patches/50-libertas-olpc-ec-wakeup.patch
new file mode 100644
index 0000000..13413af
--- /dev/null
+++ b/patches/50-libertas-olpc-ec-wakeup.patch
@@ -0,0 +1,25 @@
+This section of the libertas driver calls functions that simply don't
+exist before the release of 3.1.  This code in question was an addition,
+not a change from any existing code.  It is safe to simply remove it for
+older kernels.
+
+diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
+index b5fbbc7..513ae29 100644
+--- a/drivers/net/wireless/libertas/if_usb.c
++++ b/drivers/net/wireless/libertas/if_usb.c
+@@ -1133,6 +1133,7 @@ static int if_usb_suspend(struct usb_interface *intf, pm_message_t message)
+ 	if (priv->psstate != PS_STATE_FULL_POWER)
+ 		return -1;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,1,0))
+ #ifdef CONFIG_OLPC
+ 	if (machine_is_olpc()) {
+ 		if (priv->wol_criteria == EHS_REMOVE_WAKEUP)
+@@ -1141,6 +1142,7 @@ static int if_usb_suspend(struct usb_interface *intf, pm_message_t message)
+ 			olpc_ec_wakeup_set(EC_SCI_SRC_WLAN);
+ 	}
+ #endif
++#endif
+ 
+ 	ret = lbs_suspend(priv);
+ 	if (ret)
-- 
1.7.4.4

