Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:50138 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab3JAOzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 10:55:03 -0400
Received: by mail-we0-f177.google.com with SMTP id t60so7329103wes.22
        for <linux-wireless@vger.kernel.org>; Tue, 01 Oct 2013 07:55:01 -0700 (PDT)
Message-ID: <1380639296.2087.3.camel@canaries64-MCP7A> (sfid-20131001_165508_208054_23969BA6)
Subject: [PATCH 3/8] staging: vt6656: rxtx.c Parse struct
 vnt_tx_datahead_g_fb
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Oct 2013 15:54:56 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Parse struct vnt_tx_datahead_g_fb from s_uFillDataHead and
move to struct vnt_rts_g_fb/struct vnt_cts_fb structure returning
duration down functions.

This removes pvTxDataHd pointer assignment.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 74 +++++++++++++++++++------------------------
 drivers/staging/vt6656/rxtx.h |  2 ++
 2 files changed, 35 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 58a9d8a..a56a49a 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -528,6 +528,30 @@ static u16 vnt_rxtx_datahead_g(struct vnt_private *priv, u8 pkt_type, u16 rate,
 	return buf->wDuration_a;
 }
 
+static u16 vnt_rxtx_datahead_g_fb(struct vnt_private *priv, u8 pkt_type,
+		u16 rate, struct vnt_tx_datahead_g_fb *buf,
+		u32 frame_len, int need_ack)
+{
+	/* Get SignalField,ServiceField,Length */
+	BBvCalculateParameter(priv, frame_len, rate, pkt_type, &buf->a);
+
+	BBvCalculateParameter(priv, frame_len, priv->byTopCCKBasicRate,
+						PK_TYPE_11B, &buf->b);
+
+	/* Get Duration and TimeStamp */
+	buf->wDuration_a = s_uGetDataDuration(priv, pkt_type, need_ack);
+	buf->wDuration_b = s_uGetDataDuration(priv, PK_TYPE_11B, need_ack);
+
+	buf->wDuration_a_f0 = s_uGetDataDuration(priv, pkt_type, need_ack);
+	buf->wDuration_a_f1 = s_uGetDataDuration(priv, pkt_type, need_ack);
+
+	buf->wTimeStampOff_a = vnt_time_stamp_off(priv, rate);
+	buf->wTimeStampOff_b = vnt_time_stamp_off(priv,
+						priv->byTopCCKBasicRate);
+
+	return buf->wDuration_a;
+}
+
 static u32 s_uFillDataHead(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate, void *pTxDataHead, u32 cbFrameLength,
 	u32 uDMAIdx, int bNeedAck, u8 byFBOption)
@@ -537,35 +561,7 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
         return 0;
     }
 
-    if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
-            if (byFBOption == AUTO_FB_NONE) {
-		;
-             } else {
-                // Auto Fallback
-		struct vnt_tx_datahead_g_fb *pBuf =
-			(struct vnt_tx_datahead_g_fb *)pTxDataHead;
-                //Get SignalField,ServiceField,Length
-		BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate,
-			byPktType, &pBuf->a);
-		BBvCalculateParameter(pDevice, cbFrameLength,
-			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
-                //Get Duration and TimeStamp
-		pBuf->wDuration_a = s_uGetDataDuration(pDevice,
-							byPktType, bNeedAck);
-		pBuf->wDuration_b = s_uGetDataDuration(pDevice,
-							PK_TYPE_11B, bNeedAck);
-		pBuf->wDuration_a_f0 = s_uGetDataDuration(pDevice,
-							byPktType, bNeedAck);
-		pBuf->wDuration_a_f1 = s_uGetDataDuration(pDevice,
-							byPktType, bNeedAck);
-		pBuf->wTimeStampOff_a = vnt_time_stamp_off(pDevice,
-								wCurrentRate);
-		pBuf->wTimeStampOff_b = vnt_time_stamp_off(pDevice,
-						pDevice->byTopCCKBasicRate);
-                return (pBuf->wDuration_a);
-            } //if (byFBOption == AUTO_FB_NONE)
-    }
-    else if (byPktType == PK_TYPE_11A) {
+    if (byPktType == PK_TYPE_11A) {
 	if (byFBOption != AUTO_FB_NONE) {
 		struct vnt_tx_datahead_a_fb *pBuf =
 			(struct vnt_tx_datahead_a_fb *)pTxDataHead;
@@ -689,7 +685,8 @@ static u16 vnt_rxtx_rts_g_fb_head(struct vnt_private *priv,
 
 	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->wDuration_aa);
 
-	return 0;
+	return vnt_rxtx_datahead_g_fb(priv, pkt_type, current_rate,
+			&buf->data_head, frame_len, need_ack);
 }
 
 static u16 vnt_rxtx_rts_ab_head(struct vnt_private *priv,
@@ -755,7 +752,7 @@ static u16 s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 				psEthHeader, byPktType, cbFrameLength,
 				bNeedAck, wCurrentRate, byFBOption);
 		else
-			vnt_rxtx_rts_g_fb_head(pDevice, &head->rts_g_fb,
+			return vnt_rxtx_rts_g_fb_head(pDevice, &head->rts_g_fb,
 				psEthHeader, byPktType, cbFrameLength,
 				bNeedAck, wCurrentRate, byFBOption);
 		break;
@@ -805,6 +802,9 @@ static u16 s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 		pBuf->data.duration = pBuf->wDuration_ba;
 		pBuf->data.frame_control = TYPE_CTL_CTS;
 		memcpy(pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
+
+		return vnt_rxtx_datahead_g_fb(pDevice, byPktType, wCurrentRate,
+				&pBuf->data_head, cbFrameLength, bNeedAck);
 	} else {
 		struct vnt_cts *pBuf = &head->cts_g;
 		/* Get SignalField,ServiceField,Length */
@@ -1167,20 +1167,12 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
         } else {
             // Auto Fall Back
             if (bRTS == true) {//RTS_need
-		pvTxDataHd = (struct vnt_tx_datahead_g_fb *) (pbyTxBufferAddr +
-			wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
-				cbMICHDR + sizeof(struct vnt_rts_g_fb));
 		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
-			cbMICHDR + sizeof(struct vnt_rts_g_fb) +
-				sizeof(struct vnt_tx_datahead_g_fb);
+			cbMICHDR + sizeof(struct vnt_rts_g_fb);
             }
             else if (bRTS == false) { //RTS_needless
-		pvTxDataHd = (struct vnt_tx_datahead_g_fb *) (pbyTxBufferAddr +
-			wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
-				cbMICHDR + sizeof(struct vnt_cts_fb));
 		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
-				cbMICHDR + sizeof(struct vnt_cts_fb) +
-					sizeof(struct vnt_tx_datahead_g_fb);
+				cbMICHDR + sizeof(struct vnt_cts_fb);
             }
         } // Auto Fall Back
     }
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index ea20e94..0a022cf 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -132,6 +132,7 @@ struct vnt_rts_g_fb {
 	u16 wRTSDuration_ba_f1;
 	u16 wRTSDuration_aa_f1;
 	struct ieee80211_rts data;
+	struct vnt_tx_datahead_g_fb data_head;
 } __packed;
 
 struct vnt_rts_ab {
@@ -168,6 +169,7 @@ struct vnt_cts_fb {
 	u16 wCTSDuration_ba_f1;
 	struct ieee80211_cts data;
 	u16 reserved2;
+	struct vnt_tx_datahead_g_fb data_head;
 } __packed;
 
 union vnt_tx_data_head {
-- 
1.8.3.2

