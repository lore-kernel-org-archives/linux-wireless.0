Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59240 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab2LJWBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 17:01:33 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1851247eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 14:01:31 -0800 (PST)
Message-ID: <1355176883.4680.17.camel@canaries64> (sfid-20121210_230138_569195_A769D816)
Subject: [PATCH 03/11] staging: vt6656: change baseband/mac/wcmd/wctl to new
 structures.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 10 Dec 2012 22:01:23 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patch also cleans up function declarations, definitions and local variables
were appropriate replacing types defined in "ttype.h" with linux/types.h.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c |  75 +++++++-----------
 drivers/staging/vt6656/baseband.h |  43 +++++------
 drivers/staging/vt6656/mac.c      |  83 ++++++++++----------
 drivers/staging/vt6656/mac.h      |  35 ++++-----
 drivers/staging/vt6656/wcmd.c     | 159 ++++++++++++++------------------------
 drivers/staging/vt6656/wcmd.h     |  12 ++-
 drivers/staging/vt6656/wctl.c     |  12 +--
 drivers/staging/vt6656/wctl.h     |   8 +-
 8 files changed, 179 insertions(+), 248 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 3855015..cccd810 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -690,7 +690,7 @@ s_vClearSQ3Value(PSDevice pDevice);
  *
  */
 unsigned int
-BBuGetFrameTime (
+BBuGetFrameTime(
      BYTE byPreambleType,
      BYTE byPktType,
      unsigned int cbFrameLength,
@@ -756,23 +756,16 @@ BBuGetFrameTime (
  * Return Value: none
  *
  */
-void
-BBvCalculateParameter (
-      PSDevice pDevice,
-      unsigned int cbFrameLength,
-      WORD wRate,
-      BYTE byPacketType,
-     PWORD pwPhyLen,
-     PBYTE pbyPhySrv,
-     PBYTE pbyPhySgn
-    )
+void BBvCalculateParameter(struct vnt_private *pDevice, u32 cbFrameLength,
+	u16 wRate, u8 byPacketType, u16 *pwPhyLen, u8 *pbyPhySrv,
+		u8 *pbyPhySgn)
 {
-    unsigned int cbBitCount;
-    unsigned int cbUsCount = 0;
-    unsigned int cbTmp;
-    BOOL bExtBit;
-    BYTE byPreambleType = pDevice->byPreambleType;
-    BOOL bCCK = pDevice->bCCK;
+	u32 cbBitCount;
+	u32 cbUsCount = 0;
+	u32 cbTmp;
+	int bExtBit;
+	u8 byPreambleType = pDevice->byPreambleType;
+	int bCCK = pDevice->bCCK;
 
     cbBitCount = cbFrameLength * 8;
     bExtBit = FALSE;
@@ -929,8 +922,7 @@ BBvCalculateParameter (
  * Return Value: none
  *
  */
-void
-BBvSetAntennaMode (PSDevice pDevice, BYTE byAntennaMode)
+void BBvSetAntennaMode(struct vnt_private *pDevice, u8 byAntennaMode)
 {
     switch (byAntennaMode) {
         case ANT_TXA:
@@ -968,7 +960,7 @@ BBvSetAntennaMode (PSDevice pDevice, BYTE byAntennaMode)
  *
  */
 
-BOOL BBbVT3184Init(PSDevice pDevice)
+int BBbVT3184Init(struct vnt_private *pDevice)
 {
 	int ntStatus;
     WORD                    wLength;
@@ -1161,7 +1153,7 @@ else {
  * Return Value: none
  *
  */
-void BBvLoopbackOn (PSDevice pDevice)
+void BBvLoopbackOn(struct vnt_private *pDevice)
 {
     BYTE      byData;
 
@@ -1214,9 +1206,9 @@ void BBvLoopbackOn (PSDevice pDevice)
  * Return Value: none
  *
  */
-void BBvLoopbackOff (PSDevice pDevice)
+void BBvLoopbackOff(struct vnt_private *pDevice)
 {
-    BYTE      byData;
+	u8 byData;
 
     ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, pDevice->byBBCRc9);//CR201
     ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0x88, pDevice->byBBCR88);//CR136
@@ -1249,8 +1241,7 @@ void BBvLoopbackOff (PSDevice pDevice)
  * Return Value: none
  *
  */
-void
-BBvSetShortSlotTime (PSDevice pDevice)
+void BBvSetShortSlotTime(struct vnt_private *pDevice)
 {
     BYTE byBBVGA=0;
 
@@ -1267,7 +1258,7 @@ BBvSetShortSlotTime (PSDevice pDevice)
 }
 

-void BBvSetVGAGainOffset(PSDevice pDevice, BYTE byData)
+void BBvSetVGAGainOffset(struct vnt_private *pDevice, BYTE byData)
 {
 
     ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xE7, byData);
@@ -1294,8 +1285,7 @@ void BBvSetVGAGainOffset(PSDevice pDevice, BYTE byData)
  * Return Value: none
  *
  */
-void
-BBvSoftwareReset (PSDevice pDevice)
+void BBvSoftwareReset(struct vnt_private *pDevice)
 {
     ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0x50, 0x40);
     ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0x50, 0);
@@ -1315,22 +1305,20 @@ BBvSoftwareReset (PSDevice pDevice)
  * Return Value: none
  *
  */
-void
-BBvSetDeepSleep (PSDevice pDevice)
+void BBvSetDeepSleep(struct vnt_private *pDevice)
 {
     ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0x0c, 0x17);//CR12
     ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0x0D, 0xB9);//CR13
 }
 
-void
-BBvExitDeepSleep (PSDevice pDevice)
+void BBvExitDeepSleep(struct vnt_private *pDevice)
 {
     ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0x0C, 0x00);//CR12
     ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0x0D, 0x01);//CR13
 }
 

-static unsigned long s_ulGetLowSQ3(PSDevice pDevice)
+static unsigned long s_ulGetLowSQ3(struct vnt_private *pDevice)
 {
 	int ii;
 	unsigned long ulSQ3 = 0;
@@ -1349,7 +1337,7 @@ static unsigned long s_ulGetLowSQ3(PSDevice pDevice)
     return ulSQ3;
 }
 
-static unsigned long s_ulGetRatio(PSDevice pDevice)
+static unsigned long s_ulGetRatio(struct vnt_private *pDevice)
 {
 	int ii, jj;
 	unsigned long ulRatio = 0;
@@ -1377,9 +1365,7 @@ static unsigned long s_ulGetRatio(PSDevice pDevice)
 }
 

-static
-void
-s_vClearSQ3Value (PSDevice pDevice)
+static void s_vClearSQ3Value(struct vnt_private *pDevice)
 {
     int ii;
     pDevice->uDiversityCnt = 0;
@@ -1406,8 +1392,8 @@ s_vClearSQ3Value (PSDevice pDevice)
  *
  */
 
-void
-BBvAntennaDiversity (PSDevice pDevice, BYTE byRxRate, BYTE bySQ3)
+void BBvAntennaDiversity(struct vnt_private *pDevice,
+	u8 byRxRate, u8 bySQ3)
 {
 
     pDevice->uDiversityCnt++;
@@ -1541,9 +1527,8 @@ BBvAntennaDiversity (PSDevice pDevice, BYTE byRxRate, BYTE bySQ3)
  *
 -*/
 
-void TimerSQ3CallBack(void *hDeviceContext)
+void TimerSQ3CallBack(struct vnt_private *pDevice)
 {
-    PSDevice        pDevice = (PSDevice)hDeviceContext;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"TimerSQ3CallBack...");
     spin_lock_irq(&pDevice->lock);
@@ -1579,9 +1564,8 @@ void TimerSQ3CallBack(void *hDeviceContext)
  *
 -*/
 
-void TimerSQ3Tmax3CallBack(void *hDeviceContext)
+void TimerSQ3Tmax3CallBack(struct vnt_private *pDevice)
 {
-    PSDevice        pDevice = (PSDevice)hDeviceContext;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"TimerSQ3Tmax3CallBack...");
     spin_lock_irq(&pDevice->lock);
@@ -1607,10 +1591,7 @@ void TimerSQ3Tmax3CallBack(void *hDeviceContext)
     spin_unlock_irq(&pDevice->lock);
 }
 
-void
-BBvUpdatePreEDThreshold(
-      PSDevice    pDevice,
-      BOOL        bScanning)
+void BBvUpdatePreEDThreshold(struct vnt_private *pDevice, int bScanning)
 {
 

diff --git a/drivers/staging/vt6656/baseband.h b/drivers/staging/vt6656/baseband.h
index 844d5a8..df5cf0d 100644
--- a/drivers/staging/vt6656/baseband.h
+++ b/drivers/staging/vt6656/baseband.h
@@ -104,33 +104,26 @@ BBuGetFrameTime(
      WORD wRate
     );
 
-void BBvCalculateParameter(PSDevice pDevice,
-			  unsigned int cbFrameLength,
-			  WORD wRate,
-			  BYTE byPacketType,
-			  PWORD pwPhyLen,
-			  PBYTE pbyPhySrv,
-			  PBYTE pbyPhySgn);
+void BBvCalculateParameter(struct vnt_private *, u32 cbFrameLength,
+	u16 wRate, u8 byPacketType, u16 *pwPhyLen, u8 *pbyPhySrv,
+	u8 *pbyPhySgn);
 
 // timer for antenna diversity
 
-void TimerSQ3CallBack(void *hDeviceContext);
-void TimerSQ3Tmax3CallBack(void *hDeviceContext);
-
-void BBvAntennaDiversity(PSDevice pDevice, BYTE byRxRate, BYTE bySQ3);
-void BBvLoopbackOn(PSDevice pDevice);
-void BBvLoopbackOff(PSDevice pDevice);
-void BBvSoftwareReset(PSDevice pDevice);
-
-void BBvSetShortSlotTime(PSDevice pDevice);
-void BBvSetVGAGainOffset(PSDevice pDevice, BYTE byData);
-void BBvSetAntennaMode(PSDevice pDevice, BYTE byAntennaMode);
-BOOL BBbVT3184Init(PSDevice pDevice);
-void BBvSetDeepSleep(PSDevice pDevice);
-void BBvExitDeepSleep(PSDevice pDevice);
-void BBvUpdatePreEDThreshold(
-       PSDevice    pDevice,
-       BOOL        bScanning
-     );
+void TimerSQ3CallBack(struct vnt_private *);
+void TimerSQ3Tmax3CallBack(struct vnt_private *);
+
+void BBvAntennaDiversity(struct vnt_private *, u8 byRxRate, u8 bySQ3);
+void BBvLoopbackOn(struct vnt_private *);
+void BBvLoopbackOff(struct vnt_private *);
+void BBvSoftwareReset(struct vnt_private *);
+
+void BBvSetShortSlotTime(struct vnt_private *);
+void BBvSetVGAGainOffset(struct vnt_private *, u8 byData);
+void BBvSetAntennaMode(struct vnt_private *, u8 byAntennaMode);
+int BBbVT3184Init(struct vnt_private *);
+void BBvSetDeepSleep(struct vnt_private *);
+void BBvExitDeepSleep(struct vnt_private *);
+void BBvUpdatePreEDThreshold(struct vnt_private *, int bScanning);
 
 #endif /* __BASEBAND_H__ */
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 8fddc7b..dd732bc 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -68,11 +68,11 @@ static int          msglevel                =MSG_LEVEL_INFO;
  * Return Value: none
  *
  */
-void MACvSetMultiAddrByHash (PSDevice pDevice, BYTE byHashIdx)
+void MACvSetMultiAddrByHash(struct vnt_private *pDevice, u8 byHashIdx)
 {
-    unsigned int            uByteIdx;
-    BYTE            byBitMask;
-    BYTE            pbyData[2];
+	u8 uByteIdx;
+	u8 byBitMask;
+	u8 pbyData[2];
 

     // calculate byte position
@@ -110,9 +110,9 @@ void MACvSetMultiAddrByHash (PSDevice pDevice, BYTE byHashIdx)
  * Return Value: none
  *
  */
-void MACvWriteMultiAddr(PSDevice pDevice, unsigned int uByteIdx, BYTE byData)
+void MACvWriteMultiAddr(struct vnt_private *pDevice, u32 uByteIdx, u8 byData)
 {
-    BYTE            byData1;
+	u8 byData1;
 
     byData1 = byData;
     CONTROLnsRequestOut(pDevice,
@@ -135,7 +135,7 @@ void MACvWriteMultiAddr(PSDevice pDevice, unsigned int uByteIdx, BYTE byData)
  *
  *
  */
-void MACbShutdown(PSDevice pDevice)
+void MACbShutdown(struct vnt_private *pDevice)
 {
     CONTROLnsRequestOutAsyn(pDevice,
                         MESSAGE_TYPE_MACSHUTDOWN,
@@ -146,9 +146,9 @@ void MACbShutdown(PSDevice pDevice)
                         );
 }
 
-void MACvSetBBType(PSDevice pDevice,BYTE byType)
+void MACvSetBBType(struct vnt_private *pDevice, u8 byType)
 {
-BYTE            pbyData[2];
+	u8 pbyData[2];
 

     pbyData[0] = byType;
@@ -163,9 +163,9 @@ BYTE            pbyData[2];
                         );
 }
 
-void MACvSetMISCFifo (PSDevice pDevice, WORD wOffset, DWORD dwData)
+void MACvSetMISCFifo(struct vnt_private *pDevice, u16 wOffset, u32 dwData)
 {
-BYTE    pbyData[4];
+	u8 pbyData[4];
 
     if (wOffset > 273)
         return;
@@ -197,10 +197,10 @@ BYTE    pbyData[4];
  * Return Value: none
  *
  */
-void MACvDisableKeyEntry(PSDevice pDevice, unsigned int uEntryIdx)
+void MACvDisableKeyEntry(struct vnt_private *pDevice, u32 uEntryIdx)
 {
-WORD    wOffset;
-BYTE            byData;
+	u16 wOffset;
+	u8 byData;
 

     byData = (BYTE) uEntryIdx;
@@ -237,15 +237,14 @@ BYTE            byData;
  * Return Value: none
  *
  */
-void MACvSetKeyEntry(PSDevice pDevice, WORD wKeyCtl,
-		     unsigned int uEntryIdx, unsigned int uKeyIdx,
-		     PBYTE pbyAddr, PDWORD pdwKey)
+void MACvSetKeyEntry(struct vnt_private *pDevice, u16 wKeyCtl, u32 uEntryIdx,
+	u32 uKeyIdx, u8 *pbyAddr, u32 *pdwKey)
 {
-PBYTE           pbyKey;
-WORD            wOffset;
-DWORD           dwData1,dwData2;
-int             ii;
-BYTE            pbyData[24];
+	u8 *pbyKey;
+	u16 wOffset;
+	u32 dwData1, dwData2;
+	int ii;
+	u8 pbyData[24];
 
     if ( pDevice->byLocalID <= MAC_REVISION_A1 ) {
         if ( pDevice->sMgmtObj.byCSSPK == KEY_CTL_CCMP )
@@ -321,9 +320,9 @@ BYTE            pbyData[24];
 }
 

-void MACvRegBitsOff(PSDevice pDevice, BYTE byRegOfs, BYTE byBits)
+void MACvRegBitsOff(struct vnt_private *pDevice, u8 byRegOfs, u8 byBits)
 {
-BYTE            pbyData[2];
+	u8 pbyData[2];
 
     pbyData[0] = 0;
     pbyData[1] = byBits;
@@ -338,9 +337,9 @@ BYTE            pbyData[2];
 }
 

-void MACvRegBitsOn(PSDevice pDevice, BYTE byRegOfs, BYTE byBits)
+void MACvRegBitsOn(struct vnt_private *pDevice, u8 byRegOfs, u8 byBits)
 {
-BYTE            pbyData[2];
+	u8 pbyData[2];
 

     pbyData[0] = byBits;
@@ -355,9 +354,9 @@ BYTE            pbyData[2];
                         );
 }
 
-void MACvWriteWord(PSDevice pDevice, BYTE byRegOfs, WORD wData)
+void MACvWriteWord(struct vnt_private *pDevice, u8 byRegOfs, u16 wData)
 {
-BYTE            pbyData[2];
+	u8 pbyData[2];
 

     pbyData[0] = (BYTE)(wData & 0xff);
@@ -373,9 +372,9 @@ BYTE            pbyData[2];
 
 }
 
-void MACvWriteBSSIDAddress(PSDevice pDevice, PBYTE pbyEtherAddr)
+void MACvWriteBSSIDAddress(struct vnt_private *pDevice, u8 *pbyEtherAddr)
 {
-BYTE            pbyData[6];
+	u8 pbyData[6];
 

     pbyData[0] = *((PBYTE)pbyEtherAddr);
@@ -394,9 +393,9 @@ BYTE            pbyData[6];
                         );
 }
 
-void MACvEnableProtectMD(PSDevice pDevice)
+void MACvEnableProtectMD(struct vnt_private *pDevice)
 {
-BYTE            pbyData[2];
+	u8 pbyData[2];
 

     pbyData[0] = EnCFG_ProtectMd;
@@ -411,9 +410,9 @@ BYTE            pbyData[2];
                         );
 }
 
-void MACvDisableProtectMD(PSDevice pDevice)
+void MACvDisableProtectMD(struct vnt_private *pDevice)
 {
-BYTE            pbyData[2];
+	u8 pbyData[2];
 

     pbyData[0] = 0;
@@ -428,9 +427,9 @@ BYTE            pbyData[2];
                         );
 }
 
-void MACvEnableBarkerPreambleMd(PSDevice pDevice)
+void MACvEnableBarkerPreambleMd(struct vnt_private *pDevice)
 {
-BYTE            pbyData[2];
+	u8 pbyData[2];
 

     pbyData[0] = EnCFG_BarkerPream;
@@ -445,9 +444,9 @@ BYTE            pbyData[2];
                         );
 }
 
-void MACvDisableBarkerPreambleMd(PSDevice pDevice)
+void MACvDisableBarkerPreambleMd(struct vnt_private *pDevice)
 {
-BYTE            pbyData[2];
+	u8 pbyData[2];
 

     pbyData[0] = 0;
@@ -463,12 +462,12 @@ BYTE            pbyData[2];
 }
 

-void MACvWriteBeaconInterval(PSDevice pDevice, WORD wInterval)
+void MACvWriteBeaconInterval(struct vnt_private *pDevice, u16 wInterval)
 {
-BYTE            pbyData[2];
+	u8 pbyData[2];
 
-    pbyData[0] = (BYTE) (wInterval & 0xff);
-    pbyData[1] = (BYTE) (wInterval >> 8);
+	pbyData[0] = (u8)(wInterval & 0xff);
+	pbyData[1] = (u8)(wInterval >> 8);
 
     CONTROLnsRequestOut(pDevice,
 			MESSAGE_TYPE_WRITE,
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index 147ac50..6e28500 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -420,24 +420,21 @@
 
 /*---------------------  Export Functions  --------------------------*/
 
-void MACvSetMultiAddrByHash(PSDevice pDevice, BYTE byHashIdx);
-void MACvWriteMultiAddr(PSDevice pDevice, unsigned int uByteIdx, BYTE byData);
-void MACbShutdown(PSDevice pDevice);
-void MACvSetBBType(PSDevice pDevice, BYTE byType);
-void MACvSetMISCFifo(PSDevice pDevice, WORD wOffset, DWORD dwData);
-void MACvDisableKeyEntry(PSDevice pDevice, unsigned int uEntryIdx);
-void MACvSetKeyEntry(PSDevice pDevice, WORD wKeyCtl, unsigned int uEntryIdx,
-		     unsigned int uKeyIdx, PBYTE pbyAddr, PDWORD pdwKey);
-
-void MACvRegBitsOff(PSDevice pDevice, BYTE byRegOfs, BYTE byBits);
-void MACvRegBitsOn(PSDevice pDevice, BYTE byRegOfs, BYTE byBits);
-void MACvWriteWord(PSDevice pDevice, BYTE byRegOfs, WORD wData);
-
-void MACvWriteBSSIDAddress(PSDevice pDevice, PBYTE pbyEtherAddr);
-void MACvEnableProtectMD(PSDevice pDevice);
-void MACvDisableProtectMD(PSDevice pDevice);
-void MACvEnableBarkerPreambleMd(PSDevice pDevice);
-void MACvDisableBarkerPreambleMd(PSDevice pDevice);
-void MACvWriteBeaconInterval(PSDevice pDevice, WORD wInterval);
+void MACvSetMultiAddrByHash(struct vnt_private *, u8);
+void MACvWriteMultiAddr(struct vnt_private *, u32, u8);
+void MACbShutdown(struct vnt_private *);
+void MACvSetBBType(struct vnt_private *, u8);
+void MACvSetMISCFifo(struct vnt_private *pDevice, u16, u32);
+void MACvDisableKeyEntry(struct vnt_private *, u32);
+void MACvSetKeyEntry(struct vnt_private *, u16, u32, u32, u8 *, u32 *);
+void MACvRegBitsOff(struct vnt_private *, u8, u8);
+void MACvRegBitsOn(struct vnt_private *, u8, u8);
+void MACvWriteWord(struct vnt_private *, u8, u16);
+void MACvWriteBSSIDAddress(struct vnt_private *, u8 *);
+void MACvEnableProtectMD(struct vnt_private *);
+void MACvDisableProtectMD(struct vnt_private *);
+void MACvEnableBarkerPreambleMd(struct vnt_private *);
+void MACvDisableBarkerPreambleMd(struct vnt_private *);
+void MACvWriteBeaconInterval(struct vnt_private *, u16);
 
 #endif /* __MAC_H__ */
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 22f6b41..51f48c1 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -68,33 +68,17 @@ static int          msglevel                =MSG_LEVEL_INFO;
 //static int          msglevel                =MSG_LEVEL_DEBUG;
 /*---------------------  Static Functions  --------------------------*/
 
-static
-void
-s_vProbeChannel(
-     PSDevice pDevice
-    );
+static void s_vProbeChannel(struct vnt_private *);
 
+static struct vnt_tx_mgmt *s_MgrMakeProbeRequest(struct vnt_private *,
+	struct vnt_manager *pMgmt, u8 *pScanBSSID, PWLAN_IE_SSID pSSID,
+	PWLAN_IE_SUPP_RATES pCurrRates, PWLAN_IE_SUPP_RATES pCurrExtSuppRates);
 
-static
-PSTxMgmtPacket
-s_MgrMakeProbeRequest(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PBYTE pScanBSSID,
-     PWLAN_IE_SSID pSSID,
-     PWLAN_IE_SUPP_RATES pCurrRates,
-     PWLAN_IE_SUPP_RATES pCurrExtSuppRates
-    );
 
+static int s_bCommandComplete(struct vnt_private *);
 
-static
-BOOL
-s_bCommandComplete (
-    PSDevice pDevice
-    );
 
-
-static BOOL s_bClearBSSID_SCAN(void *hDeviceContext);
+static int s_bClearBSSID_SCAN(struct vnt_private *);
 
 /*---------------------  Export Variables  --------------------------*/
 
@@ -114,13 +98,10 @@ static BOOL s_bClearBSSID_SCAN(void *hDeviceContext);
  *
  */
 
-static
-void
-vAdHocBeaconStop(PSDevice  pDevice)
+static void vAdHocBeaconStop(struct vnt_private *pDevice)
 {
-
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    BOOL            bStop;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	int bStop;
 
     /*
      * temporarily stop Beacon packet for AdHoc Server
@@ -171,11 +152,9 @@ vAdHocBeaconStop(PSDevice  pDevice)
  * Return Value: none
  *
  */
-static
-void
-vAdHocBeaconRestart(PSDevice pDevice)
+static void vAdHocBeaconRestart(struct vnt_private *pDevice)
 {
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 
     /*
      * Restart Beacon packet for AdHoc Server
@@ -204,22 +183,22 @@ vAdHocBeaconRestart(PSDevice pDevice)
  *
 -*/
 
-static
-void
-s_vProbeChannel(
-     PSDevice pDevice
-    )
+static void s_vProbeChannel(struct vnt_private *pDevice)
 {
-                                                     //1M,   2M,   5M,   11M,  18M,  24M,  36M,  54M
-    BYTE abyCurrSuppRatesG[] = {WLAN_EID_SUPP_RATES, 8, 0x02, 0x04, 0x0B, 0x16, 0x24, 0x30, 0x48, 0x6C};
-    BYTE abyCurrExtSuppRatesG[] = {WLAN_EID_EXTSUPP_RATES, 4, 0x0C, 0x12, 0x18, 0x60};
-                                                           //6M,   9M,   12M,  48M
-    BYTE abyCurrSuppRatesA[] = {WLAN_EID_SUPP_RATES, 8, 0x0C, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C};
-    BYTE abyCurrSuppRatesB[] = {WLAN_EID_SUPP_RATES, 4, 0x02, 0x04, 0x0B, 0x16};
-    PBYTE           pbyRate;
-    PSTxMgmtPacket  pTxPacket;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    unsigned int            ii;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	struct vnt_tx_mgmt *pTxPacket;
+	u8 abyCurrSuppRatesG[] = {WLAN_EID_SUPP_RATES,
+			8, 0x02, 0x04, 0x0B, 0x16, 0x24, 0x30, 0x48, 0x6C};
+			/* 1M,   2M,   5M,   11M,  18M,  24M,  36M,  54M*/
+	u8 abyCurrExtSuppRatesG[] = {WLAN_EID_EXTSUPP_RATES,
+			4, 0x0C, 0x12, 0x18, 0x60};
+			/* 6M,   9M,   12M,  48M*/
+	u8 abyCurrSuppRatesA[] = {WLAN_EID_SUPP_RATES,
+			8, 0x0C, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C};
+	u8 abyCurrSuppRatesB[] = {WLAN_EID_SUPP_RATES,
+			4, 0x02, 0x04, 0x0B, 0x16};
+	u8 *pbyRate;
+	int ii;
 

     if (pDevice->byBBType == BB_TYPE_11A) {
@@ -268,24 +247,19 @@ s_vProbeChannel(
 -*/
 

-PSTxMgmtPacket
-s_MgrMakeProbeRequest(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PBYTE pScanBSSID,
-     PWLAN_IE_SSID pSSID,
-     PWLAN_IE_SUPP_RATES pCurrRates,
-     PWLAN_IE_SUPP_RATES pCurrExtSuppRates
-
-    )
+struct vnt_tx_mgmt *s_MgrMakeProbeRequest(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, u8 *pScanBSSID, PWLAN_IE_SSID pSSID,
+	PWLAN_IE_SUPP_RATES pCurrRates, PWLAN_IE_SUPP_RATES pCurrExtSuppRates)
 {
-    PSTxMgmtPacket      pTxPacket = NULL;
-    WLAN_FR_PROBEREQ    sFrame;
+	struct vnt_tx_mgmt *pTxPacket = NULL;
+	WLAN_FR_PROBEREQ sFrame;
 

-    pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
-    memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_PROBEREQ_FR_MAXLEN);
-    pTxPacket->p80211Header = (PUWLAN_80211HDR)((PBYTE)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket = (struct vnt_tx_mgmt *)pMgmt->pbyMgmtPacketPool;
+	memset(pTxPacket, 0, sizeof(struct vnt_tx_mgmt)
+		+ WLAN_PROBEREQ_FR_MAXLEN);
+	pTxPacket->p80211Header = (PUWLAN_80211HDR)((u8 *)pTxPacket
+		+ sizeof(struct vnt_tx_mgmt));
     sFrame.pBuf = (PBYTE)pTxPacket->p80211Header;
     sFrame.len = WLAN_PROBEREQ_FR_MAXLEN;
     vMgrEncodeProbeRequest(&sFrame);
@@ -316,9 +290,8 @@ s_MgrMakeProbeRequest(
     return pTxPacket;
 }
 
-void vCommandTimerWait(void *hDeviceContext, unsigned long MSecond)
+void vCommandTimerWait(struct vnt_private *pDevice, unsigned long MSecond)
 {
-	PSDevice pDevice = (PSDevice)hDeviceContext;
 
 	init_timer(&pDevice->sTimerCommand);
 
@@ -331,18 +304,17 @@ void vCommandTimerWait(void *hDeviceContext, unsigned long MSecond)
 	return;
 }
 
-void vRunCommand(void *hDeviceContext)
+void vRunCommand(struct vnt_private *pDevice)
 {
-    PSDevice        pDevice = (PSDevice)hDeviceContext;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    PWLAN_IE_SSID   pItemSSID;
-    PWLAN_IE_SSID   pItemSSIDCurr;
-    CMD_STATUS      Status;
-    unsigned int            ii;
-    BYTE            byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
-    struct sk_buff  *skb;
-    BYTE            byData;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	PWLAN_IE_SSID pItemSSID;
+	PWLAN_IE_SSID pItemSSIDCurr;
+	CMD_STATUS Status;
+	struct sk_buff  *skb;
 	union iwreq_data wrqu;
+	int ii;
+	u8 byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
+	u8 byData;
 

     if (pDevice->dwDiagRefCount != 0)
@@ -1043,17 +1015,12 @@ void vRunCommand(void *hDeviceContext)
 }
 

-static
-BOOL
-s_bCommandComplete (
-    PSDevice pDevice
-    )
+static int s_bCommandComplete(struct vnt_private *pDevice)
 {
-    PWLAN_IE_SSID pSSID;
-    BOOL          bRadioCmd = FALSE;
-    //WORD          wDeAuthenReason = 0;
-    BOOL          bForceSCAN = TRUE;
-    PSMgmtObject  pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	PWLAN_IE_SSID pSSID;
+	int bRadioCmd = FALSE;
+	int bForceSCAN = TRUE;
 

     pDevice->eCommandState = WLAN_CMD_IDLE;
@@ -1146,18 +1113,15 @@ s_bCommandComplete (
                 break;
 
         }
-	vCommandTimerWait((void *) pDevice, 0);
+	vCommandTimerWait(pDevice, 0);
     }
 
     return TRUE;
 }
 
-BOOL bScheduleCommand(void *hDeviceContext,
-		      CMD_CODE eCommand,
-		      PBYTE pbyItem0)
+int bScheduleCommand(struct vnt_private *pDevice,
+		CMD_CODE eCommand, u8 *pbyItem0)
 {
-    PSDevice        pDevice = (PSDevice)hDeviceContext;
-
 
     if (pDevice->cbFreeCmdQueue == 0) {
         return (FALSE);
@@ -1222,11 +1186,10 @@ BOOL bScheduleCommand(void *hDeviceContext,
  * Return Value: TRUE if success; otherwise FALSE
  *
  */
-static BOOL s_bClearBSSID_SCAN(void *hDeviceContext)
+static int s_bClearBSSID_SCAN(struct vnt_private *pDevice)
 {
-    PSDevice        pDevice = (PSDevice)hDeviceContext;
-    unsigned int            uCmdDequeueIdx = pDevice->uCmdDequeueIdx;
-    unsigned int            ii;
+	unsigned int uCmdDequeueIdx = pDevice->uCmdDequeueIdx;
+	unsigned int ii;
 
     if ((pDevice->cbFreeCmdQueue < CMD_Q_SIZE) && (uCmdDequeueIdx != pDevice->uCmdEnqueueIdx)) {
         for (ii = 0; ii < (CMD_Q_SIZE - pDevice->cbFreeCmdQueue); ii ++) {
@@ -1242,9 +1205,8 @@ static BOOL s_bClearBSSID_SCAN(void *hDeviceContext)
 

 //mike add:reset command timer
-void vResetCommandTimer(void *hDeviceContext)
+void vResetCommandTimer(struct vnt_private *pDevice)
 {
-	PSDevice pDevice = (PSDevice)hDeviceContext;
 
 	//delete timer
 	del_timer(&pDevice->sTimerCommand);
@@ -1261,10 +1223,9 @@ void vResetCommandTimer(void *hDeviceContext)
 	pDevice->bCmdClear = FALSE;
 }
 
-void BSSvSecondTxData(void *hDeviceContext)
+void BSSvSecondTxData(struct vnt_private *pDevice)
 {
-	PSDevice pDevice = (PSDevice)hDeviceContext;
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 
 	pDevice->nTxDataTimeCout++;
 
diff --git a/drivers/staging/vt6656/wcmd.h b/drivers/staging/vt6656/wcmd.h
index d24a79d..a3d0323 100644
--- a/drivers/staging/vt6656/wcmd.h
+++ b/drivers/staging/vt6656/wcmd.h
@@ -28,7 +28,6 @@
 
 #ifndef __WCMD_H__
 #define __WCMD_H__
-
 #include "ttype.h"
 #include "80211hdr.h"
 #include "80211mgr.h"
@@ -112,14 +111,13 @@ typedef enum tagCMD_STATE {
 /*---------------------  Export Types  ------------------------------*/
 
 /*---------------------  Export Functions  --------------------------*/
+struct vnt_private;
 
-void vResetCommandTimer(void *hDeviceContext);
+void vResetCommandTimer(struct vnt_private *);
 
-BOOL bScheduleCommand(void *hDeviceContext,
-		      CMD_CODE eCommand,
-		      PBYTE pbyItem0);
+int bScheduleCommand(struct vnt_private *, CMD_CODE eCommand, u8 *pbyItem0);
 
-void vRunCommand(void *hDeviceContext);
+void vRunCommand(struct vnt_private *);
 
 /*
 void
@@ -128,6 +126,6 @@ WCMDvCommandThread(
     );
 */
 
-void BSSvSecondTxData(void *hDeviceContext);
+void BSSvSecondTxData(struct vnt_private *);
 
 #endif /* __WCMD_H__ */
diff --git a/drivers/staging/vt6656/wctl.c b/drivers/staging/vt6656/wctl.c
index 9249263..18a09a3 100644
--- a/drivers/staging/vt6656/wctl.c
+++ b/drivers/staging/vt6656/wctl.c
@@ -113,7 +113,8 @@ BOOL WCTLbIsDuplicate (PSCache pCache, PS802_11Header pMACHeader)
  *
  */
 
-unsigned int WCTLuSearchDFCB(PSDevice pDevice, PS802_11Header pMACHeader)
+unsigned int WCTLuSearchDFCB(struct vnt_private *pDevice,
+	PS802_11Header pMACHeader)
 {
 	unsigned int ii;
 
@@ -141,7 +142,8 @@ unsigned int WCTLuSearchDFCB(PSDevice pDevice, PS802_11Header pMACHeader)
  * Return Value: index number in Defragment Database
  *
  */
-unsigned int WCTLuInsertDFCB(PSDevice pDevice, PS802_11Header pMACHeader)
+unsigned int WCTLuInsertDFCB(struct vnt_private *pDevice,
+	PS802_11Header pMACHeader)
 {
 	unsigned int ii;
 
@@ -180,10 +182,10 @@ unsigned int WCTLuInsertDFCB(PSDevice pDevice, PS802_11Header pMACHeader)
  * Return Value: TRUE if it is valid fragment packet and we have resource to defragment; otherwise FALSE
  *
  */
-BOOL WCTLbHandleFragment(PSDevice pDevice, PS802_11Header pMACHeader,
-			 unsigned int cbFrameLength, BOOL bWEP, BOOL bExtIV)
+int WCTLbHandleFragment(struct vnt_private *pDevice, PS802_11Header pMACHeader,
+	unsigned int cbFrameLength, int bWEP, int bExtIV)
 {
-unsigned int            uHeaderSize;
+	unsigned int uHeaderSize;
 

     if (bWEP == TRUE) {
diff --git a/drivers/staging/vt6656/wctl.h b/drivers/staging/vt6656/wctl.h
index 7270af6..a509f63 100644
--- a/drivers/staging/vt6656/wctl.h
+++ b/drivers/staging/vt6656/wctl.h
@@ -97,9 +97,9 @@
 /*---------------------  Export Functions  --------------------------*/
 
 BOOL WCTLbIsDuplicate(PSCache pCache, PS802_11Header pMACHeader);
-BOOL WCTLbHandleFragment(PSDevice pDevice, PS802_11Header pMACHeader,
-			 unsigned int cbFrameLength, BOOL bWEP, BOOL bExtIV);
-unsigned int WCTLuSearchDFCB(PSDevice pDevice, PS802_11Header pMACHeader);
-unsigned int WCTLuInsertDFCB(PSDevice pDevice, PS802_11Header pMACHeader);
+int WCTLbHandleFragment(struct vnt_private *, PS802_11Header pMACHeader,
+	unsigned int cbFrameLength, BOOL bWEP, BOOL bExtIV);
+unsigned int WCTLuSearchDFCB(struct vnt_private *, PS802_11Header pMACHeader);
+unsigned int WCTLuInsertDFCB(struct vnt_private *, PS802_11Header pMACHeader);
 
 #endif /* __WCTL_H__ */
-- 
1.8.0




