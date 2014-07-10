Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54993 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbaGJS5L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 14:57:11 -0400
Received: by mail-wi0-f177.google.com with SMTP id ho1so192407wib.4
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 11:57:09 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 15/16] staging: vt6656: s_vFillCTSHead remove camel case
Date: Thu, 10 Jul 2014 19:56:16 +0100
Message-Id: <1405018577-6832-15-git-send-email-tvboxspy@gmail.com> (sfid-20140710_205728_185282_2F3B4C62)
In-Reply-To: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
References: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes
byPktType -> pkt_type
cbFrameLength -> frame_len
bNeedAck -> need_ack
pDevice -> priv
uCTSFrameLen -> cts_frame_len

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 66 +++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index ad1a1b6..dce6cb5 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -520,60 +520,60 @@ static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 s_vFillCTSHead(struct vnt_usb_send_context *tx_context,
-	u8 byPktType, union vnt_tx_data_head *head, u32 cbFrameLength,
-	int bNeedAck, u16 wCurrentRate)
+	u8 pkt_type, union vnt_tx_data_head *head, u32 frame_len,
+	int need_ack, u16 current_rate)
 {
-	struct vnt_private *pDevice = tx_context->priv;
-	u32 uCTSFrameLen = 14;
+	struct vnt_private *priv = tx_context->priv;
+	u32 cts_frame_len = 14;
 
 	if (!head)
 		return 0;
 
 	if (tx_context->fb_option) {
 		/* Auto Fall back */
-		struct vnt_cts_fb *pBuf = &head->cts_g_fb;
+		struct vnt_cts_fb *buf = &head->cts_g_fb;
 		/* Get SignalField,ServiceField,Length */
-		vnt_get_phy_field(pDevice, uCTSFrameLen,
-			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
-		pBuf->duration_ba = s_uGetRTSCTSDuration(pDevice, CTSDUR_BA,
-			cbFrameLength, byPktType,
-			wCurrentRate, bNeedAck);
+		vnt_get_phy_field(priv, cts_frame_len,
+			priv->byTopCCKBasicRate, PK_TYPE_11B, &buf->b);
+		buf->duration_ba = s_uGetRTSCTSDuration(priv, CTSDUR_BA,
+			frame_len, pkt_type,
+			current_rate, need_ack);
 		/* Get CTSDuration_ba_f0 */
-		pBuf->cts_duration_ba_f0 = s_uGetRTSCTSDuration(pDevice,
-			CTSDUR_BA_F0, cbFrameLength, byPktType,
-			pDevice->tx_rate_fb0, bNeedAck);
+		buf->cts_duration_ba_f0 = s_uGetRTSCTSDuration(priv,
+			CTSDUR_BA_F0, frame_len, pkt_type,
+			priv->tx_rate_fb0, need_ack);
 		/* Get CTSDuration_ba_f1 */
-		pBuf->cts_duration_ba_f1 = s_uGetRTSCTSDuration(pDevice,
-			CTSDUR_BA_F1, cbFrameLength, byPktType,
-			pDevice->tx_rate_fb1, bNeedAck);
+		buf->cts_duration_ba_f1 = s_uGetRTSCTSDuration(priv,
+			CTSDUR_BA_F1, frame_len, pkt_type,
+			priv->tx_rate_fb1, need_ack);
 		/* Get CTS Frame body */
-		pBuf->data.duration = pBuf->duration_ba;
-		pBuf->data.frame_control =
+		buf->data.duration = buf->duration_ba;
+		buf->data.frame_control =
 			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
 
-		memcpy(pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
+		memcpy(buf->data.ra, priv->abyCurrentNetAddr, ETH_ALEN);
 
-		return vnt_rxtx_datahead_g_fb(tx_context, byPktType,
-				wCurrentRate, &pBuf->data_head, cbFrameLength,
-				bNeedAck);
+		return vnt_rxtx_datahead_g_fb(tx_context, pkt_type,
+				current_rate, &buf->data_head, frame_len,
+				need_ack);
 	} else {
-		struct vnt_cts *pBuf = &head->cts_g;
+		struct vnt_cts *buf = &head->cts_g;
 		/* Get SignalField,ServiceField,Length */
-		vnt_get_phy_field(pDevice, uCTSFrameLen,
-			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
+		vnt_get_phy_field(priv, cts_frame_len,
+			priv->byTopCCKBasicRate, PK_TYPE_11B, &buf->b);
 		/* Get CTSDuration_ba */
-		pBuf->duration_ba = s_uGetRTSCTSDuration(pDevice,
-			CTSDUR_BA, cbFrameLength, byPktType,
-			wCurrentRate, bNeedAck);
+		buf->duration_ba = s_uGetRTSCTSDuration(priv,
+			CTSDUR_BA, frame_len, pkt_type,
+			current_rate, need_ack);
 		/*Get CTS Frame body*/
-		pBuf->data.duration = pBuf->duration_ba;
-		pBuf->data.frame_control =
+		buf->data.duration = buf->duration_ba;
+		buf->data.frame_control =
 			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
 
-		memcpy(pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
+		memcpy(buf->data.ra, priv->abyCurrentNetAddr, ETH_ALEN);
 
-		return vnt_rxtx_datahead_g(tx_context, byPktType, wCurrentRate,
-				&pBuf->data_head, cbFrameLength, bNeedAck);
+		return vnt_rxtx_datahead_g(tx_context, pkt_type, current_rate,
+				&buf->data_head, frame_len, need_ack);
         }
 
 	return 0;
-- 
1.9.1

