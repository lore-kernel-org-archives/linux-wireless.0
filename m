Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:39836 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaGLGyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 02:54:37 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so256291wib.2
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2014 23:54:36 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/10] staging: vt6656: remove unused variables from struct tagCMD_ITEM
Date: Sat, 12 Jul 2014 07:53:43 +0100
Message-Id: <1405148028-4053-5-git-send-email-tvboxspy@gmail.com> (sfid-20140712_085441_452475_AF7F554F)
In-Reply-To: <1405148028-4053-1-git-send-email-tvboxspy@gmail.com>
References: <1405148028-4053-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also remove local variables

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c | 6 +-----
 drivers/staging/vt6656/wcmd.h | 4 ----
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 5621c14..1987d5c 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -141,8 +141,6 @@ void vRunCommand(struct work_struct *work)
 
 static int s_bCommandComplete(struct vnt_private *pDevice)
 {
-	int bRadioCmd = false;
-	int bForceSCAN = true;
 
 	pDevice->eCommandState = WLAN_CMD_IDLE;
 	if (pDevice->cbFreeCmdQueue == CMD_Q_SIZE) {
@@ -151,8 +149,7 @@ static int s_bCommandComplete(struct vnt_private *pDevice)
 		return true;
 	} else {
 		pDevice->eCommand = pDevice->eCmdQueue[pDevice->uCmdDequeueIdx].eCmd;
-		bRadioCmd = pDevice->eCmdQueue[pDevice->uCmdDequeueIdx].bRadioCmd;
-		bForceSCAN = pDevice->eCmdQueue[pDevice->uCmdDequeueIdx].bForceSCAN;
+
 		ADD_ONE_WITH_WRAP_AROUND(pDevice->uCmdDequeueIdx, CMD_Q_SIZE);
 		pDevice->cbFreeCmdQueue++;
 		pDevice->bCmdRunning = true;
@@ -197,7 +194,6 @@ int bScheduleCommand(struct vnt_private *pDevice,
 	if (pDevice->cbFreeCmdQueue == 0)
 		return false;
 	pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].eCmd = eCommand;
-	pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].bForceSCAN = true;
 
 	ADD_ONE_WITH_WRAP_AROUND(pDevice->uCmdEnqueueIdx, CMD_Q_SIZE);
 	pDevice->cbFreeCmdQueue--;
diff --git a/drivers/staging/vt6656/wcmd.h b/drivers/staging/vt6656/wcmd.h
index 4fe34b5..98387f3 100644
--- a/drivers/staging/vt6656/wcmd.h
+++ b/drivers/staging/vt6656/wcmd.h
@@ -58,10 +58,6 @@ typedef enum tagCMD_STATUS {
 
 typedef struct tagCMD_ITEM {
     CMD_CODE eCmd;
-    bool     bNeedRadioOFF;
-    bool     bRadioCmd;
-    bool     bForceSCAN;
-    u16     wDeAuthenReason;
 } CMD_ITEM, *PCMD_ITEM;
 
 // Command state
-- 
1.9.1

