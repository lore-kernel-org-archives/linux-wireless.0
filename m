Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29942 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268Ab1CKC4H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:56:07 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:55:44 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 04/20] ath6kl: remove-typedef: A_UCHAR
Date: Thu, 10 Mar 2011 18:55:31 -0800
Message-ID: <1299812147-12069-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
References: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s A_UCHAR u8 drivers/staging/ath6kl/

This uses the remove-typedef utility:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/scripts/remove-typedef

Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/bmi/include/bmi_internal.h  |    4 +-
 drivers/staging/ath6kl/bmi/src/bmi.c               |   34 ++++----
 .../hif/sdio/linux_sdio/include/hif_internal.h     |    2 +-
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |    4 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          |    4 +-
 drivers/staging/ath6kl/htc2/htc_internal.h         |    2 +-
 drivers/staging/ath6kl/include/a_debug.h           |    2 +-
 drivers/staging/ath6kl/include/ar6000_diag.h       |    4 +-
 drivers/staging/ath6kl/include/bmi.h               |   12 ++--
 .../include/common/regulatory/reg_dbschema.h       |    2 +-
 drivers/staging/ath6kl/include/common/testcmd.h    |    2 +-
 drivers/staging/ath6kl/include/common/wmi.h        |    4 +-
 drivers/staging/ath6kl/include/common/wmi_thin.h   |    2 +-
 drivers/staging/ath6kl/include/common_drv.h        |    2 +-
 drivers/staging/ath6kl/include/hif.h               |    2 +-
 drivers/staging/ath6kl/include/wlan_api.h          |    4 +-
 drivers/staging/ath6kl/include/wmi_api.h           |   10 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c   |   34 ++++----
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h   |    4 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c   |   36 ++++----
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h   |   13 +---
 drivers/staging/ath6kl/miscdrv/common_drv.c        |   32 ++++----
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   82 ++++++++++----------
 drivers/staging/ath6kl/os/linux/eeprom.c           |    6 +-
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    2 +-
 .../ath6kl/os/linux/include/athtypes_linux.h       |    1 -
 drivers/staging/ath6kl/os/linux/ioctl.c            |    4 +-
 drivers/staging/ath6kl/wlan/src/wlan_node.c        |    8 +-
 drivers/staging/ath6kl/wmi/wmi.c                   |   16 ++--
 29 files changed, 163 insertions(+), 171 deletions(-)

diff --git a/drivers/staging/ath6kl/bmi/include/bmi_internal.h b/drivers/staging/ath6kl/bmi/include/bmi_internal.h
index ebc037d..e13fb01 100644
--- a/drivers/staging/ath6kl/bmi/include/bmi_internal.h
+++ b/drivers/staging/ath6kl/bmi/include/bmi_internal.h
@@ -43,12 +43,12 @@ static bool bmiDone;
 
 int
 bmiBufferSend(HIF_DEVICE *device,
-              A_UCHAR *buffer,
+              u8 *buffer,
               u32 length);
 
 int
 bmiBufferReceive(HIF_DEVICE *device,
-                 A_UCHAR *buffer,
+                 u8 *buffer,
                  u32 length,
                  bool want_timeout);
 
diff --git a/drivers/staging/ath6kl/bmi/src/bmi.c b/drivers/staging/ath6kl/bmi/src/bmi.c
index 1e1e6ee..37f7cbc 100644
--- a/drivers/staging/ath6kl/bmi/src/bmi.c
+++ b/drivers/staging/ath6kl/bmi/src/bmi.c
@@ -55,7 +55,7 @@ very simple.
 
 static bool pendingEventsFuncCheck = false;
 static u32 *pBMICmdCredits;
-static A_UCHAR *pBMICmdBuf;
+static u8 *pBMICmdBuf;
 #define MAX_BMI_CMDBUF_SZ (BMI_DATASZ_MAX + \
                        sizeof(u32) /* cmd */ + \
                        sizeof(u32) /* addr */ + \
@@ -84,7 +84,7 @@ BMIInit(void)
     }
 
     if (!pBMICmdBuf) {
-        pBMICmdBuf = (A_UCHAR *)A_MALLOC_NOWAIT(MAX_BMI_CMDBUF_SZ);
+        pBMICmdBuf = (u8 *)A_MALLOC_NOWAIT(MAX_BMI_CMDBUF_SZ);
         A_ASSERT(pBMICmdBuf);
     }
     
@@ -120,7 +120,7 @@ BMIDone(HIF_DEVICE *device)
     bmiDone = true;
     cid = BMI_DONE;
 
-    status = bmiBufferSend(device, (A_UCHAR *)&cid, sizeof(cid));
+    status = bmiBufferSend(device, (u8 *)&cid, sizeof(cid));
     if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to write to the device\n"));
         return A_ERROR;
@@ -155,13 +155,13 @@ BMIGetTargetInfo(HIF_DEVICE *device, struct bmi_target_info *targ_info)
     AR_DEBUG_PRINTF(ATH_DEBUG_BMI, ("BMI Get Target Info: Enter (device: 0x%p)\n", device));
     cid = BMI_GET_TARGET_INFO;
 
-    status = bmiBufferSend(device, (A_UCHAR *)&cid, sizeof(cid));
+    status = bmiBufferSend(device, (u8 *)&cid, sizeof(cid));
     if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to write to the device\n"));
         return A_ERROR;
     }
 
-    status = bmiBufferReceive(device, (A_UCHAR *)&targ_info->target_ver,
+    status = bmiBufferReceive(device, (u8 *)&targ_info->target_ver,
                                                 sizeof(targ_info->target_ver), true);
     if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to read Target Version from the device\n"));
@@ -170,7 +170,7 @@ BMIGetTargetInfo(HIF_DEVICE *device, struct bmi_target_info *targ_info)
 
     if (targ_info->target_ver == TARGET_VERSION_SENTINAL) {
         /* Determine how many bytes are in the Target's targ_info */
-        status = bmiBufferReceive(device, (A_UCHAR *)&targ_info->target_info_byte_count,
+        status = bmiBufferReceive(device, (u8 *)&targ_info->target_info_byte_count,
                                             sizeof(targ_info->target_info_byte_count), true);
         if (status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to read Target Info Byte Count from the device\n"));
@@ -185,7 +185,7 @@ BMIGetTargetInfo(HIF_DEVICE *device, struct bmi_target_info *targ_info)
 
         /* Read the remainder of the targ_info */
         status = bmiBufferReceive(device,
-                        ((A_UCHAR *)targ_info)+sizeof(targ_info->target_info_byte_count),
+                        ((u8 *)targ_info)+sizeof(targ_info->target_info_byte_count),
                         sizeof(*targ_info)-sizeof(targ_info->target_info_byte_count), true);
         if (status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to read Target Info (%d bytes) from the device\n",
@@ -203,7 +203,7 @@ BMIGetTargetInfo(HIF_DEVICE *device, struct bmi_target_info *targ_info)
 int
 BMIReadMemory(HIF_DEVICE *device,
               u32 address,
-              A_UCHAR *buffer,
+              u8 *buffer,
               u32 length)
 {
     u32 cid;
@@ -259,7 +259,7 @@ BMIReadMemory(HIF_DEVICE *device,
 int
 BMIWriteMemory(HIF_DEVICE *device,
                u32 address,
-               A_UCHAR *buffer,
+               u8 *buffer,
                u32 length)
 {
     u32 cid;
@@ -267,8 +267,8 @@ BMIWriteMemory(HIF_DEVICE *device,
     u32 offset;
     u32 remaining, txlen;
     const u32 header = sizeof(cid) + sizeof(address) + sizeof(length);
-    A_UCHAR alignedBuffer[BMI_DATASZ_MAX];
-    A_UCHAR *src;
+    u8 alignedBuffer[BMI_DATASZ_MAX];
+    u8 *src;
 
     A_ASSERT(BMI_COMMAND_FITS(BMI_DATASZ_MAX + header));
     memset (pBMICmdBuf, 0, BMI_DATASZ_MAX + header);
@@ -647,7 +647,7 @@ BMIrompatchDeactivate(HIF_DEVICE *device,
 
 int
 BMILZData(HIF_DEVICE *device,
-          A_UCHAR *buffer,
+          u8 *buffer,
           u32 length)
 {
     u32 cid;
@@ -735,7 +735,7 @@ BMILZStreamStart(HIF_DEVICE *device,
 /* BMI Access routines */
 int
 bmiBufferSend(HIF_DEVICE *device,
-              A_UCHAR *buffer,
+              u8 *buffer,
               u32 length)
 {
     int status;
@@ -783,7 +783,7 @@ bmiBufferSend(HIF_DEVICE *device,
 
 int
 bmiBufferReceive(HIF_DEVICE *device,
-                 A_UCHAR *buffer,
+                 u8 *buffer,
                  u32 length,
                  bool want_timeout)
 {
@@ -958,7 +958,7 @@ bmiBufferReceive(HIF_DEVICE *device,
 }
 
 int
-BMIFastDownload(HIF_DEVICE *device, u32 address, A_UCHAR *buffer, u32 length)
+BMIFastDownload(HIF_DEVICE *device, u32 address, u8 *buffer, u32 length)
 {
     int status = A_ERROR;
     u32 lastWord = 0;
@@ -998,13 +998,13 @@ BMIFastDownload(HIF_DEVICE *device, u32 address, A_UCHAR *buffer, u32 length)
 }
 
 int
-BMIRawWrite(HIF_DEVICE *device, A_UCHAR *buffer, u32 length)
+BMIRawWrite(HIF_DEVICE *device, u8 *buffer, u32 length)
 {
     return bmiBufferSend(device, buffer, length);
 }
 
 int
-BMIRawRead(HIF_DEVICE *device, A_UCHAR *buffer, u32 length, bool want_timeout)
+BMIRawRead(HIF_DEVICE *device, u8 *buffer, u32 length, bool want_timeout)
 {
     return bmiBufferReceive(device, buffer, length, want_timeout);
 }
diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h b/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
index 8ea3d02..87057e3 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
@@ -54,7 +54,7 @@ typedef struct bus_request {
     struct bus_request *inusenext;  /* link list of in use requests */
     struct semaphore sem_req;
     u32 address;               /* request data */
-    A_UCHAR *buffer;
+    u8 *buffer;
     u32 length;
     u32 request;
     void *context;
diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
index 8504724..b9f8c72 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
@@ -155,7 +155,7 @@ int HIFInit(OSDRV_CALLBACKS *callbacks)
 static int
 __HIFReadWrite(HIF_DEVICE *device,
              u32 address,
-             A_UCHAR *buffer,
+             u8 *buffer,
              u32 length,
              u32 request,
              void *context)
@@ -332,7 +332,7 @@ void AddToAsyncList(HIF_DEVICE *device, BUS_REQUEST *busrequest)
 int
 HIFReadWrite(HIF_DEVICE *device,
              u32 address,
-             A_UCHAR *buffer,
+             u8 *buffer,
              u32 length,
              u32 request,
              void *context)
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
index cf75c20..9090a39 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
@@ -491,7 +491,7 @@ int DevEnableRecv(AR6K_DEVICE *pDev, bool AsyncMode)
 int DevWaitForPendingRecv(AR6K_DEVICE *pDev,u32 TimeoutInMs,bool *pbIsRecvPending)
 {
     int    status          = 0;
-    A_UCHAR     host_int_status = 0x0;
+    u8     host_int_status = 0x0;
     u32 counter         = 0x0;
 
     if(TimeoutInMs < 100)
@@ -507,7 +507,7 @@ int DevWaitForPendingRecv(AR6K_DEVICE *pDev,u32 TimeoutInMs,bool *pbIsRecvPendin
         status = HIFReadWrite(pDev->HIFDevice,
                               HOST_INT_STATUS_ADDRESS,
                              &host_int_status,
-                              sizeof(A_UCHAR),
+                              sizeof(u8),
                               HIF_RD_SYNC_BYTE_INC,
                               NULL);
         if (status)
diff --git a/drivers/staging/ath6kl/htc2/htc_internal.h b/drivers/staging/ath6kl/htc2/htc_internal.h
index 743469d..73f6ed9 100644
--- a/drivers/staging/ath6kl/htc2/htc_internal.h
+++ b/drivers/staging/ath6kl/htc2/htc_internal.h
@@ -178,7 +178,7 @@ void        HTCFlushSendPkts(HTC_TARGET *target);
 #ifdef ATH_DEBUG_MODULE
 void        DumpCreditDist(HTC_ENDPOINT_CREDIT_DIST *pEPDist);
 void        DumpCreditDistStates(HTC_TARGET *target);
-void 		DebugDumpBytes(A_UCHAR *buffer, u16 length, char *pDescription);
+void 		DebugDumpBytes(u8 *buffer, u16 length, char *pDescription);
 #endif
 
 static INLINE HTC_PACKET *HTC_ALLOC_CONTROL_TX(HTC_TARGET *target) {
diff --git a/drivers/staging/ath6kl/include/a_debug.h b/drivers/staging/ath6kl/include/a_debug.h
index 57472cf..0e5430d 100644
--- a/drivers/staging/ath6kl/include/a_debug.h
+++ b/drivers/staging/ath6kl/include/a_debug.h
@@ -57,7 +57,7 @@ extern "C" {
     /* macro to make a module-specific masks */
 #define ATH_DEBUG_MAKE_MODULE_MASK(index)  (1 << (ATH_DEBUG_MODULE_MASK_SHIFT + (index)))
 
-void DebugDumpBytes(A_UCHAR *buffer, u16 length, char *pDescription);
+void DebugDumpBytes(u8 *buffer, u16 length, char *pDescription);
 
 /* Debug support on a per-module basis
  *
diff --git a/drivers/staging/ath6kl/include/ar6000_diag.h b/drivers/staging/ath6kl/include/ar6000_diag.h
index 78ac597..ca0961a 100644
--- a/drivers/staging/ath6kl/include/ar6000_diag.h
+++ b/drivers/staging/ath6kl/include/ar6000_diag.h
@@ -33,11 +33,11 @@ ar6000_WriteRegDiag(HIF_DEVICE *hifDevice, u32 *address, u32 *data);
 
 int
 ar6000_ReadDataDiag(HIF_DEVICE *hifDevice, u32 address,
-                    A_UCHAR *data, u32 length);
+                    u8 *data, u32 length);
 
 int
 ar6000_WriteDataDiag(HIF_DEVICE *hifDevice, u32 address,
-                     A_UCHAR *data, u32 length);
+                     u8 *data, u32 length);
 
 int
 ar6k_ReadTargetRegister(HIF_DEVICE *hifDevice, int regsel, u32 *regval);
diff --git a/drivers/staging/ath6kl/include/bmi.h b/drivers/staging/ath6kl/include/bmi.h
index 788f9af..b44988d 100644
--- a/drivers/staging/ath6kl/include/bmi.h
+++ b/drivers/staging/ath6kl/include/bmi.h
@@ -52,13 +52,13 @@ BMIGetTargetInfo(HIF_DEVICE *device, struct bmi_target_info *targ_info);
 int
 BMIReadMemory(HIF_DEVICE *device,
               u32 address,
-              A_UCHAR *buffer,
+              u8 *buffer,
               u32 length);
 
 int
 BMIWriteMemory(HIF_DEVICE *device,
                u32 address,
-               A_UCHAR *buffer,
+               u8 *buffer,
                u32 length);
 
 int
@@ -108,23 +108,23 @@ BMILZStreamStart(HIF_DEVICE *device,
 
 int
 BMILZData(HIF_DEVICE *device,
-          A_UCHAR *buffer,
+          u8 *buffer,
           u32 length);
 
 int
 BMIFastDownload(HIF_DEVICE *device,
                 u32 address,
-                A_UCHAR *buffer,
+                u8 *buffer,
                 u32 length);
 
 int
 BMIRawWrite(HIF_DEVICE *device,
-            A_UCHAR *buffer,
+            u8 *buffer,
             u32 length);
 
 int
 BMIRawRead(HIF_DEVICE *device, 
-           A_UCHAR *buffer, 
+           u8 *buffer, 
            u32 length,
            bool want_timeout);
 
diff --git a/drivers/staging/ath6kl/include/common/regulatory/reg_dbschema.h b/drivers/staging/ath6kl/include/common/regulatory/reg_dbschema.h
index 93d7c0b..4904040 100644
--- a/drivers/staging/ath6kl/include/common/regulatory/reg_dbschema.h
+++ b/drivers/staging/ath6kl/include/common/regulatory/reg_dbschema.h
@@ -124,7 +124,7 @@ enum searchType {
  * instance of table).
  */
 typedef PREPACK struct dbMasterTable_t {    /* Hold ptrs to Table data structures */
-    A_UCHAR     numOfEntries;
+    u8     numOfEntries;
     char entrySize;      /* Entry size per table row */
     char searchType;     /* Index based access or key based */
     char reserved[3];    /* for alignment */
diff --git a/drivers/staging/ath6kl/include/common/testcmd.h b/drivers/staging/ath6kl/include/common/testcmd.h
index 3799b68..9ca1f2a 100644
--- a/drivers/staging/ath6kl/include/common/testcmd.h
+++ b/drivers/staging/ath6kl/include/common/testcmd.h
@@ -142,7 +142,7 @@ typedef PREPACK struct {
             u16 rateCntShortGuard[TCMD_MAX_RATES];
         } POSTPACK report;
         struct PREPACK TCMD_CONT_RX_MAC {
-            A_UCHAR    addr[ATH_MAC_LEN];
+            u8    addr[ATH_MAC_LEN];
         } POSTPACK mac;
         struct PREPACK TCMD_CONT_RX_ANT_SWITCH_TABLE {
             u32 antswitch1;
diff --git a/drivers/staging/ath6kl/include/common/wmi.h b/drivers/staging/ath6kl/include/common/wmi.h
index a8b143a..c645af3 100644
--- a/drivers/staging/ath6kl/include/common/wmi.h
+++ b/drivers/staging/ath6kl/include/common/wmi.h
@@ -537,7 +537,7 @@ typedef PREPACK struct {
     u8 groupCryptoType;
     u8 groupCryptoLen;
     u8 ssidLength;
-    A_UCHAR     ssid[WMI_MAX_SSID_LEN];
+    u8     ssid[WMI_MAX_SSID_LEN];
     u16 channel;
     u8 bssid[ATH_MAC_LEN];
     u32 ctrl_flags;
@@ -3031,7 +3031,7 @@ typedef PREPACK struct {
 #define WMI_DISABLE_REGULATORY_CODE "FF"
 
 typedef PREPACK struct {
-    A_UCHAR countryCode[3];
+    u8 countryCode[3];
 } POSTPACK WMI_AP_SET_COUNTRY_CMD;
 
 typedef PREPACK struct {
diff --git a/drivers/staging/ath6kl/include/common/wmi_thin.h b/drivers/staging/ath6kl/include/common/wmi_thin.h
index 41f2b9b..0a8364c 100644
--- a/drivers/staging/ath6kl/include/common/wmi_thin.h
+++ b/drivers/staging/ath6kl/include/common/wmi_thin.h
@@ -309,7 +309,7 @@ typedef PREPACK struct {
     u8 ssidLength; /* 0 - 32 */
     u8 probe;      /* != 0 : issue probe req at start */
     u8 reserved;   /* alignment */
-    A_UCHAR     ssid[WMI_MAX_SSID_LEN];    
+    u8     ssid[WMI_MAX_SSID_LEN];    
     u8 bssid[ATH_MAC_LEN];
 } POSTPACK WMI_THIN_JOIN_CMD;
 
diff --git a/drivers/staging/ath6kl/include/common_drv.h b/drivers/staging/ath6kl/include/common_drv.h
index 141b7ef..6ed4901 100644
--- a/drivers/staging/ath6kl/include/common_drv.h
+++ b/drivers/staging/ath6kl/include/common_drv.h
@@ -70,7 +70,7 @@ int ar6000_ReadRegDiag(HIF_DEVICE *hifDevice, u32 *address, u32 *data);
 
 int ar6000_WriteRegDiag(HIF_DEVICE *hifDevice, u32 *address, u32 *data);
 
-int ar6000_ReadDataDiag(HIF_DEVICE *hifDevice, u32 address,  A_UCHAR *data, u32 length);
+int ar6000_ReadDataDiag(HIF_DEVICE *hifDevice, u32 address,  u8 *data, u32 length);
 
 int ar6000_reset_device(HIF_DEVICE *hifDevice, u32 TargetType, bool waitForCompletion, bool coldReset);
 
diff --git a/drivers/staging/ath6kl/include/hif.h b/drivers/staging/ath6kl/include/hif.h
index 3906780..ab1f4c1 100644
--- a/drivers/staging/ath6kl/include/hif.h
+++ b/drivers/staging/ath6kl/include/hif.h
@@ -401,7 +401,7 @@ void     HIFDetachHTC(HIF_DEVICE *device);
 int
 HIFReadWrite(HIF_DEVICE    *device,
              u32 address,
-             A_UCHAR       *buffer,
+             u8       *buffer,
              u32 length,
              u32 request,
              void          *context);
diff --git a/drivers/staging/ath6kl/include/wlan_api.h b/drivers/staging/ath6kl/include/wlan_api.h
index ba5493c..9eea587 100644
--- a/drivers/staging/ath6kl/include/wlan_api.h
+++ b/drivers/staging/ath6kl/include/wlan_api.h
@@ -108,7 +108,7 @@ void
 wlan_refresh_inactive_nodes (struct ieee80211_node_table *nt);
 
 bss_t *
-wlan_find_Ssidnode (struct ieee80211_node_table *nt, A_UCHAR *pSsid,
+wlan_find_Ssidnode (struct ieee80211_node_table *nt, u8 *pSsid,
                     u32 ssidLength, bool bIsWPA2, bool bMatchSSID);
 
 void
@@ -117,7 +117,7 @@ wlan_node_return (struct ieee80211_node_table *nt, bss_t *ni);
 bss_t *wlan_node_remove(struct ieee80211_node_table *nt, u8 *bssid);
 
 bss_t *
-wlan_find_matching_Ssidnode (struct ieee80211_node_table *nt, A_UCHAR *pSsid,
+wlan_find_matching_Ssidnode (struct ieee80211_node_table *nt, u8 *pSsid,
                     u32 ssidLength, u32 dot11AuthMode, u32 authMode,
                    u32 pairwiseCryptoType, u32 grpwiseCryptoTyp);
 
diff --git a/drivers/staging/ath6kl/include/wmi_api.h b/drivers/staging/ath6kl/include/wmi_api.h
index 7ba8505..c8583e0 100644
--- a/drivers/staging/ath6kl/include/wmi_api.h
+++ b/drivers/staging/ath6kl/include/wmi_api.h
@@ -111,7 +111,7 @@ int wmi_connect_cmd(struct wmi_t *wmip,
                          CRYPTO_TYPE groupCrypto,
                          u8 groupCryptoLen,
                          int ssidLength,
-                         A_UCHAR *ssid,
+                         u8 *ssid,
                          u8 *bssid,
                          u16 channel,
                          u32 ctrl_flags);
@@ -134,7 +134,7 @@ int wmi_scanparams_cmd(struct wmi_t *wmip, u16 fg_start_sec,
                             u16 maxact_scan_per_ssid);
 int wmi_bssfilter_cmd(struct wmi_t *wmip, u8 filter, u32 ieMask);
 int wmi_probedSsid_cmd(struct wmi_t *wmip, u8 index, u8 flag,
-                            u8 ssidLength, A_UCHAR *ssid);
+                            u8 ssidLength, u8 *ssid);
 int wmi_listeninterval_cmd(struct wmi_t *wmip, u16 listenInterval, u16 listenBeacons);
 int wmi_bmisstime_cmd(struct wmi_t *wmip, u16 bmisstime, u16 bmissbeacons);
 int wmi_associnfo_cmd(struct wmi_t *wmip, u8 ieType,
@@ -284,7 +284,7 @@ int wmi_set_reassocmode_cmd(struct wmi_t *wmip, u8 mode);
 int wmi_set_qos_supp_cmd(struct wmi_t *wmip,u8 status);
 int wmi_set_wmm_cmd(struct wmi_t *wmip, WMI_WMM_STATUS status);
 int wmi_set_wmm_txop(struct wmi_t *wmip, WMI_TXOP_CFG txEnable);
-int wmi_set_country(struct wmi_t *wmip, A_UCHAR *countryCode);
+int wmi_set_country(struct wmi_t *wmip, u8 *countryCode);
 
 int wmi_get_keepalive_configured(struct wmi_t *wmip);
 u8 wmi_get_keepalive_cmd(struct wmi_t *wmip);
@@ -322,7 +322,7 @@ int
 wmi_mcast_filter_cmd(struct wmi_t *wmip, u8 enable);
 
 bss_t *
-wmi_find_Ssidnode (struct wmi_t *wmip, A_UCHAR *pSsid,
+wmi_find_Ssidnode (struct wmi_t *wmip, u8 *pSsid,
                    u32 ssidLength, bool bIsWPA2, bool bMatchSSID);
 
 
@@ -429,7 +429,7 @@ u16 wmi_ieee2freq (int chan);
 u32 wmi_freq2ieee (u16 freq);
 
 bss_t *
-wmi_find_matching_Ssidnode (struct wmi_t *wmip, A_UCHAR *pSsid,
+wmi_find_matching_Ssidnode (struct wmi_t *wmip, u8 *pSsid,
                    u32 ssidLength,
                    u32 dot11AuthMode, u32 authMode,
                    u32 pairwiseCryptoType, u32 grpwiseCryptoTyp);
diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
index 55b0633..3dce6f5 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
+++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
@@ -62,20 +62,20 @@ int ReadVersionInfo(AR3K_CONFIG_INFO *pConfig);
 
 DECLARE_WAIT_QUEUE_HEAD(PsCompleteEvent);
 DECLARE_WAIT_QUEUE_HEAD(HciEvent);
-A_UCHAR *HciEventpacket;
+u8 *HciEventpacket;
 rwlock_t syncLock;
 wait_queue_t Eventwait;
 
-int PSHciWritepacket(struct hci_dev*,A_UCHAR* Data, u32 len);
+int PSHciWritepacket(struct hci_dev*,u8* Data, u32 len);
 extern char *bdaddr;
 #endif /* HCI_TRANSPORT_SDIO */
 
-int write_bdaddr(AR3K_CONFIG_INFO *pConfig,A_UCHAR *bdaddr,int type);
+int write_bdaddr(AR3K_CONFIG_INFO *pConfig,u8 *bdaddr,int type);
 
 int PSSendOps(void *arg);
 
 #ifdef BT_PS_DEBUG
-void Hci_log(A_UCHAR * log_string,A_UCHAR *data,u32 len)
+void Hci_log(u8 * log_string,u8 *data,u32 len)
 {
     int i;
     AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("%s : ",log_string));
@@ -139,14 +139,14 @@ int PSSendOps(void *arg)
     u8 *event;
     u8 *bufferToFree;
     struct hci_dev *device;
-    A_UCHAR *buffer;
+    u8 *buffer;
     u32 len;
     u32 DevType;
-    A_UCHAR *PsFileName;
-    A_UCHAR *patchFileName;
-    A_UCHAR *path = NULL;
-    A_UCHAR *config_path = NULL;
-    A_UCHAR config_bdaddr[MAX_BDADDR_FORMAT_LENGTH];
+    u8 *PsFileName;
+    u8 *patchFileName;
+    u8 *path = NULL;
+    u8 *config_path = NULL;
+    u8 config_bdaddr[MAX_BDADDR_FORMAT_LENGTH];
     AR3K_CONFIG_INFO *hdev = (AR3K_CONFIG_INFO*)arg;
     struct device *firmwareDev = NULL;
     status = 0;
@@ -162,12 +162,12 @@ int PSSendOps(void *arg)
     /* First verify if the controller is an FPGA or ASIC, so depending on the device type the PS file to be written will be different.
      */
 
-    path =(A_UCHAR *)A_MALLOC(MAX_FW_PATH_LEN);
+    path =(u8 *)A_MALLOC(MAX_FW_PATH_LEN);
     if(path == NULL) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Malloc failed to allocate %d bytes for path\n", MAX_FW_PATH_LEN));
         goto complete;
     }
-    config_path = (A_UCHAR *) A_MALLOC(MAX_FW_PATH_LEN);
+    config_path = (u8 *) A_MALLOC(MAX_FW_PATH_LEN);
     if(config_path == NULL) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Malloc failed to allocate %d bytes for config_path\n", MAX_FW_PATH_LEN));
         goto complete;
@@ -214,7 +214,7 @@ int PSSendOps(void *arg)
         status = 1;
         goto complete;
     }
-    buffer = (A_UCHAR *)A_MALLOC(firmware->size);
+    buffer = (u8 *)A_MALLOC(firmware->size);
     if(buffer != NULL) {
     /* Copy the read file to a local Dynamic buffer */
         memcpy(buffer,firmware->data,firmware->size);
@@ -248,7 +248,7 @@ int PSSendOps(void *arg)
         if(NULL == firmware || firmware->size == 0) {
             status = 0;
         } else {
-            buffer = (A_UCHAR *)A_MALLOC(firmware->size);
+            buffer = (u8 *)A_MALLOC(firmware->size);
             if(buffer != NULL) {
                 /* Copy the read file to a local Dynamic buffer */
                 memcpy(buffer,firmware->data,firmware->size);
@@ -419,7 +419,7 @@ int SendHCICommandWaitCommandComplete(AR3K_CONFIG_INFO *pConfig,
 }
 #endif /* HCI_TRANSPORT_SDIO */
 
-int ReadPSEvent(A_UCHAR* Data){
+int ReadPSEvent(u8* Data){
     AR_DEBUG_PRINTF(ATH_DEBUG_ERR,(" PS Event %x %x %x\n",Data[4],Data[5],Data[3]));
                                 
     if(Data[4] == 0xFC && Data[5] == 0x00)
@@ -481,9 +481,9 @@ int str2ba(unsigned char *str_bdaddr,unsigned char *bdaddr)
 	return 0; 
 }
 
-int write_bdaddr(AR3K_CONFIG_INFO *pConfig,A_UCHAR *bdaddr,int type)
+int write_bdaddr(AR3K_CONFIG_INFO *pConfig,u8 *bdaddr,int type)
 {
-	A_UCHAR bdaddr_cmd[] = { 0x0B, 0xFC, 0x0A, 0x01, 0x01, 
+	u8 bdaddr_cmd[] = { 0x0B, 0xFC, 0x0A, 0x01, 0x01, 
 							0x00, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 
     u8 *event;
diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
index 975bf62..b97d91f 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
+++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
@@ -67,9 +67,9 @@
 #define AR3K_CONFIG_INFO        struct hci_dev
 extern wait_queue_head_t HciEvent;
 extern wait_queue_t Eventwait;
-extern A_UCHAR *HciEventpacket;
+extern u8 *HciEventpacket;
 #endif /* #ifndef HCI_TRANSPORT_SDIO */
 
 int AthPSInitialize(AR3K_CONFIG_INFO *hdev);
-int ReadPSEvent(A_UCHAR* Data);
+int ReadPSEvent(u8* Data);
 #endif /* __AR3KPSCONFIG_H */
diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
index 90ced22..300c501 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
+++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
@@ -127,13 +127,13 @@ tPsTagEntry PsTagEntry[RAMPS_MAX_PS_TAGS_PER_FILE];
 tRamPatch   RamPatch[MAX_NUM_PATCH_ENTRY];
 
 
-int AthParseFilesUnified(A_UCHAR *srcbuffer,u32 srclen, int FileFormat);
-char AthReadChar(A_UCHAR *buffer, u32 len,u32 *pos);
-char *AthGetLine(char *buffer, int maxlen, A_UCHAR *srcbuffer,u32 len,u32 *pos);
-static int AthPSCreateHCICommand(A_UCHAR Opcode, u32 Param1,PSCmdPacket *PSPatchPacket,u32 *index);
+int AthParseFilesUnified(u8 *srcbuffer,u32 srclen, int FileFormat);
+char AthReadChar(u8 *buffer, u32 len,u32 *pos);
+char *AthGetLine(char *buffer, int maxlen, u8 *srcbuffer,u32 len,u32 *pos);
+static int AthPSCreateHCICommand(u8 Opcode, u32 Param1,PSCmdPacket *PSPatchPacket,u32 *index);
 
 /* Function to reads the next character from the input buffer */
-char AthReadChar(A_UCHAR *buffer, u32 len,u32 *pos)
+char AthReadChar(u8 *buffer, u32 len,u32 *pos)
 {
     char Ch;
     if(buffer == NULL || *pos >=len )
@@ -315,7 +315,7 @@ unsigned int uReadDataInSection(char *pCharLine, ST_PS_DATA_FORMAT stPS_DataForm
         return (0x0FFF);
     }
 }
-int AthParseFilesUnified(A_UCHAR *srcbuffer,u32 srclen, int FileFormat)
+int AthParseFilesUnified(u8 *srcbuffer,u32 srclen, int FileFormat)
 {
    char *Buffer;
    char *pCharLine;
@@ -558,7 +558,7 @@ int AthParseFilesUnified(A_UCHAR *srcbuffer,u32 srclen, int FileFormat)
 /********************/
 
 
-int GetNextTwoChar(A_UCHAR *srcbuffer,u32 len, u32 *pos, char *buffer)
+int GetNextTwoChar(u8 *srcbuffer,u32 len, u32 *pos, char *buffer)
 {
     unsigned char ch;
 
@@ -579,7 +579,7 @@ int GetNextTwoChar(A_UCHAR *srcbuffer,u32 len, u32 *pos, char *buffer)
     return 0;
 }
 
-int AthDoParsePatch(A_UCHAR *patchbuffer, u32 patchlen)
+int AthDoParsePatch(u8 *patchbuffer, u32 patchlen)
 {
 
     char Byte[3];
@@ -659,7 +659,7 @@ int AthDoParsePatch(A_UCHAR *patchbuffer, u32 patchlen)
 
 
 /********************/
-int AthDoParsePS(A_UCHAR *srcbuffer, u32 srclen)
+int AthDoParsePS(u8 *srcbuffer, u32 srclen)
 {
     int status;
     int i;
@@ -713,7 +713,7 @@ int AthDoParsePS(A_UCHAR *srcbuffer, u32 srclen)
 
     return status;
 }
-char *AthGetLine(char *buffer, int maxlen, A_UCHAR *srcbuffer,u32 len,u32 *pos)
+char *AthGetLine(char *buffer, int maxlen, u8 *srcbuffer,u32 len,u32 *pos)
 {
 
     int count;
@@ -751,7 +751,7 @@ char *AthGetLine(char *buffer, int maxlen, A_UCHAR *srcbuffer,u32 len,u32 *pos)
     return buffer;
 }
 
-static void LoadHeader(A_UCHAR *HCI_PS_Command,A_UCHAR opcode,int length,int index){
+static void LoadHeader(u8 *HCI_PS_Command,u8 opcode,int length,int index){
 
         HCI_PS_Command[0]= 0x0B;
         HCI_PS_Command[1]= 0xFC;
@@ -833,9 +833,9 @@ int AthCreateCommandList(PSCmdPacket **HciPacketList, u32 *numPackets)
 ////////////////////////
 
 /////////////
-static int AthPSCreateHCICommand(A_UCHAR Opcode, u32 Param1,PSCmdPacket *PSPatchPacket,u32 *index)
+static int AthPSCreateHCICommand(u8 Opcode, u32 Param1,PSCmdPacket *PSPatchPacket,u32 *index)
 {
-    A_UCHAR *HCI_PS_Command;
+    u8 *HCI_PS_Command;
     u32 Length;
     int i,j;
     
@@ -846,7 +846,7 @@ static int AthPSCreateHCICommand(A_UCHAR Opcode, u32 Param1,PSCmdPacket *PSPatch
 
          for(i=0;i< Param1;i++){
 
-             HCI_PS_Command = (A_UCHAR *) A_MALLOC(RamPatch[i].Len+HCI_COMMAND_HEADER);
+             HCI_PS_Command = (u8 *) A_MALLOC(RamPatch[i].Len+HCI_COMMAND_HEADER);
              AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Allocated Buffer Size %d\n",RamPatch[i].Len+HCI_COMMAND_HEADER));
                  if(HCI_PS_Command == NULL){
                      AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("MALLOC Failed\r\n"));
@@ -871,7 +871,7 @@ static int AthPSCreateHCICommand(A_UCHAR Opcode, u32 Param1,PSCmdPacket *PSPatch
 
          Length = 0;
          i= 0;
-         HCI_PS_Command = (A_UCHAR *) A_MALLOC(Length+HCI_COMMAND_HEADER);
+         HCI_PS_Command = (u8 *) A_MALLOC(Length+HCI_COMMAND_HEADER);
          if(HCI_PS_Command == NULL){
              AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("MALLOC Failed\r\n"));
             return A_ERROR;
@@ -888,7 +888,7 @@ static int AthPSCreateHCICommand(A_UCHAR Opcode, u32 Param1,PSCmdPacket *PSPatch
     case PS_RESET:
                         Length = 0x06;
                         i=0;
-                        HCI_PS_Command = (A_UCHAR *) A_MALLOC(Length+HCI_COMMAND_HEADER);
+                        HCI_PS_Command = (u8 *) A_MALLOC(Length+HCI_COMMAND_HEADER);
                         if(HCI_PS_Command == NULL){
                                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("MALLOC Failed\r\n"));
                                 return A_ERROR;
@@ -909,7 +909,7 @@ static int AthPSCreateHCICommand(A_UCHAR Opcode, u32 Param1,PSCmdPacket *PSPatch
                                 if(PsTagEntry[i].TagId ==1)
                                         BDADDR = true;
 
-                                HCI_PS_Command = (A_UCHAR *) A_MALLOC(PsTagEntry[i].TagLen+HCI_COMMAND_HEADER);
+                                HCI_PS_Command = (u8 *) A_MALLOC(PsTagEntry[i].TagLen+HCI_COMMAND_HEADER);
                                 if(HCI_PS_Command == NULL){
                                         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("MALLOC Failed\r\n"));
                                         return A_ERROR;
@@ -936,7 +936,7 @@ static int AthPSCreateHCICommand(A_UCHAR Opcode, u32 Param1,PSCmdPacket *PSPatch
 
                         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("VALUE of CRC:%d At index %d\r\n",Param1,*index));
 
-                        HCI_PS_Command = (A_UCHAR *) A_MALLOC(Length+HCI_COMMAND_HEADER);
+                        HCI_PS_Command = (u8 *) A_MALLOC(Length+HCI_COMMAND_HEADER);
                         if(HCI_PS_Command == NULL){
                                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("MALLOC Failed\r\n"));
                                 return A_ERROR;
diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h
index fdc1c94..62e298d 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h
+++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h
@@ -48,13 +48,6 @@
 
 /* Helper data type declaration */
 
-#ifndef u32 #define A_UCHAR                 unsigned char
-#define u32 unsigned long
-#define u16 unsigned short
-#define u8 unsigned char
-#define bool                  unsigned char
-#endif /* u32 */
-
 #define ATH_DEBUG_ERR          (1 << 0)
 #define ATH_DEBUG_WARN         (1 << 1)
 #define ATH_DEBUG_INFO         (1 << 2)
@@ -98,15 +91,15 @@
 
 typedef struct PSCmdPacket
 {
-    A_UCHAR *Hcipacket;
+    u8 *Hcipacket;
     int packetLen;
 } PSCmdPacket;
 
 /* Parses a Patch information buffer and store it in global structure */
-int AthDoParsePatch(A_UCHAR *, u32 );
+int AthDoParsePatch(u8 *, u32 );
 
 /* parses a PS information buffer and stores it in a global structure */
-int AthDoParsePS(A_UCHAR *, u32 );
+int AthDoParsePS(u8 *, u32 );
 
 /* 
  *  Uses the output of Both AthDoParsePS and AthDoParsePatch APIs to form HCI command array with
diff --git a/drivers/staging/ath6kl/miscdrv/common_drv.c b/drivers/staging/ath6kl/miscdrv/common_drv.c
index a01f5d7..b5f74c5 100644
--- a/drivers/staging/ath6kl/miscdrv/common_drv.c
+++ b/drivers/staging/ath6kl/miscdrv/common_drv.c
@@ -123,7 +123,7 @@ int ar6000_SetAddressWindowRegister(HIF_DEVICE *hifDevice, u32 RegisterAddr, u32
          * 3 byte write to bytes 1,2,3 has no effect since we are writing the same values again */
     status = HIFReadWrite(hifDevice,
                           RegisterAddr,
-                          (A_UCHAR *)(&Address),
+                          (u8 *)(&Address),
                           4,
                           HIF_WR_SYNC_BYTE_INC,
                           NULL);
@@ -152,7 +152,7 @@ int ar6000_SetAddressWindowRegister(HIF_DEVICE *hifDevice, u32 RegisterAddr, u32
          * last to initiate the access cycle */
     status = HIFReadWrite(hifDevice,
                           RegisterAddr+1,  /* write upper 3 bytes */
-                          ((A_UCHAR *)(&Address))+1,
+                          ((u8 *)(&Address))+1,
                           sizeof(u32)-1,
                           HIF_WR_SYNC_BYTE_INC,
                           NULL);
@@ -166,7 +166,7 @@ int ar6000_SetAddressWindowRegister(HIF_DEVICE *hifDevice, u32 RegisterAddr, u32
         /* write the LSB of the register, this initiates the operation */
     status = HIFReadWrite(hifDevice,
                           RegisterAddr,
-                          (A_UCHAR *)(&Address),
+                          (u8 *)(&Address),
                           sizeof(u8),
                           HIF_WR_SYNC_BYTE_INC,
                           NULL);
@@ -203,7 +203,7 @@ ar6000_ReadRegDiag(HIF_DEVICE *hifDevice, u32 *address, u32 *data)
         /* read the data */
     status = HIFReadWrite(hifDevice,
                           WINDOW_DATA_ADDRESS,
-                          (A_UCHAR *)data,
+                          (u8 *)data,
                           sizeof(u32),
                           HIF_RD_SYNC_BYTE_INC,
                           NULL);
@@ -228,7 +228,7 @@ ar6000_WriteRegDiag(HIF_DEVICE *hifDevice, u32 *address, u32 *data)
         /* set write data */
     status = HIFReadWrite(hifDevice,
                           WINDOW_DATA_ADDRESS,
-                          (A_UCHAR *)data,
+                          (u8 *)data,
                           sizeof(u32),
                           HIF_WR_SYNC_BYTE_INC,
                           NULL);
@@ -245,7 +245,7 @@ ar6000_WriteRegDiag(HIF_DEVICE *hifDevice, u32 *address, u32 *data)
 
 int
 ar6000_ReadDataDiag(HIF_DEVICE *hifDevice, u32 address,
-                    A_UCHAR *data, u32 length)
+                    u8 *data, u32 length)
 {
     u32 count;
     int status = 0;
@@ -263,7 +263,7 @@ ar6000_ReadDataDiag(HIF_DEVICE *hifDevice, u32 address,
 
 int
 ar6000_WriteDataDiag(HIF_DEVICE *hifDevice, u32 address,
-                    A_UCHAR *data, u32 length)
+                    u8 *data, u32 length)
 {
     u32 count;
     int status = 0;
@@ -283,8 +283,8 @@ int
 ar6k_ReadTargetRegister(HIF_DEVICE *hifDevice, int regsel, u32 *regval)
 {
     int status;
-    A_UCHAR vals[4];
-    A_UCHAR register_selection[4];
+    u8 vals[4];
+    u8 register_selection[4];
 
     register_selection[0] = register_selection[1] = register_selection[2] = register_selection[3] = (regsel & 0xff);
     status = HIFReadWrite(hifDevice,
@@ -301,7 +301,7 @@ ar6k_ReadTargetRegister(HIF_DEVICE *hifDevice, int regsel, u32 *regval)
 
     status = HIFReadWrite(hifDevice,
                           CPU_DBG_ADDRESS,
-                          (A_UCHAR *)vals,
+                          (u8 *)vals,
                           sizeof(vals),
                           HIF_RD_SYNC_BYTE_INC,
                           NULL);
@@ -489,7 +489,7 @@ ar6000_copy_cust_data_from_target(HIF_DEVICE *hifDevice, u32 TargetType)
 
     if (BMIReadMemory(hifDevice,
             HOST_INTEREST_ITEM_ADDRESS(TargetType, hi_board_data),
-            (A_UCHAR *)&eepHeaderAddr,
+            (u8 *)&eepHeaderAddr,
             4)!= 0)
     {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("BMIReadMemory for reading board data address failed \n"));
@@ -595,7 +595,7 @@ void ar6000_dump_target_assert_info(HIF_DEVICE *hifDevice, u32 TargetType)
             /* fetch register dump data */
         status = ar6000_ReadDataDiag(hifDevice,
                                      regDumpArea,
-                                     (A_UCHAR *)&regDumpValues[0],
+                                     (u8 *)&regDumpValues[0],
                                      regDumpCount * (sizeof(u32)));
 
         if (status) {
@@ -654,7 +654,7 @@ int ar6000_set_htc_params(HIF_DEVICE *hifDevice,
             /* set the host interest area for the block size */
         status = BMIWriteMemory(hifDevice,
                                 HOST_INTEREST_ITEM_ADDRESS(TargetType, hi_mbox_io_block_sz),
-                                (A_UCHAR *)&blocksizes[1],
+                                (u8 *)&blocksizes[1],
                                 4);
 
         if (status) {
@@ -669,7 +669,7 @@ int ar6000_set_htc_params(HIF_DEVICE *hifDevice,
                 /* set the host interest area for the mbox ISR yield limit */
             status = BMIWriteMemory(hifDevice,
                                     HOST_INTEREST_ITEM_ADDRESS(TargetType, hi_mbox_isr_yield_limit),
-                                    (A_UCHAR *)&MboxIsrYieldValue,
+                                    (u8 *)&MboxIsrYieldValue,
                                     4);
 
             if (status) {
@@ -796,7 +796,7 @@ ar6002_REV1_reset_force_host (HIF_DEVICE *hifDevice)
 
 #endif /* CONFIG_AR6002_REV1_FORCE_HOST */
 
-void DebugDumpBytes(A_UCHAR *buffer, u16 length, char *pDescription)
+void DebugDumpBytes(u8 *buffer, u16 length, char *pDescription)
 {
     char stream[60];
     char byteOffsetStr[10];
@@ -1015,7 +1015,7 @@ int ar6000_set_hci_bridge_flags(HIF_DEVICE *hifDevice,
             /* set hci bridge flags */
         status = BMIWriteMemory(hifDevice,
                                 HOST_INTEREST_ITEM_ADDRESS(TargetType, hi_hci_bridge_flags),
-                                (A_UCHAR *)&Flags,
+                                (u8 *)&Flags,
                                 4);
 
 
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index e8277ff..f8d8999 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -416,7 +416,7 @@ ar6000_set_host_app_area(AR_SOFTC_T *ar)
     address = TARG_VTOP(ar->arTargetType, data);
     host_app_area.wmi_protocol_ver = WMI_PROTOCOL_VERSION;
     if (ar6000_WriteDataDiag(ar->arHifDevice, address,
-                             (A_UCHAR *)&host_app_area,
+                             (u8 *)&host_app_area,
                              sizeof(struct host_app_area_s)) != 0)
     {
         return A_ERROR;
@@ -433,7 +433,7 @@ u32 dbglog_get_debug_hdr_ptr(AR_SOFTC_T *ar)
 
     address = TARG_VTOP(ar->arTargetType, HOST_INTEREST_ITEM_ADDRESS(ar, hi_dbglog_hdr));
     if ((status = ar6000_ReadDataDiag(ar->arHifDevice, address,
-                                      (A_UCHAR *)&param, 4)) != 0)
+                                      (u8 *)&param, 4)) != 0)
     {
         param = 0;
     }
@@ -550,13 +550,13 @@ ar6000_dbglog_get_debug_logs(AR_SOFTC_T *ar)
         address = TARG_VTOP(ar->arTargetType, debug_hdr_ptr);
         length = 4 /* sizeof(dbuf) */ + 4 /* sizeof(dropped) */;
         A_MEMZERO(data, sizeof(data));
-        ar6000_ReadDataDiag(ar->arHifDevice, address, (A_UCHAR *)data, length);
+        ar6000_ReadDataDiag(ar->arHifDevice, address, (u8 *)data, length);
         address = TARG_VTOP(ar->arTargetType, data[0] /* dbuf */);
         firstbuf = address;
         dropped = data[1]; /* dropped */
         length = 4 /* sizeof(next) */ + 4 /* sizeof(buffer) */ + 4 /* sizeof(bufsize) */ + 4 /* sizeof(length) */ + 4 /* sizeof(count) */ + 4 /* sizeof(free) */;
         A_MEMZERO(data, sizeof(data));
-        ar6000_ReadDataDiag(ar->arHifDevice, address, (A_UCHAR *)&data, length);
+        ar6000_ReadDataDiag(ar->arHifDevice, address, (u8 *)&data, length);
 
         do {
             address = TARG_VTOP(ar->arTargetType, data[1] /* buffer*/);
@@ -567,7 +567,7 @@ ar6000_dbglog_get_debug_logs(AR_SOFTC_T *ar)
                     ar->log_cnt = 0;
                 }
                 if(0 != ar6000_ReadDataDiag(ar->arHifDevice, address,
-                                    (A_UCHAR *)&ar->log_buffer[ar->log_cnt], length))
+                                    (u8 *)&ar->log_buffer[ar->log_cnt], length))
                 {
                     break;
                 }
@@ -582,7 +582,7 @@ ar6000_dbglog_get_debug_logs(AR_SOFTC_T *ar)
             length = 4 /* sizeof(next) */ + 4 /* sizeof(buffer) */ + 4 /* sizeof(bufsize) */ + 4 /* sizeof(length) */ + 4 /* sizeof(count) */ + 4 /* sizeof(free) */;
             A_MEMZERO(data, sizeof(data));
             if(0 != ar6000_ReadDataDiag(ar->arHifDevice, address,
-                                (A_UCHAR *)&data, length))
+                                (u8 *)&data, length))
             {
                 break;
             }
@@ -816,7 +816,7 @@ ar6000_sysfs_bmi_read(struct file *fp, struct kobject *kobj,
 
     if (index == MAX_AR6000) return 0;
 
-    if ((BMIRawRead(ar->arHifDevice, (A_UCHAR*)buf, count, true)) != 0) {
+    if ((BMIRawRead(ar->arHifDevice, (u8*)buf, count, true)) != 0) {
         return 0;
     }
 
@@ -843,7 +843,7 @@ ar6000_sysfs_bmi_write(struct file *fp, struct kobject *kobj,
 
     if (index == MAX_AR6000) return 0;
 
-    if ((BMIRawWrite(ar->arHifDevice, (A_UCHAR*)buf, count)) != 0) {
+    if ((BMIRawWrite(ar->arHifDevice, (u8*)buf, count)) != 0) {
         return 0;
     }
 
@@ -900,7 +900,7 @@ ar6000_sysfs_bmi_deinit(AR_SOFTC_T *ar)
 #define AR6002_MAC_ADDRESS_OFFSET     0x0A
 #define AR6003_MAC_ADDRESS_OFFSET     0x16
 static
-void calculate_crc(u32 TargetType, A_UCHAR *eeprom_data)
+void calculate_crc(u32 TargetType, u8 *eeprom_data)
 {
     u16 *ptr_crc;
     u16 *ptr16_eeprom;
@@ -916,12 +916,12 @@ void calculate_crc(u32 TargetType, A_UCHAR *eeprom_data)
     else if (TargetType == TARGET_TYPE_AR6003)
     {
         eeprom_size = 1024;
-        ptr_crc = (u16 *)((A_UCHAR *)eeprom_data + 0x04);
+        ptr_crc = (u16 *)((u8 *)eeprom_data + 0x04);
     }
     else
     {
         eeprom_size = 768;
-        ptr_crc = (u16 *)((A_UCHAR *)eeprom_data + 0x04);
+        ptr_crc = (u16 *)((u8 *)eeprom_data + 0x04);
     }
 
 
@@ -941,17 +941,17 @@ void calculate_crc(u32 TargetType, A_UCHAR *eeprom_data)
 }
 
 static void 
-ar6000_softmac_update(AR_SOFTC_T *ar, A_UCHAR *eeprom_data, size_t size)
+ar6000_softmac_update(AR_SOFTC_T *ar, u8 *eeprom_data, size_t size)
 {
     const char *source = "random generated";
     const struct firmware *softmac_entry;
-    A_UCHAR *ptr_mac;
+    u8 *ptr_mac;
     switch (ar->arTargetType) {
     case TARGET_TYPE_AR6002:
-        ptr_mac = (u8 *)((A_UCHAR *)eeprom_data + AR6002_MAC_ADDRESS_OFFSET);
+        ptr_mac = (u8 *)((u8 *)eeprom_data + AR6002_MAC_ADDRESS_OFFSET);
         break;
     case TARGET_TYPE_AR6003:
-        ptr_mac = (u8 *)((A_UCHAR *)eeprom_data + AR6003_MAC_ADDRESS_OFFSET);
+        ptr_mac = (u8 *)((u8 *)eeprom_data + AR6003_MAC_ADDRESS_OFFSET);
         break;
     default:
 	AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Invalid Target Type\n"));
@@ -1097,7 +1097,7 @@ ar6000_transfer_bin_file(AR_SOFTC_T *ar, AR6K_BIN_FILE file, u32 address, bool c
 
 #ifdef SOFTMAC_FILE_USED
     if (file==AR6K_BOARD_DATA_FILE && fw_entry->data) {
-        ar6000_softmac_update(ar, (A_UCHAR *)fw_entry->data, fw_entry->size);
+        ar6000_softmac_update(ar, (u8 *)fw_entry->data, fw_entry->size);
     }
 #endif 
 
@@ -1117,14 +1117,14 @@ ar6000_transfer_bin_file(AR_SOFTC_T *ar, AR6K_BIN_FILE file, u32 address, bool c
                           (((ar)->arTargetType == TARGET_TYPE_AR6003) ? AR6003_BOARD_DATA_SZ : 0));
         
         /* Determine where in Target RAM to write Board Data */
-        bmifn(BMIReadMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_ext_data), (A_UCHAR *)&board_ext_address, 4));
+        bmifn(BMIReadMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_ext_data), (u8 *)&board_ext_address, 4));
         AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("Board extended Data download address: 0x%x\n", board_ext_address));
 
         /* check whether the target has allocated memory for extended board data and file contains extended board data */
         if ((board_ext_address) && (fw_entry->size == (board_data_size + board_ext_data_size))) {
             u32 param;
 
-            status = BMIWriteMemory(ar->arHifDevice, board_ext_address, (A_UCHAR *)(fw_entry->data + board_data_size), board_ext_data_size);
+            status = BMIWriteMemory(ar->arHifDevice, board_ext_address, (u8 *)(fw_entry->data + board_data_size), board_ext_data_size);
 
             if (status) {
                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("BMI operation failed: %d\n", __LINE__));
@@ -1134,15 +1134,15 @@ ar6000_transfer_bin_file(AR_SOFTC_T *ar, AR6K_BIN_FILE file, u32 address, bool c
 
             /* Record the fact that extended board Data IS initialized */
             param = 1;
-            bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_ext_data_initialized), (A_UCHAR *)&param, 4));
+            bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_ext_data_initialized), (u8 *)&param, 4));
         }
         fw_entry_size = board_data_size;
     }
 
     if (compressed) {
-        status = BMIFastDownload(ar->arHifDevice, address, (A_UCHAR *)fw_entry->data, fw_entry_size);
+        status = BMIFastDownload(ar->arHifDevice, address, (u8 *)fw_entry->data, fw_entry_size);
     } else {
-        status = BMIWriteMemory(ar->arHifDevice, address, (A_UCHAR *)fw_entry->data, fw_entry_size);
+        status = BMIWriteMemory(ar->arHifDevice, address, (u8 *)fw_entry->data, fw_entry_size);
     }
 
     if (status) {
@@ -1163,13 +1163,13 @@ ar6000_update_bdaddr(AR_SOFTC_T *ar)
             u32 address;
 
            if (BMIReadMemory(ar->arHifDevice,
-		HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_data), (A_UCHAR *)&address, 4) != 0)
+		HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_data), (u8 *)&address, 4) != 0)
            {
     	      	AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIReadMemory for hi_board_data failed\n"));
            	return A_ERROR;
            }
 
-           if (BMIReadMemory(ar->arHifDevice, address + BDATA_BDADDR_OFFSET, (A_UCHAR *)ar->bdaddr, 6) != 0)
+           if (BMIReadMemory(ar->arHifDevice, address + BDATA_BDADDR_OFFSET, (u8 *)ar->bdaddr, 6) != 0)
            {
     	    	AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIReadMemory for BD address failed\n"));
            	return A_ERROR;
@@ -1234,7 +1234,7 @@ ar6000_sysfs_bmi_get_config(AR_SOFTC_T *ar, u32 mode)
 
         param = 0;
         if (ar->arTargetType == TARGET_TYPE_AR6002) {
-            bmifn(BMIReadMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_ext_clk_detected), (A_UCHAR *)&param, 4));
+            bmifn(BMIReadMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_ext_clk_detected), (u8 *)&param, 4));
         }
 
         /* LPO_CAL.ENABLE = 1 if no external clk is detected */
@@ -1267,7 +1267,7 @@ ar6000_sysfs_bmi_get_config(AR_SOFTC_T *ar, u32 mode)
         if (ar->arTargetType == TARGET_TYPE_AR6003) {
             /* hi_ext_clk_detected = 0 */
             param = 0;
-            bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_ext_clk_detected), (A_UCHAR *)&param, 4));
+            bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_ext_clk_detected), (u8 *)&param, 4));
 
             /* CLOCK_CONTROL &= ~LF_CLK32 */
             address = RTC_BASE_ADDRESS + CLOCK_CONTROL_ADDRESS;
@@ -1280,7 +1280,7 @@ ar6000_sysfs_bmi_get_config(AR_SOFTC_T *ar, u32 mode)
         /* Transfer Board Data from Target EEPROM to Target RAM */
         if (ar->arTargetType == TARGET_TYPE_AR6003) {
             /* Determine where in Target RAM to write Board Data */
-            bmifn(BMIReadMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_data), (A_UCHAR *)&address, 4));
+            bmifn(BMIReadMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_data), (u8 *)&address, 4));
             AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("Board Data download address: 0x%x\n", address));
 
             /* Write EEPROM data to Target RAM */
@@ -1290,7 +1290,7 @@ ar6000_sysfs_bmi_get_config(AR_SOFTC_T *ar, u32 mode)
 
             /* Record the fact that Board Data IS initialized */
             param = 1;
-            bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_data_initialized), (A_UCHAR *)&param, 4));
+            bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_data_initialized), (u8 *)&param, 4));
 
             /* Transfer One time Programmable data */
             AR6K_DATA_DOWNLOAD_ADDRESS(address, ar->arVersion.target_ver);
@@ -1325,7 +1325,7 @@ ar6000_sysfs_bmi_get_config(AR_SOFTC_T *ar, u32 mode)
         }
 
         param = address;
-        bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_dset_list_head), (A_UCHAR *)&param, 4));
+        bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_dset_list_head), (u8 *)&param, 4));
 
         if (ar->arTargetType == TARGET_TYPE_AR6003) {
             if (ar->arVersion.target_ver == AR6003_REV1_VERSION) {
@@ -1335,7 +1335,7 @@ ar6000_sysfs_bmi_get_config(AR_SOFTC_T *ar, u32 mode)
                 /* Reserve 6.5K of RAM */
                 param = 6656;
             }
-            bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_end_RAM_reserve_sz), (A_UCHAR *)&param, 4));
+            bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_end_RAM_reserve_sz), (u8 *)&param, 4));
         }
 
         /* Restore system sleep */
@@ -1352,7 +1352,7 @@ ar6000_sysfs_bmi_get_config(AR_SOFTC_T *ar, u32 mode)
 #define CONFIG_AR600x_DEBUG_UART_TX_PIN 8
 #endif
             param = CONFIG_AR600x_DEBUG_UART_TX_PIN;
-            bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_dbg_uart_txpin), (A_UCHAR *)&param, 4));
+            bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_dbg_uart_txpin), (u8 *)&param, 4));
 
 #if (CONFIG_AR600x_DEBUG_UART_TX_PIN == 23)
             {
@@ -1367,7 +1367,7 @@ ar6000_sysfs_bmi_get_config(AR_SOFTC_T *ar, u32 mode)
 #ifdef ATH6KL_CONFIG_GPIO_BT_RESET
 #define CONFIG_AR600x_BT_RESET_PIN	0x16
             param = CONFIG_AR600x_BT_RESET_PIN;
-            bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_hci_uart_support_pins), (A_UCHAR *)&param, 4));
+            bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_hci_uart_support_pins), (u8 *)&param, 4));
 #endif /* ATH6KL_CONFIG_GPIO_BT_RESET */
 
             /* Configure UART flow control polarity */
@@ -1378,7 +1378,7 @@ ar6000_sysfs_bmi_get_config(AR_SOFTC_T *ar, u32 mode)
 #if (CONFIG_ATH6KL_BT_UART_FC_POLARITY == 1)
             if (ar->arVersion.target_ver == AR6003_REV2_VERSION) {
                 param = ((CONFIG_ATH6KL_BT_UART_FC_POLARITY << 1) & 0x2);
-                bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_hci_uart_pwr_mgmt_params), (A_UCHAR *)&param, 4));
+                bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_hci_uart_pwr_mgmt_params), (u8 *)&param, 4));
             }
 #endif /* CONFIG_ATH6KL_BT_UART_FC_POLARITY */
         }
@@ -1405,7 +1405,7 @@ ar6000_configure_target(AR_SOFTC_T *ar)
         param = 1;
         if (BMIWriteMemory(ar->arHifDevice,
                            HOST_INTEREST_ITEM_ADDRESS(ar, hi_serial_enable),
-                           (A_UCHAR *)&param,
+                           (u8 *)&param,
                            4)!= 0)
         {
              AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIWriteMemory for enableuartprint failed \n"));
@@ -1418,7 +1418,7 @@ ar6000_configure_target(AR_SOFTC_T *ar)
     param = HTC_PROTOCOL_VERSION;
     if (BMIWriteMemory(ar->arHifDevice,
                        HOST_INTEREST_ITEM_ADDRESS(ar, hi_app_host_interest),
-                       (A_UCHAR *)&param,
+                       (u8 *)&param,
                        4)!= 0)
     {
          AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIWriteMemory for htc version failed \n"));
@@ -1437,7 +1437,7 @@ ar6000_configure_target(AR_SOFTC_T *ar)
 
         if (BMIReadMemory(ar->arHifDevice,
             HOST_INTEREST_ITEM_ADDRESS(ar, hi_option_flag),
-            (A_UCHAR *)&param,
+            (u8 *)&param,
             4)!= 0)
         {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIReadMemory for enabletimerwar failed \n"));
@@ -1448,7 +1448,7 @@ ar6000_configure_target(AR_SOFTC_T *ar)
 
         if (BMIWriteMemory(ar->arHifDevice,
             HOST_INTEREST_ITEM_ADDRESS(ar, hi_option_flag),
-            (A_UCHAR *)&param,
+            (u8 *)&param,
             4) != 0)
         {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIWriteMemory for enabletimerwar failed \n"));
@@ -1463,7 +1463,7 @@ ar6000_configure_target(AR_SOFTC_T *ar)
 
         if (BMIReadMemory(ar->arHifDevice,
             HOST_INTEREST_ITEM_ADDRESS(ar, hi_option_flag),
-            (A_UCHAR *)&param,
+            (u8 *)&param,
             4)!= 0)
         {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIReadMemory for setting fwmode failed \n"));
@@ -1474,7 +1474,7 @@ ar6000_configure_target(AR_SOFTC_T *ar)
 
         if (BMIWriteMemory(ar->arHifDevice,
             HOST_INTEREST_ITEM_ADDRESS(ar, hi_option_flag),
-            (A_UCHAR *)&param,
+            (u8 *)&param,
             4) != 0)
         {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIWriteMemory for setting fwmode failed \n"));
@@ -1489,7 +1489,7 @@ ar6000_configure_target(AR_SOFTC_T *ar)
 
         if (BMIReadMemory(ar->arHifDevice,
             HOST_INTEREST_ITEM_ADDRESS(ar, hi_option_flag),
-            (A_UCHAR *)&param,
+            (u8 *)&param,
             4)!= 0)
         {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIReadMemory for disabling debug logs failed\n"));
@@ -1500,7 +1500,7 @@ ar6000_configure_target(AR_SOFTC_T *ar)
 
         if (BMIWriteMemory(ar->arHifDevice,
             HOST_INTEREST_ITEM_ADDRESS(ar, hi_option_flag),
-            (A_UCHAR *)&param,
+            (u8 *)&param,
             4) != 0)
         {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIWriteMemory for HI_OPTION_DISABLE_DBGLOG\n"));
@@ -1522,7 +1522,7 @@ ar6000_configure_target(AR_SOFTC_T *ar)
         param = AR6003_BOARD_EXT_DATA_ADDRESS; 
         if (BMIWriteMemory(ar->arHifDevice,
             HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_ext_data),
-            (A_UCHAR *)&param,
+            (u8 *)&param,
             4) != 0)
         {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIWriteMemory for hi_board_ext_data failed \n"));
diff --git a/drivers/staging/ath6kl/os/linux/eeprom.c b/drivers/staging/ath6kl/os/linux/eeprom.c
index 7d7a63d..7d049df 100644
--- a/drivers/staging/ath6kl/os/linux/eeprom.c
+++ b/drivers/staging/ath6kl/os/linux/eeprom.c
@@ -53,7 +53,7 @@ char *p_mac = NULL;
 // static variables
 //
 
-static A_UCHAR eeprom_data[EEPROM_SZ];
+static u8 eeprom_data[EEPROM_SZ];
 static u32 sys_sleep_reg;
 static HIF_DEVICE *p_bmi_device;
 
@@ -143,14 +143,14 @@ BMI_write_reg(u32 address, u32 value)
 inline void
 BMI_read_mem(u32 address, u32 *pvalue)
 {
-    BMIReadMemory(p_bmi_device, address, (A_UCHAR*)(pvalue), 4);
+    BMIReadMemory(p_bmi_device, address, (u8*)(pvalue), 4);
 }
 
 /* Write a word to a Target memory. */
 inline void
 BMI_write_mem(u32 address, u8 *p_data, u32 sz)
 {
-    BMIWriteMemory(p_bmi_device, address, (A_UCHAR*)(p_data), sz); 
+    BMIWriteMemory(p_bmi_device, address, (u8*)(p_data), sz); 
 }
 
 /*
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index f3b7344..0beba09 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -553,7 +553,7 @@ typedef struct ar6_softc {
     COMMON_CREDIT_STATE_INFO arCreditStateInfo;
     bool                  arWMIControlEpFull;
     bool                  dbgLogFetchInProgress;
-    A_UCHAR                 log_buffer[DBGLOG_HOST_LOG_BUFFER_SIZE];
+    u8                 log_buffer[DBGLOG_HOST_LOG_BUFFER_SIZE];
     u32 log_cnt;
     u32 dbglog_init_done;
     u32 arConnectCtrlFlags;
diff --git a/drivers/staging/ath6kl/os/linux/include/athtypes_linux.h b/drivers/staging/ath6kl/os/linux/include/athtypes_linux.h
index 32bd29b..8cb5632 100644
--- a/drivers/staging/ath6kl/os/linux/include/athtypes_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/athtypes_linux.h
@@ -45,7 +45,6 @@ typedef u_int32_t    A_UINT32;
 typedef u_int64_t    A_UINT64;
 
 typedef char            A_CHAR;
-typedef unsigned char   A_UCHAR;
 typedef unsigned long   A_ATH_TIMER;
 
 
diff --git a/drivers/staging/ath6kl/os/linux/ioctl.c b/drivers/staging/ath6kl/os/linux/ioctl.c
index a95b743..1824475 100644
--- a/drivers/staging/ath6kl/os/linux/ioctl.c
+++ b/drivers/staging/ath6kl/os/linux/ioctl.c
@@ -702,8 +702,8 @@ ar6000_ioctl_tcmd_get_rx_report(struct net_device *dev,
     buf[1] = ar->tcmdRxRssi;
     buf[2] = ar->tcmdRxcrcErrPkt;
     buf[3] = ar->tcmdRxsecErrPkt;
-    memcpy(((A_UCHAR *)buf)+(4*sizeof(u32)), ar->tcmdRateCnt, sizeof(ar->tcmdRateCnt));
-    memcpy(((A_UCHAR *)buf)+(4*sizeof(u32))+(TCMD_MAX_RATES *sizeof(u16)), ar->tcmdRateCntShortGuard, sizeof(ar->tcmdRateCntShortGuard));
+    memcpy(((u8 *)buf)+(4*sizeof(u32)), ar->tcmdRateCnt, sizeof(ar->tcmdRateCnt));
+    memcpy(((u8 *)buf)+(4*sizeof(u32))+(TCMD_MAX_RATES *sizeof(u16)), ar->tcmdRateCntShortGuard, sizeof(ar->tcmdRateCntShortGuard));
 
     if (!ret && copy_to_user(rq->ifr_data, buf, sizeof(buf))) {
         ret = -EFAULT;
diff --git a/drivers/staging/ath6kl/wlan/src/wlan_node.c b/drivers/staging/ath6kl/wlan/src/wlan_node.c
index 0edf9c1..83c4dc3 100644
--- a/drivers/staging/ath6kl/wlan/src/wlan_node.c
+++ b/drivers/staging/ath6kl/wlan/src/wlan_node.c
@@ -432,11 +432,11 @@ wlan_node_table_cleanup(struct ieee80211_node_table *nt)
 }
 
 bss_t *
-wlan_find_Ssidnode (struct ieee80211_node_table *nt, A_UCHAR *pSsid,
+wlan_find_Ssidnode (struct ieee80211_node_table *nt, u8 *pSsid,
                     u32 ssidLength, bool bIsWPA2, bool bMatchSSID)
 {
     bss_t   *ni = NULL;
-    A_UCHAR *pIESsid = NULL;
+    u8 *pIESsid = NULL;
 
     IEEE80211_NODE_LOCK (nt);
 
@@ -554,13 +554,13 @@ wlan_node_remove(struct ieee80211_node_table *nt, u8 *bssid)
 }
 
 bss_t *
-wlan_find_matching_Ssidnode (struct ieee80211_node_table *nt, A_UCHAR *pSsid,
+wlan_find_matching_Ssidnode (struct ieee80211_node_table *nt, u8 *pSsid,
                     u32 ssidLength, u32 dot11AuthMode, u32 authMode,
                    u32 pairwiseCryptoType, u32 grpwiseCryptoTyp)
 {
     bss_t   *ni = NULL;
     bss_t   *best_ni = NULL;
-    A_UCHAR *pIESsid = NULL;
+    u8 *pIESsid = NULL;
 
     IEEE80211_NODE_LOCK (nt);
 
diff --git a/drivers/staging/ath6kl/wmi/wmi.c b/drivers/staging/ath6kl/wmi/wmi.c
index bf9dd0b..80ba629 100644
--- a/drivers/staging/ath6kl/wmi/wmi.c
+++ b/drivers/staging/ath6kl/wmi/wmi.c
@@ -1421,8 +1421,8 @@ wmi_bssInfo_event_rx(struct wmi_t *wmip, u8 *datap, int len)
     WMI_BSS_INFO_HDR *bih;
     u8 *buf;
     u32 nodeCachingAllowed = 1;
-    A_UCHAR cached_ssid_len = 0;
-    A_UCHAR cached_ssid_buf[IEEE80211_NWID_LEN] = {0};
+    u8 cached_ssid_len = 0;
+    u8 cached_ssid_buf[IEEE80211_NWID_LEN] = {0};
     u8 beacon_ssid_len = 0;
 
     if (len <= sizeof(WMI_BSS_INFO_HDR)) {
@@ -1477,7 +1477,7 @@ wmi_bssInfo_event_rx(struct wmi_t *wmip, u8 *datap, int len)
          * so cache the probe-resp-ssid if already present. */
         if ((true == is_probe_ssid) && (BEACON_FTYPE == bih->frameType))
         {
-            A_UCHAR *ie_ssid;
+            u8 *ie_ssid;
 
             ie_ssid = bss->ni_cie.ie_ssid;
             if(ie_ssid && (ie_ssid[1] <= IEEE80211_NWID_LEN) && (ie_ssid[2] != 0))
@@ -2420,7 +2420,7 @@ wmi_connect_cmd(struct wmi_t *wmip, NETWORK_TYPE netType,
                 DOT11_AUTH_MODE dot11AuthMode, AUTH_MODE authMode,
                 CRYPTO_TYPE pairwiseCrypto, u8 pairwiseCryptoLen,
                 CRYPTO_TYPE groupCrypto, u8 groupCryptoLen,
-                int ssidLength, A_UCHAR *ssid,
+                int ssidLength, u8 *ssid,
                 u8 *bssid, u16 channel, u32 ctrl_flags)
 {
     void *osbuf;
@@ -2616,7 +2616,7 @@ wmi_bssfilter_cmd(struct wmi_t *wmip, u8 filter, u32 ieMask)
 
 int
 wmi_probedSsid_cmd(struct wmi_t *wmip, u8 index, u8 flag,
-                   u8 ssidLength, A_UCHAR *ssid)
+                   u8 ssidLength, u8 *ssid)
 {
     void *osbuf;
     WMI_PROBED_SSID_CMD *cmd;
@@ -4844,7 +4844,7 @@ wmi_set_wmm_txop(struct wmi_t *wmip, WMI_TXOP_CFG cfg)
 }
 
 int
-wmi_set_country(struct wmi_t *wmip, A_UCHAR *countryCode)
+wmi_set_country(struct wmi_t *wmip, u8 *countryCode)
 {
     void *osbuf;
     WMI_AP_SET_COUNTRY_CMD *cmd;
@@ -5374,7 +5374,7 @@ wmi_set_nodeage(struct wmi_t *wmip, u32 nodeAge)
 }
 
 bss_t *
-wmi_find_Ssidnode (struct wmi_t *wmip, A_UCHAR *pSsid,
+wmi_find_Ssidnode (struct wmi_t *wmip, u8 *pSsid,
                    u32 ssidLength, bool bIsWPA2, bool bMatchSSID)
 {
     bss_t *node = NULL;
@@ -6652,7 +6652,7 @@ wmi_SGI_cmd(struct wmi_t *wmip, u32 sgiMask, u8 sgiPERThreshold)
 }
 
 bss_t *
-wmi_find_matching_Ssidnode (struct wmi_t *wmip, A_UCHAR *pSsid,
+wmi_find_matching_Ssidnode (struct wmi_t *wmip, u8 *pSsid,
                    u32 ssidLength,
                    u32 dot11AuthMode, u32 authMode,
                    u32 pairwiseCryptoType, u32 grpwiseCryptoTyp)
-- 
1.7.4.15.g7811d

