Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50816 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbaGTOfF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:35:05 -0400
Received: by mail-wi0-f172.google.com with SMTP id n3so2917412wiv.11
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:35:04 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 25/25] staging: vt6656: struct vnt_usb_send_context context into vnt_get_duration_le
Date: Sun, 20 Jul 2014 15:33:35 +0100
Message-Id: <1405866815-2687-25-git-send-email-tvboxspy@gmail.com> (sfid-20140720_165108_384294_BF9A741B)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing priv, frame_length and need_ack

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 122 +++++++++++++++++++++++-------------------
 1 file changed, 68 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 7c92d1b..4fc93f0 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -199,10 +199,13 @@ static __le16 vnt_get_duration_le(struct vnt_private *priv,
 	return 0;
 }
 
-static __le16 vnt_get_rtscts_duration_le(struct vnt_private *priv, u8 dur_type,
-	u32 frame_length, u8 pkt_type, u16 rate, int need_ack)
+static __le16 vnt_get_rtscts_duration_le(struct vnt_usb_send_context *context,
+					 u8 dur_type, u8 pkt_type, u16 rate)
 {
+	struct vnt_private *priv = context->priv;
 	u32 cts_time = 0, dur_time = 0;
+	u32 frame_length = context->frame_len;
+	u8 need_ack = context->need_ack;
 
 	switch (dur_type) {
 	case RTSDUR_BB:
@@ -399,22 +402,23 @@ static u16 vnt_rxtx_rts_g_head(struct vnt_usb_send_context *tx_context,
 			       struct vnt_rts_g *buf)
 {
 	struct vnt_private *priv = tx_context->priv;
-	u32 frame_len = tx_context->frame_len;
 	u16 rts_frame_len = 20;
 	u16 current_rate = tx_context->tx_rate;
-	u8 need_ack = tx_context->need_ack;
 
 	vnt_get_phy_field(priv, rts_frame_len, priv->top_cck_basic_rate,
 		PK_TYPE_11B, &buf->b);
 	vnt_get_phy_field(priv, rts_frame_len, priv->top_ofdm_basic_rate,
 			  tx_context->pkt_type, &buf->a);
 
-	buf->duration_bb = vnt_get_rtscts_duration_le(priv, RTSDUR_BB,
-		frame_len, PK_TYPE_11B, priv->top_cck_basic_rate, need_ack);
-	buf->duration_aa = vnt_get_rtscts_duration_le(priv, RTSDUR_AA,
-		frame_len, tx_context->pkt_type, current_rate, need_ack);
-	buf->duration_ba = vnt_get_rtscts_duration_le(priv, RTSDUR_BA,
-		frame_len, tx_context->pkt_type, current_rate, need_ack);
+	buf->duration_bb = vnt_get_rtscts_duration_le(tx_context, RTSDUR_BB,
+						      PK_TYPE_11B,
+						      priv->top_cck_basic_rate);
+	buf->duration_aa = vnt_get_rtscts_duration_le(tx_context, RTSDUR_AA,
+						      tx_context->pkt_type,
+						      current_rate);
+	buf->duration_ba = vnt_get_rtscts_duration_le(tx_context, RTSDUR_BA,
+						      tx_context->pkt_type,
+						      current_rate);
 
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration_aa);
 
@@ -425,31 +429,40 @@ static u16 vnt_rxtx_rts_g_fb_head(struct vnt_usb_send_context *tx_context,
 				  struct vnt_rts_g_fb *buf)
 {
 	struct vnt_private *priv = tx_context->priv;
-	u32 frame_len = tx_context->frame_len;
 	u16 current_rate = tx_context->tx_rate;
 	u16 rts_frame_len = 20;
-	u8 need_ack = tx_context->need_ack;
 
 	vnt_get_phy_field(priv, rts_frame_len, priv->top_cck_basic_rate,
 		PK_TYPE_11B, &buf->b);
 	vnt_get_phy_field(priv, rts_frame_len, priv->top_ofdm_basic_rate,
 			  tx_context->pkt_type, &buf->a);
 
-	buf->duration_bb = vnt_get_rtscts_duration_le(priv, RTSDUR_BB,
-		frame_len, PK_TYPE_11B, priv->top_cck_basic_rate, need_ack);
-	buf->duration_aa = vnt_get_rtscts_duration_le(priv, RTSDUR_AA,
-		frame_len, tx_context->pkt_type, current_rate, need_ack);
-	buf->duration_ba = vnt_get_rtscts_duration_le(priv, RTSDUR_BA,
-		frame_len, tx_context->pkt_type, current_rate, need_ack);
-
-	buf->rts_duration_ba_f0 = vnt_get_rtscts_duration_le(priv, RTSDUR_BA_F0,
-		frame_len, tx_context->pkt_type, priv->tx_rate_fb0, need_ack);
-	buf->rts_duration_aa_f0 = vnt_get_rtscts_duration_le(priv, RTSDUR_AA_F0,
-		frame_len, tx_context->pkt_type, priv->tx_rate_fb0, need_ack);
-	buf->rts_duration_ba_f1 = vnt_get_rtscts_duration_le(priv, RTSDUR_BA_F1,
-		frame_len, tx_context->pkt_type, priv->tx_rate_fb1, need_ack);
-	buf->rts_duration_aa_f1 = vnt_get_rtscts_duration_le(priv, RTSDUR_AA_F1,
-		frame_len, tx_context->pkt_type, priv->tx_rate_fb1, need_ack);
+	buf->duration_bb = vnt_get_rtscts_duration_le(tx_context, RTSDUR_BB,
+						      PK_TYPE_11B,
+						      priv->top_cck_basic_rate);
+	buf->duration_aa = vnt_get_rtscts_duration_le(tx_context, RTSDUR_AA,
+						      tx_context->pkt_type,
+						      current_rate);
+	buf->duration_ba = vnt_get_rtscts_duration_le(tx_context, RTSDUR_BA,
+						      tx_context->pkt_type,
+						      current_rate);
+
+	buf->rts_duration_ba_f0 =
+		vnt_get_rtscts_duration_le(tx_context, RTSDUR_BA_F0,
+					   tx_context->pkt_type,
+					   priv->tx_rate_fb0);
+	buf->rts_duration_aa_f0 =
+		vnt_get_rtscts_duration_le(tx_context, RTSDUR_AA_F0,
+					   tx_context->pkt_type,
+					   priv->tx_rate_fb0);
+	buf->rts_duration_ba_f1 =
+		vnt_get_rtscts_duration_le(tx_context, RTSDUR_BA_F1,
+					   tx_context->pkt_type,
+					   priv->tx_rate_fb1);
+	buf->rts_duration_aa_f1 =
+		vnt_get_rtscts_duration_le(tx_context, RTSDUR_AA_F1,
+					   tx_context->pkt_type,
+					   priv->tx_rate_fb1);
 
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration_aa);
 
@@ -460,18 +473,15 @@ static u16 vnt_rxtx_rts_ab_head(struct vnt_usb_send_context *tx_context,
 				struct vnt_rts_ab *buf)
 {
 	struct vnt_private *priv = tx_context->priv;
-	u32 frame_len = tx_context->frame_len;
 	u16 current_rate = tx_context->tx_rate;
 	u16 rts_frame_len = 20;
-	u8 need_ack = tx_context->need_ack;
-
 
 	vnt_get_phy_field(priv, rts_frame_len, priv->top_ofdm_basic_rate,
 			  tx_context->pkt_type, &buf->ab);
 
-	buf->duration = vnt_get_rtscts_duration_le(priv, RTSDUR_AA, frame_len,
+	buf->duration = vnt_get_rtscts_duration_le(tx_context, RTSDUR_AA,
 						   tx_context->pkt_type,
-						   current_rate, need_ack);
+						   current_rate);
 
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration);
 
@@ -482,23 +492,25 @@ static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
 				  struct vnt_rts_a_fb *buf)
 {
 	struct vnt_private *priv = tx_context->priv;
-	u32 frame_len = tx_context->frame_len;
 	u16 current_rate = tx_context->tx_rate;
 	u16 rts_frame_len = 20;
-	u8 need_ack = tx_context->need_ack;
 
 	vnt_get_phy_field(priv, rts_frame_len,
 		priv->top_ofdm_basic_rate, tx_context->pkt_type, &buf->a);
 
-	buf->duration = vnt_get_rtscts_duration_le(priv, RTSDUR_AA, frame_len,
+	buf->duration = vnt_get_rtscts_duration_le(tx_context, RTSDUR_AA,
 						   tx_context->pkt_type,
-						   current_rate, need_ack);
+						   current_rate);
 
-	buf->rts_duration_f0 = vnt_get_rtscts_duration_le(priv, RTSDUR_AA_F0,
-		frame_len, tx_context->pkt_type, priv->tx_rate_fb0, need_ack);
+	buf->rts_duration_f0 =
+		vnt_get_rtscts_duration_le(tx_context, RTSDUR_AA_F0,
+					   tx_context->pkt_type,
+					   priv->tx_rate_fb0);
 
-	buf->rts_duration_f1 = vnt_get_rtscts_duration_le(priv, RTSDUR_AA_F1,
-		frame_len, tx_context->pkt_type, priv->tx_rate_fb1, need_ack);
+	buf->rts_duration_f1 =
+		vnt_get_rtscts_duration_le(tx_context, RTSDUR_AA_F1,
+					   tx_context->pkt_type,
+					   priv->tx_rate_fb1);
 
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration);
 
@@ -509,10 +521,8 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 	union vnt_tx_data_head *head)
 {
 	struct vnt_private *priv = tx_context->priv;
-	u32 frame_len = tx_context->frame_len;
 	u32 cts_frame_len = 14;
 	u16 current_rate = tx_context->tx_rate;
-	u8 need_ack = tx_context->need_ack;
 
 	if (!head)
 		return 0;
@@ -523,17 +533,20 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 		/* Get SignalField,ServiceField,Length */
 		vnt_get_phy_field(priv, cts_frame_len,
 			priv->top_cck_basic_rate, PK_TYPE_11B, &buf->b);
-		buf->duration_ba = vnt_get_rtscts_duration_le(priv, CTSDUR_BA,
-			frame_len, tx_context->pkt_type,
-			current_rate, need_ack);
+		buf->duration_ba =
+			vnt_get_rtscts_duration_le(tx_context, CTSDUR_BA,
+						   tx_context->pkt_type,
+						   current_rate);
 		/* Get CTSDuration_ba_f0 */
-		buf->cts_duration_ba_f0 = vnt_get_rtscts_duration_le(priv,
-			CTSDUR_BA_F0, frame_len, tx_context->pkt_type,
-			priv->tx_rate_fb0, need_ack);
+		buf->cts_duration_ba_f0 =
+			vnt_get_rtscts_duration_le(tx_context, CTSDUR_BA_F0,
+						   tx_context->pkt_type,
+						   priv->tx_rate_fb0);
 		/* Get CTSDuration_ba_f1 */
-		buf->cts_duration_ba_f1 = vnt_get_rtscts_duration_le(priv,
-			CTSDUR_BA_F1, frame_len, tx_context->pkt_type,
-			priv->tx_rate_fb1, need_ack);
+		buf->cts_duration_ba_f1 =
+			vnt_get_rtscts_duration_le(tx_context, CTSDUR_BA_F1,
+						   tx_context->pkt_type,
+						   priv->tx_rate_fb1);
 		/* Get CTS Frame body */
 		buf->data.duration = buf->duration_ba;
 		buf->data.frame_control =
@@ -548,9 +561,10 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 		vnt_get_phy_field(priv, cts_frame_len,
 			priv->top_cck_basic_rate, PK_TYPE_11B, &buf->b);
 		/* Get CTSDuration_ba */
-		buf->duration_ba = vnt_get_rtscts_duration_le(priv,
-			CTSDUR_BA, frame_len, tx_context->pkt_type,
-			current_rate, need_ack);
+		buf->duration_ba =
+			vnt_get_rtscts_duration_le(tx_context, CTSDUR_BA,
+						   tx_context->pkt_type,
+						   current_rate);
 		/*Get CTS Frame body*/
 		buf->data.duration = buf->duration_ba;
 		buf->data.frame_control =
-- 
2.0.1

