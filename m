Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46777 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3HZKMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 06:12:08 -0400
Received: by mail-ee0-f46.google.com with SMTP id c13so1500257eek.33
        for <linux-wireless@vger.kernel.org>; Mon, 26 Aug 2013 03:12:07 -0700 (PDT)
Message-ID: <1377511920.3685.37.camel@canaries32-MCP7A> (sfid-20130826_121212_831677_FC6A1DCC)
Subject: [PATCH 4/6] staging: vt6656: rxtx.c s_vFillRTSHead Parse out struct
 vnt_rts_a_fb to new function.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 26 Aug 2013 11:12:00 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Parse out vnt_rts_a_fb code to new function vnt_rxtx_rts_a_fb_head.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 54 +++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index ce8018e..a45cc9f 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -692,11 +692,34 @@ static int vnt_rxtx_rts_ab_head(struct vnt_private *priv,
 	return 0;
 }
 
+static int vnt_rxtx_rts_a_fb_head(struct vnt_private *priv,
+	struct vnt_rts_a_fb *buf, struct ethhdr *eth_hdr,
+	u8 pkt_type, u32 frame_len, int need_ack,
+	u16 current_rate, u8 fb_option)
+{
+	u16 rts_frame_len = 20;
+
+	BBvCalculateParameter(priv, rts_frame_len,
+		priv->byTopOFDMBasicRate, pkt_type, &buf->a);
+
+	buf->wDuration = s_uGetRTSCTSDuration(priv, RTSDUR_AA, frame_len,
+		pkt_type, current_rate, need_ack, fb_option);
+
+	buf->wRTSDuration_f0 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F0,
+		frame_len, pkt_type, current_rate, need_ack, fb_option);
+
+	buf->wRTSDuration_f1 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F1,
+		frame_len, pkt_type, current_rate, need_ack, fb_option);
+
+	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->wDuration);
+
+	return 0;
+}
+
 static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 	void *pvRTS, u32 cbFrameLength, int bNeedAck,
 	struct ethhdr *psEthHeader, u16 wCurrentRate, u8 byFBOption)
 {
-	u32 uRTSFrameLen = 20;
 
     if (pvRTS == NULL)
     	return;
@@ -729,33 +752,10 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
         }
         else {
 		struct vnt_rts_a_fb *pBuf = (struct vnt_rts_a_fb *)pvRTS;
-            //Get SignalField,ServiceField,Length
-		BBvCalculateParameter(pDevice, uRTSFrameLen,
-			pDevice->byTopOFDMBasicRate, byPktType, &pBuf->a);
-            //Get Duration
-		pBuf->wDuration = s_uGetRTSCTSDuration(pDevice, RTSDUR_AA,
-			cbFrameLength, byPktType, wCurrentRate,
-			bNeedAck, byFBOption);
-		pBuf->wRTSDuration_f0 = s_uGetRTSCTSDuration(pDevice,
-			RTSDUR_AA_F0, cbFrameLength, byPktType,
-			wCurrentRate, bNeedAck, byFBOption);
-		pBuf->wRTSDuration_f1 = s_uGetRTSCTSDuration(pDevice,
-			RTSDUR_AA_F1, cbFrameLength, byPktType,
-			wCurrentRate, bNeedAck, byFBOption);
-		pBuf->data.duration = pBuf->wDuration;
-		/* Get RTS Frame body */
-		pBuf->data.frame_control = TYPE_CTL_RTS;
-
-		if (pDevice->eOPMode == OP_MODE_ADHOC ||
-				pDevice->eOPMode == OP_MODE_AP)
-			memcpy(pBuf->data.ra, psEthHeader->h_dest, ETH_ALEN);
-		else
-			memcpy(pBuf->data.ra, pDevice->abyBSSID, ETH_ALEN);
 
-		if (pDevice->eOPMode == OP_MODE_AP)
-			memcpy(pBuf->data.ta, pDevice->abyBSSID, ETH_ALEN);
-		else
-			memcpy(pBuf->data.ta, psEthHeader->h_source, ETH_ALEN);
+		vnt_rxtx_rts_a_fb_head(pDevice, pBuf,
+				psEthHeader, byPktType, cbFrameLength,
+				bNeedAck, wCurrentRate, byFBOption);
         }
     }
     else if (byPktType == PK_TYPE_11B) {
-- 
1.8.1.2

