Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:45779 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbaJYUFa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 16:05:30 -0400
Received: by mail-wg0-f48.google.com with SMTP id m15so1244927wgh.19
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 13:05:29 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/48] staging: vt6655: remove dead functions in power.c/h
Date: Sat, 25 Oct 2014 09:39:48 +0100
Message-Id: <1414226426-5811-11-git-send-email-tvboxspy@gmail.com> (sfid-20141025_220535_841454_16FA559F)
In-Reply-To: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
References: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/power.c | 171 -----------------------------------------
 drivers/staging/vt6655/power.h |  16 ----
 drivers/staging/vt6655/wcmd.c  |   2 -
 drivers/staging/vt6655/wmgr.c  |   6 --
 4 files changed, 195 deletions(-)

diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index 5371802..040484e 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -43,7 +43,6 @@
 #include "wmgr.h"
 #include "power.h"
 #include "wcmd.h"
-#include "rxtx.h"
 #include "card.h"
 
 /*---------------------  Static Definitions -------------------------*/
@@ -140,176 +139,6 @@ PSvDisablePowerSaving(
 	pDevice->bPWBitOn = false;
 }
 
-/*+
- *
- * Routine Description:
- * Consider to power down when no more packets to tx or rx.
- *
- * Return Value:
- *    true, if power down success
- *    false, if fail
- -*/
-
-bool
-PSbConsiderPowerDown(
-	void *hDeviceContext,
-	bool bCheckRxDMA,
-	bool bCheckCountToWakeUp
-)
-{
-	struct vnt_private *pDevice = hDeviceContext;
-	PSMgmtObject    pMgmt = pDevice->pMgmt;
-	unsigned int uIdx;
-
-	// check if already in Doze mode
-	if (MACbIsRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_PS))
-		return true;
-
-	if (pMgmt->eCurrMode != WMAC_MODE_IBSS_STA) {
-		// check if in TIM wake period
-		if (pMgmt->bInTIMWake)
-			return false;
-	}
-
-	// check scan state
-	if (pDevice->bCmdRunning)
-		return false;
-
-	// Force PSEN on
-	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_PSEN);
-
-	// check if all TD are empty,
-	for (uIdx = 0; uIdx < TYPE_MAXTD; uIdx++) {
-		if (pDevice->iTDUsed[uIdx] != 0)
-			return false;
-	}
-
-	// check if rx isr is clear
-	if (bCheckRxDMA &&
-	    ((pDevice->dwIsr & ISR_RXDMA0) != 0) &&
-	    ((pDevice->dwIsr & ISR_RXDMA1) != 0)) {
-		return false;
-	}
-
-	if (pMgmt->eCurrMode != WMAC_MODE_IBSS_STA) {
-		if (bCheckCountToWakeUp &&
-		    (pMgmt->wCountToWakeUp == 0 || pMgmt->wCountToWakeUp == 1)) {
-			return false;
-		}
-	}
-
-	// no Tx, no Rx isr, now go to Doze
-	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_GO2DOZE);
-	pr_debug("Go to Doze ZZZZZZZZZZZZZZZ\n");
-	return true;
-}
-
-/*+
- *
- * Routine Description:
- * Send PS-POLL packet
- *
- * Return Value:
- *    None.
- *
- -*/
-
-void
-PSvSendPSPOLL(
-	void *hDeviceContext
-)
-{
-	struct vnt_private *pDevice = hDeviceContext;
-	PSMgmtObject        pMgmt = pDevice->pMgmt;
-	PSTxMgmtPacket      pTxPacket = NULL;
-
-	memset(pMgmt->pbyPSPacketPool, 0, sizeof(STxMgmtPacket) + WLAN_HDR_ADDR2_LEN);
-	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyPSPacketPool;
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
-	pTxPacket->p80211Header->sA2.wFrameCtl = cpu_to_le16(
-		(
-			WLAN_SET_FC_FTYPE(WLAN_TYPE_CTL) |
-			WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_PSPOLL) |
-			WLAN_SET_FC_PWRMGT(0)
-));
-	pTxPacket->p80211Header->sA2.wDurationID = pMgmt->wCurrAID | BIT14 | BIT15;
-	memcpy(pTxPacket->p80211Header->sA2.abyAddr1, pMgmt->abyCurrBSSID, WLAN_ADDR_LEN);
-	memcpy(pTxPacket->p80211Header->sA2.abyAddr2, pMgmt->abyMACAddr, WLAN_ADDR_LEN);
-	pTxPacket->cbMPDULen = WLAN_HDR_ADDR2_LEN;
-	pTxPacket->cbPayloadLen = 0;
-	// send the frame
-	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING)
-		pr_debug("Send PS-Poll packet failed..\n");
-}
-
-/*+
- *
- * Routine Description:
- * Send NULL packet to AP for notification power state of STA
- *
- * Return Value:
- *    None.
- *
- -*/
-bool
-PSbSendNullPacket(
-	void *hDeviceContext
-)
-{
-	struct vnt_private *pDevice = hDeviceContext;
-	PSTxMgmtPacket      pTxPacket = NULL;
-	PSMgmtObject        pMgmt = pDevice->pMgmt;
-	unsigned int uIdx;
-
-	if (!pDevice->bLinkPass)
-		return false;
-
-	if (!pDevice->bEnablePSMode && !pDevice->fTxDataInSleep)
-		return false;
-
-	if (pDevice->bEnablePSMode) {
-		for (uIdx = 0; uIdx < TYPE_MAXTD; uIdx++) {
-			if (pDevice->iTDUsed[uIdx] != 0)
-				return false;
-		}
-	}
-
-	memset(pMgmt->pbyPSPacketPool, 0, sizeof(STxMgmtPacket) + WLAN_NULLDATA_FR_MAXLEN);
-	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyPSPacketPool;
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
-
-	if (pDevice->bEnablePSMode) {
-		pTxPacket->p80211Header->sA3.wFrameCtl = cpu_to_le16(
-			(
-				WLAN_SET_FC_FTYPE(WLAN_TYPE_DATA) |
-				WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_NULL) |
-				WLAN_SET_FC_PWRMGT(1)
-));
-	} else {
-		pTxPacket->p80211Header->sA3.wFrameCtl = cpu_to_le16(
-			(
-				WLAN_SET_FC_FTYPE(WLAN_TYPE_DATA) |
-				WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_NULL) |
-				WLAN_SET_FC_PWRMGT(0)
-));
-	}
-
-	if (pMgmt->eCurrMode != WMAC_MODE_IBSS_STA)
-		pTxPacket->p80211Header->sA3.wFrameCtl |= cpu_to_le16((unsigned short)WLAN_SET_FC_TODS(1));
-
-	memcpy(pTxPacket->p80211Header->sA3.abyAddr1, pMgmt->abyCurrBSSID, WLAN_ADDR_LEN);
-	memcpy(pTxPacket->p80211Header->sA3.abyAddr2, pMgmt->abyMACAddr, WLAN_ADDR_LEN);
-	memcpy(pTxPacket->p80211Header->sA3.abyAddr3, pMgmt->abyCurrBSSID, WLAN_BSSID_LEN);
-	pTxPacket->cbMPDULen = WLAN_HDR_ADDR3_LEN;
-	pTxPacket->cbPayloadLen = 0;
-	// send the frame
-	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING) {
-		pr_debug("Send Null Packet failed !\n");
-		return false;
-	}
-
-	return true;
-}
 
 /*+
  *
diff --git a/drivers/staging/vt6655/power.h b/drivers/staging/vt6655/power.h
index 936f171..1083341 100644
--- a/drivers/staging/vt6655/power.h
+++ b/drivers/staging/vt6655/power.h
@@ -33,13 +33,6 @@
 #define     PS_FAST_INTERVAL         1         // Fast power saving listen interval
 #define     PS_MAX_INTERVAL          4         // MAX power saving listen interval
 
-bool
-PSbConsiderPowerDown(
-	void *hDeviceContext,
-	bool bCheckRxDMA,
-	bool bCheckCountToWakeUp
-);
-
 void
 PSvDisablePowerSaving(
 	void *hDeviceContext
@@ -51,15 +44,6 @@ PSvEnablePowerSaving(
 	unsigned short wListenInterval
 );
 
-void
-PSvSendPSPOLL(
-	void *hDeviceContext
-);
-
-bool
-PSbSendNullPacket(
-	void *hDeviceContext
-);
 
 bool
 PSbIsNextTBTTWakeUp(
diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index 53f81f1..33ee84f 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -646,7 +646,6 @@ vCommandTimer(
 			bClearBSSID_SCAN(pDevice);
 			if (pDevice->byFOETuning) {
 				BBvSetFOE(pDevice->PortOffset);
-				PSbSendNullPacket(pDevice);
 			}
 			if (netif_queue_stopped(pDevice->dev))
 				netif_wake_queue(pDevice->dev);
@@ -1009,7 +1008,6 @@ BSSvSecondTxData(
 	if ((pDevice->bLinkPass && (pMgmt->eAuthenMode < WMAC_AUTH_WPA)) ||
 	    pDevice->fWPA_Authened) {   /* wpa linking */
 		pDevice->fTxDataInSleep = true;
-		PSbSendNullPacket(pDevice);	/* send null packet */
 		pDevice->fTxDataInSleep = false;
 	}
 
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index a1bada1..72906b0 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -2025,19 +2025,13 @@ s_vMgrRxBeacon(
 				pMgmt->bInTIMWake = true;
 				// send out ps-poll packet
 
-				if (pMgmt->bInTIM)
-					PSvSendPSPOLL(pDevice);
 
 			} else {
 				pMgmt->bInTIMWake = false;
 				pr_debug("BCN: Not In TIM..\n");
 				if (!pDevice->bPWBitOn) {
 					pr_debug("BCN: Send Null Packet\n");
-					if (PSbSendNullPacket(pDevice))
-						pDevice->bPWBitOn = true;
 				}
-				if (PSbConsiderPowerDown(pDevice, false, false))
-					pr_debug("BCN: Power down now...\n");
 			}
 
 		}
-- 
1.9.1

