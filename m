Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29970 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310Ab1CKC4c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:56:32 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:56:09 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 13/20] ath6kl: remove-typedef AR6K_IRQ_ENABLE_REGISTERS
Date: Thu, 10 Mar 2011 18:55:40 -0800
Message-ID: <1299812147-12069-14-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
References: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s AR6K_IRQ_ENABLE_REGISTERS \
	"struct ar6k_irq_enable_registers" drivers/staging/ath6kl/

Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c        |    8 ++++----
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h        |   10 +++++-----
 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c |    2 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c  |    2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
index 85d45a7..77fa618 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
@@ -219,7 +219,7 @@ int DevSetup(struct ar6k_device *pDev)
 int DevEnableInterrupts(struct ar6k_device *pDev)
 {
     int                  status;
-    AR6K_IRQ_ENABLE_REGISTERS regs;
+    struct ar6k_irq_enable_registers regs;
 
     LOCK_AR6K(pDev);
 
@@ -278,7 +278,7 @@ int DevEnableInterrupts(struct ar6k_device *pDev)
 
 int DevDisableInterrupts(struct ar6k_device *pDev)
 {
-    AR6K_IRQ_ENABLE_REGISTERS regs;
+    struct ar6k_irq_enable_registers regs;
 
     LOCK_AR6K(pDev);
         /* Disable all interrupts */
@@ -407,7 +407,7 @@ static int DevDoEnableDisableRecvNormal(struct ar6k_device *pDev, bool EnableRec
 {
     int                  status = 0;
     HTC_PACKET                *pIOPacket = NULL;
-    AR6K_IRQ_ENABLE_REGISTERS regs;
+    struct ar6k_irq_enable_registers regs;
 
         /* take the lock to protect interrupt enable shadows */
     LOCK_AR6K(pDev);
@@ -538,7 +538,7 @@ int DevWaitForPendingRecv(struct ar6k_device *pDev,u32 TimeoutInMs,bool *pbIsRec
 
 void DevDumpRegisters(struct ar6k_device               *pDev,
                       AR6K_IRQ_PROC_REGISTERS   *pIrqProcRegs,
-                      AR6K_IRQ_ENABLE_REGISTERS *pIrqEnableRegs)
+                      struct ar6k_irq_enable_registers *pIrqEnableRegs)
 {
 
     AR_DEBUG_PRINTF(ATH_DEBUG_ANY, ("\n<------- Register Table -------->\n"));
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
index 0bee46a..fc781d1 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
@@ -58,12 +58,12 @@ typedef PREPACK struct _AR6K_IRQ_PROC_REGISTERS {
 
 #define AR6K_IRQ_PROC_REGS_SIZE sizeof(AR6K_IRQ_PROC_REGISTERS)
 
-typedef PREPACK struct _AR6K_IRQ_ENABLE_REGISTERS {
+PREPACK struct ar6k_irq_enable_registers {
     u8 int_status_enable;
     u8 cpu_int_status_enable;
     u8 error_status_enable;
     u8 counter_int_status_enable;
-} POSTPACK AR6K_IRQ_ENABLE_REGISTERS;
+} POSTPACK;
 
 PREPACK struct ar6k_gmbox_ctrl_registers {
     u8 int_status_enable;
@@ -71,7 +71,7 @@ PREPACK struct ar6k_gmbox_ctrl_registers {
 
 #include "athendpack.h"
 
-#define AR6K_IRQ_ENABLE_REGS_SIZE sizeof(AR6K_IRQ_ENABLE_REGISTERS)
+#define AR6K_IRQ_ENABLE_REGS_SIZE sizeof(struct ar6k_irq_enable_registers)
 
 #define AR6K_REG_IO_BUFFER_SIZE     32
 #define AR6K_MAX_REG_IO_BUFFERS     8
@@ -110,7 +110,7 @@ struct ar6k_device {
     u8 _Pad1[A_CACHE_LINE_PAD];
     AR6K_IRQ_PROC_REGISTERS     IrqProcRegisters;   /* cache-line safe with pads around */
     u8 _Pad2[A_CACHE_LINE_PAD];
-    AR6K_IRQ_ENABLE_REGISTERS   IrqEnableRegisters; /* cache-line safe with pads around */
+    struct ar6k_irq_enable_registers   IrqEnableRegisters; /* cache-line safe with pads around */
     u8 _Pad3[A_CACHE_LINE_PAD];
     void                        *HIFDevice;
     u32 BlockSize;
@@ -160,7 +160,7 @@ int DevCheckPendingRecvMsgsAsync(void *context);
 void     DevAsyncIrqProcessComplete(struct ar6k_device *pDev);
 void     DevDumpRegisters(struct ar6k_device               *pDev,
                           AR6K_IRQ_PROC_REGISTERS   *pIrqProcRegs,
-                          AR6K_IRQ_ENABLE_REGISTERS *pIrqEnableRegs);
+                          struct ar6k_irq_enable_registers *pIrqEnableRegs);
 
 #define DEV_STOP_RECV_ASYNC true
 #define DEV_STOP_RECV_SYNC  false
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
index aa45590..3aafbea 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
@@ -747,7 +747,7 @@ int DevDsrHandler(void *context)
 void DumpAR6KDevState(struct ar6k_device *pDev)
 {
     int                    status;
-    AR6K_IRQ_ENABLE_REGISTERS   regs;
+    struct ar6k_irq_enable_registers   regs;
     AR6K_IRQ_PROC_REGISTERS     procRegs;
 
     LOCK_AR6K(pDev);
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
index cbfbdea..1b44d07 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
@@ -77,7 +77,7 @@ static void DevGMboxIRQActionAsyncHandler(void *Context, HTC_PACKET *pPacket)
 static int DevGMboxCounterEnableDisable(struct ar6k_device *pDev, GMBOX_IRQ_ACTION_TYPE IrqAction, bool AsyncMode)
 {
     int                  status = 0;
-    AR6K_IRQ_ENABLE_REGISTERS regs;
+    struct ar6k_irq_enable_registers regs;
     HTC_PACKET                *pIOPacket = NULL;  
     
     LOCK_AR6K(pDev);
-- 
1.7.4.15.g7811d

