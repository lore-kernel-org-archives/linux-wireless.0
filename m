Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:64719 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbaJ2RqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:46:04 -0400
Received: by mail-wg0-f51.google.com with SMTP id l18so3896600wgh.10
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:46:03 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 29/34] staging: vt6655: device_init_registers replace spin lock
Date: Wed, 29 Oct 2014 17:44:04 +0000
Message-Id: <1414604649-9105-30-git-send-email-tvboxspy@gmail.com> (sfid-20141029_184620_967512_138B9080)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
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
2.1.0

