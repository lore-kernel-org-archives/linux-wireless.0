Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:33737 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbaGMJnd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 05:43:33 -0400
Received: by mail-wg0-f49.google.com with SMTP id k14so2175313wgh.20
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 02:43:32 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/13] staging: vt6656: remove typedef struct tagCMD_ITEM
Date: Sun, 13 Jul 2014 10:42:43 +0100
Message-Id: <1405244573-10978-3-git-send-email-tvboxspy@gmail.com> (sfid-20140713_114338_185861_D4BA5E2E)
In-Reply-To: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
References: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since enum vnt_cmd is only member replace with array
enum vnt_cmd cmd_queue with size of CMD_Q_SIZE

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 2 +-
 drivers/staging/vt6656/wcmd.c   | 4 ++--
 drivers/staging/vt6656/wcmd.h   | 4 ----
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 0c9166e..a6eeebc 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -406,7 +406,7 @@ struct vnt_private {
 
 	/* 802.11 counter */
 
-	CMD_ITEM eCmdQueue[CMD_Q_SIZE];
+	enum vnt_cmd cmd_queue[CMD_Q_SIZE];
 	u32 uCmdDequeueIdx;
 	u32 uCmdEnqueueIdx;
 	u32 cbFreeCmdQueue;
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index e0ad20a..c2da8cc 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -146,7 +146,7 @@ static int s_bCommandComplete(struct vnt_private *priv)
 		return true;
 	}
 
-	priv->command = priv->eCmdQueue[priv->uCmdDequeueIdx].cmd;
+	priv->command = priv->cmd_queue[priv->uCmdDequeueIdx];
 
 	ADD_ONE_WITH_WRAP_AROUND(priv->uCmdDequeueIdx, CMD_Q_SIZE);
 	priv->cbFreeCmdQueue++;
@@ -192,7 +192,7 @@ int bScheduleCommand(struct vnt_private *priv, enum vnt_cmd command, u8 *item0)
 	if (priv->cbFreeCmdQueue == 0)
 		return false;
 
-	priv->eCmdQueue[priv->uCmdEnqueueIdx].cmd = command;
+	priv->cmd_queue[priv->uCmdEnqueueIdx] = command;
 
 	ADD_ONE_WITH_WRAP_AROUND(priv->uCmdEnqueueIdx, CMD_Q_SIZE);
 	priv->cbFreeCmdQueue--;
diff --git a/drivers/staging/vt6656/wcmd.h b/drivers/staging/vt6656/wcmd.h
index 283df61..f42270b 100644
--- a/drivers/staging/vt6656/wcmd.h
+++ b/drivers/staging/vt6656/wcmd.h
@@ -56,10 +56,6 @@ typedef enum tagCMD_STATUS {
 
 } CMD_STATUS, *PCMD_STATUS;
 
-typedef struct tagCMD_ITEM {
-	enum vnt_cmd cmd;
-} CMD_ITEM, *PCMD_ITEM;
-
 /* Command state */
 enum vnt_cmd_state {
 	WLAN_CMD_INIT_MAC80211_START,
-- 
1.9.1

