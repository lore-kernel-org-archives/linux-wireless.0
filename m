Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38333 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaJYTJP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:09:15 -0400
Received: by mail-wi0-f173.google.com with SMTP id ex7so3494312wid.12
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:09:13 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 29/31] staging: vt6655: device_init_registers replace spin lock
Date: Sat, 25 Oct 2014 09:20:39 +0100
Message-Id: <1414225241-5480-30-git-send-email-tvboxspy@gmail.com> (sfid-20141025_210918_028797_B31156A3)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use spin_lock_irqsave and spin_unlock_irqrestore.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index d7dd002..c5eca10 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -406,6 +406,7 @@ device_set_options(struct vnt_private *pDevice)
 
 static void device_init_registers(struct vnt_private *pDevice)
 {
+	unsigned long flags;
 	unsigned int ii;
 	unsigned char byValue;
 	unsigned char byValue1;
@@ -439,11 +440,11 @@ static void device_init_registers(struct vnt_private *pDevice)
 	/* Get Local ID */
 	VNSvInPortB(pDevice->PortOffset + MAC_REG_LOCALID, &pDevice->byLocalID);
 
-	spin_lock_irq(&pDevice->lock);
+	spin_lock_irqsave(&pDevice->lock, flags);
 
 	SROMvReadAllContents(pDevice->PortOffset, pDevice->abyEEPROM);
 
-	spin_unlock_irq(&pDevice->lock);
+	spin_unlock_irqrestore(&pDevice->lock, flags);
 
 	/* Get Channel range */
 	pDevice->byMinChannel = 1;
-- 
1.9.1

