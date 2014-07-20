Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:57568 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbaGTOfD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:35:03 -0400
Received: by mail-we0-f173.google.com with SMTP id q58so6571775wes.4
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:35:02 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 24/25] staging; vt6656: rxtx add current_rate into vnt_usb_send_context as tx_rate
Date: Sun, 20 Jul 2014 15:33:34 +0100
Message-Id: <1405866815-2687-24-git-send-email-tvboxspy@gmail.com> (sfid-20140720_165108_903695_CE8D7F9E)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create u8 tx_rate and remove current_rate from function declarations

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h |  1 +
 drivers/staging/vt6656/rxtx.c   | 91 ++++++++++++++++++++---------------------
 2 files changed, 45 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index d3c36af..6b7bb8c 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -234,6 +234,7 @@ struct vnt_usb_send_context {
 	unsigned int buf_len;
 	u32 frame_len;
 	u16 tx_hdr_size;
+	u16 tx_rate;
 	u8 type;
 	u8 pkt_no;
 	u8 pkt_type;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 163bb1a..7c92d1b 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -254,13 +254,14 @@ static u16 vnt_mac_hdr_pos(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_datahead_g(struct vnt_usb_send_context *tx_context,
-		u16 rate, struct vnt_tx_datahead_g *buf)
+			       struct vnt_tx_datahead_g *buf)
 {
 
 	struct vnt_private *priv = tx_context->priv;
 	struct ieee80211_hdr *hdr =
 				(struct ieee80211_hdr *)tx_context->skb->data;
 	u32 frame_len = tx_context->frame_len;
+	u16 rate = tx_context->tx_rate;
 	u8 need_ack = tx_context->need_ack;
 
 	/* Get SignalField,ServiceField,Length */
@@ -291,10 +292,11 @@ static u16 vnt_rxtx_datahead_g(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_datahead_g_fb(struct vnt_usb_send_context *tx_context,
-		u16 rate, struct vnt_tx_datahead_g_fb *buf)
+				  struct vnt_tx_datahead_g_fb *buf)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u32 frame_len = tx_context->frame_len;
+	u16 rate = tx_context->tx_rate;
 	u8 need_ack = tx_context->need_ack;
 
 	/* Get SignalField,ServiceField,Length */
@@ -323,9 +325,10 @@ static u16 vnt_rxtx_datahead_g_fb(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_datahead_a_fb(struct vnt_usb_send_context *tx_context,
-		u16 rate, struct vnt_tx_datahead_a_fb *buf)
+				  struct vnt_tx_datahead_a_fb *buf)
 {
 	struct vnt_private *priv = tx_context->priv;
+	u16 rate = tx_context->tx_rate;
 	u8 pkt_type = tx_context->pkt_type;
 	u8 need_ack = tx_context->need_ack;
 	u32 frame_len = tx_context->frame_len;
@@ -346,12 +349,13 @@ static u16 vnt_rxtx_datahead_a_fb(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_datahead_ab(struct vnt_usb_send_context *tx_context,
-		u16 rate, struct vnt_tx_datahead_ab *buf)
+				struct vnt_tx_datahead_ab *buf)
 {
 	struct vnt_private *priv = tx_context->priv;
 	struct ieee80211_hdr *hdr =
 				(struct ieee80211_hdr *)tx_context->skb->data;
 	u32 frame_len = tx_context->frame_len;
+	u16 rate = tx_context->tx_rate;
 	u8 need_ack = tx_context->need_ack;
 
 	/* Get SignalField,ServiceField,Length */
@@ -392,11 +396,12 @@ static int vnt_fill_ieee80211_rts(struct vnt_usb_send_context *tx_context,
 }
 
 static u16 vnt_rxtx_rts_g_head(struct vnt_usb_send_context *tx_context,
-	struct vnt_rts_g *buf, u16 current_rate)
+			       struct vnt_rts_g *buf)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u32 frame_len = tx_context->frame_len;
 	u16 rts_frame_len = 20;
+	u16 current_rate = tx_context->tx_rate;
 	u8 need_ack = tx_context->need_ack;
 
 	vnt_get_phy_field(priv, rts_frame_len, priv->top_cck_basic_rate,
@@ -413,18 +418,18 @@ static u16 vnt_rxtx_rts_g_head(struct vnt_usb_send_context *tx_context,
 
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration_aa);
 
-	return vnt_rxtx_datahead_g(tx_context, current_rate, &buf->data_head);
+	return vnt_rxtx_datahead_g(tx_context, &buf->data_head);
 }
 
 static u16 vnt_rxtx_rts_g_fb_head(struct vnt_usb_send_context *tx_context,
-	struct vnt_rts_g_fb *buf, u16 current_rate)
+				  struct vnt_rts_g_fb *buf)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u32 frame_len = tx_context->frame_len;
+	u16 current_rate = tx_context->tx_rate;
 	u16 rts_frame_len = 20;
 	u8 need_ack = tx_context->need_ack;
 
-
 	vnt_get_phy_field(priv, rts_frame_len, priv->top_cck_basic_rate,
 		PK_TYPE_11B, &buf->b);
 	vnt_get_phy_field(priv, rts_frame_len, priv->top_ofdm_basic_rate,
@@ -448,15 +453,15 @@ static u16 vnt_rxtx_rts_g_fb_head(struct vnt_usb_send_context *tx_context,
 
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration_aa);
 
-	return vnt_rxtx_datahead_g_fb(tx_context,
-				      current_rate, &buf->data_head);
+	return vnt_rxtx_datahead_g_fb(tx_context, &buf->data_head);
 }
 
 static u16 vnt_rxtx_rts_ab_head(struct vnt_usb_send_context *tx_context,
-	struct vnt_rts_ab *buf, u16 current_rate)
+				struct vnt_rts_ab *buf)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u32 frame_len = tx_context->frame_len;
+	u16 current_rate = tx_context->tx_rate;
 	u16 rts_frame_len = 20;
 	u8 need_ack = tx_context->need_ack;
 
@@ -470,19 +475,18 @@ static u16 vnt_rxtx_rts_ab_head(struct vnt_usb_send_context *tx_context,
 
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration);
 
-	return vnt_rxtx_datahead_ab(tx_context, current_rate,
-				    &buf->data_head);
+	return vnt_rxtx_datahead_ab(tx_context, &buf->data_head);
 }
 
 static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
-	struct vnt_rts_a_fb *buf, u16 current_rate)
+				  struct vnt_rts_a_fb *buf)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u32 frame_len = tx_context->frame_len;
+	u16 current_rate = tx_context->tx_rate;
 	u16 rts_frame_len = 20;
 	u8 need_ack = tx_context->need_ack;
 
-
 	vnt_get_phy_field(priv, rts_frame_len,
 		priv->top_ofdm_basic_rate, tx_context->pkt_type, &buf->a);
 
@@ -498,16 +502,16 @@ static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
 
 	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration);
 
-	return vnt_rxtx_datahead_a_fb(tx_context,
-				      current_rate, &buf->data_head);
+	return vnt_rxtx_datahead_a_fb(tx_context, &buf->data_head);
 }
 
 static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
-	union vnt_tx_data_head *head, u16 current_rate)
+	union vnt_tx_data_head *head)
 {
 	struct vnt_private *priv = tx_context->priv;
 	u32 frame_len = tx_context->frame_len;
 	u32 cts_frame_len = 14;
+	u16 current_rate = tx_context->tx_rate;
 	u8 need_ack = tx_context->need_ack;
 
 	if (!head)
@@ -537,8 +541,7 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 
 		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
 
-		return vnt_rxtx_datahead_g_fb(tx_context, current_rate,
-					      &buf->data_head);
+		return vnt_rxtx_datahead_g_fb(tx_context, &buf->data_head);
 	} else {
 		struct vnt_cts *buf = &head->cts_g;
 		/* Get SignalField,ServiceField,Length */
@@ -555,21 +558,20 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 
 		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
 
-		return vnt_rxtx_datahead_g(tx_context, current_rate,
-					   &buf->data_head);
+		return vnt_rxtx_datahead_g(tx_context, &buf->data_head);
         }
 
 	return 0;
 }
 
 static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
-	union vnt_tx_head *tx_head,
-	u16 current_rate, bool need_mic)
+			union vnt_tx_head *tx_head, bool need_mic)
 {
 	struct vnt_private *priv = tx_context->priv;
 	struct vnt_rrv_time_rts *buf = &tx_head->tx_rts.rts;
 	union vnt_tx_data_head *head = &tx_head->tx_rts.tx.head;
 	u32 frame_len = tx_context->frame_len;
+	u16 current_rate = tx_context->tx_rate;
 	u8 need_ack = tx_context->need_ack;
 
 	buf->rts_rrv_time_aa = vnt_get_rtscts_rsvtime_le(priv, 2,
@@ -589,19 +591,19 @@ static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
 		head = &tx_head->tx_rts.tx.mic.head;
 
 	if (tx_context->fb_option)
-		return vnt_rxtx_rts_g_fb_head(tx_context, &head->rts_g_fb,
-					      current_rate);
+		return vnt_rxtx_rts_g_fb_head(tx_context, &head->rts_g_fb);
 
-	return vnt_rxtx_rts_g_head(tx_context, &head->rts_g, current_rate);
+	return vnt_rxtx_rts_g_head(tx_context, &head->rts_g);
 }
 
 static u16 vnt_rxtx_cts(struct vnt_usb_send_context *tx_context,
-	union vnt_tx_head *tx_head, u16 current_rate, bool need_mic)
+			union vnt_tx_head *tx_head, bool need_mic)
 {
 	struct vnt_private *priv = tx_context->priv;
 	struct vnt_rrv_time_cts *buf = &tx_head->tx_cts.cts;
 	union vnt_tx_data_head *head = &tx_head->tx_cts.tx.head;
 	u32 frame_len = tx_context->frame_len;
+	u16 current_rate = tx_context->tx_rate;
 	u8 need_ack = tx_context->need_ack;
 
 	buf->rrv_time_a = vnt_rxtx_rsvtime_le16(priv, tx_context->pkt_type,
@@ -616,17 +618,17 @@ static u16 vnt_rxtx_cts(struct vnt_usb_send_context *tx_context,
 		head = &tx_head->tx_cts.tx.mic.head;
 
 	/* Fill CTS */
-	return vnt_fill_cts_head(tx_context, head, current_rate);
+	return vnt_fill_cts_head(tx_context, head);
 }
 
 static u16 vnt_rxtx_ab(struct vnt_usb_send_context *tx_context,
-	union vnt_tx_head *tx_head,
-	u16 current_rate, bool need_rts, bool need_mic)
+		       union vnt_tx_head *tx_head, bool need_rts, bool need_mic)
 {
 	struct vnt_private *priv = tx_context->priv;
 	struct vnt_rrv_time_ab *buf = &tx_head->tx_ab.ab;
 	union vnt_tx_data_head *head = &tx_head->tx_ab.tx.head;
 	u32 frame_len = tx_context->frame_len;
+	u16 current_rate = tx_context->tx_rate;
 	u8 need_ack = tx_context->need_ack;
 
 	buf->rrv_time = vnt_rxtx_rsvtime_le16(priv, tx_context->pkt_type,
@@ -646,23 +648,20 @@ static u16 vnt_rxtx_ab(struct vnt_usb_send_context *tx_context,
 		if (tx_context->fb_option &&
 		    tx_context->pkt_type == PK_TYPE_11A)
 			return vnt_rxtx_rts_a_fb_head(tx_context,
-						      &head->rts_a_fb,
-						      current_rate);
+						      &head->rts_a_fb);
 
-		return vnt_rxtx_rts_ab_head(tx_context, &head->rts_ab,
-					    current_rate);
+		return vnt_rxtx_rts_ab_head(tx_context, &head->rts_ab);
 	}
 
 	if (tx_context->pkt_type == PK_TYPE_11A)
-		return vnt_rxtx_datahead_a_fb(tx_context, current_rate,
+		return vnt_rxtx_datahead_a_fb(tx_context,
 					      &head->data_head_a_fb);
 
-	return vnt_rxtx_datahead_ab(tx_context, current_rate,
-				    &head->data_head_ab);
+	return vnt_rxtx_datahead_ab(tx_context, &head->data_head_ab);
 }
 
 static u16 vnt_generate_tx_parameter(struct vnt_usb_send_context *tx_context,
-	u16 current_rate, struct vnt_tx_buffer *tx_buffer,
+	struct vnt_tx_buffer *tx_buffer,
 	struct vnt_mic_hdr **mic_hdr, u32 need_mic,
 	bool need_rts)
 {
@@ -675,21 +674,19 @@ static u16 vnt_generate_tx_parameter(struct vnt_usb_send_context *tx_context,
 						tx_head.tx_rts.tx.mic.hdr;
 
 			return vnt_rxtx_rts(tx_context, &tx_buffer->tx_head,
-					    current_rate, need_mic);
+					    need_mic);
 		}
 
 		if (need_mic)
 			*mic_hdr = &tx_buffer->tx_head.tx_cts.tx.mic.hdr;
 
-		return vnt_rxtx_cts(tx_context, &tx_buffer->tx_head,
-				    current_rate, need_mic);
+		return vnt_rxtx_cts(tx_context, &tx_buffer->tx_head, need_mic);
 	}
 
 	if (need_mic)
 		*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
 
-	return vnt_rxtx_ab(tx_context, &tx_buffer->tx_head,
-			   current_rate, need_rts, need_mic);
+	return vnt_rxtx_ab(tx_context, &tx_buffer->tx_head, need_rts, need_mic);
 }
 
 static void vnt_fill_txkey(struct vnt_usb_send_context *tx_context,
@@ -807,6 +804,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 	tx_context->pkt_type = pkt_type;
 	tx_context->need_ack = false;
 	tx_context->frame_len = skb->len + 4;
+	tx_context->tx_rate = current_rate;
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -909,9 +907,8 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	tx_context->fb_option = fb_option;
 
-	duration_id = vnt_generate_tx_parameter(tx_context, current_rate,
-						tx_buffer, &mic_hdr, need_mic,
-						need_rts);
+	duration_id = vnt_generate_tx_parameter(tx_context, tx_buffer, &mic_hdr,
+						need_mic, need_rts);
 
 	tx_header_size = tx_context->tx_hdr_size;
 	if (!tx_header_size) {
-- 
2.0.1

