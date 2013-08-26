Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:35748 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab3HZKJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 06:09:46 -0400
Received: by mail-bk0-f43.google.com with SMTP id mz13so1054823bkb.30
        for <linux-wireless@vger.kernel.org>; Mon, 26 Aug 2013 03:09:45 -0700 (PDT)
Message-ID: <1377511778.3685.35.camel@canaries32-MCP7A> (sfid-20130826_120950_233367_83C7F7E8)
Subject: [PATCH 3/6] staging: vt6656: rxtx.c s_vFillRTSHead Parse out struct
 vnt_rts_ab to new function.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 26 Aug 2013 11:09:38 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Parse out vnt_rts_ab code to new function vnt_rxtx_rts_ab_head.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 65 ++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 5cfdfaf..ce8018e 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -674,6 +674,24 @@ static int vnt_rxtx_rts_g_fb_head(struct vnt_private *priv,
 	return 0;
 }
 
+static int vnt_rxtx_rts_ab_head(struct vnt_private *priv,
+	struct vnt_rts_ab *buf, struct ethhdr *eth_hdr,
+	u8 pkt_type, u32 frame_len, int need_ack,
+	u16 current_rate, u8 fb_option)
+{
+	u16 rts_frame_len = 20;
+
+	BBvCalculateParameter(priv, rts_frame_len,
+		priv->byTopOFDMBasicRate, pkt_type, &buf->ab);
+
+	buf->wDuration = s_uGetRTSCTSDuration(priv, RTSDUR_AA, frame_len,
+		pkt_type, current_rate, need_ack, fb_option);
+
+	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->wDuration);
+
+	return 0;
+}
+
 static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 	void *pvRTS, u32 cbFrameLength, int bNeedAck,
 	struct ethhdr *psEthHeader, u16 wCurrentRate, u8 byFBOption)
@@ -704,27 +722,10 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
     else if (byPktType == PK_TYPE_11A) {
         if (byFBOption == AUTO_FB_NONE) {
 		struct vnt_rts_ab *pBuf = (struct vnt_rts_ab *)pvRTS;
-            //Get SignalField,ServiceField,Length
-		BBvCalculateParameter(pDevice, uRTSFrameLen,
-			pDevice->byTopOFDMBasicRate, byPktType, &pBuf->ab);
-            //Get Duration
-		pBuf->wDuration = s_uGetRTSCTSDuration(pDevice, RTSDUR_AA,
-			cbFrameLength, byPktType, wCurrentRate,
-				bNeedAck, byFBOption);
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
+		vnt_rxtx_rts_ab_head(pDevice, pBuf,
+				psEthHeader, byPktType, cbFrameLength,
+				bNeedAck, wCurrentRate, byFBOption);
         }
         else {
 		struct vnt_rts_a_fb *pBuf = (struct vnt_rts_a_fb *)pvRTS;
@@ -759,28 +760,10 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
     }
     else if (byPktType == PK_TYPE_11B) {
 	struct vnt_rts_ab *pBuf = (struct vnt_rts_ab *)pvRTS;
-        //Get SignalField,ServiceField,Length
-	BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate,
-		PK_TYPE_11B, &pBuf->ab);
-        //Get Duration
-	pBuf->wDuration = s_uGetRTSCTSDuration(pDevice, RTSDUR_BB,
-		cbFrameLength, byPktType, wCurrentRate,
-		bNeedAck, byFBOption);
-
-	pBuf->data.duration = pBuf->wDuration;
-	/* Get RTS Frame body */
-	pBuf->data.frame_control = TYPE_CTL_RTS;
-
-	if (pDevice->eOPMode == OP_MODE_ADHOC ||
-			pDevice->eOPMode == OP_MODE_AP)
-		memcpy(pBuf->data.ra, psEthHeader->h_dest, ETH_ALEN);
-	else
-		memcpy(pBuf->data.ra, pDevice->abyBSSID, ETH_ALEN);
 
-	if (pDevice->eOPMode == OP_MODE_AP)
-		memcpy(pBuf->data.ta, pDevice->abyBSSID, ETH_ALEN);
-	else
-		memcpy(pBuf->data.ta, psEthHeader->h_source, ETH_ALEN);
+	vnt_rxtx_rts_ab_head(pDevice, pBuf,
+			psEthHeader, byPktType, cbFrameLength,
+			bNeedAck, wCurrentRate, byFBOption);
     }
 }
 
-- 
1.8.1.2

