Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:52954 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759024AbaD3Ucx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2014 16:32:53 -0400
Received: by mail-we0-f178.google.com with SMTP id u56so1331860wes.37
        for <linux-wireless@vger.kernel.org>; Wed, 30 Apr 2014 13:32:51 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/4] staging: vt6656: rxtx: Remove unused uDMAIdx from driver.
Date: Wed, 30 Apr 2014 21:31:12 +0100
Message-Id: <1398889875-3312-1-git-send-email-tvboxspy@gmail.com> (sfid-20140430_223257_295782_BF0CCE35)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove from functions and callers.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c |  2 +-
 drivers/staging/vt6656/rxtx.c     | 33 +++++++++++++++------------------
 drivers/staging/vt6656/rxtx.h     |  2 +-
 drivers/staging/vt6656/wcmd.c     |  4 ++--
 4 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 3c93230..0b0bc77 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1189,7 +1189,7 @@ static int device_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto out;
 	}
 
-	if (nsDMA_tx_packet(pDevice, TYPE_AC0DMA, skb)) {
+	if (nsDMA_tx_packet(pDevice, skb)) {
 		if (netif_queue_stopped(dev))
 			netif_wake_queue(dev);
 	}
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 1ff1446..4977f72 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -101,11 +101,11 @@ static struct vnt_usb_send_context *s_vGetFreeContext(struct vnt_private *);
 static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate,	struct vnt_tx_buffer *tx_buffer,
 	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 cbFrameSize,
-	int bNeedACK, u32 uDMAIdx, struct ethhdr *psEthHeader, bool need_rts);
+	int bNeedACK, struct ethhdr *psEthHeader, bool need_rts);
 
 static void s_vGenerateMACHeader(struct vnt_private *pDevice,
 	u8 *pbyBufferAddr, u16 wDuration, struct ethhdr *psEthHeader,
-	int bNeedEncrypt, u16 wFragType, u32 uDMAIdx, u32 uFragIdx);
+	int bNeedEncrypt, u16 wFragType, u32 uFragIdx);
 
 static void s_vFillTxKey(struct vnt_private *pDevice,
 	struct vnt_tx_fifo_head *fifo_head, u8 *pbyIVHead,
@@ -121,7 +121,7 @@ static unsigned int s_uGetTxRsvTime(struct vnt_private *pDevice, u8 byPktType,
 static __le16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
 	u8 rsv_type, u8 pkt_type, u32 frame_lenght, u16 current_rate);
 
-static u16 s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
+static u16 s_vFillCTSHead(struct vnt_private *pDevice,
 	u8 byPktType, union vnt_tx_data_head *head, u32 cbFrameLength,
 	int bNeedAck, u16 wCurrentRate, u8 byFBOption);
 
@@ -714,7 +714,7 @@ static u16 s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 	return 0;
 }
 
-static u16 s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
+static u16 s_vFillCTSHead(struct vnt_private *pDevice,
 	u8 byPktType, union vnt_tx_data_head *head, u32 cbFrameLength,
 	int bNeedAck, u16 wCurrentRate, u8 byFBOption)
 {
@@ -787,7 +787,6 @@ static u16 s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
  *      pCTS            - CTS Buffer
  *      cbFrameSize     - Transmit Data Length (Hdr+Payload+FCS)
  *      bNeedACK        - If need ACK
- *      uDMAIdx         - DMA Index
  *  Out:
  *      none
  *
@@ -798,7 +797,7 @@ static u16 s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate,	struct vnt_tx_buffer *tx_buffer,
 	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 cbFrameSize,
-	int bNeedACK, u32 uDMAIdx, struct ethhdr *psEthHeader, bool need_rts)
+	int bNeedACK, struct ethhdr *psEthHeader, bool need_rts)
 {
 	struct vnt_tx_fifo_head *pFifoHead = &tx_buffer->fifo_head;
 	union vnt_tx_data_head *head = NULL;
@@ -869,7 +868,7 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 			}
 
 			/* Fill CTS */
-			return s_vFillCTSHead(pDevice, uDMAIdx, byPktType,
+			return s_vFillCTSHead(pDevice, byPktType,
 				head, cbFrameSize, bNeedACK, wCurrentRate,
 					byFBOption);
 		}
@@ -954,7 +953,7 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 
 static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 	struct vnt_tx_buffer *tx_buffer, int bNeedEncryption,
-	u32 uSkbPacketLen, u32 uDMAIdx,	struct ethhdr *psEthHeader,
+	u32 uSkbPacketLen, struct ethhdr *psEthHeader,
 	u8 *pPacket, PSKeyItem pTransmitKey, u32 uNodeIndex, u16 wCurrentRate,
 	u32 *pcbHeaderLen, u32 *pcbTotalLen)
 {
@@ -1150,17 +1149,16 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
     //=========================
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"No Fragmentation...\n");
     byFragType = FRAGCTL_NONFRAG;
-    //uDMAIdx = TYPE_AC0DMA;
     //pTxBufHead = (PSTxBufHead) &(pTxBufHead->adwTxKey[0]);
 
 	/* Fill FIFO, RrvTime, RTS and CTS */
 	uDuration = s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
 			tx_buffer, &pMICHDR, cbMICHDR,
-			cbFrameSize, bNeedACK, uDMAIdx, psEthHeader, bRTS);
+			cbFrameSize, bNeedACK, psEthHeader, bRTS);
 
     // Generate TX MAC Header
     s_vGenerateMACHeader(pDevice, pbyMacHdr, (u16)uDuration, psEthHeader, bNeedEncryption,
-                           byFragType, uDMAIdx, 0);
+		byFragType, 0);
 
     if (bNeedEncryption == true) {
         //Fill TXKEY
@@ -1292,7 +1290,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 
 static void s_vGenerateMACHeader(struct vnt_private *pDevice,
 	u8 *pbyBufferAddr, u16 wDuration, struct ethhdr *psEthHeader,
-	int bNeedEncrypt, u16 wFragType, u32 uDMAIdx, u32 uFragIdx)
+	int bNeedEncrypt, u16 wFragType, u32 uFragIdx)
 {
 	struct ieee80211_hdr *pMACHeader = (struct ieee80211_hdr *)pbyBufferAddr;
 
@@ -1532,7 +1530,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 	/* Fill FIFO,RrvTime,RTS,and CTS */
 	uDuration = s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
 		pTX_Buffer, &pMICHDR, 0,
-		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
+		cbFrameSize, bNeedACK, &sEthHeader, false);
 
     pMACHeader = (struct ieee80211_hdr *) (pbyTxBufferAddr + cbHeaderSize);
 
@@ -1926,7 +1924,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 	/* Fill FIFO,RrvTime,RTS,and CTS */
 	uDuration = s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
 		pTX_Buffer, &pMICHDR, cbMICHDR,
-		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
+		cbFrameSize, bNeedACK, &sEthHeader, false);
 
 	pMACHeader = (struct ieee80211_hdr *) (pbyTxBufferAddr + cbHeaderSize);
 
@@ -2088,8 +2086,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
  * Return Value: NULL
  */
 
-int nsDMA_tx_packet(struct vnt_private *pDevice,
-	u32 uDMAIdx, struct sk_buff *skb)
+int nsDMA_tx_packet(struct vnt_private *pDevice, struct sk_buff *skb)
 {
 	struct net_device_stats *pStats = &pDevice->stats;
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
@@ -2420,7 +2417,7 @@ int nsDMA_tx_packet(struct vnt_private *pDevice,
 
     fConvertedPacket = s_bPacketToWirelessUsb(pDevice, byPktType,
 			pTX_Buffer, bNeedEncryption,
-                        skb->len, uDMAIdx, &pDevice->sTxEthHeader,
+			skb->len, &pDevice->sTxEthHeader,
                         (u8 *)skb->data, pTransmitKey, uNodeIndex,
                         pDevice->wCurrentRate,
                         &uHeaderLen, &BytesToWrite
@@ -2584,7 +2581,7 @@ int bRelayPacketSend(struct vnt_private *pDevice, u8 *pbySkbData, u32 uDataLen,
 
     fConvertedPacket = s_bPacketToWirelessUsb(pDevice, byPktType,
 			pTX_Buffer, bNeedEncryption,
-                         uDataLen, TYPE_AC0DMA, &pDevice->sTxEthHeader,
+			uDataLen, &pDevice->sTxEthHeader,
                          pbySkbData, pTransmitKey, uNodeIndex,
                          pDevice->wCurrentRate,
                          &uHeaderLen, &BytesToWrite
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 4dfb2e0..982f162 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -247,7 +247,7 @@ struct vnt_beacon_buffer {
 } __packed;
 
 void vDMA0_tx_80211(struct vnt_private *, struct sk_buff *skb);
-int nsDMA_tx_packet(struct vnt_private *, u32 uDMAIdx, struct sk_buff *skb);
+int nsDMA_tx_packet(struct vnt_private *, struct sk_buff *skb);
 CMD_STATUS csMgmt_xmit(struct vnt_private *, struct vnt_tx_mgmt *);
 CMD_STATUS csBeacon_xmit(struct vnt_private *, struct vnt_tx_mgmt *);
 int bRelayPacketSend(struct vnt_private *, u8 *pbySkbData, u32 uDataLen,
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 3cf3f24..de7e808 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -675,7 +675,7 @@ void vRunCommand(struct work_struct *work)
 					pDevice->bMoreData = true;
 				}
 
-				if (nsDMA_tx_packet(pDevice, TYPE_AC0DMA, skb) != 0)
+				if (nsDMA_tx_packet(pDevice, skb) != 0)
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Multicast ps tx fail\n");
 
 				pMgmt->sNodeDBTable[0].wEnQueueCnt--;
@@ -698,7 +698,7 @@ void vRunCommand(struct work_struct *work)
 						pDevice->bMoreData = true;
 					}
 
-					if (nsDMA_tx_packet(pDevice, TYPE_AC0DMA, skb) != 0)
+					if (nsDMA_tx_packet(pDevice, skb) != 0)
 						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "sta ps tx fail\n");
 
 					pMgmt->sNodeDBTable[ii].wEnQueueCnt--;
-- 
1.9.1

