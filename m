Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41683 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbaGMJnb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 05:43:31 -0400
Received: by mail-wi0-f178.google.com with SMTP id hi2so1185588wib.11
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 02:43:30 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/13] staging: vt6656: replace typedef enum tagCMD_STATE with enum vnt_cmd_state
Date: Sun, 13 Jul 2014 10:42:42 +0100
Message-Id: <1405244573-10978-2-git-send-email-tvboxspy@gmail.com> (sfid-20140713_114337_584410_E87B72D5)
In-Reply-To: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
References: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing variables.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h |  2 +-
 drivers/staging/vt6656/wcmd.c   | 18 +++++++++---------
 drivers/staging/vt6656/wcmd.h   | 20 ++++++++++----------
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 4630206..0c9166e 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -398,7 +398,7 @@ struct vnt_private {
 	/* Beacon releated */
 	u16 wSeqCounter;
 
-	CMD_STATE eCommandState;
+	enum vnt_cmd_state command_state;
 
 	enum vnt_cmd command;
 
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 3d9ace2..e0ad20a 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -67,7 +67,7 @@ void vRunCommand(struct work_struct *work)
 	if (priv->bCmdRunning != true)
 		return;
 
-	switch (priv->eCommandState) {
+	switch (priv->command_state) {
 	case WLAN_CMD_INIT_MAC80211_START:
 		if (priv->mac_hw)
 			break;
@@ -139,7 +139,7 @@ void vRunCommand(struct work_struct *work)
 static int s_bCommandComplete(struct vnt_private *priv)
 {
 
-	priv->eCommandState = WLAN_CMD_IDLE;
+	priv->command_state = WLAN_CMD_IDLE;
 	if (priv->cbFreeCmdQueue == CMD_Q_SIZE) {
 		/* Command Queue Empty */
 		priv->bCmdRunning = false;
@@ -154,27 +154,27 @@ static int s_bCommandComplete(struct vnt_private *priv)
 
 	switch (priv->command) {
 	case WLAN_CMD_INIT_MAC80211:
-		priv->eCommandState = WLAN_CMD_INIT_MAC80211_START;
+		priv->command_state = WLAN_CMD_INIT_MAC80211_START;
 		break;
 
 	case WLAN_CMD_TBTT_WAKEUP:
-		priv->eCommandState = WLAN_CMD_TBTT_WAKEUP_START;
+		priv->command_state = WLAN_CMD_TBTT_WAKEUP_START;
 		break;
 
 	case WLAN_CMD_BECON_SEND:
-		priv->eCommandState = WLAN_CMD_BECON_SEND_START;
+		priv->command_state = WLAN_CMD_BECON_SEND_START;
 		break;
 
 	case WLAN_CMD_SETPOWER:
-		priv->eCommandState = WLAN_CMD_SETPOWER_START;
+		priv->command_state = WLAN_CMD_SETPOWER_START;
 		break;
 
 	case WLAN_CMD_CHANGE_ANTENNA:
-		priv->eCommandState = WLAN_CMD_CHANGE_ANTENNA_START;
+		priv->command_state = WLAN_CMD_CHANGE_ANTENNA_START;
 		break;
 
 	case WLAN_CMD_11H_CHSW:
-		priv->eCommandState = WLAN_CMD_11H_CHSW_START;
+		priv->command_state = WLAN_CMD_11H_CHSW_START;
 		break;
 
 	default:
@@ -209,7 +209,7 @@ void vResetCommandTimer(struct vnt_private *priv)
 	priv->cbFreeCmdQueue = CMD_Q_SIZE;
 	priv->uCmdDequeueIdx = 0;
 	priv->uCmdEnqueueIdx = 0;
-	priv->eCommandState = WLAN_CMD_IDLE;
+	priv->command_state = WLAN_CMD_IDLE;
 	priv->bCmdRunning = false;
 	priv->bCmdClear = false;
 }
diff --git a/drivers/staging/vt6656/wcmd.h b/drivers/staging/vt6656/wcmd.h
index 1d0201a..283df61 100644
--- a/drivers/staging/vt6656/wcmd.h
+++ b/drivers/staging/vt6656/wcmd.h
@@ -60,16 +60,16 @@ typedef struct tagCMD_ITEM {
 	enum vnt_cmd cmd;
 } CMD_ITEM, *PCMD_ITEM;
 
-// Command state
-typedef enum tagCMD_STATE {
-    WLAN_CMD_INIT_MAC80211_START,
-    WLAN_CMD_SETPOWER_START,
-    WLAN_CMD_TBTT_WAKEUP_START,
-    WLAN_CMD_BECON_SEND_START,
-    WLAN_CMD_CHANGE_ANTENNA_START,
-    WLAN_CMD_11H_CHSW_START,
-    WLAN_CMD_IDLE
-} CMD_STATE, *PCMD_STATE;
+/* Command state */
+enum vnt_cmd_state {
+	WLAN_CMD_INIT_MAC80211_START,
+	WLAN_CMD_SETPOWER_START,
+	WLAN_CMD_TBTT_WAKEUP_START,
+	WLAN_CMD_BECON_SEND_START,
+	WLAN_CMD_CHANGE_ANTENNA_START,
+	WLAN_CMD_11H_CHSW_START,
+	WLAN_CMD_IDLE
+};
 
 struct vnt_private;
 
-- 
1.9.1

