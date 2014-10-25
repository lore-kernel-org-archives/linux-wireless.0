Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:59165 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaJYS6x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 14:58:53 -0400
Received: by mail-wg0-f43.google.com with SMTP id n12so3109338wgh.14
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 11:58:52 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/31] staging: vt6655: mac80211 conversion: changes to device_intr
Date: Sat, 25 Oct 2014 09:20:22 +0100
Message-Id: <1414225241-5480-13-git-send-email-tvboxspy@gmail.com> (sfid-20141025_205918_739729_291C7CE1)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove net device code.

Remove current measure code and function s_vCompleteCurrentMeasure
and switch code which are now handled by mac80211

Change beaconing to mac80211.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 175 ++---------------------------------
 1 file changed, 8 insertions(+), 167 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 5ece184..69c98c2 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -400,45 +400,6 @@ device_set_options(struct vnt_private *pDevice)
 		 (int)pDevice->bDiversityRegCtlON);
 }
 
-static void s_vCompleteCurrentMeasure(struct vnt_private *pDevice,
-				      unsigned char byResult)
-{
-	unsigned int ii;
-	unsigned long dwDuration = 0;
-	unsigned char byRPI0 = 0;
-
-	for (ii = 1; ii < 8; ii++) {
-		pDevice->dwRPIs[ii] *= 255;
-		dwDuration |= *((unsigned short *)(pDevice->pCurrMeasureEID->sReq.abyDuration));
-		dwDuration <<= 10;
-		pDevice->dwRPIs[ii] /= dwDuration;
-		pDevice->abyRPIs[ii] = (unsigned char)pDevice->dwRPIs[ii];
-		byRPI0 += pDevice->abyRPIs[ii];
-	}
-	pDevice->abyRPIs[0] = (0xFF - byRPI0);
-
-	if (pDevice->uNumOfMeasureEIDs == 0) {
-		VNTWIFIbMeasureReport(pDevice->pMgmt,
-				      true,
-				      pDevice->pCurrMeasureEID,
-				      byResult,
-				      pDevice->byBasicMap,
-				      pDevice->byCCAFraction,
-				      pDevice->abyRPIs
-			);
-	} else {
-		VNTWIFIbMeasureReport(pDevice->pMgmt,
-				      false,
-				      pDevice->pCurrMeasureEID,
-				      byResult,
-				      pDevice->byBasicMap,
-				      pDevice->byCCAFraction,
-				      pDevice->abyRPIs
-			);
-		CARDbStartMeasure(pDevice, pDevice->pCurrMeasureEID++, pDevice->uNumOfMeasureEIDs);
-	}
-}
-
 //
 // Initialisation of MAC & BBP registers
 //
@@ -2056,14 +2017,11 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 
 static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 {
-	struct net_device *dev = dev_instance;
-	struct vnt_private *pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = dev_instance;
 	int             max_count = 0;
 	unsigned long dwMIBCounter = 0;
-	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	unsigned char byOrgPageSel = 0;
 	int             handled = 0;
-	unsigned char byData = 0;
 	int             ii = 0;
 	unsigned long flags;
 
@@ -2106,94 +2064,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 			device_error(pDevice, pDevice->dwIsr);
 		}
 
-		if (pDevice->byLocalID > REV_ID_VT3253_B1) {
-			if (pDevice->dwIsr & ISR_MEASURESTART) {
-				// 802.11h measure start
-				pDevice->byOrgChannel = pDevice->byCurrentCh;
-				VNSvInPortB(pDevice->PortOffset + MAC_REG_RCR, &(pDevice->byOrgRCR));
-				VNSvOutPortB(pDevice->PortOffset + MAC_REG_RCR, (RCR_RXALLTYPE | RCR_UNICAST | RCR_BROADCAST | RCR_MULTICAST | RCR_WPAERR));
-				MACvSelectPage1(pDevice->PortOffset);
-				VNSvInPortD(pDevice->PortOffset + MAC_REG_MAR0, &(pDevice->dwOrgMAR0));
-				VNSvInPortD(pDevice->PortOffset + MAC_REG_MAR4, &(pDevice->dwOrgMAR4));
-				MACvSelectPage0(pDevice->PortOffset);
-				//xxxx
-				if (set_channel(pDevice, pDevice->pCurrMeasureEID->sReq.byChannel)) {
-					pDevice->bMeasureInProgress = true;
-					MACvSelectPage1(pDevice->PortOffset);
-					MACvRegBitsOn(pDevice->PortOffset, MAC_REG_MSRCTL, MSRCTL_READY);
-					MACvSelectPage0(pDevice->PortOffset);
-					pDevice->byBasicMap = 0;
-					pDevice->byCCAFraction = 0;
-					for (ii = 0; ii < 8; ii++)
-						pDevice->dwRPIs[ii] = 0;
-
-				} else {
-					// can not measure because set channel fail
-					// clear measure control
-					MACvRegBitsOff(pDevice->PortOffset, MAC_REG_MSRCTL, MSRCTL_EN);
-					s_vCompleteCurrentMeasure(pDevice, MEASURE_MODE_INCAPABLE);
-					MACvSelectPage1(pDevice->PortOffset);
-					MACvRegBitsOn(pDevice->PortOffset, MAC_REG_MSRCTL+1, MSRCTL1_TXPAUSE);
-					MACvSelectPage0(pDevice->PortOffset);
-				}
-			}
-			if (pDevice->dwIsr & ISR_MEASUREEND) {
-				// 802.11h measure end
-				pDevice->bMeasureInProgress = false;
-				VNSvOutPortB(pDevice->PortOffset + MAC_REG_RCR, pDevice->byOrgRCR);
-				MACvSelectPage1(pDevice->PortOffset);
-				VNSvOutPortD(pDevice->PortOffset + MAC_REG_MAR0, pDevice->dwOrgMAR0);
-				VNSvOutPortD(pDevice->PortOffset + MAC_REG_MAR4, pDevice->dwOrgMAR4);
-				VNSvInPortB(pDevice->PortOffset + MAC_REG_MSRBBSTS, &byData);
-				pDevice->byBasicMap |= (byData >> 4);
-				VNSvInPortB(pDevice->PortOffset + MAC_REG_CCAFRACTION, &pDevice->byCCAFraction);
-				VNSvInPortB(pDevice->PortOffset + MAC_REG_MSRCTL, &byData);
-				// clear measure control
-				MACvRegBitsOff(pDevice->PortOffset, MAC_REG_MSRCTL, MSRCTL_EN);
-				MACvSelectPage0(pDevice->PortOffset);
-				set_channel(pDevice, pDevice->byOrgChannel);
-				MACvSelectPage1(pDevice->PortOffset);
-				MACvRegBitsOn(pDevice->PortOffset, MAC_REG_MSRCTL+1, MSRCTL1_TXPAUSE);
-				MACvSelectPage0(pDevice->PortOffset);
-				if (byData & MSRCTL_FINISH) {
-					// measure success
-					s_vCompleteCurrentMeasure(pDevice, 0);
-				} else {
-					// can not measure because not ready before end of measure time
-					s_vCompleteCurrentMeasure(pDevice, MEASURE_MODE_LATE);
-				}
-			}
-			if (pDevice->dwIsr & ISR_QUIETSTART) {
-				do {
-					;
-				} while (!CARDbStartQuiet(pDevice));
-			}
-		}
-
 		if (pDevice->dwIsr & ISR_TBTT) {
-			if (pDevice->bEnableFirstQuiet) {
-				pDevice->byQuietStartCount--;
-				if (pDevice->byQuietStartCount == 0) {
-					pDevice->bEnableFirstQuiet = false;
-					MACvSelectPage1(pDevice->PortOffset);
-					MACvRegBitsOn(pDevice->PortOffset, MAC_REG_MSRCTL, (MSRCTL_QUIETTXCHK | MSRCTL_QUIETEN));
-					MACvSelectPage0(pDevice->PortOffset);
-				}
-			}
-			if (pDevice->bChannelSwitch &&
-			    (pDevice->op_mode == NL80211_IFTYPE_STATION)) {
-				pDevice->byChannelSwitchCount--;
-				if (pDevice->byChannelSwitchCount == 0) {
-					pDevice->bChannelSwitch = false;
-					set_channel(pDevice, pDevice->byNewChannel);
-					VNTWIFIbChannelSwitch(pDevice->pMgmt, pDevice->byNewChannel);
-					MACvSelectPage1(pDevice->PortOffset);
-					MACvRegBitsOn(pDevice->PortOffset, MAC_REG_MSRCTL+1, MSRCTL1_TXPAUSE);
-					MACvSelectPage0(pDevice->PortOffset);
-					CARDbStartTxPacket(pDevice, PKT_TYPE_802_11_ALL);
-
-				}
-			}
 			if (pDevice->op_mode != NL80211_IFTYPE_ADHOC) {
 				if ((pDevice->bUpdateBBVGA) && pDevice->bLinkPass && (pDevice->uCurrRSSI != 0)) {
 					long            ldBm;
@@ -2234,10 +2105,11 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 			if (pDevice->bEnablePSMode)
 				PSbIsNextTBTTWakeUp((void *)pDevice);
 
-			if ((pDevice->op_mode == NL80211_IFTYPE_AP) ||
-			    (pDevice->op_mode == NL80211_IFTYPE_ADHOC)) {
+			if ((pDevice->op_mode == NL80211_IFTYPE_AP ||
+			    pDevice->op_mode == NL80211_IFTYPE_ADHOC) &&
+			    pDevice->vif->bss_conf.enable_beacon) {
 				MACvOneShotTimer1MicroSec(pDevice->PortOffset,
-							  (pMgmt->wIBSSBeaconPeriod - MAKE_BEACON_RESERVED) << 10);
+							  (pDevice->vif->bss_conf.beacon_int - MAKE_BEACON_RESERVED) << 10);
 			}
 
 			/* TODO: adhoc PS mode */
@@ -2250,34 +2122,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 				pDevice->cbBeaconBufReadySetCnt = 0;
 			}
 
-			if (pDevice->op_mode == NL80211_IFTYPE_AP) {
-				if (pMgmt->byDTIMCount > 0) {
-					pMgmt->byDTIMCount--;
-					pMgmt->sNodeDBTable[0].bRxPSPoll = false;
-				} else {
-					if (pMgmt->byDTIMCount == 0) {
-						// check if mutltcast tx bufferring
-						pMgmt->byDTIMCount = pMgmt->byDTIMPeriod - 1;
-						pMgmt->sNodeDBTable[0].bRxPSPoll = true;
-						bScheduleCommand((void *)pDevice, WLAN_CMD_RX_PSPOLL, NULL);
-					}
-				}
-			}
 			pDevice->bBeaconSent = true;
-
-			if (pDevice->bChannelSwitch) {
-				pDevice->byChannelSwitchCount--;
-				if (pDevice->byChannelSwitchCount == 0) {
-					pDevice->bChannelSwitch = false;
-					set_channel(pDevice, pDevice->byNewChannel);
-					VNTWIFIbChannelSwitch(pDevice->pMgmt, pDevice->byNewChannel);
-					MACvSelectPage1(pDevice->PortOffset);
-					MACvRegBitsOn(pDevice->PortOffset, MAC_REG_MSRCTL+1, MSRCTL1_TXPAUSE);
-					MACvSelectPage0(pDevice->PortOffset);
-					CARDbStartTxPacket(pDevice, PKT_TYPE_802_11_ALL);
-				}
-			}
-
 		}
 
 		if (pDevice->dwIsr & ISR_RXDMA0)
@@ -2293,14 +2138,10 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 			max_count += device_tx_srv(pDevice, TYPE_AC0DMA);
 
 		if (pDevice->dwIsr & ISR_SOFTTIMER1) {
-			if (pDevice->op_mode == NL80211_IFTYPE_AP) {
-				if (pDevice->bShortSlotTime)
-					pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SHORTSLOTTIME(1);
-				else
-					pMgmt->wCurrCapInfo &= ~(WLAN_SET_CAP_INFO_SHORTSLOTTIME(1));
+			if (pDevice->vif) {
+				if (pDevice->vif->bss_conf.enable_beacon)
+					vnt_beacon_make(pDevice, pDevice->vif);
 			}
-			bMgrPrepareBeaconToSend(pDevice, pMgmt);
-			pDevice->byCntMeasure = 0;
 		}
 
 		MACvReadISR(pDevice->PortOffset, &pDevice->dwIsr);
-- 
1.9.1

