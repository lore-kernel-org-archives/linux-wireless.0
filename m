Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:63404 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaGLGyk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 02:54:40 -0400
Received: by mail-we0-f169.google.com with SMTP id t60so1988335wes.28
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2014 23:54:39 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/10] staging: vt6656: s_bCommandComplete clean up and remove camel case
Date: Sat, 12 Jul 2014 07:53:45 +0100
Message-Id: <1405148028-4053-7-git-send-email-tvboxspy@gmail.com> (sfid-20140712_085445_299257_755BD106)
In-Reply-To: <1405148028-4053-1-git-send-email-tvboxspy@gmail.com>
References: <1405148028-4053-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pDevice -> priv

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index cc9d50a..cdd828c 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -139,52 +139,52 @@ void vRunCommand(struct work_struct *work)
 	return;
 }
 
-static int s_bCommandComplete(struct vnt_private *pDevice)
+static int s_bCommandComplete(struct vnt_private *priv)
 {
 
-	pDevice->eCommandState = WLAN_CMD_IDLE;
-	if (pDevice->cbFreeCmdQueue == CMD_Q_SIZE) {
-		//Command Queue Empty
-		pDevice->bCmdRunning = false;
+	priv->eCommandState = WLAN_CMD_IDLE;
+	if (priv->cbFreeCmdQueue == CMD_Q_SIZE) {
+		/* Command Queue Empty */
+		priv->bCmdRunning = false;
 		return true;
 	}
 
-	pDevice->eCommand = pDevice->eCmdQueue[pDevice->uCmdDequeueIdx].eCmd;
+	priv->eCommand = priv->eCmdQueue[priv->uCmdDequeueIdx].eCmd;
 
-	ADD_ONE_WITH_WRAP_AROUND(pDevice->uCmdDequeueIdx, CMD_Q_SIZE);
-	pDevice->cbFreeCmdQueue++;
-	pDevice->bCmdRunning = true;
+	ADD_ONE_WITH_WRAP_AROUND(priv->uCmdDequeueIdx, CMD_Q_SIZE);
+	priv->cbFreeCmdQueue++;
+	priv->bCmdRunning = true;
 
-	switch (pDevice->eCommand) {
+	switch (priv->eCommand) {
 	case WLAN_CMD_INIT_MAC80211:
-		pDevice->eCommandState = WLAN_CMD_INIT_MAC80211_START;
+		priv->eCommandState = WLAN_CMD_INIT_MAC80211_START;
 		break;
 
 	case WLAN_CMD_TBTT_WAKEUP:
-		pDevice->eCommandState = WLAN_CMD_TBTT_WAKEUP_START;
+		priv->eCommandState = WLAN_CMD_TBTT_WAKEUP_START;
 		break;
 
 	case WLAN_CMD_BECON_SEND:
-		pDevice->eCommandState = WLAN_CMD_BECON_SEND_START;
+		priv->eCommandState = WLAN_CMD_BECON_SEND_START;
 		break;
 
 	case WLAN_CMD_SETPOWER:
-		pDevice->eCommandState = WLAN_CMD_SETPOWER_START;
+		priv->eCommandState = WLAN_CMD_SETPOWER_START;
 		break;
 
 	case WLAN_CMD_CHANGE_ANTENNA:
-		pDevice->eCommandState = WLAN_CMD_CHANGE_ANTENNA_START;
+		priv->eCommandState = WLAN_CMD_CHANGE_ANTENNA_START;
 		break;
 
 	case WLAN_CMD_11H_CHSW:
-		pDevice->eCommandState = WLAN_CMD_11H_CHSW_START;
+		priv->eCommandState = WLAN_CMD_11H_CHSW_START;
 		break;
 
 	default:
 		break;
 	}
 
-	vCommandTimerWait(pDevice, 0);
+	vCommandTimerWait(priv, 0);
 
 	return true;
 }
-- 
1.9.1

