Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33186 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbaGTOeZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:25 -0400
Received: by mail-wg0-f46.google.com with SMTP id m15so5402420wgh.5
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:24 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/25] staging: vt6656: struct vnt_private replace byTopOFDMBasicRate with top_ofdm_basic_rate
Date: Sun, 20 Jul 2014 15:33:14 +0100
Message-Id: <1405866815-2687-4-git-send-email-tvboxspy@gmail.com> (sfid-20140720_163430_993753_F317BE95)
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
 drivers/staging/vt6656/rxtx.c     | 22 +++++++++++-----------
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 80b6732..3217f77 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -460,7 +460,7 @@ void vnt_update_top_rates(struct vnt_private *priv)
 		}
 	}
 
-	priv->byTopOFDMBasicRate = top_ofdm;
+	priv->top_ofdm_basic_rate = top_ofdm;
 
 	for (i = RATE_11M;; i--) {
 		if (priv->basic_rates & (u16)(1 << i)) {
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 8cc33df..951abc2b 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -333,7 +333,7 @@ struct vnt_private {
 	u8 bb_type; /* 0: 11A, 1:11B, 2:11G */
 	u8 packet_type; /* 0:11a 1:11b 2:11gb 3:11ga */
 	u32 basic_rates;
-	u8 byTopOFDMBasicRate;
+	u8 top_ofdm_basic_rate;
 	u8 byTopCCKBasicRate;
 
 	u8 abyEEPROM[EEP_MAX_CONTEXT_SIZE];  /*u32 alignment */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 02898ff..a02a028 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -195,7 +195,7 @@ static int device_init_registers(struct vnt_private *priv)
 
 	/* do MACbSoftwareReset in MACvInitialize */
 
-	priv->byTopOFDMBasicRate = RATE_24M;
+	priv->top_ofdm_basic_rate = RATE_24M;
 	priv->byTopCCKBasicRate = RATE_1M;
 
 	/* target to IF pin while programming to RF chip */
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 03f299d..ba2d550 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -122,7 +122,7 @@ static u32 vnt_get_rsvtime(struct vnt_private *priv, u8 pkt_type,
 					14, (u16)priv->byTopCCKBasicRate);
 	else
 		ack_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
-					14, (u16)priv->byTopOFDMBasicRate);
+					14, (u16)priv->top_ofdm_basic_rate);
 
 	if (need_ack)
 		return data_time + priv->sifs + ack_time;
@@ -158,17 +158,17 @@ static __le16 vnt_get_rtscts_rsvtime_le(struct vnt_private *priv,
 		cts_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
 			14, priv->byTopCCKBasicRate);
 		ack_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
-			14, priv->byTopOFDMBasicRate);
+			14, priv->top_ofdm_basic_rate);
 	} else if (rsv_type == 2) {
 		rts_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
-			20, priv->byTopOFDMBasicRate);
+			20, priv->top_ofdm_basic_rate);
 		cts_time = ack_time = vnt_get_frame_time(priv->byPreambleType,
-			pkt_type, 14, priv->byTopOFDMBasicRate);
+			pkt_type, 14, priv->top_ofdm_basic_rate);
 	} else if (rsv_type == 3) {
 		cts_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
 			14, priv->byTopCCKBasicRate);
 		ack_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
-			14, priv->byTopOFDMBasicRate);
+			14, priv->top_ofdm_basic_rate);
 
 		rrv_time = cts_time + ack_time + data_time + 2 * priv->sifs;
 
@@ -191,7 +191,7 @@ static __le16 vnt_get_duration_le(struct vnt_private *piv,
 				pkt_type, 14, piv->byTopCCKBasicRate);
 		else
 			ack_time = vnt_get_frame_time(piv->byPreambleType,
-				pkt_type, 14, piv->byTopOFDMBasicRate);
+				pkt_type, 14, piv->top_ofdm_basic_rate);
 
 		return cpu_to_le16((u16)(piv->sifs + ack_time));
 	}
@@ -220,7 +220,7 @@ static __le16 vnt_get_rtscts_duration_le(struct vnt_private *priv, u8 dur_type,
 	case RTSDUR_AA_F0:
 	case RTSDUR_AA_F1:
 		cts_time = vnt_get_frame_time(priv->byPreambleType,
-				pkt_type, 14, priv->byTopOFDMBasicRate);
+				pkt_type, 14, priv->top_ofdm_basic_rate);
 		dur_time = cts_time + 2 * priv->sifs +
 			vnt_get_rsvtime(priv, pkt_type,
 						frame_length, rate, need_ack);
@@ -390,7 +390,7 @@ static u16 vnt_rxtx_rts_g_head(struct vnt_usb_send_context *tx_context,
 	vnt_get_phy_field(priv, rts_frame_len, priv->byTopCCKBasicRate,
 		PK_TYPE_11B, &buf->b);
 	vnt_get_phy_field(priv, rts_frame_len,
-		priv->byTopOFDMBasicRate, pkt_type, &buf->a);
+		priv->top_ofdm_basic_rate, pkt_type, &buf->a);
 
 	buf->duration_bb = vnt_get_rtscts_duration_le(priv, RTSDUR_BB,
 		frame_len, PK_TYPE_11B, priv->byTopCCKBasicRate, need_ack);
@@ -415,7 +415,7 @@ static u16 vnt_rxtx_rts_g_fb_head(struct vnt_usb_send_context *tx_context,
 	vnt_get_phy_field(priv, rts_frame_len, priv->byTopCCKBasicRate,
 		PK_TYPE_11B, &buf->b);
 	vnt_get_phy_field(priv, rts_frame_len,
-		priv->byTopOFDMBasicRate, pkt_type, &buf->a);
+		priv->top_ofdm_basic_rate, pkt_type, &buf->a);
 
 
 	buf->duration_bb = vnt_get_rtscts_duration_le(priv, RTSDUR_BB,
@@ -449,7 +449,7 @@ static u16 vnt_rxtx_rts_ab_head(struct vnt_usb_send_context *tx_context,
 	u16 rts_frame_len = 20;
 
 	vnt_get_phy_field(priv, rts_frame_len,
-		priv->byTopOFDMBasicRate, pkt_type, &buf->ab);
+		priv->top_ofdm_basic_rate, pkt_type, &buf->ab);
 
 	buf->duration = vnt_get_rtscts_duration_le(priv, RTSDUR_AA, frame_len,
 		pkt_type, current_rate, need_ack);
@@ -468,7 +468,7 @@ static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
 	u16 rts_frame_len = 20;
 
 	vnt_get_phy_field(priv, rts_frame_len,
-		priv->byTopOFDMBasicRate, pkt_type, &buf->a);
+		priv->top_ofdm_basic_rate, pkt_type, &buf->a);
 
 	buf->duration = vnt_get_rtscts_duration_le(priv, RTSDUR_AA, frame_len,
 		pkt_type, current_rate, need_ack);
-- 
2.0.1

