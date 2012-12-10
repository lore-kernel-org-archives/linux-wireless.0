Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34210 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab2LJWEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 17:04:08 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1852425eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 14:04:05 -0800 (PST)
Message-ID: <1355177036.4680.19.camel@canaries64> (sfid-20121210_230413_805700_941E87E7)
Subject: [PATCH 04/11] staging: vt6656: change wmgr to new structures
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 10 Dec 2012 22:03:56 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patch cleans up function declarations, definitions and local variables
were appropriate replacing types defined in "ttype.h" with linux/types.h.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wmgr.c | 1037 +++++++++++++++--------------------------
 drivers/staging/vt6656/wmgr.h |  101 ++--
 2 files changed, 431 insertions(+), 707 deletions(-)

diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 7a242f7..89491ae 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -93,227 +93,98 @@ static int          msglevel                =MSG_LEVEL_INFO;
 
 /*---------------------  Static Functions  --------------------------*/
 
-static BOOL ChannelExceedZoneType(
-     PSDevice pDevice,
-     BYTE byCurrChannel
-    );
+static int ChannelExceedZoneType(struct vnt_private *, u8 byCurrChannel);
 
-// Association/diassociation functions
-static
-PSTxMgmtPacket
-s_MgrMakeAssocRequest(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PBYTE pDAddr,
-     WORD wCurrCapInfo,
-     WORD wListenInterval,
-     PWLAN_IE_SSID pCurrSSID,
-     PWLAN_IE_SUPP_RATES pCurrRates,
-     PWLAN_IE_SUPP_RATES pCurrExtSuppRates
-    );
+/* Association/diassociation functions */
+static struct vnt_tx_mgmt *s_MgrMakeAssocRequest(struct vnt_private *,
+	struct vnt_manager *pMgmt, u8 *pDAddr, u16 wCurrCapInfo,
+	u16 wListenInterval, PWLAN_IE_SSID pCurrSSID,
+	PWLAN_IE_SUPP_RATES pCurrRates, PWLAN_IE_SUPP_RATES pCurrExtSuppRates);
 
-static
-void
-s_vMgrRxAssocRequest(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PSRxMgmtPacket pRxPacket,
-     unsigned int  uNodeIndex
-    );
+static void s_vMgrRxAssocRequest(struct vnt_private *,
+	struct vnt_manager *pMgmt, struct vnt_rx_mgmt *pRxPacket,
+	u32 uNodeIndex);
 
-static
-PSTxMgmtPacket
-s_MgrMakeReAssocRequest(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PBYTE pDAddr,
-     WORD wCurrCapInfo,
-     WORD wListenInterval,
-     PWLAN_IE_SSID pCurrSSID,
-     PWLAN_IE_SUPP_RATES pCurrRates,
-     PWLAN_IE_SUPP_RATES pCurrExtSuppRates
-    );
+static struct vnt_tx_mgmt *s_MgrMakeReAssocRequest(struct vnt_private *,
+	struct vnt_manager *pMgmt, u8 *pDAddr, u16 wCurrCapInfo,
+	u16 wListenInterval, PWLAN_IE_SSID pCurrSSID,
+	PWLAN_IE_SUPP_RATES pCurrRates, PWLAN_IE_SUPP_RATES pCurrExtSuppRates);
 
-static
-void
-s_vMgrRxAssocResponse(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PSRxMgmtPacket pRxPacket,
-     BOOL bReAssocType
-    );
+static void s_vMgrRxAssocResponse(struct vnt_private *,
+	struct vnt_manager *pMgmt, struct vnt_rx_mgmt *pRxPacket,
+	int bReAssocType);
 
-static
-void
-s_vMgrRxDisassociation(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PSRxMgmtPacket pRxPacket
-    );
+static void s_vMgrRxDisassociation(struct vnt_private *,
+	struct vnt_manager *pMgmt, struct vnt_rx_mgmt *pRxPacket);
 
-// Authentication/deauthen functions
-static
-void
-s_vMgrRxAuthenSequence_1(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PWLAN_FR_AUTHEN pFrame
-    );
+/* Authentication/deauthen functions */
+static void s_vMgrRxAuthenSequence_1(struct vnt_private *,
+	struct vnt_manager *pMgmt, PWLAN_FR_AUTHEN pFrame);
 
-static
-void
-s_vMgrRxAuthenSequence_2(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PWLAN_FR_AUTHEN pFrame
-    );
+static void s_vMgrRxAuthenSequence_2(struct vnt_private *,
+	struct vnt_manager *pMgmt, PWLAN_FR_AUTHEN pFrame);
 
-static
-void
-s_vMgrRxAuthenSequence_3(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PWLAN_FR_AUTHEN pFrame
-    );
+static void s_vMgrRxAuthenSequence_3(struct vnt_private *,
+	struct vnt_manager *pMgmt, PWLAN_FR_AUTHEN pFrame);
 
-static
-void
-s_vMgrRxAuthenSequence_4(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PWLAN_FR_AUTHEN pFrame
-    );
+static void s_vMgrRxAuthenSequence_4(struct vnt_private *,
+	struct vnt_manager *pMgmt, PWLAN_FR_AUTHEN pFrame);
 
-static
-void
-s_vMgrRxAuthentication(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PSRxMgmtPacket pRxPacket
-    );
+static void s_vMgrRxAuthentication(struct vnt_private *,
+	struct vnt_manager *pMgmt, struct vnt_rx_mgmt *pRxPacket);
 
-static
-void
-s_vMgrRxDeauthentication(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PSRxMgmtPacket pRxPacket
-    );
+static void s_vMgrRxDeauthentication(struct vnt_private *,
+	struct vnt_manager *pMgmt, struct vnt_rx_mgmt *pRxPacket);
 
-// Scan functions
-// probe request/response functions
-static
-void
-s_vMgrRxProbeRequest(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PSRxMgmtPacket pRxPacket
-    );
+/* Scan functions
+*  probe request/response functions */
 
-static
-void
-s_vMgrRxProbeResponse(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PSRxMgmtPacket pRxPacket
-    );
+static void s_vMgrRxProbeRequest(struct vnt_private *,
+	struct vnt_manager *pMgmt, struct vnt_rx_mgmt *pRxPacket);
 
-// beacon functions
-static
-void
-s_vMgrRxBeacon(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PSRxMgmtPacket pRxPacket,
-     BOOL bInScan
-    );
+static void s_vMgrRxProbeResponse(struct vnt_private *,
+	struct vnt_manager *pMgmt, struct vnt_rx_mgmt *pRxPacket);
 
-static
-void
-s_vMgrFormatTIM(
-     PSMgmtObject pMgmt,
-     PWLAN_IE_TIM pTIM
-    );
+/* beacon functions */
+static void s_vMgrRxBeacon(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, struct vnt_rx_mgmt *pRxPacket,
+	int bInScan);
 
-static
-PSTxMgmtPacket
-s_MgrMakeBeacon(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     WORD wCurrCapInfo,
-     WORD wCurrBeaconPeriod,
-     unsigned int uCurrChannel,
-     WORD wCurrATIMWinodw,
-     PWLAN_IE_SSID pCurrSSID,
-     PBYTE pCurrBSSID,
-     PWLAN_IE_SUPP_RATES pCurrSuppRates,
-     PWLAN_IE_SUPP_RATES pCurrExtSuppRates
-    );
+static void s_vMgrFormatTIM(struct vnt_manager *pMgmt, PWLAN_IE_TIM pTIM);
 
+static struct vnt_tx_mgmt *s_MgrMakeBeacon(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, u16 wCurrCapInfo, u16 wCurrBeaconPeriod,
+	u32 uCurrChannel, u16 wCurrATIMWinodw, PWLAN_IE_SSID pCurrSSID,
+	u8 *pCurrBSSID, PWLAN_IE_SUPP_RATES pCurrSuppRates,
+	PWLAN_IE_SUPP_RATES pCurrExtSuppRates);
 
-// Association response
-static
-PSTxMgmtPacket
-s_MgrMakeAssocResponse(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     WORD wCurrCapInfo,
-     WORD wAssocStatus,
-     WORD wAssocAID,
-     PBYTE pDstAddr,
-     PWLAN_IE_SUPP_RATES pCurrSuppRates,
-     PWLAN_IE_SUPP_RATES pCurrExtSuppRates
-    );
 
-// ReAssociation response
-static
-PSTxMgmtPacket
-s_MgrMakeReAssocResponse(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     WORD wCurrCapInfo,
-     WORD wAssocStatus,
-     WORD wAssocAID,
-     PBYTE pDstAddr,
-     PWLAN_IE_SUPP_RATES pCurrSuppRates,
-     PWLAN_IE_SUPP_RATES pCurrExtSuppRates
-    );
+/* Association response */
+static struct vnt_tx_mgmt *s_MgrMakeAssocResponse(struct vnt_private *,
+	struct vnt_manager *pMgmt, u16 wCurrCapInfo, u16 wAssocStatus,
+	u16 wAssocAID, u8 *pDstAddr, PWLAN_IE_SUPP_RATES pCurrSuppRates,
+	PWLAN_IE_SUPP_RATES pCurrExtSuppRates);
 
-// Probe response
-static
-PSTxMgmtPacket
-s_MgrMakeProbeResponse(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     WORD wCurrCapInfo,
-     WORD wCurrBeaconPeriod,
-     unsigned int uCurrChannel,
-     WORD wCurrATIMWinodw,
-     PBYTE pDstAddr,
-     PWLAN_IE_SSID pCurrSSID,
-     PBYTE pCurrBSSID,
-     PWLAN_IE_SUPP_RATES pCurrSuppRates,
-     PWLAN_IE_SUPP_RATES pCurrExtSuppRates,
-     BYTE byPHYType
-    );
+/* ReAssociation response */
+static struct vnt_tx_mgmt *s_MgrMakeReAssocResponse(struct vnt_private *,
+	struct vnt_manager *pMgmt, u16 wCurrCapInfo, u16 wAssocStatus,
+	u16 wAssocAID, u8 *pDstAddr, PWLAN_IE_SUPP_RATES pCurrSuppRates,
+	PWLAN_IE_SUPP_RATES pCurrExtSuppRates);
 
-// received status
-static
-void
-s_vMgrLogStatus(
-     PSMgmtObject pMgmt,
-     WORD wStatus
-    );
+/* Probe response */
+static struct vnt_tx_mgmt *s_MgrMakeProbeResponse(struct vnt_private *,
+	struct vnt_manager *pMgmt, u16 wCurrCapInfo, u16 wCurrBeaconPeriod,
+	u32 uCurrChannel, u16 wCurrATIMWinodw, u8 *pDstAddr,
+	PWLAN_IE_SSID pCurrSSID, u8 *pCurrBSSID,
+	PWLAN_IE_SUPP_RATES pCurrSuppRates,
+	PWLAN_IE_SUPP_RATES pCurrExtSuppRates, u8 byPHYType);
 
+/* received status */
+static void s_vMgrLogStatus(struct vnt_manager *pMgmt, u16 wStatus);
 
-static
-void
-s_vMgrSynchBSS (
-     PSDevice      pDevice,
-     unsigned int          uBSSMode,
-     PKnownBSS     pCurr,
-     PCMD_STATUS  pStatus
-    );
+
+static void s_vMgrSynchBSS(struct vnt_private *, u32 uBSSMode,
+	PKnownBSS pCurr, PCMD_STATUS  pStatus);
 

 static BOOL
@@ -324,10 +195,7 @@ s_bCipherMatch (
      PBYTE                           pbyCCSGK
     );
 
- static void  Encyption_Rebuild(
-     PSDevice pDevice,
-     PKnownBSS pCurr
- );
+static void Encyption_Rebuild(struct vnt_private *, PKnownBSS pCurr);
 
 /*---------------------  Export Variables  --------------------------*/
 
@@ -343,11 +211,10 @@ s_bCipherMatch (
  *
 -*/
 
-void vMgrObjectInit(void *hDeviceContext)
+void vMgrObjectInit(struct vnt_private *pDevice)
 {
-    PSDevice     pDevice = (PSDevice)hDeviceContext;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    int ii;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	int ii;
 

     pMgmt->pbyPSPacketPool = &pMgmt->byPSPacketPool[0];
@@ -402,12 +269,10 @@ void vMgrObjectInit(void *hDeviceContext)
  *
 -*/
 
-void vMgrAssocBeginSta(void *hDeviceContext,
-		       PSMgmtObject pMgmt,
-		       PCMD_STATUS pStatus)
+void vMgrAssocBeginSta(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, PCMD_STATUS pStatus)
 {
-    PSDevice             pDevice = (PSDevice)hDeviceContext;
-    PSTxMgmtPacket          pTxPacket;
+	struct vnt_tx_mgmt *pTxPacket;
 

     pMgmt->wCurrCapInfo = 0;
@@ -475,14 +340,10 @@ void vMgrAssocBeginSta(void *hDeviceContext,
  *
 -*/
 
-void vMgrReAssocBeginSta(void *hDeviceContext,
-			 PSMgmtObject pMgmt,
-			 PCMD_STATUS pStatus)
+void vMgrReAssocBeginSta(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, PCMD_STATUS pStatus)
 {
-    PSDevice             pDevice = (PSDevice)hDeviceContext;
-    PSTxMgmtPacket          pTxPacket;
-
-
+	struct vnt_tx_mgmt *pTxPacket;
 
     pMgmt->wCurrCapInfo = 0;
     pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_ESS(1);
@@ -551,19 +412,18 @@ void vMgrReAssocBeginSta(void *hDeviceContext,
  *
 -*/
 
-void vMgrDisassocBeginSta(void *hDeviceContext,
-			  PSMgmtObject pMgmt,
-			  PBYTE  abyDestAddress,
-			  WORD    wReason,
-			  PCMD_STATUS pStatus)
+void vMgrDisassocBeginSta(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, u8 *abyDestAddress, u16 wReason,
+	PCMD_STATUS pStatus)
 {
-    PSDevice            pDevice = (PSDevice)hDeviceContext;
-    PSTxMgmtPacket      pTxPacket = NULL;
-    WLAN_FR_DISASSOC    sFrame;
+	struct vnt_tx_mgmt *pTxPacket = NULL;
+	WLAN_FR_DISASSOC sFrame;
 
-    pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
-    memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_DISASSOC_FR_MAXLEN);
-    pTxPacket->p80211Header = (PUWLAN_80211HDR)((PBYTE)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket = (struct vnt_tx_mgmt *)pMgmt->pbyMgmtPacketPool;
+	memset(pTxPacket, 0, sizeof(struct vnt_tx_mgmt)
+		+ WLAN_DISASSOC_FR_MAXLEN);
+	pTxPacket->p80211Header = (PUWLAN_80211HDR)((u8 *)pTxPacket
+		+ sizeof(struct vnt_tx_mgmt));
 
     // Setup the sFrame structure
     sFrame.pBuf = (PBYTE)pTxPacket->p80211Header;
@@ -610,23 +470,18 @@ void vMgrDisassocBeginSta(void *hDeviceContext,
  *
 -*/
 
-static
-void
-s_vMgrRxAssocRequest(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PSRxMgmtPacket pRxPacket,
-     unsigned int uNodeIndex
-    )
+static void s_vMgrRxAssocRequest(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, struct vnt_rx_mgmt *pRxPacket,
+	u32 uNodeIndex)
 {
-    WLAN_FR_ASSOCREQ    sFrame;
-    CMD_STATUS          Status;
-    PSTxMgmtPacket      pTxPacket;
-    WORD                wAssocStatus = 0;
-    WORD                wAssocAID = 0;
-    unsigned int                uRateLen = WLAN_RATES_MAXLEN;
-    BYTE                abyCurrSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
-    BYTE                abyCurrExtSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
+	WLAN_FR_ASSOCREQ sFrame;
+	CMD_STATUS Status;
+	struct vnt_tx_mgmt *pTxPacket;
+	u16 wAssocStatus = 0;
+	u16 wAssocAID = 0;
+	u32 uRateLen = WLAN_RATES_MAXLEN;
+	u8 abyCurrSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
+	u8 abyCurrExtSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
 

     if (pMgmt->eCurrMode != WMAC_MODE_ESS_AP)
@@ -766,23 +621,18 @@ s_vMgrRxAssocRequest(
  *
 -*/
 
-static
-void
-s_vMgrRxReAssocRequest(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PSRxMgmtPacket pRxPacket,
-     unsigned int uNodeIndex
-    )
+static void s_vMgrRxReAssocRequest(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, struct vnt_rx_mgmt *pRxPacket,
+	u32 uNodeIndex)
 {
-    WLAN_FR_REASSOCREQ    sFrame;
-    CMD_STATUS          Status;
-    PSTxMgmtPacket      pTxPacket;
-    WORD                wAssocStatus = 0;
-    WORD                wAssocAID = 0;
-    unsigned int                uRateLen = WLAN_RATES_MAXLEN;
-    BYTE                abyCurrSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
-    BYTE                abyCurrExtSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
+	WLAN_FR_REASSOCREQ    sFrame;
+	CMD_STATUS Status;
+	struct vnt_tx_mgmt *pTxPacket;
+	u16 wAssocStatus = 0;
+	u16 wAssocAID = 0;
+	u32 uRateLen = WLAN_RATES_MAXLEN;
+	u8 abyCurrSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
+	u8 abyCurrExtSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
 
     if (pMgmt->eCurrMode != WMAC_MODE_ESS_AP)
         return;
@@ -913,18 +763,13 @@ s_vMgrRxReAssocRequest(
  *
 -*/
 
-static
-void
-s_vMgrRxAssocResponse(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PSRxMgmtPacket pRxPacket,
-     BOOL bReAssocType
-    )
+static void s_vMgrRxAssocResponse(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, struct vnt_rx_mgmt *pRxPacket,
+	int bReAssocType)
 {
-    WLAN_FR_ASSOCRESP   sFrame;
-    PWLAN_IE_SSID   pItemSSID;
-    PBYTE   pbyIEs;
+	WLAN_FR_ASSOCRESP   sFrame;
+	PWLAN_IE_SSID   pItemSSID;
+	u8 *pbyIEs;
 


@@ -1050,17 +895,17 @@ if(pMgmt->eCurrState == WMAC_STATE_ASSOC)
  *
 -*/
 
-void vMgrAuthenBeginSta(void *hDeviceContext,
-			PSMgmtObject  pMgmt,
-			PCMD_STATUS pStatus)
+void vMgrAuthenBeginSta(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, PCMD_STATUS pStatus)
 {
-    PSDevice     pDevice = (PSDevice)hDeviceContext;
-    WLAN_FR_AUTHEN  sFrame;
-    PSTxMgmtPacket  pTxPacket = NULL;
-
-    pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
-    memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_AUTHEN_FR_MAXLEN);
-    pTxPacket->p80211Header = (PUWLAN_80211HDR)((PBYTE)pTxPacket + sizeof(STxMgmtPacket));
+	WLAN_FR_AUTHEN sFrame;
+	struct vnt_tx_mgmt *pTxPacket =
+		(struct vnt_tx_mgmt *)pMgmt->pbyMgmtPacketPool;
+
+	memset(pTxPacket, 0, sizeof(struct vnt_tx_mgmt)
+		+ WLAN_AUTHEN_FR_MAXLEN);
+	pTxPacket->p80211Header = (PUWLAN_80211HDR)((u8 *)pTxPacket
+		+ sizeof(struct vnt_tx_mgmt));
     sFrame.pBuf = (PBYTE)pTxPacket->p80211Header;
     sFrame.len = WLAN_AUTHEN_FR_MAXLEN;
     vMgrEncodeAuthen(&sFrame);
@@ -1103,20 +948,18 @@ void vMgrAuthenBeginSta(void *hDeviceContext,
  *
 -*/
 
-void vMgrDeAuthenBeginSta(void *hDeviceContext,
-			  PSMgmtObject pMgmt,
-			  PBYTE abyDestAddress,
-			  WORD wReason,
-			  PCMD_STATUS pStatus)
+void vMgrDeAuthenBeginSta(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, u8 *abyDestAddress, u16 wReason,
+	PCMD_STATUS pStatus)
 {
-    PSDevice            pDevice = (PSDevice)hDeviceContext;
-    WLAN_FR_DEAUTHEN    sFrame;
-    PSTxMgmtPacket      pTxPacket = NULL;
-
-
-    pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
-    memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_DEAUTHEN_FR_MAXLEN);
-    pTxPacket->p80211Header = (PUWLAN_80211HDR)((PBYTE)pTxPacket + sizeof(STxMgmtPacket));
+	WLAN_FR_DEAUTHEN sFrame;
+	struct vnt_tx_mgmt *pTxPacket =
+		(struct vnt_tx_mgmt *)pMgmt->pbyMgmtPacketPool;
+
+	memset(pTxPacket, 0, sizeof(struct vnt_tx_mgmt)
+		+ WLAN_DEAUTHEN_FR_MAXLEN);
+	pTxPacket->p80211Header = (PUWLAN_80211HDR)((u8 *)pTxPacket
+		+ sizeof(struct vnt_tx_mgmt));
     sFrame.pBuf = (PBYTE)pTxPacket->p80211Header;
     sFrame.len = WLAN_DEAUTHEN_FR_MAXLEN;
     vMgrEncodeDeauthen(&sFrame);
@@ -1156,15 +999,10 @@ void vMgrDeAuthenBeginSta(void *hDeviceContext,
  *
 -*/
 
-static
-void
-s_vMgrRxAuthentication(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PSRxMgmtPacket pRxPacket
-    )
+static void s_vMgrRxAuthentication(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, struct vnt_rx_mgmt *pRxPacket)
 {
-    WLAN_FR_AUTHEN  sFrame;
+	WLAN_FR_AUTHEN  sFrame;
 
     // we better be an AP or a STA in AUTHPENDING otherwise ignore
     if (!(pMgmt->eCurrMode == WMAC_MODE_ESS_AP ||
@@ -1214,25 +1052,21 @@ s_vMgrRxAuthentication(
 -*/
 

-static
-void
-s_vMgrRxAuthenSequence_1(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PWLAN_FR_AUTHEN pFrame
-     )
+static void s_vMgrRxAuthenSequence_1(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, PWLAN_FR_AUTHEN pFrame)
 {
-    PSTxMgmtPacket      pTxPacket = NULL;
-    unsigned int                uNodeIndex;
-    WLAN_FR_AUTHEN      sFrame;
-    PSKeyItem           pTransmitKey;
-
-    // Insert a Node entry
-    if (!BSSbIsSTAInNodeDB(pDevice, pFrame->pHdr->sA3.abyAddr2, &uNodeIndex)) {
-        BSSvCreateOneNode((PSDevice)pDevice, &uNodeIndex);
-        memcpy(pMgmt->sNodeDBTable[uNodeIndex].abyMACAddr, pFrame->pHdr->sA3.abyAddr2,
-               WLAN_ADDR_LEN);
-    }
+	struct vnt_tx_mgmt *pTxPacket = NULL;
+	u32 uNodeIndex;
+	WLAN_FR_AUTHEN sFrame;
+	PSKeyItem pTransmitKey;
+
+	/* Insert a Node entry */
+	if (!BSSbIsSTAInNodeDB(pDevice, pFrame->pHdr->sA3.abyAddr2,
+		&uNodeIndex)) {
+		BSSvCreateOneNode(pDevice, &uNodeIndex);
+		memcpy(pMgmt->sNodeDBTable[uNodeIndex].abyMACAddr,
+			pFrame->pHdr->sA3.abyAddr2, WLAN_ADDR_LEN);
+	}
 
     if (pMgmt->bShareKeyAlgorithm) {
         pMgmt->sNodeDBTable[uNodeIndex].eNodeState = NODE_KNOWN;
@@ -1243,9 +1077,11 @@ s_vMgrRxAuthenSequence_1(
     }
 
     // send auth reply
-    pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
-    memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_AUTHEN_FR_MAXLEN);
-    pTxPacket->p80211Header = (PUWLAN_80211HDR)((PBYTE)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket = (struct vnt_tx_mgmt *)pMgmt->pbyMgmtPacketPool;
+	memset(pTxPacket, 0, sizeof(struct vnt_tx_mgmt)
+		+ WLAN_AUTHEN_FR_MAXLEN);
+	pTxPacket->p80211Header = (PUWLAN_80211HDR)((u8 *)pTxPacket
+		+ sizeof(struct vnt_tx_mgmt));
     sFrame.pBuf = (PBYTE)pTxPacket->p80211Header;
     sFrame.len = WLAN_AUTHEN_FR_MAXLEN;
     // format buffer structure
@@ -1320,16 +1156,11 @@ s_vMgrRxAuthenSequence_1(
  *
 -*/
 
-static
-void
-s_vMgrRxAuthenSequence_2(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PWLAN_FR_AUTHEN pFrame
-    )
+static void s_vMgrRxAuthenSequence_2(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, PWLAN_FR_AUTHEN pFrame)
 {
-    WLAN_FR_AUTHEN      sFrame;
-    PSTxMgmtPacket      pTxPacket = NULL;
+	WLAN_FR_AUTHEN sFrame;
+	struct vnt_tx_mgmt *pTxPacket = NULL;
 

     switch (cpu_to_le16((*(pFrame->pwAuthAlgorithm))))
@@ -1355,9 +1186,13 @@ s_vMgrRxAuthenSequence_2(
         case WLAN_AUTH_ALG_SHAREDKEY:
 
             if (cpu_to_le16((*(pFrame->pwStatus))) == WLAN_MGMT_STATUS_SUCCESS) {
-                pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
-                memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_AUTHEN_FR_MAXLEN);
-                pTxPacket->p80211Header = (PUWLAN_80211HDR)((PBYTE)pTxPacket + sizeof(STxMgmtPacket));
+			pTxPacket = (struct vnt_tx_mgmt *)
+				pMgmt->pbyMgmtPacketPool;
+			memset(pTxPacket, 0, sizeof(struct vnt_tx_mgmt)
+				+ WLAN_AUTHEN_FR_MAXLEN);
+			pTxPacket->p80211Header
+				= (PUWLAN_80211HDR)((u8 *)pTxPacket
+					+ sizeof(struct vnt_tx_mgmt));
                 sFrame.pBuf = (PBYTE)pTxPacket->p80211Header;
                 sFrame.len = WLAN_AUTHEN_FR_MAXLEN;
                 // format buffer structure
@@ -1421,18 +1256,13 @@ s_vMgrRxAuthenSequence_2(
  *
 -*/
 
-static
-void
-s_vMgrRxAuthenSequence_3(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PWLAN_FR_AUTHEN pFrame
-    )
+static void s_vMgrRxAuthenSequence_3(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, PWLAN_FR_AUTHEN pFrame)
 {
-    PSTxMgmtPacket      pTxPacket = NULL;
-    unsigned int                uStatusCode = 0 ;
-    unsigned int                uNodeIndex = 0;
-    WLAN_FR_AUTHEN      sFrame;
+	struct vnt_tx_mgmt *pTxPacket = NULL;
+	u32 uStatusCode = 0 ;
+	u32 uNodeIndex = 0;
+	WLAN_FR_AUTHEN sFrame;
 
     if (!WLAN_GET_FC_ISWEP(pFrame->pHdr->sA3.wFrameCtl)) {
         uStatusCode = WLAN_MGMT_STATUS_CHALLENGE_FAIL;
@@ -1462,9 +1292,11 @@ s_vMgrRxAuthenSequence_3(
 
 reply:
     // send auth reply
-    pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
-    memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_AUTHEN_FR_MAXLEN);
-    pTxPacket->p80211Header = (PUWLAN_80211HDR)((PBYTE)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket = (struct vnt_tx_mgmt *)pMgmt->pbyMgmtPacketPool;
+	memset(pTxPacket, 0, sizeof(struct vnt_tx_mgmt)
+		+ WLAN_AUTHEN_FR_MAXLEN);
+	pTxPacket->p80211Header = (PUWLAN_80211HDR)((u8 *)pTxPacket
+		+ sizeof(struct vnt_tx_mgmt));
     sFrame.pBuf = (PBYTE)pTxPacket->p80211Header;
     sFrame.len = WLAN_AUTHEN_FR_MAXLEN;
     // format buffer structure
@@ -1509,13 +1341,8 @@ reply:
  *    None.
  *
 -*/
-static
-void
-s_vMgrRxAuthenSequence_4(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PWLAN_FR_AUTHEN pFrame
-    )
+static void s_vMgrRxAuthenSequence_4(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, PWLAN_FR_AUTHEN pFrame)
 {
 
     if ( cpu_to_le16((*(pFrame->pwStatus))) == WLAN_MGMT_STATUS_SUCCESS ){
@@ -1547,17 +1374,12 @@ s_vMgrRxAuthenSequence_4(
  *
 -*/
 
-static
-void
-s_vMgrRxDisassociation(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PSRxMgmtPacket pRxPacket
-    )
+static void s_vMgrRxDisassociation(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, struct vnt_rx_mgmt *pRxPacket)
 {
-    WLAN_FR_DISASSOC    sFrame;
-    unsigned int        uNodeIndex = 0;
-    CMD_STATUS          CmdStatus;
+	WLAN_FR_DISASSOC    sFrame;
+	u32 uNodeIndex = 0;
+	CMD_STATUS CmdStatus;
 
     if ( pMgmt->eCurrMode == WMAC_MODE_ESS_AP ){
         // if is acting an AP..
@@ -1587,7 +1409,7 @@ s_vMgrRxDisassociation(
 	       pDevice->byReAssocCount = 0;
                 pMgmt->eCurrState = WMAC_STATE_AUTH;  // jump back to the auth state!
                 pDevice->eCommandState = WLAN_ASSOCIATE_WAIT;
-            vMgrReAssocBeginSta((PSDevice)pDevice, pMgmt, &CmdStatus);
+		vMgrReAssocBeginSta(pDevice, pMgmt, &CmdStatus);
               if(CmdStatus == CMD_STATUS_PENDING) {
 		  pDevice->byReAssocCount ++;
 		  return;       //mike add: you'll retry for many times, so it cann't be regarded as disconnected!
@@ -1620,16 +1442,11 @@ s_vMgrRxDisassociation(
  *
 -*/
 
-static
-void
-s_vMgrRxDeauthentication(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PSRxMgmtPacket pRxPacket
-    )
+static void s_vMgrRxDeauthentication(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, struct vnt_rx_mgmt *pRxPacket)
 {
-    WLAN_FR_DEAUTHEN    sFrame;
-    unsigned int        uNodeIndex = 0;
+	WLAN_FR_DEAUTHEN sFrame;
+	u32 uNodeIndex = 0;
 

     if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP ){
@@ -1692,13 +1509,9 @@ s_vMgrRxDeauthentication(
  *               True:exceed;
  *                False:normal case
 -*/
-static BOOL
-ChannelExceedZoneType(
-     PSDevice pDevice,
-     BYTE byCurrChannel
-    )
+static int ChannelExceedZoneType(struct vnt_private *pDevice, u8 byCurrChannel)
 {
-  BOOL exceed=FALSE;
+	int exceed = FALSE;
 
   switch(pDevice->byZoneType) {
   	case 0x00:                  //USA:1~11
@@ -1728,39 +1541,33 @@ ChannelExceedZoneType(
  *
 -*/
 
-static
-void
-s_vMgrRxBeacon(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PSRxMgmtPacket pRxPacket,
-     BOOL bInScan
-    )
+static void s_vMgrRxBeacon(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, struct vnt_rx_mgmt *pRxPacket,
+	int bInScan)
 {
-
-    PKnownBSS           pBSSList;
-    WLAN_FR_BEACON      sFrame;
+	PKnownBSS pBSSList;
+	WLAN_FR_BEACON sFrame;
 	u64 qwTSFOffset;
-    BOOL                bIsBSSIDEqual = FALSE;
-    BOOL                bIsSSIDEqual = FALSE;
-    BOOL                bTSFLargeDiff = FALSE;
-    BOOL                bTSFOffsetPostive = FALSE;
-    BOOL                bUpdateTSF = FALSE;
-    BOOL                bIsAPBeacon = FALSE;
-    BOOL                bIsChannelEqual = FALSE;
-    unsigned int                uLocateByteIndex;
-    BYTE                byTIMBitOn = 0;
-    WORD                wAIDNumber = 0;
-    unsigned int                uNodeIndex;
+	int bIsBSSIDEqual = FALSE;
+	int bIsSSIDEqual = FALSE;
+	int bTSFLargeDiff = FALSE;
+	int bTSFOffsetPostive = FALSE;
+	int bUpdateTSF = FALSE;
+	int bIsAPBeacon = FALSE;
+	int bIsChannelEqual = FALSE;
+	u32 uLocateByteIndex;
+	u8 byTIMBitOn = 0;
+	u16 wAIDNumber = 0;
+	u32 uNodeIndex;
 	u64 qwTimestamp, qwLocalTSF;
 	u64 qwCurrTSF;
-    WORD                wStartIndex = 0;
-    WORD                wAIDIndex = 0;
-    BYTE                byCurrChannel = pRxPacket->byRxChannel;
-    ERPObject           sERP;
-    unsigned int                uRateLen = WLAN_RATES_MAXLEN;
-    BOOL                bChannelHit = FALSE;
-    BYTE                byOldPreambleType;
+	u16 wStartIndex = 0;
+	u16 wAIDIndex = 0;
+	u8 byCurrChannel = pRxPacket->byRxChannel;
+	ERPObject sERP;
+	u32 uRateLen = WLAN_RATES_MAXLEN;
+	int bChannelHit = FALSE;
+	u8 byOldPreambleType;
 


@@ -2071,12 +1878,9 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
             if (pMgmt->bInTIM ||
                 (pMgmt->bMulticastTIM && (pMgmt->byDTIMCount == 0))) {
                 pMgmt->bInTIMWake = TRUE;
-                // send out ps-poll packet
-//                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN:In TIM\n");
-                if (pMgmt->bInTIM) {
-                    PSvSendPSPOLL((PSDevice)pDevice);
-//                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN:PS-POLL sent..\n");
-                }
+		/* send out ps-poll packet */
+		if (pMgmt->bInTIM)
+			PSvSendPSPOLL(pDevice);
 
             }
             else {
@@ -2130,8 +1934,8 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
                 pMgmt->sNodeDBTable[uNodeIndex].uInActiveCount = 0;
             }
             else {
-                // Todo, initial Node content
-                BSSvCreateOneNode((PSDevice)pDevice, &uNodeIndex);
+		/* Todo, initial Node content */
+		BSSvCreateOneNode(pDevice, &uNodeIndex);
 
                 pMgmt->abyCurrSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)sFrame.pSuppRates,
                                                         (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
@@ -2242,21 +2046,20 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
  *
 -*/
 
-void vMgrCreateOwnIBSS(void *hDeviceContext,
-		       PCMD_STATUS pStatus)
+void vMgrCreateOwnIBSS(struct vnt_private *pDevice, PCMD_STATUS pStatus)
 {
-    PSDevice            pDevice = (PSDevice)hDeviceContext;
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-    WORD                wMaxBasicRate;
-    WORD                wMaxSuppRate;
-    BYTE                byTopCCKBasicRate;
-    BYTE                byTopOFDMBasicRate;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	u16 wMaxBasicRate;
+	u16 wMaxSuppRate;
+	u8 byTopCCKBasicRate;
+	u8 byTopOFDMBasicRate;
 	u64 qwCurrTSF = 0;
-    unsigned int                ii;
-    BYTE    abyRATE[] = {0x82, 0x84, 0x8B, 0x96, 0x24, 0x30, 0x48, 0x6C, 0x0C, 0x12, 0x18, 0x60};
-    BYTE    abyCCK_RATE[] = {0x82, 0x84, 0x8B, 0x96};
-    BYTE    abyOFDM_RATE[] = {0x0C, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C};
-    WORD                wSuppRate;
+	int ii;
+	u8 abyRATE[] = {0x82, 0x84, 0x8B, 0x96, 0x24, 0x30, 0x48, 0x6C, 0x0C,
+		0x12, 0x18, 0x60};
+	u8 abyCCK_RATE[] = {0x82, 0x84, 0x8B, 0x96};
+	u8 abyOFDM_RATE[] = {0x0C, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C};
+	u16 wSuppRate;
 


@@ -2494,22 +2297,21 @@ void vMgrCreateOwnIBSS(void *hDeviceContext,
  *
 -*/
 
-void vMgrJoinBSSBegin(void *hDeviceContext, PCMD_STATUS pStatus)
+void vMgrJoinBSSBegin(struct vnt_private *pDevice, PCMD_STATUS pStatus)
 {
-    PSDevice     pDevice = (PSDevice)hDeviceContext;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    PKnownBSS       pCurr = NULL;
-    unsigned int            ii, uu;
-    PWLAN_IE_SUPP_RATES pItemRates = NULL;
-    PWLAN_IE_SUPP_RATES pItemExtRates = NULL;
-    PWLAN_IE_SSID   pItemSSID;
-    unsigned int            uRateLen = WLAN_RATES_MAXLEN;
-    WORD            wMaxBasicRate = RATE_1M;
-    WORD            wMaxSuppRate = RATE_1M;
-    WORD            wSuppRate;
-    BYTE            byTopCCKBasicRate = RATE_1M;
-    BYTE            byTopOFDMBasicRate = RATE_1M;
-    BOOL            bShortSlotTime = FALSE;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	PKnownBSS pCurr = NULL;
+	int ii, uu;
+	PWLAN_IE_SUPP_RATES pItemRates = NULL;
+	PWLAN_IE_SUPP_RATES pItemExtRates = NULL;
+	PWLAN_IE_SSID   pItemSSID;
+	u32 uRateLen = WLAN_RATES_MAXLEN;
+	u16 wMaxBasicRate = RATE_1M;
+	u16 wMaxSuppRate = RATE_1M;
+	u16 wSuppRate;
+	u8 byTopCCKBasicRate = RATE_1M;
+	u8 byTopOFDMBasicRate = RATE_1M;
+	u8 bShortSlotTime = FALSE;
 

     for (ii = 0; ii < MAX_BSS_NUM; ii++) {
@@ -2819,23 +2621,20 @@ void vMgrJoinBSSBegin(void *hDeviceContext, PCMD_STATUS pStatus)
  *    PCM_STATUS
  *
 -*/
-static
-void
-s_vMgrSynchBSS (
-     PSDevice      pDevice,
-     unsigned int          uBSSMode,
-     PKnownBSS     pCurr,
-     PCMD_STATUS  pStatus
-    )
+static void s_vMgrSynchBSS(struct vnt_private *pDevice, u32 uBSSMode,
+	PKnownBSS pCurr, PCMD_STATUS pStatus)
 {
-    PSMgmtObject  pMgmt = &(pDevice->sMgmtObj);
-                                                     //1M,   2M,   5M,   11M,  18M,  24M,  36M,  54M
-    BYTE abyCurrSuppRatesG[] = {WLAN_EID_SUPP_RATES, 8, 0x02, 0x04, 0x0B, 0x16, 0x24, 0x30, 0x48, 0x6C};
-    BYTE abyCurrExtSuppRatesG[] = {WLAN_EID_EXTSUPP_RATES, 4, 0x0C, 0x12, 0x18, 0x60};
-                                                           //6M,   9M,   12M,  48M
-    BYTE abyCurrSuppRatesA[] = {WLAN_EID_SUPP_RATES, 8, 0x0C, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C};
-    BYTE abyCurrSuppRatesB[] = {WLAN_EID_SUPP_RATES, 4, 0x02, 0x04, 0x0B, 0x16};
-
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
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
 
     *pStatus = CMD_STATUS_FAILURE;
 
@@ -2974,21 +2773,13 @@ s_vMgrSynchBSS (
     return;
 };
 
-
-//mike add: fix NetworkManager 0.7.0 hidden ssid mode in WPA encryption
-//                   ,need reset eAuthenMode and eEncryptionStatus
- static void  Encyption_Rebuild(
-     PSDevice pDevice,
-     PKnownBSS pCurr
- )
+static void Encyption_Rebuild(struct vnt_private *pDevice, PKnownBSS pCurr)
  {
-  PSMgmtObject  pMgmt = &(pDevice->sMgmtObj);
-  /* unsigned int ii, uSameBssidNum=0; */
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 
-  //   if( uSameBssidNum>=2) {	 //we only check AP in hidden sssid  mode
-        if ((pMgmt->eAuthenMode == WMAC_AUTH_WPAPSK) ||           //networkmanager 0.7.0 does not give the pairwise-key selsection,
-             (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK)) {         // so we need re-selsect it according to real pairwise-key info.
-               if(pCurr->bWPAValid == TRUE)  {   //WPA-PSK
+	if ((pMgmt->eAuthenMode == WMAC_AUTH_WPAPSK) ||
+		(pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK)) {
+		if (pCurr->bWPAValid == TRUE)  {   /*WPA-PSK */
                           pMgmt->eAuthenMode = WMAC_AUTH_WPAPSK;
 		    if(pCurr->abyPKType[0] == WPA_TKIP) {
      		        pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;    //TKIP
@@ -3027,20 +2818,15 @@ s_vMgrSynchBSS (
  *
 -*/
 
-static
-void
-s_vMgrFormatTIM(
-     PSMgmtObject pMgmt,
-     PWLAN_IE_TIM pTIM
-    )
+static void s_vMgrFormatTIM(struct vnt_manager *pMgmt, PWLAN_IE_TIM pTIM)
 {
-    BYTE        byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
-    BYTE        byMap;
-    unsigned int        ii, jj;
-    BOOL        bStartFound = FALSE;
-    BOOL        bMulticast = FALSE;
-    WORD        wStartIndex = 0;
-    WORD        wEndIndex = 0;
+	u8 byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
+	u8 byMap;
+	int ii, jj;
+	int bStartFound = FALSE;
+	int bMulticast = FALSE;
+	u16 wStartIndex = 0;
+	u16 wEndIndex = 0;
 

     // Find size of partial virtual bitmap
@@ -3102,30 +2888,23 @@ s_vMgrFormatTIM(
  *
 -*/
 
-static
-PSTxMgmtPacket
-s_MgrMakeBeacon(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     WORD wCurrCapInfo,
-     WORD wCurrBeaconPeriod,
-     unsigned int uCurrChannel,
-     WORD wCurrATIMWinodw,
-     PWLAN_IE_SSID pCurrSSID,
-     PBYTE pCurrBSSID,
-     PWLAN_IE_SUPP_RATES pCurrSuppRates,
-     PWLAN_IE_SUPP_RATES pCurrExtSuppRates
-    )
+static struct vnt_tx_mgmt *s_MgrMakeBeacon(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, u16 wCurrCapInfo, u16 wCurrBeaconPeriod,
+	u32 uCurrChannel, u16 wCurrATIMWinodw, PWLAN_IE_SSID pCurrSSID,
+	u8 *pCurrBSSID, PWLAN_IE_SUPP_RATES pCurrSuppRates,
+	PWLAN_IE_SUPP_RATES pCurrExtSuppRates)
 {
-    PSTxMgmtPacket      pTxPacket = NULL;
-    WLAN_FR_BEACON      sFrame;
-    BYTE                abyBroadcastAddr[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	struct vnt_tx_mgmt *pTxPacket = NULL;
+	WLAN_FR_BEACON sFrame;
+	u8 abyBroadcastAddr[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 

-    // prepare beacon frame
-    pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
-    memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_BEACON_FR_MAXLEN);
-    pTxPacket->p80211Header = (PUWLAN_80211HDR)((PBYTE)pTxPacket + sizeof(STxMgmtPacket));
+	/* prepare beacon frame */
+	pTxPacket = (struct vnt_tx_mgmt *)pMgmt->pbyMgmtPacketPool;
+	memset(pTxPacket, 0, sizeof(struct vnt_tx_mgmt)
+		+ WLAN_BEACON_FR_MAXLEN);
+	pTxPacket->p80211Header = (PUWLAN_80211HDR)((u8 *)pTxPacket
+		+ sizeof(struct vnt_tx_mgmt));
     // Setup the sFrame structure.
     sFrame.pBuf = (PBYTE)pTxPacket->p80211Header;
     sFrame.len = WLAN_BEACON_FR_MAXLEN;
@@ -3277,30 +3056,22 @@ s_MgrMakeBeacon(
 


-PSTxMgmtPacket
-s_MgrMakeProbeResponse(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     WORD wCurrCapInfo,
-     WORD wCurrBeaconPeriod,
-     unsigned int uCurrChannel,
-     WORD wCurrATIMWinodw,
-     PBYTE pDstAddr,
-     PWLAN_IE_SSID pCurrSSID,
-     PBYTE pCurrBSSID,
-     PWLAN_IE_SUPP_RATES pCurrSuppRates,
-     PWLAN_IE_SUPP_RATES pCurrExtSuppRates,
-     BYTE byPHYType
-    )
+struct vnt_tx_mgmt *s_MgrMakeProbeResponse(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, u16 wCurrCapInfo, u16 wCurrBeaconPeriod,
+	u32 uCurrChannel, u16 wCurrATIMWinodw, u8 *pDstAddr,
+	PWLAN_IE_SSID pCurrSSID, u8 *pCurrBSSID,
+	PWLAN_IE_SUPP_RATES pCurrSuppRates,
+	PWLAN_IE_SUPP_RATES pCurrExtSuppRates, u8 byPHYType)
 {
-    PSTxMgmtPacket      pTxPacket = NULL;
-    WLAN_FR_PROBERESP   sFrame;
+	struct vnt_tx_mgmt *pTxPacket = NULL;
+	WLAN_FR_PROBERESP sFrame;
 

-
-    pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
-    memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_PROBERESP_FR_MAXLEN);
-    pTxPacket->p80211Header = (PUWLAN_80211HDR)((PBYTE)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket = (struct vnt_tx_mgmt *)pMgmt->pbyMgmtPacketPool;
+	memset(pTxPacket, 0, sizeof(struct vnt_tx_mgmt)
+		+ WLAN_PROBERESP_FR_MAXLEN);
+	pTxPacket->p80211Header = (PUWLAN_80211HDR)((u8 *)pTxPacket
+		+ sizeof(struct vnt_tx_mgmt));
     // Setup the sFrame structure.
     sFrame.pBuf = (PBYTE)pTxPacket->p80211Header;
     sFrame.len = WLAN_PROBERESP_FR_MAXLEN;
@@ -3409,27 +3180,24 @@ s_MgrMakeProbeResponse(
 -*/
 

-PSTxMgmtPacket
-s_MgrMakeAssocRequest(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PBYTE pDAddr,
-     WORD wCurrCapInfo,
-     WORD wListenInterval,
-     PWLAN_IE_SSID pCurrSSID,
-     PWLAN_IE_SUPP_RATES pCurrRates,
-     PWLAN_IE_SUPP_RATES pCurrExtSuppRates
-    )
+struct vnt_tx_mgmt *s_MgrMakeAssocRequest(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, u8 *pDAddr, u16 wCurrCapInfo,
+	u16 wListenInterval,
+	PWLAN_IE_SSID pCurrSSID,
+	PWLAN_IE_SUPP_RATES pCurrRates,
+	PWLAN_IE_SUPP_RATES pCurrExtSuppRates)
 {
-    PSTxMgmtPacket      pTxPacket = NULL;
-    WLAN_FR_ASSOCREQ    sFrame;
-    PBYTE               pbyIEs;
-    PBYTE               pbyRSN;
+	struct vnt_tx_mgmt *pTxPacket = NULL;
+	WLAN_FR_ASSOCREQ sFrame;
+	u8 *pbyIEs;
+	u8 *pbyRSN;
 

-    pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
-    memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_ASSOCREQ_FR_MAXLEN);
-    pTxPacket->p80211Header = (PUWLAN_80211HDR)((PBYTE)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket = (struct vnt_tx_mgmt *)pMgmt->pbyMgmtPacketPool;
+	memset(pTxPacket, 0, sizeof(struct vnt_tx_mgmt)
+		+ WLAN_ASSOCREQ_FR_MAXLEN);
+	pTxPacket->p80211Header = (PUWLAN_80211HDR)((u8 *)pTxPacket
+		+ sizeof(struct vnt_tx_mgmt));
     // Setup the sFrame structure.
     sFrame.pBuf = (PBYTE)pTxPacket->p80211Header;
     sFrame.len = WLAN_ASSOCREQ_FR_MAXLEN;
@@ -3671,27 +3439,23 @@ s_MgrMakeAssocRequest(
 -*/
 

-PSTxMgmtPacket
-s_MgrMakeReAssocRequest(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PBYTE pDAddr,
-     WORD wCurrCapInfo,
-     WORD wListenInterval,
-     PWLAN_IE_SSID pCurrSSID,
-     PWLAN_IE_SUPP_RATES pCurrRates,
-     PWLAN_IE_SUPP_RATES pCurrExtSuppRates
-    )
+struct vnt_tx_mgmt *s_MgrMakeReAssocRequest(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, u8 *pDAddr, u16 wCurrCapInfo,
+	u16 wListenInterval, PWLAN_IE_SSID pCurrSSID,
+	PWLAN_IE_SUPP_RATES pCurrRates,
+	PWLAN_IE_SUPP_RATES pCurrExtSuppRates)
 {
-    PSTxMgmtPacket      pTxPacket = NULL;
-    WLAN_FR_REASSOCREQ  sFrame;
-    PBYTE               pbyIEs;
-    PBYTE               pbyRSN;
+	struct vnt_tx_mgmt *pTxPacket = NULL;
+	WLAN_FR_REASSOCREQ  sFrame;
+	u8 *pbyIEs;
+	u8 *pbyRSN;
 

-    pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
-    memset( pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_REASSOCREQ_FR_MAXLEN);
-    pTxPacket->p80211Header = (PUWLAN_80211HDR)((PBYTE)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket = (struct vnt_tx_mgmt *)pMgmt->pbyMgmtPacketPool;
+	memset(pTxPacket, 0, sizeof(struct vnt_tx_mgmt)
+		+ WLAN_REASSOCREQ_FR_MAXLEN);
+	pTxPacket->p80211Header = (PUWLAN_80211HDR)((u8 *)pTxPacket
+		+ sizeof(struct vnt_tx_mgmt));
     /* Setup the sFrame structure. */
     sFrame.pBuf = (PBYTE)pTxPacket->p80211Header;
     sFrame.len = WLAN_REASSOCREQ_FR_MAXLEN;
@@ -3925,25 +3689,20 @@ s_MgrMakeReAssocRequest(
  *
 -*/
 
-PSTxMgmtPacket
-s_MgrMakeAssocResponse(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     WORD wCurrCapInfo,
-     WORD wAssocStatus,
-     WORD wAssocAID,
-     PBYTE pDstAddr,
-     PWLAN_IE_SUPP_RATES pCurrSuppRates,
-     PWLAN_IE_SUPP_RATES pCurrExtSuppRates
-    )
+struct vnt_tx_mgmt *s_MgrMakeAssocResponse(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, u16 wCurrCapInfo, u16 wAssocStatus,
+	u16 wAssocAID, u8 *pDstAddr, PWLAN_IE_SUPP_RATES pCurrSuppRates,
+	PWLAN_IE_SUPP_RATES pCurrExtSuppRates)
 {
-    PSTxMgmtPacket      pTxPacket = NULL;
-    WLAN_FR_ASSOCRESP   sFrame;
+	struct vnt_tx_mgmt *pTxPacket = NULL;
+	WLAN_FR_ASSOCRESP   sFrame;
 

-    pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
-    memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_ASSOCREQ_FR_MAXLEN);
-    pTxPacket->p80211Header = (PUWLAN_80211HDR)((PBYTE)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket = (struct vnt_tx_mgmt *)pMgmt->pbyMgmtPacketPool;
+	memset(pTxPacket, 0, sizeof(struct vnt_tx_mgmt)
+		+ WLAN_ASSOCREQ_FR_MAXLEN);
+	pTxPacket->p80211Header = (PUWLAN_80211HDR)((u8 *)pTxPacket
+		+ sizeof(struct vnt_tx_mgmt));
     // Setup the sFrame structure
     sFrame.pBuf = (PBYTE)pTxPacket->p80211Header;
     sFrame.len = WLAN_REASSOCRESP_FR_MAXLEN;
@@ -3999,25 +3758,20 @@ s_MgrMakeAssocResponse(
 -*/
 

-PSTxMgmtPacket
-s_MgrMakeReAssocResponse(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     WORD wCurrCapInfo,
-     WORD wAssocStatus,
-     WORD wAssocAID,
-     PBYTE pDstAddr,
-     PWLAN_IE_SUPP_RATES pCurrSuppRates,
-     PWLAN_IE_SUPP_RATES pCurrExtSuppRates
-    )
+struct vnt_tx_mgmt *s_MgrMakeReAssocResponse(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, u16 wCurrCapInfo, u16 wAssocStatus,
+	u16 wAssocAID, u8 *pDstAddr, PWLAN_IE_SUPP_RATES pCurrSuppRates,
+	PWLAN_IE_SUPP_RATES pCurrExtSuppRates)
 {
-    PSTxMgmtPacket      pTxPacket = NULL;
-    WLAN_FR_REASSOCRESP   sFrame;
+	struct vnt_tx_mgmt *pTxPacket = NULL;
+	WLAN_FR_REASSOCRESP sFrame;
 

-    pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
-    memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_ASSOCREQ_FR_MAXLEN);
-    pTxPacket->p80211Header = (PUWLAN_80211HDR)((PBYTE)pTxPacket + sizeof(STxMgmtPacket));
+	pTxPacket = (struct vnt_tx_mgmt *)pMgmt->pbyMgmtPacketPool;
+	memset(pTxPacket, 0, sizeof(struct vnt_tx_mgmt)
+		+ WLAN_ASSOCREQ_FR_MAXLEN);
+	pTxPacket->p80211Header = (PUWLAN_80211HDR)((u8 *)pTxPacket
+		+ sizeof(struct vnt_tx_mgmt));
     // Setup the sFrame structure
     sFrame.pBuf = (PBYTE)pTxPacket->p80211Header;
     sFrame.len = WLAN_REASSOCRESP_FR_MAXLEN;
@@ -4072,19 +3826,14 @@ s_MgrMakeReAssocResponse(
  *
 -*/
 
-static
-void
-s_vMgrRxProbeResponse(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PSRxMgmtPacket pRxPacket
-    )
+static void s_vMgrRxProbeResponse(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, struct vnt_rx_mgmt *pRxPacket)
 {
-    PKnownBSS           pBSSList = NULL;
-    WLAN_FR_PROBERESP   sFrame;
-    BYTE                byCurrChannel = pRxPacket->byRxChannel;
-    ERPObject           sERP;
-    BOOL                bChannelHit = TRUE;
+	PKnownBSS pBSSList = NULL;
+	WLAN_FR_PROBERESP sFrame;
+	u8 byCurrChannel = pRxPacket->byRxChannel;
+	ERPObject sERP;
+	int bChannelHit = TRUE;
 

     memset(&sFrame, 0, sizeof(WLAN_FR_PROBERESP));
@@ -4204,18 +3953,13 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
 -*/
 

-static
-void
-s_vMgrRxProbeRequest(
-     PSDevice pDevice,
-     PSMgmtObject pMgmt,
-     PSRxMgmtPacket pRxPacket
-    )
+static void s_vMgrRxProbeRequest(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt, struct vnt_rx_mgmt *pRxPacket)
 {
-    WLAN_FR_PROBEREQ    sFrame;
-    CMD_STATUS          Status;
-    PSTxMgmtPacket      pTxPacket;
-    BYTE                byPHYType = BB_TYPE_11B;
+	WLAN_FR_PROBEREQ sFrame;
+	CMD_STATUS Status;
+	struct vnt_tx_mgmt *pTxPacket;
+	u8 byPHYType = BB_TYPE_11B;
 
     // STA in Ad-hoc mode: when latest TBTT beacon transmit success,
     // STA have to response this request.
@@ -4290,15 +4034,13 @@ s_vMgrRxProbeRequest(
  *
 -*/
 
-void vMgrRxManagePacket(void *hDeviceContext,
-			PSMgmtObject pMgmt,
-			PSRxMgmtPacket pRxPacket)
+void vMgrRxManagePacket(struct vnt_private *pDevice, struct vnt_manager *pMgmt,
+		struct vnt_rx_mgmt *pRxPacket)
 {
-    PSDevice    pDevice = (PSDevice)hDeviceContext;
-    BOOL        bInScan = FALSE;
-    unsigned int        uNodeIndex = 0;
-    NODE_STATE  eNodeState = 0;
-    CMD_STATUS  Status;
+	int bInScan = FALSE;
+	u32 uNodeIndex = 0;
+	NODE_STATE eNodeState = 0;
+	CMD_STATUS Status;
 

     if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
@@ -4436,10 +4178,10 @@ void vMgrRxManagePacket(void *hDeviceContext,
  *    TRUE if success; FALSE if failed.
  *
 -*/
-BOOL bMgrPrepareBeaconToSend(void *hDeviceContext, PSMgmtObject pMgmt)
+int bMgrPrepareBeaconToSend(struct vnt_private *pDevice,
+	struct vnt_manager *pMgmt)
 {
-    PSDevice            pDevice = (PSDevice)hDeviceContext;
-    PSTxMgmtPacket      pTxPacket;
+	struct vnt_tx_mgmt *pTxPacket;
 
 //    pDevice->bBeaconBufReady = FALSE;
     if (pDevice->bEncryptionEnable || pDevice->bEnable8021x){
@@ -4487,12 +4229,7 @@ BOOL bMgrPrepareBeaconToSend(void *hDeviceContext, PSMgmtObject pMgmt)
  *    none.
  *
 -*/
-static
-void
-s_vMgrLogStatus(
-     PSMgmtObject pMgmt,
-     WORD  wStatus
-    )
+static void s_vMgrLogStatus(struct vnt_manager *pMgmt, u16 wStatus)
 {
     switch( wStatus ){
         case WLAN_MGMT_STATUS_UNSPEC_FAILURE:
@@ -4557,13 +4294,11 @@ s_vMgrLogStatus(
  *
 -*/
 
-BOOL bAdd_PMKID_Candidate(void *hDeviceContext,
-			  PBYTE pbyBSSID,
-			  PSRSNCapObject psRSNCapObj)
+int bAdd_PMKID_Candidate(struct vnt_private *pDevice, u8 *pbyBSSID,
+	PSRSNCapObject psRSNCapObj)
 {
-    PSDevice         pDevice = (PSDevice)hDeviceContext;
-    PPMKID_CANDIDATE pCandidateList;
-    unsigned int             ii = 0;
+	PPMKID_CANDIDATE pCandidateList;
+	int ii = 0;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"bAdd_PMKID_Candidate START: (%d)\n", (int)pDevice->gsPMKIDCandidate.NumCandidates);
 
@@ -4619,14 +4354,14 @@ BOOL bAdd_PMKID_Candidate(void *hDeviceContext,
  *
 -*/
 
-void vFlush_PMKID_Candidate(void *hDeviceContext)
+void vFlush_PMKID_Candidate(struct vnt_private *pDevice)
 {
-    PSDevice        pDevice = (PSDevice)hDeviceContext;
+	if (pDevice == NULL)
+		return;
 
-    if (pDevice == NULL)
-        return;
+	memset(&pDevice->gsPMKIDCandidate, 0, sizeof(SPMKIDCandidateEvent));
 
-    memset(&pDevice->gsPMKIDCandidate, 0, sizeof(SPMKIDCandidateEvent));
+	return;
 }
 
 static BOOL
diff --git a/drivers/staging/vt6656/wmgr.h b/drivers/staging/vt6656/wmgr.h
index f98309b..86c1505 100644
--- a/drivers/staging/vt6656/wmgr.h
+++ b/drivers/staging/vt6656/wmgr.h
@@ -220,32 +220,26 @@ typedef enum tagWMAC_POWER_MODE {
 
 /* Tx Management Packet descriptor */
 typedef struct vnt_tx_mgmt {
-
-    PUWLAN_80211HDR     p80211Header;
-    unsigned int                cbMPDULen;
-    unsigned int                cbPayloadLen;
-
+	PUWLAN_80211HDR p80211Header;
+	u32 cbMPDULen;
+	u32 cbPayloadLen;
 } STxMgmtPacket, *PSTxMgmtPacket;
 

 /* Rx Management Packet descriptor */
 typedef struct vnt_rx_mgmt {
-
-    PUWLAN_80211HDR     p80211Header;
+	PUWLAN_80211HDR p80211Header;
 	u64 qwLocalTSF;
-    unsigned int                cbMPDULen;
-    unsigned int                cbPayloadLen;
-    unsigned int                uRSSI;
-    BYTE                bySQ;
-    BYTE                byRxRate;
-    BYTE                byRxChannel;
-
+	u32 cbMPDULen;
+	u32 cbPayloadLen;
+	u32 uRSSI;
+	u8 bySQ;
+	u8 byRxRate;
+	u8 byRxChannel;
 } SRxMgmtPacket, *PSRxMgmtPacket;
 

-
-typedef struct vnt_manager
-{
+typedef struct vnt_manager {
 	void *pAdapter;
     // MAC address
     BYTE                    abyMACAddr[WLAN_ADDR_LEN];
@@ -334,7 +328,8 @@ typedef struct vnt_manager
     WORD                    wCountToWakeUp;
     BOOL                    bInTIMWake;
     PBYTE                   pbyPSPacketPool;
-    BYTE                    byPSPacketPool[sizeof(STxMgmtPacket) + WLAN_NULLDATA_FR_MAXLEN];
+	u8 byPSPacketPool[sizeof(struct vnt_tx_mgmt)
+		+ WLAN_NULLDATA_FR_MAXLEN];
     BOOL                    bRxBeaconInTBTTWake;
     BYTE                    abyPSTxMap[MAX_NODE_NUM + 1];
 
@@ -344,14 +339,15 @@ typedef struct vnt_manager
 
     // management packet pool
     PBYTE                   pbyMgmtPacketPool;
-    BYTE                    byMgmtPacketPool[sizeof(STxMgmtPacket) + WLAN_A3FR_MAXLEN];
+	u8 byMgmtPacketPool[sizeof(struct vnt_tx_mgmt)
+		+ WLAN_A3FR_MAXLEN];
 

     // One second callback timer
 	struct timer_list	    sTimerSecondCallback;
 
-    // Temporarily Rx Mgmt Packet Descriptor
-    SRxMgmtPacket           sRxPacket;
+	/* Temporarily Rx Mgmt Packet Descriptor */
+	struct vnt_rx_mgmt sRxPacket;
 
     // link list of known bss's (scan results)
     KnownBSS                sBSSList[MAX_BSS_NUM];
@@ -385,8 +381,10 @@ typedef struct vnt_manager
     BYTE                    byNewChannel;
     PWLAN_IE_MEASURE_REP    pCurrMeasureEIDRep;
     unsigned int                    uLengthOfRepEIDs;
-    BYTE                    abyCurrentMSRReq[sizeof(STxMgmtPacket) + WLAN_A3FR_MAXLEN];
-    BYTE                    abyCurrentMSRRep[sizeof(STxMgmtPacket) + WLAN_A3FR_MAXLEN];
+	u8 abyCurrentMSRReq[sizeof(struct vnt_tx_mgmt)
+		+ WLAN_A3FR_MAXLEN];
+	u8 abyCurrentMSRRep[sizeof(struct vnt_tx_mgmt)
+		+ WLAN_A3FR_MAXLEN];
     BYTE                    abyIECountry[WLAN_A3FR_MAXLEN];
     BYTE                    abyIBSSDFSOwner[6];
     BYTE                    byIBSSDFSRecovery;
@@ -399,35 +397,29 @@ typedef struct vnt_manager
 
 /*---------------------  Export Functions  --------------------------*/
 
-void vMgrObjectInit(void *hDeviceContext);
+void vMgrObjectInit(struct vnt_private *pDevice);
 
-void vMgrAssocBeginSta(void *hDeviceContext,
-		       PSMgmtObject pMgmt,
-		       PCMD_STATUS pStatus);
+void vMgrAssocBeginSta(struct vnt_private *pDevice,
+		struct vnt_manager *, PCMD_STATUS pStatus);
 
-void vMgrReAssocBeginSta(void *hDeviceContext,
-			 PSMgmtObject pMgmt,
-			 PCMD_STATUS pStatus);
+void vMgrReAssocBeginSta(struct vnt_private *pDevice,
+		struct vnt_manager *, PCMD_STATUS pStatus);
 
-void vMgrDisassocBeginSta(void *hDeviceContext,
-			  PSMgmtObject pMgmt,
-			  PBYTE abyDestAddress,
-			  WORD wReason,
-			  PCMD_STATUS pStatus);
+void vMgrDisassocBeginSta(struct vnt_private *pDevice,
+	struct vnt_manager *, u8 *abyDestAddress, u16 wReason,
+	PCMD_STATUS pStatus);
 
-void vMgrAuthenBeginSta(void *hDeviceContext,
-			PSMgmtObject pMgmt,
-			PCMD_STATUS pStatus);
+void vMgrAuthenBeginSta(struct vnt_private *pDevice,
+	struct vnt_manager *, PCMD_STATUS pStatus);
 
-void vMgrCreateOwnIBSS(void *hDeviceContext,
-		       PCMD_STATUS pStatus);
+void vMgrCreateOwnIBSS(struct vnt_private *pDevice,
+	PCMD_STATUS pStatus);
 
-void vMgrJoinBSSBegin(void *hDeviceContext,
-		      PCMD_STATUS pStatus);
+void vMgrJoinBSSBegin(struct vnt_private *pDevice,
+	PCMD_STATUS pStatus);
 
-void vMgrRxManagePacket(void *hDeviceContext,
-			PSMgmtObject pMgmt,
-			PSRxMgmtPacket pRxPacket);
+void vMgrRxManagePacket(struct vnt_private *pDevice,
+	struct vnt_manager *, struct vnt_rx_mgmt *);
 
 /*
 void
@@ -437,19 +429,16 @@ vMgrScanBegin(
     );
 */
 
-void vMgrDeAuthenBeginSta(void *hDeviceContext,
-			  PSMgmtObject pMgmt,
-			  PBYTE abyDestAddress,
-			  WORD wReason,
-			  PCMD_STATUS pStatus);
+void vMgrDeAuthenBeginSta(struct vnt_private *pDevice,
+	struct vnt_manager *, u8 *abyDestAddress, u16 wReason,
+	PCMD_STATUS pStatus);
 
-BOOL bMgrPrepareBeaconToSend(void *hDeviceContext,
-			     PSMgmtObject pMgmt);
+int bMgrPrepareBeaconToSend(struct vnt_private *pDevice,
+	struct vnt_manager *);
 
-BOOL bAdd_PMKID_Candidate(void *hDeviceContext,
-			  PBYTE pbyBSSID,
-			  PSRSNCapObject psRSNCapObj);
+int bAdd_PMKID_Candidate(struct vnt_private *pDevice,
+	u8 *pbyBSSID, PSRSNCapObject psRSNCapObj);
 
-void vFlush_PMKID_Candidate(void *hDeviceContext);
+void vFlush_PMKID_Candidate(struct vnt_private *pDevice);
 
 #endif /* __WMGR_H__ */
-- 
1.8.0




