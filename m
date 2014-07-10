Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:55226 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbaGJS4r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 14:56:47 -0400
Received: by mail-we0-f169.google.com with SMTP id t60so4619wes.14
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 11:56:43 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/16] staging: vt6656: rxtx remove struct ethhdr from functions
Date: Thu, 10 Jul 2014 19:56:02 +0100
Message-Id: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com> (sfid-20140710_205650_529936_C890509E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ethhdr is nolonger used by driver.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 264e3c9..998a62a 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -86,7 +86,7 @@ static struct vnt_usb_send_context *s_vGetFreeContext(struct vnt_private *);
 static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 	u8 byPktType, u16 wCurrentRate,	struct vnt_tx_buffer *tx_buffer,
 	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 cbFrameSize,
-	int bNeedACK, struct ethhdr *psEthHeader, bool need_rts);
+	int bNeedACK, bool need_rts);
 
 static unsigned int s_uGetTxRsvTime(struct vnt_private *pDevice, u8 byPktType,
 	u32 cbFrameLength, u16 wRate, int bNeedAck);
@@ -100,7 +100,7 @@ static u16 s_vFillCTSHead(struct vnt_usb_send_context *tx_context,
 
 static u16 s_vFillRTSHead(struct vnt_usb_send_context *tx_context, u8 byPktType,
 	union vnt_tx_data_head *head, u32 cbFrameLength, int bNeedAck,
-	struct ethhdr *psEthHeader, u16 wCurrentRate, u8 byFBOption);
+	u16 wCurrentRate, u8 byFBOption);
 
 static __le16 s_uGetDataDuration(struct vnt_private *pDevice,
 	u8 byPktType, int bNeedAck);
@@ -425,8 +425,7 @@ static int vnt_fill_ieee80211_rts(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_rts_g_head(struct vnt_usb_send_context *tx_context,
-	struct vnt_rts_g *buf, struct ethhdr *eth_hdr,
-	u8 pkt_type, u32 frame_len, int need_ack,
+	struct vnt_rts_g *buf, u8 pkt_type, u32 frame_len, int need_ack,
 	u16 current_rate, u8 fb_option)
 {
 	struct vnt_private *priv = tx_context->priv;
@@ -451,8 +450,7 @@ static u16 vnt_rxtx_rts_g_head(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_rts_g_fb_head(struct vnt_usb_send_context *tx_context,
-	struct vnt_rts_g_fb *buf, struct ethhdr *eth_hdr,
-	u8 pkt_type, u32 frame_len, int need_ack,
+	struct vnt_rts_g_fb *buf, u8 pkt_type, u32 frame_len, int need_ack,
 	u16 current_rate, u8 fb_option)
 {
 	struct vnt_private *priv = tx_context->priv;
@@ -488,8 +486,7 @@ static u16 vnt_rxtx_rts_g_fb_head(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_rts_ab_head(struct vnt_usb_send_context *tx_context,
-	struct vnt_rts_ab *buf, struct ethhdr *eth_hdr,
-	u8 pkt_type, u32 frame_len, int need_ack,
+	struct vnt_rts_ab *buf,	u8 pkt_type, u32 frame_len, int need_ack,
 	u16 current_rate, u8 fb_option)
 {
 	struct vnt_private *priv = tx_context->priv;
@@ -508,8 +505,7 @@ static u16 vnt_rxtx_rts_ab_head(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
-	struct vnt_rts_a_fb *buf, struct ethhdr *eth_hdr,
-	u8 pkt_type, u32 frame_len, int need_ack,
+	struct vnt_rts_a_fb *buf, u8 pkt_type, u32 frame_len, int need_ack,
 	u16 current_rate, u8 fb_option)
 {
 	struct vnt_private *priv = tx_context->priv;
@@ -535,7 +531,7 @@ static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
 
 static u16 s_vFillRTSHead(struct vnt_usb_send_context *tx_context, u8 byPktType,
 	union vnt_tx_data_head *head, u32 cbFrameLength, int bNeedAck,
-	struct ethhdr *psEthHeader, u16 wCurrentRate, u8 byFBOption)
+	u16 wCurrentRate, u8 byFBOption)
 {
 
 	if (!head)
@@ -551,26 +547,26 @@ static u16 s_vFillRTSHead(struct vnt_usb_send_context *tx_context, u8 byPktType,
 	case PK_TYPE_11GA:
 		if (byFBOption == AUTO_FB_NONE)
 			return vnt_rxtx_rts_g_head(tx_context, &head->rts_g,
-				psEthHeader, byPktType, cbFrameLength,
+				byPktType, cbFrameLength,
 				bNeedAck, wCurrentRate, byFBOption);
 		else
 			return vnt_rxtx_rts_g_fb_head(tx_context,
-				&head->rts_g_fb, psEthHeader, byPktType,
+				&head->rts_g_fb, byPktType,
 				cbFrameLength, bNeedAck, wCurrentRate,
 				byFBOption);
 		break;
 	case PK_TYPE_11A:
 		if (byFBOption) {
 			return vnt_rxtx_rts_a_fb_head(tx_context,
-				&head->rts_a_fb, psEthHeader, byPktType,
+				&head->rts_a_fb, byPktType,
 				cbFrameLength, bNeedAck, wCurrentRate,
 				byFBOption);
 			break;
 		}
 	case PK_TYPE_11B:
 		return vnt_rxtx_rts_ab_head(tx_context, &head->rts_ab,
-			psEthHeader, byPktType, cbFrameLength,
-			bNeedAck, wCurrentRate, byFBOption);
+				byPktType, cbFrameLength, bNeedAck,
+						wCurrentRate, byFBOption);
 	}
 
 	return 0;
@@ -661,7 +657,7 @@ static u16 s_vFillCTSHead(struct vnt_usb_send_context *tx_context,
 static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 	u8 byPktType, u16 wCurrentRate,	struct vnt_tx_buffer *tx_buffer,
 	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 cbFrameSize,
-	int bNeedACK, struct ethhdr *psEthHeader, bool need_rts)
+	int bNeedACK, bool need_rts)
 {
 	struct vnt_private *pDevice = tx_context->priv;
 	struct vnt_tx_fifo_head *pFifoHead = &tx_buffer->fifo_head;
@@ -705,7 +701,7 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 
 			/* Fill RTS */
 			return s_vFillRTSHead(tx_context, byPktType, head,
-					cbFrameSize, bNeedACK, psEthHeader,
+						cbFrameSize, bNeedACK,
 						wCurrentRate, byFBOption);
 
 		} else {
@@ -754,8 +750,8 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 
 			/* Fill RTS */
 			return s_vFillRTSHead(tx_context, byPktType, head,
-				cbFrameSize, bNeedACK, psEthHeader,
-					wCurrentRate, byFBOption);
+						cbFrameSize, bNeedACK,
+						wCurrentRate, byFBOption);
 		} else {
 			struct vnt_rrv_time_ab *pBuf = &tx_buffer->
 							tx_head.tx_ab.ab;
@@ -789,8 +785,8 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 
 			/* Fill RTS */
 			return s_vFillRTSHead(tx_context, byPktType, head,
-				cbFrameSize,
-			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
+						cbFrameSize, bNeedACK,
+						wCurrentRate, byFBOption);
 		} else {
 			struct vnt_rrv_time_ab *pBuf = &tx_buffer->
 							tx_head.tx_ab.ab;
@@ -1025,7 +1021,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	duration_id = s_vGenerateTxParameter(tx_context, pkt_type, current_rate,
 				tx_buffer, &mic_hdr, need_mic, frame_size,
-						need_ack, NULL, need_rts);
+						need_ack, need_rts);
 
 	tx_header_size = tx_context->tx_hdr_size;
 	if (!tx_header_size) {
-- 
1.9.1

