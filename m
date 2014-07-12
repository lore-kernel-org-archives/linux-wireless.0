Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:47829 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaGLGyc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 02:54:32 -0400
Received: by mail-we0-f177.google.com with SMTP id u56so1961051wes.8
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2014 23:54:31 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/10] staging: vt6656: wcmd Remove command WLAN_CMD_RADIO
Date: Sat, 12 Jul 2014 07:53:40 +0100
Message-Id: <1405148028-4053-2-git-send-email-tvboxspy@gmail.com> (sfid-20140712_085435_815864_E6C516D9)
In-Reply-To: <1405148028-4053-1-git-send-email-tvboxspy@gmail.com>
References: <1405148028-4053-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Part of it has already been removed.  checking isr1 & ISR_GPIO3
serves no purpose.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/int.c  |  6 ------
 drivers/staging/vt6656/wcmd.c | 14 --------------
 drivers/staging/vt6656/wcmd.h |  2 --
 3 files changed, 22 deletions(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 1cc9364..77bd9dd 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -197,12 +197,6 @@ void INTnsProcessData(struct vnt_private *priv)
 		low_stats->dot11FCSErrorCount += int_data->fcs_err;
 	}
 
-	if (int_data->isr1 != 0)
-		if (int_data->isr1 & ISR_GPIO3)
-			bScheduleCommand((void *) priv,
-					WLAN_CMD_RADIO,
-					NULL);
-
 	priv->int_buf.in_use = false;
 
 	stats->tx_errors = priv->wstats.discard.retries;
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 2553cde..0b87486 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -185,10 +185,6 @@ static int s_bCommandComplete(struct vnt_private *pDevice)
 			pDevice->eCommandState = WLAN_CMD_INIT_MAC80211_START;
 			break;
 
-		case WLAN_CMD_RADIO:
-			pDevice->eCommandState = WLAN_CMD_RADIO_START;
-			pDevice->bRadioCmd = bRadioCmd;
-			break;
 		case WLAN_CMD_CHANGE_BBSENSITIVITY:
 			pDevice->eCommandState = WLAN_CMD_CHANGE_BBSENSITIVITY_START;
 			break;
@@ -234,16 +230,6 @@ int bScheduleCommand(struct vnt_private *pDevice,
 		return false;
 	pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].eCmd = eCommand;
 	pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].bForceSCAN = true;
-	if (pbyItem0 != NULL) {
-		switch (eCommand) {
-		case WLAN_CMD_RADIO:
-			pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].bRadioCmd = *((int *)pbyItem0);
-			break;
-
-		default:
-			break;
-		}
-	}
 
 	ADD_ONE_WITH_WRAP_AROUND(pDevice->uCmdEnqueueIdx, CMD_Q_SIZE);
 	pDevice->cbFreeCmdQueue--;
diff --git a/drivers/staging/vt6656/wcmd.h b/drivers/staging/vt6656/wcmd.h
index 1e5b739..eb2e972 100644
--- a/drivers/staging/vt6656/wcmd.h
+++ b/drivers/staging/vt6656/wcmd.h
@@ -42,7 +42,6 @@ typedef enum tagCMD_CODE {
     WLAN_CMD_DISASSOCIATE,
     WLAN_CMD_DEAUTH,
     WLAN_CMD_RX_PSPOLL,
-    WLAN_CMD_RADIO,
     WLAN_CMD_CHANGE_BBSENSITIVITY,
     WLAN_CMD_SETPOWER,
     WLAN_CMD_TBTT_WAKEUP,
@@ -87,7 +86,6 @@ typedef enum tagCMD_STATE {
     WLAN_ASSOCIATE_WAIT,
     WLAN_DISASSOCIATE_WAIT,
     WLAN_CMD_TX_PSPACKET_START,
-    WLAN_CMD_RADIO_START,
     WLAN_CMD_CHANGE_BBSENSITIVITY_START,
     WLAN_CMD_SETPOWER_START,
     WLAN_CMD_AP_MODE_START,
-- 
1.9.1

