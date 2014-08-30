Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:42054 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaH3V1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:27:04 -0400
Received: by mail-we0-f173.google.com with SMTP id t60so3709757wes.32
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:27:02 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 23/23] staging: vt6655: Replace typedef enum _CARD_OP_MODE eOPMode with enum nl80211_iftype op_mode.
Date: Sat, 30 Aug 2014 22:25:49 +0100
Message-Id: <1409433949-5468-23-git-send-email-tvboxspy@gmail.com> (sfid-20140830_234534_036662_D7F453F3)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using the nl80211 header.

Using enum changes
OP_MODE_ADHOC -> NL80211_IFTYPE_ADHOC
OP_MODE_AP ->  NL80211_IFTYPE_AP
OP_MODE_INFRASTRUCTURE -> NL80211_IFTYPE_STATION
OP_MODE_UNKNOWN -> NL80211_IFTYPE_UNSPECIFIED

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c        | 12 ++++-----
 drivers/staging/vt6655/card.h        | 10 ++------
 drivers/staging/vt6655/device.h      |  2 +-
 drivers/staging/vt6655/device_main.c | 14 +++++-----
 drivers/staging/vt6655/dpc.c         |  2 +-
 drivers/staging/vt6655/iwctl.c       |  2 +-
 drivers/staging/vt6655/power.c       |  7 ++---
 drivers/staging/vt6655/rxtx.c        | 50 ++++++++++++++++++------------------
 drivers/staging/vt6655/wcmd.c        | 12 ++++-----
 drivers/staging/vt6655/wmgr.c        |  8 +++---
 10 files changed, 57 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index c4ed8d5..5a69502 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -698,7 +698,7 @@ bool CARDbStartTxPacket(struct vnt_private *pDevice, CARD_PKT_TYPE ePktType)
 
 	if ((pDevice->bStopBeacon == false) &&
 	    (pDevice->bBeaconBufReady == true) &&
-	    (pDevice->eOPMode == OP_MODE_ADHOC)) {
+	    (pDevice->op_mode == NL80211_IFTYPE_ADHOC)) {
 		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_TCR, TCR_AUTOBCNTX);
 	}
 
@@ -720,22 +720,22 @@ bool CARDbStartTxPacket(struct vnt_private *pDevice, CARD_PKT_TYPE ePktType)
  *
  */
 bool CARDbSetBSSID(struct vnt_private *pDevice,
-		   unsigned char *pbyBSSID, CARD_OP_MODE eOPMode)
+		   unsigned char *pbyBSSID, enum nl80211_iftype op_mode)
 {
 
 	MACvWriteBSSIDAddress(pDevice->PortOffset, pbyBSSID);
 	memcpy(pDevice->abyBSSID, pbyBSSID, WLAN_BSSID_LEN);
-	if (eOPMode == OP_MODE_ADHOC)
+	if (op_mode == NL80211_IFTYPE_ADHOC)
 		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_HOSTCR, HOSTCR_ADHOC);
 	else
 		MACvRegBitsOff(pDevice->PortOffset, MAC_REG_HOSTCR, HOSTCR_ADHOC);
 
-	if (eOPMode == OP_MODE_AP)
+	if (op_mode == NL80211_IFTYPE_AP)
 		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_HOSTCR, HOSTCR_AP);
 	else
 		MACvRegBitsOff(pDevice->PortOffset, MAC_REG_HOSTCR, HOSTCR_AP);
 
-	if (eOPMode == OP_MODE_UNKNOWN) {
+	if (op_mode == NL80211_IFTYPE_UNSPECIFIED) {
 		MACvRegBitsOff(pDevice->PortOffset, MAC_REG_RCR, RCR_BSSID);
 		pDevice->bBSSIDFilter = false;
 		pDevice->byRxMode &= ~RCR_BSSID;
@@ -749,7 +749,7 @@ bool CARDbSetBSSID(struct vnt_private *pDevice,
 		pr_debug("wmgr: rx_mode = %x\n", pDevice->byRxMode);
 	}
 	// Adopt BSS state in Adapter Device Object
-	pDevice->eOPMode = eOPMode;
+	pDevice->op_mode = op_mode;
 	return true;
 }
 
diff --git a/drivers/staging/vt6655/card.h b/drivers/staging/vt6655/card.h
index f7fd834..96f5b6c 100644
--- a/drivers/staging/vt6655/card.h
+++ b/drivers/staging/vt6655/card.h
@@ -31,6 +31,7 @@
 
 #include "ttype.h"
 #include <linux/types.h>
+#include <linux/nl80211.h>
 
 //
 // Loopback mode
@@ -70,13 +71,6 @@ typedef enum _CARD_STATUS_TYPE {
 	CARD_STATUS_PMKID
 } CARD_STATUS_TYPE, *PCARD_STATUS_TYPE;
 
-typedef enum _CARD_OP_MODE {
-	OP_MODE_INFRASTRUCTURE,
-	OP_MODE_ADHOC,
-	OP_MODE_AP,
-	OP_MODE_UNKNOWN
-} CARD_OP_MODE, *PCARD_OP_MODE;
-
 struct vnt_private;
 
 void CARDvSetRSPINF(struct vnt_private *, CARD_PHY_TYPE ePHYType);
@@ -108,7 +102,7 @@ bool CARDbStopTxPacket(struct vnt_private *, CARD_PKT_TYPE ePktType);
 bool CARDbStartTxPacket(struct vnt_private *, CARD_PKT_TYPE ePktType);
 bool CARDbSetBeaconPeriod(struct vnt_private *, unsigned short wBeaconInterval);
 bool CARDbSetBSSID(struct vnt_private *,
-		   unsigned char *pbyBSSID, CARD_OP_MODE eOPMode);
+		   unsigned char *pbyBSSID, enum nl80211_iftype);
 
 bool CARDbPowerDown(struct vnt_private *);
 
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 15303d9..7db0404 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -470,7 +470,7 @@ struct vnt_private {
 	unsigned short wFragmentationThreshold;
 	unsigned char byShortRetryLimit;
 	unsigned char byLongRetryLimit;
-	CARD_OP_MODE                eOPMode;
+	enum nl80211_iftype op_mode;
 	unsigned char byOpMode;
 	bool bBSSIDFilter;
 	unsigned short wMaxTransmitMSDULifetime;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 0473702..f33795f 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -2341,7 +2341,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 				}
 			}
 			if (pDevice->bChannelSwitch &&
-			    (pDevice->eOPMode == OP_MODE_INFRASTRUCTURE)) {
+			    (pDevice->op_mode == NL80211_IFTYPE_STATION)) {
 				pDevice->byChannelSwitchCount--;
 				if (pDevice->byChannelSwitchCount == 0) {
 					pDevice->bChannelSwitch = false;
@@ -2354,7 +2354,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 
 				}
 			}
-			if (pDevice->eOPMode != OP_MODE_ADHOC) {
+			if (pDevice->op_mode != NL80211_IFTYPE_ADHOC) {
 				if ((pDevice->bUpdateBBVGA) && pDevice->bLinkPass && (pDevice->uCurrRSSI != 0)) {
 					long            ldBm;
 
@@ -2394,8 +2394,8 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 			if (pDevice->bEnablePSMode)
 				PSbIsNextTBTTWakeUp((void *)pDevice);
 
-			if ((pDevice->eOPMode == OP_MODE_AP) ||
-			    (pDevice->eOPMode == OP_MODE_ADHOC)) {
+			if ((pDevice->op_mode == NL80211_IFTYPE_AP) ||
+			    (pDevice->op_mode == NL80211_IFTYPE_ADHOC)) {
 				MACvOneShotTimer1MicroSec(pDevice->PortOffset,
 							  (pMgmt->wIBSSBeaconPeriod - MAKE_BEACON_RESERVED) << 10);
 			}
@@ -2405,12 +2405,12 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 		}
 
 		if (pDevice->dwIsr & ISR_BNTX) {
-			if (pDevice->eOPMode == OP_MODE_ADHOC) {
+			if (pDevice->op_mode == NL80211_IFTYPE_ADHOC) {
 				pDevice->bIsBeaconBufReadySet = false;
 				pDevice->cbBeaconBufReadySetCnt = 0;
 			}
 
-			if (pDevice->eOPMode == OP_MODE_AP) {
+			if (pDevice->op_mode == NL80211_IFTYPE_AP) {
 				if (pMgmt->byDTIMCount > 0) {
 					pMgmt->byDTIMCount--;
 					pMgmt->sNodeDBTable[0].bRxPSPoll = false;
@@ -2453,7 +2453,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 			max_count += device_tx_srv(pDevice, TYPE_AC0DMA);
 
 		if (pDevice->dwIsr & ISR_SOFTTIMER1) {
-			if (pDevice->eOPMode == OP_MODE_AP) {
+			if (pDevice->op_mode == NL80211_IFTYPE_AP) {
 				if (pDevice->bShortSlotTime)
 					pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SHORTSLOTTIME(1);
 				else
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index 60eb129..6fb6cdf 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -603,7 +603,7 @@ device_receive_frame(
 
 	// Now it only supports 802.11g Infrastructure Mode, and support rate must up to 54 Mbps
 	if (pDevice->bDiversityEnable && (FrameSize > 50) &&
-	    (pDevice->eOPMode == OP_MODE_INFRASTRUCTURE) &&
+	    (pDevice->op_mode == NL80211_IFTYPE_STATION) &&
 	    pDevice->bLinkPass) {
 		BBvAntennaDiversity(pDevice, s_byGetRateIdx(*pbyRxRate), 0);
 	}
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 6a6bdd3..14a62bd 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -76,7 +76,7 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 	struct vnt_private *pDevice = netdev_priv(dev);
 	long ldBm;
 
-	pDevice->wstats.status = pDevice->eOPMode;
+	pDevice->wstats.status = pDevice->op_mode;
 #ifdef Calcu_LinkQual
 	if (pDevice->scStatistic.LinkQuality > 100)
 		pDevice->scStatistic.LinkQuality = 100;
diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index 93681b3..08241b9 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -78,7 +78,7 @@ PSvEnablePowerSaving(
 
 	// set period of power up before TBTT
 	VNSvOutPortW(pDevice->PortOffset + MAC_REG_PWBT, C_PWBT);
-	if (pDevice->eOPMode != OP_MODE_ADHOC) {
+	if (pDevice->op_mode != NL80211_IFTYPE_ADHOC) {
 		// set AID
 		VNSvOutPortW(pDevice->PortOffset + MAC_REG_AIDATIM, wAID);
 	} else {
@@ -107,7 +107,8 @@ PSvEnablePowerSaving(
 	pDevice->bEnablePSMode = true;
 
 	/* We don't send null pkt in ad hoc mode since beacon will handle this. */
-	if (pDevice->eOPMode != OP_MODE_ADHOC && pDevice->eOPMode == OP_MODE_INFRASTRUCTURE)
+	if (pDevice->op_mode != NL80211_IFTYPE_ADHOC &&
+	    pDevice->op_mode == NL80211_IFTYPE_STATION)
 		PSbSendNullPacket(pDevice);
 
 	pDevice->bPWBitOn = true;
@@ -142,7 +143,7 @@ PSvDisablePowerSaving(
 
 	pDevice->bEnablePSMode = false;
 
-	if (pDevice->eOPMode == OP_MODE_INFRASTRUCTURE)
+	if (pDevice->op_mode == NL80211_IFTYPE_STATION)
 		PSbSendNullPacket(pDevice);
 
 	pDevice->bPWBitOn = false;
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 0c69193..7a183f5 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -851,13 +851,13 @@ s_vFillRTSHead(
 						    IEEE80211_STYPE_RTS);
 
 
-			if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
-			    (pDevice->eOPMode == OP_MODE_AP)) {
+			if ((pDevice->op_mode == NL80211_IFTYPE_ADHOC) ||
+			    (pDevice->op_mode == NL80211_IFTYPE_AP)) {
 				memcpy(&buf->data.ra, psEthHeader->abyDstAddr, ETH_ALEN);
 			} else {
 				memcpy(&buf->data.ra, pDevice->abyBSSID, ETH_ALEN);
 			}
-			if (pDevice->eOPMode == OP_MODE_AP)
+			if (pDevice->op_mode == NL80211_IFTYPE_AP)
 				memcpy(&buf->data.ta, pDevice->abyBSSID, ETH_ALEN);
 			else
 				memcpy(&buf->data.ta, psEthHeader->abySrcAddr, ETH_ALEN);
@@ -915,14 +915,14 @@ s_vFillRTSHead(
 						    IEEE80211_STYPE_RTS);
 
 
-			if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
-			    (pDevice->eOPMode == OP_MODE_AP)) {
+			if ((pDevice->op_mode == NL80211_IFTYPE_ADHOC) ||
+			    (pDevice->op_mode == NL80211_IFTYPE_AP)) {
 				memcpy(&buf->data.ra, psEthHeader->abyDstAddr, ETH_ALEN);
 			} else {
 				memcpy(&buf->data.ra, pDevice->abyBSSID, ETH_ALEN);
 			}
 
-			if (pDevice->eOPMode == OP_MODE_AP)
+			if (pDevice->op_mode == NL80211_IFTYPE_AP)
 				memcpy(&buf->data.ta, pDevice->abyBSSID, ETH_ALEN);
 			else
 				memcpy(&buf->data.ta, psEthHeader->abySrcAddr, ETH_ALEN);
@@ -948,14 +948,14 @@ s_vFillRTSHead(
 						    IEEE80211_STYPE_RTS);
 
 
-			if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
-			    (pDevice->eOPMode == OP_MODE_AP)) {
+			if ((pDevice->op_mode == NL80211_IFTYPE_ADHOC) ||
+			    (pDevice->op_mode == NL80211_IFTYPE_AP)) {
 				memcpy(&buf->data.ra, psEthHeader->abyDstAddr, ETH_ALEN);
 			} else {
 				memcpy(&buf->data.ra, pDevice->abyBSSID, ETH_ALEN);
 			}
 
-			if (pDevice->eOPMode == OP_MODE_AP)
+			if (pDevice->op_mode == NL80211_IFTYPE_AP)
 				memcpy(&buf->data.ta, pDevice->abyBSSID, ETH_ALEN);
 			else
 				memcpy(&buf->data.ta, psEthHeader->abySrcAddr, ETH_ALEN);
@@ -988,13 +988,13 @@ s_vFillRTSHead(
 					cpu_to_le16(IEEE80211_FTYPE_CTL |
 						    IEEE80211_STYPE_RTS);
 
-			if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
-			    (pDevice->eOPMode == OP_MODE_AP)) {
+			if ((pDevice->op_mode == NL80211_IFTYPE_ADHOC) ||
+			    (pDevice->op_mode == NL80211_IFTYPE_AP)) {
 				memcpy(&buf->data.ra, psEthHeader->abyDstAddr, ETH_ALEN);
 			} else {
 				memcpy(&buf->data.ra, pDevice->abyBSSID, ETH_ALEN);
 			}
-			if (pDevice->eOPMode == OP_MODE_AP)
+			if (pDevice->op_mode == NL80211_IFTYPE_AP)
 				memcpy(&buf->data.ta, pDevice->abyBSSID, ETH_ALEN);
 			else
 				memcpy(&buf->data.ta, psEthHeader->abySrcAddr, ETH_ALEN);
@@ -1016,14 +1016,14 @@ s_vFillRTSHead(
 		buf->data.frame_control =
 			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS);
 
-		if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
-		    (pDevice->eOPMode == OP_MODE_AP)) {
+		if ((pDevice->op_mode == NL80211_IFTYPE_ADHOC) ||
+		    (pDevice->op_mode == NL80211_IFTYPE_AP)) {
 			memcpy(&buf->data.ra, psEthHeader->abyDstAddr, ETH_ALEN);
 		} else {
 			memcpy(&buf->data.ra, pDevice->abyBSSID, ETH_ALEN);
 		}
 
-		if (pDevice->eOPMode == OP_MODE_AP)
+		if (pDevice->op_mode == NL80211_IFTYPE_AP)
 			memcpy(&buf->data.ta, pDevice->abyBSSID, ETH_ALEN);
 		else
 			memcpy(&buf->data.ta, psEthHeader->abySrcAddr, ETH_ALEN);
@@ -1335,8 +1335,8 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 
 	pvRrvTime = pMICHDR = pvRTS = pvCTS = pvTxDataHd = NULL;
 
-	if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
-	    (pDevice->eOPMode == OP_MODE_AP)) {
+	if ((pDevice->op_mode == NL80211_IFTYPE_ADHOC) ||
+	    (pDevice->op_mode == NL80211_IFTYPE_AP)) {
 		if (is_multicast_ether_addr(&(psEthHeader->abyDstAddr[0])))
 			bNeedACK = false;
 		else
@@ -1976,8 +1976,8 @@ vGenerateFIFOHeader(struct vnt_private *pDevice, unsigned char byPktType,
 	memset(pTxBufHead, 0, wTxBufSize);
 	//Set FIFOCTL_NEEDACK
 
-	if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
-	    (pDevice->eOPMode == OP_MODE_AP)) {
+	if ((pDevice->op_mode == NL80211_IFTYPE_ADHOC) ||
+	    (pDevice->op_mode == NL80211_IFTYPE_AP)) {
 		if (is_multicast_ether_addr(&(psEthHeader->abyDstAddr[0]))) {
 			bNeedACK = false;
 			pTxBufHead->wFIFOCtl = pTxBufHead->wFIFOCtl & (~FIFOCTL_NEEDACK);
@@ -2104,13 +2104,13 @@ vGenerateMACHeader(
 	else
 		pMACHeader->wFrameCtl = TYPE_802_11_DATA;
 
-	if (pDevice->eOPMode == OP_MODE_AP) {
+	if (pDevice->op_mode == NL80211_IFTYPE_AP) {
 		memcpy(&(pMACHeader->abyAddr1[0]), &(psEthHeader->abyDstAddr[0]), ETH_ALEN);
 		memcpy(&(pMACHeader->abyAddr2[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
 		memcpy(&(pMACHeader->abyAddr3[0]), &(psEthHeader->abySrcAddr[0]), ETH_ALEN);
 		pMACHeader->wFrameCtl |= FC_FROMDS;
 	} else {
-		if (pDevice->eOPMode == OP_MODE_ADHOC) {
+		if (pDevice->op_mode == NL80211_IFTYPE_ADHOC) {
 			memcpy(&(pMACHeader->abyAddr1[0]), &(psEthHeader->abyDstAddr[0]), ETH_ALEN);
 			memcpy(&(pMACHeader->abyAddr2[0]), &(psEthHeader->abySrcAddr[0]), ETH_ALEN);
 			memcpy(&(pMACHeader->abyAddr3[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
@@ -2349,7 +2349,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 		// S/W or H/W Encryption
 		//---------------------------
 		do {
-			if ((pDevice->eOPMode == OP_MODE_INFRASTRUCTURE) &&
+			if ((pDevice->op_mode == NL80211_IFTYPE_STATION) &&
 			    (pDevice->bLinkPass == true)) {
 				pbyBSSID = pDevice->abyBSSID;
 				// get pairwise key
@@ -2369,7 +2369,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 			if (KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, GROUP_KEY, &pTransmitKey) == false) {
 				pTransmitKey = NULL;
 				pr_debug("KEY is NULL. OP Mode[%d]\n",
-					 pDevice->eOPMode);
+					 pDevice->op_mode);
 			} else {
 				pr_debug("Get GTK\n");
 			}
@@ -2531,8 +2531,8 @@ cbGetFragCount(
 	unsigned int uMACfragNum = 1;
 	bool bNeedACK;
 
-	if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
-	    (pDevice->eOPMode == OP_MODE_AP)) {
+	if ((pDevice->op_mode == NL80211_IFTYPE_ADHOC) ||
+	    (pDevice->op_mode == NL80211_IFTYPE_AP)) {
 		if (is_multicast_ether_addr(&(psEthHeader->abyDstAddr[0])))
 			bNeedACK = false;
 		else
diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index 7565073..985e1b9 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -328,7 +328,7 @@ vCommandTimer(
 
 		if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
 			s_bCommandComplete(pDevice);
-			CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_AP);
+			CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, NL80211_IFTYPE_AP);
 			spin_unlock_irq(&pDevice->lock);
 			return;
 		}
@@ -356,9 +356,9 @@ vCommandTimer(
 			pr_debug("Scanning, set back to channel: [%d]\n",
 				 pMgmt->uCurrChannel);
 			if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA)
-				CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_ADHOC);
+				CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, NL80211_IFTYPE_ADHOC);
 			else
-				CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_INFRASTRUCTURE);
+				CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, NL80211_IFTYPE_STATION);
 
 			vAdHocBeaconRestart(pDevice);
 			s_bCommandComplete(pDevice);
@@ -393,7 +393,7 @@ vCommandTimer(
 				pr_debug("SET SCAN Channel Fail: %d\n",
 					 pMgmt->uScanChannel);
 
-			CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_UNKNOWN);
+			CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, NL80211_IFTYPE_UNSPECIFIED);
 			pMgmt->uScanChannel++;
 //2008-8-4 <modify> by chester
 			if (!is_channel_valid(pMgmt->uScanChannel) &&
@@ -427,9 +427,9 @@ vCommandTimer(
 		pr_debug("Scanning, set back to channel: [%d]\n",
 			 pMgmt->uCurrChannel);
 		if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA)
-			CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_ADHOC);
+			CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, NL80211_IFTYPE_ADHOC);
 		else
-			CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_INFRASTRUCTURE);
+			CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, NL80211_IFTYPE_STATION);
 
 		pMgmt->eScanState = WMAC_NO_SCANNING;
 		vAdHocBeaconRestart(pDevice);
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index ba273c7..c73c39d 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -2356,9 +2356,9 @@ vMgrCreateOwnIBSS(
 	pMgmt->byERPContext = 0;
 
 	if (pMgmt->eConfigMode == WMAC_CONFIG_AP) {
-		CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_AP);
+		CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, NL80211_IFTYPE_AP);
 	} else {
-		CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, OP_MODE_ADHOC);
+		CARDbSetBSSID(pMgmt->pAdapter, pMgmt->abyCurrBSSID, NL80211_IFTYPE_ADHOC);
 	}
 
 	CARDbSetPhyParameter(pMgmt->pAdapter,
@@ -2727,13 +2727,13 @@ s_vMgrSynchBSS(
 	}
 
 	if (WLAN_GET_CAP_INFO_ESS(pCurr->wCapInfo)) {
-		CARDbSetBSSID(pMgmt->pAdapter, pCurr->abyBSSID, OP_MODE_INFRASTRUCTURE);
+		CARDbSetBSSID(pMgmt->pAdapter, pCurr->abyBSSID, NL80211_IFTYPE_STATION);
 		// Add current BSS to Candidate list
 		// This should only works for WPA2 BSS, and WPA2 BSS check must be done before.
 		if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2)
 			CARDbAdd_PMKID_Candidate(pMgmt->pAdapter, pMgmt->abyCurrBSSID, pCurr->sRSNCapObj.bRSNCapExist, pCurr->sRSNCapObj.wRSNCap);
 	} else {
-		CARDbSetBSSID(pMgmt->pAdapter, pCurr->abyBSSID, OP_MODE_ADHOC);
+		CARDbSetBSSID(pMgmt->pAdapter, pCurr->abyBSSID, NL80211_IFTYPE_ADHOC);
 	}
 
 	if (!CARDbSetPhyParameter(pMgmt->pAdapter,
-- 
1.9.1

