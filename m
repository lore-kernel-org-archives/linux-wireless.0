Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56748 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab2K1VLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 16:11:13 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so5955057bkw.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 13:11:11 -0800 (PST)
Message-ID: <1354137062.2633.1.camel@user64-MCP7A> (sfid-20121128_221135_995092_6D8D9BDC)
Subject: [PATCH 1/3] staging: vt6656: Remove QWORD from source and replace
 with u64.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 28 Nov 2012 21:11:02 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/80211mgr.c |   28 ++++----
 drivers/staging/vt6656/80211mgr.h |    4 +-
 drivers/staging/vt6656/bssdb.c    |   11 ++-
 drivers/staging/vt6656/bssdb.h    |    8 +--
 drivers/staging/vt6656/card.c     |  141 +++++++++++++++----------------------
 drivers/staging/vt6656/card.h     |   10 +--
 drivers/staging/vt6656/device.h   |    2 +-
 drivers/staging/vt6656/dpc.c      |    9 ++-
 drivers/staging/vt6656/hostap.c   |   18 +++--
 drivers/staging/vt6656/int.c      |    3 +-
 drivers/staging/vt6656/int.h      |    3 +-
 drivers/staging/vt6656/key.c      |   54 +++++++-------
 drivers/staging/vt6656/key.h      |    8 +--
 drivers/staging/vt6656/ttype.h    |   14 ----
 drivers/staging/vt6656/wmgr.c     |   53 +++++---------
 drivers/staging/vt6656/wmgr.h     |    2 +-
 drivers/staging/vt6656/wpactl.c   |   12 ++--
 17 files changed, 158 insertions(+), 222 deletions(-)

diff --git a/drivers/staging/vt6656/80211mgr.c b/drivers/staging/vt6656/80211mgr.c
index e6ced95..8221d65 100644
--- a/drivers/staging/vt6656/80211mgr.c
+++ b/drivers/staging/vt6656/80211mgr.c
@@ -96,9 +96,10 @@ vMgrEncodeBeacon(
 {
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-    /* Fixed Fields */
-    pFrame->pqwTimestamp = (PQWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                    + WLAN_BEACON_OFF_TS);
+	/* Fixed Fields */
+	pFrame->pqwTimestamp =
+		(u64 *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3)) +
+			WLAN_BEACON_OFF_TS);
     pFrame->pwBeaconInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                        + WLAN_BEACON_OFF_BCN_INT);
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -130,9 +131,10 @@ vMgrDecodeBeacon(
 
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-    /* Fixed Fields */
-    pFrame->pqwTimestamp = (PQWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                    + WLAN_BEACON_OFF_TS);
+	/* Fixed Fields */
+	pFrame->pqwTimestamp =
+		(u64 *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3)) +
+			WLAN_BEACON_OFF_TS);
     pFrame->pwBeaconInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                        + WLAN_BEACON_OFF_BCN_INT);
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -671,9 +673,10 @@ vMgrEncodeProbeResponse(
 {
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-    /* Fixed Fields */
-    pFrame->pqwTimestamp = (PQWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                    + WLAN_PROBERESP_OFF_TS);
+	/* Fixed Fields */
+	pFrame->pqwTimestamp =
+		(u64 *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3)) +
+			WLAN_PROBERESP_OFF_TS);
     pFrame->pwBeaconInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                        + WLAN_PROBERESP_OFF_BCN_INT);
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -706,9 +709,10 @@ vMgrDecodeProbeResponse(
 
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-    /* Fixed Fields */
-    pFrame->pqwTimestamp = (PQWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                    + WLAN_PROBERESP_OFF_TS);
+	/* Fixed Fields */
+	pFrame->pqwTimestamp =
+		(u64 *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3)) +
+			WLAN_PROBERESP_OFF_TS);
     pFrame->pwBeaconInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                        + WLAN_PROBERESP_OFF_BCN_INT);
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
diff --git a/drivers/staging/vt6656/80211mgr.h b/drivers/staging/vt6656/80211mgr.h
index e5db73b..29fad08 100644
--- a/drivers/staging/vt6656/80211mgr.h
+++ b/drivers/staging/vt6656/80211mgr.h
@@ -526,7 +526,7 @@ typedef struct tagWLAN_FR_BEACON {
     PBYTE                   pBuf;
     PUWLAN_80211HDR         pHdr;
     // fixed fields
-    PQWORD                  pqwTimestamp;
+	u64 *pqwTimestamp;
     PWORD                   pwBeaconInterval;
     PWORD                   pwCapInfo;
     /*-- info elements ----------*/
@@ -683,7 +683,7 @@ typedef struct tagWLAN_FR_PROBERESP {
     PBYTE                   pBuf;
     PUWLAN_80211HDR         pHdr;
     /*-- fixed fields -----------*/
-    PQWORD                  pqwTimestamp;
+	u64 *pqwTimestamp;
     PWORD                   pwBeaconInterval;
     PWORD                   pwCapInfo;
     /*-- info elements ----------*/
diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 6a13941..539bc1d 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -339,7 +339,7 @@ PKnownBSS BSSpAddrIsInBSSList(void *hDeviceContext,
 
 BOOL BSSbInsertToBSSList(void *hDeviceContext,
 			 PBYTE abyBSSIDAddr,
-			 QWORD qwTimestamp,
+			u64 qwTimestamp,
 			 WORD wBeaconInterval,
 			 WORD wCapInfo,
 			 BYTE byCurrChannel,
@@ -380,8 +380,7 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
     // save the BSS info
     pBSSList->bActive = TRUE;
     memcpy( pBSSList->abyBSSID, abyBSSIDAddr, WLAN_BSSID_LEN);
-    HIDWORD(pBSSList->qwBSSTimestamp) = cpu_to_le32(HIDWORD(qwTimestamp));
-    LODWORD(pBSSList->qwBSSTimestamp) = cpu_to_le32(LODWORD(qwTimestamp));
+	pBSSList->qwBSSTimestamp = cpu_to_le64(qwTimestamp);
     pBSSList->wBeaconInterval = cpu_to_le16(wBeaconInterval);
     pBSSList->wCapInfo = cpu_to_le16(wCapInfo);
     pBSSList->uClearCount = 0;
@@ -519,7 +518,7 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
 // TODO: input structure modify
 
 BOOL BSSbUpdateToBSSList(void *hDeviceContext,
-			 QWORD qwTimestamp,
+			u64 qwTimestamp,
 			 WORD wBeaconInterval,
 			 WORD wCapInfo,
 			 BYTE byCurrChannel,
@@ -548,8 +547,8 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
         return FALSE;
 

-    HIDWORD(pBSSList->qwBSSTimestamp) = cpu_to_le32(HIDWORD(qwTimestamp));
-    LODWORD(pBSSList->qwBSSTimestamp) = cpu_to_le32(LODWORD(qwTimestamp));
+	pBSSList->qwBSSTimestamp = cpu_to_le64(qwTimestamp);
+
     pBSSList->wBeaconInterval = cpu_to_le16(wBeaconInterval);
     pBSSList->wCapInfo = cpu_to_le16(wCapInfo);
     pBSSList->uClearCount = 0;
diff --git a/drivers/staging/vt6656/bssdb.h b/drivers/staging/vt6656/bssdb.h
index 6b2ec39..125edc2 100644
--- a/drivers/staging/vt6656/bssdb.h
+++ b/drivers/staging/vt6656/bssdb.h
@@ -142,8 +142,8 @@ typedef struct tagKnownBSS {
     unsigned int            uClearCount;
 //    BYTE            abyIEs[WLAN_BEACON_FR_MAXLEN];
     unsigned int            uIELength;
-    QWORD           qwBSSTimestamp;
-    QWORD           qwLocalTSF;     // local TSF timer
+	u64 qwBSSTimestamp;
+	u64 qwLocalTSF;/* local TSF timer */
 
     CARD_PHY_TYPE   eNetworkTypeInUse;
 
@@ -239,7 +239,7 @@ void BSSvClearBSSList(void *hDeviceContext, BOOL bKeepCurrBSSID);
 
 BOOL BSSbInsertToBSSList(void *hDeviceContext,
 			 PBYTE abyBSSIDAddr,
-			 QWORD qwTimestamp,
+			u64 qwTimestamp,
 			 WORD wBeaconInterval,
 			 WORD wCapInfo,
 			 BYTE byCurrChannel,
@@ -256,7 +256,7 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
 			 void *pRxPacketContext);
 
 BOOL BSSbUpdateToBSSList(void *hDeviceContext,
-			 QWORD qwTimestamp,
+			u64 qwTimestamp,
 			 WORD wBeaconInterval,
 			 WORD wCapInfo,
 			 BYTE byCurrChannel,
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 826520b..d89fac5 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -654,28 +654,18 @@ BYTE CARDbyGetPktType(void *pDeviceHandler)
  * Return Value: TSF Offset value
  *
  */
-QWORD CARDqGetTSFOffset (BYTE byRxRate, QWORD qwTSF1, QWORD qwTSF2)
+u64 CARDqGetTSFOffset(BYTE byRxRate, u64 qwTSF1, u64 qwTSF2)
 {
-    QWORD   qwTSFOffset;
-    WORD    wRxBcnTSFOffst = 0;
+	u64 qwTSFOffset = 0;
+	WORD wRxBcnTSFOffst = 0;
 
-    HIDWORD(qwTSFOffset) = 0;
-    LODWORD(qwTSFOffset) = 0;
+	wRxBcnTSFOffst = cwRXBCNTSFOff[byRxRate % MAX_RATE];
 
-    wRxBcnTSFOffst = cwRXBCNTSFOff[byRxRate%MAX_RATE];
-    (qwTSF2).u.dwLowDword += (DWORD)(wRxBcnTSFOffst);
-    if ((qwTSF2).u.dwLowDword < (DWORD)(wRxBcnTSFOffst)) {
-        (qwTSF2).u.dwHighDword++;
-    }
-    LODWORD(qwTSFOffset) = LODWORD(qwTSF1) - LODWORD(qwTSF2);
-    if (LODWORD(qwTSF1) < LODWORD(qwTSF2)) {
-        // if borrow needed
-        HIDWORD(qwTSFOffset) = HIDWORD(qwTSF1) - HIDWORD(qwTSF2) - 1 ;
-    }
-    else {
-        HIDWORD(qwTSFOffset) = HIDWORD(qwTSF1) - HIDWORD(qwTSF2);
-    };
-    return (qwTSFOffset);
+	qwTSF2 += (u64)wRxBcnTSFOffst;
+
+	qwTSFOffset = qwTSF1 - qwTSF2;
+
+	return qwTSFOffset;
 }
 

@@ -696,32 +686,26 @@ QWORD CARDqGetTSFOffset (BYTE byRxRate, QWORD qwTSF1, QWORD qwTSF2)
  *
  */
 void CARDvAdjustTSF(void *pDeviceHandler, BYTE byRxRate,
-		    QWORD qwBSSTimestamp, QWORD qwLocalTSF)
+		u64 qwBSSTimestamp, u64 qwLocalTSF)
 {
 
     PSDevice        pDevice = (PSDevice) pDeviceHandler;
-    QWORD           qwTSFOffset;
-    DWORD           dwTSFOffset1,dwTSFOffset2;
+	u64 qwTSFOffset = 0;
     BYTE            pbyData[8];
 
-    HIDWORD(qwTSFOffset) = 0;
-    LODWORD(qwTSFOffset) = 0;
 
     qwTSFOffset = CARDqGetTSFOffset(byRxRate, qwBSSTimestamp, qwLocalTSF);
     // adjust TSF
     // HW's TSF add TSF Offset reg
-    dwTSFOffset1 = LODWORD(qwTSFOffset);
-    dwTSFOffset2 = HIDWORD(qwTSFOffset);
 
-
-    pbyData[0] = (BYTE)dwTSFOffset1;
-    pbyData[1] = (BYTE)(dwTSFOffset1>>8);
-    pbyData[2] = (BYTE)(dwTSFOffset1>>16);
-    pbyData[3] = (BYTE)(dwTSFOffset1>>24);
-    pbyData[4] = (BYTE)dwTSFOffset2;
-    pbyData[5] = (BYTE)(dwTSFOffset2>>8);
-    pbyData[6] = (BYTE)(dwTSFOffset2>>16);
-    pbyData[7] = (BYTE)(dwTSFOffset2>>24);
+	pbyData[0] = (u8)qwTSFOffset;
+	pbyData[1] = (u8)(qwTSFOffset >> 8);
+	pbyData[2] = (u8)(qwTSFOffset >> 16);
+	pbyData[3] = (u8)(qwTSFOffset >> 24);
+	pbyData[4] = (u8)(qwTSFOffset >> 32);
+	pbyData[5] = (u8)(qwTSFOffset >> 40);
+	pbyData[6] = (u8)(qwTSFOffset >> 48);
+	pbyData[7] = (u8)(qwTSFOffset >> 56);
 
     CONTROLnsRequestOut(pDevice,
                         MESSAGE_TYPE_SET_TSFTBTT,
@@ -745,12 +729,11 @@ void CARDvAdjustTSF(void *pDeviceHandler, BYTE byRxRate,
  * Return Value: TRUE if success; otherwise FALSE
  *
  */
-BOOL CARDbGetCurrentTSF(void *pDeviceHandler, PQWORD pqwCurrTSF)
+BOOL CARDbGetCurrentTSF(void *pDeviceHandler, u64 *pqwCurrTSF)
 {
-    PSDevice    pDevice = (PSDevice) pDeviceHandler;
+	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 
-    LODWORD(*pqwCurrTSF) = LODWORD(pDevice->qwCurrTSF);
-    HIDWORD(*pqwCurrTSF) = HIDWORD(pDevice->qwCurrTSF);
+	*pqwCurrTSF = pDevice->qwCurrTSF;
 
     return(TRUE);
 }
@@ -773,8 +756,7 @@ BOOL CARDbClearCurrentTSF(void *pDeviceHandler)
 
     MACvRegBitsOn(pDevice,MAC_REG_TFTCTL,TFTCTL_TSFCNTRST);
 
-    LODWORD(pDevice->qwCurrTSF) = 0;
-    HIDWORD(pDevice->qwCurrTSF) = 0;
+	pDevice->qwCurrTSF = 0;
 
     return(TRUE);
 }
@@ -793,7 +775,7 @@ BOOL CARDbClearCurrentTSF(void *pDeviceHandler)
  * Return Value: TSF value of next Beacon
  *
  */
-QWORD CARDqGetNextTBTT (QWORD qwTSF, WORD wBeaconInterval)
+u64 CARDqGetNextTBTT(u64 qwTSF, WORD wBeaconInterval)
 {
 
     unsigned int    uLowNextTBTT;
@@ -802,18 +784,19 @@ QWORD CARDqGetNextTBTT (QWORD qwTSF, WORD wBeaconInterval)
 
     uBeaconInterval = wBeaconInterval * 1024;
     // Next TBTT = ((local_current_TSF / beacon_interval) + 1 ) * beacon_interval
-    uLowNextTBTT = (LODWORD(qwTSF) >> 10) << 10;
-    uLowRemain = (uLowNextTBTT) % uBeaconInterval;
-    uHighRemain = ((0x80000000 % uBeaconInterval)* 2 * HIDWORD(qwTSF))
-                  % uBeaconInterval;
-    uLowRemain = (uHighRemain + uLowRemain) % uBeaconInterval;
-    uLowRemain = uBeaconInterval - uLowRemain;
+	uLowNextTBTT = ((qwTSF & 0xffffffffU) >> 10) << 10;
+	uLowRemain = (uLowNextTBTT) % uBeaconInterval;
+	uHighRemain = ((0x80000000 % uBeaconInterval) * 2 * (u32)(qwTSF >> 32))
+		% uBeaconInterval;
+	uLowRemain = (uHighRemain + uLowRemain) % uBeaconInterval;
+	uLowRemain = uBeaconInterval - uLowRemain;
 
     // check if carry when add one beacon interval
-    if ((~uLowNextTBTT) < uLowRemain)
-        HIDWORD(qwTSF) ++ ;
+	if ((~uLowNextTBTT) < uLowRemain)
+		qwTSF = ((qwTSF >> 32) + 1) << 32;
 
-    LODWORD(qwTSF) = uLowNextTBTT + uLowRemain;
+	qwTSF = (qwTSF & 0xffffffff00000000U) |
+		(u64)(uLowNextTBTT + uLowRemain);
 
     return (qwTSF);
 }
@@ -837,28 +820,22 @@ void CARDvSetFirstNextTBTT(void *pDeviceHandler, WORD wBeaconInterval)
 {
 
     PSDevice        pDevice = (PSDevice) pDeviceHandler;
-    QWORD           qwNextTBTT;
-    DWORD           dwLoTBTT,dwHiTBTT;
-    BYTE            pbyData[8];
+	u64 qwNextTBTT = 0;
+	BYTE            pbyData[8];
 
-    HIDWORD(qwNextTBTT) = 0;
-    LODWORD(qwNextTBTT) = 0;
-    CARDbClearCurrentTSF(pDevice);
+	CARDbClearCurrentTSF(pDevice);
     //CARDbGetCurrentTSF(pDevice, &qwNextTBTT); //Get Local TSF counter
-    qwNextTBTT = CARDqGetNextTBTT(qwNextTBTT, wBeaconInterval);
+	qwNextTBTT = CARDqGetNextTBTT(qwNextTBTT, wBeaconInterval);
     // Set NextTBTT
 
-    dwLoTBTT = LODWORD(qwNextTBTT);
-    dwHiTBTT = HIDWORD(qwNextTBTT);
-
-    pbyData[0] = (BYTE)dwLoTBTT;
-    pbyData[1] = (BYTE)(dwLoTBTT>>8);
-    pbyData[2] = (BYTE)(dwLoTBTT>>16);
-    pbyData[3] = (BYTE)(dwLoTBTT>>24);
-    pbyData[4] = (BYTE)dwHiTBTT;
-    pbyData[5] = (BYTE)(dwHiTBTT>>8);
-    pbyData[6] = (BYTE)(dwHiTBTT>>16);
-    pbyData[7] = (BYTE)(dwHiTBTT>>24);
+	pbyData[0] = (u8)qwNextTBTT;
+	pbyData[1] = (u8)(qwNextTBTT >> 8);
+	pbyData[2] = (u8)(qwNextTBTT >> 16);
+	pbyData[3] = (u8)(qwNextTBTT >> 24);
+	pbyData[4] = (u8)(qwNextTBTT >> 32);
+	pbyData[5] = (u8)(qwNextTBTT >> 40);
+	pbyData[6] = (u8)(qwNextTBTT >> 48);
+	pbyData[7] = (u8)(qwNextTBTT >> 56);
 
     CONTROLnsRequestOut(pDevice,
                         MESSAGE_TYPE_SET_TSFTBTT,
@@ -887,27 +864,24 @@ void CARDvSetFirstNextTBTT(void *pDeviceHandler, WORD wBeaconInterval)
  * Return Value: none
  *
  */
-void CARDvUpdateNextTBTT(void *pDeviceHandler, QWORD qwTSF,
+void CARDvUpdateNextTBTT(void *pDeviceHandler, u64 qwTSF,
 			 WORD wBeaconInterval)
 {
     PSDevice        pDevice = (PSDevice) pDeviceHandler;
-    DWORD           dwLoTBTT,dwHiTBTT;
     BYTE            pbyData[8];
 
     qwTSF = CARDqGetNextTBTT(qwTSF, wBeaconInterval);
 
     // Set NextTBTT
-    dwLoTBTT = LODWORD(qwTSF);
-    dwHiTBTT = HIDWORD(qwTSF);
-
-    pbyData[0] = (BYTE)dwLoTBTT;
-    pbyData[1] = (BYTE)(dwLoTBTT>>8);
-    pbyData[2] = (BYTE)(dwLoTBTT>>16);
-    pbyData[3] = (BYTE)(dwLoTBTT>>24);
-    pbyData[4] = (BYTE)dwHiTBTT;
-    pbyData[5] = (BYTE)(dwHiTBTT>>8);
-    pbyData[6] = (BYTE)(dwHiTBTT>>16);
-    pbyData[7] = (BYTE)(dwHiTBTT>>24);
+
+	pbyData[0] = (u8)qwTSF;
+	pbyData[1] = (u8)(qwTSF >> 8);
+	pbyData[2] = (u8)(qwTSF >> 16);
+	pbyData[3] = (u8)(qwTSF >> 24);
+	pbyData[4] = (u8)(qwTSF >> 32);
+	pbyData[5] = (u8)(qwTSF >> 40);
+	pbyData[6] = (u8)(qwTSF >> 48);
+	pbyData[7] = (u8)(qwTSF >> 56);
 
     CONTROLnsRequestOut(pDevice,
                         MESSAGE_TYPE_SET_TSFTBTT,
@@ -918,7 +892,8 @@ void CARDvUpdateNextTBTT(void *pDeviceHandler, QWORD qwTSF,
                         );
 

-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Card:Update Next TBTT[%8xh:%8xh] \n",(int)HIDWORD(qwTSF), (int)LODWORD(qwTSF));
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+		"Card:Update Next TBTT[%8lx]\n", (unsigned long)qwTSF);
 
     return;
 }
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 55962b1..1059467 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -67,14 +67,14 @@ void CARDvUpdateBasicTopRate(void *pDeviceHandler);
 void CARDbAddBasicRate(void *pDeviceHandler, WORD wRateIdx);
 BOOL CARDbIsOFDMinBasicRate(void *pDeviceHandler);
 void CARDvAdjustTSF(void *pDeviceHandler, BYTE byRxRate,
-		    QWORD qwBSSTimestamp, QWORD qwLocalTSF);
-BOOL CARDbGetCurrentTSF(void *pDeviceHandler, PQWORD pqwCurrTSF);
+		u64 qwBSSTimestamp, u64 qwLocalTSF);
+BOOL CARDbGetCurrentTSF(void *pDeviceHandler, u64 *pqwCurrTSF);
 BOOL CARDbClearCurrentTSF(void *pDeviceHandler);
 void CARDvSetFirstNextTBTT(void *pDeviceHandler, WORD wBeaconInterval);
-void CARDvUpdateNextTBTT(void *pDeviceHandler, QWORD qwTSF,
+void CARDvUpdateNextTBTT(void *pDeviceHandler, u64 qwTSF,
 			 WORD wBeaconInterval);
-QWORD CARDqGetNextTBTT(QWORD qwTSF, WORD wBeaconInterval);
-QWORD CARDqGetTSFOffset(BYTE byRxRate, QWORD qwTSF1, QWORD qwTSF2);
+u64 CARDqGetNextTBTT(u64 qwTSF, WORD wBeaconInterval);
+u64 CARDqGetTSFOffset(BYTE byRxRate, u64 qwTSF1, u64 qwTSF2);
 BOOL CARDbRadioPowerOff(void *pDeviceHandler);
 BOOL CARDbRadioPowerOn(void *pDeviceHandler);
 BYTE CARDbyGetPktType(void *pDeviceHandler);
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 25bf03a..047f550 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -527,7 +527,7 @@ typedef struct __device_info {
     // 802.11 management
     SMgmtObject                 sMgmtObj;
 
-    QWORD                       qwCurrTSF;
+	u64 qwCurrTSF;
     unsigned int                        cbBulkInMax;
     BOOL                        bPSRxBeacon;
 
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index e94f6a1..8f21bc7 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -328,7 +328,7 @@ RXbBulkInProcessData (
     PBYTE           pbyRsr;
     PBYTE           pbyNewRsr;
     PBYTE           pbyRSSI;
-    PQWORD          pqwTSFTime;
+	u64 *pqwTSFTime;
     PBYTE           pbyFrame;
     BOOL            bDeFragRx = FALSE;
     unsigned int            cbHeaderOffset;
@@ -411,7 +411,7 @@ RXbBulkInProcessData (
 
     wPLCPwithPadding = ( (*pwPLCP_Length / 4) + ( (*pwPLCP_Length % 4) ? 1:0 ) ) *4;
 
-    pqwTSFTime = (PQWORD) (pbyDAddress + 8 + wPLCPwithPadding);
+	pqwTSFTime = (u64 *)(pbyDAddress + 8 + wPLCPwithPadding);
   if(pDevice->byBBType == BB_TYPE_11G)  {
       pby3SQ = pbyDAddress + 8 + wPLCPwithPadding + 12;
       pbySQ = pby3SQ;
@@ -598,8 +598,7 @@ RXbBulkInProcessData (
             pRxPacket->cbMPDULen = FrameSize;
             pRxPacket->uRSSI = *pbyRSSI;
             pRxPacket->bySQ = *pbySQ;
-            HIDWORD(pRxPacket->qwLocalTSF) = cpu_to_le32(HIDWORD(*pqwTSFTime));
-            LODWORD(pRxPacket->qwLocalTSF) = cpu_to_le32(LODWORD(*pqwTSFTime));
+		pRxPacket->qwLocalTSF = cpu_to_le64(*pqwTSFTime);
             if (bIsWEP) {
                 // strip IV
                 pbyData1 = WLAN_HDR_A3_DATA_PTR(pbyFrame);
@@ -910,7 +909,7 @@ RXbBulkInProcessData (
             RSC = dwRxTSC47_16;
             RSC <<= 16;
             RSC += wRxTSC15_0;
-            memcpy(&(pKey->KeyRSC), &RSC,  sizeof(QWORD));
+		memcpy(&(pKey->KeyRSC), &RSC,  sizeof(u64));
 
             if ( (pDevice->sMgmtObj.eCurrMode == WMAC_MODE_ESS_STA) &&
                  (pDevice->sMgmtObj.eCurrState == WMAC_STATE_ASSOC)) {
diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index 26a7d0e..3322855 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -512,14 +512,12 @@ static int hostap_set_encryption(PSDevice pDevice,
         } else {
             // 8021x enable, individual key
             dwKeyIndex |= (1 << 30); // set pairwise key
-            if (KeybSetKey(pDevice,
-                           &(pDevice->sKey),
-                           &param->sta_addr[0],
-                           dwKeyIndex & ~(USE_KEYRSC),
-                           param->u.crypt.key_len,
-                           (PQWORD) &(KeyRSC),
-                           (PBYTE)abyKey,
-                            KEY_CTL_WEP
+		if (KeybSetKey(pDevice, &(pDevice->sKey),
+			&param->sta_addr[0],
+			dwKeyIndex & ~(USE_KEYRSC),
+			param->u.crypt.key_len,
+			&KeyRSC, (PBYTE)abyKey,
+			KEY_CTL_WEP
                            ) == TRUE) {
 

@@ -574,7 +572,7 @@ static int hostap_set_encryption(PSDevice pDevice,
                            &(pDevice->sKey),
                            dwKeyIndex,
                            param->u.crypt.key_len,
-                           (PQWORD) &(KeyRSC),
+			&KeyRSC,
                            abyKey,
                            byKeyDecMode
                           );
@@ -587,7 +585,7 @@ static int hostap_set_encryption(PSDevice pDevice,
                        &param->sta_addr[0],
                        dwKeyIndex,
                        param->u.crypt.key_len,
-                       (PQWORD) &(KeyRSC),
+			&KeyRSC,
                        (PBYTE)abyKey,
                         byKeyDecMode
                        ) == TRUE) {
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index bba31ca..7718ac2 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -179,8 +179,7 @@ void INTnsProcessData(PSDevice pDevice)
 							NULL);
 			}
 		}
-		LODWORD(pDevice->qwCurrTSF) = pINTData->dwLoTSF;
-		HIDWORD(pDevice->qwCurrTSF) = pINTData->dwHiTSF;
+		pDevice->qwCurrTSF = cpu_to_le64(pINTData->qwTSF);
 		/*DBG_PRN_GRP01(("ISR0 = %02x ,
 		  LoTsf =  %08x,
 		  HiTsf =  %08x\n",
diff --git a/drivers/staging/vt6656/int.h b/drivers/staging/vt6656/int.h
index 5d8faf9..ffc243f 100644
--- a/drivers/staging/vt6656/int.h
+++ b/drivers/staging/vt6656/int.h
@@ -48,8 +48,7 @@ typedef struct tagSINTData {
 	BYTE byTSR3;
 	BYTE byPkt3;
 	WORD wTime3;
-	u32 dwLoTSF;
-	u32 dwHiTSF;
+	u64 qwTSF;
 	BYTE byISR0;
 	BYTE byISR1;
 	BYTE byRTSSuccess;
diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index 8c78b86..6f6a219 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -224,7 +224,7 @@ BOOL KeybSetKey(
     PBYTE           pbyBSSID,
     DWORD           dwKeyIndex,
 	u32 uKeyLength,
-    PQWORD          pKeyRSC,
+	u64 *KeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
     )
@@ -286,13 +286,11 @@ BOOL KeybSetKey(
             }
             MACvSetKeyEntry(pDevice, pTable->KeyTable[i].wKeyCtl, i, uKeyIdx, pbyBSSID, (PDWORD)pKey->abyKey);
 
-            if ((dwKeyIndex & USE_KEYRSC) == 0) {
-                // RSC set by NIC
-		    memset(&(pKey->KeyRSC), 0, sizeof(QWORD));
-            }
-            else {
-                memcpy(&(pKey->KeyRSC), pKeyRSC,  sizeof(QWORD));
-            }
+		if ((dwKeyIndex & USE_KEYRSC) == 0)
+			pKey->KeyRSC = 0; /* RSC set by NIC */
+		else
+			pKey->KeyRSC = *KeyRSC;
+
             pKey->dwTSC47_16 = 0;
             pKey->wTSC15_0 = 0;
 
@@ -356,13 +354,11 @@ BOOL KeybSetKey(
         }
         MACvSetKeyEntry(pDevice, pTable->KeyTable[j].wKeyCtl, j, uKeyIdx, pbyBSSID, (PDWORD)pKey->abyKey);
 
-        if ((dwKeyIndex & USE_KEYRSC) == 0) {
-            // RSC set by NIC
-		memset(&(pKey->KeyRSC), 0, sizeof(QWORD));
-        }
-        else {
-            memcpy(&(pKey->KeyRSC), pKeyRSC,  sizeof(QWORD));
-        }
+		if ((dwKeyIndex & USE_KEYRSC) == 0)
+			pKey->KeyRSC = 0; /* RSC set by NIC */
+		else
+			pKey->KeyRSC = *KeyRSC;
+
         pKey->dwTSC47_16 = 0;
         pKey->wTSC15_0 = 0;
 
@@ -676,7 +672,7 @@ BOOL KeybSetDefaultKey(
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
 	u32 uKeyLength,
-    PQWORD          pKeyRSC,
+	u64 *KeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
     )
@@ -742,12 +738,12 @@ BOOL KeybSetDefaultKey(
 
     MACvSetKeyEntry(pDevice, pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl, MAX_KEY_TABLE-1, uKeyIdx, pTable->KeyTable[MAX_KEY_TABLE-1].abyBSSID, (PDWORD) pKey->abyKey);
 
-    if ((dwKeyIndex & USE_KEYRSC) == 0) {
-        // RSC set by NIC
-	    memset(&(pKey->KeyRSC), 0, sizeof(QWORD));
-    } else {
-        memcpy(&(pKey->KeyRSC), pKeyRSC,  sizeof(QWORD));
-    }
+		if ((dwKeyIndex & USE_KEYRSC) == 0)
+			pKey->KeyRSC = 0; /* RSC set by NIC */
+		else
+			pKey->KeyRSC = *KeyRSC;
+
+
     pKey->dwTSC47_16 = 0;
     pKey->wTSC15_0 = 0;
 
@@ -792,7 +788,7 @@ BOOL KeybSetAllGroupKey(
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
 	u32 uKeyLength,
-    PQWORD          pKeyRSC,
+	u64 *KeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
     )
@@ -847,13 +843,11 @@ BOOL KeybSetAllGroupKey(
 
             MACvSetKeyEntry(pDevice, pTable->KeyTable[i].wKeyCtl, i, uKeyIdx, pTable->KeyTable[i].abyBSSID, (PDWORD) pKey->abyKey);
 
-            if ((dwKeyIndex & USE_KEYRSC) == 0) {
-                // RSC set by NIC
-		    memset(&(pKey->KeyRSC), 0, sizeof(QWORD));
-            }
-            else {
-                memcpy(&(pKey->KeyRSC), pKeyRSC,  sizeof(QWORD));
-            }
+		if ((dwKeyIndex & USE_KEYRSC) == 0)
+			pKey->KeyRSC = 0; /* RSC set by NIC */
+		else
+			pKey->KeyRSC = *KeyRSC;
+
             pKey->dwTSC47_16 = 0;
             pKey->wTSC15_0 = 0;
 
diff --git a/drivers/staging/vt6656/key.h b/drivers/staging/vt6656/key.h
index bd35d39..863db7c 100644
--- a/drivers/staging/vt6656/key.h
+++ b/drivers/staging/vt6656/key.h
@@ -60,7 +60,7 @@ typedef struct tagSKeyItem
     BOOL        bKeyValid;
 	u32 uKeyLength;
     BYTE        abyKey[MAX_KEY_LEN];
-    QWORD       KeyRSC;
+	u64 KeyRSC;
     DWORD       dwTSC47_16;
     WORD        wTSC15_0;
     BYTE        byCipherSuite;
@@ -108,7 +108,7 @@ BOOL KeybSetKey(
     PBYTE           pbyBSSID,
     DWORD           dwKeyIndex,
 	u32 uKeyLength,
-    PQWORD          pKeyRSC,
+	u64 *KeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
     );
@@ -147,7 +147,7 @@ BOOL KeybSetDefaultKey(
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
 	u32 uKeyLength,
-    PQWORD          pKeyRSC,
+	u64 *KeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
     );
@@ -157,7 +157,7 @@ BOOL KeybSetAllGroupKey(
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
 	u32 uKeyLength,
-    PQWORD          pKeyRSC,
+	u64 *KeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
     );
diff --git a/drivers/staging/vt6656/ttype.h b/drivers/staging/vt6656/ttype.h
index dfbf747..89ab494 100644
--- a/drivers/staging/vt6656/ttype.h
+++ b/drivers/staging/vt6656/ttype.h
@@ -48,18 +48,6 @@ typedef u8 BYTE;
 typedef u16 WORD;
 typedef u32 DWORD;
 
-// QWORD is for those situation that we want
-// an 8-byte-aligned 8 byte long structure
-// which is NOT really a floating point number.
-typedef union tagUQuadWord {
-    struct {
-	u32 dwLowDword;
-	u32 dwHighDword;
-    } u;
-    double      DoNotUseThisField;
-} UQuadWord;
-typedef UQuadWord       QWORD;          // 64-bit
-
 /****** Common pointer types ***********************************************/
 
 typedef u32 ULONG_PTR;
@@ -73,6 +61,4 @@ typedef WORD *           PWORD;
 
 typedef DWORD *          PDWORD;
 
-typedef QWORD *          PQWORD;
-
 #endif /* __TTYPE_H__ */
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 95ddc83..7a242f7 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -1740,7 +1740,7 @@ s_vMgrRxBeacon(
 
     PKnownBSS           pBSSList;
     WLAN_FR_BEACON      sFrame;
-    QWORD               qwTSFOffset;
+	u64 qwTSFOffset;
     BOOL                bIsBSSIDEqual = FALSE;
     BOOL                bIsSSIDEqual = FALSE;
     BOOL                bTSFLargeDiff = FALSE;
@@ -1752,8 +1752,8 @@ s_vMgrRxBeacon(
     BYTE                byTIMBitOn = 0;
     WORD                wAIDNumber = 0;
     unsigned int                uNodeIndex;
-    QWORD               qwTimestamp, qwLocalTSF;
-    QWORD               qwCurrTSF;
+	u64 qwTimestamp, qwLocalTSF;
+	u64 qwCurrTSF;
     WORD                wStartIndex = 0;
     WORD                wAIDIndex = 0;
     BYTE                byCurrChannel = pRxPacket->byRxChannel;
@@ -2013,26 +2013,14 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
         }
     }
 
-    HIDWORD(qwTimestamp) = cpu_to_le32(HIDWORD(*sFrame.pqwTimestamp));
-    LODWORD(qwTimestamp) = cpu_to_le32(LODWORD(*sFrame.pqwTimestamp));
-    HIDWORD(qwLocalTSF) = HIDWORD(pRxPacket->qwLocalTSF);
-    LODWORD(qwLocalTSF) = LODWORD(pRxPacket->qwLocalTSF);
+	qwTimestamp = cpu_to_le64(*sFrame.pqwTimestamp);
+	qwLocalTSF = pRxPacket->qwLocalTSF;
 
     // check if beacon TSF larger or small than our local TSF
-    if (HIDWORD(qwTimestamp) == HIDWORD(qwLocalTSF)) {
-        if (LODWORD(qwTimestamp) >= LODWORD(qwLocalTSF)) {
-            bTSFOffsetPostive = TRUE;
-        }
-        else {
-            bTSFOffsetPostive = FALSE;
-        }
-    }
-    else if (HIDWORD(qwTimestamp) > HIDWORD(qwLocalTSF)) {
-        bTSFOffsetPostive = TRUE;
-    }
-    else if (HIDWORD(qwTimestamp) < HIDWORD(qwLocalTSF)) {
-        bTSFOffsetPostive = FALSE;
-    }
+	if (qwTimestamp >= qwLocalTSF)
+		bTSFOffsetPostive = TRUE;
+	else
+		bTSFOffsetPostive = FALSE;
 
     if (bTSFOffsetPostive) {
         qwTSFOffset = CARDqGetTSFOffset(pRxPacket->byRxRate, (qwTimestamp), (qwLocalTSF));
@@ -2041,10 +2029,8 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
         qwTSFOffset = CARDqGetTSFOffset(pRxPacket->byRxRate, (qwLocalTSF), (qwTimestamp));
     }
 
-    if (HIDWORD(qwTSFOffset) != 0 ||
-        (LODWORD(qwTSFOffset) > TRIVIAL_SYNC_DIFFERENCE )) {
-         bTSFLargeDiff = TRUE;
-    }
+	if (qwTSFOffset > TRIVIAL_SYNC_DIFFERENCE)
+		bTSFLargeDiff = TRUE;
 

     // if infra mode
@@ -2265,7 +2251,7 @@ void vMgrCreateOwnIBSS(void *hDeviceContext,
     WORD                wMaxSuppRate;
     BYTE                byTopCCKBasicRate;
     BYTE                byTopOFDMBasicRate;
-    QWORD               qwCurrTSF;
+	u64 qwCurrTSF = 0;
     unsigned int                ii;
     BYTE    abyRATE[] = {0x82, 0x84, 0x8B, 0x96, 0x24, 0x30, 0x48, 0x6C, 0x0C, 0x12, 0x18, 0x60};
     BYTE    abyCCK_RATE[] = {0x82, 0x84, 0x8B, 0x96};
@@ -2274,9 +2260,6 @@ void vMgrCreateOwnIBSS(void *hDeviceContext,
 


-    HIDWORD(qwCurrTSF) = 0;
-    LODWORD(qwCurrTSF) = 0;
-
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Create Basic Service Set .......\n");
 
     if (pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) {
@@ -2420,12 +2403,12 @@ void vMgrCreateOwnIBSS(void *hDeviceContext,
     if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
 
         // BSSID selected must be randomized as spec 11.1.3
-        pMgmt->abyCurrBSSID[5] = (BYTE) (LODWORD(qwCurrTSF)& 0x000000ff);
-        pMgmt->abyCurrBSSID[4] = (BYTE)((LODWORD(qwCurrTSF)& 0x0000ff00) >> 8);
-        pMgmt->abyCurrBSSID[3] = (BYTE)((LODWORD(qwCurrTSF)& 0x00ff0000) >> 16);
-        pMgmt->abyCurrBSSID[2] = (BYTE)((LODWORD(qwCurrTSF)& 0x00000ff0) >> 4);
-        pMgmt->abyCurrBSSID[1] = (BYTE)((LODWORD(qwCurrTSF)& 0x000ff000) >> 12);
-        pMgmt->abyCurrBSSID[0] = (BYTE)((LODWORD(qwCurrTSF)& 0x0ff00000) >> 20);
+	pMgmt->abyCurrBSSID[5] = (u8)(qwCurrTSF & 0x000000ff);
+	pMgmt->abyCurrBSSID[4] = (u8)((qwCurrTSF & 0x0000ff00) >> 8);
+	pMgmt->abyCurrBSSID[3] = (u8)((qwCurrTSF & 0x00ff0000) >> 16);
+	pMgmt->abyCurrBSSID[2] = (u8)((qwCurrTSF & 0x00000ff0) >> 4);
+	pMgmt->abyCurrBSSID[1] = (u8)((qwCurrTSF & 0x000ff000) >> 12);
+	pMgmt->abyCurrBSSID[0] = (u8)((qwCurrTSF & 0x0ff00000) >> 20);
         pMgmt->abyCurrBSSID[5] ^= pMgmt->abyMACAddr[0];
         pMgmt->abyCurrBSSID[4] ^= pMgmt->abyMACAddr[1];
         pMgmt->abyCurrBSSID[3] ^= pMgmt->abyMACAddr[2];
diff --git a/drivers/staging/vt6656/wmgr.h b/drivers/staging/vt6656/wmgr.h
index 52b1b56..876c352 100644
--- a/drivers/staging/vt6656/wmgr.h
+++ b/drivers/staging/vt6656/wmgr.h
@@ -232,7 +232,7 @@ typedef struct tagSTxMgmtPacket {
 typedef struct tagSRxMgmtPacket {
 
     PUWLAN_80211HDR     p80211Header;
-    QWORD               qwLocalTSF;
+	u64 qwLocalTSF;
     unsigned int                cbMPDULen;
     unsigned int                cbPayloadLen;
     unsigned int                uRSSI;
diff --git a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpactl.c
index cc1d48b..3afbb61 100644
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -74,7 +74,7 @@ int wpa_set_keys(PSDevice pDevice, void *ctx)
 	DWORD dwKeyIndex = 0;
 	BYTE abyKey[MAX_KEY_LEN];
 	BYTE abySeq[MAX_KEY_LEN];
-	QWORD KeyRSC;
+	u64 KeyRSC;
 	BYTE byKeyDecMode = KEY_CTL_WEP;
 	int ret = 0;
 	int uu;
@@ -136,9 +136,9 @@ int wpa_set_keys(PSDevice pDevice, void *ctx)
 	if (param->u.wpa_key.seq_len > 0) {
 		for (ii = 0 ; ii < param->u.wpa_key.seq_len ; ii++) {
 			if (ii < 4)
-				LODWORD(KeyRSC) |= (abySeq[ii] << (ii * 8));
+				KeyRSC |= (abySeq[ii] << (ii * 8));
 			else
-				HIDWORD(KeyRSC) |= (abySeq[ii] << ((ii-4) * 8));
+				KeyRSC |= (abySeq[ii] << ((ii-4) * 8));
 		}
 		dwKeyIndex |= 1 << 29;
 	}
@@ -203,7 +203,7 @@ int wpa_set_keys(PSDevice pDevice, void *ctx)
 
 		if ((KeybSetAllGroupKey(pDevice, &(pDevice->sKey), dwKeyIndex,
 							param->u.wpa_key.key_len,
-							(PQWORD) &(KeyRSC),
+							&KeyRSC,
 							(PBYTE)abyKey,
 							byKeyDecMode
 					) == TRUE) &&
@@ -211,7 +211,7 @@ int wpa_set_keys(PSDevice pDevice, void *ctx)
 					&(pDevice->sKey),
 					dwKeyIndex,
 					param->u.wpa_key.key_len,
-					(PQWORD) &(KeyRSC),
+					&KeyRSC,
 					(PBYTE)abyKey,
 					byKeyDecMode
 				) == TRUE) ) {
@@ -234,7 +234,7 @@ int wpa_set_keys(PSDevice pDevice, void *ctx)
 		}
 		if (KeybSetKey(pDevice, &(pDevice->sKey), &param->addr[0],
 				dwKeyIndex, param->u.wpa_key.key_len,
-				(PQWORD) &(KeyRSC), (PBYTE)abyKey, byKeyDecMode
+				&KeyRSC, (PBYTE)abyKey, byKeyDecMode
 				) == TRUE) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pairwise Key Set\n");
 		} else {
-- 
1.7.10.4



