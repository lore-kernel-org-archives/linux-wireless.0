Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45465 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaGLGyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 02:54:43 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so1969598wgh.27
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2014 23:54:42 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/10] staging: vt6656: vResetCommandTimer remove camel case
Date: Sat, 12 Jul 2014 07:53:47 +0100
Message-Id: <1405148028-4053-9-git-send-email-tvboxspy@gmail.com> (sfid-20140712_085448_116577_97CA5139)
In-Reply-To: <1405148028-4053-1-git-send-email-tvboxspy@gmail.com>
References: <1405148028-4053-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pDevice -> priv

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 76e7f78..9130f14 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -207,12 +207,12 @@ int bScheduleCommand(struct vnt_private *priv, CMD_CODE command, u8 *item0)
 
 }
 
-void vResetCommandTimer(struct vnt_private *pDevice)
+void vResetCommandTimer(struct vnt_private *priv)
 {
-	pDevice->cbFreeCmdQueue = CMD_Q_SIZE;
-	pDevice->uCmdDequeueIdx = 0;
-	pDevice->uCmdEnqueueIdx = 0;
-	pDevice->eCommandState = WLAN_CMD_IDLE;
-	pDevice->bCmdRunning = false;
-	pDevice->bCmdClear = false;
+	priv->cbFreeCmdQueue = CMD_Q_SIZE;
+	priv->uCmdDequeueIdx = 0;
+	priv->uCmdEnqueueIdx = 0;
+	priv->eCommandState = WLAN_CMD_IDLE;
+	priv->bCmdRunning = false;
+	priv->bCmdClear = false;
 }
-- 
1.9.1

