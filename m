Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41894 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab1KRU6c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 15:58:32 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] compat-wireless: avoid pr_fmt build SPAM
Date: Fri, 18 Nov 2011 15:54:33 -0500
Message-Id: <1321649673-15874-1-git-send-email-linville@tuxdriver.com> (sfid-20111118_215835_740990_2277842B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The way the compat-* header files are included causes the default
pr_fmt definition from <linux/kernel.h> to be evaluated for every file.
Files that define pr_fmt then generate a lot of build SPAM about
pr_fmt being redefined.

Eliminate the build noise by preemptively undefining pr_fmt in those
files that define it.  This is accomplished by adding a patch to the
patches directory.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 patches/44-pr_fmt.patch |  346 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 346 insertions(+), 0 deletions(-)
 create mode 100644 patches/44-pr_fmt.patch

diff --git a/patches/44-pr_fmt.patch b/patches/44-pr_fmt.patch
new file mode 100644
index 0000000..5c787da
--- /dev/null
+++ b/patches/44-pr_fmt.patch
@@ -0,0 +1,346 @@
+The way the compat-* header files are included causes the default
+pr_fmt definition from <linux/kernel.h> to be evaluated for every file.
+Files that define pr_fmt then generate a lot of build SPAM about
+pr_fmt being redefined.
+
+Eliminate the build noise by preemptively undefining pr_fmt in those
+files that define it.
+
+diff -up compat-wireless-3.2-rc1-1/compat/crc8.c.pr_fmt compat-wireless-3.2-rc1-1/compat/crc8.c
+--- compat-wireless-3.2-rc1-1/compat/crc8.c.pr_fmt	2011-11-18 15:08:04.497812086 -0500
++++ compat-wireless-3.2-rc1-1/compat/crc8.c	2011-11-18 15:20:09.450522691 -0500
+@@ -14,6 +14,7 @@
+  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/module.h>
+diff -up compat-wireless-3.2-rc1-1/drivers/bcma/bcma_private.h.pr_fmt compat-wireless-3.2-rc1-1/drivers/bcma/bcma_private.h
+--- compat-wireless-3.2-rc1-1/drivers/bcma/bcma_private.h.pr_fmt	2011-11-18 15:08:04.522323679 -0500
++++ compat-wireless-3.2-rc1-1/drivers/bcma/bcma_private.h	2011-11-18 15:20:09.451522757 -0500
+@@ -1,6 +1,7 @@
+ #ifndef LINUX_BCMA_PRIVATE_H_
+ #define LINUX_BCMA_PRIVATE_H_
+ 
++#undef pr_fmt
+ #ifndef pr_fmt
+ #define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
+ #endif
+diff -up compat-wireless-3.2-rc1-1/drivers/net/ethernet/broadcom/b44.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/ethernet/broadcom/b44.c
+--- compat-wireless-3.2-rc1-1/drivers/net/ethernet/broadcom/b44.c.pr_fmt	2011-11-18 15:08:04.529757401 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/ethernet/broadcom/b44.c	2011-11-18 15:20:09.453522618 -0500
+@@ -10,6 +10,7 @@
+  * Distribute under GPL.
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/kernel.h>
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/iwlegacy/iwl3945-base.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/iwlegacy/iwl3945-base.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/iwlegacy/iwl3945-base.c.pr_fmt	2011-11-18 15:08:04.531811389 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/iwlegacy/iwl3945-base.c	2011-11-18 15:20:09.455522411 -0500
+@@ -27,6 +27,7 @@
+  *
+  *****************************************************************************/
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/kernel.h>
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/iwlegacy/iwl4965-base.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/iwlegacy/iwl4965-base.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/iwlegacy/iwl4965-base.c.pr_fmt	2011-11-18 15:08:04.533811528 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/iwlegacy/iwl4965-base.c	2011-11-18 15:20:09.456520247 -0500
+@@ -27,6 +27,7 @@
+  *
+  *****************************************************************************/
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/kernel.h>
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/cfg.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/cfg.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/cfg.c.pr_fmt	2011-11-18 15:08:04.534811319 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/cfg.c	2011-11-18 15:20:09.456520247 -0500
+@@ -6,6 +6,7 @@
+  *
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/hardirq.h>
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/if_cs.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/if_cs.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/if_cs.c.pr_fmt	2011-11-18 15:08:04.534811319 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/if_cs.c	2011-11-18 15:20:09.457520945 -0500
+@@ -21,6 +21,7 @@
+ 
+ */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/module.h>
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/if_sdio.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/if_sdio.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/if_sdio.c.pr_fmt	2011-11-18 15:08:04.535829198 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/if_sdio.c	2011-11-18 15:20:09.457520945 -0500
+@@ -26,6 +26,7 @@
+  * if_sdio_card_to_host() to pad the data.
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/kernel.h>
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/if_spi.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/if_spi.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/if_spi.c.pr_fmt	2011-11-18 15:08:04.536811878 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/if_spi.c	2011-11-18 15:20:09.457520945 -0500
+@@ -17,6 +17,7 @@
+  * (at your option) any later version.
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/hardirq.h>
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/if_usb.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/if_usb.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/if_usb.c.pr_fmt	2011-11-18 15:08:04.536811878 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/if_usb.c	2011-11-18 15:20:09.458521084 -0500
+@@ -2,6 +2,7 @@
+  * This file contains functions used in USB interface module.
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/delay.h>
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/main.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/main.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/main.c.pr_fmt	2011-11-18 15:08:04.537812436 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/main.c	2011-11-18 15:20:09.458521084 -0500
+@@ -4,6 +4,7 @@
+  * thread etc..
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/module.h>
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/mesh.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/mesh.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/mesh.c.pr_fmt	2011-11-18 15:08:04.537812436 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/mesh.c	2011-11-18 15:20:09.458521084 -0500
+@@ -1,3 +1,4 @@
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/delay.h>
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/rx.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/rx.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/rx.c.pr_fmt	2011-11-18 15:08:04.538812017 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas/rx.c	2011-11-18 15:20:09.459520455 -0500
+@@ -2,6 +2,7 @@
+  * This file contains the handling of RX in wlan driver.
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/etherdevice.h>
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas_tf/cmd.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas_tf/cmd.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas_tf/cmd.c.pr_fmt	2011-11-18 15:08:04.544819700 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas_tf/cmd.c	2011-11-18 15:20:09.459520455 -0500
+@@ -7,6 +7,7 @@
+  *  the Free Software Foundation; either version 2 of the License, or (at
+  *  your option) any later version.
+  */
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/hardirq.h>
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas_tf/if_usb.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas_tf/if_usb.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas_tf/if_usb.c.pr_fmt	2011-11-18 15:08:04.545747064 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas_tf/if_usb.c	2011-11-18 15:20:09.459520455 -0500
+@@ -9,6 +9,7 @@
+  */
+ #define DRV_NAME "lbtf_usb"
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include "libertas_tf.h"
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas_tf/main.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas_tf/main.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas_tf/main.c.pr_fmt	2011-11-18 15:08:04.545747064 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/libertas_tf/main.c	2011-11-18 15:20:09.459520455 -0500
+@@ -7,6 +7,7 @@
+  *  the Free Software Foundation; either version 2 of the License, or (at
+  *  your option) any later version.
+  */
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/hardirq.h>
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/base.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/base.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/base.c.pr_fmt	2011-11-18 15:08:04.565011903 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/base.c	2011-11-18 15:20:55.315644844 -0500
+@@ -27,6 +27,7 @@
+  *
+  *****************************************************************************/
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/ip.h>
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/cam.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/cam.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/cam.c.pr_fmt	2011-11-18 15:08:04.565812364 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/cam.c	2011-11-18 15:20:55.322652946 -0500
+@@ -27,6 +27,7 @@
+  *
+  *****************************************************************************/
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/export.h>
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c.pr_fmt	2011-11-18 15:08:04.565812364 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c	2011-11-18 15:20:55.334647078 -0500
+@@ -27,6 +27,7 @@
+  *
+  *****************************************************************************/
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/firmware.h>
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c.pr_fmt	2011-11-18 15:08:04.567811877 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c	2011-11-18 15:20:55.341625637 -0500
+@@ -27,6 +27,7 @@
+  *
+  *****************************************************************************/
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include "../wifi.h"
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c.pr_fmt	2011-11-18 15:08:04.567811877 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c	2011-11-18 15:20:55.342644635 -0500
+@@ -27,6 +27,7 @@
+  *
+ ****************************************************************************/
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/module.h>
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192de/sw.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192de/sw.c.pr_fmt	2011-11-18 15:08:04.568814042 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192de/sw.c	2011-11-18 15:20:55.350617325 -0500
+@@ -27,6 +27,7 @@
+  *
+  *****************************************************************************/
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/vmalloc.h>
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192se/hw.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192se/hw.c.pr_fmt	2011-11-18 15:08:04.569828848 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192se/hw.c	2011-11-18 15:20:55.358645682 -0500
+@@ -27,6 +27,7 @@
+  *
+  *****************************************************************************/
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include "../wifi.h"
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192se/phy.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192se/phy.c.pr_fmt	2011-11-18 15:08:04.570818023 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192se/phy.c	2011-11-18 15:20:55.365635904 -0500
+@@ -27,6 +27,7 @@
+  *
+  *****************************************************************************/
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include "../wifi.h"
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192se/rf.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192se/rf.c.pr_fmt	2011-11-18 15:08:04.571812156 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192se/rf.c	2011-11-18 15:20:55.371549230 -0500
+@@ -27,6 +27,7 @@
+  *
+  *****************************************************************************/
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include "../wifi.h"
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192se/sw.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192se/sw.c.pr_fmt	2011-11-18 15:08:04.571812156 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/rtl8192se/sw.c	2011-11-18 15:20:55.379720621 -0500
+@@ -27,6 +27,7 @@
+  *
+  *****************************************************************************/
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/vmalloc.h>
+diff -up compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/usb.c.pr_fmt compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/usb.c
+--- compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/usb.c.pr_fmt	2011-11-18 15:08:04.572718638 -0500
++++ compat-wireless-3.2-rc1-1/drivers/net/wireless/rtlwifi/usb.c	2011-11-18 15:20:55.389173129 -0500
+@@ -25,6 +25,7 @@
+  *
+  *****************************************************************************/
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/usb.h>
+diff -up compat-wireless-3.2-rc1-1/net/wireless/core.c.pr_fmt compat-wireless-3.2-rc1-1/net/wireless/core.c
+--- compat-wireless-3.2-rc1-1/net/wireless/core.c.pr_fmt	2011-11-18 15:08:04.573774302 -0500
++++ compat-wireless-3.2-rc1-1/net/wireless/core.c	2011-11-18 15:20:55.395647078 -0500
+@@ -4,6 +4,7 @@
+  * Copyright 2006-2010		Johannes Berg <johannes@sipsolutions.net>
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/if.h>
+diff -up compat-wireless-3.2-rc1-1/net/wireless/lib80211.c.pr_fmt compat-wireless-3.2-rc1-1/net/wireless/lib80211.c
+--- compat-wireless-3.2-rc1-1/net/wireless/lib80211.c.pr_fmt	2011-11-18 15:08:04.573774302 -0500
++++ compat-wireless-3.2-rc1-1/net/wireless/lib80211.c	2011-11-18 15:20:55.405646450 -0500
+@@ -13,6 +13,7 @@
+  *
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/module.h>
+diff -up compat-wireless-3.2-rc1-1/net/wireless/lib80211_crypt_tkip.c.pr_fmt compat-wireless-3.2-rc1-1/net/wireless/lib80211_crypt_tkip.c
+--- compat-wireless-3.2-rc1-1/net/wireless/lib80211_crypt_tkip.c.pr_fmt	2011-11-18 15:08:04.574811667 -0500
++++ compat-wireless-3.2-rc1-1/net/wireless/lib80211_crypt_tkip.c	2011-11-18 15:20:55.406648475 -0500
+@@ -10,6 +10,7 @@
+  * more details.
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/err.h>
+diff -up compat-wireless-3.2-rc1-1/net/wireless/reg.c.pr_fmt compat-wireless-3.2-rc1-1/net/wireless/reg.c
+--- compat-wireless-3.2-rc1-1/net/wireless/reg.c.pr_fmt	2011-11-18 15:08:04.575716473 -0500
++++ compat-wireless-3.2-rc1-1/net/wireless/reg.c	2011-11-18 15:20:55.408647986 -0500
+@@ -33,6 +33,7 @@
+  *
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/kernel.h>
-- 
1.7.4.4

