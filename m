Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:52144 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbaGTOea (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:30 -0400
Received: by mail-we0-f181.google.com with SMTP id k48so5211969wev.26
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:29 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/25] staging: vt6656: struct vnt_private replace byPreambleType with preamble_type
Date: Sun, 20 Jul 2014 15:33:17 +0100
Message-Id: <1405866815-2687-7-git-send-email-tvboxspy@gmail.com> (sfid-20140720_163437_304934_8DCF5ABC)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing type prefix and camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c |  2 +-
 drivers/staging/vt6656/device.h   |  2 +-
 drivers/staging/vt6656/main_usb.c |  6 +++---
 drivers/staging/vt6656/rxtx.c     | 40 +++++++++++++++++++--------------------
 4 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 9598c19..ab5ce02 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -207,7 +207,7 @@ void vnt_get_phy_field(struct vnt_private *priv, u32 frame_length,
 	u32 count = 0;
 	u32 tmp;
 	int ext_bit;
-	u8 preamble_type = priv->byPreambleType;
+	u8 preamble_type = priv->preamble_type;
 
 	bit_count = frame_length * 8;
 	ext_bit = false;
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 07e9d03..466a984 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -338,7 +338,7 @@ struct vnt_private {
 
 	u8 eeprom[EEP_MAX_CONTEXT_SIZE];  /*u32 alignment */
 
-	u8 byPreambleType;
+	u8 preamble_type;
 
 	/* For RF Power table */
 	u8 byCCKPwr;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 4054e36..325daae 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -124,7 +124,7 @@ static void device_set_options(struct vnt_private *priv)
 	priv->bb_type = BBP_TYPE_DEF;
 	priv->packet_type = priv->bb_type;
 	priv->byAutoFBCtrl = AUTO_FB_0;
-	priv->byPreambleType = 0;
+	priv->preamble_type = 0;
 	priv->exist_sw_net_addr = false;
 }
 
@@ -752,10 +752,10 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
 		if (conf->use_short_preamble) {
 			vnt_mac_enable_barker_preamble_mode(priv);
-			priv->byPreambleType = true;
+			priv->preamble_type = true;
 		} else {
 			vnt_mac_disable_barker_preamble_mode(priv);
-			priv->byPreambleType = false;
+			priv->preamble_type = false;
 		}
 	}
 
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 79ce396..68e479a 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -105,7 +105,7 @@ static struct vnt_usb_send_context
 
 static __le16 vnt_time_stamp_off(struct vnt_private *priv, u16 rate)
 {
-	return cpu_to_le16(vnt_time_stampoff[priv->byPreambleType % 2]
+	return cpu_to_le16(vnt_time_stampoff[priv->preamble_type % 2]
 							[rate % MAX_RATE]);
 }
 
@@ -114,14 +114,14 @@ static u32 vnt_get_rsvtime(struct vnt_private *priv, u8 pkt_type,
 {
 	u32 data_time, ack_time;
 
-	data_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
+	data_time = vnt_get_frame_time(priv->preamble_type, pkt_type,
 							frame_length, rate);
 
 	if (pkt_type == PK_TYPE_11B)
-		ack_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
+		ack_time = vnt_get_frame_time(priv->preamble_type, pkt_type,
 					14, (u16)priv->top_cck_basic_rate);
 	else
-		ack_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
+		ack_time = vnt_get_frame_time(priv->preamble_type, pkt_type,
 					14, (u16)priv->top_ofdm_basic_rate);
 
 	if (need_ack)
@@ -144,30 +144,30 @@ static __le16 vnt_get_rtscts_rsvtime_le(struct vnt_private *priv,
 
 	rrv_time = rts_time = cts_time = ack_time = data_time = 0;
 
-	data_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
+	data_time = vnt_get_frame_time(priv->preamble_type, pkt_type,
 						frame_length, current_rate);
 
 	if (rsv_type == 0) {
-		rts_time = vnt_get_frame_time(priv->byPreambleType,
+		rts_time = vnt_get_frame_time(priv->preamble_type,
 			pkt_type, 20, priv->top_cck_basic_rate);
-		cts_time = ack_time = vnt_get_frame_time(priv->byPreambleType,
+		cts_time = ack_time = vnt_get_frame_time(priv->preamble_type,
 			pkt_type, 14, priv->top_cck_basic_rate);
 	} else if (rsv_type == 1) {
-		rts_time = vnt_get_frame_time(priv->byPreambleType,
+		rts_time = vnt_get_frame_time(priv->preamble_type,
 			pkt_type, 20, priv->top_cck_basic_rate);
-		cts_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
+		cts_time = vnt_get_frame_time(priv->preamble_type, pkt_type,
 			14, priv->top_cck_basic_rate);
-		ack_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
+		ack_time = vnt_get_frame_time(priv->preamble_type, pkt_type,
 			14, priv->top_ofdm_basic_rate);
 	} else if (rsv_type == 2) {
-		rts_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
+		rts_time = vnt_get_frame_time(priv->preamble_type, pkt_type,
 			20, priv->top_ofdm_basic_rate);
-		cts_time = ack_time = vnt_get_frame_time(priv->byPreambleType,
+		cts_time = ack_time = vnt_get_frame_time(priv->preamble_type,
 			pkt_type, 14, priv->top_ofdm_basic_rate);
 	} else if (rsv_type == 3) {
-		cts_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
+		cts_time = vnt_get_frame_time(priv->preamble_type, pkt_type,
 			14, priv->top_cck_basic_rate);
-		ack_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
+		ack_time = vnt_get_frame_time(priv->preamble_type, pkt_type,
 			14, priv->top_ofdm_basic_rate);
 
 		rrv_time = cts_time + ack_time + data_time + 2 * priv->sifs;
@@ -187,10 +187,10 @@ static __le16 vnt_get_duration_le(struct vnt_private *piv,
 
 	if (need_ack) {
 		if (pkt_type == PK_TYPE_11B)
-			ack_time = vnt_get_frame_time(piv->byPreambleType,
+			ack_time = vnt_get_frame_time(piv->preamble_type,
 				pkt_type, 14, piv->top_cck_basic_rate);
 		else
-			ack_time = vnt_get_frame_time(piv->byPreambleType,
+			ack_time = vnt_get_frame_time(piv->preamble_type,
 				pkt_type, 14, piv->top_ofdm_basic_rate);
 
 		return cpu_to_le16((u16)(piv->sifs + ack_time));
@@ -209,7 +209,7 @@ static __le16 vnt_get_rtscts_duration_le(struct vnt_private *priv, u8 dur_type,
 	case RTSDUR_BA:
 	case RTSDUR_BA_F0:
 	case RTSDUR_BA_F1:
-		cts_time = vnt_get_frame_time(priv->byPreambleType,
+		cts_time = vnt_get_frame_time(priv->preamble_type,
 				pkt_type, 14, priv->top_cck_basic_rate);
 		dur_time = cts_time + 2 * priv->sifs +
 			vnt_get_rsvtime(priv, pkt_type,
@@ -219,7 +219,7 @@ static __le16 vnt_get_rtscts_duration_le(struct vnt_private *priv, u8 dur_type,
 	case RTSDUR_AA:
 	case RTSDUR_AA_F0:
 	case RTSDUR_AA_F1:
-		cts_time = vnt_get_frame_time(priv->byPreambleType,
+		cts_time = vnt_get_frame_time(priv->preamble_type,
 				pkt_type, 14, priv->top_ofdm_basic_rate);
 		dur_time = cts_time + 2 * priv->sifs +
 			vnt_get_rsvtime(priv, pkt_type,
@@ -825,9 +825,9 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 		tx_buffer_head->wFIFOCtl |= FIFOCTL_LRETRY;
 
 	if (tx_rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
-		priv->byPreambleType = PREAMBLE_SHORT;
+		priv->preamble_type = PREAMBLE_SHORT;
 	else
-		priv->byPreambleType = PREAMBLE_LONG;
+		priv->preamble_type = PREAMBLE_LONG;
 
 	if (tx_rate->flags & IEEE80211_TX_RC_USE_RTS_CTS) {
 		need_rts = true;
-- 
2.0.1

