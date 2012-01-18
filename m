Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43629 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab2ARRc1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 12:32:27 -0500
Date: Wed, 18 Jan 2012 11:32:23 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH V3] rtlwifi: Move pr_fmt macros to a single location
Message-ID: <4f170227.PQaRuvPTfxbtfbJ4%Larry.Finger@lwfinger.net> (sfid-20120118_183230_779460_45EBF7E7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Although the rtlwifi family of devices contains 11 copies of the pr_fmt
macro, the macro is not defined for all routines that need it. By moving
the macro to wifi.h, a single copy is available for all routines.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

V2 - reordered includes so that wifi.h is called first. This change
     avoids redefinition warnings.
V3 - remove duplicated includes.
---

 base.c               |    7 +++----
 cam.c                |    2 --
 core.h               |    2 --
 debug.c              |    4 ++--
 pci.c                |    4 ++--
 rtl8192c/fw_common.c |    5 +----
 rtl8192c/main.c      |    2 +-
 rtl8192ce/sw.c       |    5 ++---
 rtl8192cu/hw.c       |    2 --
 rtl8192cu/mac.c      |    6 ++----
 rtl8192cu/sw.c       |    1 -
 rtl8192de/sw.c       |    7 ++-----
 rtl8192se/hw.c       |    2 --
 rtl8192se/phy.c      |    2 --
 rtl8192se/rf.c       |    2 --
 rtl8192se/sw.c       |    7 ++-----
 usb.c                |    7 ++-----
 usb.h                |    1 -
 wifi.h               |    2 ++
 19 files changed, 21 insertions(+), 49 deletions(-)
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/base.c
@@ -27,10 +27,6 @@
  *
  *****************************************************************************/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/ip.h>
-#include <linux/module.h>
 #include "wifi.h"
 #include "rc.h"
 #include "base.h"
@@ -39,6 +35,9 @@
 #include "ps.h"
 #include "regd.h"
 
+#include <linux/ip.h>
+#include <linux/module.h>
+
 /*
  *NOTICE!!!: This file will be very big, we hsould
  *keep it clear under follwing roles:
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
@@ -27,16 +27,13 @@
  *
  *****************************************************************************/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/firmware.h>
-#include <linux/export.h>
 #include "../wifi.h"
 #include "../pci.h"
 #include "../base.h"
 #include "../rtl8192ce/reg.h"
 #include "../rtl8192ce/def.h"
 #include "fw_common.h"
+#include <linux/export.h>
 
 static void _rtl92c_enable_fw_download(struct ieee80211_hw *hw, bool enable)
 {
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
@@ -27,10 +27,6 @@
  *
 ****************************************************************************/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-
 #include "../wifi.h"
 #include "../pci.h"
 #include "../usb.h"
@@ -44,6 +40,8 @@
 #include "mac.h"
 #include "trx.h"
 
+#include <linux/module.h>
+
 /* macro to shorten lines */
 
 #define LINK_Q	ui_link_quality
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
@@ -27,11 +27,6 @@
  *
  *****************************************************************************/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/vmalloc.h>
-#include <linux/module.h>
-
 #include "../wifi.h"
 #include "../core.h"
 #include "../pci.h"
@@ -44,6 +39,8 @@
 #include "trx.h"
 #include "led.h"
 
+#include <linux/module.h>
+
 static void rtl92d_init_aspm_vars(struct ieee80211_hw *hw)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
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
@@ -27,11 +27,6 @@
  *
  *****************************************************************************/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/vmalloc.h>
-#include <linux/module.h>
-
 #include "../wifi.h"
 #include "../core.h"
 #include "../pci.h"
@@ -45,6 +40,8 @@
 #include "trx.h"
 #include "led.h"
 
+#include <linux/module.h>
+
 static void rtl92s_init_aspm_vars(struct ieee80211_hw *hw)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
@@ -25,16 +25,13 @@
  *
  *****************************************************************************/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/usb.h>
-#include <linux/export.h>
-#include "core.h"
 #include "wifi.h"
+#include "core.h"
 #include "usb.h"
 #include "base.h"
 #include "ps.h"
 #include "rtl8192c/fw_common.h"
+#include <linux/export.h>
 
 #define	REALTEK_USB_VENQT_READ			0xC0
 #define	REALTEK_USB_VENQT_WRITE			0x40
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
@@ -30,6 +30,8 @@
 #ifndef __RTL_WIFI_H__
 #define __RTL_WIFI_H__
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sched.h>
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/debug.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/debug.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/debug.c
@@ -26,10 +26,10 @@
  * Larry Finger <Larry.Finger@lwfinger.net>
  *****************************************************************************/
 
-#include <linux/moduleparam.h>
-
 #include "wifi.h"
 
+#include <linux/moduleparam.h>
+
 void rtl_dbgp_flag_init(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
@@ -27,13 +27,13 @@
  *
  *****************************************************************************/
 
-#include <linux/export.h>
-#include "core.h"
 #include "wifi.h"
+#include "core.h"
 #include "pci.h"
 #include "base.h"
 #include "ps.h"
 #include "efuse.h"
+#include <linux/export.h>
 
 static const u16 pcibridge_vendors[PCI_BRIDGE_VENDOR_MAX] = {
 	PCI_VENDOR_ID_INTEL,
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/main.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192c/main.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/main.c
@@ -27,8 +27,8 @@
  *
  *****************************************************************************/
 
-#include <linux/module.h>
 #include "../wifi.h"
+#include <linux/module.h>
 
 
 MODULE_AUTHOR("lizhaoming	<chaoming_li@realsil.com.cn>");
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -27,9 +27,6 @@
  *
  *****************************************************************************/
 
-#include <linux/vmalloc.h>
-#include <linux/module.h>
-
 #include "../wifi.h"
 #include "../core.h"
 #include "../pci.h"
@@ -43,6 +40,8 @@
 #include "trx.h"
 #include "led.h"
 
+#include <linux/module.h>
+
 static void rtl92c_init_aspm_vars(struct ieee80211_hw *hw)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/core.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/core.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/core.h
@@ -30,8 +30,6 @@
 #ifndef __RTL_CORE_H__
 #define __RTL_CORE_H__
 
-#include <net/mac80211.h>
-
 #define RTL_SUPPORTED_FILTERS		\
 	(FIF_PROMISC_IN_BSS | \
 	FIF_ALLMULTI | FIF_CONTROL | \
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -41,7 +41,6 @@
 #include "trx.h"
 #include "led.h"
 #include "hw.h"
-#include <linux/vmalloc.h>
 #include <linux/module.h>
 
 MODULE_AUTHOR("Georgia		<georgia@realtek.com>");
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/usb.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/usb.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/usb.h
@@ -28,7 +28,6 @@
 #ifndef __RTL_USB_H__
 #define __RTL_USB_H__
 
-#include <linux/usb.h>
 #include <linux/skbuff.h>
 
 #define RTL_RX_DESC_SIZE		24
