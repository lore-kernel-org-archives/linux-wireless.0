Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:62759 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3JAPA0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 11:00:26 -0400
Received: by mail-wg0-f48.google.com with SMTP id n12so7439722wgh.15
        for <linux-wireless@vger.kernel.org>; Tue, 01 Oct 2013 08:00:24 -0700 (PDT)
Message-ID: <1380639620.2087.6.camel@canaries64-MCP7A> (sfid-20131001_170034_158737_4880EE3E)
Subject: [PATCH 6/8] staging: vt6656: rxtx.c parse out vnt_rxtx_datahead_ab
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Oct 2013 16:00:20 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Parse struct vnt_tx_datahead_ab from s_uFillDataHead and
move to struct vnt_rts_ab structure returning duration down
functions.

Both are returned in s_uFillDataHead at this stage as pvTxDataHd
is only null in s_bPacketToWirelessUsb.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 53 +++++++++++++++++++++----------------------
 drivers/staging/vt6656/rxtx.h |  1 +
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 1d02724..0a77092 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -569,6 +569,20 @@ static u16 vnt_rxtx_datahead_a_fb(struct vnt_private *priv, u8 pkt_type,
 	return buf->wDuration;
 }
 
+static u16 vnt_rxtx_datahead_ab(struct vnt_private *priv, u8 pkt_type,
+		u16 rate, struct vnt_tx_datahead_ab *buf,
+		u32 frame_len, int need_ack)
+{
+	/* Get SignalField,ServiceField,Length */
+	BBvCalculateParameter(priv, frame_len, rate, pkt_type, &buf->ab);
+	/* Get Duration and TimeStampOff */
+	buf->wDuration = s_uGetDataDuration(priv, pkt_type, need_ack);
+
+	buf->wTimeStampOff = vnt_time_stamp_off(priv, rate);
+
+	return buf->wDuration;
+}
+
 static u32 s_uFillDataHead(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate, void *pTxDataHead, u32 cbFrameLength,
 	u32 uDMAIdx, int bNeedAck, u8 byFBOption)
@@ -581,28 +595,16 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
     if (byPktType == PK_TYPE_11A) {
 		struct vnt_tx_datahead_ab *pBuf =
 			(struct vnt_tx_datahead_ab *)pTxDataHead;
-            //Get SignalField,ServiceField,Length
-		BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate,
-			byPktType, &pBuf->ab);
-            //Get Duration and TimeStampOff
-		pBuf->wDuration = s_uGetDataDuration(pDevice,
-				byPktType, bNeedAck);
-		pBuf->wTimeStampOff = vnt_time_stamp_off(pDevice,
-								wCurrentRate);
-            return (pBuf->wDuration);
+
+		return vnt_rxtx_datahead_ab(pDevice, byPktType,	wCurrentRate,
+				pBuf, cbFrameLength, bNeedAck);
     }
     else if (byPktType == PK_TYPE_11B) {
 		struct vnt_tx_datahead_ab *pBuf =
 			(struct vnt_tx_datahead_ab *)pTxDataHead;
-            //Get SignalField,ServiceField,Length
-		BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate,
-			byPktType, &pBuf->ab);
-            //Get Duration and TimeStampOff
-		pBuf->wDuration = s_uGetDataDuration(pDevice,
-				byPktType, bNeedAck);
-		pBuf->wTimeStampOff = vnt_time_stamp_off(pDevice,
-								wCurrentRate);
-            return (pBuf->wDuration);
+
+		return vnt_rxtx_datahead_ab(pDevice, byPktType,	wCurrentRate,
+				pBuf, cbFrameLength, bNeedAck);
     }
     return 0;
 }
@@ -703,7 +705,8 @@ static u16 vnt_rxtx_rts_ab_head(struct vnt_private *priv,
 
 	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->wDuration);
 
-	return 0;
+	return vnt_rxtx_datahead_ab(priv, pkt_type, current_rate,
+			&buf->data_head, frame_len, need_ack);
 }
 
 static u16 vnt_rxtx_rts_a_fb_head(struct vnt_private *priv,
@@ -764,7 +767,7 @@ static u16 s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 			break;
 		}
 	case PK_TYPE_11B:
-		vnt_rxtx_rts_ab_head(pDevice, &head->rts_ab,
+		return vnt_rxtx_rts_ab_head(pDevice, &head->rts_ab,
 			psEthHeader, byPktType, cbFrameLength,
 			bNeedAck, wCurrentRate, byFBOption);
 	}
@@ -947,7 +950,7 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 				cbFrameSize, wCurrentRate, bNeedACK);
 
 		/* Fill RTS */
-		s_vFillRTSHead(pDevice, byPktType, head, cbFrameSize,
+		return s_vFillRTSHead(pDevice, byPktType, head, cbFrameSize,
 			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
 	} else {
             //Fill RsvTime
@@ -978,7 +981,7 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 		}
 
 		/* Fill RTS */
-		s_vFillRTSHead(pDevice, byPktType, head, cbFrameSize,
+		return s_vFillRTSHead(pDevice, byPktType, head, cbFrameSize,
 			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
         }
         else { //RTS_needless, non PCF mode
@@ -1179,12 +1182,8 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
     else {//802.11a/b packet
         if (byFBOption == AUTO_FB_NONE) {
             if (bRTS == true) {//RTS_need
-		pvTxDataHd = (struct vnt_tx_datahead_ab *)(pbyTxBufferAddr +
-			wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR +
-						sizeof(struct vnt_rts_ab));
 		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
-			cbMICHDR + sizeof(struct vnt_rts_ab) +
-				sizeof(struct vnt_tx_datahead_ab);
+			cbMICHDR + sizeof(struct vnt_rts_ab);
             }
             else if (bRTS == false) { //RTS_needless, no MICHDR
 		pvTxDataHd = (struct vnt_tx_datahead_ab *)(pbyTxBufferAddr +
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index d8f25d1..d905b97 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -140,6 +140,7 @@ struct vnt_rts_ab {
 	u16 wDuration;
 	u16 wReserved;
 	struct ieee80211_rts data;
+	struct vnt_tx_datahead_ab data_head;
 } __packed;
 
 struct vnt_rts_a_fb {
-- 
1.8.3.2



