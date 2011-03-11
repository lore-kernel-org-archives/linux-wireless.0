Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29971 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab1CKC4g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:56:36 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:56:13 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 14/20] ath6kl: remove-typedef AR6K_IRQ_PROC_REGISTERS
Date: Thu, 10 Mar 2011 18:55:41 -0800
Message-ID: <1299812147-12069-15-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
References: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s AR6K_IRQ_PROC_REGISTERS \
	"struct ar6k_irq_proc_registers" drivers/staging/ath6kl/

Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c        |    2 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h        |   10 +++++-----
 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c |    4 ++--
 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c  |    2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
index 77fa618..bdaffd7 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
@@ -537,7 +537,7 @@ int DevWaitForPendingRecv(struct ar6k_device *pDev,u32 TimeoutInMs,bool *pbIsRec
 }
 
 void DevDumpRegisters(struct ar6k_device               *pDev,
-                      AR6K_IRQ_PROC_REGISTERS   *pIrqProcRegs,
+                      struct ar6k_irq_proc_registers   *pIrqProcRegs,
                       struct ar6k_irq_enable_registers *pIrqEnableRegs)
 {
 
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
index fc781d1..247cf56 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
@@ -43,7 +43,7 @@
 //#define MBOXHW_UNIT_TEST 1
 
 #include "athstartpack.h"
-typedef PREPACK struct _AR6K_IRQ_PROC_REGISTERS {
+PREPACK struct ar6k_irq_proc_registers {
     u8 host_int_status;
     u8 cpu_int_status;
     u8 error_int_status;
@@ -54,9 +54,9 @@ typedef PREPACK struct _AR6K_IRQ_PROC_REGISTERS {
     u8 gmbox_rx_avail;
     u32 rx_lookahead[2];
     u32 rx_gmbox_lookahead_alias[2];
-} POSTPACK AR6K_IRQ_PROC_REGISTERS;
+} POSTPACK;
 
-#define AR6K_IRQ_PROC_REGS_SIZE sizeof(AR6K_IRQ_PROC_REGISTERS)
+#define AR6K_IRQ_PROC_REGS_SIZE sizeof(struct ar6k_irq_proc_registers)
 
 PREPACK struct ar6k_irq_enable_registers {
     u8 int_status_enable;
@@ -108,7 +108,7 @@ struct ar6k_gmbox_info {
 struct ar6k_device {
     A_MUTEX_T                   Lock;
     u8 _Pad1[A_CACHE_LINE_PAD];
-    AR6K_IRQ_PROC_REGISTERS     IrqProcRegisters;   /* cache-line safe with pads around */
+    struct ar6k_irq_proc_registers     IrqProcRegisters;   /* cache-line safe with pads around */
     u8 _Pad2[A_CACHE_LINE_PAD];
     struct ar6k_irq_enable_registers   IrqEnableRegisters; /* cache-line safe with pads around */
     u8 _Pad3[A_CACHE_LINE_PAD];
@@ -159,7 +159,7 @@ int DevDsrHandler(void *context);
 int DevCheckPendingRecvMsgsAsync(void *context);
 void     DevAsyncIrqProcessComplete(struct ar6k_device *pDev);
 void     DevDumpRegisters(struct ar6k_device               *pDev,
-                          AR6K_IRQ_PROC_REGISTERS   *pIrqProcRegs,
+                          struct ar6k_irq_proc_registers   *pIrqProcRegs,
                           struct ar6k_irq_enable_registers *pIrqEnableRegs);
 
 #define DEV_STOP_RECV_ASYNC true
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
index 3aafbea..bac4f93 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
@@ -331,7 +331,7 @@ static void DevGetEventAsyncHandler(void *Context, HTC_PACKET *pPacket)
             }
         } else {
                 /* standard interrupt table handling.... */
-            AR6K_IRQ_PROC_REGISTERS *pReg = (AR6K_IRQ_PROC_REGISTERS *)pPacket->pBuffer;
+            struct ar6k_irq_proc_registers *pReg = (struct ar6k_irq_proc_registers *)pPacket->pBuffer;
             u8 host_int_status;
 
             host_int_status = pReg->host_int_status & pDev->IrqEnableRegisters.int_status_enable;
@@ -748,7 +748,7 @@ void DumpAR6KDevState(struct ar6k_device *pDev)
 {
     int                    status;
     struct ar6k_irq_enable_registers   regs;
-    AR6K_IRQ_PROC_REGISTERS     procRegs;
+    struct ar6k_irq_proc_registers     procRegs;
 
     LOCK_AR6K(pDev);
         /* copy into our temp area */
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
index 1b44d07..106f9bf 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
@@ -638,7 +638,7 @@ int DevGMboxRecvLookAheadPeek(struct ar6k_device *pDev, u8 *pLookAheadBuffer, in
 {
 
     int                    status = 0;
-    AR6K_IRQ_PROC_REGISTERS     procRegs;
+    struct ar6k_irq_proc_registers     procRegs;
     int                         maxCopy;
   
     do {
-- 
1.7.4.15.g7811d

