Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55137 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab2ARDEV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 22:04:21 -0500
Date: Tue, 17 Jan 2012 21:04:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Move pr_fmt macros to a single location
Message-ID: <4f1636b2.D5g8MJEc04WZglzi%Larry.Finger@lwfinger.net> (sfid-20120118_040443_882117_913B2005)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Although the rtlwifi family of devices contains 11 copies of the pr_fmt
macro, the macro is not defined for all routines that need it. By moving
the macro to wifi.h, a single copy is available for all routines.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 base.c               |    2 --
 cam.c                |    2 --
 rtl8192c/fw_common.c |    2 --
 rtl8192cu/hw.c       |    2 --
 rtl8192cu/mac.c      |    2 --
 rtl8192de/sw.c       |    2 --
 rtl8192se/hw.c       |    2 --
 rtl8192se/phy.c      |    2 --
 rtl8192se/rf.c       |    2 --
 rtl8192se/sw.c       |    2 --
 usb.c                |    2 --
 wifi.h               |    2 ++
 12 files changed, 2 insertions(+), 22 deletions(-)
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/base.c
@@ -27,8 +27,6 @@
  *
  *****************************************************************************/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/ip.h>
 #include <linux/module.h>
 #include "wifi.h"
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/cam.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/cam.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/cam.c
@@ -27,8 +27,6 @@
  *
  *****************************************************************************/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/export.h>
 #include "wifi.h"
 #include "cam.h"
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -27,8 +27,6 @@
  *
  *****************************************************************************/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/firmware.h>
 #include <linux/export.h>
 #include "../wifi.h"
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -27,8 +27,6 @@
  *
  *****************************************************************************/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include "../wifi.h"
 #include "../efuse.h"
 #include "../base.h"
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -27,8 +27,6 @@
  *
 ****************************************************************************/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/module.h>
 
 #include "../wifi.h"
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
@@ -27,8 +27,6 @@
  *
  *****************************************************************************/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/vmalloc.h>
 #include <linux/module.h>
 
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -27,8 +27,6 @@
  *
  *****************************************************************************/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include "../wifi.h"
 #include "../efuse.h"
 #include "../base.h"
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
@@ -27,8 +27,6 @@
  *
  *****************************************************************************/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include "../wifi.h"
 #include "../pci.h"
 #include "../ps.h"
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
@@ -27,8 +27,6 @@
  *
  *****************************************************************************/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include "../wifi.h"
 #include "reg.h"
 #include "def.h"
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -27,8 +27,6 @@
  *
  *****************************************************************************/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/vmalloc.h>
 #include <linux/module.h>
 
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
@@ -25,8 +25,6 @@
  *
  *****************************************************************************/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/usb.h>
 #include <linux/export.h>
 #include "core.h"
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
@@ -172,6 +172,8 @@ enum hardware_type {
 	 _pdesc->rxmcs == DESC92_RATE5_5M ||		\
 	 _pdesc->rxmcs == DESC92_RATE11M)
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 enum scan_operation_backup_opt {
 	SCAN_OPT_BACKUP = 0,
 	SCAN_OPT_RESTORE,
