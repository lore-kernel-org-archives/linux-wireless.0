Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39409 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaGMJnh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 05:43:37 -0400
Received: by mail-wi0-f177.google.com with SMTP id ho1so1186877wib.10
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 02:43:35 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/13] staging: vt6656: replace camel case from command variables
Date: Sun, 13 Jul 2014 10:42:45 +0100
Message-Id: <1405244573-10978-5-git-send-email-tvboxspy@gmail.com> (sfid-20140713_114350_720374_F8FE2629)
In-Reply-To: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
References: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
uCmdDequeueIdx -> cmd_dequeue_idx
uCmdEnqueueIdx -> cmd_enqueue_idx
cbFreeCmdQueue -> free_cmd_queue
bCmdRunning -> cmd_running

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   |  8 ++++----
 drivers/staging/vt6656/main_usb.c |  2 +-
 drivers/staging/vt6656/wcmd.c     | 32 ++++++++++++++++----------------
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index a1ed376..436f109 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -407,10 +407,10 @@ struct vnt_private {
 	/* 802.11 counter */
 
 	enum vnt_cmd cmd_queue[CMD_Q_SIZE];
-	u32 uCmdDequeueIdx;
-	u32 uCmdEnqueueIdx;
-	u32 cbFreeCmdQueue;
-	int bCmdRunning;
+	u32 cmd_dequeue_idx;
+	u32 cmd_enqueue_idx;
+	u32 free_cmd_queue;
+	int cmd_running;
 
 	unsigned long key_entry_inuse;
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 4cdf29e..34b6148 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -708,7 +708,7 @@ static void vnt_stop(struct ieee80211_hw *hw)
 
 	cancel_delayed_work_sync(&priv->run_command_work);
 
-	priv->bCmdRunning = false;
+	priv->cmd_running = false;
 
 	priv->flags &= ~DEVICE_FLAGS_OPENED;
 
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index fa7c7b6..37ca3de 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -64,7 +64,7 @@ void vRunCommand(struct work_struct *work)
 	if (priv->Flags & fMP_DISCONNECTED)
 		return;
 
-	if (priv->bCmdRunning != true)
+	if (priv->cmd_running != true)
 		return;
 
 	switch (priv->command_state) {
@@ -140,17 +140,17 @@ static int s_bCommandComplete(struct vnt_private *priv)
 {
 
 	priv->command_state = WLAN_CMD_IDLE;
-	if (priv->cbFreeCmdQueue == CMD_Q_SIZE) {
+	if (priv->free_cmd_queue == CMD_Q_SIZE) {
 		/* Command Queue Empty */
-		priv->bCmdRunning = false;
+		priv->cmd_running = false;
 		return true;
 	}
 
-	priv->command = priv->cmd_queue[priv->uCmdDequeueIdx];
+	priv->command = priv->cmd_queue[priv->cmd_dequeue_idx];
 
-	ADD_ONE_WITH_WRAP_AROUND(priv->uCmdDequeueIdx, CMD_Q_SIZE);
-	priv->cbFreeCmdQueue++;
-	priv->bCmdRunning = true;
+	ADD_ONE_WITH_WRAP_AROUND(priv->cmd_dequeue_idx, CMD_Q_SIZE);
+	priv->free_cmd_queue++;
+	priv->cmd_running = true;
 
 	switch (priv->command) {
 	case WLAN_CMD_INIT_MAC80211:
@@ -189,15 +189,15 @@ static int s_bCommandComplete(struct vnt_private *priv)
 int bScheduleCommand(struct vnt_private *priv, enum vnt_cmd command, u8 *item0)
 {
 
-	if (priv->cbFreeCmdQueue == 0)
+	if (priv->free_cmd_queue == 0)
 		return false;
 
-	priv->cmd_queue[priv->uCmdEnqueueIdx] = command;
+	priv->cmd_queue[priv->cmd_enqueue_idx] = command;
 
-	ADD_ONE_WITH_WRAP_AROUND(priv->uCmdEnqueueIdx, CMD_Q_SIZE);
-	priv->cbFreeCmdQueue--;
+	ADD_ONE_WITH_WRAP_AROUND(priv->cmd_enqueue_idx, CMD_Q_SIZE);
+	priv->free_cmd_queue--;
 
-	if (priv->bCmdRunning == false)
+	if (priv->cmd_running == false)
 		s_bCommandComplete(priv);
 
 	return true;
@@ -206,9 +206,9 @@ int bScheduleCommand(struct vnt_private *priv, enum vnt_cmd command, u8 *item0)
 
 void vResetCommandTimer(struct vnt_private *priv)
 {
-	priv->cbFreeCmdQueue = CMD_Q_SIZE;
-	priv->uCmdDequeueIdx = 0;
-	priv->uCmdEnqueueIdx = 0;
+	priv->free_cmd_queue = CMD_Q_SIZE;
+	priv->cmd_dequeue_idx = 0;
+	priv->cmd_enqueue_idx = 0;
 	priv->command_state = WLAN_CMD_IDLE;
-	priv->bCmdRunning = false;
+	priv->cmd_running = false;
 }
-- 
1.9.1

