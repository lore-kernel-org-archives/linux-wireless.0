Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:60034 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbaGLGym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 02:54:42 -0400
Received: by mail-we0-f172.google.com with SMTP id x48so213461wes.3
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2014 23:54:40 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/10] staging: vt6656: bScheduleCommand remove camel case
Date: Sat, 12 Jul 2014 07:53:46 +0100
Message-Id: <1405148028-4053-8-git-send-email-tvboxspy@gmail.com> (sfid-20140712_085447_229327_E32B2AAE)
In-Reply-To: <1405148028-4053-1-git-send-email-tvboxspy@gmail.com>
References: <1405148028-4053-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes
pDevice -> priv
eCommand -> command
pbyItem0 -> item0

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index cdd828c..76e7f78 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -189,19 +189,19 @@ static int s_bCommandComplete(struct vnt_private *priv)
 	return true;
 }
 
-int bScheduleCommand(struct vnt_private *pDevice,
-		CMD_CODE eCommand, u8 *pbyItem0)
+int bScheduleCommand(struct vnt_private *priv, CMD_CODE command, u8 *item0)
 {
 
-	if (pDevice->cbFreeCmdQueue == 0)
+	if (priv->cbFreeCmdQueue == 0)
 		return false;
-	pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].eCmd = eCommand;
 
-	ADD_ONE_WITH_WRAP_AROUND(pDevice->uCmdEnqueueIdx, CMD_Q_SIZE);
-	pDevice->cbFreeCmdQueue--;
+	priv->eCmdQueue[priv->uCmdEnqueueIdx].eCmd = command;
 
-	if (pDevice->bCmdRunning == false)
-		s_bCommandComplete(pDevice);
+	ADD_ONE_WITH_WRAP_AROUND(priv->uCmdEnqueueIdx, CMD_Q_SIZE);
+	priv->cbFreeCmdQueue--;
+
+	if (priv->bCmdRunning == false)
+		s_bCommandComplete(priv);
 
 	return true;
 
-- 
1.9.1

