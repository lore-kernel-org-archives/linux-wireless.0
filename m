Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:61830 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaGLGyi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 02:54:38 -0400
Received: by mail-we0-f178.google.com with SMTP id w61so1078701wes.37
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2014 23:54:37 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/10] staging: vt6656: s_bCommandComplete remove else from if
Date: Sat, 12 Jul 2014 07:53:44 +0100
Message-Id: <1405148028-4053-6-git-send-email-tvboxspy@gmail.com> (sfid-20140712_085442_955980_AF8456E5)
In-Reply-To: <1405148028-4053-1-git-send-email-tvboxspy@gmail.com>
References: <1405148028-4053-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

if returns out so remove else

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c | 60 ++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 1987d5c..cc9d50a 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -147,43 +147,45 @@ static int s_bCommandComplete(struct vnt_private *pDevice)
 		//Command Queue Empty
 		pDevice->bCmdRunning = false;
 		return true;
-	} else {
-		pDevice->eCommand = pDevice->eCmdQueue[pDevice->uCmdDequeueIdx].eCmd;
-
-		ADD_ONE_WITH_WRAP_AROUND(pDevice->uCmdDequeueIdx, CMD_Q_SIZE);
-		pDevice->cbFreeCmdQueue++;
-		pDevice->bCmdRunning = true;
-		switch (pDevice->eCommand) {
-		case WLAN_CMD_INIT_MAC80211:
-			pDevice->eCommandState = WLAN_CMD_INIT_MAC80211_START;
-			break;
+	}
 
-		case WLAN_CMD_TBTT_WAKEUP:
-			pDevice->eCommandState = WLAN_CMD_TBTT_WAKEUP_START;
-			break;
+	pDevice->eCommand = pDevice->eCmdQueue[pDevice->uCmdDequeueIdx].eCmd;
 
-		case WLAN_CMD_BECON_SEND:
-			pDevice->eCommandState = WLAN_CMD_BECON_SEND_START;
-			break;
+	ADD_ONE_WITH_WRAP_AROUND(pDevice->uCmdDequeueIdx, CMD_Q_SIZE);
+	pDevice->cbFreeCmdQueue++;
+	pDevice->bCmdRunning = true;
 
-		case WLAN_CMD_SETPOWER:
-			pDevice->eCommandState = WLAN_CMD_SETPOWER_START;
-			break;
+	switch (pDevice->eCommand) {
+	case WLAN_CMD_INIT_MAC80211:
+		pDevice->eCommandState = WLAN_CMD_INIT_MAC80211_START;
+		break;
 
-		case WLAN_CMD_CHANGE_ANTENNA:
-			pDevice->eCommandState = WLAN_CMD_CHANGE_ANTENNA_START;
-			break;
+	case WLAN_CMD_TBTT_WAKEUP:
+		pDevice->eCommandState = WLAN_CMD_TBTT_WAKEUP_START;
+		break;
 
-		case WLAN_CMD_11H_CHSW:
-			pDevice->eCommandState = WLAN_CMD_11H_CHSW_START;
-			break;
+	case WLAN_CMD_BECON_SEND:
+		pDevice->eCommandState = WLAN_CMD_BECON_SEND_START;
+		break;
 
-		default:
-			break;
-		}
-		vCommandTimerWait(pDevice, 0);
+	case WLAN_CMD_SETPOWER:
+		pDevice->eCommandState = WLAN_CMD_SETPOWER_START;
+		break;
+
+	case WLAN_CMD_CHANGE_ANTENNA:
+		pDevice->eCommandState = WLAN_CMD_CHANGE_ANTENNA_START;
+		break;
+
+	case WLAN_CMD_11H_CHSW:
+		pDevice->eCommandState = WLAN_CMD_11H_CHSW_START;
+		break;
+
+	default:
+		break;
 	}
 
+	vCommandTimerWait(pDevice, 0);
+
 	return true;
 }
 
-- 
1.9.1

