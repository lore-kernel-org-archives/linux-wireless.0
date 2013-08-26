Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:52559 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3HZKHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 06:07:54 -0400
Received: by mail-bk0-f44.google.com with SMTP id mz10so1016878bkb.17
        for <linux-wireless@vger.kernel.org>; Mon, 26 Aug 2013 03:07:53 -0700 (PDT)
Message-ID: <1377511666.3685.34.camel@canaries32-MCP7A> (sfid-20130826_120757_313830_51454654)
Subject: [PATCH 2/6] staging: vt6656: rxtx.c s_vFillRTSHead Parse out struct
 vnt_rts_g_fb to new function.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 26 Aug 2013 11:07:46 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Parse out vnt_rts_g_fb code to new function vnt_rxtx_rts_g_fb_head.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 78 +++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 57af55b..5cfdfaf 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -639,6 +639,41 @@ static int vnt_rxtx_rts_g_head(struct vnt_private *priv,
 	return 0;
 }
 
+static int vnt_rxtx_rts_g_fb_head(struct vnt_private *priv,
+	struct vnt_rts_g_fb *buf, struct ethhdr *eth_hdr,
+	u8 pkt_type, u32 frame_len, int need_ack,
+	u16 current_rate, u8 fb_option)
+{
+	u16 rts_frame_len = 20;
+
+	BBvCalculateParameter(priv, rts_frame_len, priv->byTopCCKBasicRate,
+		PK_TYPE_11B, &buf->b);
+	BBvCalculateParameter(priv, rts_frame_len,
+		priv->byTopOFDMBasicRate, pkt_type, &buf->a);
+
+
+	buf->wDuration_bb = s_uGetRTSCTSDuration(priv, RTSDUR_BB, frame_len,
+		PK_TYPE_11B, priv->byTopCCKBasicRate, need_ack, fb_option);
+	buf->wDuration_aa = s_uGetRTSCTSDuration(priv, RTSDUR_AA, frame_len,
+		pkt_type, current_rate, need_ack, fb_option);
+	buf->wDuration_ba = s_uGetRTSCTSDuration(priv, RTSDUR_BA, frame_len,
+		pkt_type, current_rate, need_ack, fb_option);
+
+
+	buf->wRTSDuration_ba_f0 = s_uGetRTSCTSDuration(priv, RTSDUR_BA_F0,
+		frame_len, pkt_type, current_rate, need_ack, fb_option);
+	buf->wRTSDuration_aa_f0 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F0,
+		frame_len, pkt_type, current_rate, need_ack, fb_option);
+	buf->wRTSDuration_ba_f1 = s_uGetRTSCTSDuration(priv, RTSDUR_BA_F1,
+		frame_len, pkt_type, current_rate, need_ack, fb_option);
+	buf->wRTSDuration_aa_f1 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F1,
+		frame_len, pkt_type, current_rate, need_ack, fb_option);
+
+	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->wDuration_aa);
+
+	return 0;
+}
+
 static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 	void *pvRTS, u32 cbFrameLength, int bNeedAck,
 	struct ethhdr *psEthHeader, u16 wCurrentRate, u8 byFBOption)
@@ -660,47 +695,10 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
         }
         else {
 		struct vnt_rts_g_fb *pBuf = (struct vnt_rts_g_fb *)pvRTS;
-            //Get SignalField,ServiceField,Length
-		BBvCalculateParameter(pDevice, uRTSFrameLen,
-			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
-		BBvCalculateParameter(pDevice, uRTSFrameLen,
-			pDevice->byTopOFDMBasicRate, byPktType, &pBuf->a);
-            //Get Duration
-		pBuf->wDuration_bb = s_uGetRTSCTSDuration(pDevice, RTSDUR_BB,
-			cbFrameLength, PK_TYPE_11B,
-			pDevice->byTopCCKBasicRate, bNeedAck, byFBOption);
-		pBuf->wDuration_aa = s_uGetRTSCTSDuration(pDevice, RTSDUR_AA,
-			cbFrameLength, byPktType,
-			wCurrentRate, bNeedAck, byFBOption);
-		pBuf->wDuration_ba = s_uGetRTSCTSDuration(pDevice, RTSDUR_BA,
-			cbFrameLength, byPktType,
-			wCurrentRate, bNeedAck, byFBOption);
-		pBuf->wRTSDuration_ba_f0 = s_uGetRTSCTSDuration(pDevice,
-			RTSDUR_BA_F0, cbFrameLength, byPktType, wCurrentRate,
-			bNeedAck, byFBOption);
-		pBuf->wRTSDuration_aa_f0 = s_uGetRTSCTSDuration(pDevice,
-			RTSDUR_AA_F0, cbFrameLength, byPktType,
-			wCurrentRate, bNeedAck, byFBOption);
-		pBuf->wRTSDuration_ba_f1 = s_uGetRTSCTSDuration(pDevice,
-			RTSDUR_BA_F1, cbFrameLength, byPktType, wCurrentRate,
-			bNeedAck, byFBOption);
-		pBuf->wRTSDuration_aa_f1 = s_uGetRTSCTSDuration(pDevice,
-			RTSDUR_AA_F1, cbFrameLength, byPktType, wCurrentRate,
-			bNeedAck, byFBOption);
-		pBuf->data.duration = pBuf->wDuration_aa;
-		/*Get RTS Frame body*/
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
+		vnt_rxtx_rts_g_fb_head(pDevice, pBuf,
+				psEthHeader, byPktType, cbFrameLength,
+				bNeedAck, wCurrentRate, byFBOption);
         } // if (byFBOption == AUTO_FB_NONE)
     }
     else if (byPktType == PK_TYPE_11A) {
-- 
1.8.1.2

