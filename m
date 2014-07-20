Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:61209 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbaGTOe1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:27 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so2873030wiw.6
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:26 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/25] staging: vt6656: struct vnt_private replace byTopCCKBasicRate with top_cck_basic_rate
Date: Sun, 20 Jul 2014 15:33:15 +0100
Message-Id: <1405866815-2687-5-git-send-email-tvboxspy@gmail.com> (sfid-20140720_163432_748741_1454B15D)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing type prefix and camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c     |  2 +-
 drivers/staging/vt6656/device.h   |  2 +-
 drivers/staging/vt6656/main_usb.c |  2 +-
 drivers/staging/vt6656/rxtx.c     | 40 +++++++++++++++++++--------------------
 4 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 3217f77..8e00377 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -471,7 +471,7 @@ void vnt_update_top_rates(struct vnt_private *priv)
 			break;
 	}
 
-	priv->byTopCCKBasicRate = top_cck;
+	priv->top_cck_basic_rate = top_cck;
 }
 
 int vnt_ofdm_min_rate(struct vnt_private *priv)
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 951abc2b..dcb57dc 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -334,7 +334,7 @@ struct vnt_private {
 	u8 packet_type; /* 0:11a 1:11b 2:11gb 3:11ga */
 	u32 basic_rates;
 	u8 top_ofdm_basic_rate;
-	u8 byTopCCKBasicRate;
+	u8 top_cck_basic_rate;
 
 	u8 abyEEPROM[EEP_MAX_CONTEXT_SIZE];  /*u32 alignment */
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index a02a028..f5227ee 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -196,7 +196,7 @@ static int device_init_registers(struct vnt_private *priv)
 	/* do MACbSoftwareReset in MACvInitialize */
 
 	priv->top_ofdm_basic_rate = RATE_24M;
-	priv->byTopCCKBasicRate = RATE_1M;
+	priv->top_cck_basic_rate = RATE_1M;
 
 	/* target to IF pin while programming to RF chip */
 	priv->byCurPwr = 0xFF;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index ba2d550..79ce396 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -119,7 +119,7 @@ static u32 vnt_get_rsvtime(struct vnt_private *priv, u8 pkt_type,
 
 	if (pkt_type == PK_TYPE_11B)
 		ack_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
-					14, (u16)priv->byTopCCKBasicRate);
+					14, (u16)priv->top_cck_basic_rate);
 	else
 		ack_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
 					14, (u16)priv->top_ofdm_basic_rate);
@@ -149,14 +149,14 @@ static __le16 vnt_get_rtscts_rsvtime_le(struct vnt_private *priv,
 
 	if (rsv_type == 0) {
 		rts_time = vnt_get_frame_time(priv->byPreambleType,
-			pkt_type, 20, priv->byTopCCKBasicRate);
+			pkt_type, 20, priv->top_cck_basic_rate);
 		cts_time = ack_time = vnt_get_frame_time(priv->byPreambleType,
-			pkt_type, 14, priv->byTopCCKBasicRate);
+			pkt_type, 14, priv->top_cck_basic_rate);
 	} else if (rsv_type == 1) {
 		rts_time = vnt_get_frame_time(priv->byPreambleType,
-			pkt_type, 20, priv->byTopCCKBasicRate);
+			pkt_type, 20, priv->top_cck_basic_rate);
 		cts_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
-			14, priv->byTopCCKBasicRate);
+			14, priv->top_cck_basic_rate);
 		ack_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
 			14, priv->top_ofdm_basic_rate);
 	} else if (rsv_type == 2) {
@@ -166,7 +166,7 @@ static __le16 vnt_get_rtscts_rsvtime_le(struct vnt_private *priv,
 			pkt_type, 14, priv->top_ofdm_basic_rate);
 	} else if (rsv_type == 3) {
 		cts_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
-			14, priv->byTopCCKBasicRate);
+			14, priv->top_cck_basic_rate);
 		ack_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
 			14, priv->top_ofdm_basic_rate);
 
@@ -188,7 +188,7 @@ static __le16 vnt_get_duration_le(struct vnt_private *piv,
 	if (need_ack) {
 		if (pkt_type == PK_TYPE_11B)
 			ack_time = vnt_get_frame_time(piv->byPreambleType,
-				pkt_type, 14, piv->byTopCCKBasicRate);
+				pkt_type, 14, piv->top_cck_basic_rate);
 		else
 			ack_time = vnt_get_frame_time(piv->byPreambleType,
 				pkt_type, 14, piv->top_ofdm_basic_rate);
@@ -210,7 +210,7 @@ static __le16 vnt_get_rtscts_duration_le(struct vnt_private *priv, u8 dur_type,
 	case RTSDUR_BA_F0:
 	case RTSDUR_BA_F1:
 		cts_time = vnt_get_frame_time(priv->byPreambleType,
-				pkt_type, 14, priv->byTopCCKBasicRate);
+				pkt_type, 14, priv->top_cck_basic_rate);
 		dur_time = cts_time + 2 * priv->sifs +
 			vnt_get_rsvtime(priv, pkt_type,
 						frame_length, rate, need_ack);
@@ -264,7 +264,7 @@ static u16 vnt_rxtx_datahead_g(struct vnt_usb_send_context *tx_context,
 
 	/* Get SignalField,ServiceField,Length */
 	vnt_get_phy_field(priv, frame_len, rate, pkt_type, &buf->a);
-	vnt_get_phy_field(priv, frame_len, priv->byTopCCKBasicRate,
+	vnt_get_phy_field(priv, frame_len, priv->top_cck_basic_rate,
 							PK_TYPE_11B, &buf->b);
 
 	/* Get Duration and TimeStamp */
@@ -281,7 +281,7 @@ static u16 vnt_rxtx_datahead_g(struct vnt_usb_send_context *tx_context,
 
 	buf->time_stamp_off_a = vnt_time_stamp_off(priv, rate);
 	buf->time_stamp_off_b = vnt_time_stamp_off(priv,
-					priv->byTopCCKBasicRate);
+					priv->top_cck_basic_rate);
 
 	tx_context->tx_hdr_size = vnt_mac_hdr_pos(tx_context, &buf->hdr);
 
@@ -297,7 +297,7 @@ static u16 vnt_rxtx_datahead_g_fb(struct vnt_usb_send_context *tx_context,
 	/* Get SignalField,ServiceField,Length */
 	vnt_get_phy_field(priv, frame_len, rate, pkt_type, &buf->a);
 
-	vnt_get_phy_field(priv, frame_len, priv->byTopCCKBasicRate,
+	vnt_get_phy_field(priv, frame_len, priv->top_cck_basic_rate,
 						PK_TYPE_11B, &buf->b);
 
 	/* Get Duration and TimeStamp */
@@ -309,7 +309,7 @@ static u16 vnt_rxtx_datahead_g_fb(struct vnt_usb_send_context *tx_context,
 
 	buf->time_stamp_off_a = vnt_time_stamp_off(priv, rate);
 	buf->time_stamp_off_b = vnt_time_stamp_off(priv,
-						priv->byTopCCKBasicRate);
+						priv->top_cck_basic_rate);
 
 	tx_context->tx_hdr_size = vnt_mac_hdr_pos(tx_context, &buf->hdr);
 
@@ -387,13 +387,13 @@ static u16 vnt_rxtx_rts_g_head(struct vnt_usb_send_context *tx_context,
 	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
 
-	vnt_get_phy_field(priv, rts_frame_len, priv->byTopCCKBasicRate,
+	vnt_get_phy_field(priv, rts_frame_len, priv->top_cck_basic_rate,
 		PK_TYPE_11B, &buf->b);
 	vnt_get_phy_field(priv, rts_frame_len,
 		priv->top_ofdm_basic_rate, pkt_type, &buf->a);
 
 	buf->duration_bb = vnt_get_rtscts_duration_le(priv, RTSDUR_BB,
-		frame_len, PK_TYPE_11B, priv->byTopCCKBasicRate, need_ack);
+		frame_len, PK_TYPE_11B, priv->top_cck_basic_rate, need_ack);
 	buf->duration_aa = vnt_get_rtscts_duration_le(priv, RTSDUR_AA,
 		frame_len, pkt_type, current_rate, need_ack);
 	buf->duration_ba = vnt_get_rtscts_duration_le(priv, RTSDUR_BA,
@@ -412,14 +412,14 @@ static u16 vnt_rxtx_rts_g_fb_head(struct vnt_usb_send_context *tx_context,
 	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
 
-	vnt_get_phy_field(priv, rts_frame_len, priv->byTopCCKBasicRate,
+	vnt_get_phy_field(priv, rts_frame_len, priv->top_cck_basic_rate,
 		PK_TYPE_11B, &buf->b);
 	vnt_get_phy_field(priv, rts_frame_len,
 		priv->top_ofdm_basic_rate, pkt_type, &buf->a);
 
 
 	buf->duration_bb = vnt_get_rtscts_duration_le(priv, RTSDUR_BB,
-		frame_len, PK_TYPE_11B, priv->byTopCCKBasicRate, need_ack);
+		frame_len, PK_TYPE_11B, priv->top_cck_basic_rate, need_ack);
 	buf->duration_aa = vnt_get_rtscts_duration_le(priv, RTSDUR_AA,
 		frame_len, pkt_type, current_rate, need_ack);
 	buf->duration_ba = vnt_get_rtscts_duration_le(priv, RTSDUR_BA,
@@ -500,7 +500,7 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 		struct vnt_cts_fb *buf = &head->cts_g_fb;
 		/* Get SignalField,ServiceField,Length */
 		vnt_get_phy_field(priv, cts_frame_len,
-			priv->byTopCCKBasicRate, PK_TYPE_11B, &buf->b);
+			priv->top_cck_basic_rate, PK_TYPE_11B, &buf->b);
 		buf->duration_ba = vnt_get_rtscts_duration_le(priv, CTSDUR_BA,
 			frame_len, pkt_type,
 			current_rate, need_ack);
@@ -526,7 +526,7 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 		struct vnt_cts *buf = &head->cts_g;
 		/* Get SignalField,ServiceField,Length */
 		vnt_get_phy_field(priv, cts_frame_len,
-			priv->byTopCCKBasicRate, PK_TYPE_11B, &buf->b);
+			priv->top_cck_basic_rate, PK_TYPE_11B, &buf->b);
 		/* Get CTSDuration_ba */
 		buf->duration_ba = vnt_get_rtscts_duration_le(priv,
 			CTSDUR_BA, frame_len, pkt_type,
@@ -563,7 +563,7 @@ static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
 	buf->rrv_time_a = vnt_rxtx_rsvtime_le16(priv, pkt_type, frame_size,
 							current_rate, need_ack);
 	buf->rrv_time_b = vnt_rxtx_rsvtime_le16(priv, PK_TYPE_11B, frame_size,
-					priv->byTopCCKBasicRate, need_ack);
+					priv->top_cck_basic_rate, need_ack);
 
 	if (need_mic)
 		head = &tx_head->tx_rts.tx.mic.head;
@@ -588,7 +588,7 @@ static u16 vnt_rxtx_cts(struct vnt_usb_send_context *tx_context,
 	buf->rrv_time_a = vnt_rxtx_rsvtime_le16(priv, pkt_type,
 					frame_size, current_rate, need_ack);
 	buf->rrv_time_b = vnt_rxtx_rsvtime_le16(priv, PK_TYPE_11B,
-				frame_size, priv->byTopCCKBasicRate, need_ack);
+				frame_size, priv->top_cck_basic_rate, need_ack);
 
 	buf->cts_rrv_time_ba = vnt_get_rtscts_rsvtime_le(priv, 3,
 			pkt_type, frame_size, current_rate);
-- 
2.0.1

