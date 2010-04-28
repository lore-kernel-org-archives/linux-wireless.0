Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54360 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab0D1UaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 16:30:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Steve deRosier <steve@cozybit.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas_tf: avoid warning about pr_fmt redefinition
Date: Wed, 28 Apr 2010 16:22:33 -0400
Message-Id: <1272486153-11982-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also includes a minor cleanup regarding quotation of a standard kernel
header file...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/libertas_tf/cmd.c         |    2 +-
 drivers/net/wireless/libertas_tf/deb_defs.h    |    2 --
 drivers/net/wireless/libertas_tf/if_usb.c      |    3 ++-
 drivers/net/wireless/libertas_tf/libertas_tf.h |    2 ++
 drivers/net/wireless/libertas_tf/main.c        |    4 ++--
 5 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/libertas_tf/cmd.c b/drivers/net/wireless/libertas_tf/cmd.c
index fba1e94..8945afd 100644
--- a/drivers/net/wireless/libertas_tf/cmd.c
+++ b/drivers/net/wireless/libertas_tf/cmd.c
@@ -7,7 +7,7 @@
  *  the Free Software Foundation; either version 2 of the License, or (at
  *  your option) any later version.
  */
-#include "deb_defs.h"
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/slab.h>
 
diff --git a/drivers/net/wireless/libertas_tf/deb_defs.h b/drivers/net/wireless/libertas_tf/deb_defs.h
index 9a3e92b..ae75396 100644
--- a/drivers/net/wireless/libertas_tf/deb_defs.h
+++ b/drivers/net/wireless/libertas_tf/deb_defs.h
@@ -9,8 +9,6 @@
 #define DRV_NAME "libertas_tf"
 #endif
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/spinlock.h>
 
 #ifdef CONFIG_LIBERTAS_THINFIRM_DEBUG
diff --git a/drivers/net/wireless/libertas_tf/if_usb.c b/drivers/net/wireless/libertas_tf/if_usb.c
index 125f54d..4412c27 100644
--- a/drivers/net/wireless/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/libertas_tf/if_usb.c
@@ -9,7 +9,8 @@
  */
 #define DRV_NAME "lbtf_usb"
 
-#include "deb_defs.h"
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "libertas_tf.h"
 #include "if_usb.h"
 
diff --git a/drivers/net/wireless/libertas_tf/libertas_tf.h b/drivers/net/wireless/libertas_tf/libertas_tf.h
index 4cc42dd..fbbaaae 100644
--- a/drivers/net/wireless/libertas_tf/libertas_tf.h
+++ b/drivers/net/wireless/libertas_tf/libertas_tf.h
@@ -13,6 +13,8 @@
 #include <linux/kthread.h>
 #include <net/mac80211.h>
 
+#include "deb_defs.h"
+
 #ifndef DRV_NAME
 #define DRV_NAME "libertas_tf"
 #endif
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 61d6a7b..bb46665 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -7,12 +7,12 @@
  *  the Free Software Foundation; either version 2 of the License, or (at
  *  your option) any later version.
  */
-#include "deb_defs.h"
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/slab.h>
+#include <linux/etherdevice.h>
 
 #include "libertas_tf.h"
-#include "linux/etherdevice.h"
 
 #define DRIVER_RELEASE_VERSION "004.p0"
 /* thinfirm version: 5.132.X.pX */
-- 
1.6.6.1

