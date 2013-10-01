Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:37625 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3JAPEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 11:04:04 -0400
Received: by mail-wg0-f53.google.com with SMTP id x12so6977486wgg.20
        for <linux-wireless@vger.kernel.org>; Tue, 01 Oct 2013 08:04:02 -0700 (PDT)
Message-ID: <1380639820.2087.8.camel@canaries64-MCP7A> (sfid-20131001_170409_112678_0BABC70B)
Subject: [PATCH 7/8] staging: vt6656: rxtx.c add no rts  struct
 vnt_tx_datahead_ab
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Oct 2013 16:03:40 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add no rts/cts vnt_tx_datahead_ab to union vnt_tx_data_head.

The need_mic now applies to all modes of packet type PK_TYPE_11B.

and return vnt_rxtx_datahead_ab in s_vGenerateTxParameter

This removes pvTxDataHd pointer assignment and calls to s_uFillDataHead.

Since pvTxDataHd is now null a small vendor hack to vDMA0_tx_80211/csMgmt_xmit
to do with Disassociation-packet is also changed correct head position.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 44 +++++++++++++++++--------------------------
 drivers/staging/vt6656/rxtx.h |  1 +
 2 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 0a77092..d094a6a 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -964,6 +964,13 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
         }
     }
     else if (byPktType == PK_TYPE_11B) {
+	if (need_mic) {
+		*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
+		head = &tx_buffer->tx_head.tx_ab.tx.mic.head;
+	} else {
+		head = &tx_buffer->tx_head.tx_ab.tx.head;
+	}
+
 	if (need_rts) {
             //Fill RsvTime
 		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.tx_ab.ab;
@@ -973,13 +980,6 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B,
 				cbFrameSize, wCurrentRate, bNeedACK);
 
-		if (need_mic) {
-			*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
-			head = &tx_buffer->tx_head.tx_ab.tx.mic.head;
-		} else {
-			head = &tx_buffer->tx_head.tx_ab.tx.head;
-		}
-
 		/* Fill RTS */
 		return s_vFillRTSHead(pDevice, byPktType, head, cbFrameSize,
 			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
@@ -988,11 +988,11 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
             //Fill RsvTime
 		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.tx_ab.ab;
 
-		if (need_mic)
-			*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
-
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B,
 			cbFrameSize, wCurrentRate, bNeedACK);
+
+		return vnt_rxtx_datahead_ab(pDevice, byPktType, wCurrentRate,
+			&head->data_head_ab, cbFrameSize, bNeedACK);
         }
     }
     //DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"s_vGenerateTxParameter END.\n");
@@ -1186,8 +1186,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 			cbMICHDR + sizeof(struct vnt_rts_ab);
             }
             else if (bRTS == false) { //RTS_needless, no MICHDR
-		pvTxDataHd = (struct vnt_tx_datahead_ab *)(pbyTxBufferAddr +
-			wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
 				cbMICHDR + sizeof(struct vnt_tx_datahead_ab);
             }
@@ -1220,10 +1218,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 	uDuration = s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
 			tx_buffer, &pMICHDR, cbMICHDR,
 			cbFrameSize, bNeedACK, uDMAIdx, psEthHeader, bRTS);
-    //Fill DataHead
-	if (pvTxDataHd)
-    		uDuration |= s_uFillDataHead(pDevice, byPktType, wCurrentRate,
-		pvTxDataHd, cbFrameSize, uDMAIdx, bNeedACK, byFBOption);
+
     // Generate TX MAC Header
     s_vGenerateMACHeader(pDevice, pbyMacHdr, (u16)uDuration, psEthHeader, bNeedEncryption,
                            byFragType, uDMAIdx, 0);
@@ -1456,7 +1451,6 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 	struct ieee80211_hdr *pMACHeader;
 	struct ethhdr sEthHeader;
 	u8 byPktType, *pbyTxBufferAddr;
-	void *pvTxDataHd;
 	struct vnt_mic_hdr *pMICHDR = NULL;
 	u32 uDuration, cbReqCount, cbHeaderSize, cbFrameBodySize, cbFrameSize;
 	int bNeedACK, bIsPSPOLL = false;
@@ -1593,8 +1587,6 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 		sizeof(struct vnt_cts);
     }
     else { // 802.11a/b packet
-	pvTxDataHd = (struct vnt_tx_datahead_ab *) (pbyTxBufferAddr +
-		wTxBufSize + sizeof(struct vnt_rrv_time_ab));
 	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
 		sizeof(struct vnt_tx_datahead_ab);
     }
@@ -1615,10 +1607,6 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 		pTX_Buffer, &pMICHDR, 0,
 		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
 
-    //Fill DataHead
-    uDuration |= s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd,
-		cbFrameSize, TYPE_TXDMA0, bNeedACK, AUTO_FB_NONE);
-
     pMACHeader = (struct ieee80211_hdr *) (pbyTxBufferAddr + cbHeaderSize);
 
     cbReqCount = cbHeaderSize + cbMacHdLen + uPadding + cbIVlen + cbFrameBodySize;
@@ -1688,7 +1676,9 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 		data_head->wDuration_b =
 			cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
 	} else {
-		((struct vnt_tx_datahead_ab *)pvTxDataHd)->wDuration =
+		struct vnt_tx_datahead_ab *data_head = &pTX_Buffer->tx_head.
+					tx_ab.tx.head.data_head_ab;
+		data_head->wDuration =
 			cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
 	}
     }
@@ -1997,8 +1987,6 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 
     }
     else {//802.11a/b packet
-	pvTxDataHd = (struct vnt_tx_datahead_ab *)(pbyTxBufferAddr +
-		wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR +
 					sizeof(struct vnt_tx_datahead_ab);
     }
@@ -2137,7 +2125,9 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 		data_head->wDuration_b =
 			cpu_to_le16(p80211Header->sA2.wDurationID);
 	} else {
-		((struct vnt_tx_datahead_ab *)pvTxDataHd)->wDuration =
+		struct vnt_tx_datahead_ab *data_head = &pTX_Buffer->tx_head.
+					tx_ab.tx.head.data_head_ab;
+		data_head->wDuration =
 			cpu_to_le16(p80211Header->sA2.wDurationID);
 	}
     }
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index d905b97..eecbe89 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -186,6 +186,7 @@ union vnt_tx_data_head {
 	struct vnt_cts_fb cts_g_fb;
 	/* no rts/cts */
 	struct vnt_tx_datahead_a_fb data_head_a_fb;
+	struct vnt_tx_datahead_ab data_head_ab;
 };
 
 struct vnt_tx_mic_hdr {
-- 
1.8.3.2





