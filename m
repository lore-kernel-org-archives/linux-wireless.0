Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:44281 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab3HZKFF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 06:05:05 -0400
Received: by mail-bk0-f52.google.com with SMTP id e11so1054584bkh.11
        for <linux-wireless@vger.kernel.org>; Mon, 26 Aug 2013 03:05:04 -0700 (PDT)
Message-ID: <1377511490.3685.32.camel@canaries32-MCP7A> (sfid-20130826_120535_580494_13F15306)
Subject: [PATCH 1/6] staging: vt6656: rxtx.c s_vFillRTSHead Parse out struct
 vnt_rts_g to new functions.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 26 Aug 2013 11:04:50 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Parse out vnt_rts_g code to new function vnt_rxtx_rts_g_head.

Also create a new common calling function vnt_fill_ieee80211_rts
to fill the ieee80211_rts structure.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 75 +++++++++++++++++++++++++++----------------
 1 file changed, 47 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index dd2bfc9..57af55b 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -595,6 +595,50 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
     return 0;
 }
 
+static int vnt_fill_ieee80211_rts(struct vnt_private *priv,
+	struct ieee80211_rts *rts, struct ethhdr *eth_hdr,
+		u16 duration)
+{
+	rts->duration = duration;
+	rts->frame_control = TYPE_CTL_RTS;
+
+	if (priv->eOPMode == OP_MODE_ADHOC || priv->eOPMode == OP_MODE_AP)
+		memcpy(rts->ra, eth_hdr->h_dest, ETH_ALEN);
+	else
+		memcpy(rts->ra, priv->abyBSSID, ETH_ALEN);
+
+	if (priv->eOPMode == OP_MODE_AP)
+		memcpy(rts->ta, priv->abyBSSID, ETH_ALEN);
+	else
+		memcpy(rts->ta, eth_hdr->h_source, ETH_ALEN);
+
+	return 0;
+}
+
+static int vnt_rxtx_rts_g_head(struct vnt_private *priv,
+	struct vnt_rts_g *buf, struct ethhdr *eth_hdr,
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
+	buf->wDuration_bb = s_uGetRTSCTSDuration(priv, RTSDUR_BB, frame_len,
+		PK_TYPE_11B, priv->byTopCCKBasicRate, need_ack, fb_option);
+	buf->wDuration_aa = s_uGetRTSCTSDuration(priv, RTSDUR_AA, frame_len,
+		pkt_type, current_rate, need_ack, fb_option);
+	buf->wDuration_ba = s_uGetRTSCTSDuration(priv, RTSDUR_BA, frame_len,
+		pkt_type, current_rate, need_ack, fb_option);
+
+	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->wDuration_aa);
+
+	return 0;
+}
+
 static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 	void *pvRTS, u32 cbFrameLength, int bNeedAck,
 	struct ethhdr *psEthHeader, u16 wCurrentRate, u8 byFBOption)
@@ -609,35 +653,10 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
         if (byFBOption == AUTO_FB_NONE) {
 		struct vnt_rts_g *pBuf = (struct vnt_rts_g *)pvRTS;
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
-		pBuf->data.duration = pBuf->wDuration_aa;
-		/*Get RTS Frame body */
-		pBuf->data.frame_control = TYPE_CTL_RTS;
 
-		if (pDevice->eOPMode == OP_MODE_ADHOC ||
-				pDevice->eOPMode == OP_MODE_AP)
-			memcpy(pBuf->data.ra, psEthHeader->h_dest, ETH_ALEN);
-		else
-			memcpy(pBuf->data.ra, pDevice->abyBSSID, ETH_ALEN);
-
-		if (pDevice->eOPMode == OP_MODE_AP)
-			memcpy(pBuf->data.ta, pDevice->abyBSSID, ETH_ALEN);
-		else
-			memcpy(pBuf->data.ta, psEthHeader->h_source, ETH_ALEN);
+		vnt_rxtx_rts_g_head(pDevice, pBuf,
+				psEthHeader, byPktType, cbFrameLength,
+				bNeedAck, wCurrentRate, byFBOption);
         }
         else {
 		struct vnt_rts_g_fb *pBuf = (struct vnt_rts_g_fb *)pvRTS;
-- 
1.8.1.2

