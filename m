Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:42090 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3AGXmn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 18:42:43 -0500
Received: by mail-wg0-f42.google.com with SMTP id dr1so4515wgb.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2013 15:42:41 -0800 (PST)
Message-ID: <1357602156.12182.11.camel@canaries64> (sfid-20130108_004247_190132_EDF2E2DE)
Subject: [PATCH 3/3] staging: vt6656: staging: vt6656 change remaining to
 vnt_mgmt and remove typedef v2
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 07 Jan 2013 23:42:36 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


rebased version

after this patch continue on wards with
[10/11] staging: vt6656: clean up struct vnt_private.
[11/11] staging: vt6656: clean up struct vnt manager

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c    |  2 +-
 drivers/staging/vt6656/card.c     | 16 ++++++++--------
 drivers/staging/vt6656/device.h   |  7 +++----
 drivers/staging/vt6656/dpc.c      | 10 +++++-----
 drivers/staging/vt6656/mac.c      |  7 +++----
 drivers/staging/vt6656/main_usb.c | 17 +++++++----------
 drivers/staging/vt6656/rf.c       | 24 ++++++++++++++++--------
 drivers/staging/vt6656/rxtx.c     |  8 ++++----
 drivers/staging/vt6656/wmgr.h     | 12 ++++++------
 9 files changed, 53 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 59765b0..79339fd 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -772,7 +772,7 @@ void BSSvRemoveOneNode(struct vnt_private *pDevice, u32 uNodeIndex)
 void BSSvUpdateAPNode(struct vnt_private *pDevice, u16 *pwCapInfo,
 	PWLAN_IE_SUPP_RATES pSuppRates, PWLAN_IE_SUPP_RATES pExtSuppRates)
 {
-	struct vnt_manager *pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	u32 uRateLen = WLAN_RATES_MAXLEN;
 
     memset(&pMgmt->sNodeDBTable[0], 0, sizeof(KnownNodeDB));
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 93983d9..7d725bb 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -513,7 +513,7 @@ void vUpdateIFS(struct vnt_private *pDevice)
         }
         pDevice->uDIFS = C_SIFS_BG + 2*pDevice->uSlot;
 
-        pItemRates = (PWLAN_IE_SUPP_RATES)pDevice->sMgmtObj.abyCurrSuppRates;
+	pItemRates = (PWLAN_IE_SUPP_RATES)pDevice->vnt_mgmt.abyCurrSuppRates;
         for (ii = 0; ii < pItemRates->len; ii++) {
             byRate = (BYTE)(pItemRates->abyRates[ii]&0x7F);
             if (RATEwGetRateIdx(byRate) > RATE_11M) {
@@ -522,7 +522,8 @@ void vUpdateIFS(struct vnt_private *pDevice)
             }
         }
         if (bOFDMRate == FALSE) {
-            pItemRates = (PWLAN_IE_SUPP_RATES)pDevice->sMgmtObj.abyCurrExtSuppRates;
+		pItemRates = (PWLAN_IE_SUPP_RATES)pDevice->vnt_mgmt
+			.abyCurrExtSuppRates;
             for (ii = 0; ii < pItemRates->len; ii++) {
                 byRate = (BYTE)(pItemRates->abyRates[ii]&0x7F);
                 if (RATEwGetRateIdx(byRate) > RATE_11M) {
@@ -1035,12 +1036,11 @@ int CARDbChannelSwitch(struct vnt_private *pDevice, u8 byMode,
 {
 	int bResult = TRUE;
 
-    if (byCount == 0) {
-        pDevice->sMgmtObj.uCurrChannel = byNewChannel;
-	CARDbSetMediaChannel(pDevice, byNewChannel);
-
-	return bResult;
-    }
+	if (byCount == 0) {
+		pDevice->vnt_mgmt.uCurrChannel = byNewChannel;
+		CARDbSetMediaChannel(pDevice, byNewChannel);
+		return bResult;
+	}
     pDevice->byChannelSwitchCount = byCount;
     pDevice->byNewChannel = byNewChannel;
     pDevice->bChannelSwitch = TRUE;
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index eb8a311..1d2e234 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -392,7 +392,7 @@ typedef struct __device_opt {
 } OPTIONS, *POPTIONS;
 

-typedef struct vnt_private {
+struct vnt_private {
 
 // netdev
 	struct usb_device*          usb;
@@ -524,9 +524,8 @@ typedef struct vnt_private {
     unsigned long                       RcvBuffersInUse;
 

-    // 802.11 management
+	/* 802.11 management */
 	struct vnt_manager vnt_mgmt;
-    SMgmtObject                 sMgmtObj;
 
 	u64 qwCurrTSF;
     unsigned int                        cbBulkInMax;
@@ -815,7 +814,7 @@ typedef struct vnt_private {
 	struct iw_statistics	wstats;		// wireless stats
     BOOL                    bCommit;
 
-} DEVICE_INFO, *PSDevice;
+};
 


diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index b627860..6c98172 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -850,9 +850,9 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, PRCB pRCB,
             RSC += wRxTSC15_0;
 		memcpy(&(pKey->KeyRSC), &RSC,  sizeof(u64));
 
-            if ( (pDevice->sMgmtObj.eCurrMode == WMAC_MODE_ESS_STA) &&
-                 (pDevice->sMgmtObj.eCurrState == WMAC_STATE_ASSOC)) {
-                // check RSC
+		if (pDevice->vnt_mgmt.eCurrMode == WMAC_MODE_ESS_STA &&
+			pDevice->vnt_mgmt.eCurrState == WMAC_STATE_ASSOC) {
+			/* check RSC */
                 if ( (wRxTSC15_0 < wLocalTSC15_0) &&
                      (dwRxTSC47_16 <= dwLocalTSC47_16) &&
                      !((dwRxTSC47_16 == 0) && (dwLocalTSC47_16 == 0xFFFFFFFF))) {
@@ -927,7 +927,7 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, PRCB pRCB,
 static int s_bAPModeRxCtl(struct vnt_private *pDevice, u8 *pbyFrame,
 	s32 iSANodeIndex)
 {
-	struct vnt_manager *pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	PS802_11Header p802_11Header;
 	CMD_STATUS Status;
 
@@ -1456,7 +1456,7 @@ void RXvMngWorkItem(struct vnt_private *pDevice)
         }
         ASSERT(pRCB);// cannot be NULL
         pRxPacket = &(pRCB->sMngPacket);
-	vMgrRxManagePacket((void *) pDevice, &(pDevice->sMgmtObj), pRxPacket);
+	vMgrRxManagePacket(pDevice, &pDevice->vnt_mgmt, pRxPacket);
         pRCB->Ref--;
         if(pRCB->Ref == 0) {
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"RxvFreeMng %d %d\n",pDevice->NumRecvFreeList, pDevice->NumRecvMngList);
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index dd732bc..76d307b 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -246,10 +246,9 @@ void MACvSetKeyEntry(struct vnt_private *pDevice, u16 wKeyCtl, u32 uEntryIdx,
 	int ii;
 	u8 pbyData[24];
 
-    if ( pDevice->byLocalID <= MAC_REVISION_A1 ) {
-        if ( pDevice->sMgmtObj.byCSSPK == KEY_CTL_CCMP )
-            return;
-    }
+	if (pDevice->byLocalID <= MAC_REVISION_A1)
+		if (pDevice->vnt_mgmt.byCSSPK == KEY_CTL_CCMP)
+			return;
 
     wOffset = MISCFIFO_KEYETRY0;
     wOffset += (uEntryIdx * MISCFIFO_KEYENTRYSIZE);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index a316d89..99ac7eb 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -706,7 +706,7 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	spin_lock_init(&pDevice->lock);
 
 	pDevice->tx_80211 = device_dma0_tx_80211;
-	pDevice->sMgmtObj.pAdapter = (void *) pDevice;
+	pDevice->vnt_mgmt.pAdapter = (void *) pDevice;
 
 	netdev->netdev_ops = &device_netdev_ops;
 	netdev->wireless_handlers =
@@ -986,7 +986,8 @@ static int  device_open(struct net_device *dev)
     // Init for Key Management
 
     KeyvInitTable(pDevice,&pDevice->sKey);
-    memcpy(pDevice->sMgmtObj.abyMACAddr, pDevice->abyCurrentNetAddr, ETH_ALEN);
+	memcpy(pDevice->vnt_mgmt.abyMACAddr,
+		pDevice->abyCurrentNetAddr, ETH_ALEN);
     memcpy(pDevice->dev->dev_addr, pDevice->abyCurrentNetAddr, ETH_ALEN);
     pDevice->bStopTx0Pkt = FALSE;
     pDevice->bStopDataPkt = FALSE;
@@ -1001,7 +1002,7 @@ static int  device_open(struct net_device *dev)
     tasklet_init(&pDevice->RxMngWorkItem, (void *)RXvMngWorkItem, (unsigned long)pDevice);
     tasklet_init(&pDevice->ReadWorkItem, (void *)RXvWorkItem, (unsigned long)pDevice);
     tasklet_init(&pDevice->EventWorkItem, (void *)INTvWorkItem, (unsigned long)pDevice);
-    add_timer(&(pDevice->sMgmtObj.sTimerSecondCallback));
+	add_timer(&pDevice->vnt_mgmt.sTimerSecondCallback);
     pDevice->int_interval = 100;  //Max 100 microframes.
     pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 
@@ -1035,14 +1036,10 @@ static int  device_open(struct net_device *dev)
          pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
     }
 
-    if (pDevice->sMgmtObj.eConfigMode == WMAC_CONFIG_AP) {
+	if (pDevice->vnt_mgmt.eConfigMode == WMAC_CONFIG_AP)
 		bScheduleCommand((void *) pDevice, WLAN_CMD_RUN_AP, NULL);
-	}
-	else {
-	//mike:mark@2008-11-10
-	  bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, NULL);
-	  /* bScheduleCommand((void *) pDevice, WLAN_CMD_SSID, NULL); */
-    }
+	else
+		bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, NULL);
 

     netif_stop_queue(pDevice->dev);
diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 06cff8b..5785eec 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -888,14 +888,22 @@ int RFbRawSetPower(struct vnt_private *pDevice, u8 byPwr, u32 uRATE)
                 bResult &= IFRFbWriteEmbedded(pDevice, dwVT3226Pwr);
 
                 bResult &= IFRFbWriteEmbedded(pDevice, 0x03C6A200+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
-                if (pDevice->sMgmtObj.eScanState != WMAC_NO_SCANNING) {
-                    // scanning, the channel number is pDevice->uScanChannel
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"@@@@ RFbRawSetPower> 11B mode uCurrChannel[%d]\n", pDevice->sMgmtObj.uScanChannel);
-                    bResult &= IFRFbWriteEmbedded(pDevice, dwVT3226D0LoCurrentTable[pDevice->sMgmtObj.uScanChannel-1]); //RobertYu:20060420, sometimes didn't change channel just set power with different rate
-                } else {
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"@@@@ RFbRawSetPower> 11B mode uCurrChannel[%d]\n", pDevice->sMgmtObj.uCurrChannel);
-                    bResult &= IFRFbWriteEmbedded(pDevice, dwVT3226D0LoCurrentTable[pDevice->sMgmtObj.uCurrChannel-1]); //RobertYu:20060420, sometimes didn't change channel just set power with different rate
-                }
+		if (pDevice->vnt_mgmt.eScanState != WMAC_NO_SCANNING) {
+			/* scanning, channel number is pDevice->uScanChannel */
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"RFbRawSetPower> 11B mode uCurrChannel[%d]\n",
+				pDevice->vnt_mgmt.uScanChannel);
+			bResult &= IFRFbWriteEmbedded(pDevice,
+				dwVT3226D0LoCurrentTable[pDevice->
+					vnt_mgmt.uScanChannel - 1]);
+		} else {
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"RFbRawSetPower> 11B mode uCurrChannel[%d]\n",
+				pDevice->vnt_mgmt.uCurrChannel);
+			bResult &= IFRFbWriteEmbedded(pDevice,
+				dwVT3226D0LoCurrentTable[pDevice->
+					vnt_mgmt.uCurrChannel - 1]);
+		}
 
                 bResult &= IFRFbWriteEmbedded(pDevice, 0x015C0800+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW); //RobertYu:20060420, ok now, new switching power (mini-pci can have bigger power consumption)
             } else {
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index bb014c0..536d314 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1511,10 +1511,10 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 
         ///////////////////////////////////////////////////////////////////
 
-        if (pDevice->sMgmtObj.eAuthenMode == WMAC_AUTH_WPANONE) {
-            dwMICKey0 = *(PDWORD)(&pTransmitKey->abyKey[16]);
-            dwMICKey1 = *(PDWORD)(&pTransmitKey->abyKey[20]);
-        }
+	if (pDevice->vnt_mgmt.eAuthenMode == WMAC_AUTH_WPANONE) {
+		dwMICKey0 = *(u32 *)(&pTransmitKey->abyKey[16]);
+		dwMICKey1 = *(u32 *)(&pTransmitKey->abyKey[20]);
+	}
         else if ((pTransmitKey->dwKeyIndex & AUTHENTICATOR_KEY) != 0) {
             dwMICKey0 = *(PDWORD)(&pTransmitKey->abyKey[16]);
             dwMICKey1 = *(PDWORD)(&pTransmitKey->abyKey[20]);
diff --git a/drivers/staging/vt6656/wmgr.h b/drivers/staging/vt6656/wmgr.h
index 86c1505..5112f53 100644
--- a/drivers/staging/vt6656/wmgr.h
+++ b/drivers/staging/vt6656/wmgr.h
@@ -219,15 +219,15 @@ typedef enum tagWMAC_POWER_MODE {
 

 /* Tx Management Packet descriptor */
-typedef struct vnt_tx_mgmt {
+struct vnt_tx_mgmt {
 	PUWLAN_80211HDR p80211Header;
 	u32 cbMPDULen;
 	u32 cbPayloadLen;
-} STxMgmtPacket, *PSTxMgmtPacket;
+};
 

 /* Rx Management Packet descriptor */
-typedef struct vnt_rx_mgmt {
+struct vnt_rx_mgmt {
 	PUWLAN_80211HDR p80211Header;
 	u64 qwLocalTSF;
 	u32 cbMPDULen;
@@ -236,10 +236,10 @@ typedef struct vnt_rx_mgmt {
 	u8 bySQ;
 	u8 byRxRate;
 	u8 byRxChannel;
-} SRxMgmtPacket, *PSRxMgmtPacket;
+};
 

-typedef struct vnt_manager {
+struct vnt_manager {
 	void *pAdapter;
     // MAC address
     BYTE                    abyMACAddr[WLAN_ADDR_LEN];
@@ -391,7 +391,7 @@ typedef struct vnt_manager {
 
     struct sk_buff  skb;
 
-} SMgmtObject, *PSMgmtObject;
+};
 
 /*---------------------  Export Macros ------------------------------*/
 
-- 
1.8.0



