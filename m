Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:53923 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaHJOr5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2014 10:47:57 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so3056435wiw.12
        for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2014 07:47:55 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/9] staging: vt6655: card change PSDevice to struct vnt_private
Date: Sun, 10 Aug 2014 15:46:57 +0100
Message-Id: <1407682023-2865-3-git-send-email-tvboxspy@gmail.com> (sfid-20140810_164919_894172_274EC575)
In-Reply-To: <1407682023-2865-1-git-send-email-tvboxspy@gmail.com>
References: <1407682023-2865-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Repacing void *pDeviceHandler

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c | 111 ++++++++++++++++--------------------------
 drivers/staging/vt6655/card.h |  83 ++++++++++++++++---------------
 2 files changed, 84 insertions(+), 110 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 931fca8..633585f 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -224,7 +224,8 @@ s_vCalculateOFDMRParameter(
  */
 static
 void
-s_vSetRSPINF(PSDevice pDevice, CARD_PHY_TYPE ePHYType, void *pvSupportRateIEs, void *pvExtSupportRateIEs)
+s_vSetRSPINF(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
+	     void *pvSupportRateIEs, void *pvExtSupportRateIEs)
 {
 	unsigned char byServ = 0, bySignal = 0; // For CCK
 	unsigned short wLen = 0;
@@ -348,9 +349,8 @@ s_vSetRSPINF(PSDevice pDevice, CARD_PHY_TYPE ePHYType, void *pvSupportRateIEs, v
  * Return Value: true if short preamble; otherwise false
  *
  */
-bool CARDbIsShortPreamble(void *pDeviceHandler)
+bool CARDbIsShortPreamble(struct vnt_private *pDevice)
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 
 	if (pDevice->byPreambleType == 0)
 		return false;
@@ -370,9 +370,8 @@ bool CARDbIsShortPreamble(void *pDeviceHandler)
  * Return Value: true if short slot time; otherwise false
  *
  */
-bool CARDbIsShorSlotTime(void *pDeviceHandler)
+bool CARDbIsShorSlotTime(struct vnt_private *pDevice)
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 
 	return pDevice->bShortSlotTime;
 }
@@ -389,9 +388,10 @@ bool CARDbIsShorSlotTime(void *pDeviceHandler)
  * Return Value: None.
  *
  */
-bool CARDbSetPhyParameter(void *pDeviceHandler, CARD_PHY_TYPE ePHYType, unsigned short wCapInfo, unsigned char byERPField, void *pvSupportRateIEs, void *pvExtSupportRateIEs)
+bool CARDbSetPhyParameter(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
+			  unsigned short wCapInfo, unsigned char byERPField,
+			  void *pvSupportRateIEs, void *pvExtSupportRateIEs)
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 	unsigned char byCWMaxMin = 0;
 	unsigned char bySlot = 0;
 	unsigned char bySIFS = 0;
@@ -573,9 +573,9 @@ bool CARDbSetPhyParameter(void *pDeviceHandler, CARD_PHY_TYPE ePHYType, unsigned
  * Return Value: none
  *
  */
-bool CARDbUpdateTSF(void *pDeviceHandler, unsigned char byRxRate, u64 qwBSSTimestamp, u64 qwLocalTSF)
+bool CARDbUpdateTSF(struct vnt_private *pDevice, unsigned char byRxRate,
+		    u64 qwBSSTimestamp, u64 qwLocalTSF)
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 	u64 qwTSFOffset = 0;
 
 	if (qwBSSTimestamp != qwLocalTSF) {
@@ -603,9 +603,9 @@ bool CARDbUpdateTSF(void *pDeviceHandler, unsigned char byRxRate, u64 qwBSSTimes
  * Return Value: true if succeed; otherwise false
  *
  */
-bool CARDbSetBeaconPeriod(void *pDeviceHandler, unsigned short wBeaconInterval)
+bool CARDbSetBeaconPeriod(struct vnt_private *pDevice,
+			  unsigned short wBeaconInterval)
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 	u64 qwNextTBTT = 0;
 
 	CARDbGetCurrentTSF(pDevice->PortOffset, &qwNextTBTT); //Get Local TSF counter
@@ -636,9 +636,8 @@ bool CARDbSetBeaconPeriod(void *pDeviceHandler, unsigned short wBeaconInterval)
  * Return Value: true if all data packet complete; otherwise false.
  *
  */
-bool CARDbStopTxPacket(void *pDeviceHandler, CARD_PKT_TYPE ePktType)
+bool CARDbStopTxPacket(struct vnt_private *pDevice, CARD_PKT_TYPE ePktType)
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 
 	if (ePktType == PKT_TYPE_802_11_ALL) {
 		pDevice->bStopBeacon = true;
@@ -690,9 +689,8 @@ bool CARDbStopTxPacket(void *pDeviceHandler, CARD_PKT_TYPE ePktType)
  * Return Value: true if success; false if failed.
  *
  */
-bool CARDbStartTxPacket(void *pDeviceHandler, CARD_PKT_TYPE ePktType)
+bool CARDbStartTxPacket(struct vnt_private *pDevice, CARD_PKT_TYPE ePktType)
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 
 	if (ePktType == PKT_TYPE_802_11_ALL) {
 		pDevice->bStopBeacon = false;
@@ -729,9 +727,9 @@ bool CARDbStartTxPacket(void *pDeviceHandler, CARD_PKT_TYPE ePktType)
  * Return Value: true if success; false if failed.
  *
  */
-bool CARDbSetBSSID(void *pDeviceHandler, unsigned char *pbyBSSID, CARD_OP_MODE eOPMode)
+bool CARDbSetBSSID(struct vnt_private *pDevice,
+		   unsigned char *pbyBSSID, CARD_OP_MODE eOPMode)
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 
 	MACvWriteBSSIDAddress(pDevice->PortOffset, pbyBSSID);
 	memcpy(pDevice->abyBSSID, pbyBSSID, WLAN_BSSID_LEN);
@@ -795,11 +793,10 @@ bool CARDbSetBSSID(void *pDeviceHandler, unsigned char *pbyBSSID, CARD_OP_MODE e
  *
  */
 bool CARDbSetTxDataRate(
-	void *pDeviceHandler,
+	struct vnt_private *pDevice,
 	unsigned short wDataRate
 )
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 
 	pDevice->wCurrentRate = wDataRate;
 	return true;
@@ -821,10 +818,9 @@ bool CARDbSetTxDataRate(
  -*/
 bool
 CARDbPowerDown(
-	void *pDeviceHandler
+	struct vnt_private *pDevice
 )
 {
-	PSDevice        pDevice = (PSDevice)pDeviceHandler;
 	unsigned int uIdx;
 
 	// check if already in Doze mode
@@ -858,9 +854,8 @@ CARDbPowerDown(
  * Return Value: true if success; otherwise false
  *
  */
-bool CARDbRadioPowerOff(void *pDeviceHandler)
+bool CARDbRadioPowerOff(struct vnt_private *pDevice)
 {
-	PSDevice    pDevice = (PSDevice)pDeviceHandler;
 	bool bResult = true;
 
 	if (pDevice->bRadioOff == true)
@@ -904,9 +899,8 @@ bool CARDbRadioPowerOff(void *pDeviceHandler)
  * Return Value: true if success; otherwise false
  *
  */
-bool CARDbRadioPowerOn(void *pDeviceHandler)
+bool CARDbRadioPowerOn(struct vnt_private *pDevice)
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 	bool bResult = true;
 
 	pr_debug("chester power on\n");
@@ -947,9 +941,8 @@ bool CARDbRadioPowerOn(void *pDeviceHandler)
 	return bResult;
 }
 
-bool CARDbRemoveKey(void *pDeviceHandler, unsigned char *pbyBSSID)
+bool CARDbRemoveKey(struct vnt_private *pDevice, unsigned char *pbyBSSID)
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 
 	KeybRemoveAllKey(&(pDevice->sKey), pbyBSSID, pDevice->PortOffset);
 	return true;
@@ -973,13 +966,12 @@ bool CARDbRemoveKey(void *pDeviceHandler, unsigned char *pbyBSSID)
  -*/
 bool
 CARDbAdd_PMKID_Candidate(
-	void *pDeviceHandler,
+	struct vnt_private *pDevice,
 	unsigned char *pbyBSSID,
 	bool bRSNCapExist,
 	unsigned short wRSNCap
 )
 {
-	PSDevice            pDevice = (PSDevice) pDeviceHandler;
 	struct pmkid_candidate *pCandidateList;
 	unsigned int ii = 0;
 
@@ -1023,10 +1015,9 @@ CARDbAdd_PMKID_Candidate(
 
 void *
 CARDpGetCurrentAddress(
-	void *pDeviceHandler
+	struct vnt_private *pDevice
 )
 {
-	PSDevice            pDevice = (PSDevice) pDeviceHandler;
 
 	return pDevice->abyCurrentNetAddr;
 }
@@ -1047,12 +1038,11 @@ CARDpGetCurrentAddress(
  -*/
 bool
 CARDbStartMeasure(
-	void *pDeviceHandler,
+	struct vnt_private *pDevice,
 	void *pvMeasureEIDs,
 	unsigned int uNumOfMeasureEIDs
 )
 {
-	PSDevice                pDevice = (PSDevice) pDeviceHandler;
 	PWLAN_IE_MEASURE_REQ    pEID = (PWLAN_IE_MEASURE_REQ) pvMeasureEIDs;
 	u64 qwCurrTSF;
 	u64 qwStartTSF;
@@ -1163,13 +1153,12 @@ CARDbStartMeasure(
  -*/
 bool
 CARDbChannelSwitch(
-	void *pDeviceHandler,
+	struct vnt_private *pDevice,
 	unsigned char byMode,
 	unsigned char byNewChannel,
 	unsigned char byCount
 )
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 	bool bResult = true;
 
 	if (byCount == 0) {
@@ -1205,7 +1194,7 @@ CARDbChannelSwitch(
  -*/
 bool
 CARDbSetQuiet(
-	void *pDeviceHandler,
+	struct vnt_private *pDevice,
 	bool bResetQuiet,
 	unsigned char byQuietCount,
 	unsigned char byQuietPeriod,
@@ -1213,7 +1202,6 @@ CARDbSetQuiet(
 	unsigned short wQuietOffset
 )
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 	unsigned int ii = 0;
 
 	if (bResetQuiet) {
@@ -1258,10 +1246,9 @@ CARDbSetQuiet(
  -*/
 bool
 CARDbStartQuiet(
-	void *pDeviceHandler
+	struct vnt_private *pDevice
 )
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 	unsigned int ii = 0;
 	unsigned long dwStartTime = 0xFFFFFFFF;
 	unsigned int uCurrentQuietIndex = 0;
@@ -1358,12 +1345,11 @@ CARDbStartQuiet(
  -*/
 void
 CARDvSetPowerConstraint(
-	void *pDeviceHandler,
+	struct vnt_private *pDevice,
 	unsigned char byChannel,
 	char byPower
 )
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 
 	if (byChannel > CB_MAX_CHANNEL_24G) {
 		if (pDevice->bCountryInfo5G == true)
@@ -1392,12 +1378,11 @@ CARDvSetPowerConstraint(
  -*/
 void
 CARDvGetPowerCapability(
-	void *pDeviceHandler,
+	struct vnt_private *pDevice,
 	unsigned char *pbyMinPower,
 	unsigned char *pbyMaxPower
 )
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 	unsigned char byDec = 0;
 
 	*pbyMaxPower = pDevice->abyOFDMDefaultPwr[pDevice->byCurrentCh];
@@ -1427,10 +1412,9 @@ CARDvGetPowerCapability(
  */
 char
 CARDbyGetTransmitPower(
-	void *pDeviceHandler
+	struct vnt_private *pDevice
 )
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 
 	return pDevice->byCurPwrdBm;
 }
@@ -1438,10 +1422,9 @@ CARDbyGetTransmitPower(
 //xxx
 void
 CARDvSafeResetTx(
-	void *pDeviceHandler
+	struct vnt_private *pDevice
 )
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 	unsigned int uu;
 	PSTxDesc    pCurrTD;
 
@@ -1491,10 +1474,9 @@ CARDvSafeResetTx(
  -*/
 void
 CARDvSafeResetRx(
-	void *pDeviceHandler
+	struct vnt_private *pDevice
 )
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 	unsigned int uu;
 	PSRxDesc    pDesc;
 
@@ -1545,9 +1527,9 @@ CARDvSafeResetRx(
  * Return Value: response Control frame rate
  *
  */
-static unsigned short CARDwGetCCKControlRate(void *pDeviceHandler, unsigned short wRateIdx)
+static unsigned short CARDwGetCCKControlRate(struct vnt_private *pDevice,
+					     unsigned short wRateIdx)
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 	unsigned int ui = (unsigned int) wRateIdx;
 
 	while (ui > RATE_1M) {
@@ -1572,9 +1554,9 @@ static unsigned short CARDwGetCCKControlRate(void *pDeviceHandler, unsigned shor
  * Return Value: response Control frame rate
  *
  */
-static unsigned short CARDwGetOFDMControlRate(void *pDeviceHandler, unsigned short wRateIdx)
+static unsigned short CARDwGetOFDMControlRate(struct vnt_private *pDevice,
+					      unsigned short wRateIdx)
 {
-	PSDevice pDevice = (PSDevice) pDeviceHandler;
 	unsigned int ui = (unsigned int) wRateIdx;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BASIC RATE: %X\n", pDevice->wBasicRate);
@@ -1608,9 +1590,8 @@ static unsigned short CARDwGetOFDMControlRate(void *pDeviceHandler, unsigned sho
  * Return Value: None.
  *
  */
-void CARDvSetRSPINF(void *pDeviceHandler, CARD_PHY_TYPE ePHYType)
+void CARDvSetRSPINF(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType)
 {
-	PSDevice pDevice = (PSDevice) pDeviceHandler;
 	unsigned char byServ = 0x00, bySignal = 0x00; //For CCK
 	unsigned short wLen = 0x0000;
 	unsigned char byTxRate, byRsvTime;             //For OFDM
@@ -1733,10 +1714,9 @@ void CARDvSetRSPINF(void *pDeviceHandler, CARD_PHY_TYPE ePHYType)
  * Return Value: None.
  *
  */
-void vUpdateIFS(void *pDeviceHandler)
+void vUpdateIFS(struct vnt_private *pDevice)
 {
-	//Set SIFS, DIFS, EIFS, SlotTime, CwMin
-	PSDevice pDevice = (PSDevice) pDeviceHandler;
+	/* Set SIFS, DIFS, EIFS, SlotTime, CwMin */
 
 	unsigned char byMaxMin = 0;
 
@@ -1785,9 +1765,8 @@ void vUpdateIFS(void *pDeviceHandler)
 	VNSvOutPortB(pDevice->PortOffset + MAC_REG_CWMAXMIN0, (unsigned char)byMaxMin);
 }
 
-void CARDvUpdateBasicTopRate(void *pDeviceHandler)
+void CARDvUpdateBasicTopRate(struct vnt_private *pDevice)
 {
-	PSDevice pDevice = (PSDevice) pDeviceHandler;
 	unsigned char byTopOFDM = RATE_24M, byTopCCK = RATE_1M;
 	unsigned char ii;
 
@@ -1811,9 +1790,8 @@ void CARDvUpdateBasicTopRate(void *pDeviceHandler)
 	pDevice->byTopCCKBasicRate = byTopCCK;
 }
 
-bool CARDbAddBasicRate(void *pDeviceHandler, unsigned short wRateIdx)
+bool CARDbAddBasicRate(struct vnt_private *pDevice, unsigned short wRateIdx)
 {
-	PSDevice pDevice = (PSDevice) pDeviceHandler;
 	unsigned short wRate = (unsigned short)(1<<wRateIdx);
 
 	pDevice->wBasicRate |= wRate;
@@ -1824,9 +1802,8 @@ bool CARDbAddBasicRate(void *pDeviceHandler, unsigned short wRateIdx)
 	return true;
 }
 
-bool CARDbIsOFDMinBasicRate(void *pDeviceHandler)
+bool CARDbIsOFDMinBasicRate(struct vnt_private *pDevice)
 {
-	PSDevice pDevice = (PSDevice)pDeviceHandler;
 	int ii;
 
 	for (ii = RATE_54M; ii >= RATE_6M; ii--) {
@@ -1836,9 +1813,8 @@ bool CARDbIsOFDMinBasicRate(void *pDeviceHandler)
 	return false;
 }
 
-unsigned char CARDbyGetPktType(void *pDeviceHandler)
+unsigned char CARDbyGetPktType(struct vnt_private *pDevice)
 {
-	PSDevice pDevice = (PSDevice) pDeviceHandler;
 
 	if (pDevice->byBBType == BB_TYPE_11A || pDevice->byBBType == BB_TYPE_11B)
 		return (unsigned char)pDevice->byBBType;
@@ -1889,9 +1865,8 @@ void CARDvSetLoopbackMode(void __iomem *dwIoBase, unsigned short wLoopbackMode)
  * Return Value: none
  *
  */
-bool CARDbSoftwareReset(void *pDeviceHandler)
+bool CARDbSoftwareReset(struct vnt_private *pDevice)
 {
-	PSDevice pDevice = (PSDevice) pDeviceHandler;
 
 	// reset MAC
 	if (!MACbSafeSoftwareReset(pDevice->PortOffset))
diff --git a/drivers/staging/vt6655/card.h b/drivers/staging/vt6655/card.h
index 6e3698b..f7fd834 100644
--- a/drivers/staging/vt6655/card.h
+++ b/drivers/staging/vt6655/card.h
@@ -77,49 +77,48 @@ typedef enum _CARD_OP_MODE {
 	OP_MODE_UNKNOWN
 } CARD_OP_MODE, *PCARD_OP_MODE;
 
-void CARDvSetRSPINF(void *pDeviceHandler, CARD_PHY_TYPE ePHYType);
-void vUpdateIFS(void *pDeviceHandler);
-void CARDvUpdateBasicTopRate(void *pDeviceHandler);
-bool CARDbAddBasicRate(void *pDeviceHandler, unsigned short wRateIdx);
-bool CARDbIsOFDMinBasicRate(void *pDeviceHandler);
+struct vnt_private;
+
+void CARDvSetRSPINF(struct vnt_private *, CARD_PHY_TYPE ePHYType);
+void vUpdateIFS(struct vnt_private *);
+void CARDvUpdateBasicTopRate(struct vnt_private *);
+bool CARDbAddBasicRate(struct vnt_private *, unsigned short wRateIdx);
+bool CARDbIsOFDMinBasicRate(struct vnt_private *);
 void CARDvSetLoopbackMode(void __iomem *dwIoBase, unsigned short wLoopbackMode);
-bool CARDbSoftwareReset(void *pDeviceHandler);
+bool CARDbSoftwareReset(struct vnt_private *);
 void CARDvSetFirstNextTBTT(void __iomem *dwIoBase, unsigned short wBeaconInterval);
 void CARDvUpdateNextTBTT(void __iomem *dwIoBase, u64 qwTSF, unsigned short wBeaconInterval);
 bool CARDbGetCurrentTSF(void __iomem *dwIoBase, u64 *pqwCurrTSF);
 u64 CARDqGetNextTBTT(u64 qwTSF, unsigned short wBeaconInterval);
 u64 CARDqGetTSFOffset(unsigned char byRxRate, u64 qwTSF1, u64 qwTSF2);
-bool CARDbSetTxPower(void *pDeviceHandler, unsigned long ulTxPower);
-unsigned char CARDbyGetPktType(void *pDeviceHandler);
-void CARDvSafeResetTx(void *pDeviceHandler);
-void CARDvSafeResetRx(void *pDeviceHandler);
-
-bool CARDbRadioPowerOff(void *pDeviceHandler);
-bool CARDbRadioPowerOn(void *pDeviceHandler);
-bool CARDbIsShortPreamble(void *pDeviceHandler);
-bool CARDbIsShorSlotTime(void *pDeviceHandler);
-bool CARDbSetPhyParameter(void *pDeviceHandler, CARD_PHY_TYPE ePHYType, unsigned short wCapInfo, unsigned char byERPField, void *pvSupportRateIEs, void *pvExtSupportRateIEs);
-bool CARDbUpdateTSF(void *pDeviceHandler, unsigned char byRxRate, u64 qwBSSTimestamp, u64 qwLocalTSF);
-bool CARDbStopTxPacket(void *pDeviceHandler, CARD_PKT_TYPE ePktType);
-bool CARDbStartTxPacket(void *pDeviceHandler, CARD_PKT_TYPE ePktType);
-bool CARDbSetBeaconPeriod(void *pDeviceHandler, unsigned short wBeaconInterval);
-bool CARDbSetBSSID(void *pDeviceHandler, unsigned char *pbyBSSID, CARD_OP_MODE eOPMode);
-
-bool
-CARDbPowerDown(
-	void *pDeviceHandler
-);
-
-bool CARDbSetTxDataRate(
-	void *pDeviceHandler,
-	unsigned short wDataRate
-);
-
-bool CARDbRemoveKey(void *pDeviceHandler, unsigned char *pbyBSSID);
+bool CARDbSetTxPower(struct vnt_private *, unsigned long ulTxPower);
+unsigned char CARDbyGetPktType(struct vnt_private *);
+void CARDvSafeResetTx(struct vnt_private *);
+void CARDvSafeResetRx(struct vnt_private *);
+bool CARDbRadioPowerOff(struct vnt_private *);
+bool CARDbRadioPowerOn(struct vnt_private *);
+bool CARDbIsShortPreamble(struct vnt_private *);
+bool CARDbIsShorSlotTime(struct vnt_private *);
+bool CARDbSetPhyParameter(struct vnt_private *, CARD_PHY_TYPE ePHYType,
+			  unsigned short wCapInfo, unsigned char byERPField,
+			  void *pvSupportRateIEs, void *pvExtSupportRateIEs);
+bool CARDbUpdateTSF(struct vnt_private *, unsigned char byRxRate,
+		    u64 qwBSSTimestamp, u64 qwLocalTSF);
+bool CARDbStopTxPacket(struct vnt_private *, CARD_PKT_TYPE ePktType);
+bool CARDbStartTxPacket(struct vnt_private *, CARD_PKT_TYPE ePktType);
+bool CARDbSetBeaconPeriod(struct vnt_private *, unsigned short wBeaconInterval);
+bool CARDbSetBSSID(struct vnt_private *,
+		   unsigned char *pbyBSSID, CARD_OP_MODE eOPMode);
+
+bool CARDbPowerDown(struct vnt_private *);
+
+bool CARDbSetTxDataRate(struct vnt_private *, unsigned short wDataRate);
+
+bool CARDbRemoveKey(struct vnt_private *, unsigned char *pbyBSSID);
 
 bool
 CARDbAdd_PMKID_Candidate(
-	void *pDeviceHandler,
+	struct vnt_private *,
 	unsigned char *pbyBSSID,
 	bool bRSNCapExist,
 	unsigned short wRSNCap
@@ -127,19 +126,19 @@ CARDbAdd_PMKID_Candidate(
 
 void *
 CARDpGetCurrentAddress(
-	void *pDeviceHandler
+	struct vnt_private *
 );
 
 bool
 CARDbStartMeasure(
-	void *pDeviceHandler,
+	struct vnt_private *,
 	void *pvMeasureEIDs,
 	unsigned int uNumOfMeasureEIDs
 );
 
 bool
 CARDbChannelSwitch(
-	void *pDeviceHandler,
+	struct vnt_private *,
 	unsigned char byMode,
 	unsigned char byNewChannel,
 	unsigned char byCount
@@ -147,7 +146,7 @@ CARDbChannelSwitch(
 
 bool
 CARDbSetQuiet(
-	void *pDeviceHandler,
+	struct vnt_private *,
 	bool bResetQuiet,
 	unsigned char byQuietCount,
 	unsigned char byQuietPeriod,
@@ -157,26 +156,26 @@ CARDbSetQuiet(
 
 bool
 CARDbStartQuiet(
-	void *pDeviceHandler
+	struct vnt_private *
 );
 
 void
 CARDvSetPowerConstraint(
-	void *pDeviceHandler,
+	struct vnt_private *,
 	unsigned char byChannel,
 	char byPower
 );
 
 void
 CARDvGetPowerCapability(
-	void *pDeviceHandler,
+	struct vnt_private *,
 	unsigned char *pbyMinPower,
 	unsigned char *pbyMaxPower
 );
 
 char
 CARDbyGetTransmitPower(
-	void *pDeviceHandler
+	struct vnt_private *
 );
 
 #endif // __CARD_H__
-- 
1.9.1

