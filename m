Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:64177 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbaGMJn3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 05:43:29 -0400
Received: by mail-we0-f177.google.com with SMTP id u56so2864975wes.36
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 02:43:28 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/13] staging: vt6656: replace typedef enum tagCMD_CODE with enum vnt_cmd
Date: Sun, 13 Jul 2014 10:42:41 +0100
Message-Id: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com> (sfid-20140713_114336_858352_B97ACE6A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing the variables.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h |  2 +-
 drivers/staging/vt6656/wcmd.c   |  8 ++++----
 drivers/staging/vt6656/wcmd.h   | 22 +++++++++++-----------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 789c55d..4630206 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -400,7 +400,7 @@ struct vnt_private {
 
 	CMD_STATE eCommandState;
 
-	CMD_CODE eCommand;
+	enum vnt_cmd command;
 
 	int bStopDataPkt;
 
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index ade0f81..3d9ace2 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -146,13 +146,13 @@ static int s_bCommandComplete(struct vnt_private *priv)
 		return true;
 	}
 
-	priv->eCommand = priv->eCmdQueue[priv->uCmdDequeueIdx].eCmd;
+	priv->command = priv->eCmdQueue[priv->uCmdDequeueIdx].cmd;
 
 	ADD_ONE_WITH_WRAP_AROUND(priv->uCmdDequeueIdx, CMD_Q_SIZE);
 	priv->cbFreeCmdQueue++;
 	priv->bCmdRunning = true;
 
-	switch (priv->eCommand) {
+	switch (priv->command) {
 	case WLAN_CMD_INIT_MAC80211:
 		priv->eCommandState = WLAN_CMD_INIT_MAC80211_START;
 		break;
@@ -186,13 +186,13 @@ static int s_bCommandComplete(struct vnt_private *priv)
 	return true;
 }
 
-int bScheduleCommand(struct vnt_private *priv, CMD_CODE command, u8 *item0)
+int bScheduleCommand(struct vnt_private *priv, enum vnt_cmd command, u8 *item0)
 {
 
 	if (priv->cbFreeCmdQueue == 0)
 		return false;
 
-	priv->eCmdQueue[priv->uCmdEnqueueIdx].eCmd = command;
+	priv->eCmdQueue[priv->uCmdEnqueueIdx].cmd = command;
 
 	ADD_ONE_WITH_WRAP_AROUND(priv->uCmdEnqueueIdx, CMD_Q_SIZE);
 	priv->cbFreeCmdQueue--;
diff --git a/drivers/staging/vt6656/wcmd.h b/drivers/staging/vt6656/wcmd.h
index 98387f3..1d0201a 100644
--- a/drivers/staging/vt6656/wcmd.h
+++ b/drivers/staging/vt6656/wcmd.h
@@ -34,15 +34,15 @@
 #define AUTHENTICATE_TIMEOUT   1000 //ms
 #define ASSOCIATE_TIMEOUT      1000 //ms
 
-// Command code
-typedef enum tagCMD_CODE {
-    WLAN_CMD_INIT_MAC80211,
-    WLAN_CMD_SETPOWER,
-    WLAN_CMD_TBTT_WAKEUP,
-    WLAN_CMD_BECON_SEND,
-    WLAN_CMD_CHANGE_ANTENNA,
-    WLAN_CMD_11H_CHSW,
-} CMD_CODE, *PCMD_CODE;
+/* Command code */
+enum vnt_cmd {
+	WLAN_CMD_INIT_MAC80211,
+	WLAN_CMD_SETPOWER,
+	WLAN_CMD_TBTT_WAKEUP,
+	WLAN_CMD_BECON_SEND,
+	WLAN_CMD_CHANGE_ANTENNA,
+	WLAN_CMD_11H_CHSW,
+};
 
 #define CMD_Q_SIZE              32
 
@@ -57,7 +57,7 @@ typedef enum tagCMD_STATUS {
 } CMD_STATUS, *PCMD_STATUS;
 
 typedef struct tagCMD_ITEM {
-    CMD_CODE eCmd;
+	enum vnt_cmd cmd;
 } CMD_ITEM, *PCMD_ITEM;
 
 // Command state
@@ -75,7 +75,7 @@ struct vnt_private;
 
 void vResetCommandTimer(struct vnt_private *);
 
-int bScheduleCommand(struct vnt_private *, CMD_CODE eCommand, u8 *pbyItem0);
+int bScheduleCommand(struct vnt_private *, enum vnt_cmd, u8 *);
 
 void vRunCommand(struct work_struct *work);
 
-- 
1.9.1

