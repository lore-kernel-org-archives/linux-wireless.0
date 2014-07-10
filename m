Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48132 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbaGJS4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 14:56:52 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so5427wgh.15
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 11:56:47 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/16] staging: vt6656: rxtx remove fb_option from functions.
Date: Thu, 10 Jul 2014 19:56:04 +0100
Message-Id: <1405018577-6832-3-git-send-email-tvboxspy@gmail.com> (sfid-20140710_205659_943177_AF984BD2)
In-Reply-To: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
References: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is now dead code.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 84 +++++++++++++++++++------------------------
 1 file changed, 36 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index a556d81..57e1dff 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -96,18 +96,18 @@ static __le16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
 
 static u16 s_vFillCTSHead(struct vnt_usb_send_context *tx_context,
 	u8 byPktType, union vnt_tx_data_head *head, u32 cbFrameLength,
-	int bNeedAck, u16 wCurrentRate, u8 byFBOption);
+	int bNeedAck, u16 wCurrentRate);
 
 static u16 s_vFillRTSHead(struct vnt_usb_send_context *tx_context, u8 byPktType,
 	union vnt_tx_data_head *head, u32 cbFrameLength, int bNeedAck,
-	u16 wCurrentRate, u8 byFBOption);
+	u16 wCurrentRate);
 
 static __le16 s_uGetDataDuration(struct vnt_private *pDevice,
 	u8 byPktType, int bNeedAck);
 
 static __le16 s_uGetRTSCTSDuration(struct vnt_private *pDevice,
 	u8 byDurType, u32 cbFrameLength, u8 byPktType, u16 wRate,
-	int bNeedAck, u8 byFBOption);
+	int bNeedAck);
 
 static struct vnt_usb_send_context
 	*s_vGetFreeContext(struct vnt_private *priv)
@@ -243,8 +243,7 @@ static __le16 s_uGetDataDuration(struct vnt_private *pDevice,
 
 //byFreqType: 0=>5GHZ 1=>2.4GHZ
 static __le16 s_uGetRTSCTSDuration(struct vnt_private *pDevice, u8 byDurType,
-	u32 cbFrameLength, u8 byPktType, u16 wRate, int bNeedAck,
-	u8 byFBOption)
+	u32 cbFrameLength, u8 byPktType, u16 wRate, int bNeedAck)
 {
 	u32 uCTSTime = 0, uDurTime = 0;
 
@@ -426,7 +425,7 @@ static int vnt_fill_ieee80211_rts(struct vnt_usb_send_context *tx_context,
 
 static u16 vnt_rxtx_rts_g_head(struct vnt_usb_send_context *tx_context,
 	struct vnt_rts_g *buf, u8 pkt_type, u32 frame_len, int need_ack,
-	u16 current_rate, u8 fb_option)
+	u16 current_rate)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
@@ -437,11 +436,11 @@ static u16 vnt_rxtx_rts_g_head(struct vnt_usb_send_context *tx_context,
 		priv->byTopOFDMBasicRate, pkt_type, &buf->a);
 
 	buf->duration_bb = s_uGetRTSCTSDuration(priv, RTSDUR_BB, frame_len,
-		PK_TYPE_11B, priv->byTopCCKBasicRate, need_ack, fb_option);
+		PK_TYPE_11B, priv->byTopCCKBasicRate, need_ack);
 	buf->duration_aa = s_uGetRTSCTSDuration(priv, RTSDUR_AA, frame_len,
-		pkt_type, current_rate, need_ack, fb_option);
+		pkt_type, current_rate, need_ack);
 	buf->duration_ba = s_uGetRTSCTSDuration(priv, RTSDUR_BA, frame_len,
-		pkt_type, current_rate, need_ack, fb_option);
+		pkt_type, current_rate, need_ack);
 
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration_aa);
 
@@ -451,7 +450,7 @@ static u16 vnt_rxtx_rts_g_head(struct vnt_usb_send_context *tx_context,
 
 static u16 vnt_rxtx_rts_g_fb_head(struct vnt_usb_send_context *tx_context,
 	struct vnt_rts_g_fb *buf, u8 pkt_type, u32 frame_len, int need_ack,
-	u16 current_rate, u8 fb_option)
+	u16 current_rate)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
@@ -463,21 +462,21 @@ static u16 vnt_rxtx_rts_g_fb_head(struct vnt_usb_send_context *tx_context,
 
 
 	buf->duration_bb = s_uGetRTSCTSDuration(priv, RTSDUR_BB, frame_len,
-		PK_TYPE_11B, priv->byTopCCKBasicRate, need_ack, fb_option);
+		PK_TYPE_11B, priv->byTopCCKBasicRate, need_ack);
 	buf->duration_aa = s_uGetRTSCTSDuration(priv, RTSDUR_AA, frame_len,
-		pkt_type, current_rate, need_ack, fb_option);
+		pkt_type, current_rate, need_ack);
 	buf->duration_ba = s_uGetRTSCTSDuration(priv, RTSDUR_BA, frame_len,
-		pkt_type, current_rate, need_ack, fb_option);
+		pkt_type, current_rate, need_ack);
 
 
 	buf->rts_duration_ba_f0 = s_uGetRTSCTSDuration(priv, RTSDUR_BA_F0,
-		frame_len, pkt_type, priv->tx_rate_fb0, need_ack, fb_option);
+		frame_len, pkt_type, priv->tx_rate_fb0, need_ack);
 	buf->rts_duration_aa_f0 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F0,
-		frame_len, pkt_type, priv->tx_rate_fb0, need_ack, fb_option);
+		frame_len, pkt_type, priv->tx_rate_fb0, need_ack);
 	buf->rts_duration_ba_f1 = s_uGetRTSCTSDuration(priv, RTSDUR_BA_F1,
-		frame_len, pkt_type, priv->tx_rate_fb1, need_ack, fb_option);
+		frame_len, pkt_type, priv->tx_rate_fb1, need_ack);
 	buf->rts_duration_aa_f1 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F1,
-		frame_len, pkt_type, priv->tx_rate_fb1, need_ack, fb_option);
+		frame_len, pkt_type, priv->tx_rate_fb1, need_ack);
 
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration_aa);
 
@@ -487,7 +486,7 @@ static u16 vnt_rxtx_rts_g_fb_head(struct vnt_usb_send_context *tx_context,
 
 static u16 vnt_rxtx_rts_ab_head(struct vnt_usb_send_context *tx_context,
 	struct vnt_rts_ab *buf,	u8 pkt_type, u32 frame_len, int need_ack,
-	u16 current_rate, u8 fb_option)
+	u16 current_rate)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
@@ -496,7 +495,7 @@ static u16 vnt_rxtx_rts_ab_head(struct vnt_usb_send_context *tx_context,
 		priv->byTopOFDMBasicRate, pkt_type, &buf->ab);
 
 	buf->duration = s_uGetRTSCTSDuration(priv, RTSDUR_AA, frame_len,
-		pkt_type, current_rate, need_ack, fb_option);
+		pkt_type, current_rate, need_ack);
 
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration);
 
@@ -506,7 +505,7 @@ static u16 vnt_rxtx_rts_ab_head(struct vnt_usb_send_context *tx_context,
 
 static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
 	struct vnt_rts_a_fb *buf, u8 pkt_type, u32 frame_len, int need_ack,
-	u16 current_rate, u8 fb_option)
+	u16 current_rate)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
@@ -515,13 +514,13 @@ static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
 		priv->byTopOFDMBasicRate, pkt_type, &buf->a);
 
 	buf->duration = s_uGetRTSCTSDuration(priv, RTSDUR_AA, frame_len,
-		pkt_type, current_rate, need_ack, fb_option);
+		pkt_type, current_rate, need_ack);
 
 	buf->rts_duration_f0 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F0,
-		frame_len, pkt_type, priv->tx_rate_fb0, need_ack, fb_option);
+		frame_len, pkt_type, priv->tx_rate_fb0, need_ack);
 
 	buf->rts_duration_f1 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F1,
-		frame_len, pkt_type, priv->tx_rate_fb1, need_ack, fb_option);
+		frame_len, pkt_type, priv->tx_rate_fb1, need_ack);
 
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration);
 
@@ -531,7 +530,7 @@ static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
 
 static u16 s_vFillRTSHead(struct vnt_usb_send_context *tx_context, u8 byPktType,
 	union vnt_tx_data_head *head, u32 cbFrameLength, int bNeedAck,
-	u16 wCurrentRate, u8 byFBOption)
+	u16 wCurrentRate)
 {
 
 	if (!head)
@@ -548,25 +547,23 @@ static u16 s_vFillRTSHead(struct vnt_usb_send_context *tx_context, u8 byPktType,
 		if (!tx_context->fb_option)
 			return vnt_rxtx_rts_g_head(tx_context, &head->rts_g,
 				byPktType, cbFrameLength,
-				bNeedAck, wCurrentRate, byFBOption);
+				bNeedAck, wCurrentRate);
 		else
 			return vnt_rxtx_rts_g_fb_head(tx_context,
 				&head->rts_g_fb, byPktType,
-				cbFrameLength, bNeedAck, wCurrentRate,
-				byFBOption);
+				cbFrameLength, bNeedAck, wCurrentRate);
 		break;
 	case PK_TYPE_11A:
 		if (tx_context->fb_option) {
 			return vnt_rxtx_rts_a_fb_head(tx_context,
 				&head->rts_a_fb, byPktType,
-				cbFrameLength, bNeedAck, wCurrentRate,
-				byFBOption);
+				cbFrameLength, bNeedAck, wCurrentRate);
 			break;
 		}
 	case PK_TYPE_11B:
 		return vnt_rxtx_rts_ab_head(tx_context, &head->rts_ab,
 				byPktType, cbFrameLength, bNeedAck,
-						wCurrentRate, byFBOption);
+						wCurrentRate);
 	}
 
 	return 0;
@@ -574,7 +571,7 @@ static u16 s_vFillRTSHead(struct vnt_usb_send_context *tx_context, u8 byPktType,
 
 static u16 s_vFillCTSHead(struct vnt_usb_send_context *tx_context,
 	u8 byPktType, union vnt_tx_data_head *head, u32 cbFrameLength,
-	int bNeedAck, u16 wCurrentRate, u8 byFBOption)
+	int bNeedAck, u16 wCurrentRate)
 {
 	struct vnt_private *pDevice = tx_context->priv;
 	u32 uCTSFrameLen = 14;
@@ -590,15 +587,15 @@ static u16 s_vFillCTSHead(struct vnt_usb_send_context *tx_context,
 			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
 		pBuf->duration_ba = s_uGetRTSCTSDuration(pDevice, CTSDUR_BA,
 			cbFrameLength, byPktType,
-			wCurrentRate, bNeedAck, byFBOption);
+			wCurrentRate, bNeedAck);
 		/* Get CTSDuration_ba_f0 */
 		pBuf->cts_duration_ba_f0 = s_uGetRTSCTSDuration(pDevice,
 			CTSDUR_BA_F0, cbFrameLength, byPktType,
-			pDevice->tx_rate_fb0, bNeedAck, byFBOption);
+			pDevice->tx_rate_fb0, bNeedAck);
 		/* Get CTSDuration_ba_f1 */
 		pBuf->cts_duration_ba_f1 = s_uGetRTSCTSDuration(pDevice,
 			CTSDUR_BA_F1, cbFrameLength, byPktType,
-			pDevice->tx_rate_fb1, bNeedAck, byFBOption);
+			pDevice->tx_rate_fb1, bNeedAck);
 		/* Get CTS Frame body */
 		pBuf->data.duration = pBuf->duration_ba;
 		pBuf->data.frame_control =
@@ -617,7 +614,7 @@ static u16 s_vFillCTSHead(struct vnt_usb_send_context *tx_context,
 		/* Get CTSDuration_ba */
 		pBuf->duration_ba = s_uGetRTSCTSDuration(pDevice,
 			CTSDUR_BA, cbFrameLength, byPktType,
-			wCurrentRate, bNeedAck, byFBOption);
+			wCurrentRate, bNeedAck);
 		/*Get CTS Frame body*/
 		pBuf->data.duration = pBuf->duration_ba;
 		pBuf->data.frame_control =
@@ -662,16 +659,8 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 	struct vnt_private *pDevice = tx_context->priv;
 	struct vnt_tx_fifo_head *pFifoHead = &tx_buffer->fifo_head;
 	union vnt_tx_data_head *head = NULL;
-	u16 wFifoCtl;
-	u8 byFBOption = AUTO_FB_NONE;
 
 	pFifoHead->current_rate = cpu_to_le16(wCurrentRate);
-	wFifoCtl = pFifoHead->wFIFOCtl;
-
-	if (wFifoCtl & FIFOCTL_AUTO_FB_0)
-		byFBOption = AUTO_FB_0;
-	else if (wFifoCtl & FIFOCTL_AUTO_FB_1)
-		byFBOption = AUTO_FB_1;
 
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
 		if (need_rts) {
@@ -702,7 +691,7 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 			/* Fill RTS */
 			return s_vFillRTSHead(tx_context, byPktType, head,
 						cbFrameSize, bNeedACK,
-						wCurrentRate, byFBOption);
+						wCurrentRate);
 
 		} else {
 			struct vnt_rrv_time_cts *pBuf = &tx_buffer->
@@ -727,8 +716,7 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 
 			/* Fill CTS */
 			return s_vFillCTSHead(tx_context, byPktType,
-				head, cbFrameSize, bNeedACK, wCurrentRate,
-					byFBOption);
+				head, cbFrameSize, bNeedACK, wCurrentRate);
 		}
 	} else if (byPktType == PK_TYPE_11A) {
 		if (need_mic) {
@@ -751,7 +739,7 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 			/* Fill RTS */
 			return s_vFillRTSHead(tx_context, byPktType, head,
 						cbFrameSize, bNeedACK,
-						wCurrentRate, byFBOption);
+						wCurrentRate);
 		} else {
 			struct vnt_rrv_time_ab *pBuf = &tx_buffer->
 							tx_head.tx_ab.ab;
@@ -786,7 +774,7 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 			/* Fill RTS */
 			return s_vFillRTSHead(tx_context, byPktType, head,
 						cbFrameSize, bNeedACK,
-						wCurrentRate, byFBOption);
+						wCurrentRate);
 		} else {
 			struct vnt_rrv_time_ab *pBuf = &tx_buffer->
 							tx_head.tx_ab.ab;
-- 
1.9.1

