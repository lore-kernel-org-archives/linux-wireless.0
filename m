Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:60989 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaEQIxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:53:23 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so3171403wib.0
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:53:21 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 22/22] staging: vt6656: Remove always true bUpdateBBVGA
Date: Sat, 17 May 2014 09:50:39 +0100
Message-Id: <1400316639-4430-22-git-send-email-tvboxspy@gmail.com> (sfid-20140517_112147_637682_A60547BF)
In-Reply-To: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
References: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove true if statements.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c    | 29 ++++++++++++-----------------
 drivers/staging/vt6656/device.h   |  1 -
 drivers/staging/vt6656/main_usb.c |  9 +++------
 drivers/staging/vt6656/wcmd.c     | 17 +++++++----------
 drivers/staging/vt6656/wmgr.c     |  3 +--
 5 files changed, 23 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 7e8e67a..de60c99 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -455,16 +455,14 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 		}
 	}
 
-	if (pDevice->bUpdateBBVGA) {
-		/* Monitor if RSSI is too strong. */
-		pBSSList->byRSSIStatCnt = 0;
-		RFvRSSITodBm(pDevice, (u8) (pRxPacket->uRSSI),
+	/* Monitor if RSSI is too strong. */
+	pBSSList->byRSSIStatCnt = 0;
+	RFvRSSITodBm(pDevice, (u8) (pRxPacket->uRSSI),
 			     &pBSSList->ldBmMAX);
-		pBSSList->ldBmAverage[0] = pBSSList->ldBmMAX;
-		pBSSList->ldBmAverRange = pBSSList->ldBmMAX;
-		for (ii = 1; ii < RSSI_STAT_COUNT; ii++)
-			pBSSList->ldBmAverage[ii] = 0;
-	}
+	pBSSList->ldBmAverage[0] = pBSSList->ldBmMAX;
+	pBSSList->ldBmAverRange = pBSSList->ldBmMAX;
+	for (ii = 1; ii < RSSI_STAT_COUNT; ii++)
+		pBSSList->ldBmAverage[ii] = 0;
 
 	pBSSList->uIELength = uIELength;
 	if (pBSSList->uIELength > WLAN_BEACON_FR_MAXLEN)
@@ -998,10 +996,8 @@ void BSSvSecondCallBack(struct work_struct *work)
 
 		if (pMgmt->sNodeDBTable[0].bActive) { /* Assoc with BSS */
 
-			if (pDevice->bUpdateBBVGA) {
-				s_vCheckSensitivity(pDevice);
-				s_vCheckPreEDThreshold(pDevice);
-			}
+			s_vCheckSensitivity(pDevice);
+			s_vCheckPreEDThreshold(pDevice);
 
 			if (pMgmt->sNodeDBTable[0].uInActiveCount >=
 							(LOST_BEACON_COUNT/2) &&
@@ -1118,10 +1114,9 @@ void BSSvSecondCallBack(struct work_struct *work)
 		}
 		if (pMgmt->eCurrState == WMAC_STATE_JOINTED) {
 
-			if (pDevice->bUpdateBBVGA) {
-				s_vCheckSensitivity(pDevice);
-				s_vCheckPreEDThreshold(pDevice);
-			}
+			s_vCheckSensitivity(pDevice);
+			s_vCheckPreEDThreshold(pDevice);
+
 			if (pMgmt->sNodeDBTable[0].uInActiveCount >=
 						ADHOC_LOST_BEACON_COUNT) {
 				DBG_PRT(MSG_LEVEL_NOTICE,
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index ee3fb0b..606ca9f 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -660,7 +660,6 @@ struct vnt_private {
 	int bRxMICFail;
 
 	/* For Update BaseBand VGA Gain Offset */
-	int bUpdateBBVGA;
 	u32 uBBVGADiffCount;
 	u8 byBBVGANew;
 	u8 byBBVGACurrent;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index a9d9cc8..3a576fa 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -262,7 +262,6 @@ device_set_options(struct vnt_private *pDevice) {
     pDevice->byBBType = BBP_TYPE_DEF;
     pDevice->byPacketType = pDevice->byBBType;
     pDevice->byAutoFBCtrl = AUTO_FB_0;
-    pDevice->bUpdateBBVGA = true;
     pDevice->byPreambleType = 0;
     pDevice->bExistSWNetAddr = false;
     /* pDevice->bDiversityRegCtlON = true; */
@@ -566,12 +565,10 @@ static int device_init_registers(struct vnt_private *pDevice)
 	BBvSetShortSlotTime(pDevice);
 	CARDvSetBSSMode(pDevice);
 
-	if (pDevice->bUpdateBBVGA) {
-		pDevice->byBBVGACurrent = pDevice->abyBBVGA[0];
-		pDevice->byBBVGANew = pDevice->byBBVGACurrent;
+	pDevice->byBBVGACurrent = pDevice->abyBBVGA[0];
+	pDevice->byBBVGANew = pDevice->byBBVGACurrent;
 
-		BBvSetVGAGainOffset(pDevice, pDevice->abyBBVGA[0]);
-	}
+	BBvSetVGAGainOffset(pDevice, pDevice->abyBBVGA[0]);
 
 	pDevice->byRadioCtl = pDevice->abyEEPROM[EEP_OFS_RADIOCTL];
 	pDevice->bHWRadioOff = false;
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 8fecb34..b742460 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -344,11 +344,10 @@ void vRunCommand(struct work_struct *work)
 			CARDbSetMediaChannel(pDevice, pMgmt->uScanChannel);
 			// Set Baseband to be more sensitive.
 
-			if (pDevice->bUpdateBBVGA) {
-				BBvSetShortSlotTime(pDevice);
-				BBvSetVGAGainOffset(pDevice, pDevice->abyBBVGA[0]);
-				BBvUpdatePreEDThreshold(pDevice, true);
-			}
+			BBvSetShortSlotTime(pDevice);
+			BBvSetVGAGainOffset(pDevice, pDevice->abyBBVGA[0]);
+			BBvUpdatePreEDThreshold(pDevice, true);
+
 			pMgmt->uScanChannel++;
 
 			while (!ChannelValid(pDevice->byZoneType, pMgmt->uScanChannel) &&
@@ -381,11 +380,9 @@ void vRunCommand(struct work_struct *work)
 			CARDvSetBSSMode(pDevice);
 		}
 
-		if (pDevice->bUpdateBBVGA) {
-			BBvSetShortSlotTime(pDevice);
-			BBvSetVGAGainOffset(pDevice, pDevice->byBBVGACurrent);
-			BBvUpdatePreEDThreshold(pDevice, false);
-		}
+		BBvSetShortSlotTime(pDevice);
+		BBvSetVGAGainOffset(pDevice, pDevice->byBBVGACurrent);
+		BBvUpdatePreEDThreshold(pDevice, false);
 
 		// Set channel back
 		vAdHocBeaconRestart(pDevice);
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index d08f290..e6eec7f 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -2653,8 +2653,7 @@ static void s_vMgrSynchBSS(struct vnt_private *pDevice, u32 uBSSMode,
     pMgmt->uCurrChannel = pCurr->uChannel;
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "<----s_bSynchBSS Set Channel [%d]\n", pCurr->uChannel);
 
-    if ((pDevice->bUpdateBBVGA) &&
-        (pDevice->byBBVGACurrent != pDevice->abyBBVGA[0])) {
+    if (pDevice->byBBVGACurrent != pDevice->abyBBVGA[0]) {
         pDevice->byBBVGACurrent = pDevice->abyBBVGA[0];
         BBvSetVGAGainOffset(pDevice, pDevice->byBBVGACurrent);
         BBvSetShortSlotTime(pDevice);
-- 
1.9.1

