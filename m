Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:58974 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975AbaGWUft (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 16:35:49 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 1/2] staging: vt6655: Fix Warning on boot handle_irq_event_percpu.
Date: Wed, 23 Jul 2014 21:35:11 +0100
Message-Id: <1406147712-3152-1-git-send-email-tvboxspy@gmail.com> (sfid-20140723_223556_078463_C8B6032D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WARNING: CPU: 0 PID: 929 at /home/apw/COD/linux/kernel/irq/handle.c:147 handle_irq_event_percpu+0x1d1/0x1e0()
irq 17 handler device_intr+0x0/0xa80 [vt6655_stage] enabled interrupts

Using spin_lock_irqsave appears to fix this.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org>

---
 drivers/staging/vt6655/device_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 5eeb19e..a0863ca 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -2322,6 +2322,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 	int             handled = 0;
 	unsigned char byData = 0;
 	int             ii = 0;
+	unsigned long flags;
 
 	MACvReadISR(pDevice->PortOffset, &pDevice->dwIsr);
 
@@ -2335,7 +2336,8 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 
 	handled = 1;
 	MACvIntDisable(pDevice->PortOffset);
-	spin_lock_irq(&pDevice->lock);
+
+	spin_lock_irqsave(&pDevice->lock, flags);
 
 	//Make sure current page is 0
 	VNSvInPortB(pDevice->PortOffset + MAC_REG_PAGE1SEL, &byOrgPageSel);
@@ -2564,7 +2566,8 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 	if (byOrgPageSel == 1)
 		MACvSelectPage1(pDevice->PortOffset);
 
-	spin_unlock_irq(&pDevice->lock);
+	spin_unlock_irqrestore(&pDevice->lock, flags);
+
 	MACvIntEnable(pDevice->PortOffset, IMR_MASK_VALUE);
 
 	return IRQ_RETVAL(handled);
-- 
1.9.1

