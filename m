Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20466 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757006Ab1CNR7Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 13:59:25 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 10:59:02 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 08/38] ath6kl: remove-typedef HIF_DEVICE_MBOX_INFO
Date: Mon, 14 Mar 2011 10:58:42 -0700
Message-ID: <1300125552-24422-9-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s HIF_DEVICE_MBOX_INFO \
	"struct hif_device_mbox_info" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../staging/ath6kl/hif/common/hif_sdio_common.h    |    2 +-
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |    4 ++--
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |    2 +-
 drivers/staging/ath6kl/include/hif.h               |    6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ath6kl/hif/common/hif_sdio_common.h b/drivers/staging/ath6kl/hif/common/hif_sdio_common.h
index 9939a4a..93a2adc 100644
--- a/drivers/staging/ath6kl/hif/common/hif_sdio_common.h
+++ b/drivers/staging/ath6kl/hif/common/hif_sdio_common.h
@@ -58,7 +58,7 @@
 #define HIF_DEFAULT_IO_BLOCK_SIZE          128
 
     /* set extended MBOX window information for SDIO interconnects */
-static INLINE void SetExtendedMboxWindowInfo(u16 Manfid, HIF_DEVICE_MBOX_INFO *pInfo)
+static INLINE void SetExtendedMboxWindowInfo(u16 Manfid, struct hif_device_mbox_info *pInfo)
 {
     switch (Manfid & MANUFACTURER_ID_AR6K_BASE_MASK) {                   
         case MANUFACTURER_ID_AR6002_BASE :
diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
index 8a1cedb..9b947b4 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
@@ -710,9 +710,9 @@ HIFConfigureDevice(HIF_DEVICE *device, HIF_DEVICE_CONFIG_OPCODE opcode,
                 ((u32 *)config)[count] = HIF_MBOX_START_ADDR(count);
             }
             
-            if (configLen >= sizeof(HIF_DEVICE_MBOX_INFO)) {    
+            if (configLen >= sizeof(struct hif_device_mbox_info)) {    
                 SetExtendedMboxWindowInfo((u16)device->func->device,
-                                          (HIF_DEVICE_MBOX_INFO *)config);
+                                          (struct hif_device_mbox_info *)config);
             }
                         
             break;
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
index e367288..85c5915 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
@@ -115,7 +115,7 @@ struct ar6k_device {
     void                        *HIFDevice;
     u32 BlockSize;
     u32 BlockMask;
-    HIF_DEVICE_MBOX_INFO        MailBoxInfo;
+    struct hif_device_mbox_info        MailBoxInfo;
     HIF_PENDING_EVENTS_FUNC     GetPendingEventsFunc;
     void                        *HTCContext;
     HTC_PACKET_QUEUE            RegisterIOList;
diff --git a/drivers/staging/ath6kl/include/hif.h b/drivers/staging/ath6kl/include/hif.h
index 044af7e..8df01b3 100644
--- a/drivers/staging/ath6kl/include/hif.h
+++ b/drivers/staging/ath6kl/include/hif.h
@@ -153,7 +153,7 @@ typedef enum {
  *
  *   HIF_DEVICE_GET_MBOX_ADDR
  *   input : none
- *   output : HIF_DEVICE_MBOX_INFO
+ *   output : struct hif_device_mbox_info
  *   notes: 
  *
  *   HIF_DEVICE_GET_PENDING_EVENTS_FUNC
@@ -235,7 +235,7 @@ typedef enum _MBOX_BUF_IF_TYPE {
     MBOX_BUS_IF_SPI = 1,    
 } MBOX_BUF_IF_TYPE;
 
-typedef struct {
+struct hif_device_mbox_info {
     u32 MboxAddresses[4];  /* must be first element for legacy HIFs that return the address in
                                    and ARRAY of 32-bit words */
     
@@ -247,7 +247,7 @@ typedef struct {
     u32 GMboxSize;
     u32 Flags;             /* flags to describe mbox behavior or usage */
     MBOX_BUF_IF_TYPE MboxBusIFType;   /* mailbox bus interface type */
-} HIF_DEVICE_MBOX_INFO;
+};
 
 typedef enum {
     HIF_DEVICE_IRQ_SYNC_ONLY,   /* for HIF implementations that require the DSR to process all
-- 
1.7.4.15.g7811d

