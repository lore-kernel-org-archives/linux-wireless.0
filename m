Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43790 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240AbaESTeP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:34:15 -0400
Received: by mail-wi0-f171.google.com with SMTP id cc10so2100663wib.10
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 12:34:13 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/20] staging: vt6656: dpc.c remove hostapd
Date: Mon, 19 May 2014 20:32:55 +0100
Message-Id: <1400527992-3061-3-git-send-email-tvboxspy@gmail.com> (sfid-20140519_213421_137561_0A2075C5)
In-Reply-To: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
References: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove dead functions
s_bAPModeRxCtl
s_bAPModeRxData

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/dpc.c | 223 +------------------------------------------
 1 file changed, 1 insertion(+), 222 deletions(-)

diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index a1ae213..88808ba 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -26,8 +26,6 @@
  *
  * Functions:
  *      device_receive_frame - Rcv 802.11 frame function
- *      s_bAPModeRxCtl- AP Rcv frame filer Ctl.
- *      s_bAPModeRxData- AP Rcv data frame handle
  *      s_bHandleRxEncryption- Rcv decrypted data via on-fly
  *      s_byGetRateIdx- get rate index
  *      s_vGetDASA- get data offset
@@ -75,12 +73,6 @@ static void s_vProcessRxMACHeader(struct vnt_private *pDevice,
 	u8 *pbyRxBufferAddr, u32 cbPacketSize, int bIsWEP, int bExtIV,
 	u32 *pcbHeadSize);
 
-static int s_bAPModeRxCtl(struct vnt_private *pDevice, u8 *pbyFrame,
-	s32 iSANodeIndex);
-
-static int s_bAPModeRxData(struct vnt_private *pDevice, struct sk_buff *skb,
-	u32 FrameSize, u32 cbHeaderOffset, s32 iSANodeIndex, s32 iDANodeIndex);
-
 static int s_bHandleRxEncryption(struct vnt_private *pDevice, u8 *pbyFrame,
 	u32 FrameSize, u8 *pbyRsr, u8 *pbyNewRsr, PSKeyItem *pKeyOut,
 	s32 *pbExtIV, u16 *pwRxTSC15_0, u32 *pdwRxTSC47_16);
@@ -255,7 +247,7 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, struct vnt_rcb *pRCB,
 	u32 cbHeaderOffset, cbIVOffset;
 	u32 FrameSize;
 	u16 wEtherType = 0;
-	s32 iSANodeIndex = -1, iDANodeIndex = -1;
+	s32 iSANodeIndex = -1;
 	int ii;
 	u8 *pbyRxSts, *pbyRxRate, *pbySQ, *pby3SQ;
 	u32 cbHeaderSize;
@@ -383,12 +375,6 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, struct vnt_rcb *pRCB,
         }
     }
 
-    if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
-        if (s_bAPModeRxCtl(pDevice, pbyFrame, iSANodeIndex) == true) {
-            return false;
-        }
-    }
-
     if (IS_FC_WEP(pbyFrame)) {
         bool     bRxDecryOK = false;
 
@@ -735,26 +721,6 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, struct vnt_rcb *pRCB,
     if (FrameSize < 12)
         return false;
 
-    if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
-        if (s_bAPModeRxData(pDevice,
-                            skb,
-                            FrameSize,
-                            cbHeaderOffset,
-                            iSANodeIndex,
-                            iDANodeIndex
-                            ) == false) {
-
-            if (bDeFragRx) {
-                if (!device_alloc_frag_buf(pDevice, &pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx])) {
-                    DBG_PRT(MSG_LEVEL_ERR,KERN_ERR "%s: can not alloc more frag bufs\n",
-                    pDevice->dev->name);
-                }
-            }
-            return false;
-        }
-
-    }
-
 	skb->data += cbHeaderOffset;
 	skb->tail += cbHeaderOffset;
     skb_put(skb, FrameSize);
@@ -774,112 +740,6 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, struct vnt_rcb *pRCB,
     return true;
 }
 
-static int s_bAPModeRxCtl(struct vnt_private *pDevice, u8 *pbyFrame,
-	s32 iSANodeIndex)
-{
-	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
-	struct ieee80211_hdr *p802_11Header;
-	CMD_STATUS Status;
-
-    if (IS_CTL_PSPOLL(pbyFrame) || !IS_TYPE_CONTROL(pbyFrame)) {
-
-        p802_11Header = (struct ieee80211_hdr *) (pbyFrame);
-        if (!IS_TYPE_MGMT(pbyFrame)) {
-
-            // Data & PS-Poll packet
-            // check frame class
-            if (iSANodeIndex > 0) {
-                // frame class 3 fliter & checking
-                if (pMgmt->sNodeDBTable[iSANodeIndex].eNodeState < NODE_AUTH) {
-                    // send deauth notification
-                    // reason = (6) class 2 received from nonauth sta
-                    vMgrDeAuthenBeginSta(pDevice,
-                                         pMgmt,
-                                         (u8 *)(p802_11Header->addr2),
-                                         (WLAN_MGMT_REASON_CLASS2_NONAUTH),
-                                         &Status
-                                         );
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: send vMgrDeAuthenBeginSta 1\n");
-                    return true;
-                }
-                if (pMgmt->sNodeDBTable[iSANodeIndex].eNodeState < NODE_ASSOC) {
-                    // send deassoc notification
-                    // reason = (7) class 3 received from nonassoc sta
-                    vMgrDisassocBeginSta(pDevice,
-                                         pMgmt,
-                                         (u8 *)(p802_11Header->addr2),
-                                         (WLAN_MGMT_REASON_CLASS3_NONASSOC),
-                                         &Status
-                                         );
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: send vMgrDisassocBeginSta 2\n");
-                    return true;
-                }
-
-                if (pMgmt->sNodeDBTable[iSANodeIndex].bPSEnable) {
-                    // delcare received ps-poll event
-                    if (IS_CTL_PSPOLL(pbyFrame)) {
-                        pMgmt->sNodeDBTable[iSANodeIndex].bRxPSPoll = true;
-			bScheduleCommand((void *) pDevice,
-					 WLAN_CMD_RX_PSPOLL,
-					 NULL);
-                        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: WLAN_CMD_RX_PSPOLL 1\n");
-                    }
-                    else {
-                        // check Data PS state
-                        // if PW bit off, send out all PS bufferring packets.
-                        if (!IS_FC_POWERMGT(pbyFrame)) {
-                            pMgmt->sNodeDBTable[iSANodeIndex].bPSEnable = false;
-                            pMgmt->sNodeDBTable[iSANodeIndex].bRxPSPoll = true;
-				bScheduleCommand((void *) pDevice,
-						 WLAN_CMD_RX_PSPOLL,
-						 NULL);
-                            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: WLAN_CMD_RX_PSPOLL 2\n");
-                        }
-                    }
-                }
-                else {
-                   if (IS_FC_POWERMGT(pbyFrame)) {
-                       pMgmt->sNodeDBTable[iSANodeIndex].bPSEnable = true;
-                       // Once if STA in PS state, enable multicast bufferring
-                       pMgmt->sNodeDBTable[0].bPSEnable = true;
-                   }
-                   else {
-                      // clear all pending PS frame.
-                      if (pMgmt->sNodeDBTable[iSANodeIndex].wEnQueueCnt > 0) {
-                          pMgmt->sNodeDBTable[iSANodeIndex].bPSEnable = false;
-                          pMgmt->sNodeDBTable[iSANodeIndex].bRxPSPoll = true;
-			bScheduleCommand((void *) pDevice,
-					 WLAN_CMD_RX_PSPOLL,
-					 NULL);
-                         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: WLAN_CMD_RX_PSPOLL 3\n");
-
-                      }
-                   }
-                }
-            }
-            else {
-                  vMgrDeAuthenBeginSta(pDevice,
-                                       pMgmt,
-                                       (u8 *)(p802_11Header->addr2),
-                                       (WLAN_MGMT_REASON_CLASS2_NONAUTH),
-                                       &Status
-                                       );
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: send vMgrDeAuthenBeginSta 3\n");
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BSSID:%pM\n",
-				p802_11Header->addr3);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ADDR2:%pM\n",
-				p802_11Header->addr2);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ADDR1:%pM\n",
-				p802_11Header->addr1);
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: frame_control= %x\n", p802_11Header->frame_control);
-                    return true;
-            }
-        }
-    }
-    return false;
-
-}
-
 static int s_bHandleRxEncryption(struct vnt_private *pDevice, u8 *pbyFrame,
 	u32 FrameSize, u8 *pbyRsr, u8 *pbyNewRsr, PSKeyItem *pKeyOut,
 	s32 *pbExtIV, u16 *pwRxTSC15_0, u32 *pdwRxTSC47_16)
@@ -1006,87 +866,6 @@ static int s_bHandleRxEncryption(struct vnt_private *pDevice, u8 *pbyFrame,
     return true;
 }
 
-static int s_bAPModeRxData(struct vnt_private *pDevice, struct sk_buff *skb,
-	u32 FrameSize, u32 cbHeaderOffset, s32 iSANodeIndex, s32 iDANodeIndex)
-{
-	struct sk_buff *skbcpy;
-	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
-	int  bRelayAndForward = false;
-	int bRelayOnly = false;
-	u8 byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
-	u16 wAID;
-
-    if (FrameSize > CB_MAX_BUF_SIZE)
-        return false;
-    // check DA
-    if (is_multicast_ether_addr((u8 *)(skb->data+cbHeaderOffset))) {
-       if (pMgmt->sNodeDBTable[0].bPSEnable) {
-
-	    skbcpy = netdev_alloc_skb(pDevice->dev, pDevice->rx_buf_sz);
-
-        // if any node in PS mode, buffer packet until DTIM.
-           if (skbcpy == NULL) {
-               DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "relay multicast no skb available \n");
-           }
-           else {
-               skbcpy->len = FrameSize;
-               memcpy(skbcpy->data, skb->data+cbHeaderOffset, FrameSize);
-               skb_queue_tail(&(pMgmt->sNodeDBTable[0].sTxPSQueue), skbcpy);
-               pMgmt->sNodeDBTable[0].wEnQueueCnt++;
-               // set tx map
-               pMgmt->abyPSTxMap[0] |= byMask[0];
-           }
-       }
-       else {
-           bRelayAndForward = true;
-       }
-    }
-    else {
-        // check if relay
-        if (BSSbIsSTAInNodeDB(pDevice, (u8 *)(skb->data+cbHeaderOffset), &iDANodeIndex)) {
-            if (pMgmt->sNodeDBTable[iDANodeIndex].eNodeState >= NODE_ASSOC) {
-                if (pMgmt->sNodeDBTable[iDANodeIndex].bPSEnable) {
-                    // queue this skb until next PS tx, and then release.
-
-	                skb->data += cbHeaderOffset;
-	                skb->tail += cbHeaderOffset;
-                    skb_put(skb, FrameSize);
-                    skb_queue_tail(&pMgmt->sNodeDBTable[iDANodeIndex].sTxPSQueue, skb);
-
-                    pMgmt->sNodeDBTable[iDANodeIndex].wEnQueueCnt++;
-                    wAID = pMgmt->sNodeDBTable[iDANodeIndex].wAID;
-                    pMgmt->abyPSTxMap[wAID >> 3] |=  byMask[wAID & 7];
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "relay: index= %d, pMgmt->abyPSTxMap[%d]= %d\n",
-                               iDANodeIndex, (wAID >> 3), pMgmt->abyPSTxMap[wAID >> 3]);
-                    return true;
-                }
-                else {
-                    bRelayOnly = true;
-                }
-            }
-        }
-    }
-
-    if (bRelayOnly || bRelayAndForward) {
-        // relay this packet right now
-        if (bRelayAndForward)
-            iDANodeIndex = 0;
-
-        if ((pDevice->uAssocCount > 1) && (iDANodeIndex >= 0)) {
-		bRelayPacketSend(pDevice, (u8 *) (skb->data + cbHeaderOffset),
-				 FrameSize, (unsigned int) iDANodeIndex);
-        }
-
-        if (bRelayOnly)
-            return false;
-    }
-    // none associate, don't forward
-    if (pDevice->uAssocCount == 0)
-        return false;
-
-    return true;
-}
-
 void RXvWorkItem(struct work_struct *work)
 {
 	struct vnt_private *priv =
-- 
1.9.1

