Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:36483 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaHJLWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2014 07:22:48 -0400
Received: by mail-we0-f178.google.com with SMTP id w61so7544630wes.9
        for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2014 04:22:46 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/7] staging: vt6655: Replace and remove typedef QWORD/ DQWORD
Date: Sun, 10 Aug 2014 12:21:58 +0100
Message-Id: <1407669722-2682-3-git-send-email-tvboxspy@gmail.com> (sfid-20140810_132252_914690_8F69B7AE)
In-Reply-To: <1407669722-2682-1-git-send-email-tvboxspy@gmail.com>
References: <1407669722-2682-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace the variables with u64/__le64.

The endian variant is needed in some places endian correction is
needed.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/80211mgr.c |   8 +--
 drivers/staging/vt6655/80211mgr.h |   6 +-
 drivers/staging/vt6655/bssdb.c    |  10 ++--
 drivers/staging/vt6655/bssdb.h    |   8 +--
 drivers/staging/vt6655/card.c     | 116 +++++++++++++++-----------------------
 drivers/staging/vt6655/card.h     |  10 ++--
 drivers/staging/vt6655/device.h   |   2 +-
 drivers/staging/vt6655/dpc.c      |   9 ++-
 drivers/staging/vt6655/hostap.c   |  10 ++--
 drivers/staging/vt6655/key.c      |  22 ++++----
 drivers/staging/vt6655/key.h      |   8 +--
 drivers/staging/vt6655/ttype.h    |  23 --------
 drivers/staging/vt6655/wmgr.c     |  40 +++++--------
 drivers/staging/vt6655/wmgr.h     |   2 +-
 drivers/staging/vt6655/wpactl.c   |  12 ++--
 15 files changed, 114 insertions(+), 172 deletions(-)

diff --git a/drivers/staging/vt6655/80211mgr.c b/drivers/staging/vt6655/80211mgr.c
index 96b0d61..2c1fd82 100644
--- a/drivers/staging/vt6655/80211mgr.c
+++ b/drivers/staging/vt6655/80211mgr.c
@@ -91,7 +91,7 @@ vMgrEncodeBeacon(
 	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
 	/* Fixed Fields */
-	pFrame->pqwTimestamp = (PQWORD)
+	pFrame->pqwTimestamp = (__le64 *)
 				(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3)) +
 				 WLAN_BEACON_OFF_TS);
 	pFrame->pwBeaconInterval = (unsigned short *)
@@ -125,7 +125,7 @@ vMgrDecodeBeacon(
 	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
 	/* Fixed Fields */
-	pFrame->pqwTimestamp = (PQWORD)
+	pFrame->pqwTimestamp = (__le64 *)
 				(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3)) +
 				 WLAN_BEACON_OFF_TS);
 	pFrame->pwBeaconInterval = (unsigned short *)
@@ -695,7 +695,7 @@ vMgrEncodeProbeResponse(
 	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
 	/* Fixed Fields */
-	pFrame->pqwTimestamp = (PQWORD)
+	pFrame->pqwTimestamp = (__le64 *)
 			       (WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3)) +
 				WLAN_PROBERESP_OFF_TS);
 	pFrame->pwBeaconInterval = (unsigned short *)
@@ -730,7 +730,7 @@ vMgrDecodeProbeResponse(
 	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
 	/* Fixed Fields */
-	pFrame->pqwTimestamp = (PQWORD)
+	pFrame->pqwTimestamp = (__le64 *)
 			       (WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3)) +
 				WLAN_PROBERESP_OFF_TS);
 	pFrame->pwBeaconInterval = (unsigned short *)
diff --git a/drivers/staging/vt6655/80211mgr.h b/drivers/staging/vt6655/80211mgr.h
index 8b126bb..94fb93d 100644
--- a/drivers/staging/vt6655/80211mgr.h
+++ b/drivers/staging/vt6655/80211mgr.h
@@ -31,6 +31,8 @@
 #ifndef __80211MGR_H__
 #define __80211MGR_H__
 
+#include <linux/types.h>
+
 #include "ttype.h"
 #include "80211hdr.h"
 
@@ -464,7 +466,7 @@ typedef struct tagWLAN_FR_BEACON {
 	unsigned int	len;
 	unsigned char *pBuf;
 	PUWLAN_80211HDR         pHdr;
-	PQWORD                  pqwTimestamp;
+	__le64 *pqwTimestamp;
 	unsigned short *pwBeaconInterval;
 	unsigned short *pwCapInfo;
 	PWLAN_IE_SSID           pSSID;
@@ -577,7 +579,7 @@ typedef struct tagWLAN_FR_PROBERESP {
 	unsigned int	len;
 	unsigned char *pBuf;
 	PUWLAN_80211HDR         pHdr;
-	PQWORD                  pqwTimestamp;
+	__le64 *pqwTimestamp;
 	unsigned short *pwBeaconInterval;
 	unsigned short *pwCapInfo;
 	PWLAN_IE_SSID           pSSID;
diff --git a/drivers/staging/vt6655/bssdb.c b/drivers/staging/vt6655/bssdb.c
index 9569f43..0d6b27e 100644
--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -316,7 +316,7 @@ bool
 BSSbInsertToBSSList(
 	void *hDeviceContext,
 	unsigned char *abyBSSIDAddr,
-	QWORD qwTimestamp,
+	__le64 qwTimestamp,
 	unsigned short wBeaconInterval,
 	unsigned short wCapInfo,
 	unsigned char byCurrChannel,
@@ -356,8 +356,7 @@ BSSbInsertToBSSList(
 	/* save the BSS info */
 	pBSSList->bActive = true;
 	memcpy(pBSSList->abyBSSID, abyBSSIDAddr, WLAN_BSSID_LEN);
-	HIDWORD(pBSSList->qwBSSTimestamp) = cpu_to_le32(HIDWORD(qwTimestamp));
-	LODWORD(pBSSList->qwBSSTimestamp) = cpu_to_le32(LODWORD(qwTimestamp));
+	pBSSList->qwBSSTimestamp = le64_to_cpu(qwTimestamp);
 	pBSSList->wBeaconInterval = cpu_to_le16(wBeaconInterval);
 	pBSSList->wCapInfo = cpu_to_le16(wCapInfo);
 	pBSSList->uClearCount = 0;
@@ -521,7 +520,7 @@ BSSbInsertToBSSList(
 bool
 BSSbUpdateToBSSList(
 	void *hDeviceContext,
-	QWORD qwTimestamp,
+	__le64 qwTimestamp,
 	unsigned short wBeaconInterval,
 	unsigned short wCapInfo,
 	unsigned char byCurrChannel,
@@ -551,8 +550,7 @@ BSSbUpdateToBSSList(
 	if (pBSSList == NULL)
 		return false;
 
-	HIDWORD(pBSSList->qwBSSTimestamp) = cpu_to_le32(HIDWORD(qwTimestamp));
-	LODWORD(pBSSList->qwBSSTimestamp) = cpu_to_le32(LODWORD(qwTimestamp));
+	pBSSList->qwBSSTimestamp = le64_to_cpu(qwTimestamp);
 	pBSSList->wBeaconInterval = cpu_to_le16(wBeaconInterval);
 	pBSSList->wCapInfo = cpu_to_le16(wCapInfo);
 	pBSSList->uClearCount = 0;
diff --git a/drivers/staging/vt6655/bssdb.h b/drivers/staging/vt6655/bssdb.h
index bf299e3..5d4dd28 100644
--- a/drivers/staging/vt6655/bssdb.h
+++ b/drivers/staging/vt6655/bssdb.h
@@ -131,8 +131,8 @@ typedef struct tagKnownBSS {
 
 	unsigned int	uClearCount;
 	unsigned int	uIELength;
-	QWORD           qwBSSTimestamp;
-	QWORD           qwLocalTSF;
+	u64 qwBSSTimestamp;
+	u64 qwLocalTSF;
 
 	CARD_PHY_TYPE   eNetworkTypeInUse;
 
@@ -233,7 +233,7 @@ bool
 BSSbInsertToBSSList(
 	void *hDeviceContext,
 	unsigned char *abyBSSIDAddr,
-	QWORD qwTimestamp,
+	__le64 qwTimestamp,
 	unsigned short wBeaconInterval,
 	unsigned short wCapInfo,
 	unsigned char byCurrChannel,
@@ -253,7 +253,7 @@ BSSbInsertToBSSList(
 bool
 BSSbUpdateToBSSList(
 	void *hDeviceContext,
-	QWORD qwTimestamp,
+	__le64 qwTimestamp,
 	unsigned short wBeaconInterval,
 	unsigned short wCapInfo,
 	unsigned char byCurrChannel,
diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 4ae8d93..5295463 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -573,21 +573,17 @@ bool CARDbSetPhyParameter(void *pDeviceHandler, CARD_PHY_TYPE ePHYType, unsigned
  * Return Value: none
  *
  */
-bool CARDbUpdateTSF(void *pDeviceHandler, unsigned char byRxRate, QWORD qwBSSTimestamp, QWORD qwLocalTSF)
+bool CARDbUpdateTSF(void *pDeviceHandler, unsigned char byRxRate, u64 qwBSSTimestamp, u64 qwLocalTSF)
 {
 	PSDevice    pDevice = (PSDevice) pDeviceHandler;
-	QWORD       qwTSFOffset;
+	u64 qwTSFOffset = 0;
 
-	HIDWORD(qwTSFOffset) = 0;
-	LODWORD(qwTSFOffset) = 0;
-
-	if ((HIDWORD(qwBSSTimestamp) != HIDWORD(qwLocalTSF)) ||
-	    (LODWORD(qwBSSTimestamp) != LODWORD(qwLocalTSF))) {
+	if (qwBSSTimestamp != qwLocalTSF) {
 		qwTSFOffset = CARDqGetTSFOffset(byRxRate, qwBSSTimestamp, qwLocalTSF);
 		// adjust TSF
 		// HW's TSF add TSF Offset reg
-		VNSvOutPortD(pDevice->PortOffset + MAC_REG_TSFOFST, LODWORD(qwTSFOffset));
-		VNSvOutPortD(pDevice->PortOffset + MAC_REG_TSFOFST + 4, HIDWORD(qwTSFOffset));
+		VNSvOutPortD(pDevice->PortOffset + MAC_REG_TSFOFST, (u32)qwTSFOffset);
+		VNSvOutPortD(pDevice->PortOffset + MAC_REG_TSFOFST + 4, (u32)(qwTSFOffset >> 32));
 		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_TFTCTL, TFTCTL_TSFSYNCEN);
 	}
 	return true;
@@ -614,33 +610,32 @@ bool CARDbSetBeaconPeriod(void *pDeviceHandler, unsigned short wBeaconInterval)
 	unsigned int uLowNextTBTT = 0;
 	unsigned int uHighRemain = 0;
 	unsigned int uLowRemain = 0;
-	QWORD       qwNextTBTT;
+	u64 qwNextTBTT = 0;
 
-	HIDWORD(qwNextTBTT) = 0;
-	LODWORD(qwNextTBTT) = 0;
 	CARDbGetCurrentTSF(pDevice->PortOffset, &qwNextTBTT); //Get Local TSF counter
 	uBeaconInterval = wBeaconInterval * 1024;
 	// Next TBTT = ((local_current_TSF / beacon_interval) + 1) * beacon_interval
-	uLowNextTBTT = (LODWORD(qwNextTBTT) >> 10) << 10;
+	uLowNextTBTT = ((qwNextTBTT & 0xffffffffULL) >> 10) << 10;
 	uLowRemain = (uLowNextTBTT) % uBeaconInterval;
 	// high dword (mod) bcn
-	uHighRemain = (((0xffffffff % uBeaconInterval) + 1) * HIDWORD(qwNextTBTT))
+	uHighRemain = (((0xffffffff % uBeaconInterval) + 1) * (u32)(qwNextTBTT >> 32))
 		% uBeaconInterval;
 	uLowRemain = (uHighRemain + uLowRemain) % uBeaconInterval;
 	uLowRemain = uBeaconInterval - uLowRemain;
 
 	// check if carry when add one beacon interval
 	if ((~uLowNextTBTT) < uLowRemain)
-		HIDWORD(qwNextTBTT)++;
+		qwNextTBTT = ((qwNextTBTT >> 32) + 1) << 32;
 
-	LODWORD(qwNextTBTT) = uLowNextTBTT + uLowRemain;
+	qwNextTBTT = (qwNextTBTT & 0xffffffff00000000ULL) |
+			(u64)(uLowNextTBTT + uLowRemain);
 
 	// set HW beacon interval
 	VNSvOutPortW(pDevice->PortOffset + MAC_REG_BI, wBeaconInterval);
 	pDevice->wBeaconInterval = wBeaconInterval;
 	// Set NextTBTT
-	VNSvOutPortD(pDevice->PortOffset + MAC_REG_NEXTTBTT, LODWORD(qwNextTBTT));
-	VNSvOutPortD(pDevice->PortOffset + MAC_REG_NEXTTBTT + 4, HIDWORD(qwNextTBTT));
+	VNSvOutPortD(pDevice->PortOffset + MAC_REG_NEXTTBTT, (u32)qwNextTBTT);
+	VNSvOutPortD(pDevice->PortOffset + MAC_REG_NEXTTBTT + 4, (u32)(qwNextTBTT >> 32));
 	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_TFTCTL, TFTCTL_TBTTSYNCEN);
 
 	return true;
@@ -1077,8 +1072,8 @@ CARDbStartMeasure(
 {
 	PSDevice                pDevice = (PSDevice) pDeviceHandler;
 	PWLAN_IE_MEASURE_REQ    pEID = (PWLAN_IE_MEASURE_REQ) pvMeasureEIDs;
-	QWORD                   qwCurrTSF;
-	QWORD                   qwStartTSF;
+	u64 qwCurrTSF;
+	u64 qwStartTSF;
 	bool bExpired = true;
 	unsigned short wDuration = 0;
 
@@ -1109,32 +1104,22 @@ CARDbStartMeasure(
 		pDevice->uNumOfMeasureEIDs--;
 
 		if (pDevice->byLocalID > REV_ID_VT3253_B1) {
-			HIDWORD(qwStartTSF) = HIDWORD(*((PQWORD)(pDevice->pCurrMeasureEID->sReq.abyStartTime)));
-			LODWORD(qwStartTSF) = LODWORD(*((PQWORD)(pDevice->pCurrMeasureEID->sReq.abyStartTime)));
+			qwStartTSF = *((u64 *)(pDevice->pCurrMeasureEID->sReq.abyStartTime));
 			wDuration = *((unsigned short *)(pDevice->pCurrMeasureEID->sReq.abyDuration));
 			wDuration += 1; // 1 TU for channel switching
 
-			if ((LODWORD(qwStartTSF) == 0) && (HIDWORD(qwStartTSF) == 0)) {
+			if (qwStartTSF == 0) {
 				// start immediately by setting start TSF == current TSF + 2 TU
-				LODWORD(qwStartTSF) = LODWORD(qwCurrTSF) + 2048;
-				HIDWORD(qwStartTSF) = HIDWORD(qwCurrTSF);
-				if (LODWORD(qwCurrTSF) > LODWORD(qwStartTSF))
-					HIDWORD(qwStartTSF)++;
+				qwStartTSF = qwCurrTSF + 2048;
 
 				bExpired = false;
 				break;
 			} else {
 				// start at setting start TSF - 1TU(for channel switching)
-				if (LODWORD(qwStartTSF) < 1024)
-					HIDWORD(qwStartTSF)--;
-
-				LODWORD(qwStartTSF) -= 1024;
+				qwStartTSF -= 1024;
 			}
 
-			if ((HIDWORD(qwCurrTSF) < HIDWORD(qwStartTSF)) ||
-			    ((HIDWORD(qwCurrTSF) == HIDWORD(qwStartTSF)) &&
-			     (LODWORD(qwCurrTSF) < LODWORD(qwStartTSF)))
-) {
+			if (qwCurrTSF < qwStartTSF) {
 				bExpired = false;
 				break;
 			}
@@ -1161,8 +1146,8 @@ CARDbStartMeasure(
 
 	if (!bExpired) {
 		MACvSelectPage1(pDevice->PortOffset);
-		VNSvOutPortD(pDevice->PortOffset + MAC_REG_MSRSTART, LODWORD(qwStartTSF));
-		VNSvOutPortD(pDevice->PortOffset + MAC_REG_MSRSTART + 4, HIDWORD(qwStartTSF));
+		VNSvOutPortD(pDevice->PortOffset + MAC_REG_MSRSTART, (u32)qwStartTSF);
+		VNSvOutPortD(pDevice->PortOffset + MAC_REG_MSRSTART + 4, (u32)(qwStartTSF >> 32));
 		VNSvOutPortW(pDevice->PortOffset + MAC_REG_MSRDURATION, wDuration);
 		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_MSRCTL, MSRCTL_EN);
 		MACvSelectPage0(pDevice->PortOffset);
@@ -1948,25 +1933,17 @@ bool CARDbSoftwareReset(void *pDeviceHandler)
  * Return Value: TSF Offset value
  *
  */
-QWORD CARDqGetTSFOffset(unsigned char byRxRate, QWORD qwTSF1, QWORD qwTSF2)
+u64 CARDqGetTSFOffset(unsigned char byRxRate, u64 qwTSF1, u64 qwTSF2)
 {
-	QWORD   qwTSFOffset;
+	u64 qwTSFOffset = 0;
 	unsigned short wRxBcnTSFOffst = 0;
 
-	HIDWORD(qwTSFOffset) = 0;
-	LODWORD(qwTSFOffset) = 0;
 	wRxBcnTSFOffst = cwRXBCNTSFOff[byRxRate%MAX_RATE];
-	(qwTSF2).u.dwLowDword += (unsigned long)(wRxBcnTSFOffst);
-	if ((qwTSF2).u.dwLowDword < (unsigned long)(wRxBcnTSFOffst))
-		(qwTSF2).u.dwHighDword++;
-
-	LODWORD(qwTSFOffset) = LODWORD(qwTSF1) - LODWORD(qwTSF2);
-	if (LODWORD(qwTSF1) < LODWORD(qwTSF2)) {
-		// if borrow needed
-		HIDWORD(qwTSFOffset) = HIDWORD(qwTSF1) - HIDWORD(qwTSF2) - 1;
-	} else {
-		HIDWORD(qwTSFOffset) = HIDWORD(qwTSF1) - HIDWORD(qwTSF2);
-	}
+
+	qwTSF2 += (u64)wRxBcnTSFOffst;
+
+	qwTSFOffset = qwTSF1 - qwTSF2;
+
 	return qwTSFOffset;
 }
 
@@ -1983,7 +1960,7 @@ QWORD CARDqGetTSFOffset(unsigned char byRxRate, QWORD qwTSF1, QWORD qwTSF2)
  * Return Value: true if success; otherwise false
  *
  */
-bool CARDbGetCurrentTSF(void __iomem *dwIoBase, PQWORD pqwCurrTSF)
+bool CARDbGetCurrentTSF(void __iomem *dwIoBase, u64 *pqwCurrTSF)
 {
 	unsigned short ww;
 	unsigned char byData;
@@ -1996,8 +1973,8 @@ bool CARDbGetCurrentTSF(void __iomem *dwIoBase, PQWORD pqwCurrTSF)
 	}
 	if (ww == W_MAX_TIMEOUT)
 		return false;
-	VNSvInPortD(dwIoBase + MAC_REG_TSFCNTR, &LODWORD(*pqwCurrTSF));
-	VNSvInPortD(dwIoBase + MAC_REG_TSFCNTR + 4, &HIDWORD(*pqwCurrTSF));
+	VNSvInPortD(dwIoBase + MAC_REG_TSFCNTR, (u32 *)pqwCurrTSF);
+	VNSvInPortD(dwIoBase + MAC_REG_TSFCNTR + 4, (u32 *)pqwCurrTSF + 1);
 
 	return true;
 }
@@ -2016,7 +1993,7 @@ bool CARDbGetCurrentTSF(void __iomem *dwIoBase, PQWORD pqwCurrTSF)
  * Return Value: TSF value of next Beacon
  *
  */
-QWORD CARDqGetNextTBTT(QWORD qwTSF, unsigned short wBeaconInterval)
+u64 CARDqGetNextTBTT(u64 qwTSF, unsigned short wBeaconInterval)
 {
 	unsigned int uLowNextTBTT;
 	unsigned int uHighRemain, uLowRemain;
@@ -2024,20 +2001,21 @@ QWORD CARDqGetNextTBTT(QWORD qwTSF, unsigned short wBeaconInterval)
 
 	uBeaconInterval = wBeaconInterval * 1024;
 	// Next TBTT = ((local_current_TSF / beacon_interval) + 1) * beacon_interval
-	uLowNextTBTT = (LODWORD(qwTSF) >> 10) << 10;
+	uLowNextTBTT = ((qwTSF & 0xffffffffULL) >> 10) << 10;
 	// low dword (mod) bcn
 	uLowRemain = (uLowNextTBTT) % uBeaconInterval;
 	// high dword (mod) bcn
-	uHighRemain = (((0xffffffff % uBeaconInterval) + 1) * HIDWORD(qwTSF))
+	uHighRemain = (((0xffffffff % uBeaconInterval) + 1) * (u32)(qwTSF >> 32))
 		% uBeaconInterval;
 	uLowRemain = (uHighRemain + uLowRemain) % uBeaconInterval;
 	uLowRemain = uBeaconInterval - uLowRemain;
 
 	// check if carry when add one beacon interval
 	if ((~uLowNextTBTT) < uLowRemain)
-		HIDWORD(qwTSF)++;
+		qwTSF = ((qwTSF >> 32) + 1) << 32;
 
-	LODWORD(qwTSF) = uLowNextTBTT + uLowRemain;
+	qwTSF = (qwTSF & 0xffffffff00000000ULL) |
+		(u64)(uLowNextTBTT + uLowRemain);
 
 	return qwTSF;
 }
@@ -2058,15 +2036,14 @@ QWORD CARDqGetNextTBTT(QWORD qwTSF, unsigned short wBeaconInterval)
  */
 void CARDvSetFirstNextTBTT(void __iomem *dwIoBase, unsigned short wBeaconInterval)
 {
-	QWORD   qwNextTBTT;
+	u64 qwNextTBTT = 0;
 
-	HIDWORD(qwNextTBTT) = 0;
-	LODWORD(qwNextTBTT) = 0;
 	CARDbGetCurrentTSF(dwIoBase, &qwNextTBTT); //Get Local TSF counter
+
 	qwNextTBTT = CARDqGetNextTBTT(qwNextTBTT, wBeaconInterval);
 	// Set NextTBTT
-	VNSvOutPortD(dwIoBase + MAC_REG_NEXTTBTT, LODWORD(qwNextTBTT));
-	VNSvOutPortD(dwIoBase + MAC_REG_NEXTTBTT + 4, HIDWORD(qwNextTBTT));
+	VNSvOutPortD(dwIoBase + MAC_REG_NEXTTBTT, (u32)qwNextTBTT);
+	VNSvOutPortD(dwIoBase + MAC_REG_NEXTTBTT + 4, (u32)(qwNextTBTT >> 32));
 	MACvRegBitsOn(dwIoBase, MAC_REG_TFTCTL, TFTCTL_TBTTSYNCEN);
 }
 
@@ -2085,13 +2062,12 @@ void CARDvSetFirstNextTBTT(void __iomem *dwIoBase, unsigned short wBeaconInterva
  * Return Value: none
  *
  */
-void CARDvUpdateNextTBTT(void __iomem *dwIoBase, QWORD qwTSF, unsigned short wBeaconInterval)
+void CARDvUpdateNextTBTT(void __iomem *dwIoBase, u64 qwTSF, unsigned short wBeaconInterval)
 {
 	qwTSF = CARDqGetNextTBTT(qwTSF, wBeaconInterval);
 	// Set NextTBTT
-	VNSvOutPortD(dwIoBase + MAC_REG_NEXTTBTT, LODWORD(qwTSF));
-	VNSvOutPortD(dwIoBase + MAC_REG_NEXTTBTT + 4, HIDWORD(qwTSF));
+	VNSvOutPortD(dwIoBase + MAC_REG_NEXTTBTT, (u32)qwTSF);
+	VNSvOutPortD(dwIoBase + MAC_REG_NEXTTBTT + 4, (u32)(qwTSF >> 32));
 	MACvRegBitsOn(dwIoBase, MAC_REG_TFTCTL, TFTCTL_TBTTSYNCEN);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Card:Update Next TBTT[%8xh:%8xh]\n",
-		(unsigned int) HIDWORD(qwTSF), (unsigned int) LODWORD(qwTSF));
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Card:Update Next TBTT[%8llx]\n", qwTSF);
 }
diff --git a/drivers/staging/vt6655/card.h b/drivers/staging/vt6655/card.h
index 2f1a05e..6e3698b 100644
--- a/drivers/staging/vt6655/card.h
+++ b/drivers/staging/vt6655/card.h
@@ -85,10 +85,10 @@ bool CARDbIsOFDMinBasicRate(void *pDeviceHandler);
 void CARDvSetLoopbackMode(void __iomem *dwIoBase, unsigned short wLoopbackMode);
 bool CARDbSoftwareReset(void *pDeviceHandler);
 void CARDvSetFirstNextTBTT(void __iomem *dwIoBase, unsigned short wBeaconInterval);
-void CARDvUpdateNextTBTT(void __iomem *dwIoBase, QWORD qwTSF, unsigned short wBeaconInterval);
-bool CARDbGetCurrentTSF(void __iomem *dwIoBase, PQWORD pqwCurrTSF);
-QWORD CARDqGetNextTBTT(QWORD qwTSF, unsigned short wBeaconInterval);
-QWORD CARDqGetTSFOffset(unsigned char byRxRate, QWORD qwTSF1, QWORD qwTSF2);
+void CARDvUpdateNextTBTT(void __iomem *dwIoBase, u64 qwTSF, unsigned short wBeaconInterval);
+bool CARDbGetCurrentTSF(void __iomem *dwIoBase, u64 *pqwCurrTSF);
+u64 CARDqGetNextTBTT(u64 qwTSF, unsigned short wBeaconInterval);
+u64 CARDqGetTSFOffset(unsigned char byRxRate, u64 qwTSF1, u64 qwTSF2);
 bool CARDbSetTxPower(void *pDeviceHandler, unsigned long ulTxPower);
 unsigned char CARDbyGetPktType(void *pDeviceHandler);
 void CARDvSafeResetTx(void *pDeviceHandler);
@@ -99,7 +99,7 @@ bool CARDbRadioPowerOn(void *pDeviceHandler);
 bool CARDbIsShortPreamble(void *pDeviceHandler);
 bool CARDbIsShorSlotTime(void *pDeviceHandler);
 bool CARDbSetPhyParameter(void *pDeviceHandler, CARD_PHY_TYPE ePHYType, unsigned short wCapInfo, unsigned char byERPField, void *pvSupportRateIEs, void *pvExtSupportRateIEs);
-bool CARDbUpdateTSF(void *pDeviceHandler, unsigned char byRxRate, QWORD qwBSSTimestamp, QWORD qwLocalTSF);
+bool CARDbUpdateTSF(void *pDeviceHandler, unsigned char byRxRate, u64 qwBSSTimestamp, u64 qwLocalTSF);
 bool CARDbStopTxPacket(void *pDeviceHandler, CARD_PKT_TYPE ePktType);
 bool CARDbStartTxPacket(void *pDeviceHandler, CARD_PKT_TYPE ePktType);
 bool CARDbSetBeaconPeriod(void *pDeviceHandler, unsigned short wBeaconInterval);
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index b857881..96d14da 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -566,7 +566,7 @@ typedef struct __device_info {
 	SKeyManagement          sKey;
 	unsigned long dwIVCounter;
 
-	QWORD                   qwPacketNumber; //For CCMP and TKIP as TSC(6 bytes)
+	u64 qwPacketNumber; /* For CCMP and TKIP as TSC(6 bytes) */
 	unsigned int	uCurrentWEPMode;
 
 	RC4Ext                  SBox;
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index 0bcf6c7..4497419 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -283,7 +283,7 @@ device_receive_frame(
 	unsigned char *pbyRsr;
 	unsigned char *pbyNewRsr;
 	unsigned char *pbyRSSI;
-	PQWORD          pqwTSFTime;
+	__le64 *pqwTSFTime;
 	unsigned short *pwFrameSize;
 	unsigned char *pbyFrame;
 	bool bDeFragRx = false;
@@ -334,7 +334,7 @@ device_receive_frame(
 	pbyRSSI = (unsigned char *)(skb->data + FrameSize - 2);
 	pbyNewRsr = (unsigned char *)(skb->data + FrameSize - 3);
 	pbySQ = (unsigned char *)(skb->data + FrameSize - 4);
-	pqwTSFTime = (PQWORD)(skb->data + FrameSize - 12);
+	pqwTSFTime = (__le64 *)(skb->data + FrameSize - 12);
 	pbyFrame = (unsigned char *)(skb->data + 4);
 
 	// get packet size
@@ -515,8 +515,7 @@ device_receive_frame(
 			pRxPacket->cbMPDULen = FrameSize;
 			pRxPacket->uRSSI = *pbyRSSI;
 			pRxPacket->bySQ = *pbySQ;
-			HIDWORD(pRxPacket->qwLocalTSF) = cpu_to_le32(HIDWORD(*pqwTSFTime));
-			LODWORD(pRxPacket->qwLocalTSF) = cpu_to_le32(LODWORD(*pqwTSFTime));
+			pRxPacket->qwLocalTSF = le64_to_cpu(*pqwTSFTime);
 			if (bIsWEP) {
 				// strip IV
 				pbyData1 = WLAN_HDR_A3_DATA_PTR(skb->data+4);
@@ -796,7 +795,7 @@ device_receive_frame(
 			RSC = dwRxTSC47_16;
 			RSC <<= 16;
 			RSC += wRxTSC15_0;
-			memcpy(&(pKey->KeyRSC), &RSC,  sizeof(QWORD));
+			pKey->KeyRSC = RSC;
 
 			if ((pDevice->sMgmtObj.eCurrMode == WMAC_MODE_ESS_STA) &&
 			    (pDevice->sMgmtObj.eCurrState == WMAC_STATE_ASSOC)) {
diff --git a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hostap.c
index f105c2a..29e8eb3 100644
--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -417,7 +417,7 @@ static int hostap_set_encryption(PSDevice pDevice,
 	unsigned long dwKeyIndex = 0;
 	unsigned char abyKey[MAX_KEY_LEN];
 	unsigned char abySeq[MAX_KEY_LEN];
-	unsigned long long KeyRSC;
+	u64 KeyRSC;
 	unsigned char byKeyDecMode = KEY_CTL_WEP;
 	int     iNodeIndex = -1;
 	int     ii;
@@ -509,7 +509,7 @@ static int hostap_set_encryption(PSDevice pDevice,
 				       &param->sta_addr[0],
 				       dwKeyIndex & ~(USE_KEYRSC),
 				       param->u.crypt.key_len,
-				       (PQWORD) &(KeyRSC),
+				       (u64 *) &KeyRSC,
 				       (unsigned char *)abyKey,
 				       KEY_CTL_WEP,
 				       pDevice->PortOffset,
@@ -534,7 +534,7 @@ static int hostap_set_encryption(PSDevice pDevice,
 	if (param->u.crypt.seq) {
 		memcpy(&abySeq, param->u.crypt.seq, 8);
 		for (ii = 0; ii < 8; ii++)
-			KeyRSC |= (unsigned long)abySeq[ii] << (ii * 8);
+			KeyRSC |= (u64)abySeq[ii] << (ii * 8);
 
 		dwKeyIndex |= 1 << 29;
 		pMgmt->sNodeDBTable[iNodeIndex].KeyRSC = KeyRSC;
@@ -563,7 +563,7 @@ static int hostap_set_encryption(PSDevice pDevice,
 		KeybSetDefaultKey(&(pDevice->sKey),
 				  dwKeyIndex,
 				  param->u.crypt.key_len,
-				  (PQWORD) &(KeyRSC),
+				  (u64 *) &KeyRSC,
 				  abyKey,
 				  byKeyDecMode,
 				  pDevice->PortOffset,
@@ -576,7 +576,7 @@ static int hostap_set_encryption(PSDevice pDevice,
 			       &param->sta_addr[0],
 			       dwKeyIndex,
 			       param->u.crypt.key_len,
-			       (PQWORD) &(KeyRSC),
+			       (u64 *) &KeyRSC,
 			       (unsigned char *)abyKey,
 			       byKeyDecMode,
 			       pDevice->PortOffset,
diff --git a/drivers/staging/vt6655/key.c b/drivers/staging/vt6655/key.c
index 9339e2a..1903790 100644
--- a/drivers/staging/vt6655/key.c
+++ b/drivers/staging/vt6655/key.c
@@ -184,7 +184,7 @@ bool KeybSetKey(
 	unsigned char *pbyBSSID,
 	unsigned long dwKeyIndex,
 	unsigned long uKeyLength,
-	PQWORD          pKeyRSC,
+	u64 *pKeyRSC,
 	unsigned char *pbyKey,
 	unsigned char byKeyDecMode,
 	void __iomem *dwIoBase,
@@ -245,9 +245,9 @@ bool KeybSetKey(
 
 			if ((dwKeyIndex & USE_KEYRSC) == 0) {
 				// RSC set by NIC
-				memset(&(pKey->KeyRSC), 0, sizeof(QWORD));
+				pKey->KeyRSC = 0;
 			} else {
-				memcpy(&(pKey->KeyRSC), pKeyRSC,  sizeof(QWORD));
+				pKey->KeyRSC = *pKeyRSC;
 			}
 			pKey->dwTSC47_16 = 0;
 			pKey->wTSC15_0 = 0;
@@ -308,9 +308,9 @@ bool KeybSetKey(
 
 		if ((dwKeyIndex & USE_KEYRSC) == 0) {
 			// RSC set by NIC
-			memset(&(pKey->KeyRSC), 0, sizeof(QWORD));
+			pKey->KeyRSC = 0;
 		} else {
-			memcpy(&(pKey->KeyRSC), pKeyRSC,  sizeof(QWORD));
+			pKey->KeyRSC = *pKeyRSC;
 		}
 		pKey->dwTSC47_16 = 0;
 		pKey->wTSC15_0 = 0;
@@ -606,7 +606,7 @@ bool KeybSetDefaultKey(
 	PSKeyManagement pTable,
 	unsigned long dwKeyIndex,
 	unsigned long uKeyLength,
-	PQWORD          pKeyRSC,
+	u64 *pKeyRSC,
 	unsigned char *pbyKey,
 	unsigned char byKeyDecMode,
 	void __iomem *dwIoBase,
@@ -669,9 +669,9 @@ bool KeybSetDefaultKey(
 
 	if ((dwKeyIndex & USE_KEYRSC) == 0) {
 		// RSC set by NIC
-		memset(&(pKey->KeyRSC), 0, sizeof(QWORD));
+		pKey->KeyRSC = 0;
 	} else {
-		memcpy(&(pKey->KeyRSC), pKeyRSC,  sizeof(QWORD));
+		pKey->KeyRSC = *pKeyRSC;
 	}
 	pKey->dwTSC47_16 = 0;
 	pKey->wTSC15_0 = 0;
@@ -712,7 +712,7 @@ bool KeybSetAllGroupKey(
 	PSKeyManagement pTable,
 	unsigned long dwKeyIndex,
 	unsigned long uKeyLength,
-	PQWORD          pKeyRSC,
+	u64 *pKeyRSC,
 	unsigned char *pbyKey,
 	unsigned char byKeyDecMode,
 	void __iomem *dwIoBase,
@@ -764,9 +764,9 @@ bool KeybSetAllGroupKey(
 
 			if ((dwKeyIndex & USE_KEYRSC) == 0) {
 				// RSC set by NIC
-				memset(&(pKey->KeyRSC), 0, sizeof(QWORD));
+				pKey->KeyRSC = 0;
 			} else {
-				memcpy(&(pKey->KeyRSC), pKeyRSC,  sizeof(QWORD));
+				pKey->KeyRSC = *pKeyRSC;
 			}
 			pKey->dwTSC47_16 = 0;
 			pKey->wTSC15_0 = 0;
diff --git a/drivers/staging/vt6655/key.h b/drivers/staging/vt6655/key.h
index 3eb881b..44efe18 100644
--- a/drivers/staging/vt6655/key.h
+++ b/drivers/staging/vt6655/key.h
@@ -57,7 +57,7 @@ typedef struct tagSKeyItem {
 	bool bKeyValid;
 	unsigned long uKeyLength;
 	unsigned char abyKey[MAX_KEY_LEN];
-	QWORD       KeyRSC;
+	u64 KeyRSC;
 	unsigned long dwTSC47_16;
 	unsigned short wTSC15_0;
 	unsigned char byCipherSuite;
@@ -108,7 +108,7 @@ bool KeybSetKey(
 	unsigned char *pbyBSSID,
 	unsigned long dwKeyIndex,
 	unsigned long uKeyLength,
-	PQWORD          pKeyRSC,
+	u64 *pKeyRSC,
 	unsigned char *pbyKey,
 	unsigned char byKeyDecMode,
 	void __iomem *dwIoBase,
@@ -119,7 +119,7 @@ bool KeybSetDefaultKey(
 	PSKeyManagement pTable,
 	unsigned long dwKeyIndex,
 	unsigned long uKeyLength,
-	PQWORD          pKeyRSC,
+	u64 *pKeyRSC,
 	unsigned char *pbyKey,
 	unsigned char byKeyDecMode,
 	void __iomem *dwIoBase,
@@ -166,7 +166,7 @@ bool KeybSetAllGroupKey(
 	PSKeyManagement pTable,
 	unsigned long dwKeyIndex,
 	unsigned long uKeyLength,
-	PQWORD          pKeyRSC,
+	u64 *pKeyRSC,
 	unsigned char *pbyKey,
 	unsigned char byKeyDecMode,
 	void __iomem *dwIoBase,
diff --git a/drivers/staging/vt6655/ttype.h b/drivers/staging/vt6655/ttype.h
index 3f3a768..747ef62 100644
--- a/drivers/staging/vt6655/ttype.h
+++ b/drivers/staging/vt6655/ttype.h
@@ -39,27 +39,4 @@
 #define Calcu_LinkQual
 #endif
 
-/****** Simple typedefs  ***************************************************/
-
-/* These lines assume that your compiler's longs are 32 bits and
- * shorts are 16 bits. It is already assumed that chars are 8 bits,
- * but it doesn't matter if they're signed or unsigned.
- */
-
-// QWORD is for those situation that we want
-// an 8-byte-aligned 8 byte long structure
-// which is NOT really a floating point number.
-typedef union tagUQuadWord {
-	struct {
-		unsigned int dwLowDword;
-		unsigned int dwHighDword;
-	} u;
-	double      DoNotUseThisField;
-} UQuadWord;
-typedef UQuadWord       QWORD;          // 64-bit
-
-/****** Common pointer types ***********************************************/
-
-typedef QWORD *PQWORD;
-
 #endif // __TTYPE_H__
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index 3b9819e..79ba37b 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -1721,7 +1721,7 @@ s_vMgrRxBeacon(
 {
 	PKnownBSS           pBSSList;
 	WLAN_FR_BEACON      sFrame;
-	QWORD               qwTSFOffset;
+	u64 qwTSFOffset;
 	bool bIsBSSIDEqual = false;
 	bool bIsSSIDEqual = false;
 	bool bTSFLargeDiff = false;
@@ -1733,8 +1733,8 @@ s_vMgrRxBeacon(
 	unsigned char byTIMBitOn = 0;
 	unsigned short wAIDNumber = 0;
 	unsigned int uNodeIndex;
-	QWORD               qwTimestamp, qwLocalTSF;
-	QWORD               qwCurrTSF;
+	u64 qwTimestamp, qwLocalTSF;
+	u64 qwCurrTSF;
 	unsigned short wStartIndex = 0;
 	unsigned short wAIDIndex = 0;
 	unsigned char byCurrChannel = pRxPacket->byRxChannel;
@@ -1972,32 +1972,22 @@ s_vMgrRxBeacon(
 		}
 	}
 
-	HIDWORD(qwTimestamp) = cpu_to_le32(HIDWORD(*sFrame.pqwTimestamp));
-	LODWORD(qwTimestamp) = cpu_to_le32(LODWORD(*sFrame.pqwTimestamp));
-	HIDWORD(qwLocalTSF) = HIDWORD(pRxPacket->qwLocalTSF);
-	LODWORD(qwLocalTSF) = LODWORD(pRxPacket->qwLocalTSF);
+	qwTimestamp = le64_to_cpu(*sFrame.pqwTimestamp);
+	qwLocalTSF = pRxPacket->qwLocalTSF;
 
 	// check if beacon TSF larger or small than our local TSF
-	if (HIDWORD(qwTimestamp) == HIDWORD(qwLocalTSF)) {
-		if (LODWORD(qwTimestamp) >= LODWORD(qwLocalTSF))
-			bTSFOffsetPostive = true;
-		else
-			bTSFOffsetPostive = false;
-	} else if (HIDWORD(qwTimestamp) > HIDWORD(qwLocalTSF)) {
+	if (qwTimestamp >= qwLocalTSF)
 		bTSFOffsetPostive = true;
-	} else if (HIDWORD(qwTimestamp) < HIDWORD(qwLocalTSF)) {
+	else
 		bTSFOffsetPostive = false;
-	}
 
 	if (bTSFOffsetPostive)
 		qwTSFOffset = CARDqGetTSFOffset(pRxPacket->byRxRate, (qwTimestamp), (qwLocalTSF));
 	else
 		qwTSFOffset = CARDqGetTSFOffset(pRxPacket->byRxRate, (qwLocalTSF), (qwTimestamp));
 
-	if (HIDWORD(qwTSFOffset) != 0 ||
-	    (LODWORD(qwTSFOffset) > TRIVIAL_SYNC_DIFFERENCE)) {
+	if (qwTSFOffset > TRIVIAL_SYNC_DIFFERENCE)
 		bTSFLargeDiff = true;
-	}
 
 	// if infra mode
 	if (bIsAPBeacon) {
@@ -2194,7 +2184,7 @@ vMgrCreateOwnIBSS(
 	unsigned short wMaxSuppRate;
 	unsigned char byTopCCKBasicRate;
 	unsigned char byTopOFDMBasicRate;
-	QWORD               qwCurrTSF;
+	u64 qwCurrTSF;
 	unsigned int ii;
 	unsigned char abyRATE[] = {0x82, 0x84, 0x8B, 0x96, 0x24, 0x30, 0x48, 0x6C, 0x0C, 0x12, 0x18, 0x60};
 	unsigned char abyCCK_RATE[] = {0x82, 0x84, 0x8B, 0x96};
@@ -2316,12 +2306,12 @@ vMgrCreateOwnIBSS(
 
 	if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
 		// BSSID selected must be randomized as spec 11.1.3
-		pMgmt->abyCurrBSSID[5] = (unsigned char) (LODWORD(qwCurrTSF) & 0x000000ff);
-		pMgmt->abyCurrBSSID[4] = (unsigned char)((LODWORD(qwCurrTSF) & 0x0000ff00) >> 8);
-		pMgmt->abyCurrBSSID[3] = (unsigned char)((LODWORD(qwCurrTSF) & 0x00ff0000) >> 16);
-		pMgmt->abyCurrBSSID[2] = (unsigned char)((LODWORD(qwCurrTSF) & 0x00000ff0) >> 4);
-		pMgmt->abyCurrBSSID[1] = (unsigned char)((LODWORD(qwCurrTSF) & 0x000ff000) >> 12);
-		pMgmt->abyCurrBSSID[0] = (unsigned char)((LODWORD(qwCurrTSF) & 0x0ff00000) >> 20);
+		pMgmt->abyCurrBSSID[5] = (u8) (qwCurrTSF & 0x000000ff);
+		pMgmt->abyCurrBSSID[4] = (u8) ((qwCurrTSF & 0x0000ff00) >> 8);
+		pMgmt->abyCurrBSSID[3] = (u8) ((qwCurrTSF & 0x00ff0000) >> 16);
+		pMgmt->abyCurrBSSID[2] = (u8) ((qwCurrTSF & 0x00000ff0) >> 4);
+		pMgmt->abyCurrBSSID[1] = (u8) ((qwCurrTSF & 0x000ff000) >> 12);
+		pMgmt->abyCurrBSSID[0] = (u8) ((qwCurrTSF & 0x0ff00000) >> 20);
 		pMgmt->abyCurrBSSID[5] ^= pMgmt->abyMACAddr[0];
 		pMgmt->abyCurrBSSID[4] ^= pMgmt->abyMACAddr[1];
 		pMgmt->abyCurrBSSID[3] ^= pMgmt->abyMACAddr[2];
diff --git a/drivers/staging/vt6655/wmgr.h b/drivers/staging/vt6655/wmgr.h
index a71daed..ce939b3 100644
--- a/drivers/staging/vt6655/wmgr.h
+++ b/drivers/staging/vt6655/wmgr.h
@@ -175,7 +175,7 @@ typedef struct tagSTxMgmtPacket {
 // Rx Management Packet descriptor
 typedef struct tagSRxMgmtPacket {
 	PUWLAN_80211HDR     p80211Header;
-	QWORD               qwLocalTSF;
+	u64 qwLocalTSF;
 	unsigned int cbMPDULen;
 	unsigned int cbPayloadLen;
 	unsigned int uRSSI;
diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index 4c6e337..6f29a69 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -195,7 +195,7 @@ int wpa_set_keys(PSDevice pDevice, void *ctx,
 	unsigned long dwKeyIndex = 0;
 	unsigned char abyKey[MAX_KEY_LEN];
 	unsigned char abySeq[MAX_KEY_LEN];
-	QWORD   KeyRSC;
+	u64 KeyRSC;
 	unsigned char byKeyDecMode = KEY_CTL_WEP;
 	int ret = 0;
 	int uu, ii;
@@ -271,9 +271,9 @@ int wpa_set_keys(PSDevice pDevice, void *ctx,
 	if (param->u.wpa_key.seq_len > 0) {
 		for (ii = 0; ii < param->u.wpa_key.seq_len; ii++) {
 			if (ii < 4)
-				LODWORD(KeyRSC) |= (abySeq[ii] << (ii * 8));
+				KeyRSC |= (u64)(abySeq[ii] << (ii * 8));
 			else
-				HIDWORD(KeyRSC) |= (abySeq[ii] << ((ii-4) * 8));
+				KeyRSC |= (u64)(abySeq[ii] << ((ii-4) * 8));
 		}
 		dwKeyIndex |= 1 << 29;
 	}
@@ -336,7 +336,7 @@ int wpa_set_keys(PSDevice pDevice, void *ctx,
 		if (KeybSetAllGroupKey(&(pDevice->sKey),
 					dwKeyIndex,
 					param->u.wpa_key.key_len,
-					(PQWORD) &(KeyRSC),
+					(u64 *) &KeyRSC,
 					(unsigned char *)abyKey,
 					byKeyDecMode,
 					pDevice->PortOffset,
@@ -344,7 +344,7 @@ int wpa_set_keys(PSDevice pDevice, void *ctx,
 		    KeybSetDefaultKey(&(pDevice->sKey),
 				       dwKeyIndex,
 				       param->u.wpa_key.key_len,
-				       (PQWORD) &(KeyRSC),
+				       (u64 *) &KeyRSC,
 				       (unsigned char *)abyKey,
 				       byKeyDecMode,
 				       pDevice->PortOffset,
@@ -372,7 +372,7 @@ int wpa_set_keys(PSDevice pDevice, void *ctx,
 			       &param->addr[0],
 			       dwKeyIndex,
 			       param->u.wpa_key.key_len,
-			       (PQWORD) &(KeyRSC),
+			       (u64 *) &KeyRSC,
 			       (unsigned char *)abyKey,
 			       byKeyDecMode,
 			       pDevice->PortOffset,
-- 
1.9.1

