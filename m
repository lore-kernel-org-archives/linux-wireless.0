Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:42768 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbaGTOfA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:35:00 -0400
Received: by mail-we0-f171.google.com with SMTP id p10so6545752wes.16
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:59 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 22/25] staging: vt6656: move need_ack into into vnt_usb_send_context
Date: Sun, 20 Jul 2014 15:33:32 +0100
Message-Id: <1405866815-2687-22-git-send-email-tvboxspy@gmail.com> (sfid-20140720_165109_476630_3E8395E0)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixing need_ack to u8 and removing from function declarations.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h |  1 +
 drivers/staging/vt6656/rxtx.c   | 89 +++++++++++++++++++++++------------------
 2 files changed, 52 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 0d5ecd6..9d42877 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -236,6 +236,7 @@ struct vnt_usb_send_context {
 	u8 type;
 	u8 pkt_no;
 	u8 pkt_type;
+	u8 need_ack;
 	u8 fb_option;
 	bool in_use;
 	unsigned char data[MAX_TOTAL_SIZE_WITH_ALL_HEADERS];
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 7906251..81086ab 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -255,12 +255,13 @@ static u16 vnt_mac_hdr_pos(struct vnt_usb_send_context *tx_context,
 
 static u16 vnt_rxtx_datahead_g(struct vnt_usb_send_context *tx_context,
 		u16 rate, struct vnt_tx_datahead_g *buf,
-		u32 frame_len, int need_ack)
+		u32 frame_len)
 {
 
 	struct vnt_private *priv = tx_context->priv;
 	struct ieee80211_hdr *hdr =
 				(struct ieee80211_hdr *)tx_context->skb->data;
+	u8 need_ack = tx_context->need_ack;
 
 	/* Get SignalField,ServiceField,Length */
 	vnt_get_phy_field(priv, frame_len, rate, tx_context->pkt_type, &buf->a);
@@ -291,9 +292,10 @@ static u16 vnt_rxtx_datahead_g(struct vnt_usb_send_context *tx_context,
 
 static u16 vnt_rxtx_datahead_g_fb(struct vnt_usb_send_context *tx_context,
 		u16 rate, struct vnt_tx_datahead_g_fb *buf,
-		u32 frame_len, int need_ack)
+		u32 frame_len)
 {
 	struct vnt_private *priv = tx_context->priv;
+	u8 need_ack = tx_context->need_ack;
 
 	/* Get SignalField,ServiceField,Length */
 	vnt_get_phy_field(priv, frame_len, rate, tx_context->pkt_type, &buf->a);
@@ -322,10 +324,11 @@ static u16 vnt_rxtx_datahead_g_fb(struct vnt_usb_send_context *tx_context,
 
 static u16 vnt_rxtx_datahead_a_fb(struct vnt_usb_send_context *tx_context,
 		u16 rate, struct vnt_tx_datahead_a_fb *buf,
-		u32 frame_len, int need_ack)
+		u32 frame_len)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u8 pkt_type = tx_context->pkt_type;
+	u8 need_ack = tx_context->need_ack;
 
 	/* Get SignalField,ServiceField,Length */
 	vnt_get_phy_field(priv, frame_len, rate, pkt_type, &buf->a);
@@ -344,11 +347,12 @@ static u16 vnt_rxtx_datahead_a_fb(struct vnt_usb_send_context *tx_context,
 
 static u16 vnt_rxtx_datahead_ab(struct vnt_usb_send_context *tx_context,
 		u16 rate, struct vnt_tx_datahead_ab *buf,
-		u32 frame_len, int need_ack)
+		u32 frame_len)
 {
 	struct vnt_private *priv = tx_context->priv;
 	struct ieee80211_hdr *hdr =
 				(struct ieee80211_hdr *)tx_context->skb->data;
+	u8 need_ack = tx_context->need_ack;
 
 	/* Get SignalField,ServiceField,Length */
 	vnt_get_phy_field(priv, frame_len, rate,
@@ -388,10 +392,12 @@ static int vnt_fill_ieee80211_rts(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_rts_g_head(struct vnt_usb_send_context *tx_context,
-	struct vnt_rts_g *buf, u32 frame_len, int need_ack, u16 current_rate)
+	struct vnt_rts_g *buf, u32 frame_len, u16 current_rate)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
+	u8 need_ack = tx_context->need_ack;
+
 
 	vnt_get_phy_field(priv, rts_frame_len, priv->top_cck_basic_rate,
 		PK_TYPE_11B, &buf->b);
@@ -408,14 +414,16 @@ static u16 vnt_rxtx_rts_g_head(struct vnt_usb_send_context *tx_context,
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration_aa);
 
 	return vnt_rxtx_datahead_g(tx_context, current_rate, &buf->data_head,
-				   frame_len, need_ack);
+				   frame_len);
 }
 
 static u16 vnt_rxtx_rts_g_fb_head(struct vnt_usb_send_context *tx_context,
-	struct vnt_rts_g_fb *buf, u32 frame_len, int need_ack, u16 current_rate)
+	struct vnt_rts_g_fb *buf, u32 frame_len, u16 current_rate)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
+	u8 need_ack = tx_context->need_ack;
+
 
 	vnt_get_phy_field(priv, rts_frame_len, priv->top_cck_basic_rate,
 		PK_TYPE_11B, &buf->b);
@@ -441,15 +449,16 @@ static u16 vnt_rxtx_rts_g_fb_head(struct vnt_usb_send_context *tx_context,
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration_aa);
 
 	return vnt_rxtx_datahead_g_fb(tx_context, current_rate, &buf->data_head,
-				      frame_len, need_ack);
+				      frame_len);
 }
 
 static u16 vnt_rxtx_rts_ab_head(struct vnt_usb_send_context *tx_context,
-	struct vnt_rts_ab *buf, u32 frame_len, int need_ack,
-	u16 current_rate)
+	struct vnt_rts_ab *buf, u32 frame_len, u16 current_rate)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
+	u8 need_ack = tx_context->need_ack;
+
 
 	vnt_get_phy_field(priv, rts_frame_len, priv->top_ofdm_basic_rate,
 			  tx_context->pkt_type, &buf->ab);
@@ -461,14 +470,16 @@ static u16 vnt_rxtx_rts_ab_head(struct vnt_usb_send_context *tx_context,
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration);
 
 	return vnt_rxtx_datahead_ab(tx_context, current_rate,
-				    &buf->data_head, frame_len, need_ack);
+				    &buf->data_head, frame_len);
 }
 
 static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
-	struct vnt_rts_a_fb *buf, u32 frame_len, int need_ack, u16 current_rate)
+	struct vnt_rts_a_fb *buf, u32 frame_len, u16 current_rate)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
+	u8 need_ack = tx_context->need_ack;
+
 
 	vnt_get_phy_field(priv, rts_frame_len,
 		priv->top_ofdm_basic_rate, tx_context->pkt_type, &buf->a);
@@ -486,15 +497,16 @@ static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration);
 
 	return vnt_rxtx_datahead_a_fb(tx_context, current_rate, &buf->data_head,
-				      frame_len, need_ack);
+				      frame_len);
 }
 
 static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
-	union vnt_tx_data_head *head, u32 frame_len,
-	int need_ack, u16 current_rate)
+	union vnt_tx_data_head *head, u32 frame_len, u16 current_rate)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u32 cts_frame_len = 14;
+	u8 need_ack = tx_context->need_ack;
+
 
 	if (!head)
 		return 0;
@@ -524,8 +536,7 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
 
 		return vnt_rxtx_datahead_g_fb(tx_context, current_rate,
-					      &buf->data_head, frame_len,
-					      need_ack);
+					      &buf->data_head, frame_len);
 	} else {
 		struct vnt_cts *buf = &head->cts_g;
 		/* Get SignalField,ServiceField,Length */
@@ -543,19 +554,20 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
 
 		return vnt_rxtx_datahead_g(tx_context, current_rate,
-				&buf->data_head, frame_len, need_ack);
+					   &buf->data_head, frame_len);
         }
 
 	return 0;
 }
 
 static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
-	union vnt_tx_head *tx_head, u32 frame_size, int need_ack,
+	union vnt_tx_head *tx_head, u32 frame_size,
 	u16 current_rate, bool need_mic)
 {
 	struct vnt_private *priv = tx_context->priv;
 	struct vnt_rrv_time_rts *buf = &tx_head->tx_rts.rts;
 	union vnt_tx_data_head *head = &tx_head->tx_rts.tx.head;
+	u8 need_ack = tx_context->need_ack;
 
 	buf->rts_rrv_time_aa = vnt_get_rtscts_rsvtime_le(priv, 2,
 			tx_context->pkt_type, frame_size, current_rate);
@@ -575,19 +587,21 @@ static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
 
 	if (tx_context->fb_option)
 		return vnt_rxtx_rts_g_fb_head(tx_context, &head->rts_g_fb,
-					frame_size, need_ack, current_rate);
+					frame_size, current_rate);
 
 	return vnt_rxtx_rts_g_head(tx_context, &head->rts_g, frame_size,
-				   need_ack, current_rate);
+				   current_rate);
 }
 
 static u16 vnt_rxtx_cts(struct vnt_usb_send_context *tx_context,
-	union vnt_tx_head *tx_head, u32 frame_size, int need_ack,
+	union vnt_tx_head *tx_head, u32 frame_size,
 	u16 current_rate, bool need_mic)
 {
 	struct vnt_private *priv = tx_context->priv;
 	struct vnt_rrv_time_cts *buf = &tx_head->tx_cts.cts;
 	union vnt_tx_data_head *head = &tx_head->tx_cts.tx.head;
+	u8 need_ack = tx_context->need_ack;
+
 
 	buf->rrv_time_a = vnt_rxtx_rsvtime_le16(priv, tx_context->pkt_type,
 					frame_size, current_rate, need_ack);
@@ -601,17 +615,17 @@ static u16 vnt_rxtx_cts(struct vnt_usb_send_context *tx_context,
 		head = &tx_head->tx_cts.tx.mic.head;
 
 	/* Fill CTS */
-	return vnt_fill_cts_head(tx_context,
-				 head, frame_size, need_ack, current_rate);
+	return vnt_fill_cts_head(tx_context, head, frame_size, current_rate);
 }
 
 static u16 vnt_rxtx_ab(struct vnt_usb_send_context *tx_context,
 	union vnt_tx_head *tx_head, u32 frame_size,
-	int need_ack, u16 current_rate, bool need_rts, bool need_mic)
+	u16 current_rate, bool need_rts, bool need_mic)
 {
 	struct vnt_private *priv = tx_context->priv;
 	struct vnt_rrv_time_ab *buf = &tx_head->tx_ab.ab;
 	union vnt_tx_data_head *head = &tx_head->tx_ab.tx.head;
+	u8 need_ack = tx_context->need_ack;
 
 	buf->rrv_time = vnt_rxtx_rsvtime_le16(priv, tx_context->pkt_type,
 			frame_size, current_rate, need_ack);
@@ -631,26 +645,25 @@ static u16 vnt_rxtx_ab(struct vnt_usb_send_context *tx_context,
 		    tx_context->pkt_type == PK_TYPE_11A)
 			return vnt_rxtx_rts_a_fb_head(tx_context,
 						      &head->rts_a_fb,
-						      frame_size, need_ack,
-						      current_rate);
+						      frame_size, current_rate);
 
 		return vnt_rxtx_rts_ab_head(tx_context, &head->rts_ab,
-					    frame_size, need_ack, current_rate);
+					    frame_size, current_rate);
 	}
 
 	if (tx_context->pkt_type == PK_TYPE_11A)
 		return vnt_rxtx_datahead_a_fb(tx_context, current_rate,
 					      &head->data_head_a_fb,
-					      frame_size, need_ack);
+					      frame_size);
 
 	return vnt_rxtx_datahead_ab(tx_context, current_rate,
-				    &head->data_head_ab, frame_size, need_ack);
+				    &head->data_head_ab, frame_size);
 }
 
 static u16 vnt_generate_tx_parameter(struct vnt_usb_send_context *tx_context,
 	u16 current_rate, struct vnt_tx_buffer *tx_buffer,
 	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 frame_size,
-	int need_ack, bool need_rts)
+	bool need_rts)
 {
 
 	if (tx_context->pkt_type == PK_TYPE_11GB ||
@@ -661,22 +674,21 @@ static u16 vnt_generate_tx_parameter(struct vnt_usb_send_context *tx_context,
 						tx_head.tx_rts.tx.mic.hdr;
 
 			return vnt_rxtx_rts(tx_context, &tx_buffer->tx_head,
-					    frame_size, need_ack, current_rate,
-					    need_mic);
+					    frame_size, current_rate, need_mic);
 		}
 
 		if (need_mic)
 			*mic_hdr = &tx_buffer->tx_head.tx_cts.tx.mic.hdr;
 
 		return vnt_rxtx_cts(tx_context, &tx_buffer->tx_head, frame_size,
-				    need_ack, current_rate, need_mic);
+				    current_rate, need_mic);
 	}
 
 	if (need_mic)
 		*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
 
 	return vnt_rxtx_ab(tx_context, &tx_buffer->tx_head, frame_size,
-			   need_ack, current_rate, need_rts, need_mic);
+			   current_rate, need_rts, need_mic);
 }
 
 static void vnt_fill_txkey(struct vnt_usb_send_context *tx_context,
@@ -763,7 +775,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 	u32 frame_size = 0;
 	u16 tx_bytes, tx_header_size, tx_body_size, current_rate, duration_id;
 	u8 pkt_type, fb_option = AUTO_FB_NONE;
-	bool need_rts = false, need_ack = false, is_pspoll = false;
+	bool need_rts = false, is_pspoll = false;
 	bool need_mic = false;
 
 	hdr = (struct ieee80211_hdr *)(skb->data);
@@ -793,6 +805,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	tx_context->skb = skb;
 	tx_context->pkt_type = pkt_type;
+	tx_context->need_ack = false;
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -826,7 +839,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
 		tx_buffer_head->wFIFOCtl |= FIFOCTL_NEEDACK;
-		need_ack = true;
+		tx_context->need_ack = true;
 	}
 
 	if (ieee80211_has_retry(hdr->frame_control))
@@ -899,7 +912,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	duration_id = vnt_generate_tx_parameter(tx_context, current_rate,
 						tx_buffer, &mic_hdr, need_mic,
-						frame_size, need_ack, need_rts);
+						frame_size, need_rts);
 
 	tx_header_size = tx_context->tx_hdr_size;
 	if (!tx_header_size) {
-- 
2.0.1

