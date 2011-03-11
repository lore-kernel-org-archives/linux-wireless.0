Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29983 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390Ab1CKC4o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:56:44 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:56:21 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 17/20] ath6kl: remove-typedef ATH_DEBUG_MASK_DESCRIPTION
Date: Thu, 10 Mar 2011 18:55:44 -0800
Message-ID: <1299812147-12069-18-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
References: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s ATH_DEBUG_MASK_DESCRIPTION \
	"struct ath_debug_mask_description" drivers/staging/ath6kl/

Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/bmi/src/bmi.c         |    2 +-
 drivers/staging/ath6kl/htc2/htc.c            |    2 +-
 drivers/staging/ath6kl/include/a_debug.h     |   10 +++++-----
 drivers/staging/ath6kl/miscdrv/common_drv.c  |    2 +-
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |    2 +-
 drivers/staging/ath6kl/os/linux/ar6000_pm.c  |    2 +-
 drivers/staging/ath6kl/wlan/src/wlan_node.c  |    2 +-
 drivers/staging/ath6kl/wmi/wmi.c             |    2 +-
 8 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/ath6kl/bmi/src/bmi.c b/drivers/staging/ath6kl/bmi/src/bmi.c
index 37f7cbc..a9615b7 100644
--- a/drivers/staging/ath6kl/bmi/src/bmi.c
+++ b/drivers/staging/ath6kl/bmi/src/bmi.c
@@ -33,7 +33,7 @@
 #include "bmi_internal.h"
 
 #ifdef ATH_DEBUG_MODULE
-static ATH_DEBUG_MASK_DESCRIPTION bmi_debug_desc[] = {
+static struct ath_debug_mask_description bmi_debug_desc[] = {
     { ATH_DEBUG_BMI , "BMI Tracing"},
 };
 
diff --git a/drivers/staging/ath6kl/htc2/htc.c b/drivers/staging/ath6kl/htc2/htc.c
index 8bde7bf..bb999b6 100644
--- a/drivers/staging/ath6kl/htc2/htc.c
+++ b/drivers/staging/ath6kl/htc2/htc.c
@@ -23,7 +23,7 @@
 #include "htc_internal.h"
 
 #ifdef ATH_DEBUG_MODULE
-static ATH_DEBUG_MASK_DESCRIPTION g_HTCDebugDescription[] = {
+static struct ath_debug_mask_description g_HTCDebugDescription[] = {
     { ATH_DEBUG_SEND , "Send"},
     { ATH_DEBUG_RECV , "Recv"},
     { ATH_DEBUG_SYNC , "Sync"},
diff --git a/drivers/staging/ath6kl/include/a_debug.h b/drivers/staging/ath6kl/include/a_debug.h
index 0e5430d..d433942 100644
--- a/drivers/staging/ath6kl/include/a_debug.h
+++ b/drivers/staging/ath6kl/include/a_debug.h
@@ -95,7 +95,7 @@ void DebugDumpBytes(u8 *buffer, u16 length, char *pDescription);
  *   #define ATH_DEBUG_BMI  ATH_DEBUG_MAKE_MODULE_MASK(0)
  *
  *   #ifdef DEBUG
- *   static ATH_DEBUG_MASK_DESCRIPTION bmi_debug_desc[] = {
+ *   static struct ath_debug_mask_description bmi_debug_desc[] = {
  *       { ATH_DEBUG_BMI , "BMI Tracing"},   <== description of the module specific mask
  *   };
  *
@@ -118,10 +118,10 @@ void DebugDumpBytes(u8 *buffer, u16 length, char *pDescription);
 #define ATH_DEBUG_MAX_MASK_DESC_LENGTH   32
 #define ATH_DEBUG_MAX_MOD_DESC_LENGTH    64
 
-typedef struct {
+struct ath_debug_mask_description {
     u32 Mask;
     char Description[ATH_DEBUG_MAX_MASK_DESC_LENGTH];
-} ATH_DEBUG_MASK_DESCRIPTION;
+};
 
 #define ATH_DEBUG_INFO_FLAGS_REGISTERED (1 << 0)
 
@@ -132,10 +132,10 @@ typedef struct  _ATH_DEBUG_MODULE_DBG_INFO{
     u32 Flags;
     u32 CurrentMask;
     int                         MaxDescriptions;
-    ATH_DEBUG_MASK_DESCRIPTION  *pMaskDescriptions; /* pointer to array of descriptions */
+    struct ath_debug_mask_description  *pMaskDescriptions; /* pointer to array of descriptions */
 } ATH_DEBUG_MODULE_DBG_INFO;
 
-#define ATH_DEBUG_DESCRIPTION_COUNT(d)  (int)((sizeof((d))) / (sizeof(ATH_DEBUG_MASK_DESCRIPTION)))
+#define ATH_DEBUG_DESCRIPTION_COUNT(d)  (int)((sizeof((d))) / (sizeof(struct ath_debug_mask_description)))
 
 #define GET_ATH_MODULE_DEBUG_VAR_NAME(s) _XGET_ATH_MODULE_NAME_DEBUG_(s)
 #define GET_ATH_MODULE_DEBUG_VAR_MASK(s) _XGET_ATH_MODULE_NAME_DEBUG_(s).CurrentMask
diff --git a/drivers/staging/ath6kl/miscdrv/common_drv.c b/drivers/staging/ath6kl/miscdrv/common_drv.c
index b5f74c5..3ada331 100644
--- a/drivers/staging/ath6kl/miscdrv/common_drv.c
+++ b/drivers/staging/ath6kl/miscdrv/common_drv.c
@@ -834,7 +834,7 @@ void DebugDumpBytes(u8 *buffer, u16 length, char *pDescription)
 void a_dump_module_debug_info(ATH_DEBUG_MODULE_DBG_INFO *pInfo)
 {
     int                         i;
-    ATH_DEBUG_MASK_DESCRIPTION *pDesc;
+    struct ath_debug_mask_description *pDesc;
 
     if (pInfo == NULL) {
         return;
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index e52a88a..811235a 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -60,7 +60,7 @@ u8 null_mac[] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0};
 #define  ATH_DEBUG_HTC_RAW       ATH_DEBUG_MAKE_MODULE_MASK(5)
 #define  ATH_DEBUG_HCI_BRIDGE    ATH_DEBUG_MAKE_MODULE_MASK(6)
 
-static ATH_DEBUG_MASK_DESCRIPTION driver_debug_desc[] = {
+static struct ath_debug_mask_description driver_debug_desc[] = {
     { ATH_DEBUG_DBG_LOG      , "Target Debug Logs"},
     { ATH_DEBUG_WLAN_CONNECT , "WLAN connect"},
     { ATH_DEBUG_WLAN_SCAN    , "WLAN scan"},
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_pm.c b/drivers/staging/ath6kl/os/linux/ar6000_pm.c
index 46342d8..5659ad8 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_pm.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_pm.c
@@ -44,7 +44,7 @@ extern void android_ar6k_check_wow_status(AR_SOFTC_T *ar, struct sk_buff *skb, b
 #define  ATH_DEBUG_PM       ATH_DEBUG_MAKE_MODULE_MASK(0)
 
 #ifdef DEBUG
-static ATH_DEBUG_MASK_DESCRIPTION pm_debug_desc[] = {
+static struct ath_debug_mask_description pm_debug_desc[] = {
     { ATH_DEBUG_PM     , "System power management"},
 };
 
diff --git a/drivers/staging/ath6kl/wlan/src/wlan_node.c b/drivers/staging/ath6kl/wlan/src/wlan_node.c
index 83c4dc3..1a3ac7d 100644
--- a/drivers/staging/ath6kl/wlan/src/wlan_node.c
+++ b/drivers/staging/ath6kl/wlan/src/wlan_node.c
@@ -40,7 +40,7 @@
 
 #ifdef ATH_DEBUG_MODULE
 
-static ATH_DEBUG_MASK_DESCRIPTION wlan_debug_desc[] = {
+static struct ath_debug_mask_description wlan_debug_desc[] = {
     { ATH_DEBUG_WLAN , "General WLAN Node Tracing"},
 };
 
diff --git a/drivers/staging/ath6kl/wmi/wmi.c b/drivers/staging/ath6kl/wmi/wmi.c
index 80ba629..0ddaee2 100644
--- a/drivers/staging/ath6kl/wmi/wmi.c
+++ b/drivers/staging/ath6kl/wmi/wmi.c
@@ -48,7 +48,7 @@
 
 #ifdef ATH_DEBUG_MODULE
 
-static ATH_DEBUG_MASK_DESCRIPTION wmi_debug_desc[] = {
+static struct ath_debug_mask_description wmi_debug_desc[] = {
     { ATH_DEBUG_WMI , "General WMI Tracing"},
 };
 
-- 
1.7.4.15.g7811d

