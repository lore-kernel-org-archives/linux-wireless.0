Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:41352 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab1EDPuu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 11:50:50 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 08:50:22 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<Vipin.Mehta@Atheros.com>, <Naveen.Singh@Atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 2/2] ath6kl: Merge Bootloader Management Interface (BMI) related header files into one
Date: Wed, 4 May 2011 21:28:11 +0530
Message-ID: <1304524691-12652-2-git-send-email-vasanth@atheros.com> (sfid-20110504_175054_865230_B9D54AA4)
In-Reply-To: <1304524691-12652-1-git-send-email-vasanth@atheros.com>
References: <1304524691-12652-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/staging/ath6kl/Makefile                   |    2 +-
 drivers/staging/ath6kl/bmi/bmi.h                  |  338 +++++++++++++++++++++
 drivers/staging/ath6kl/bmi/include/bmi_internal.h |   54 ----
 drivers/staging/ath6kl/bmi/src/bmi.c              |  109 ++++----
 drivers/staging/ath6kl/htc2/htc_internal.h        |    3 +-
 drivers/staging/ath6kl/include/bmi.h              |  134 --------
 drivers/staging/ath6kl/include/common/bmi_msg.h   |  233 --------------
 drivers/staging/ath6kl/miscdrv/common_drv.c       |   26 +-
 drivers/staging/ath6kl/os/linux/ar6000_drv.c      |  138 +++++-----
 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c   |    6 +-
 10 files changed, 480 insertions(+), 563 deletions(-)
 create mode 100644 drivers/staging/ath6kl/bmi/bmi.h
 delete mode 100644 drivers/staging/ath6kl/bmi/include/bmi_internal.h
 delete mode 100644 drivers/staging/ath6kl/include/bmi.h
 delete mode 100644 drivers/staging/ath6kl/include/common/bmi_msg.h

diff --git a/drivers/staging/ath6kl/Makefile b/drivers/staging/ath6kl/Makefile
index 1d3f239..b58c622 100644
--- a/drivers/staging/ath6kl/Makefile
+++ b/drivers/staging/ath6kl/Makefile
@@ -26,7 +26,7 @@ ccflags-y += -I$(obj)/include/common
 ccflags-y += -I$(obj)/wlan/include
 ccflags-y += -I$(obj)/os/linux/include
 ccflags-y += -I$(obj)/os
-ccflags-y += -I$(obj)/bmi/include
+ccflags-y += -I$(obj)/bmi
 ccflags-y += -I$(obj)/include/common/AR6002/hw4.0
 
 ifeq ($(CONFIG_AR600x_DUAL_ANTENNA),y)
diff --git a/drivers/staging/ath6kl/bmi/bmi.h b/drivers/staging/ath6kl/bmi/bmi.h
new file mode 100644
index 0000000..0a83b1f
--- /dev/null
+++ b/drivers/staging/ath6kl/bmi/bmi.h
@@ -0,0 +1,338 @@
+/*
+ * Copyright (c) 2004-2010 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef BMI_H
+#define BMI_H
+
+#include "hif.h"
+#include "hw/mbox_wlan_host_reg.h"
+/*
+ * Bootloader Messaging Interface (BMI)
+ *
+ * BMI is a very simple messaging interface used during initialization
+ * to read memory, write memory, execute code, and to define an
+ * application entry PC.
+ *
+ * It is used to download an application to AR6K, to provide
+ * patches to code that is already resident on AR6K, and generally
+ * to examine and modify state.  The Host has an opportunity to use
+ * BMI only once during bootup.  Once the Host issues a BMI_DONE
+ * command, this opportunity ends.
+ *
+ * The Host writes BMI requests to mailbox0, and reads BMI responses
+ * from mailbox0.   BMI requests all begin with a command
+ * (see below for specific commands), and are followed by
+ * command-specific data.
+ *
+ * Flow control:
+ * The Host can only issue a command once the Target gives it a
+ * "BMI Command Credit", using AR6K Counter #4.  As soon as the
+ * Target has completed a command, it issues another BMI Command
+ * Credit (so the Host can issue the next command).
+ *
+ * BMI handles all required Target-side cache flushing.
+ */
+
+
+/* Maximum data size used for BMI transfers */
+#define BMI_DATASZ_MAX                      256
+
+/* BMI Commands */
+
+#define BMI_NO_COMMAND                      0
+
+#define BMI_DONE                            1
+        /*
+         * Semantics: Host is done using BMI
+         * Request format:
+         *    u32 command (BMI_DONE)
+         * Response format: none
+         */
+
+#define BMI_READ_MEMORY                     2
+        /*
+         * Semantics: Host reads AR6K memory
+         * Request format:
+         *    u32 command (BMI_READ_MEMORY)
+         *    u32 address
+         *    u32 length, at most BMI_DATASZ_MAX
+         * Response format:
+         *    u8 data[length]
+         */
+
+#define BMI_WRITE_MEMORY                    3
+        /*
+         * Semantics: Host writes AR6K memory
+         * Request format:
+         *    u32 command (BMI_WRITE_MEMORY)
+         *    u32 address
+         *    u32 length, at most BMI_DATASZ_MAX
+         *    u8 data[length]
+         * Response format: none
+         */
+
+#define BMI_EXECUTE                         4
+        /*
+         * Semantics: Causes AR6K to execute code
+         * Request format:
+         *    u32 command (BMI_EXECUTE)
+         *    u32 address
+         *    u32 parameter
+         * Response format:
+         *    u32 return value
+         */
+
+#define BMI_SET_APP_START                   5
+        /*
+         * Semantics: Set Target application starting address
+         * Request format:
+         *    u32 command (BMI_SET_APP_START)
+         *    u32 address
+         * Response format: none
+         */
+
+#define BMI_READ_SOC_REGISTER               6
+        /*
+         * Semantics: Read a 32-bit Target SOC register.
+         * Request format:
+         *    u32 command (BMI_READ_REGISTER)
+         *    u32 address
+         * Response format:
+         *    u32 value
+         */
+
+#define BMI_WRITE_SOC_REGISTER              7
+        /*
+         * Semantics: Write a 32-bit Target SOC register.
+         * Request format:
+         *    u32 command (BMI_WRITE_REGISTER)
+         *    u32 address
+         *    u32 value
+         *
+         * Response format: none
+         */
+
+#define BMI_GET_TARGET_ID                  8
+#define BMI_GET_TARGET_INFO                8
+        /*
+         * Semantics: Fetch the 4-byte Target information
+         * Request format:
+         *    u32 command (BMI_GET_TARGET_ID/INFO)
+         * Response format1 (old firmware):
+         *    u32 TargetVersionID
+         * Response format2 (newer firmware):
+         *    u32 TARGET_VERSION_SENTINAL
+         *    struct bmi_target_info;
+         */
+
+#define TARGET_VERSION_SENTINAL 0xffffffff
+#define TARGET_TYPE_AR6001 1
+#define TARGET_TYPE_AR6002 2
+#define TARGET_TYPE_AR6003 3
+
+
+#define BMI_ROMPATCH_INSTALL               9
+        /*
+         * Semantics: Install a ROM Patch.
+         * Request format:
+         *    u32 command (BMI_ROMPATCH_INSTALL)
+         *    u32 Target ROM Address
+         *    u32 Target RAM Address or Value (depending on Target Type)
+         *    u32 Size, in bytes
+         *    u32 Activate? 1-->activate;
+         *                            0-->install but do not activate
+         * Response format:
+         *    u32 PatchID
+         */
+
+#define BMI_ROMPATCH_UNINSTALL             10
+        /*
+         * Semantics: Uninstall a previously-installed ROM Patch,
+         * automatically deactivating, if necessary.
+         * Request format:
+         *    u32 command (BMI_ROMPATCH_UNINSTALL)
+         *    u32 PatchID
+         *
+         * Response format: none
+         */
+
+#define BMI_ROMPATCH_ACTIVATE              11
+        /*
+         * Semantics: Activate a list of previously-installed ROM Patches.
+         * Request format:
+         *    u32 command (BMI_ROMPATCH_ACTIVATE)
+         *    u32 rompatch_count
+         *    u32 PatchID[rompatch_count]
+         *
+         * Response format: none
+         */
+
+#define BMI_ROMPATCH_DEACTIVATE            12
+        /*
+         * Semantics: Deactivate a list of active ROM Patches.
+         * Request format:
+         *    u32 command (BMI_ROMPATCH_DEACTIVATE)
+         *    u32 rompatch_count
+         *    u32 PatchID[rompatch_count]
+         *
+         * Response format: none
+         */
+
+
+#define BMI_LZ_STREAM_START                13
+        /*
+         * Semantics: Begin an LZ-compressed stream of input
+         * which is to be uncompressed by the Target to an
+         * output buffer at address.  The output buffer must
+         * be sufficiently large to hold the uncompressed
+         * output from the compressed input stream.  This BMI
+         * command should be followed by a series of 1 or more
+         * BMI_LZ_DATA commands.
+         *    u32 command (BMI_LZ_STREAM_START)
+         *    u32 address
+         * Note: Not supported on all versions of ROM firmware.
+         */
+
+#define BMI_LZ_DATA                        14
+        /*
+         * Semantics: Host writes AR6K memory with LZ-compressed
+         * data which is uncompressed by the Target.  This command
+         * must be preceded by a BMI_LZ_STREAM_START command. A series
+         * of BMI_LZ_DATA commands are considered part of a single
+         * input stream until another BMI_LZ_STREAM_START is issued.
+         * Request format:
+         *    u32 command (BMI_LZ_DATA)
+         *    u32 length (of compressed data),
+         *                  at most BMI_DATASZ_MAX
+         *    u8 CompressedData[length]
+         * Response format: none
+         * Note: Not supported on all versions of ROM firmware.
+         */
+
+#define ATH_DEBUG_BMI  ATH_DEBUG_MAKE_MODULE_MASK(0)
+
+
+#define BMI_COMMUNICATION_TIMEOUT       100000
+
+struct bmi_target_info {
+	u32 target_info_byte_count; /* size of this structure */
+	u32 target_ver;             /* Target Version ID */
+	u32 target_type;            /* Target type */
+} __packed;
+
+void
+bmi_init(void);
+
+void
+bmi_cleanup(void);
+
+int
+bmi_done(struct hif_device *device);
+
+int
+bmi_get_target_info(struct hif_device *device, struct bmi_target_info *targ_info);
+
+int
+bmi_read_memory(struct hif_device *device,
+              u32 address,
+              u8 *buffer,
+              u32 length);
+
+int
+bmi_write_memory(struct hif_device *device,
+               u32 address,
+               u8 *buffer,
+               u32 length);
+
+int
+bmi_execute(struct hif_device *device,
+           u32 address,
+           u32 *param);
+
+int
+bmi_set_app_start(struct hif_device *device,
+               u32 address);
+
+int
+bmi_read_soc_register(struct hif_device *device,
+                   u32 address,
+                   u32 *param);
+
+int
+bmi_write_soc_register(struct hif_device *device,
+                    u32 address,
+                    u32 param);
+
+int
+bmi_rom_patch_install(struct hif_device *device,
+                   u32 ROM_addr,
+                   u32 RAM_addr,
+                   u32 nbytes,
+                   u32 do_activate,
+                   u32 *patch_id);
+
+int
+bmi_rom_patch_uninstall(struct hif_device *device,
+                     u32 rompatch_id);
+
+int
+bmi_rom_patch_activate(struct hif_device *device,
+                    u32 rompatch_count,
+                    u32 *rompatch_list);
+
+int
+bmi_rom_patch_deactivate(struct hif_device *device,
+                      u32 rompatch_count,
+                      u32 *rompatch_list);
+
+int
+bmi_lz_stream_start(struct hif_device *device,
+                 u32 address);
+
+int
+bmi_lz_data(struct hif_device *device,
+          u8 *buffer,
+          u32 length);
+
+int
+bmi_fast_download(struct hif_device *device,
+                u32 address,
+                u8 *buffer,
+                u32 length);
+
+int
+bmi_raw_write(struct hif_device *device,
+            u8 *buffer,
+            u32 length);
+
+int
+bmi_raw_read(struct hif_device *device,
+           u8 *buffer,
+           u32 length,
+           bool want_timeout);
+
+int
+bmi_send_buf(struct hif_device *device,
+              u8 *buffer,
+              u32 length);
+
+int
+bmi_recv_buf(struct hif_device *device,
+                 u8 *buffer,
+                 u32 length,
+                 bool want_timeout);
+
+#endif
diff --git a/drivers/staging/ath6kl/bmi/include/bmi_internal.h b/drivers/staging/ath6kl/bmi/include/bmi_internal.h
deleted file mode 100644
index 8e25770..0000000
--- a/drivers/staging/ath6kl/bmi/include/bmi_internal.h
+++ /dev/null
@@ -1,54 +0,0 @@
-//------------------------------------------------------------------------------
-// Copyright (c) 2004-2010 Atheros Communications Inc.
-// All rights reserved.
-// 
-//
-// Permission to use, copy, modify, and/or distribute this software for any
-// purpose with or without fee is hereby granted, provided that the above
-// copyright notice and this permission notice appear in all copies.
-//
-// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
-// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
-// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
-//
-//
-//------------------------------------------------------------------------------
-//==============================================================================
-//
-// Author(s): ="Atheros"
-//==============================================================================
-#ifndef BMI_INTERNAL_H
-#define BMI_INTERNAL_H
-
-#include "a_config.h"
-#include "athdefs.h"
-#include "a_osapi.h"
-#define ATH_MODULE_NAME bmi
-#include "a_debug.h"
-#include "hw/mbox_host_reg.h"
-#include "bmi_msg.h"
-
-#define ATH_DEBUG_BMI  ATH_DEBUG_MAKE_MODULE_MASK(0)
-
-
-#define BMI_COMMUNICATION_TIMEOUT       100000
-
-/* ------ Global Variable Declarations ------- */
-static bool bmiDone;
-
-int
-bmiBufferSend(struct hif_device *device,
-              u8 *buffer,
-              u32 length);
-
-int
-bmiBufferReceive(struct hif_device *device,
-                 u8 *buffer,
-                 u32 length,
-                 bool want_timeout);
-
-#endif
diff --git a/drivers/staging/ath6kl/bmi/src/bmi.c b/drivers/staging/ath6kl/bmi/src/bmi.c
index f1f085e..31a9900 100644
--- a/drivers/staging/ath6kl/bmi/src/bmi.c
+++ b/drivers/staging/ath6kl/bmi/src/bmi.c
@@ -27,16 +27,19 @@
 #include <string.h>
 #endif
 
-#include "hif.h"
 #include "bmi.h"
 #include "htc_api.h"
-#include "bmi_internal.h"
+#include "a_debug.h"
+
+#define ATH_MODULE_NAME bmi
 
 #ifdef ATH_DEBUG_MODULE
 static struct ath_debug_mask_description bmi_debug_desc[] = {
     { ATH_DEBUG_BMI , "BMI Tracing"},
 };
 
+bool bmiDone;
+
 ATH_DEBUG_INSTANTIATE_MODULE_VAR(bmi,
                                  "bmi",
                                  "Boot Manager Interface",
@@ -64,7 +67,7 @@ static u8 *pBMICmdBuf;
     
 /* APIs visible to the driver */
 void
-BMIInit(void)
+bmi_init(void)
 {
     bmiDone = false;
     pendingEventsFuncCheck = false;
@@ -92,7 +95,7 @@ BMIInit(void)
 }
 
 void
-BMICleanup(void)
+bmi_cleanup(void)
 {
     if (pBMICmdCredits) {
         kfree(pBMICmdCredits);
@@ -106,13 +109,13 @@ BMICleanup(void)
 }
 
 int
-BMIDone(struct hif_device *device)
+bmi_done(struct hif_device *device)
 {
     int status;
     u32 cid;
 
     if (bmiDone) {
-        AR_DEBUG_PRINTF (ATH_DEBUG_BMI, ("BMIDone skipped\n"));
+        AR_DEBUG_PRINTF (ATH_DEBUG_BMI, ("bmi_done skipped\n"));
         return 0;
     }
 
@@ -120,7 +123,7 @@ BMIDone(struct hif_device *device)
     bmiDone = true;
     cid = BMI_DONE;
 
-    status = bmiBufferSend(device, (u8 *)&cid, sizeof(cid));
+    status = bmi_send_buf(device, (u8 *)&cid, sizeof(cid));
     if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to write to the device\n"));
         return A_ERROR;
@@ -142,7 +145,7 @@ BMIDone(struct hif_device *device)
 }
 
 int
-BMIGetTargetInfo(struct hif_device *device, struct bmi_target_info *targ_info)
+bmi_get_target_info(struct hif_device *device, struct bmi_target_info *targ_info)
 {
     int status;
     u32 cid;
@@ -155,13 +158,13 @@ BMIGetTargetInfo(struct hif_device *device, struct bmi_target_info *targ_info)
     AR_DEBUG_PRINTF(ATH_DEBUG_BMI, ("BMI Get Target Info: Enter (device: 0x%p)\n", device));
     cid = BMI_GET_TARGET_INFO;
 
-    status = bmiBufferSend(device, (u8 *)&cid, sizeof(cid));
+    status = bmi_send_buf(device, (u8 *)&cid, sizeof(cid));
     if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to write to the device\n"));
         return A_ERROR;
     }
 
-    status = bmiBufferReceive(device, (u8 *)&targ_info->target_ver,
+    status = bmi_recv_buf(device, (u8 *)&targ_info->target_ver,
                                                 sizeof(targ_info->target_ver), true);
     if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to read Target Version from the device\n"));
@@ -170,7 +173,7 @@ BMIGetTargetInfo(struct hif_device *device, struct bmi_target_info *targ_info)
 
     if (targ_info->target_ver == TARGET_VERSION_SENTINAL) {
         /* Determine how many bytes are in the Target's targ_info */
-        status = bmiBufferReceive(device, (u8 *)&targ_info->target_info_byte_count,
+        status = bmi_recv_buf(device, (u8 *)&targ_info->target_info_byte_count,
                                             sizeof(targ_info->target_info_byte_count), true);
         if (status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to read Target Info Byte Count from the device\n"));
@@ -184,7 +187,7 @@ BMIGetTargetInfo(struct hif_device *device, struct bmi_target_info *targ_info)
         A_ASSERT(targ_info->target_info_byte_count == sizeof(*targ_info));
 
         /* Read the remainder of the targ_info */
-        status = bmiBufferReceive(device,
+        status = bmi_recv_buf(device,
                         ((u8 *)targ_info)+sizeof(targ_info->target_info_byte_count),
                         sizeof(*targ_info)-sizeof(targ_info->target_info_byte_count), true);
         if (status) {
@@ -201,7 +204,7 @@ BMIGetTargetInfo(struct hif_device *device, struct bmi_target_info *targ_info)
 }
 
 int
-BMIReadMemory(struct hif_device *device,
+bmi_read_memory(struct hif_device *device,
               u32 address,
               u8 *buffer,
               u32 length)
@@ -238,12 +241,12 @@ BMIReadMemory(struct hif_device *device,
         memcpy(&(pBMICmdBuf[offset]), &rxlen, sizeof(rxlen));
         offset += sizeof(length);
 
-        status = bmiBufferSend(device, pBMICmdBuf, offset);
+        status = bmi_send_buf(device, pBMICmdBuf, offset);
         if (status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to write to the device\n"));
             return A_ERROR;
         }
-        status = bmiBufferReceive(device, pBMICmdBuf, rxlen, true);
+        status = bmi_recv_buf(device, pBMICmdBuf, rxlen, true);
         if (status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to read from the device\n"));
             return A_ERROR;
@@ -257,7 +260,7 @@ BMIReadMemory(struct hif_device *device,
 }
 
 int
-BMIWriteMemory(struct hif_device *device,
+bmi_write_memory(struct hif_device *device,
                u32 address,
                u8 *buffer,
                u32 length)
@@ -308,7 +311,7 @@ BMIWriteMemory(struct hif_device *device,
         offset += sizeof(txlen);
         memcpy(&(pBMICmdBuf[offset]), src, txlen);
         offset += txlen;
-        status = bmiBufferSend(device, pBMICmdBuf, offset);
+        status = bmi_send_buf(device, pBMICmdBuf, offset);
         if (status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to write to the device\n"));
             return A_ERROR;
@@ -322,7 +325,7 @@ BMIWriteMemory(struct hif_device *device,
 }
 
 int
-BMIExecute(struct hif_device *device,
+bmi_execute(struct hif_device *device,
            u32 address,
            u32 *param)
 {
@@ -351,13 +354,13 @@ BMIExecute(struct hif_device *device,
     offset += sizeof(address);
     memcpy(&(pBMICmdBuf[offset]), param, sizeof(*param));
     offset += sizeof(*param);
-    status = bmiBufferSend(device, pBMICmdBuf, offset);
+    status = bmi_send_buf(device, pBMICmdBuf, offset);
     if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to write to the device\n"));
         return A_ERROR;
     }
 
-    status = bmiBufferReceive(device, pBMICmdBuf, sizeof(*param), false);
+    status = bmi_recv_buf(device, pBMICmdBuf, sizeof(*param), false);
     if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to read from the device\n"));
         return A_ERROR;
@@ -370,7 +373,7 @@ BMIExecute(struct hif_device *device,
 }
 
 int
-BMISetAppStart(struct hif_device *device,
+bmi_set_app_start(struct hif_device *device,
                u32 address)
 {
     u32 cid;
@@ -396,7 +399,7 @@ BMISetAppStart(struct hif_device *device,
     offset += sizeof(cid);
     memcpy(&(pBMICmdBuf[offset]), &address, sizeof(address));
     offset += sizeof(address);
-    status = bmiBufferSend(device, pBMICmdBuf, offset);
+    status = bmi_send_buf(device, pBMICmdBuf, offset);
     if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to write to the device\n"));
         return A_ERROR;
@@ -407,7 +410,7 @@ BMISetAppStart(struct hif_device *device,
 }
 
 int
-BMIReadSOCRegister(struct hif_device *device,
+bmi_read_soc_register(struct hif_device *device,
                    u32 address,
                    u32 *param)
 {
@@ -435,13 +438,13 @@ BMIReadSOCRegister(struct hif_device *device,
     memcpy(&(pBMICmdBuf[offset]), &address, sizeof(address));
     offset += sizeof(address);
 
-    status = bmiBufferSend(device, pBMICmdBuf, offset);
+    status = bmi_send_buf(device, pBMICmdBuf, offset);
     if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to write to the device\n"));
         return A_ERROR;
     }
 
-    status = bmiBufferReceive(device, pBMICmdBuf, sizeof(*param), true);
+    status = bmi_recv_buf(device, pBMICmdBuf, sizeof(*param), true);
     if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to read from the device\n"));
         return A_ERROR;
@@ -453,7 +456,7 @@ BMIReadSOCRegister(struct hif_device *device,
 }
 
 int
-BMIWriteSOCRegister(struct hif_device *device,
+bmi_write_soc_register(struct hif_device *device,
                     u32 address,
                     u32 param)
 {
@@ -482,7 +485,7 @@ BMIWriteSOCRegister(struct hif_device *device,
     offset += sizeof(address);
     memcpy(&(pBMICmdBuf[offset]), &param, sizeof(param));
     offset += sizeof(param);
-    status = bmiBufferSend(device, pBMICmdBuf, offset);
+    status = bmi_send_buf(device, pBMICmdBuf, offset);
     if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to write to the device\n"));
         return A_ERROR;
@@ -493,7 +496,7 @@ BMIWriteSOCRegister(struct hif_device *device,
 }
 
 int
-BMIrompatchInstall(struct hif_device *device,
+bmi_rom_patch_install(struct hif_device *device,
                    u32 ROM_addr,
                    u32 RAM_addr,
                    u32 nbytes,
@@ -531,13 +534,13 @@ BMIrompatchInstall(struct hif_device *device,
     offset += sizeof(nbytes);
     memcpy(&(pBMICmdBuf[offset]), &do_activate, sizeof(do_activate));
     offset += sizeof(do_activate);
-    status = bmiBufferSend(device, pBMICmdBuf, offset);
+    status = bmi_send_buf(device, pBMICmdBuf, offset);
     if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to write to the device\n"));
         return A_ERROR;
     }
 
-    status = bmiBufferReceive(device, pBMICmdBuf, sizeof(*rompatch_id), true);
+    status = bmi_recv_buf(device, pBMICmdBuf, sizeof(*rompatch_id), true);
     if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to read from the device\n"));
         return A_ERROR;
@@ -549,7 +552,7 @@ BMIrompatchInstall(struct hif_device *device,
 }
 
 int
-BMIrompatchUninstall(struct hif_device *device,
+bmi_rom_patch_uninstall(struct hif_device *device,
                      u32 rompatch_id)
 {
     u32 cid;
@@ -575,7 +578,7 @@ BMIrompatchUninstall(struct hif_device *device,
     offset += sizeof(cid);
     memcpy(&(pBMICmdBuf[offset]), &rompatch_id, sizeof(rompatch_id));
     offset += sizeof(rompatch_id);
-    status = bmiBufferSend(device, pBMICmdBuf, offset);
+    status = bmi_send_buf(device, pBMICmdBuf, offset);
     if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to write to the device\n"));
         return A_ERROR;
@@ -618,7 +621,7 @@ _BMIrompatchChangeActivation(struct hif_device *device,
     length = rompatch_count * sizeof(*rompatch_list);
     memcpy(&(pBMICmdBuf[offset]), rompatch_list, length);
     offset += length;
-    status = bmiBufferSend(device, pBMICmdBuf, offset);
+    status = bmi_send_buf(device, pBMICmdBuf, offset);
     if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to write to the device\n"));
         return A_ERROR;
@@ -630,7 +633,7 @@ _BMIrompatchChangeActivation(struct hif_device *device,
 }
 
 int
-BMIrompatchActivate(struct hif_device *device,
+bmi_rom_patch_activate(struct hif_device *device,
                     u32 rompatch_count,
                     u32 *rompatch_list)
 {
@@ -638,7 +641,7 @@ BMIrompatchActivate(struct hif_device *device,
 }
 
 int
-BMIrompatchDeactivate(struct hif_device *device,
+bmi_rom_patch_deactivate(struct hif_device *device,
                       u32 rompatch_count,
                       u32 *rompatch_list)
 {
@@ -646,7 +649,7 @@ BMIrompatchDeactivate(struct hif_device *device,
 }
 
 int
-BMILZData(struct hif_device *device,
+bmi_lz_data(struct hif_device *device,
           u8 *buffer,
           u32 length)
 {
@@ -682,7 +685,7 @@ BMILZData(struct hif_device *device,
         offset += sizeof(txlen);
         memcpy(&(pBMICmdBuf[offset]), &buffer[length - remaining], txlen);
         offset += txlen;
-        status = bmiBufferSend(device, pBMICmdBuf, offset);
+        status = bmi_send_buf(device, pBMICmdBuf, offset);
         if (status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to write to the device\n"));
             return A_ERROR;
@@ -696,7 +699,7 @@ BMILZData(struct hif_device *device,
 }
 
 int
-BMILZStreamStart(struct hif_device *device,
+bmi_lz_stream_start(struct hif_device *device,
                  u32 address)
 {
     u32 cid;
@@ -721,7 +724,7 @@ BMILZStreamStart(struct hif_device *device,
     offset += sizeof(cid);
     memcpy(&(pBMICmdBuf[offset]), &address, sizeof(address));
     offset += sizeof(address);
-    status = bmiBufferSend(device, pBMICmdBuf, offset);
+    status = bmi_send_buf(device, pBMICmdBuf, offset);
     if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unable to Start LZ Stream to the device\n"));
         return A_ERROR;
@@ -734,7 +737,7 @@ BMILZStreamStart(struct hif_device *device,
 
 /* BMI Access routines */
 int
-bmiBufferSend(struct hif_device *device,
+bmi_send_buf(struct hif_device *device,
               u8 *buffer,
               u32 length)
 {
@@ -774,7 +777,7 @@ bmiBufferSend(struct hif_device *device,
             return A_ERROR;
         }
     } else {
-        AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("BMI Communication timeout - bmiBufferSend\n"));
+        AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("BMI Communication timeout - bmi_send_buf\n"));
         return A_ERROR;
     }
 
@@ -782,7 +785,7 @@ bmiBufferSend(struct hif_device *device,
 }
 
 int
-bmiBufferReceive(struct hif_device *device,
+bmi_recv_buf(struct hif_device *device,
                  u8 *buffer,
                  u32 length,
                  bool want_timeout)
@@ -890,7 +893,7 @@ bmiBufferReceive(struct hif_device *device,
         }
 
         if (!word_available) {
-            AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("BMI Communication timeout - bmiBufferReceive FIFO empty\n"));
+            AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("BMI Communication timeout - bmi_recv_buf FIFO empty\n"));
             return A_ERROR;
         }
     }
@@ -941,7 +944,7 @@ bmiBufferReceive(struct hif_device *device,
         }
 
         if (!(*pBMICmdCredits)) {
-            AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("BMI Communication timeout- bmiBufferReceive no credit\n"));
+            AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("BMI Communication timeout- bmi_recv_buf no credit\n"));
             return A_ERROR;
         }
     }
@@ -958,14 +961,14 @@ bmiBufferReceive(struct hif_device *device,
 }
 
 int
-BMIFastDownload(struct hif_device *device, u32 address, u8 *buffer, u32 length)
+bmi_fast_download(struct hif_device *device, u32 address, u8 *buffer, u32 length)
 {
     int status = A_ERROR;
     u32 lastWord = 0;
     u32 lastWordOffset = length & ~0x3;
     u32 unalignedBytes = length & 0x3;
 
-    status = BMILZStreamStart (device, address);
+    status = bmi_lz_stream_start (device, address);
     if (status) {
             return A_ERROR;
     }
@@ -975,21 +978,21 @@ BMIFastDownload(struct hif_device *device, u32 address, u8 *buffer, u32 length)
         memcpy(&lastWord, &buffer[lastWordOffset], unalignedBytes);
     }
 
-    status = BMILZData(device, buffer, lastWordOffset);
+    status = bmi_lz_data(device, buffer, lastWordOffset);
 
     if (status) {
         return A_ERROR;
     }
 
     if (unalignedBytes) {
-        status = BMILZData(device, (u8 *)&lastWord, 4);
+        status = bmi_lz_data(device, (u8 *)&lastWord, 4);
     }
 
     if (!status) {
         //
         // Close compressed stream and open a new (fake) one.  This serves mainly to flush Target caches.
         //
-        status = BMILZStreamStart (device, 0x00);
+        status = bmi_lz_stream_start (device, 0x00);
         if (status) {
            return A_ERROR;
         }
@@ -998,13 +1001,13 @@ BMIFastDownload(struct hif_device *device, u32 address, u8 *buffer, u32 length)
 }
 
 int
-BMIRawWrite(struct hif_device *device, u8 *buffer, u32 length)
+bmi_raw_write(struct hif_device *device, u8 *buffer, u32 length)
 {
-    return bmiBufferSend(device, buffer, length);
+    return bmi_send_buf(device, buffer, length);
 }
 
 int
-BMIRawRead(struct hif_device *device, u8 *buffer, u32 length, bool want_timeout)
+bmi_raw_read(struct hif_device *device, u8 *buffer, u32 length, bool want_timeout)
 {
-    return bmiBufferReceive(device, buffer, length, want_timeout);
+    return bmi_recv_buf(device, buffer, length, want_timeout);
 }
diff --git a/drivers/staging/ath6kl/htc2/htc_internal.h b/drivers/staging/ath6kl/htc2/htc_internal.h
index cac9735..bab8cda 100644
--- a/drivers/staging/ath6kl/htc2/htc_internal.h
+++ b/drivers/staging/ath6kl/htc2/htc_internal.h
@@ -38,10 +38,9 @@ extern "C" {
 #include "athdefs.h"
 #include "a_osapi.h"
 #include "htc_debug.h"
+#include "bmi.h"
 #include "htc.h"
 #include "htc_api.h"
-#include "bmi_msg.h"
-#include "hif.h"
 #include "AR6000/ar6k.h"
 
 /* HTC operational parameters */
diff --git a/drivers/staging/ath6kl/include/bmi.h b/drivers/staging/ath6kl/include/bmi.h
deleted file mode 100644
index d3227f7..0000000
--- a/drivers/staging/ath6kl/include/bmi.h
+++ /dev/null
@@ -1,134 +0,0 @@
-//------------------------------------------------------------------------------
-// <copyright file="bmi.h" company="Atheros">
-//    Copyright (c) 2004-2010 Atheros Corporation.  All rights reserved.
-// 
-//
-// Permission to use, copy, modify, and/or distribute this software for any
-// purpose with or without fee is hereby granted, provided that the above
-// copyright notice and this permission notice appear in all copies.
-//
-// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
-// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
-// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
-//
-//
-//------------------------------------------------------------------------------
-//==============================================================================
-// BMI declarations and prototypes
-//
-// Author(s): ="Atheros"
-//==============================================================================
-#ifndef _BMI_H_
-#define _BMI_H_
-
-#ifdef __cplusplus
-extern "C" {
-#endif /* __cplusplus */
-
-/* Header files */
-#include "a_config.h"
-#include "athdefs.h"
-#include "hif.h"
-#include "a_osapi.h"
-#include "bmi_msg.h"
-
-void
-BMIInit(void);
-
-void
-BMICleanup(void);
-
-int
-BMIDone(struct hif_device *device);
-
-int
-BMIGetTargetInfo(struct hif_device *device, struct bmi_target_info *targ_info);
-
-int
-BMIReadMemory(struct hif_device *device,
-              u32 address,
-              u8 *buffer,
-              u32 length);
-
-int
-BMIWriteMemory(struct hif_device *device,
-               u32 address,
-               u8 *buffer,
-               u32 length);
-
-int
-BMIExecute(struct hif_device *device,
-           u32 address,
-           u32 *param);
-
-int
-BMISetAppStart(struct hif_device *device,
-               u32 address);
-
-int
-BMIReadSOCRegister(struct hif_device *device,
-                   u32 address,
-                   u32 *param);
-
-int
-BMIWriteSOCRegister(struct hif_device *device,
-                    u32 address,
-                    u32 param);
-
-int
-BMIrompatchInstall(struct hif_device *device,
-                   u32 ROM_addr,
-                   u32 RAM_addr,
-                   u32 nbytes,
-                   u32 do_activate,
-                   u32 *patch_id);
-
-int
-BMIrompatchUninstall(struct hif_device *device,
-                     u32 rompatch_id);
-
-int
-BMIrompatchActivate(struct hif_device *device,
-                    u32 rompatch_count,
-                    u32 *rompatch_list);
-
-int
-BMIrompatchDeactivate(struct hif_device *device,
-                      u32 rompatch_count,
-                      u32 *rompatch_list);
-
-int
-BMILZStreamStart(struct hif_device *device,
-                 u32 address);
-
-int
-BMILZData(struct hif_device *device,
-          u8 *buffer,
-          u32 length);
-
-int
-BMIFastDownload(struct hif_device *device,
-                u32 address,
-                u8 *buffer,
-                u32 length);
-
-int
-BMIRawWrite(struct hif_device *device,
-            u8 *buffer,
-            u32 length);
-
-int
-BMIRawRead(struct hif_device *device, 
-           u8 *buffer, 
-           u32 length,
-           bool want_timeout);
-
-#ifdef __cplusplus
-}
-#endif
-
-#endif /* _BMI_H_ */
diff --git a/drivers/staging/ath6kl/include/common/bmi_msg.h b/drivers/staging/ath6kl/include/common/bmi_msg.h
deleted file mode 100644
index 84e8db5..0000000
--- a/drivers/staging/ath6kl/include/common/bmi_msg.h
+++ /dev/null
@@ -1,233 +0,0 @@
-//------------------------------------------------------------------------------
-// Copyright (c) 2004-2010 Atheros Corporation.  All rights reserved.
-//
-//
-// Permission to use, copy, modify, and/or distribute this software for any
-// purpose with or without fee is hereby granted, provided that the above
-// copyright notice and this permission notice appear in all copies.
-//
-// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
-// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
-// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
-//
-//
-//
-// Author(s): ="Atheros"
-//------------------------------------------------------------------------------
-
-#ifndef __BMI_MSG_H__
-#define __BMI_MSG_H__
-
-/*
- * Bootloader Messaging Interface (BMI)
- *
- * BMI is a very simple messaging interface used during initialization
- * to read memory, write memory, execute code, and to define an
- * application entry PC.
- *
- * It is used to download an application to AR6K, to provide
- * patches to code that is already resident on AR6K, and generally
- * to examine and modify state.  The Host has an opportunity to use
- * BMI only once during bootup.  Once the Host issues a BMI_DONE
- * command, this opportunity ends.
- *
- * The Host writes BMI requests to mailbox0, and reads BMI responses
- * from mailbox0.   BMI requests all begin with a command
- * (see below for specific commands), and are followed by
- * command-specific data.
- *
- * Flow control:
- * The Host can only issue a command once the Target gives it a
- * "BMI Command Credit", using AR6K Counter #4.  As soon as the
- * Target has completed a command, it issues another BMI Command
- * Credit (so the Host can issue the next command).
- *
- * BMI handles all required Target-side cache flushing.
- */
-
-
-/* Maximum data size used for BMI transfers */
-#define BMI_DATASZ_MAX                      256
-
-/* BMI Commands */
-
-#define BMI_NO_COMMAND                      0
-
-#define BMI_DONE                            1
-        /*
-         * Semantics: Host is done using BMI
-         * Request format:
-         *    u32 command (BMI_DONE)
-         * Response format: none
-         */
-
-#define BMI_READ_MEMORY                     2
-        /*
-         * Semantics: Host reads AR6K memory
-         * Request format:
-         *    u32 command (BMI_READ_MEMORY)
-         *    u32 address
-         *    u32 length, at most BMI_DATASZ_MAX
-         * Response format:
-         *    u8 data[length]
-         */
-
-#define BMI_WRITE_MEMORY                    3
-        /*
-         * Semantics: Host writes AR6K memory
-         * Request format:
-         *    u32 command (BMI_WRITE_MEMORY)
-         *    u32 address
-         *    u32 length, at most BMI_DATASZ_MAX
-         *    u8 data[length]
-         * Response format: none
-         */
-
-#define BMI_EXECUTE                         4
-        /*
-         * Semantics: Causes AR6K to execute code
-         * Request format:
-         *    u32 command (BMI_EXECUTE)
-         *    u32 address
-         *    u32 parameter
-         * Response format:
-         *    u32 return value
-         */
-
-#define BMI_SET_APP_START                   5
-        /*
-         * Semantics: Set Target application starting address
-         * Request format:
-         *    u32 command (BMI_SET_APP_START)
-         *    u32 address
-         * Response format: none
-         */
-
-#define BMI_READ_SOC_REGISTER               6
-        /*
-         * Semantics: Read a 32-bit Target SOC register.
-         * Request format:
-         *    u32 command (BMI_READ_REGISTER)
-         *    u32 address
-         * Response format: 
-         *    u32 value
-         */
-
-#define BMI_WRITE_SOC_REGISTER              7
-        /*
-         * Semantics: Write a 32-bit Target SOC register.
-         * Request format:
-         *    u32 command (BMI_WRITE_REGISTER)
-         *    u32 address
-         *    u32 value
-         *
-         * Response format: none
-         */
-
-#define BMI_GET_TARGET_ID                  8
-#define BMI_GET_TARGET_INFO                8
-        /*
-         * Semantics: Fetch the 4-byte Target information
-         * Request format:
-         *    u32 command (BMI_GET_TARGET_ID/INFO)
-         * Response format1 (old firmware):
-         *    u32 TargetVersionID
-         * Response format2 (newer firmware):
-         *    u32 TARGET_VERSION_SENTINAL
-         *    struct bmi_target_info;
-         */
-
-PREPACK struct bmi_target_info {
-    u32 target_info_byte_count; /* size of this structure */
-    u32 target_ver;             /* Target Version ID */
-    u32 target_type;            /* Target type */
-} POSTPACK;
-#define TARGET_VERSION_SENTINAL 0xffffffff
-#define TARGET_TYPE_AR6001 1
-#define TARGET_TYPE_AR6002 2
-#define TARGET_TYPE_AR6003 3
-
-
-#define BMI_ROMPATCH_INSTALL               9
-        /*
-         * Semantics: Install a ROM Patch.
-         * Request format:
-         *    u32 command (BMI_ROMPATCH_INSTALL)
-         *    u32 Target ROM Address
-         *    u32 Target RAM Address or Value (depending on Target Type)
-         *    u32 Size, in bytes
-         *    u32 Activate? 1-->activate;
-         *                            0-->install but do not activate
-         * Response format:
-         *    u32 PatchID
-         */
-
-#define BMI_ROMPATCH_UNINSTALL             10
-        /*
-         * Semantics: Uninstall a previously-installed ROM Patch,
-         * automatically deactivating, if necessary.
-         * Request format:
-         *    u32 command (BMI_ROMPATCH_UNINSTALL)
-         *    u32 PatchID
-         *
-         * Response format: none
-         */
-
-#define BMI_ROMPATCH_ACTIVATE              11
-        /*
-         * Semantics: Activate a list of previously-installed ROM Patches.
-         * Request format:
-         *    u32 command (BMI_ROMPATCH_ACTIVATE)
-         *    u32 rompatch_count
-         *    u32 PatchID[rompatch_count]
-         *
-         * Response format: none
-         */
-
-#define BMI_ROMPATCH_DEACTIVATE            12
-        /*
-         * Semantics: Deactivate a list of active ROM Patches.
-         * Request format:
-         *    u32 command (BMI_ROMPATCH_DEACTIVATE)
-         *    u32 rompatch_count
-         *    u32 PatchID[rompatch_count]
-         *
-         * Response format: none
-         */
-
-
-#define BMI_LZ_STREAM_START                13
-        /*
-         * Semantics: Begin an LZ-compressed stream of input
-         * which is to be uncompressed by the Target to an
-         * output buffer at address.  The output buffer must
-         * be sufficiently large to hold the uncompressed
-         * output from the compressed input stream.  This BMI
-         * command should be followed by a series of 1 or more
-         * BMI_LZ_DATA commands.
-         *    u32 command (BMI_LZ_STREAM_START)
-         *    u32 address
-         * Note: Not supported on all versions of ROM firmware.
-         */
-
-#define BMI_LZ_DATA                        14
-        /*
-         * Semantics: Host writes AR6K memory with LZ-compressed
-         * data which is uncompressed by the Target.  This command
-         * must be preceded by a BMI_LZ_STREAM_START command. A series
-         * of BMI_LZ_DATA commands are considered part of a single
-         * input stream until another BMI_LZ_STREAM_START is issued.
-         * Request format:
-         *    u32 command (BMI_LZ_DATA)
-         *    u32 length (of compressed data),
-         *                  at most BMI_DATASZ_MAX
-         *    u8 CompressedData[length]
-         * Response format: none
-         * Note: Not supported on all versions of ROM firmware.
-         */
-
-#endif /* __BMI_MSG_H__ */
diff --git a/drivers/staging/ath6kl/miscdrv/common_drv.c b/drivers/staging/ath6kl/miscdrv/common_drv.c
index 1ce539a..b80e532 100644
--- a/drivers/staging/ath6kl/miscdrv/common_drv.c
+++ b/drivers/staging/ath6kl/miscdrv/common_drv.c
@@ -32,11 +32,9 @@
 
 #include "a_osapi.h"
 #include "targaddrs.h"
-#include "hif.h"
+#include "bmi.h"
 #include "htc_api.h"
 #include "wmi.h"
-#include "bmi.h"
-#include "bmi_msg.h"
 #include "common_drv.h"
 #define ATH_MODULE_NAME misc
 #include "a_debug.h"
@@ -484,12 +482,12 @@ ar6000_copy_cust_data_from_target(struct hif_device *hifDevice, u32 TargetType)
     u8 AR6003CustDataShadow[AR6003_CUST_DATA_SIZE+4];
     s32 i;
 
-    if (BMIReadMemory(hifDevice,
+    if (bmi_read_memory(hifDevice,
             HOST_INTEREST_ITEM_ADDRESS(TargetType, hi_board_data),
             (u8 *)&eepHeaderAddr,
             4)!= 0)
     {
-        AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("BMIReadMemory for reading board data address failed \n"));
+        AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("bmi_read_memory for reading board data address failed \n"));
         return;
     }
 
@@ -497,8 +495,8 @@ ar6000_copy_cust_data_from_target(struct hif_device *hifDevice, u32 TargetType)
         eepHeaderAddr += 36;  /* AR6003 customer data section offset is 37 */
 
         for (i=0; i<AR6003_CUST_DATA_SIZE+4; i+=4){
-            if (BMIReadSOCRegister(hifDevice, eepHeaderAddr, (u32 *)&AR6003CustDataShadow[i])!= 0) {
-                AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("BMIReadSOCRegister () failed \n"));
+            if (bmi_read_soc_register(hifDevice, eepHeaderAddr, (u32 *)&AR6003CustDataShadow[i])!= 0) {
+                AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("bmi_read_soc_register () failed \n"));
                 return ;
             }  
             eepHeaderAddr +=4;
@@ -511,8 +509,8 @@ ar6000_copy_cust_data_from_target(struct hif_device *hifDevice, u32 TargetType)
         eepHeaderAddr += 64;  /* AR6002 customer data sectioin offset is 64 */
 
         for (i=0; i<AR6002_CUST_DATA_SIZE; i+=4){
-            if (BMIReadSOCRegister(hifDevice, eepHeaderAddr, (u32 *)&custDataAR6002[i])!= 0) {
-                AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("BMIReadSOCRegister () failed \n"));
+            if (bmi_read_soc_register(hifDevice, eepHeaderAddr, (u32 *)&custDataAR6002[i])!= 0) {
+                AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("bmi_read_soc_register () failed \n"));
                 return ;
             }  
             eepHeaderAddr +=4;
@@ -649,13 +647,13 @@ int ar6000_set_htc_params(struct hif_device *hifDevice,
         }
 
             /* set the host interest area for the block size */
-        status = BMIWriteMemory(hifDevice,
+        status = bmi_write_memory(hifDevice,
                                 HOST_INTEREST_ITEM_ADDRESS(TargetType, hi_mbox_io_block_sz),
                                 (u8 *)&blocksizes[1],
                                 4);
 
         if (status) {
-            AR_DEBUG_PRINTF(ATH_LOG_ERR,("BMIWriteMemory for IO block size failed \n"));
+            AR_DEBUG_PRINTF(ATH_LOG_ERR,("bmi_write_memory for IO block size failed \n"));
             break;
         }
 
@@ -664,13 +662,13 @@ int ar6000_set_htc_params(struct hif_device *hifDevice,
 
         if (MboxIsrYieldValue != 0) {
                 /* set the host interest area for the mbox ISR yield limit */
-            status = BMIWriteMemory(hifDevice,
+            status = bmi_write_memory(hifDevice,
                                     HOST_INTEREST_ITEM_ADDRESS(TargetType, hi_mbox_isr_yield_limit),
                                     (u8 *)&MboxIsrYieldValue,
                                     4);
 
             if (status) {
-                AR_DEBUG_PRINTF(ATH_LOG_ERR,("BMIWriteMemory for yield limit failed \n"));
+                AR_DEBUG_PRINTF(ATH_LOG_ERR,("bmi_write_memory for yield limit failed \n"));
                 break;
             }
         }
@@ -897,7 +895,7 @@ int ar6000_set_hci_bridge_flags(struct hif_device *hifDevice,
         }
 
             /* set hci bridge flags */
-        status = BMIWriteMemory(hifDevice,
+        status = bmi_write_memory(hifDevice,
                                 HOST_INTEREST_ITEM_ADDRESS(TargetType, hi_hci_bridge_flags),
                                 (u8 *)&Flags,
                                 4);
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index aece57a..755a347 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -765,7 +765,7 @@ ar6000_sysfs_bmi_read(struct file *fp, struct kobject *kobj,
 
     if (index == MAX_AR6000) return 0;
 
-    if ((BMIRawRead(ar->arHifDevice, (u8*)buf, count, true)) != 0) {
+    if ((bmi_raw_read(ar->arHifDevice, (u8*)buf, count, true)) != 0) {
         return 0;
     }
 
@@ -792,7 +792,7 @@ ar6000_sysfs_bmi_write(struct file *fp, struct kobject *kobj,
 
     if (index == MAX_AR6000) return 0;
 
-    if ((BMIRawWrite(ar->arHifDevice, (u8*)buf, count)) != 0) {
+    if ((bmi_raw_write(ar->arHifDevice, (u8*)buf, count)) != 0) {
         return 0;
     }
 
@@ -1076,14 +1076,14 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
                           (((ar)->arTargetType == TARGET_TYPE_AR6003) ? AR6003_BOARD_DATA_SZ : 0));
         
         /* Determine where in Target RAM to write Board Data */
-        bmifn(BMIReadMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_ext_data), (u8 *)&board_ext_address, 4));
+        bmifn(bmi_read_memory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_ext_data), (u8 *)&board_ext_address, 4));
         AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("Board extended Data download address: 0x%x\n", board_ext_address));
 
         /* check whether the target has allocated memory for extended board data and file contains extended board data */
         if ((board_ext_address) && (fw_entry->size == (board_data_size + board_ext_data_size))) {
             u32 param;
 
-            status = BMIWriteMemory(ar->arHifDevice, board_ext_address, (u8 *)(fw_entry->data + board_data_size), board_ext_data_size);
+            status = bmi_write_memory(ar->arHifDevice, board_ext_address, (u8 *)(fw_entry->data + board_data_size), board_ext_data_size);
 
             if (status) {
                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("BMI operation failed: %d\n", __LINE__));
@@ -1093,7 +1093,7 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
 
             /* Record the fact that extended board Data IS initialized */
             param = (board_ext_data_size << 16) | 1;
-            bmifn(BMIWriteMemory(ar->arHifDevice,
+            bmifn(bmi_write_memory(ar->arHifDevice,
             HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_ext_data_config),
 				       (unsigned char *)&param, 4));
         }
@@ -1101,9 +1101,9 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
     }
 
     if (compressed) {
-        status = BMIFastDownload(ar->arHifDevice, address, (u8 *)fw_entry->data, fw_entry_size);
+        status = bmi_fast_download(ar->arHifDevice, address, (u8 *)fw_entry->data, fw_entry_size);
     } else {
-        status = BMIWriteMemory(ar->arHifDevice, address, (u8 *)fw_entry->data, fw_entry_size);
+        status = bmi_write_memory(ar->arHifDevice, address, (u8 *)fw_entry->data, fw_entry_size);
     }
 
     if (status) {
@@ -1122,16 +1122,16 @@ ar6000_update_bdaddr(struct ar6_softc *ar)
         if (setupbtdev != 0) {
             u32 address;
 
-           if (BMIReadMemory(ar->arHifDevice,
+           if (bmi_read_memory(ar->arHifDevice,
 		HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_data), (u8 *)&address, 4) != 0)
            {
-    	      	AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIReadMemory for hi_board_data failed\n"));
+		   AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("bmi_read_memory for hi_board_data failed\n"));
            	return A_ERROR;
            }
 
-           if (BMIReadMemory(ar->arHifDevice, address + BDATA_BDADDR_OFFSET, (u8 *)ar->bdaddr, 6) != 0)
+           if (bmi_read_memory(ar->arHifDevice, address + BDATA_BDADDR_OFFSET, (u8 *)ar->bdaddr, 6) != 0)
            {
-    	    	AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIReadMemory for BD address failed\n"));
+		   AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("bmi_read_memory for BD address failed\n"));
            	return A_ERROR;
            }
 	   AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BDADDR 0x%x:0x%x:0x%x:0x%x:0x%x:0x%x\n", ar->bdaddr[0],
@@ -1167,21 +1167,21 @@ ar6000_sysfs_bmi_get_config(struct ar6_softc *ar, u32 mode)
 
         /* Temporarily disable system sleep */
         address = MBOX_BASE_ADDRESS + LOCAL_SCRATCH_ADDRESS;
-        bmifn(BMIReadSOCRegister(ar->arHifDevice, address, &param));
+        bmifn(bmi_read_soc_register(ar->arHifDevice, address, &param));
         options = param;
         param |= AR6K_OPTION_SLEEP_DISABLE;
-        bmifn(BMIWriteSOCRegister(ar->arHifDevice, address, param));
+        bmifn(bmi_write_soc_register(ar->arHifDevice, address, param));
 
         address = RTC_BASE_ADDRESS + SYSTEM_SLEEP_ADDRESS;
-        bmifn(BMIReadSOCRegister(ar->arHifDevice, address, &param));
+        bmifn(bmi_read_soc_register(ar->arHifDevice, address, &param));
         sleep = param;
         param |= WLAN_SYSTEM_SLEEP_DISABLE_SET(1);
-        bmifn(BMIWriteSOCRegister(ar->arHifDevice, address, param));
+        bmifn(bmi_write_soc_register(ar->arHifDevice, address, param));
         AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("old options: %d, old sleep: %d\n", options, sleep));
 
         if (ar->arTargetType == TARGET_TYPE_AR6003) {
             /* Program analog PLL register */
-            bmifn(BMIWriteSOCRegister(ar->arHifDevice, ANALOG_INTF_BASE_ADDRESS + 0x284, 0xF9104001));
+            bmifn(bmi_write_soc_register(ar->arHifDevice, ANALOG_INTF_BASE_ADDRESS + 0x284, 0xF9104001));
             /* Run at 80/88MHz by default */
             param = CPU_CLOCK_STANDARD_SET(1);
         } else {
@@ -1189,18 +1189,18 @@ ar6000_sysfs_bmi_get_config(struct ar6_softc *ar, u32 mode)
             param = CPU_CLOCK_STANDARD_SET(0);
         }
         address = RTC_BASE_ADDRESS + CPU_CLOCK_ADDRESS;
-        bmifn(BMIWriteSOCRegister(ar->arHifDevice, address, param));
+        bmifn(bmi_write_soc_register(ar->arHifDevice, address, param));
 
         param = 0;
         if (ar->arTargetType == TARGET_TYPE_AR6002) {
-            bmifn(BMIReadMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_ext_clk_detected), (u8 *)&param, 4));
+            bmifn(bmi_read_memory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_ext_clk_detected), (u8 *)&param, 4));
         }
 
         /* LPO_CAL.ENABLE = 1 if no external clk is detected */
         if (param != 1) {
             address = RTC_BASE_ADDRESS + LPO_CAL_ADDRESS;
             param = LPO_CAL_ENABLE_SET(1);
-            bmifn(BMIWriteSOCRegister(ar->arHifDevice, address, param));
+            bmifn(bmi_write_soc_register(ar->arHifDevice, address, param));
         }
 
         /* Venus2.0: Lower SDIO pad drive strength,
@@ -1209,16 +1209,16 @@ ar6000_sysfs_bmi_get_config(struct ar6_softc *ar, u32 mode)
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("AR6K: Temporary WAR to avoid SDIO CRC error\n"));
             param = 0x20;
             address = GPIO_BASE_ADDRESS + GPIO_PIN10_ADDRESS;
-            bmifn(BMIWriteSOCRegister(ar->arHifDevice, address, param));
+            bmifn(bmi_write_soc_register(ar->arHifDevice, address, param));
 
             address = GPIO_BASE_ADDRESS + GPIO_PIN11_ADDRESS;
-            bmifn(BMIWriteSOCRegister(ar->arHifDevice, address, param));
+            bmifn(bmi_write_soc_register(ar->arHifDevice, address, param));
 
             address = GPIO_BASE_ADDRESS + GPIO_PIN12_ADDRESS;
-            bmifn(BMIWriteSOCRegister(ar->arHifDevice, address, param));
+            bmifn(bmi_write_soc_register(ar->arHifDevice, address, param));
 
             address = GPIO_BASE_ADDRESS + GPIO_PIN13_ADDRESS;
-            bmifn(BMIWriteSOCRegister(ar->arHifDevice, address, param));
+            bmifn(bmi_write_soc_register(ar->arHifDevice, address, param));
         }
 
 #ifdef FORCE_INTERNAL_CLOCK
@@ -1226,20 +1226,20 @@ ar6000_sysfs_bmi_get_config(struct ar6_softc *ar, u32 mode)
         if (ar->arTargetType == TARGET_TYPE_AR6003) {
             /* hi_ext_clk_detected = 0 */
             param = 0;
-            bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_ext_clk_detected), (u8 *)&param, 4));
+            bmifn(bmi_write_memory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_ext_clk_detected), (u8 *)&param, 4));
 
             /* CLOCK_CONTROL &= ~LF_CLK32 */
             address = RTC_BASE_ADDRESS + CLOCK_CONTROL_ADDRESS;
-            bmifn(BMIReadSOCRegister(ar->arHifDevice, address, &param));
+            bmifn(bmi_read_soc_register(ar->arHifDevice, address, &param));
             param &= (~CLOCK_CONTROL_LF_CLK32_SET(1));
-            bmifn(BMIWriteSOCRegister(ar->arHifDevice, address, param));
+            bmifn(bmi_write_soc_register(ar->arHifDevice, address, param));
         }
 #endif /* FORCE_INTERNAL_CLOCK */
 
         /* Transfer Board Data from Target EEPROM to Target RAM */
         if (ar->arTargetType == TARGET_TYPE_AR6003) {
             /* Determine where in Target RAM to write Board Data */
-            bmifn(BMIReadMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_data), (u8 *)&address, 4));
+            bmifn(bmi_read_memory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_data), (u8 *)&address, 4));
             AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("Board Data download address: 0x%x\n", address));
 
             /* Write EEPROM data to Target RAM */
@@ -1249,7 +1249,7 @@ ar6000_sysfs_bmi_get_config(struct ar6_softc *ar, u32 mode)
 
             /* Record the fact that Board Data IS initialized */
             param = 1;
-            bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_data_initialized), (u8 *)&param, 4));
+            bmifn(bmi_write_memory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_data_initialized), (u8 *)&param, 4));
 
             /* Transfer One time Programmable data */
 	    AR6K_APP_LOAD_ADDRESS(address, ar->arVersion.target_ver);
@@ -1260,7 +1260,7 @@ ar6000_sysfs_bmi_get_config(struct ar6_softc *ar, u32 mode)
                 /* Execute the OTP code */
                 param = 0;
                 AR6K_APP_START_OVERRIDE_ADDRESS(address, ar->arVersion.target_ver);
-                bmifn(BMIExecute(ar->arHifDevice, address, &param));
+                bmifn(bmi_execute(ar->arHifDevice, address, &param));
             } else if (status != A_ENOENT) {
                 return A_ERROR;
             } 
@@ -1279,7 +1279,7 @@ ar6000_sysfs_bmi_get_config(struct ar6_softc *ar, u32 mode)
 
         /* Set starting address for firmware */
         AR6K_APP_START_OVERRIDE_ADDRESS(address, ar->arVersion.target_ver);
-        bmifn(BMISetAppStart(ar->arHifDevice, address));
+        bmifn(bmi_set_app_start(ar->arHifDevice, address));
 
 	if(ar->arTargetType == TARGET_TYPE_AR6003) {
 		AR6K_DATASET_PATCH_ADDRESS(address, ar->arVersion.target_ver);
@@ -1287,18 +1287,18 @@ ar6000_sysfs_bmi_get_config(struct ar6_softc *ar, u32 mode)
 					      address, false)) != 0)
 			return A_ERROR;
 		param = address;
-		bmifn(BMIWriteMemory(ar->arHifDevice,
+		bmifn(bmi_write_memory(ar->arHifDevice,
 		HOST_INTEREST_ITEM_ADDRESS(ar, hi_dset_list_head),
 					   (unsigned char *)&param, 4));
 	}
 
         /* Restore system sleep */
         address = RTC_BASE_ADDRESS + SYSTEM_SLEEP_ADDRESS;
-        bmifn(BMIWriteSOCRegister(ar->arHifDevice, address, sleep));
+        bmifn(bmi_write_soc_register(ar->arHifDevice, address, sleep));
 
         address = MBOX_BASE_ADDRESS + LOCAL_SCRATCH_ADDRESS;
         param = options | 0x20;
-        bmifn(BMIWriteSOCRegister(ar->arHifDevice, address, param));
+        bmifn(bmi_write_soc_register(ar->arHifDevice, address, param));
 
         if (ar->arTargetType == TARGET_TYPE_AR6003) {
             /* Configure GPIO AR6003 UART */
@@ -1306,14 +1306,14 @@ ar6000_sysfs_bmi_get_config(struct ar6_softc *ar, u32 mode)
 #define CONFIG_AR600x_DEBUG_UART_TX_PIN 8
 #endif
             param = CONFIG_AR600x_DEBUG_UART_TX_PIN;
-            bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_dbg_uart_txpin), (u8 *)&param, 4));
+            bmifn(bmi_write_memory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_dbg_uart_txpin), (u8 *)&param, 4));
 
 #if (CONFIG_AR600x_DEBUG_UART_TX_PIN == 23)
             {
                 address = GPIO_BASE_ADDRESS + CLOCK_GPIO_ADDRESS;
-                bmifn(BMIReadSOCRegister(ar->arHifDevice, address, &param));
+                bmifn(bmi_read_soc_register(ar->arHifDevice, address, &param));
                 param |= CLOCK_GPIO_BT_CLK_OUT_EN_SET(1);
-                bmifn(BMIWriteSOCRegister(ar->arHifDevice, address, param));
+                bmifn(bmi_write_soc_register(ar->arHifDevice, address, param));
             }
 #endif
 
@@ -1321,7 +1321,7 @@ ar6000_sysfs_bmi_get_config(struct ar6_softc *ar, u32 mode)
 #ifdef ATH6KL_CONFIG_GPIO_BT_RESET
 #define CONFIG_AR600x_BT_RESET_PIN	0x16
             param = CONFIG_AR600x_BT_RESET_PIN;
-            bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_hci_uart_support_pins), (u8 *)&param, 4));
+            bmifn(bmi_write_memory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_hci_uart_support_pins), (u8 *)&param, 4));
 #endif /* ATH6KL_CONFIG_GPIO_BT_RESET */
 
             /* Configure UART flow control polarity */
@@ -1332,14 +1332,14 @@ ar6000_sysfs_bmi_get_config(struct ar6_softc *ar, u32 mode)
 #if (CONFIG_ATH6KL_BT_UART_FC_POLARITY == 1)
             if (ar->arVersion.target_ver == AR6003_REV2_VERSION) {
                 param = ((CONFIG_ATH6KL_BT_UART_FC_POLARITY << 1) & 0x2);
-                bmifn(BMIWriteMemory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_hci_uart_pwr_mgmt_params), (u8 *)&param, 4));
+                bmifn(bmi_write_memory(ar->arHifDevice, HOST_INTEREST_ITEM_ADDRESS(ar, hi_hci_uart_pwr_mgmt_params), (u8 *)&param, 4));
             }
 #endif /* CONFIG_ATH6KL_BT_UART_FC_POLARITY */
         }
 
 #ifdef HTC_RAW_INTERFACE
         if (!eppingtest && bypasswmi) {
-            /* Don't run BMIDone for ART mode and force resetok=0 */
+            /* Don't run bmi_done for ART mode and force resetok=0 */
             resetok = 0;
             msleep(1000);
         }
@@ -1355,12 +1355,12 @@ ar6000_configure_target(struct ar6_softc *ar)
     u32 param;
     if (enableuartprint) {
         param = 1;
-        if (BMIWriteMemory(ar->arHifDevice,
+        if (bmi_write_memory(ar->arHifDevice,
                            HOST_INTEREST_ITEM_ADDRESS(ar, hi_serial_enable),
                            (u8 *)&param,
                            4)!= 0)
         {
-             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIWriteMemory for enableuartprint failed \n"));
+             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("bmi_write_memory for enableuartprint failed \n"));
              return A_ERROR;
         }
         AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("Serial console prints enabled\n"));
@@ -1368,12 +1368,12 @@ ar6000_configure_target(struct ar6_softc *ar)
 
     /* Tell target which HTC version it is used*/
     param = HTC_PROTOCOL_VERSION;
-    if (BMIWriteMemory(ar->arHifDevice,
+    if (bmi_write_memory(ar->arHifDevice,
                        HOST_INTEREST_ITEM_ADDRESS(ar, hi_app_host_interest),
                        (u8 *)&param,
                        4)!= 0)
     {
-         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIWriteMemory for htc version failed \n"));
+         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("bmi_write_memory for htc version failed \n"));
          return A_ERROR;
     }
 
@@ -1387,23 +1387,23 @@ ar6000_configure_target(struct ar6_softc *ar)
     if (enabletimerwar) {
         u32 param;
 
-        if (BMIReadMemory(ar->arHifDevice,
+        if (bmi_read_memory(ar->arHifDevice,
             HOST_INTEREST_ITEM_ADDRESS(ar, hi_option_flag),
             (u8 *)&param,
             4)!= 0)
         {
-            AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIReadMemory for enabletimerwar failed \n"));
+            AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("bmi_read_memory for enabletimerwar failed \n"));
             return A_ERROR;
         }
 
         param |= HI_OPTION_TIMER_WAR;
 
-        if (BMIWriteMemory(ar->arHifDevice,
+        if (bmi_write_memory(ar->arHifDevice,
             HOST_INTEREST_ITEM_ADDRESS(ar, hi_option_flag),
             (u8 *)&param,
             4) != 0)
         {
-            AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIWriteMemory for enabletimerwar failed \n"));
+            AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("bmi_write_memory for enabletimerwar failed \n"));
             return A_ERROR;
         }
         AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("Timer WAR enabled\n"));
@@ -1413,12 +1413,12 @@ ar6000_configure_target(struct ar6_softc *ar)
     {
         u32 param;
 
-        if (BMIReadMemory(ar->arHifDevice,
+        if (bmi_read_memory(ar->arHifDevice,
             HOST_INTEREST_ITEM_ADDRESS(ar, hi_option_flag),
             (u8 *)&param,
             4)!= 0)
         {
-            AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIReadMemory for setting fwmode failed \n"));
+            AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("bmi_read_memory for setting fwmode failed \n"));
             return A_ERROR;
         }
 
@@ -1428,12 +1428,12 @@ ar6000_configure_target(struct ar6_softc *ar)
         param |= (firmware_bridge << HI_OPTION_FW_BRIDGE_SHIFT);
 
 
-        if (BMIWriteMemory(ar->arHifDevice,
+        if (bmi_write_memory(ar->arHifDevice,
             HOST_INTEREST_ITEM_ADDRESS(ar, hi_option_flag),
             (u8 *)&param,
             4) != 0)
         {
-            AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIWriteMemory for setting fwmode failed \n"));
+            AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("bmi_write_memory for setting fwmode failed \n"));
             return A_ERROR;
         }
         AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("Firmware mode set\n"));
@@ -1443,23 +1443,23 @@ ar6000_configure_target(struct ar6_softc *ar)
     {
         u32 param;
 
-        if (BMIReadMemory(ar->arHifDevice,
+        if (bmi_read_memory(ar->arHifDevice,
             HOST_INTEREST_ITEM_ADDRESS(ar, hi_option_flag),
             (u8 *)&param,
             4)!= 0)
         {
-            AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIReadMemory for disabling debug logs failed\n"));
+            AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("bmi_read_memory for disabling debug logs failed\n"));
             return A_ERROR;
         }
 
         param |= HI_OPTION_DISABLE_DBGLOG;
 
-        if (BMIWriteMemory(ar->arHifDevice,
+        if (bmi_write_memory(ar->arHifDevice,
             HOST_INTEREST_ITEM_ADDRESS(ar, hi_option_flag),
             (u8 *)&param,
             4) != 0)
         {
-            AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BMIWriteMemory for HI_OPTION_DISABLE_DBGLOG\n"));
+            AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("bmi_write_memory for HI_OPTION_DISABLE_DBGLOG\n"));
             return A_ERROR;
         }
         AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("Firmware mode set\n"));
@@ -1484,26 +1484,26 @@ ar6000_configure_target(struct ar6_softc *ar)
 			param = AR6003_REV3_BOARD_EXT_DATA_ADDRESS;
 			ramReservedSz =  AR6003_REV3_RAM_RESERVE_SIZE;
 		}
-		if (BMIWriteMemory(ar->arHifDevice,
+		if (bmi_write_memory(ar->arHifDevice,
 			HOST_INTEREST_ITEM_ADDRESS(ar, hi_board_ext_data),
 						   (u8 *)&param, 4) != 0) {
 				AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
-						("BMIWriteMemory for "
+						("bmi_write_memory for "
 						 "hi_board_ext_data failed\n"));
 				return A_ERROR;
 		}
-		if (BMIWriteMemory(ar->arHifDevice,
+		if (bmi_write_memory(ar->arHifDevice,
 				   HOST_INTEREST_ITEM_ADDRESS(ar,
 				   hi_end_RAM_reserve_sz),
 				   (u8 *)&ramReservedSz, 4) != 0) {
 			AR_DEBUG_PRINTF(ATH_DEBUG_ERR ,
-					("BMIWriteMemory for "
+					("bmi_write_memory for "
 					 "hi_end_RAM_reserve_sz failed\n"));
 			return A_ERROR;
 		}
 	}
 
-        /* since BMIInit is called in the driver layer, we have to set the block
+        /* since bmi_init is called in the driver layer, we have to set the block
          * size here for the target */
 
     if (ar6000_set_htc_params(ar->arHifDevice, ar->arTargetType,
@@ -1710,14 +1710,14 @@ ar6000_avail_ev(void *context, void *hif_handle)
 
     A_INIT_TIMER(&ar->disconnect_timer, disconnect_timer_handler, dev);
 
-    BMIInit();
+    bmi_init();
 
     ar6000_sysfs_bmi_init(ar);
 
     {
         struct bmi_target_info targ_info;
 
-        r = BMIGetTargetInfo(ar->arHifDevice, &targ_info);
+        r = bmi_get_target_info(ar->arHifDevice, &targ_info);
         if (r)
             goto avail_ev_failed;
 
@@ -1849,7 +1849,7 @@ ar6000_restart_endpoint(struct net_device *dev)
     int status = 0;
     struct ar6_softc *ar = (struct ar6_softc *)ar6k_priv(dev);
 
-    BMIInit();
+    bmi_init();
     do {
         if ( (status=ar6000_configure_target(ar))!= 0)
             break;
@@ -2046,7 +2046,7 @@ ar6000_destroy(struct net_device *dev, unsigned int unregister)
     ar6000_sysfs_bmi_deinit(ar);
 
     /* Cleanup BMI */
-    BMICleanup();
+    bmi_cleanup();
 
     /* Clear the tx counters */
     memset(tx_attempt, 0, sizeof(tx_attempt));
@@ -2491,7 +2491,7 @@ int ar6000_init(struct net_device *dev)
 
     /* Do we need to finish the BMI phase */
     if ((wlaninitmode == WLAN_INIT_MODE_USR || wlaninitmode == WLAN_INIT_MODE_DRV) && 
-        (BMIDone(ar->arHifDevice) != 0))
+        (bmi_done(ar->arHifDevice) != 0))
     {
         ret = -EIO;
         goto ar6000_init_done;
@@ -2652,13 +2652,13 @@ int ar6000_init(struct net_device *dev)
 	if (regscanmode) {
 		u32 param;
 
-		if (BMIReadMemory(ar->arHifDevice,
+		if (bmi_read_memory(ar->arHifDevice,
 				  HOST_INTEREST_ITEM_ADDRESS(ar,
 							     hi_option_flag),
 							     (u8 *)&param,
 							     4) != 0) {
 			AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
-					("BMIReadMemory forsetting "
+					("bmi_read_memory forsetting "
 					 "regscanmode failed\n"));
 			return A_ERROR;
 		}
@@ -2668,13 +2668,13 @@ int ar6000_init(struct net_device *dev)
 		else if (regscanmode == 2)
 			param |= HI_OPTION_INIT_REG_SCAN;
 
-		if (BMIWriteMemory(ar->arHifDevice,
+		if (bmi_write_memory(ar->arHifDevice,
 				   HOST_INTEREST_ITEM_ADDRESS(ar,
 							      hi_option_flag),
 							      (u8 *)&param,
 							      4) != 0) {
 			AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
-					("BMIWriteMemory forsetting "
+					("bmi_write_memory forsetting "
 					"regscanmode failed\n"));
 			return A_ERROR;
 		}
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c b/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
index ae7c1dd..e05c94e 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
@@ -230,7 +230,7 @@ int ar6000_htc_raw_open(struct ar6_softc *ar)
             /* Queue buffers to HTC for receive */
             if ((status = HTCAddReceivePkt(ar->arHtcTarget, &buffer->HTCPacket)) != 0)
             {
-                BMIInit();
+                bmi_init();
                 return -EIO;
             }
         }
@@ -263,7 +263,7 @@ int ar6000_htc_raw_open(struct ar6_softc *ar)
 
     /* Start the HTC component */
     if ((status = HTCStart(ar->arHtcTarget)) != 0) {
-        BMIInit();
+        bmi_init();
         return -EIO;
     }
 
@@ -280,7 +280,7 @@ int ar6000_htc_raw_close(struct ar6_softc *ar)
         /* reset the device */
     ar6000_reset_device(ar->arHifDevice, ar->arTargetType, true, false);
     /* Initialize the BMI component */
-    BMIInit();
+    bmi_init();
 
     return 0;
 }
-- 
1.7.0.4

