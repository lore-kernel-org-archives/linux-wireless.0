Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:35121 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaEOVvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 17:51:39 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so1742440wes.14
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 14:51:38 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH rebased 04/15] staging: vt6656: lock changes: vRunCommand remove locks.
Date: Thu, 15 May 2014 22:49:13 +0100
Message-Id: <1400190564-5135-4-git-send-email-tvboxspy@gmail.com> (sfid-20140515_235142_538635_3FC0A1B2)
In-Reply-To: <1400190564-5135-1-git-send-email-tvboxspy@gmail.com>
References: <1400190564-5135-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing atomic locked paths to usbpipe.c PIPEnsControlOut and PIPEnsControlIn

This function will nolonger need any locking.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index de7e808..d51cc90 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -286,8 +286,6 @@ void vRunCommand(struct work_struct *work)
 	if (pDevice->bCmdRunning != true)
 		return;
 
-	spin_lock_irq(&pDevice->lock);
-
 	switch (pDevice->eCommandState) {
 
 	case WLAN_CMD_SCAN_START:
@@ -365,11 +363,9 @@ void vRunCommand(struct work_struct *work)
 			if ((pMgmt->b11hEnable == false) ||
 			    (pMgmt->uScanChannel < CB_MAX_CHANNEL_24G)) {
 				s_vProbeChannel(pDevice);
-				spin_unlock_irq(&pDevice->lock);
 				vCommandTimerWait((void *) pDevice, 100);
 				return;
 			} else {
-				spin_unlock_irq(&pDevice->lock);
 				vCommandTimerWait((void *) pDevice, WCMD_PASSIVE_SCAN_TIME);
 				return;
 			}
@@ -504,7 +500,6 @@ void vRunCommand(struct work_struct *work)
 				pDevice->byLinkWaitCount = 0;
 				pDevice->eCommandState = WLAN_AUTHENTICATE_WAIT;
 				vCommandTimerWait((void *) pDevice, AUTHENTICATE_TIMEOUT);
-				spin_unlock_irq(&pDevice->lock);
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" Set eCommandState = WLAN_AUTHENTICATE_WAIT\n");
 				return;
 			}
@@ -578,7 +573,6 @@ void vRunCommand(struct work_struct *work)
 				pDevice->byLinkWaitCount = 0;
 				pDevice->eCommandState = WLAN_ASSOCIATE_WAIT;
 				vCommandTimerWait((void *) pDevice, ASSOCIATE_TIMEOUT);
-				spin_unlock_irq(&pDevice->lock);
 				return;
 			}
 		} else if (pMgmt->eCurrState < WMAC_STATE_AUTHPENDING) {
@@ -587,7 +581,6 @@ void vRunCommand(struct work_struct *work)
 			//mike add:wait another 2 sec if authenticated_frame delay!
 			pDevice->byLinkWaitCount++;
 			printk("WLAN_AUTHENTICATE_WAIT:wait %d times!!\n", pDevice->byLinkWaitCount);
-			spin_unlock_irq(&pDevice->lock);
 			vCommandTimerWait((void *) pDevice, AUTHENTICATE_TIMEOUT/2);
 			return;
 		}
@@ -622,7 +615,6 @@ void vRunCommand(struct work_struct *work)
 			//mike add:wait another 2 sec if associated_frame delay!
 			pDevice->byLinkWaitCount++;
 			printk("WLAN_ASSOCIATE_WAIT:wait %d times!!\n", pDevice->byLinkWaitCount);
-			spin_unlock_irq(&pDevice->lock);
 			vCommandTimerWait((void *) pDevice, ASSOCIATE_TIMEOUT/2);
 			return;
 		}
@@ -752,9 +744,9 @@ void vRunCommand(struct work_struct *work)
 
 				pDevice->byKeyIndex = 0;
 				pDevice->bTransmitKey = false;
-				spin_unlock_irq(&pDevice->lock);
+
 				KeyvInitTable(pDevice, &pDevice->sKey);
-				spin_lock_irq(&pDevice->lock);
+
 				pMgmt->byCSSPK = KEY_CTL_NONE;
 				pMgmt->byCSSGK = KEY_CTL_NONE;
 
@@ -882,7 +874,6 @@ void vRunCommand(struct work_struct *work)
 
 	s_bCommandComplete(pDevice);
 
-	spin_unlock_irq(&pDevice->lock);
 	return;
 }
 
-- 
1.9.1

