Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:46844 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbaGTOfC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:35:02 -0400
Received: by mail-wi0-f177.google.com with SMTP id ho1so2843706wib.4
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:35:00 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 23/25] staging: vt6656: rxtx move frame_len/size into vnt_usb_send_context as frame_len
Date: Sun, 20 Jul 2014 15:33:33 +0100
Message-Id: <1405866815-2687-23-git-send-email-tvboxspy@gmail.com> (sfid-20140720_165108_234089_997AAFF7)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing frame_len and frame_size from function declarations

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h |   1 +
 drivers/staging/vt6656/rxtx.c   | 115 ++++++++++++++++++++--------------------
 2 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 9d42877..d3c36af 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -232,6 +232,7 @@ struct vnt_usb_send_context {
 	struct urb *urb;
 	struct ieee80211_hdr *hdr;
 	unsigned int buf_len;
+	u32 frame_len;
 	u16 tx_hdr_size;
 	u8 type;
 	u8 pkt_no;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 81086ab..163bb1a 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -254,13 +254,13 @@ static u16 vnt_mac_hdr_pos(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_datahead_g(struct vnt_usb_send_context *tx_context,
-		u16 rate, struct vnt_tx_datahead_g *buf,
-		u32 frame_len)
+		u16 rate, struct vnt_tx_datahead_g *buf)
 {
 
 	struct vnt_private *priv = tx_context->priv;
 	struct ieee80211_hdr *hdr =
 				(struct ieee80211_hdr *)tx_context->skb->data;
+	u32 frame_len = tx_context->frame_len;
 	u8 need_ack = tx_context->need_ack;
 
 	/* Get SignalField,ServiceField,Length */
@@ -291,10 +291,10 @@ static u16 vnt_rxtx_datahead_g(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_datahead_g_fb(struct vnt_usb_send_context *tx_context,
-		u16 rate, struct vnt_tx_datahead_g_fb *buf,
-		u32 frame_len)
+		u16 rate, struct vnt_tx_datahead_g_fb *buf)
 {
 	struct vnt_private *priv = tx_context->priv;
+	u32 frame_len = tx_context->frame_len;
 	u8 need_ack = tx_context->need_ack;
 
 	/* Get SignalField,ServiceField,Length */
@@ -323,12 +323,12 @@ static u16 vnt_rxtx_datahead_g_fb(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_datahead_a_fb(struct vnt_usb_send_context *tx_context,
-		u16 rate, struct vnt_tx_datahead_a_fb *buf,
-		u32 frame_len)
+		u16 rate, struct vnt_tx_datahead_a_fb *buf)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u8 pkt_type = tx_context->pkt_type;
 	u8 need_ack = tx_context->need_ack;
+	u32 frame_len = tx_context->frame_len;
 
 	/* Get SignalField,ServiceField,Length */
 	vnt_get_phy_field(priv, frame_len, rate, pkt_type, &buf->a);
@@ -346,12 +346,12 @@ static u16 vnt_rxtx_datahead_a_fb(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_datahead_ab(struct vnt_usb_send_context *tx_context,
-		u16 rate, struct vnt_tx_datahead_ab *buf,
-		u32 frame_len)
+		u16 rate, struct vnt_tx_datahead_ab *buf)
 {
 	struct vnt_private *priv = tx_context->priv;
 	struct ieee80211_hdr *hdr =
 				(struct ieee80211_hdr *)tx_context->skb->data;
+	u32 frame_len = tx_context->frame_len;
 	u8 need_ack = tx_context->need_ack;
 
 	/* Get SignalField,ServiceField,Length */
@@ -392,13 +392,13 @@ static int vnt_fill_ieee80211_rts(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_rts_g_head(struct vnt_usb_send_context *tx_context,
-	struct vnt_rts_g *buf, u32 frame_len, u16 current_rate)
+	struct vnt_rts_g *buf, u16 current_rate)
 {
 	struct vnt_private *priv = tx_context->priv;
+	u32 frame_len = tx_context->frame_len;
 	u16 rts_frame_len = 20;
 	u8 need_ack = tx_context->need_ack;
 
-
 	vnt_get_phy_field(priv, rts_frame_len, priv->top_cck_basic_rate,
 		PK_TYPE_11B, &buf->b);
 	vnt_get_phy_field(priv, rts_frame_len, priv->top_ofdm_basic_rate,
@@ -413,14 +413,14 @@ static u16 vnt_rxtx_rts_g_head(struct vnt_usb_send_context *tx_context,
 
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration_aa);
 
-	return vnt_rxtx_datahead_g(tx_context, current_rate, &buf->data_head,
-				   frame_len);
+	return vnt_rxtx_datahead_g(tx_context, current_rate, &buf->data_head);
 }
 
 static u16 vnt_rxtx_rts_g_fb_head(struct vnt_usb_send_context *tx_context,
-	struct vnt_rts_g_fb *buf, u32 frame_len, u16 current_rate)
+	struct vnt_rts_g_fb *buf, u16 current_rate)
 {
 	struct vnt_private *priv = tx_context->priv;
+	u32 frame_len = tx_context->frame_len;
 	u16 rts_frame_len = 20;
 	u8 need_ack = tx_context->need_ack;
 
@@ -448,14 +448,15 @@ static u16 vnt_rxtx_rts_g_fb_head(struct vnt_usb_send_context *tx_context,
 
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration_aa);
 
-	return vnt_rxtx_datahead_g_fb(tx_context, current_rate, &buf->data_head,
-				      frame_len);
+	return vnt_rxtx_datahead_g_fb(tx_context,
+				      current_rate, &buf->data_head);
 }
 
 static u16 vnt_rxtx_rts_ab_head(struct vnt_usb_send_context *tx_context,
-	struct vnt_rts_ab *buf, u32 frame_len, u16 current_rate)
+	struct vnt_rts_ab *buf, u16 current_rate)
 {
 	struct vnt_private *priv = tx_context->priv;
+	u32 frame_len = tx_context->frame_len;
 	u16 rts_frame_len = 20;
 	u8 need_ack = tx_context->need_ack;
 
@@ -470,13 +471,14 @@ static u16 vnt_rxtx_rts_ab_head(struct vnt_usb_send_context *tx_context,
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration);
 
 	return vnt_rxtx_datahead_ab(tx_context, current_rate,
-				    &buf->data_head, frame_len);
+				    &buf->data_head);
 }
 
 static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
-	struct vnt_rts_a_fb *buf, u32 frame_len, u16 current_rate)
+	struct vnt_rts_a_fb *buf, u16 current_rate)
 {
 	struct vnt_private *priv = tx_context->priv;
+	u32 frame_len = tx_context->frame_len;
 	u16 rts_frame_len = 20;
 	u8 need_ack = tx_context->need_ack;
 
@@ -496,18 +498,18 @@ static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
 
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration);
 
-	return vnt_rxtx_datahead_a_fb(tx_context, current_rate, &buf->data_head,
-				      frame_len);
+	return vnt_rxtx_datahead_a_fb(tx_context,
+				      current_rate, &buf->data_head);
 }
 
 static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
-	union vnt_tx_data_head *head, u32 frame_len, u16 current_rate)
+	union vnt_tx_data_head *head, u16 current_rate)
 {
 	struct vnt_private *priv = tx_context->priv;
+	u32 frame_len = tx_context->frame_len;
 	u32 cts_frame_len = 14;
 	u8 need_ack = tx_context->need_ack;
 
-
 	if (!head)
 		return 0;
 
@@ -536,7 +538,7 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
 
 		return vnt_rxtx_datahead_g_fb(tx_context, current_rate,
-					      &buf->data_head, frame_len);
+					      &buf->data_head);
 	} else {
 		struct vnt_cts *buf = &head->cts_g;
 		/* Get SignalField,ServiceField,Length */
@@ -554,32 +556,33 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
 
 		return vnt_rxtx_datahead_g(tx_context, current_rate,
-					   &buf->data_head, frame_len);
+					   &buf->data_head);
         }
 
 	return 0;
 }
 
 static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
-	union vnt_tx_head *tx_head, u32 frame_size,
+	union vnt_tx_head *tx_head,
 	u16 current_rate, bool need_mic)
 {
 	struct vnt_private *priv = tx_context->priv;
 	struct vnt_rrv_time_rts *buf = &tx_head->tx_rts.rts;
 	union vnt_tx_data_head *head = &tx_head->tx_rts.tx.head;
+	u32 frame_len = tx_context->frame_len;
 	u8 need_ack = tx_context->need_ack;
 
 	buf->rts_rrv_time_aa = vnt_get_rtscts_rsvtime_le(priv, 2,
-			tx_context->pkt_type, frame_size, current_rate);
+			tx_context->pkt_type, frame_len, current_rate);
 	buf->rts_rrv_time_ba = vnt_get_rtscts_rsvtime_le(priv, 1,
-			tx_context->pkt_type, frame_size, current_rate);
+			tx_context->pkt_type, frame_len, current_rate);
 	buf->rts_rrv_time_bb = vnt_get_rtscts_rsvtime_le(priv, 0,
-			tx_context->pkt_type, frame_size, current_rate);
+			tx_context->pkt_type, frame_len, current_rate);
 
 	buf->rrv_time_a = vnt_rxtx_rsvtime_le16(priv, tx_context->pkt_type,
-						frame_size, current_rate,
+						frame_len, current_rate,
 						need_ack);
-	buf->rrv_time_b = vnt_rxtx_rsvtime_le16(priv, PK_TYPE_11B, frame_size,
+	buf->rrv_time_b = vnt_rxtx_rsvtime_le16(priv, PK_TYPE_11B, frame_len,
 					priv->top_cck_basic_rate, need_ack);
 
 	if (need_mic)
@@ -587,48 +590,47 @@ static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
 
 	if (tx_context->fb_option)
 		return vnt_rxtx_rts_g_fb_head(tx_context, &head->rts_g_fb,
-					frame_size, current_rate);
+					      current_rate);
 
-	return vnt_rxtx_rts_g_head(tx_context, &head->rts_g, frame_size,
-				   current_rate);
+	return vnt_rxtx_rts_g_head(tx_context, &head->rts_g, current_rate);
 }
 
 static u16 vnt_rxtx_cts(struct vnt_usb_send_context *tx_context,
-	union vnt_tx_head *tx_head, u32 frame_size,
-	u16 current_rate, bool need_mic)
+	union vnt_tx_head *tx_head, u16 current_rate, bool need_mic)
 {
 	struct vnt_private *priv = tx_context->priv;
 	struct vnt_rrv_time_cts *buf = &tx_head->tx_cts.cts;
 	union vnt_tx_data_head *head = &tx_head->tx_cts.tx.head;
+	u32 frame_len = tx_context->frame_len;
 	u8 need_ack = tx_context->need_ack;
 
-
 	buf->rrv_time_a = vnt_rxtx_rsvtime_le16(priv, tx_context->pkt_type,
-					frame_size, current_rate, need_ack);
+					frame_len, current_rate, need_ack);
 	buf->rrv_time_b = vnt_rxtx_rsvtime_le16(priv, PK_TYPE_11B,
-				frame_size, priv->top_cck_basic_rate, need_ack);
+				frame_len, priv->top_cck_basic_rate, need_ack);
 
 	buf->cts_rrv_time_ba = vnt_get_rtscts_rsvtime_le(priv, 3,
-			tx_context->pkt_type, frame_size, current_rate);
+			tx_context->pkt_type, frame_len, current_rate);
 
 	if (need_mic)
 		head = &tx_head->tx_cts.tx.mic.head;
 
 	/* Fill CTS */
-	return vnt_fill_cts_head(tx_context, head, frame_size, current_rate);
+	return vnt_fill_cts_head(tx_context, head, current_rate);
 }
 
 static u16 vnt_rxtx_ab(struct vnt_usb_send_context *tx_context,
-	union vnt_tx_head *tx_head, u32 frame_size,
+	union vnt_tx_head *tx_head,
 	u16 current_rate, bool need_rts, bool need_mic)
 {
 	struct vnt_private *priv = tx_context->priv;
 	struct vnt_rrv_time_ab *buf = &tx_head->tx_ab.ab;
 	union vnt_tx_data_head *head = &tx_head->tx_ab.tx.head;
+	u32 frame_len = tx_context->frame_len;
 	u8 need_ack = tx_context->need_ack;
 
 	buf->rrv_time = vnt_rxtx_rsvtime_le16(priv, tx_context->pkt_type,
-			frame_size, current_rate, need_ack);
+			frame_len, current_rate, need_ack);
 
 	if (need_mic)
 		head = &tx_head->tx_ab.tx.mic.head;
@@ -636,33 +638,32 @@ static u16 vnt_rxtx_ab(struct vnt_usb_send_context *tx_context,
 	if (need_rts) {
 		if (tx_context->pkt_type == PK_TYPE_11B)
 			buf->rts_rrv_time = vnt_get_rtscts_rsvtime_le(priv, 0,
-				tx_context->pkt_type, frame_size, current_rate);
+				tx_context->pkt_type, frame_len, current_rate);
 		else /* PK_TYPE_11A */
 			buf->rts_rrv_time = vnt_get_rtscts_rsvtime_le(priv, 2,
-				tx_context->pkt_type, frame_size, current_rate);
+				tx_context->pkt_type, frame_len, current_rate);
 
 		if (tx_context->fb_option &&
 		    tx_context->pkt_type == PK_TYPE_11A)
 			return vnt_rxtx_rts_a_fb_head(tx_context,
 						      &head->rts_a_fb,
-						      frame_size, current_rate);
+						      current_rate);
 
 		return vnt_rxtx_rts_ab_head(tx_context, &head->rts_ab,
-					    frame_size, current_rate);
+					    current_rate);
 	}
 
 	if (tx_context->pkt_type == PK_TYPE_11A)
 		return vnt_rxtx_datahead_a_fb(tx_context, current_rate,
-					      &head->data_head_a_fb,
-					      frame_size);
+					      &head->data_head_a_fb);
 
 	return vnt_rxtx_datahead_ab(tx_context, current_rate,
-				    &head->data_head_ab, frame_size);
+				    &head->data_head_ab);
 }
 
 static u16 vnt_generate_tx_parameter(struct vnt_usb_send_context *tx_context,
 	u16 current_rate, struct vnt_tx_buffer *tx_buffer,
-	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 frame_size,
+	struct vnt_mic_hdr **mic_hdr, u32 need_mic,
 	bool need_rts)
 {
 
@@ -674,20 +675,20 @@ static u16 vnt_generate_tx_parameter(struct vnt_usb_send_context *tx_context,
 						tx_head.tx_rts.tx.mic.hdr;
 
 			return vnt_rxtx_rts(tx_context, &tx_buffer->tx_head,
-					    frame_size, current_rate, need_mic);
+					    current_rate, need_mic);
 		}
 
 		if (need_mic)
 			*mic_hdr = &tx_buffer->tx_head.tx_cts.tx.mic.hdr;
 
-		return vnt_rxtx_cts(tx_context, &tx_buffer->tx_head, frame_size,
+		return vnt_rxtx_cts(tx_context, &tx_buffer->tx_head,
 				    current_rate, need_mic);
 	}
 
 	if (need_mic)
 		*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
 
-	return vnt_rxtx_ab(tx_context, &tx_buffer->tx_head, frame_size,
+	return vnt_rxtx_ab(tx_context, &tx_buffer->tx_head,
 			   current_rate, need_rts, need_mic);
 }
 
@@ -772,7 +773,6 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 	struct vnt_tx_fifo_head *tx_buffer_head;
 	struct vnt_usb_send_context *tx_context;
 	unsigned long flags;
-	u32 frame_size = 0;
 	u16 tx_bytes, tx_header_size, tx_body_size, current_rate, duration_id;
 	u8 pkt_type, fb_option = AUTO_FB_NONE;
 	bool need_rts = false, is_pspoll = false;
@@ -806,6 +806,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 	tx_context->skb = skb;
 	tx_context->pkt_type = pkt_type;
 	tx_context->need_ack = false;
+	tx_context->frame_len = skb->len + 4;
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -813,8 +814,6 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 	tx_buffer_head = &tx_buffer->fifo_head;
 	tx_body_size = skb->len;
 
-	frame_size = tx_body_size + 4;
-
 	/*Set fifo controls */
 	if (pkt_type == PK_TYPE_11A)
 		tx_buffer_head->wFIFOCtl = 0;
@@ -880,7 +879,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 		default:
 			break;
 		}
-		frame_size += tx_key->icv_len;
+		tx_context->frame_len += tx_key->icv_len;
 	}
 
 	tx_buffer_head->current_rate = cpu_to_le16(current_rate);
@@ -912,7 +911,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	duration_id = vnt_generate_tx_parameter(tx_context, current_rate,
 						tx_buffer, &mic_hdr, need_mic,
-						frame_size, need_rts);
+						need_rts);
 
 	tx_header_size = tx_context->tx_hdr_size;
 	if (!tx_header_size) {
-- 
2.0.1

