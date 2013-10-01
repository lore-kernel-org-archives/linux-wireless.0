Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:59815 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab3JAO4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 10:56:53 -0400
Received: by mail-we0-f179.google.com with SMTP id x55so7253580wes.24
        for <linux-wireless@vger.kernel.org>; Tue, 01 Oct 2013 07:56:52 -0700 (PDT)
Message-ID: <1380639408.2087.4.camel@canaries64-MCP7A> (sfid-20131001_165656_767233_44AABB43)
Subject: [PATCH 4/8] staging: vt6656: rxtx.c parse out struct
 vnt_tx_datahead_a_fb
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Oct 2013 15:56:48 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Parse struct vnt_tx_datahead_a_fb from s_uFillDataHead and
move to struct vnt_rts_a_fb structure returning duration down
functions.

This removes pvTxDataHd pointer assignment.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 49 ++++++++++++++++++++++++-------------------
 drivers/staging/vt6656/rxtx.h |  1 +
 2 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index a56a49a..b2c4786 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -552,6 +552,23 @@ static u16 vnt_rxtx_datahead_g_fb(struct vnt_private *priv, u8 pkt_type,
 	return buf->wDuration_a;
 }
 
+static u16 vnt_rxtx_datahead_a_fb(struct vnt_private *priv, u8 pkt_type,
+		u16 rate, struct vnt_tx_datahead_a_fb *buf,
+		u32 frame_len, int need_ack)
+{
+	/* Get SignalField,ServiceField,Length */
+	BBvCalculateParameter(priv, frame_len, rate, pkt_type, &buf->a);
+	/* Get Duration and TimeStampOff */
+	buf->wDuration = s_uGetDataDuration(priv, pkt_type, need_ack);
+
+	buf->wDuration_f0 = s_uGetDataDuration(priv, pkt_type, need_ack);
+	buf->wDuration_f1 = s_uGetDataDuration(priv, pkt_type, need_ack);
+
+	buf->wTimeStampOff = vnt_time_stamp_off(priv, rate);
+
+	return buf->wDuration;
+}
+
 static u32 s_uFillDataHead(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate, void *pTxDataHead, u32 cbFrameLength,
 	u32 uDMAIdx, int bNeedAck, u8 byFBOption)
@@ -565,19 +582,9 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 	if (byFBOption != AUTO_FB_NONE) {
 		struct vnt_tx_datahead_a_fb *pBuf =
 			(struct vnt_tx_datahead_a_fb *)pTxDataHead;
-            //Get SignalField,ServiceField,Length
-		BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate,
-			byPktType, &pBuf->a);
-            //Get Duration and TimeStampOff
-		pBuf->wDuration = s_uGetDataDuration(pDevice,
-					byPktType, bNeedAck);
-		pBuf->wDuration_f0 = s_uGetDataDuration(pDevice,
-					byPktType, bNeedAck);
-		pBuf->wDuration_f1 = s_uGetDataDuration(pDevice,
-							byPktType, bNeedAck);
-		pBuf->wTimeStampOff = vnt_time_stamp_off(pDevice,
-								wCurrentRate);
-            return (pBuf->wDuration);
+
+		return vnt_rxtx_datahead_a_fb(pDevice, byPktType, wCurrentRate,
+					pBuf, cbFrameLength, bNeedAck);
         } else {
 		struct vnt_tx_datahead_ab *pBuf =
 			(struct vnt_tx_datahead_ab *)pTxDataHead;
@@ -728,7 +735,8 @@ static u16 vnt_rxtx_rts_a_fb_head(struct vnt_private *priv,
 
 	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->wDuration);
 
-	return 0;
+	return vnt_rxtx_datahead_a_fb(priv, pkt_type, current_rate,
+			&buf->data_head, frame_len, need_ack);
 }
 
 static u16 s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
@@ -758,7 +766,7 @@ static u16 s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 		break;
 	case PK_TYPE_11A:
 		if (byFBOption) {
-			vnt_rxtx_rts_a_fb_head(pDevice, &head->rts_a_fb,
+			return vnt_rxtx_rts_a_fb_head(pDevice, &head->rts_a_fb,
 				psEthHeader, byPktType, cbFrameLength,
 				bNeedAck, wCurrentRate, byFBOption);
 			break;
@@ -1195,12 +1203,8 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
         } else {
             // Auto Fall Back
             if (bRTS == true) {//RTS_need
-		pvTxDataHd = (struct vnt_tx_datahead_a_fb *)(pbyTxBufferAddr +
-			wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR +
-					sizeof(struct vnt_rts_a_fb));
 		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
-			cbMICHDR + sizeof(struct vnt_rts_a_fb) +
-					sizeof(struct vnt_tx_datahead_a_fb);
+			cbMICHDR + sizeof(struct vnt_rts_a_fb);
             }
             else if (bRTS == false) { //RTS_needless
 		pvTxDataHd = (struct vnt_tx_datahead_a_fb *)(pbyTxBufferAddr +
@@ -1228,8 +1232,9 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 			tx_buffer, &pMICHDR, cbMICHDR,
 			cbFrameSize, bNeedACK, uDMAIdx, psEthHeader, bRTS);
     //Fill DataHead
-    uDuration |= s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd,
-		cbFrameSize, uDMAIdx, bNeedACK,	byFBOption);
+	if (pvTxDataHd)
+    		uDuration |= s_uFillDataHead(pDevice, byPktType, wCurrentRate,
+		pvTxDataHd, cbFrameSize, uDMAIdx, bNeedACK, byFBOption);
     // Generate TX MAC Header
     s_vGenerateMACHeader(pDevice, pbyMacHdr, (u16)uDuration, psEthHeader, bNeedEncryption,
                            byFragType, uDMAIdx, 0);
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 0a022cf..3fd8507 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -149,6 +149,7 @@ struct vnt_rts_a_fb {
 	u16 wRTSDuration_f0;
 	u16 wRTSDuration_f1;
 	struct ieee80211_rts data;
+	struct vnt_tx_datahead_a_fb data_head;
 } __packed;
 
 /* CTS buffer header */
-- 
1.8.3.2



