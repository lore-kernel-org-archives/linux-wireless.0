Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:54296 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaGMJnk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 05:43:40 -0400
Received: by mail-wi0-f175.google.com with SMTP id ho1so1192702wib.2
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 02:43:39 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/13] staging: vt6656: Move and rename s_bCommandComplete to vnt_cmd_complete
Date: Sun, 13 Jul 2014 10:42:47 +0100
Message-Id: <1405244573-10978-7-git-send-email-tvboxspy@gmail.com> (sfid-20140713_114410_754649_7B1839E2)
In-Reply-To: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
References: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove static declaration and moving for function visibility

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c | 108 +++++++++++++++++++++---------------------
 1 file changed, 53 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 37ca3de..8c5a0e8 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -28,7 +28,7 @@
  *      s_vProbeChannel - Active scan channel
  *      s_MgrMakeProbeRequest - Make ProbeRequest packet
  *      CommandTimer - Timer function to handle command
- *      s_bCommandComplete - Command Complete function
+ *	vnt_cmd_complete - Command Complete function
  *      bScheduleCommand - Push Command and wait Command Scheduler to do
  *      vCommandTimer- Command call back functions
  *      vCommandTimerWait- Call back timer
@@ -49,13 +49,61 @@
 #include "rf.h"
 #include "channel.h"
 
-static int s_bCommandComplete(struct vnt_private *);
-
 static void vCommandTimerWait(struct vnt_private *priv, unsigned long msecs)
 {
 	schedule_delayed_work(&priv->run_command_work, msecs_to_jiffies(msecs));
 }
 
+static int vnt_cmd_complete(struct vnt_private *priv)
+{
+
+	priv->command_state = WLAN_CMD_IDLE;
+	if (priv->free_cmd_queue == CMD_Q_SIZE) {
+		/* Command Queue Empty */
+		priv->cmd_running = false;
+		return true;
+	}
+
+	priv->command = priv->cmd_queue[priv->cmd_dequeue_idx];
+
+	ADD_ONE_WITH_WRAP_AROUND(priv->cmd_dequeue_idx, CMD_Q_SIZE);
+	priv->free_cmd_queue++;
+	priv->cmd_running = true;
+
+	switch (priv->command) {
+	case WLAN_CMD_INIT_MAC80211:
+		priv->command_state = WLAN_CMD_INIT_MAC80211_START;
+		break;
+
+	case WLAN_CMD_TBTT_WAKEUP:
+		priv->command_state = WLAN_CMD_TBTT_WAKEUP_START;
+		break;
+
+	case WLAN_CMD_BECON_SEND:
+		priv->command_state = WLAN_CMD_BECON_SEND_START;
+		break;
+
+	case WLAN_CMD_SETPOWER:
+		priv->command_state = WLAN_CMD_SETPOWER_START;
+		break;
+
+	case WLAN_CMD_CHANGE_ANTENNA:
+		priv->command_state = WLAN_CMD_CHANGE_ANTENNA_START;
+		break;
+
+	case WLAN_CMD_11H_CHSW:
+		priv->command_state = WLAN_CMD_11H_CHSW_START;
+		break;
+
+	default:
+		break;
+	}
+
+	vCommandTimerWait(priv, 0);
+
+	return true;
+}
+
 void vRunCommand(struct work_struct *work)
 {
 	struct vnt_private *priv =
@@ -131,61 +179,11 @@ void vRunCommand(struct work_struct *work)
 		break;
 	} //switch
 
-	s_bCommandComplete(priv);
+	vnt_cmd_complete(priv);
 
 	return;
 }
 
-static int s_bCommandComplete(struct vnt_private *priv)
-{
-
-	priv->command_state = WLAN_CMD_IDLE;
-	if (priv->free_cmd_queue == CMD_Q_SIZE) {
-		/* Command Queue Empty */
-		priv->cmd_running = false;
-		return true;
-	}
-
-	priv->command = priv->cmd_queue[priv->cmd_dequeue_idx];
-
-	ADD_ONE_WITH_WRAP_AROUND(priv->cmd_dequeue_idx, CMD_Q_SIZE);
-	priv->free_cmd_queue++;
-	priv->cmd_running = true;
-
-	switch (priv->command) {
-	case WLAN_CMD_INIT_MAC80211:
-		priv->command_state = WLAN_CMD_INIT_MAC80211_START;
-		break;
-
-	case WLAN_CMD_TBTT_WAKEUP:
-		priv->command_state = WLAN_CMD_TBTT_WAKEUP_START;
-		break;
-
-	case WLAN_CMD_BECON_SEND:
-		priv->command_state = WLAN_CMD_BECON_SEND_START;
-		break;
-
-	case WLAN_CMD_SETPOWER:
-		priv->command_state = WLAN_CMD_SETPOWER_START;
-		break;
-
-	case WLAN_CMD_CHANGE_ANTENNA:
-		priv->command_state = WLAN_CMD_CHANGE_ANTENNA_START;
-		break;
-
-	case WLAN_CMD_11H_CHSW:
-		priv->command_state = WLAN_CMD_11H_CHSW_START;
-		break;
-
-	default:
-		break;
-	}
-
-	vCommandTimerWait(priv, 0);
-
-	return true;
-}
-
 int bScheduleCommand(struct vnt_private *priv, enum vnt_cmd command, u8 *item0)
 {
 
@@ -198,7 +196,7 @@ int bScheduleCommand(struct vnt_private *priv, enum vnt_cmd command, u8 *item0)
 	priv->free_cmd_queue--;
 
 	if (priv->cmd_running == false)
-		s_bCommandComplete(priv);
+		vnt_cmd_complete(priv);
 
 	return true;
 
-- 
1.9.1

