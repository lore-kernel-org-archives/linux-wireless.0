Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20463 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757002Ab1CNR7X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 13:59:23 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 10:59:00 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 07/38] ath6kl: remove-typedef HIF_DEVICE_IRQ_YIELD_PARAMS
Date: Mon, 14 Mar 2011 10:58:41 -0700
Message-ID: <1300125552-24422-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s HIF_DEVICE_IRQ_YIELD_PARAMS \
	"struct hif_device_irq_yield_params" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h |    2 +-
 drivers/staging/ath6kl/include/hif.h      |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
index 4b69f91..e367288 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
@@ -129,7 +129,7 @@ struct ar6k_device {
     HIF_DEVICE_IRQ_PROCESSING_MODE  HifIRQProcessingMode;
     HIF_MASK_UNMASK_RECV_EVENT      HifMaskUmaskRecvEvent;
     bool                          HifAttached;
-    HIF_DEVICE_IRQ_YIELD_PARAMS     HifIRQYieldParams;
+    struct hif_device_irq_yield_params     HifIRQYieldParams;
     bool                          DSRCanYield;
     int                             CurrentDSRRecvCount;
     HIF_DEVICE_SCATTER_SUPPORT_INFO HifScatterInfo;
diff --git a/drivers/staging/ath6kl/include/hif.h b/drivers/staging/ath6kl/include/hif.h
index 3421a59..044af7e 100644
--- a/drivers/staging/ath6kl/include/hif.h
+++ b/drivers/staging/ath6kl/include/hif.h
@@ -190,7 +190,7 @@ typedef enum {
  *   HIF_DEVICE_GET_IRQ_YIELD_PARAMS
  * 
  *   input : none
- *   output : HIF_DEVICE_IRQ_YIELD_PARAMS
+ *   output : struct hif_device_irq_yield_params
  *   note: This query checks if the HIF layer wishes to impose a processing yield count for the DSR handler.
  *   The DSR callback handler will exit after a fixed number of RX packets or events are processed.  
  *   This query is only made if the device reports an IRQ processing mode of HIF_DEVICE_IRQ_SYNC_ONLY. 
@@ -265,9 +265,9 @@ typedef enum {
                             */
 } HIF_DEVICE_POWER_CHANGE_TYPE;
 
-typedef struct {
+struct hif_device_irq_yield_params {
     int     RecvPacketYieldCount; /* max number of packets to force DSR to return */
-} HIF_DEVICE_IRQ_YIELD_PARAMS;
+};
 
 
 typedef struct _HIF_SCATTER_ITEM {
-- 
1.7.4.15.g7811d

