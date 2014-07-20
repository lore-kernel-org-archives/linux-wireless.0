Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:63965 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaGTOeU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:20 -0400
Received: by mail-we0-f175.google.com with SMTP id t60so6467961wes.20
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:19 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/25] staging: vt6656: struct vnt_private replace byBBType with bb_type
Date: Sun, 20 Jul 2014 15:33:11 +0100
Message-Id: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com> (sfid-20140720_163423_791040_1D733424)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing type prefix and camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c     | 24 ++++++++++++------------
 drivers/staging/vt6656/device.h   |  2 +-
 drivers/staging/vt6656/dpc.c      |  2 +-
 drivers/staging/vt6656/main_usb.c | 14 +++++++-------
 drivers/staging/vt6656/rxtx.c     |  2 +-
 5 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 5ce26fa..94b933f 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -405,7 +405,7 @@ void vnt_update_ifs(struct vnt_private *priv)
 
 	switch (priv->rf_type) {
 	case RF_VT3226D0:
-		if (priv->byBBType != BB_TYPE_11B) {
+		if (priv->bb_type != BB_TYPE_11B) {
 			priv->sifs -= 1;
 			priv->difs -= 1;
 			break;
@@ -413,7 +413,7 @@ void vnt_update_ifs(struct vnt_private *priv)
 	case RF_AIROHA7230:
 	case RF_AL2230:
 	case RF_AL2230S:
-		if (priv->byBBType != BB_TYPE_11B)
+		if (priv->bb_type != BB_TYPE_11B)
 			break;
 	case RF_RFMD2959:
 	case RF_VT3226:
@@ -422,7 +422,7 @@ void vnt_update_ifs(struct vnt_private *priv)
 		priv->difs -= 3;
 		break;
 	case RF_MAXIM2829:
-		if (priv->byBBType == BB_TYPE_11A) {
+		if (priv->bb_type == BB_TYPE_11A) {
 			priv->sifs -= 5;
 			priv->difs -= 5;
 		} else {
@@ -489,8 +489,8 @@ int vnt_ofdm_min_rate(struct vnt_private *priv)
 u8 vnt_get_pkt_type(struct vnt_private *priv)
 {
 
-	if (priv->byBBType == BB_TYPE_11A || priv->byBBType == BB_TYPE_11B)
-		return (u8)priv->byBBType;
+	if (priv->bb_type == BB_TYPE_11A || priv->bb_type == BB_TYPE_11B)
+		return (u8)priv->bb_type;
 	else if (vnt_ofdm_min_rate(priv))
 		return PK_TYPE_11GA;
 	else
@@ -788,24 +788,24 @@ int vnt_radio_power_on(struct vnt_private *priv)
 
 void vnt_set_bss_mode(struct vnt_private *priv)
 {
-	if (priv->rf_type == RF_AIROHA7230 && priv->byBBType == BB_TYPE_11A)
+	if (priv->rf_type == RF_AIROHA7230 && priv->bb_type == BB_TYPE_11A)
 		vnt_mac_set_bb_type(priv, BB_TYPE_11G);
 	else
-		vnt_mac_set_bb_type(priv, priv->byBBType);
+		vnt_mac_set_bb_type(priv, priv->bb_type);
 
 	priv->byPacketType = vnt_get_pkt_type(priv);
 
-	if (priv->byBBType == BB_TYPE_11A)
+	if (priv->bb_type == BB_TYPE_11A)
 		vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x88, 0x03);
-	else if (priv->byBBType == BB_TYPE_11B)
+	else if (priv->bb_type == BB_TYPE_11B)
 		vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x88, 0x02);
-	else if (priv->byBBType == BB_TYPE_11G)
+	else if (priv->bb_type == BB_TYPE_11G)
 		vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x88, 0x08);
 
 	vnt_update_ifs(priv);
-	vnt_set_rspinf(priv, (u8)priv->byBBType);
+	vnt_set_rspinf(priv, (u8)priv->bb_type);
 
-	if (priv->byBBType == BB_TYPE_11A) {
+	if (priv->bb_type == BB_TYPE_11A) {
 		if (priv->rf_type == RF_AIROHA7230) {
 			priv->abyBBVGA[0] = 0x20;
 
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index b9753c1..7b5779a 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -330,7 +330,7 @@ struct vnt_private {
 	u32 slot;  /* Current SlotTime */
 
 	/* Rate */
-	u8 byBBType; /* 0: 11A, 1:11B, 2:11G */
+	u8 bb_type; /* 0: 11A, 1:11B, 2:11G */
 	u8 byPacketType; /* 0:11a 1:11b 2:11gb 3:11ga */
 	u32 wBasicRate;
 	u8 byTopOFDMBasicRate;
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index f8410ce1..3bf2782 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -133,7 +133,7 @@ int vnt_rx_data(struct vnt_private *priv, struct vnt_rcb *ptr_rcb,
 
 	priv->tsf_time = le64_to_cpu(*tsf_time);
 
-	if (priv->byBBType == BB_TYPE_11G) {
+	if (priv->bb_type == BB_TYPE_11G) {
 		sq_3 = skb_data + 8 + pay_load_with_padding + 12;
 		sq = sq_3;
 	} else {
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 1137a19..5ca28c2 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -121,8 +121,8 @@ static void device_set_options(struct vnt_private *priv)
 	priv->byShortRetryLimit = SHORT_RETRY_DEF;
 	priv->byLongRetryLimit = LONG_RETRY_DEF;
 	priv->op_mode = NL80211_IFTYPE_UNSPECIFIED;
-	priv->byBBType = BBP_TYPE_DEF;
-	priv->byPacketType = priv->byBBType;
+	priv->bb_type = BBP_TYPE_DEF;
+	priv->byPacketType = priv->bb_type;
 	priv->byAutoFBCtrl = AUTO_FB_0;
 	priv->byPreambleType = 0;
 	priv->exist_sw_net_addr = false;
@@ -283,7 +283,7 @@ static int device_init_registers(struct vnt_private *priv)
 	priv->byAutoFBCtrl = AUTO_FB_0;
 
 	/* default Auto Mode */
-	priv->byBBType = BB_TYPE_11G;
+	priv->bb_type = BB_TYPE_11G;
 
 	/* get RFType */
 	priv->rf_type = init_rsp->rf_type;
@@ -341,7 +341,7 @@ static int device_init_registers(struct vnt_private *priv)
 	* set BB and packet type at the same time
 	* set Short Slot Time, xIFS, and RSPINF
 	*/
-	if (priv->byBBType == BB_TYPE_11A)
+	if (priv->bb_type == BB_TYPE_11A)
 		priv->bShortSlotTime = true;
 	else
 		priv->bShortSlotTime = false;
@@ -709,15 +709,15 @@ static int vnt_config(struct ieee80211_hw *hw, u32 changed)
 		else
 			bb_type = BB_TYPE_11G;
 
-		if (priv->byBBType != bb_type) {
-			priv->byBBType = bb_type;
+		if (priv->bb_type != bb_type) {
+			priv->bb_type = bb_type;
 
 			vnt_set_bss_mode(priv);
 		}
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
-		if (priv->byBBType == BB_TYPE_11B)
+		if (priv->bb_type == BB_TYPE_11B)
 			priv->wCurrentRate = RATE_1M;
 		else
 			priv->wCurrentRate = RATE_54M;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index aa382e7..3347a72 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -966,7 +966,7 @@ static int vnt_beacon_xmit(struct vnt_private *priv,
 	beacon_buffer = (struct vnt_beacon_buffer *)&context->data[0];
 	short_head = &beacon_buffer->short_head;
 
-	if (priv->byBBType == BB_TYPE_11A) {
+	if (priv->bb_type == BB_TYPE_11A) {
 		current_rate = RATE_6M;
 
 		/* Get SignalField,ServiceField,Length */
-- 
2.0.1

