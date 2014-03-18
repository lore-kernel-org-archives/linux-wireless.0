Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:64183 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547AbaCRT0B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 15:26:01 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so6242963wgg.6
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 12:25:59 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/14] staging: vt6656: rxtx Replace wDuration* variables.
Date: Tue, 18 Mar 2014 19:24:55 +0000
Message-Id: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com> (sfid-20140318_202607_980022_80B403F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix base type to __le16 and remove camel case.

Camel case changes
wDuration* -> duration*

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 72 +++++++++++++++++++++----------------------
 drivers/staging/vt6656/rxtx.h | 40 ++++++++++++------------
 2 files changed, 56 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 7083af3..5507db8 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -481,14 +481,14 @@ static u16 vnt_rxtx_datahead_g(struct vnt_private *priv, u8 pkt_type, u16 rate,
 							PK_TYPE_11B, &buf->b);
 
 	/* Get Duration and TimeStamp */
-	buf->wDuration_a = s_uGetDataDuration(priv, pkt_type, need_ack);
-	buf->wDuration_b = s_uGetDataDuration(priv, PK_TYPE_11B, need_ack);
+	buf->duration_a = s_uGetDataDuration(priv, pkt_type, need_ack);
+	buf->duration_b = s_uGetDataDuration(priv, PK_TYPE_11B, need_ack);
 
 	buf->wTimeStampOff_a = vnt_time_stamp_off(priv, rate);
 	buf->wTimeStampOff_b = vnt_time_stamp_off(priv,
 					priv->byTopCCKBasicRate);
 
-	return buf->wDuration_a;
+	return buf->duration_a;
 }
 
 static u16 vnt_rxtx_datahead_g_fb(struct vnt_private *priv, u8 pkt_type,
@@ -502,17 +502,17 @@ static u16 vnt_rxtx_datahead_g_fb(struct vnt_private *priv, u8 pkt_type,
 						PK_TYPE_11B, &buf->b);
 
 	/* Get Duration and TimeStamp */
-	buf->wDuration_a = s_uGetDataDuration(priv, pkt_type, need_ack);
-	buf->wDuration_b = s_uGetDataDuration(priv, PK_TYPE_11B, need_ack);
+	buf->duration_a = s_uGetDataDuration(priv, pkt_type, need_ack);
+	buf->duration_b = s_uGetDataDuration(priv, PK_TYPE_11B, need_ack);
 
-	buf->wDuration_a_f0 = s_uGetDataDuration(priv, pkt_type, need_ack);
-	buf->wDuration_a_f1 = s_uGetDataDuration(priv, pkt_type, need_ack);
+	buf->duration_a_f0 = s_uGetDataDuration(priv, pkt_type, need_ack);
+	buf->duration_a_f1 = s_uGetDataDuration(priv, pkt_type, need_ack);
 
 	buf->wTimeStampOff_a = vnt_time_stamp_off(priv, rate);
 	buf->wTimeStampOff_b = vnt_time_stamp_off(priv,
 						priv->byTopCCKBasicRate);
 
-	return buf->wDuration_a;
+	return buf->duration_a;
 }
 
 static u16 vnt_rxtx_datahead_a_fb(struct vnt_private *priv, u8 pkt_type,
@@ -522,14 +522,14 @@ static u16 vnt_rxtx_datahead_a_fb(struct vnt_private *priv, u8 pkt_type,
 	/* Get SignalField,ServiceField,Length */
 	BBvCalculateParameter(priv, frame_len, rate, pkt_type, &buf->a);
 	/* Get Duration and TimeStampOff */
-	buf->wDuration = s_uGetDataDuration(priv, pkt_type, need_ack);
+	buf->duration = s_uGetDataDuration(priv, pkt_type, need_ack);
 
-	buf->wDuration_f0 = s_uGetDataDuration(priv, pkt_type, need_ack);
-	buf->wDuration_f1 = s_uGetDataDuration(priv, pkt_type, need_ack);
+	buf->duration_f0 = s_uGetDataDuration(priv, pkt_type, need_ack);
+	buf->duration_f1 = s_uGetDataDuration(priv, pkt_type, need_ack);
 
 	buf->wTimeStampOff = vnt_time_stamp_off(priv, rate);
 
-	return buf->wDuration;
+	return buf->duration;
 }
 
 static u16 vnt_rxtx_datahead_ab(struct vnt_private *priv, u8 pkt_type,
@@ -539,11 +539,11 @@ static u16 vnt_rxtx_datahead_ab(struct vnt_private *priv, u8 pkt_type,
 	/* Get SignalField,ServiceField,Length */
 	BBvCalculateParameter(priv, frame_len, rate, pkt_type, &buf->ab);
 	/* Get Duration and TimeStampOff */
-	buf->wDuration = s_uGetDataDuration(priv, pkt_type, need_ack);
+	buf->duration = s_uGetDataDuration(priv, pkt_type, need_ack);
 
 	buf->wTimeStampOff = vnt_time_stamp_off(priv, rate);
 
-	return buf->wDuration;
+	return buf->duration;
 }
 
 static int vnt_fill_ieee80211_rts(struct vnt_private *priv,
@@ -579,14 +579,14 @@ static u16 vnt_rxtx_rts_g_head(struct vnt_private *priv,
 	BBvCalculateParameter(priv, rts_frame_len,
 		priv->byTopOFDMBasicRate, pkt_type, &buf->a);
 
-	buf->wDuration_bb = s_uGetRTSCTSDuration(priv, RTSDUR_BB, frame_len,
+	buf->duration_bb = s_uGetRTSCTSDuration(priv, RTSDUR_BB, frame_len,
 		PK_TYPE_11B, priv->byTopCCKBasicRate, need_ack, fb_option);
-	buf->wDuration_aa = s_uGetRTSCTSDuration(priv, RTSDUR_AA, frame_len,
+	buf->duration_aa = s_uGetRTSCTSDuration(priv, RTSDUR_AA, frame_len,
 		pkt_type, current_rate, need_ack, fb_option);
-	buf->wDuration_ba = s_uGetRTSCTSDuration(priv, RTSDUR_BA, frame_len,
+	buf->duration_ba = s_uGetRTSCTSDuration(priv, RTSDUR_BA, frame_len,
 		pkt_type, current_rate, need_ack, fb_option);
 
-	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->wDuration_aa);
+	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->duration_aa);
 
 	return vnt_rxtx_datahead_g(priv, pkt_type, current_rate,
 			&buf->data_head, frame_len, need_ack);
@@ -605,11 +605,11 @@ static u16 vnt_rxtx_rts_g_fb_head(struct vnt_private *priv,
 		priv->byTopOFDMBasicRate, pkt_type, &buf->a);
 
 
-	buf->wDuration_bb = s_uGetRTSCTSDuration(priv, RTSDUR_BB, frame_len,
+	buf->duration_bb = s_uGetRTSCTSDuration(priv, RTSDUR_BB, frame_len,
 		PK_TYPE_11B, priv->byTopCCKBasicRate, need_ack, fb_option);
-	buf->wDuration_aa = s_uGetRTSCTSDuration(priv, RTSDUR_AA, frame_len,
+	buf->duration_aa = s_uGetRTSCTSDuration(priv, RTSDUR_AA, frame_len,
 		pkt_type, current_rate, need_ack, fb_option);
-	buf->wDuration_ba = s_uGetRTSCTSDuration(priv, RTSDUR_BA, frame_len,
+	buf->duration_ba = s_uGetRTSCTSDuration(priv, RTSDUR_BA, frame_len,
 		pkt_type, current_rate, need_ack, fb_option);
 
 
@@ -622,7 +622,7 @@ static u16 vnt_rxtx_rts_g_fb_head(struct vnt_private *priv,
 	buf->wRTSDuration_aa_f1 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F1,
 		frame_len, pkt_type, priv->tx_rate_fb1, need_ack, fb_option);
 
-	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->wDuration_aa);
+	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->duration_aa);
 
 	return vnt_rxtx_datahead_g_fb(priv, pkt_type, current_rate,
 			&buf->data_head, frame_len, need_ack);
@@ -638,10 +638,10 @@ static u16 vnt_rxtx_rts_ab_head(struct vnt_private *priv,
 	BBvCalculateParameter(priv, rts_frame_len,
 		priv->byTopOFDMBasicRate, pkt_type, &buf->ab);
 
-	buf->wDuration = s_uGetRTSCTSDuration(priv, RTSDUR_AA, frame_len,
+	buf->duration = s_uGetRTSCTSDuration(priv, RTSDUR_AA, frame_len,
 		pkt_type, current_rate, need_ack, fb_option);
 
-	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->wDuration);
+	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->duration);
 
 	return vnt_rxtx_datahead_ab(priv, pkt_type, current_rate,
 			&buf->data_head, frame_len, need_ack);
@@ -657,7 +657,7 @@ static u16 vnt_rxtx_rts_a_fb_head(struct vnt_private *priv,
 	BBvCalculateParameter(priv, rts_frame_len,
 		priv->byTopOFDMBasicRate, pkt_type, &buf->a);
 
-	buf->wDuration = s_uGetRTSCTSDuration(priv, RTSDUR_AA, frame_len,
+	buf->duration = s_uGetRTSCTSDuration(priv, RTSDUR_AA, frame_len,
 		pkt_type, current_rate, need_ack, fb_option);
 
 	buf->wRTSDuration_f0 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F0,
@@ -666,7 +666,7 @@ static u16 vnt_rxtx_rts_a_fb_head(struct vnt_private *priv,
 	buf->wRTSDuration_f1 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F1,
 		frame_len, pkt_type, priv->tx_rate_fb1, need_ack, fb_option);
 
-	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->wDuration);
+	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->duration);
 
 	return vnt_rxtx_datahead_a_fb(priv, pkt_type, current_rate,
 			&buf->data_head, frame_len, need_ack);
@@ -728,7 +728,7 @@ static u16 s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 		/* Get SignalField,ServiceField,Length */
 		BBvCalculateParameter(pDevice, uCTSFrameLen,
 			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
-		pBuf->wDuration_ba = s_uGetRTSCTSDuration(pDevice, CTSDUR_BA,
+		pBuf->duration_ba = s_uGetRTSCTSDuration(pDevice, CTSDUR_BA,
 			cbFrameLength, byPktType,
 			wCurrentRate, bNeedAck, byFBOption);
 		/* Get CTSDuration_ba_f0 */
@@ -740,7 +740,7 @@ static u16 s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 			CTSDUR_BA_F1, cbFrameLength, byPktType,
 			pDevice->tx_rate_fb1, bNeedAck, byFBOption);
 		/* Get CTS Frame body */
-		pBuf->data.duration = pBuf->wDuration_ba;
+		pBuf->data.duration = pBuf->duration_ba;
 		pBuf->data.frame_control = TYPE_CTL_CTS;
 		memcpy(pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
 
@@ -752,11 +752,11 @@ static u16 s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 		BBvCalculateParameter(pDevice, uCTSFrameLen,
 			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
 		/* Get CTSDuration_ba */
-		pBuf->wDuration_ba = s_uGetRTSCTSDuration(pDevice,
+		pBuf->duration_ba = s_uGetRTSCTSDuration(pDevice,
 			CTSDUR_BA, cbFrameLength, byPktType,
 			wCurrentRate, bNeedAck, byFBOption);
 		/*Get CTS Frame body*/
-		pBuf->data.duration = pBuf->wDuration_ba;
+		pBuf->data.duration = pBuf->duration_ba;
 		pBuf->data.frame_control = TYPE_CTL_CTS;
 		memcpy(pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
 
@@ -1593,14 +1593,14 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
 		struct vnt_tx_datahead_g *data_head = &pTX_Buffer->tx_head.
 						tx_cts.tx.head.cts_g.data_head;
-		data_head->wDuration_a =
+		data_head->duration_a =
 			cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
-		data_head->wDuration_b =
+		data_head->duration_b =
 			cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
 	} else {
 		struct vnt_tx_datahead_ab *data_head = &pTX_Buffer->tx_head.
 					tx_ab.tx.head.data_head_ab;
-		data_head->wDuration =
+		data_head->duration =
 			cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
 	}
     }
@@ -2033,14 +2033,14 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
 		struct vnt_tx_datahead_g *data_head = &pTX_Buffer->tx_head.
 						tx_cts.tx.head.cts_g.data_head;
-		data_head->wDuration_a =
+		data_head->duration_a =
 			cpu_to_le16(p80211Header->sA2.wDurationID);
-		data_head->wDuration_b =
+		data_head->duration_b =
 			cpu_to_le16(p80211Header->sA2.wDurationID);
 	} else {
 		struct vnt_tx_datahead_ab *data_head = &pTX_Buffer->tx_head.
 					tx_ab.tx.head.data_head_ab;
-		data_head->wDuration =
+		data_head->duration =
 			cpu_to_le16(p80211Header->sA2.wDurationID);
 	}
     }
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index b3ee6d0..d677d07 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -77,8 +77,8 @@ struct vnt_rrv_time_ab {
 struct vnt_tx_datahead_g {
 	struct vnt_phy_field b;
 	struct vnt_phy_field a;
-	u16 wDuration_b;
-	u16 wDuration_a;
+	__le16 duration_b;
+	__le16 duration_a;
 	u16 wTimeStampOff_b;
 	u16 wTimeStampOff_a;
 } __packed;
@@ -86,35 +86,35 @@ struct vnt_tx_datahead_g {
 struct vnt_tx_datahead_g_fb {
 	struct vnt_phy_field b;
 	struct vnt_phy_field a;
-	u16 wDuration_b;
-	u16 wDuration_a;
-	u16 wDuration_a_f0;
-	u16 wDuration_a_f1;
+	__le16 duration_b;
+	__le16 duration_a;
+	__le16 duration_a_f0;
+	__le16 duration_a_f1;
 	u16 wTimeStampOff_b;
 	u16 wTimeStampOff_a;
 } __packed;
 
 struct vnt_tx_datahead_ab {
 	struct vnt_phy_field ab;
-	u16 wDuration;
+	__le16 duration;
 	u16 wTimeStampOff;
 } __packed;
 
 struct vnt_tx_datahead_a_fb {
 	struct vnt_phy_field a;
-	u16 wDuration;
+	__le16 duration;
 	u16 wTimeStampOff;
-	u16 wDuration_f0;
-	u16 wDuration_f1;
+	__le16 duration_f0;
+	__le16 duration_f1;
 } __packed;
 
 /* RTS buffer header */
 struct vnt_rts_g {
 	struct vnt_phy_field b;
 	struct vnt_phy_field a;
-	u16 wDuration_ba;
-	u16 wDuration_aa;
-	u16 wDuration_bb;
+	__le16 duration_ba;
+	__le16 duration_aa;
+	__le16 duration_bb;
 	u16 wReserved;
 	struct ieee80211_rts data;
 	struct vnt_tx_datahead_g data_head;
@@ -123,9 +123,9 @@ struct vnt_rts_g {
 struct vnt_rts_g_fb {
 	struct vnt_phy_field b;
 	struct vnt_phy_field a;
-	u16 wDuration_ba;
-	u16 wDuration_aa;
-	u16 wDuration_bb;
+	__le16 duration_ba;
+	__le16 duration_aa;
+	__le16 duration_bb;
 	u16 wReserved;
 	u16 wRTSDuration_ba_f0;
 	u16 wRTSDuration_aa_f0;
@@ -137,7 +137,7 @@ struct vnt_rts_g_fb {
 
 struct vnt_rts_ab {
 	struct vnt_phy_field ab;
-	u16 wDuration;
+	__le16 duration;
 	u16 wReserved;
 	struct ieee80211_rts data;
 	struct vnt_tx_datahead_ab data_head;
@@ -145,7 +145,7 @@ struct vnt_rts_ab {
 
 struct vnt_rts_a_fb {
 	struct vnt_phy_field a;
-	u16 wDuration;
+	__le16 duration;
 	u16 wReserved;
 	u16 wRTSDuration_f0;
 	u16 wRTSDuration_f1;
@@ -156,7 +156,7 @@ struct vnt_rts_a_fb {
 /* CTS buffer header */
 struct vnt_cts {
 	struct vnt_phy_field b;
-	u16 wDuration_ba;
+	__le16 duration_ba;
 	u16 wReserved;
 	struct ieee80211_cts data;
 	u16 reserved2;
@@ -165,7 +165,7 @@ struct vnt_cts {
 
 struct vnt_cts_fb {
 	struct vnt_phy_field b;
-	u16 wDuration_ba;
+	__le16 duration_ba;
 	u16 wReserved;
 	u16 wCTSDuration_ba_f0;
 	u16 wCTSDuration_ba_f1;
-- 
1.9.0

