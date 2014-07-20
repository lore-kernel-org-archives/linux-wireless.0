Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59657 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbaGTOe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:58 -0400
Received: by mail-wg0-f52.google.com with SMTP id a1so5351115wgh.35
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:57 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 21/25] staging: vt6656: rxtx move pkt_type into vnt_usb_send_context
Date: Sun, 20 Jul 2014 15:33:31 +0100
Message-Id: <1405866815-2687-21-git-send-email-tvboxspy@gmail.com> (sfid-20140720_165108_752095_5B0C979D)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing pkt_type from functions

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h |   1 +
 drivers/staging/vt6656/rxtx.c   | 208 +++++++++++++++++++++-------------------
 2 files changed, 109 insertions(+), 100 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 120d325..0d5ecd6 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -235,6 +235,7 @@ struct vnt_usb_send_context {
 	u16 tx_hdr_size;
 	u8 type;
 	u8 pkt_no;
+	u8 pkt_type;
 	u8 fb_option;
 	bool in_use;
 	unsigned char data[MAX_TOTAL_SIZE_WITH_ALL_HEADERS];
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 5d2072f..7906251 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -254,7 +254,7 @@ static u16 vnt_mac_hdr_pos(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_datahead_g(struct vnt_usb_send_context *tx_context,
-		u8 pkt_type, u16 rate, struct vnt_tx_datahead_g *buf,
+		u16 rate, struct vnt_tx_datahead_g *buf,
 		u32 frame_len, int need_ack)
 {
 
@@ -263,7 +263,7 @@ static u16 vnt_rxtx_datahead_g(struct vnt_usb_send_context *tx_context,
 				(struct ieee80211_hdr *)tx_context->skb->data;
 
 	/* Get SignalField,ServiceField,Length */
-	vnt_get_phy_field(priv, frame_len, rate, pkt_type, &buf->a);
+	vnt_get_phy_field(priv, frame_len, rate, tx_context->pkt_type, &buf->a);
 	vnt_get_phy_field(priv, frame_len, priv->top_cck_basic_rate,
 							PK_TYPE_11B, &buf->b);
 
@@ -274,7 +274,8 @@ static u16 vnt_rxtx_datahead_g(struct vnt_usb_send_context *tx_context,
 		buf->duration_a = dur;
 		buf->duration_b = dur;
 	} else {
-		buf->duration_a = vnt_get_duration_le(priv, pkt_type, need_ack);
+		buf->duration_a = vnt_get_duration_le(priv,
+						tx_context->pkt_type, need_ack);
 		buf->duration_b = vnt_get_duration_le(priv,
 							PK_TYPE_11B, need_ack);
 	}
@@ -289,23 +290,26 @@ static u16 vnt_rxtx_datahead_g(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_datahead_g_fb(struct vnt_usb_send_context *tx_context,
-		u8 pkt_type, u16 rate, struct vnt_tx_datahead_g_fb *buf,
+		u16 rate, struct vnt_tx_datahead_g_fb *buf,
 		u32 frame_len, int need_ack)
 {
 	struct vnt_private *priv = tx_context->priv;
 
 	/* Get SignalField,ServiceField,Length */
-	vnt_get_phy_field(priv, frame_len, rate, pkt_type, &buf->a);
+	vnt_get_phy_field(priv, frame_len, rate, tx_context->pkt_type, &buf->a);
 
 	vnt_get_phy_field(priv, frame_len, priv->top_cck_basic_rate,
 						PK_TYPE_11B, &buf->b);
 
 	/* Get Duration and TimeStamp */
-	buf->duration_a = vnt_get_duration_le(priv, pkt_type, need_ack);
+	buf->duration_a = vnt_get_duration_le(priv, tx_context->pkt_type,
+					      need_ack);
 	buf->duration_b = vnt_get_duration_le(priv, PK_TYPE_11B, need_ack);
 
-	buf->duration_a_f0 = vnt_get_duration_le(priv, pkt_type, need_ack);
-	buf->duration_a_f1 = vnt_get_duration_le(priv, pkt_type, need_ack);
+	buf->duration_a_f0 = vnt_get_duration_le(priv, tx_context->pkt_type,
+						 need_ack);
+	buf->duration_a_f1 = vnt_get_duration_le(priv, tx_context->pkt_type,
+						 need_ack);
 
 	buf->time_stamp_off_a = vnt_time_stamp_off(priv, rate);
 	buf->time_stamp_off_b = vnt_time_stamp_off(priv,
@@ -317,10 +321,11 @@ static u16 vnt_rxtx_datahead_g_fb(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_datahead_a_fb(struct vnt_usb_send_context *tx_context,
-		u8 pkt_type, u16 rate, struct vnt_tx_datahead_a_fb *buf,
+		u16 rate, struct vnt_tx_datahead_a_fb *buf,
 		u32 frame_len, int need_ack)
 {
 	struct vnt_private *priv = tx_context->priv;
+	u8 pkt_type = tx_context->pkt_type;
 
 	/* Get SignalField,ServiceField,Length */
 	vnt_get_phy_field(priv, frame_len, rate, pkt_type, &buf->a);
@@ -338,7 +343,7 @@ static u16 vnt_rxtx_datahead_a_fb(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_datahead_ab(struct vnt_usb_send_context *tx_context,
-		u8 pkt_type, u16 rate, struct vnt_tx_datahead_ab *buf,
+		u16 rate, struct vnt_tx_datahead_ab *buf,
 		u32 frame_len, int need_ack)
 {
 	struct vnt_private *priv = tx_context->priv;
@@ -346,7 +351,8 @@ static u16 vnt_rxtx_datahead_ab(struct vnt_usb_send_context *tx_context,
 				(struct ieee80211_hdr *)tx_context->skb->data;
 
 	/* Get SignalField,ServiceField,Length */
-	vnt_get_phy_field(priv, frame_len, rate, pkt_type, &buf->ab);
+	vnt_get_phy_field(priv, frame_len, rate,
+			  tx_context->pkt_type, &buf->ab);
 
 	/* Get Duration and TimeStampOff */
 	if (ieee80211_is_pspoll(hdr->frame_control)) {
@@ -354,7 +360,8 @@ static u16 vnt_rxtx_datahead_ab(struct vnt_usb_send_context *tx_context,
 
 		buf->duration = dur;
 	} else {
-		buf->duration = vnt_get_duration_le(priv, pkt_type, need_ack);
+		buf->duration = vnt_get_duration_le(priv, tx_context->pkt_type,
+						    need_ack);
 	}
 
 	buf->time_stamp_off = vnt_time_stamp_off(priv, rate);
@@ -381,112 +388,109 @@ static int vnt_fill_ieee80211_rts(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_rts_g_head(struct vnt_usb_send_context *tx_context,
-	struct vnt_rts_g *buf, u8 pkt_type, u32 frame_len, int need_ack,
-	u16 current_rate)
+	struct vnt_rts_g *buf, u32 frame_len, int need_ack, u16 current_rate)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
 
 	vnt_get_phy_field(priv, rts_frame_len, priv->top_cck_basic_rate,
 		PK_TYPE_11B, &buf->b);
-	vnt_get_phy_field(priv, rts_frame_len,
-		priv->top_ofdm_basic_rate, pkt_type, &buf->a);
+	vnt_get_phy_field(priv, rts_frame_len, priv->top_ofdm_basic_rate,
+			  tx_context->pkt_type, &buf->a);
 
 	buf->duration_bb = vnt_get_rtscts_duration_le(priv, RTSDUR_BB,
 		frame_len, PK_TYPE_11B, priv->top_cck_basic_rate, need_ack);
 	buf->duration_aa = vnt_get_rtscts_duration_le(priv, RTSDUR_AA,
-		frame_len, pkt_type, current_rate, need_ack);
+		frame_len, tx_context->pkt_type, current_rate, need_ack);
 	buf->duration_ba = vnt_get_rtscts_duration_le(priv, RTSDUR_BA,
-		frame_len, pkt_type, current_rate, need_ack);
+		frame_len, tx_context->pkt_type, current_rate, need_ack);
 
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration_aa);
 
-	return vnt_rxtx_datahead_g(tx_context, pkt_type, current_rate,
-			&buf->data_head, frame_len, need_ack);
+	return vnt_rxtx_datahead_g(tx_context, current_rate, &buf->data_head,
+				   frame_len, need_ack);
 }
 
 static u16 vnt_rxtx_rts_g_fb_head(struct vnt_usb_send_context *tx_context,
-	struct vnt_rts_g_fb *buf, u8 pkt_type, u32 frame_len, int need_ack,
-	u16 current_rate)
+	struct vnt_rts_g_fb *buf, u32 frame_len, int need_ack, u16 current_rate)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
 
 	vnt_get_phy_field(priv, rts_frame_len, priv->top_cck_basic_rate,
 		PK_TYPE_11B, &buf->b);
-	vnt_get_phy_field(priv, rts_frame_len,
-		priv->top_ofdm_basic_rate, pkt_type, &buf->a);
-
+	vnt_get_phy_field(priv, rts_frame_len, priv->top_ofdm_basic_rate,
+			  tx_context->pkt_type, &buf->a);
 
 	buf->duration_bb = vnt_get_rtscts_duration_le(priv, RTSDUR_BB,
 		frame_len, PK_TYPE_11B, priv->top_cck_basic_rate, need_ack);
 	buf->duration_aa = vnt_get_rtscts_duration_le(priv, RTSDUR_AA,
-		frame_len, pkt_type, current_rate, need_ack);
+		frame_len, tx_context->pkt_type, current_rate, need_ack);
 	buf->duration_ba = vnt_get_rtscts_duration_le(priv, RTSDUR_BA,
-		frame_len, pkt_type, current_rate, need_ack);
-
+		frame_len, tx_context->pkt_type, current_rate, need_ack);
 
 	buf->rts_duration_ba_f0 = vnt_get_rtscts_duration_le(priv, RTSDUR_BA_F0,
-		frame_len, pkt_type, priv->tx_rate_fb0, need_ack);
+		frame_len, tx_context->pkt_type, priv->tx_rate_fb0, need_ack);
 	buf->rts_duration_aa_f0 = vnt_get_rtscts_duration_le(priv, RTSDUR_AA_F0,
-		frame_len, pkt_type, priv->tx_rate_fb0, need_ack);
+		frame_len, tx_context->pkt_type, priv->tx_rate_fb0, need_ack);
 	buf->rts_duration_ba_f1 = vnt_get_rtscts_duration_le(priv, RTSDUR_BA_F1,
-		frame_len, pkt_type, priv->tx_rate_fb1, need_ack);
+		frame_len, tx_context->pkt_type, priv->tx_rate_fb1, need_ack);
 	buf->rts_duration_aa_f1 = vnt_get_rtscts_duration_le(priv, RTSDUR_AA_F1,
-		frame_len, pkt_type, priv->tx_rate_fb1, need_ack);
+		frame_len, tx_context->pkt_type, priv->tx_rate_fb1, need_ack);
 
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration_aa);
 
-	return vnt_rxtx_datahead_g_fb(tx_context, pkt_type, current_rate,
-			&buf->data_head, frame_len, need_ack);
+	return vnt_rxtx_datahead_g_fb(tx_context, current_rate, &buf->data_head,
+				      frame_len, need_ack);
 }
 
 static u16 vnt_rxtx_rts_ab_head(struct vnt_usb_send_context *tx_context,
-	struct vnt_rts_ab *buf,	u8 pkt_type, u32 frame_len, int need_ack,
+	struct vnt_rts_ab *buf, u32 frame_len, int need_ack,
 	u16 current_rate)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
 
-	vnt_get_phy_field(priv, rts_frame_len,
-		priv->top_ofdm_basic_rate, pkt_type, &buf->ab);
+	vnt_get_phy_field(priv, rts_frame_len, priv->top_ofdm_basic_rate,
+			  tx_context->pkt_type, &buf->ab);
 
 	buf->duration = vnt_get_rtscts_duration_le(priv, RTSDUR_AA, frame_len,
-		pkt_type, current_rate, need_ack);
+						   tx_context->pkt_type,
+						   current_rate, need_ack);
 
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration);
 
-	return vnt_rxtx_datahead_ab(tx_context, pkt_type, current_rate,
-			&buf->data_head, frame_len, need_ack);
+	return vnt_rxtx_datahead_ab(tx_context, current_rate,
+				    &buf->data_head, frame_len, need_ack);
 }
 
 static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
-	struct vnt_rts_a_fb *buf, u8 pkt_type, u32 frame_len, int need_ack,
-	u16 current_rate)
+	struct vnt_rts_a_fb *buf, u32 frame_len, int need_ack, u16 current_rate)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
 
 	vnt_get_phy_field(priv, rts_frame_len,
-		priv->top_ofdm_basic_rate, pkt_type, &buf->a);
+		priv->top_ofdm_basic_rate, tx_context->pkt_type, &buf->a);
 
 	buf->duration = vnt_get_rtscts_duration_le(priv, RTSDUR_AA, frame_len,
-		pkt_type, current_rate, need_ack);
+						   tx_context->pkt_type,
+						   current_rate, need_ack);
 
 	buf->rts_duration_f0 = vnt_get_rtscts_duration_le(priv, RTSDUR_AA_F0,
-		frame_len, pkt_type, priv->tx_rate_fb0, need_ack);
+		frame_len, tx_context->pkt_type, priv->tx_rate_fb0, need_ack);
 
 	buf->rts_duration_f1 = vnt_get_rtscts_duration_le(priv, RTSDUR_AA_F1,
-		frame_len, pkt_type, priv->tx_rate_fb1, need_ack);
+		frame_len, tx_context->pkt_type, priv->tx_rate_fb1, need_ack);
 
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration);
 
-	return vnt_rxtx_datahead_a_fb(tx_context, pkt_type, current_rate,
-			&buf->data_head, frame_len, need_ack);
+	return vnt_rxtx_datahead_a_fb(tx_context, current_rate, &buf->data_head,
+				      frame_len, need_ack);
 }
 
 static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
-	u8 pkt_type, union vnt_tx_data_head *head, u32 frame_len,
+	union vnt_tx_data_head *head, u32 frame_len,
 	int need_ack, u16 current_rate)
 {
 	struct vnt_private *priv = tx_context->priv;
@@ -502,15 +506,15 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 		vnt_get_phy_field(priv, cts_frame_len,
 			priv->top_cck_basic_rate, PK_TYPE_11B, &buf->b);
 		buf->duration_ba = vnt_get_rtscts_duration_le(priv, CTSDUR_BA,
-			frame_len, pkt_type,
+			frame_len, tx_context->pkt_type,
 			current_rate, need_ack);
 		/* Get CTSDuration_ba_f0 */
 		buf->cts_duration_ba_f0 = vnt_get_rtscts_duration_le(priv,
-			CTSDUR_BA_F0, frame_len, pkt_type,
+			CTSDUR_BA_F0, frame_len, tx_context->pkt_type,
 			priv->tx_rate_fb0, need_ack);
 		/* Get CTSDuration_ba_f1 */
 		buf->cts_duration_ba_f1 = vnt_get_rtscts_duration_le(priv,
-			CTSDUR_BA_F1, frame_len, pkt_type,
+			CTSDUR_BA_F1, frame_len, tx_context->pkt_type,
 			priv->tx_rate_fb1, need_ack);
 		/* Get CTS Frame body */
 		buf->data.duration = buf->duration_ba;
@@ -519,9 +523,9 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 
 		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
 
-		return vnt_rxtx_datahead_g_fb(tx_context, pkt_type,
-				current_rate, &buf->data_head, frame_len,
-				need_ack);
+		return vnt_rxtx_datahead_g_fb(tx_context, current_rate,
+					      &buf->data_head, frame_len,
+					      need_ack);
 	} else {
 		struct vnt_cts *buf = &head->cts_g;
 		/* Get SignalField,ServiceField,Length */
@@ -529,7 +533,7 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 			priv->top_cck_basic_rate, PK_TYPE_11B, &buf->b);
 		/* Get CTSDuration_ba */
 		buf->duration_ba = vnt_get_rtscts_duration_le(priv,
-			CTSDUR_BA, frame_len, pkt_type,
+			CTSDUR_BA, frame_len, tx_context->pkt_type,
 			current_rate, need_ack);
 		/*Get CTS Frame body*/
 		buf->data.duration = buf->duration_ba;
@@ -538,7 +542,7 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 
 		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
 
-		return vnt_rxtx_datahead_g(tx_context, pkt_type, current_rate,
+		return vnt_rxtx_datahead_g(tx_context, current_rate,
 				&buf->data_head, frame_len, need_ack);
         }
 
@@ -546,22 +550,23 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
-	union vnt_tx_head *tx_head, u8 pkt_type, u32 frame_size,
-	int need_ack, u16 current_rate, bool need_mic)
+	union vnt_tx_head *tx_head, u32 frame_size, int need_ack,
+	u16 current_rate, bool need_mic)
 {
 	struct vnt_private *priv = tx_context->priv;
 	struct vnt_rrv_time_rts *buf = &tx_head->tx_rts.rts;
 	union vnt_tx_data_head *head = &tx_head->tx_rts.tx.head;
 
 	buf->rts_rrv_time_aa = vnt_get_rtscts_rsvtime_le(priv, 2,
-				pkt_type, frame_size, current_rate);
+			tx_context->pkt_type, frame_size, current_rate);
 	buf->rts_rrv_time_ba = vnt_get_rtscts_rsvtime_le(priv, 1,
-				pkt_type, frame_size, current_rate);
+			tx_context->pkt_type, frame_size, current_rate);
 	buf->rts_rrv_time_bb = vnt_get_rtscts_rsvtime_le(priv, 0,
-				pkt_type, frame_size, current_rate);
+			tx_context->pkt_type, frame_size, current_rate);
 
-	buf->rrv_time_a = vnt_rxtx_rsvtime_le16(priv, pkt_type, frame_size,
-							current_rate, need_ack);
+	buf->rrv_time_a = vnt_rxtx_rsvtime_le16(priv, tx_context->pkt_type,
+						frame_size, current_rate,
+						need_ack);
 	buf->rrv_time_b = vnt_rxtx_rsvtime_le16(priv, PK_TYPE_11B, frame_size,
 					priv->top_cck_basic_rate, need_ack);
 
@@ -570,106 +575,108 @@ static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
 
 	if (tx_context->fb_option)
 		return vnt_rxtx_rts_g_fb_head(tx_context, &head->rts_g_fb,
-			pkt_type, frame_size, need_ack, current_rate);
+					frame_size, need_ack, current_rate);
 
-	return vnt_rxtx_rts_g_head(tx_context, &head->rts_g,
-				pkt_type, frame_size, need_ack, current_rate);
+	return vnt_rxtx_rts_g_head(tx_context, &head->rts_g, frame_size,
+				   need_ack, current_rate);
 }
 
 static u16 vnt_rxtx_cts(struct vnt_usb_send_context *tx_context,
-	union vnt_tx_head *tx_head, u8 pkt_type, u32 frame_size,
-	int need_ack, u16 current_rate, bool need_mic)
+	union vnt_tx_head *tx_head, u32 frame_size, int need_ack,
+	u16 current_rate, bool need_mic)
 {
 	struct vnt_private *priv = tx_context->priv;
 	struct vnt_rrv_time_cts *buf = &tx_head->tx_cts.cts;
 	union vnt_tx_data_head *head = &tx_head->tx_cts.tx.head;
 
-
-	buf->rrv_time_a = vnt_rxtx_rsvtime_le16(priv, pkt_type,
+	buf->rrv_time_a = vnt_rxtx_rsvtime_le16(priv, tx_context->pkt_type,
 					frame_size, current_rate, need_ack);
 	buf->rrv_time_b = vnt_rxtx_rsvtime_le16(priv, PK_TYPE_11B,
 				frame_size, priv->top_cck_basic_rate, need_ack);
 
 	buf->cts_rrv_time_ba = vnt_get_rtscts_rsvtime_le(priv, 3,
-			pkt_type, frame_size, current_rate);
+			tx_context->pkt_type, frame_size, current_rate);
 
 	if (need_mic)
 		head = &tx_head->tx_cts.tx.mic.head;
 
 	/* Fill CTS */
-	return vnt_fill_cts_head(tx_context, pkt_type, head, frame_size,
-							need_ack, current_rate);
+	return vnt_fill_cts_head(tx_context,
+				 head, frame_size, need_ack, current_rate);
 }
 
 static u16 vnt_rxtx_ab(struct vnt_usb_send_context *tx_context,
-	union vnt_tx_head *tx_head, u8 pkt_type, u32 frame_size,
+	union vnt_tx_head *tx_head, u32 frame_size,
 	int need_ack, u16 current_rate, bool need_rts, bool need_mic)
 {
 	struct vnt_private *priv = tx_context->priv;
 	struct vnt_rrv_time_ab *buf = &tx_head->tx_ab.ab;
 	union vnt_tx_data_head *head = &tx_head->tx_ab.tx.head;
 
-	buf->rrv_time = vnt_rxtx_rsvtime_le16(priv, pkt_type,
+	buf->rrv_time = vnt_rxtx_rsvtime_le16(priv, tx_context->pkt_type,
 			frame_size, current_rate, need_ack);
 
 	if (need_mic)
 		head = &tx_head->tx_ab.tx.mic.head;
 
 	if (need_rts) {
-		if (pkt_type == PK_TYPE_11B)
+		if (tx_context->pkt_type == PK_TYPE_11B)
 			buf->rts_rrv_time = vnt_get_rtscts_rsvtime_le(priv, 0,
-				pkt_type, frame_size, current_rate);
+				tx_context->pkt_type, frame_size, current_rate);
 		else /* PK_TYPE_11A */
 			buf->rts_rrv_time = vnt_get_rtscts_rsvtime_le(priv, 2,
-				pkt_type, frame_size, current_rate);
+				tx_context->pkt_type, frame_size, current_rate);
 
-		if (tx_context->fb_option && pkt_type == PK_TYPE_11A)
+		if (tx_context->fb_option &&
+		    tx_context->pkt_type == PK_TYPE_11A)
 			return vnt_rxtx_rts_a_fb_head(tx_context,
-					&head->rts_a_fb, pkt_type, frame_size,
-					need_ack, current_rate);
+						      &head->rts_a_fb,
+						      frame_size, need_ack,
+						      current_rate);
 
 		return vnt_rxtx_rts_ab_head(tx_context, &head->rts_ab,
-				pkt_type, frame_size, need_ack, current_rate);
+					    frame_size, need_ack, current_rate);
 	}
 
-	if (pkt_type == PK_TYPE_11A)
-		return vnt_rxtx_datahead_a_fb(tx_context, pkt_type,
-			current_rate, &head->data_head_a_fb,
-				frame_size, need_ack);
+	if (tx_context->pkt_type == PK_TYPE_11A)
+		return vnt_rxtx_datahead_a_fb(tx_context, current_rate,
+					      &head->data_head_a_fb,
+					      frame_size, need_ack);
 
-	return vnt_rxtx_datahead_ab(tx_context, pkt_type, current_rate,
-				&head->data_head_ab, frame_size, need_ack);
+	return vnt_rxtx_datahead_ab(tx_context, current_rate,
+				    &head->data_head_ab, frame_size, need_ack);
 }
 
 static u16 vnt_generate_tx_parameter(struct vnt_usb_send_context *tx_context,
-	u8 pkt_type, u16 current_rate, struct vnt_tx_buffer *tx_buffer,
+	u16 current_rate, struct vnt_tx_buffer *tx_buffer,
 	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 frame_size,
 	int need_ack, bool need_rts)
 {
 
-	if (pkt_type == PK_TYPE_11GB || pkt_type == PK_TYPE_11GA) {
+	if (tx_context->pkt_type == PK_TYPE_11GB ||
+	    tx_context->pkt_type == PK_TYPE_11GA) {
 		if (need_rts) {
 			if (need_mic)
 				*mic_hdr = &tx_buffer->
 						tx_head.tx_rts.tx.mic.hdr;
 
 			return vnt_rxtx_rts(tx_context, &tx_buffer->tx_head,
-					pkt_type, frame_size, need_ack,
-						current_rate, need_mic);
+					    frame_size, need_ack, current_rate,
+					    need_mic);
 		}
 
 		if (need_mic)
 			*mic_hdr = &tx_buffer->tx_head.tx_cts.tx.mic.hdr;
 
-		return vnt_rxtx_cts(tx_context, &tx_buffer->tx_head, pkt_type,
-				frame_size, need_ack, current_rate, need_mic);
+		return vnt_rxtx_cts(tx_context, &tx_buffer->tx_head, frame_size,
+				    need_ack, current_rate, need_mic);
 	}
 
 	if (need_mic)
 		*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
 
-	return vnt_rxtx_ab(tx_context, &tx_buffer->tx_head, pkt_type,
-		frame_size, need_ack, current_rate, need_rts, need_mic);
+	return vnt_rxtx_ab(tx_context, &tx_buffer->tx_head, frame_size,
+			   need_ack, current_rate, need_rts, need_mic);
 }
 
 static void vnt_fill_txkey(struct vnt_usb_send_context *tx_context,
@@ -785,6 +792,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 	}
 
 	tx_context->skb = skb;
+	tx_context->pkt_type = pkt_type;
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -889,9 +897,9 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	tx_context->fb_option = fb_option;
 
-	duration_id = vnt_generate_tx_parameter(tx_context, pkt_type,
-			current_rate, tx_buffer, &mic_hdr, need_mic, frame_size,
-						need_ack, need_rts);
+	duration_id = vnt_generate_tx_parameter(tx_context, current_rate,
+						tx_buffer, &mic_hdr, need_mic,
+						frame_size, need_ack, need_rts);
 
 	tx_header_size = tx_context->tx_hdr_size;
 	if (!tx_header_size) {
-- 
2.0.1

