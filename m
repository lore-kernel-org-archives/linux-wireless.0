Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:53417 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbaBOV4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Feb 2014 16:56:34 -0500
Received: by mail-wg0-f43.google.com with SMTP id a1so1303054wgh.10
        for <linux-wireless@vger.kernel.org>; Sat, 15 Feb 2014 13:56:32 -0800 (PST)
Message-ID: <1392501380.4022.3.camel@canaries32-MCP7A> (sfid-20140215_225659_843483_6F9A3CF5)
Subject: [PATCH 1/3 RESEND] staging: vt6656: Replace typedef enum
 _CARD_OP_MODE
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sat, 15 Feb 2014 21:56:20 +0000
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace typedef enum _CARD_OP_MODE eOPMode with op_mode enum nl80211_iftype

enum changes
OP_MODE_INFRASTRUCTURE -> NL80211_IFTYPE_STATION
OP_MODE_AP -> NL80211_IFTYPE_AP
OP_MODE_DEF -> NL80211_IFTYPE_UNSPECIFIED
OP_MODE_ADHOC -> NL80211_IFTYPE_ADHOC

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.h     |  7 -------
 drivers/staging/vt6656/device.h   |  4 +++-
 drivers/staging/vt6656/dpc.c      |  2 +-
 drivers/staging/vt6656/int.c      |  4 ++--
 drivers/staging/vt6656/iwctl.c    |  2 +-
 drivers/staging/vt6656/main_usb.c |  2 +-
 drivers/staging/vt6656/power.c    |  6 +++---
 drivers/staging/vt6656/rxtx.c     | 23 ++++++++++++-----------
 drivers/staging/vt6656/wmgr.c     |  8 ++++----
 9 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index c3017a7..f843e50 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -39,13 +39,6 @@ typedef enum _CARD_PHY_TYPE {
     PHY_TYPE_11A
 } CARD_PHY_TYPE, *PCARD_PHY_TYPE;
 
-typedef enum _CARD_OP_MODE {
-    OP_MODE_INFRASTRUCTURE = 0,
-    OP_MODE_ADHOC,
-    OP_MODE_AP,
-    OP_MODE_UNKNOWN
-} CARD_OP_MODE, *PCARD_OP_MODE;
-
 #define CB_MAX_CHANNEL_24G  14
 #define CB_MAX_CHANNEL_5G       42 /* add channel9(5045MHz), 41==>42 */
 #define CB_MAX_CHANNEL      (CB_MAX_CHANNEL_24G+CB_MAX_CHANNEL_5G)
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 1f42257..2bca7c0 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -588,7 +588,9 @@ struct vnt_private {
 	u16 wFragmentationThreshold;
 	u8 byShortRetryLimit;
 	u8 byLongRetryLimit;
-	CARD_OP_MODE eOPMode;
+
+	enum nl80211_iftype op_mode;
+
 	int bBSSIDFilter;
 	u16 wMaxTransmitMSDULifetime;
 	u8 abyBSSID[ETH_ALEN];
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index eca04c0..03351e7 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -627,7 +627,7 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, struct vnt_rcb *pRCB,
 
     // Now it only supports 802.11g Infrastructure Mode, and support rate must up to 54 Mbps
     if (pDevice->bDiversityEnable && (FrameSize>50) &&
-       (pDevice->eOPMode == OP_MODE_INFRASTRUCTURE) &&
+	pDevice->op_mode == NL80211_IFTYPE_STATION &&
        (pDevice->bLinkPass == true)) {
         BBvAntennaDiversity(pDevice, s_byGetRateIdx(*pbyRxRate), 0);
     }
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index e0e9386..d12036a 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -131,7 +131,7 @@ void INTnsProcessData(struct vnt_private *pDevice)
 	}
 	if (pINTData->byISR0 != 0) {
 		if (pINTData->byISR0 & ISR_BNTX) {
-			if (pDevice->eOPMode == OP_MODE_AP) {
+			if (pDevice->op_mode == NL80211_IFTYPE_AP) {
 				if (pMgmt->byDTIMCount > 0) {
 					pMgmt->byDTIMCount--;
 					pMgmt->sNodeDBTable[0].bRxPSPoll =
@@ -149,7 +149,7 @@ void INTnsProcessData(struct vnt_private *pDevice)
 				bScheduleCommand((void *) pDevice,
 						WLAN_CMD_BECON_SEND,
 						NULL);
-			} /* if (pDevice->eOPMode == OP_MODE_AP) */
+			}
 		pDevice->bBeaconSent = true;
 		} else {
 			pDevice->bBeaconSent = false;
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 3a68dfa..23320cc 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -57,7 +57,7 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 	struct vnt_private *pDevice = netdev_priv(dev);
 	long ldBm;
 
-	pDevice->wstats.status = pDevice->eOPMode;
+	pDevice->wstats.status = pDevice->op_mode;
 	RFvRSSITodBm(pDevice, (u8)(pDevice->uCurrRSSI), &ldBm);
 	pDevice->wstats.qual.level = ldBm;
 	pDevice->wstats.qual.noise = 0;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 664781c..4f913d3 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -256,7 +256,7 @@ device_set_options(struct vnt_private *pDevice) {
     pDevice->byShortPreamble = PREAMBLE_TYPE_DEF;
     pDevice->ePSMode = PS_MODE_DEF;
     pDevice->b11hEnable = X80211h_MODE_DEF;
-    pDevice->eOPMode = OP_MODE_DEF;
+    pDevice->op_mode = NL80211_IFTYPE_UNSPECIFIED;
     pDevice->uConnectionRate = DATA_RATE_DEF;
     if (pDevice->uConnectionRate < RATE_AUTO) pDevice->bFixRate = true;
     pDevice->byBBType = BBP_TYPE_DEF;
diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index e7d5487..cd4f5bd 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -67,7 +67,7 @@ void PSvEnablePowerSaving(struct vnt_private *pDevice, u16 wListenInterval)
 	/* set period of power up before TBTT */
 	MACvWriteWord(pDevice, MAC_REG_PWBT, C_PWBT);
 
-	if (pDevice->eOPMode != OP_MODE_ADHOC) {
+	if (pDevice->op_mode != NL80211_IFTYPE_ADHOC) {
 		/* set AID */
 		MACvWriteWord(pDevice, MAC_REG_AIDATIM, wAID);
 	} else {
@@ -106,7 +106,7 @@ void PSvEnablePowerSaving(struct vnt_private *pDevice, u16 wListenInterval)
 	pDevice->bEnablePSMode = true;
 
 	/* We don't send null pkt in ad hoc mode since beacon will handle this. */
-	if (pDevice->eOPMode == OP_MODE_INFRASTRUCTURE)
+	if (pDevice->op_mode == NL80211_IFTYPE_STATION)
 		PSbSendNullPacket(pDevice);
 
 	pDevice->bPWBitOn = true;
@@ -137,7 +137,7 @@ void PSvDisablePowerSaving(struct vnt_private *pDevice)
 	MACvRegBitsOn(pDevice, MAC_REG_PSCTL, PSCTL_ALBCN);
 	pDevice->bEnablePSMode = false;
 
-	if (pDevice->eOPMode == OP_MODE_INFRASTRUCTURE)
+	if (pDevice->op_mode == NL80211_IFTYPE_STATION)
 		PSbSendNullPacket(pDevice);
 
 	pDevice->bPWBitOn = false;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 51fff89..92146e5 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -553,12 +553,13 @@ static int vnt_fill_ieee80211_rts(struct vnt_private *priv,
 	rts->duration = duration;
 	rts->frame_control = TYPE_CTL_RTS;
 
-	if (priv->eOPMode == OP_MODE_ADHOC || priv->eOPMode == OP_MODE_AP)
+	if (priv->op_mode == NL80211_IFTYPE_ADHOC ||
+				priv->op_mode == NL80211_IFTYPE_AP)
 		memcpy(rts->ra, eth_hdr->h_dest, ETH_ALEN);
 	else
 		memcpy(rts->ra, priv->abyBSSID, ETH_ALEN);
 
-	if (priv->eOPMode == OP_MODE_AP)
+	if (priv->op_mode == NL80211_IFTYPE_AP)
 		memcpy(rts->ta, priv->abyBSSID, ETH_ALEN);
 	else
 		memcpy(rts->ta, eth_hdr->h_source, ETH_ALEN);
@@ -991,8 +992,8 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
     //Set packet type
     pTxBufHead->wFIFOCtl |= (u16)(byPktType<<8);
 
-	if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
-			(pDevice->eOPMode == OP_MODE_AP)) {
+	if (pDevice->op_mode == NL80211_IFTYPE_ADHOC ||
+			pDevice->op_mode == NL80211_IFTYPE_AP) {
 		if (is_multicast_ether_addr(psEthHeader->h_dest)) {
 			bNeedACK = false;
 			pTxBufHead->wFIFOCtl =
@@ -1292,7 +1293,7 @@ static void s_vGenerateMACHeader(struct vnt_private *pDevice,
 
 	pMACHeader->frame_control = TYPE_802_11_DATA;
 
-    if (pDevice->eOPMode == OP_MODE_AP) {
+    if (pDevice->op_mode == NL80211_IFTYPE_AP) {
 	memcpy(&(pMACHeader->addr1[0]),
 	       &(psEthHeader->h_dest[0]),
 	       ETH_ALEN);
@@ -1302,7 +1303,7 @@ static void s_vGenerateMACHeader(struct vnt_private *pDevice,
 	       ETH_ALEN);
         pMACHeader->frame_control |= FC_FROMDS;
     } else {
-	if (pDevice->eOPMode == OP_MODE_ADHOC) {
+	if (pDevice->op_mode == NL80211_IFTYPE_ADHOC) {
 		memcpy(&(pMACHeader->addr1[0]),
 		       &(psEthHeader->h_dest[0]),
 		       ETH_ALEN);
@@ -1541,8 +1542,8 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
         pbyIVHead = (u8 *)(pbyTxBufferAddr + cbHeaderSize + cbMacHdLen + uPadding);
         pbyPayloadHead = (u8 *)(pbyTxBufferAddr + cbHeaderSize + cbMacHdLen + uPadding + cbIVlen);
         do {
-            if ((pDevice->eOPMode == OP_MODE_INFRASTRUCTURE) &&
-                (pDevice->bLinkPass == true)) {
+	    if (pDevice->op_mode == NL80211_IFTYPE_STATION &&
+					pDevice->bLinkPass == true) {
                 pbyBSSID = pDevice->abyBSSID;
                 // get pairwise key
                 if (KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, PAIRWISE_KEY, &pTransmitKey) == false) {
@@ -1560,7 +1561,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
             pbyBSSID = pDevice->abyBroadcastAddr;
             if(KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, GROUP_KEY, &pTransmitKey) == false) {
                 pTransmitKey = NULL;
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"KEY is NULL. OP Mode[%d]\n", pDevice->eOPMode);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"KEY is NULL. OP Mode[%d]\n", pDevice->op_mode);
             } else {
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Get GTK.\n");
             }
@@ -2305,7 +2306,7 @@ int nsDMA_tx_packet(struct vnt_private *pDevice,
         }
     }
     else {
-        if (pDevice->eOPMode == OP_MODE_ADHOC) {
+	if (pDevice->op_mode == NL80211_IFTYPE_ADHOC) {
             // Adhoc Tx rate decided from node DB
 	    if (is_multicast_ether_addr(pDevice->sTxEthHeader.h_dest)) {
                 // Multicast use highest data rate
@@ -2336,7 +2337,7 @@ int nsDMA_tx_packet(struct vnt_private *pDevice,
                 }
             }
         }
-        if (pDevice->eOPMode == OP_MODE_INFRASTRUCTURE) {
+	if (pDevice->op_mode == NL80211_IFTYPE_STATION) {
             // Infra STA rate decided from AP Node, index = 0
             pDevice->wCurrentRate = pMgmt->sNodeDBTable[0].wTxDataRate;
         }
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index d74b0e7..0d69719 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -2164,12 +2164,12 @@ void vMgrCreateOwnIBSS(struct vnt_private *pDevice, PCMD_STATUS pStatus)
         pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_ESS(1);
         pMgmt->byDTIMPeriod = DEFAULT_DTIM_PERIOD;
         pMgmt->byDTIMCount = pMgmt->byDTIMPeriod - 1;
-        pDevice->eOPMode = OP_MODE_AP;
+	pDevice->op_mode = NL80211_IFTYPE_AP;
     }
 
     if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
         pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_IBSS(1);
-        pDevice->eOPMode = OP_MODE_ADHOC;
+	pDevice->op_mode = NL80211_IFTYPE_ADHOC;
     }
 
     if (pDevice->bEncryptionEnable) {
@@ -2359,7 +2359,7 @@ void vMgrJoinBSSBegin(struct vnt_private *pDevice, PCMD_STATUS pStatus)
 
             pMgmt->eCurrState = WMAC_STATE_JOINTED;
             // Adopt BSS state in Adapter Device Object
-            pDevice->eOPMode = OP_MODE_INFRASTRUCTURE;
+	    pDevice->op_mode = NL80211_IFTYPE_STATION;
             memcpy(pDevice->abyBSSID, pCurr->abyBSSID, WLAN_BSSID_LEN);
 
             // Add current BSS to Candidate list
@@ -2500,7 +2500,7 @@ void vMgrJoinBSSBegin(struct vnt_private *pDevice, PCMD_STATUS pStatus)
             pMgmt->eCurrMode = WMAC_MODE_IBSS_STA;
             pMgmt->eCurrState = WMAC_STATE_STARTED;
             // Adopt BSS state in Adapter Device Object
-            pDevice->eOPMode = OP_MODE_ADHOC;
+	    pDevice->op_mode = NL80211_IFTYPE_ADHOC;
             pDevice->bLinkPass = true;
             ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_INTER);
             memcpy(pDevice->abyBSSID, pCurr->abyBSSID, WLAN_BSSID_LEN);
-- 
1.9.rc1

