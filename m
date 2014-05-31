Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34375 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298AbaEaMf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 08:35:56 -0400
Received: by mail-wi0-f177.google.com with SMTP id f8so2367011wiw.16
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 05:35:52 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/4] staging: vt6656: rxtx move vnt_usb_send_context into tx structure.
Date: Sat, 31 May 2014 13:34:57 +0100
Message-Id: <1401539700-3183-1-git-send-email-tvboxspy@gmail.com> (sfid-20140531_143604_604341_79F969B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing struct vnt_private.

Where struct vnt_private is needed pointer to priv is added.

This allows to move tx signaling into vnt_usb_send_context.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 108 +++++++++++++++++++++++++-----------------
 1 file changed, 64 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 704f4d3..fa04894 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -96,7 +96,7 @@ static void s_vSaveTxPktInfo(struct vnt_private *pDevice, u8 byPktNum,
 
 static struct vnt_usb_send_context *s_vGetFreeContext(struct vnt_private *);
 
-static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
+static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 	u8 byPktType, u16 wCurrentRate,	struct vnt_tx_buffer *tx_buffer,
 	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 cbFrameSize,
 	int bNeedACK, struct ethhdr *psEthHeader, bool need_rts);
@@ -119,11 +119,11 @@ static unsigned int s_uGetTxRsvTime(struct vnt_private *pDevice, u8 byPktType,
 static __le16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
 	u8 rsv_type, u8 pkt_type, u32 frame_length, u16 current_rate);
 
-static u16 s_vFillCTSHead(struct vnt_private *pDevice,
+static u16 s_vFillCTSHead(struct vnt_usb_send_context *tx_context,
 	u8 byPktType, union vnt_tx_data_head *head, u32 cbFrameLength,
 	int bNeedAck, u16 wCurrentRate, u8 byFBOption);
 
-static u16 s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
+static u16 s_vFillRTSHead(struct vnt_usb_send_context *tx_context, u8 byPktType,
 	union vnt_tx_data_head *head, u32 cbFrameLength, int bNeedAck,
 	struct ethhdr *psEthHeader, u16 wCurrentRate, u8 byFBOption);
 
@@ -470,9 +470,13 @@ static __le16 s_uGetRTSCTSDuration(struct vnt_private *pDevice, u8 byDurType,
 	return cpu_to_le16((u16)uDurTime);
 }
 
-static u16 vnt_rxtx_datahead_g(struct vnt_private *priv, u8 pkt_type, u16 rate,
-		struct vnt_tx_datahead_g *buf, u32 frame_len, int need_ack)
+static u16 vnt_rxtx_datahead_g(struct vnt_usb_send_context *tx_context,
+		u8 pkt_type, u16 rate, struct vnt_tx_datahead_g *buf,
+		u32 frame_len, int need_ack)
 {
+
+	struct vnt_private *priv = tx_context->priv;
+
 	/* Get SignalField,ServiceField,Length */
 	BBvCalculateParameter(priv, frame_len, rate, pkt_type, &buf->a);
 	BBvCalculateParameter(priv, frame_len, priv->byTopCCKBasicRate,
@@ -489,10 +493,12 @@ static u16 vnt_rxtx_datahead_g(struct vnt_private *priv, u8 pkt_type, u16 rate,
 	return le16_to_cpu(buf->duration_a);
 }
 
-static u16 vnt_rxtx_datahead_g_fb(struct vnt_private *priv, u8 pkt_type,
-		u16 rate, struct vnt_tx_datahead_g_fb *buf,
+static u16 vnt_rxtx_datahead_g_fb(struct vnt_usb_send_context *tx_context,
+		u8 pkt_type, u16 rate, struct vnt_tx_datahead_g_fb *buf,
 		u32 frame_len, int need_ack)
 {
+	struct vnt_private *priv = tx_context->priv;
+
 	/* Get SignalField,ServiceField,Length */
 	BBvCalculateParameter(priv, frame_len, rate, pkt_type, &buf->a);
 
@@ -513,10 +519,12 @@ static u16 vnt_rxtx_datahead_g_fb(struct vnt_private *priv, u8 pkt_type,
 	return le16_to_cpu(buf->duration_a);
 }
 
-static u16 vnt_rxtx_datahead_a_fb(struct vnt_private *priv, u8 pkt_type,
-		u16 rate, struct vnt_tx_datahead_a_fb *buf,
+static u16 vnt_rxtx_datahead_a_fb(struct vnt_usb_send_context *tx_context,
+		u8 pkt_type, u16 rate, struct vnt_tx_datahead_a_fb *buf,
 		u32 frame_len, int need_ack)
 {
+	struct vnt_private *priv = tx_context->priv;
+
 	/* Get SignalField,ServiceField,Length */
 	BBvCalculateParameter(priv, frame_len, rate, pkt_type, &buf->a);
 	/* Get Duration and TimeStampOff */
@@ -530,10 +538,12 @@ static u16 vnt_rxtx_datahead_a_fb(struct vnt_private *priv, u8 pkt_type,
 	return le16_to_cpu(buf->duration);
 }
 
-static u16 vnt_rxtx_datahead_ab(struct vnt_private *priv, u8 pkt_type,
-		u16 rate, struct vnt_tx_datahead_ab *buf,
+static u16 vnt_rxtx_datahead_ab(struct vnt_usb_send_context *tx_context,
+		u8 pkt_type, u16 rate, struct vnt_tx_datahead_ab *buf,
 		u32 frame_len, int need_ack)
 {
+	struct vnt_private *priv = tx_context->priv;
+
 	/* Get SignalField,ServiceField,Length */
 	BBvCalculateParameter(priv, frame_len, rate, pkt_type, &buf->ab);
 	/* Get Duration and TimeStampOff */
@@ -566,11 +576,12 @@ static int vnt_fill_ieee80211_rts(struct vnt_private *priv,
 	return 0;
 }
 
-static u16 vnt_rxtx_rts_g_head(struct vnt_private *priv,
+static u16 vnt_rxtx_rts_g_head(struct vnt_usb_send_context *tx_context,
 	struct vnt_rts_g *buf, struct ethhdr *eth_hdr,
 	u8 pkt_type, u32 frame_len, int need_ack,
 	u16 current_rate, u8 fb_option)
 {
+	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
 
 	BBvCalculateParameter(priv, rts_frame_len, priv->byTopCCKBasicRate,
@@ -587,15 +598,16 @@ static u16 vnt_rxtx_rts_g_head(struct vnt_private *priv,
 
 	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->duration_aa);
 
-	return vnt_rxtx_datahead_g(priv, pkt_type, current_rate,
+	return vnt_rxtx_datahead_g(tx_context, pkt_type, current_rate,
 			&buf->data_head, frame_len, need_ack);
 }
 
-static u16 vnt_rxtx_rts_g_fb_head(struct vnt_private *priv,
+static u16 vnt_rxtx_rts_g_fb_head(struct vnt_usb_send_context *tx_context,
 	struct vnt_rts_g_fb *buf, struct ethhdr *eth_hdr,
 	u8 pkt_type, u32 frame_len, int need_ack,
 	u16 current_rate, u8 fb_option)
 {
+	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
 
 	BBvCalculateParameter(priv, rts_frame_len, priv->byTopCCKBasicRate,
@@ -623,15 +635,16 @@ static u16 vnt_rxtx_rts_g_fb_head(struct vnt_private *priv,
 
 	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->duration_aa);
 
-	return vnt_rxtx_datahead_g_fb(priv, pkt_type, current_rate,
+	return vnt_rxtx_datahead_g_fb(tx_context, pkt_type, current_rate,
 			&buf->data_head, frame_len, need_ack);
 }
 
-static u16 vnt_rxtx_rts_ab_head(struct vnt_private *priv,
+static u16 vnt_rxtx_rts_ab_head(struct vnt_usb_send_context *tx_context,
 	struct vnt_rts_ab *buf, struct ethhdr *eth_hdr,
 	u8 pkt_type, u32 frame_len, int need_ack,
 	u16 current_rate, u8 fb_option)
 {
+	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
 
 	BBvCalculateParameter(priv, rts_frame_len,
@@ -642,15 +655,16 @@ static u16 vnt_rxtx_rts_ab_head(struct vnt_private *priv,
 
 	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->duration);
 
-	return vnt_rxtx_datahead_ab(priv, pkt_type, current_rate,
+	return vnt_rxtx_datahead_ab(tx_context, pkt_type, current_rate,
 			&buf->data_head, frame_len, need_ack);
 }
 
-static u16 vnt_rxtx_rts_a_fb_head(struct vnt_private *priv,
+static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
 	struct vnt_rts_a_fb *buf, struct ethhdr *eth_hdr,
 	u8 pkt_type, u32 frame_len, int need_ack,
 	u16 current_rate, u8 fb_option)
 {
+	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
 
 	BBvCalculateParameter(priv, rts_frame_len,
@@ -667,11 +681,11 @@ static u16 vnt_rxtx_rts_a_fb_head(struct vnt_private *priv,
 
 	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->duration);
 
-	return vnt_rxtx_datahead_a_fb(priv, pkt_type, current_rate,
+	return vnt_rxtx_datahead_a_fb(tx_context, pkt_type, current_rate,
 			&buf->data_head, frame_len, need_ack);
 }
 
-static u16 s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
+static u16 s_vFillRTSHead(struct vnt_usb_send_context *tx_context, u8 byPktType,
 	union vnt_tx_data_head *head, u32 cbFrameLength, int bNeedAck,
 	struct ethhdr *psEthHeader, u16 wCurrentRate, u8 byFBOption)
 {
@@ -688,23 +702,25 @@ static u16 s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 	case PK_TYPE_11GB:
 	case PK_TYPE_11GA:
 		if (byFBOption == AUTO_FB_NONE)
-			return vnt_rxtx_rts_g_head(pDevice, &head->rts_g,
+			return vnt_rxtx_rts_g_head(tx_context, &head->rts_g,
 				psEthHeader, byPktType, cbFrameLength,
 				bNeedAck, wCurrentRate, byFBOption);
 		else
-			return vnt_rxtx_rts_g_fb_head(pDevice, &head->rts_g_fb,
-				psEthHeader, byPktType, cbFrameLength,
-				bNeedAck, wCurrentRate, byFBOption);
+			return vnt_rxtx_rts_g_fb_head(tx_context,
+				&head->rts_g_fb, psEthHeader, byPktType,
+				cbFrameLength, bNeedAck, wCurrentRate,
+				byFBOption);
 		break;
 	case PK_TYPE_11A:
 		if (byFBOption) {
-			return vnt_rxtx_rts_a_fb_head(pDevice, &head->rts_a_fb,
-				psEthHeader, byPktType, cbFrameLength,
-				bNeedAck, wCurrentRate, byFBOption);
+			return vnt_rxtx_rts_a_fb_head(tx_context,
+				&head->rts_a_fb, psEthHeader, byPktType,
+				cbFrameLength, bNeedAck, wCurrentRate,
+				byFBOption);
 			break;
 		}
 	case PK_TYPE_11B:
-		return vnt_rxtx_rts_ab_head(pDevice, &head->rts_ab,
+		return vnt_rxtx_rts_ab_head(tx_context, &head->rts_ab,
 			psEthHeader, byPktType, cbFrameLength,
 			bNeedAck, wCurrentRate, byFBOption);
 	}
@@ -712,10 +728,11 @@ static u16 s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 	return 0;
 }
 
-static u16 s_vFillCTSHead(struct vnt_private *pDevice,
+static u16 s_vFillCTSHead(struct vnt_usb_send_context *tx_context,
 	u8 byPktType, union vnt_tx_data_head *head, u32 cbFrameLength,
 	int bNeedAck, u16 wCurrentRate, u8 byFBOption)
 {
+	struct vnt_private *pDevice = tx_context->priv;
 	u32 uCTSFrameLen = 14;
 
 	if (!head)
@@ -745,8 +762,9 @@ static u16 s_vFillCTSHead(struct vnt_private *pDevice,
 
 		memcpy(pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
 
-		return vnt_rxtx_datahead_g_fb(pDevice, byPktType, wCurrentRate,
-				&pBuf->data_head, cbFrameLength, bNeedAck);
+		return vnt_rxtx_datahead_g_fb(tx_context, byPktType,
+				wCurrentRate, &pBuf->data_head, cbFrameLength,
+				bNeedAck);
 	} else {
 		struct vnt_cts *pBuf = &head->cts_g;
 		/* Get SignalField,ServiceField,Length */
@@ -763,7 +781,7 @@ static u16 s_vFillCTSHead(struct vnt_private *pDevice,
 
 		memcpy(pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
 
-		return vnt_rxtx_datahead_g(pDevice, byPktType, wCurrentRate,
+		return vnt_rxtx_datahead_g(tx_context, byPktType, wCurrentRate,
 				&pBuf->data_head, cbFrameLength, bNeedAck);
         }
 
@@ -792,11 +810,12 @@ static u16 s_vFillCTSHead(struct vnt_private *pDevice,
  *
 -*/
 
-static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
+static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 	u8 byPktType, u16 wCurrentRate,	struct vnt_tx_buffer *tx_buffer,
 	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 cbFrameSize,
 	int bNeedACK, struct ethhdr *psEthHeader, bool need_rts)
 {
+	struct vnt_private *pDevice = tx_context->priv;
 	struct vnt_tx_fifo_head *pFifoHead = &tx_buffer->fifo_head;
 	union vnt_tx_data_head *head = NULL;
 	u16 wFifoCtl;
@@ -837,7 +856,7 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 			}
 
 			/* Fill RTS */
-			return s_vFillRTSHead(pDevice, byPktType, head,
+			return s_vFillRTSHead(tx_context, byPktType, head,
 					cbFrameSize, bNeedACK, psEthHeader,
 						wCurrentRate, byFBOption);
 
@@ -863,7 +882,7 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 			}
 
 			/* Fill CTS */
-			return s_vFillCTSHead(pDevice, byPktType,
+			return s_vFillCTSHead(tx_context, byPktType,
 				head, cbFrameSize, bNeedACK, wCurrentRate,
 					byFBOption);
 		}
@@ -886,7 +905,7 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 				byPktType, cbFrameSize, wCurrentRate, bNeedACK);
 
 			/* Fill RTS */
-			return s_vFillRTSHead(pDevice, byPktType, head,
+			return s_vFillRTSHead(tx_context, byPktType, head,
 				cbFrameSize, bNeedACK, psEthHeader,
 					wCurrentRate, byFBOption);
 		} else {
@@ -897,7 +916,7 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 				PK_TYPE_11A, cbFrameSize,
 					wCurrentRate, bNeedACK);
 
-			return vnt_rxtx_datahead_a_fb(pDevice, byPktType,
+			return vnt_rxtx_datahead_a_fb(tx_context, byPktType,
 				wCurrentRate, &head->data_head_a_fb,
 						cbFrameSize, bNeedACK);
 		}
@@ -921,7 +940,7 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 								bNeedACK);
 
 			/* Fill RTS */
-			return s_vFillRTSHead(pDevice, byPktType, head,
+			return s_vFillRTSHead(tx_context, byPktType, head,
 				cbFrameSize,
 			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
 		} else {
@@ -932,7 +951,7 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 				PK_TYPE_11B, cbFrameSize,
 					wCurrentRate, bNeedACK);
 
-			return vnt_rxtx_datahead_ab(pDevice, byPktType,
+			return vnt_rxtx_datahead_ab(tx_context, byPktType,
 				wCurrentRate, &head->data_head_ab,
 					cbFrameSize, bNeedACK);
 		}
@@ -946,12 +965,13 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
     unsigned int  cbFragmentSize,//Hdr+payoad+FCS
 */
 
-static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
-	struct vnt_tx_buffer *tx_buffer, int bNeedEncryption,
+static int s_bPacketToWirelessUsb(struct vnt_usb_send_context *tx_context,
+	u8 byPktType, struct vnt_tx_buffer *tx_buffer, int bNeedEncryption,
 	u32 uSkbPacketLen, struct ethhdr *psEthHeader,
 	u8 *pPacket, PSKeyItem pTransmitKey, u32 uNodeIndex, u16 wCurrentRate,
 	u32 *pcbHeaderLen, u32 *pcbTotalLen)
 {
+	struct vnt_private *pDevice = tx_context->priv;
 	struct vnt_tx_fifo_head *pTxBufHead = &tx_buffer->fifo_head;
 	u32 cbFrameSize, cbFrameBodySize;
 	u32 cb802_1_H_len;
@@ -1146,7 +1166,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
     //pTxBufHead = (PSTxBufHead) &(pTxBufHead->adwTxKey[0]);
 
 	/* Fill FIFO, RrvTime, RTS and CTS */
-	uDuration = s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
+	uDuration = s_vGenerateTxParameter(tx_context, byPktType, wCurrentRate,
 			tx_buffer, &pMICHDR, cbMICHDR,
 			cbFrameSize, bNeedACK, psEthHeader, bRTS);
 
@@ -1518,7 +1538,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
     pTxBufHead->wFragCtl |= (u16)FRAGCTL_NONFRAG;
 
 	/* Fill FIFO,RrvTime,RTS,and CTS */
-	uDuration = s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
+	uDuration = s_vGenerateTxParameter(pContext, byPktType, wCurrentRate,
 		pTX_Buffer, &pMICHDR, 0,
 		cbFrameSize, bNeedACK, &sEthHeader, false);
 
@@ -2020,7 +2040,7 @@ int nsDMA_tx_packet(struct vnt_private *pDevice, struct sk_buff *skb)
 
 	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->data[0];
 
-    fConvertedPacket = s_bPacketToWirelessUsb(pDevice, byPktType,
+	fConvertedPacket = s_bPacketToWirelessUsb(pContext, byPktType,
 			pTX_Buffer, bNeedEncryption,
 			skb->len, &pDevice->sTxEthHeader,
                         (u8 *)skb->data, pTransmitKey, uNodeIndex,
-- 
1.9.1

