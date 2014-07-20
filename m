Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38831 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbaGTOeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:22 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so2868058wiw.12
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:20 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/25] staging: vt6656: struct vnt_private replace byPacketType with packet_type
Date: Sun, 20 Jul 2014 15:33:12 +0100
Message-Id: <1405866815-2687-2-git-send-email-tvboxspy@gmail.com> (sfid-20140720_163425_880648_08E1A825)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing type prefix and camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c     | 6 +++---
 drivers/staging/vt6656/device.h   | 2 +-
 drivers/staging/vt6656/main_usb.c | 4 ++--
 drivers/staging/vt6656/rxtx.c     | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 94b933f..80b2ff8 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -365,12 +365,12 @@ void vnt_update_ifs(struct vnt_private *priv)
 	u8 max_min = 0;
 	u8 data[4];
 
-	if (priv->byPacketType == PK_TYPE_11A) {
+	if (priv->packet_type == PK_TYPE_11A) {
 		priv->slot = C_SLOT_SHORT;
 		priv->sifs = C_SIFS_A;
 		priv->difs = C_SIFS_A + 2 * C_SLOT_SHORT;
 		max_min = 4;
-	} else if (priv->byPacketType == PK_TYPE_11B) {
+	} else if (priv->packet_type == PK_TYPE_11B) {
 		priv->slot = C_SLOT_LONG;
 		priv->sifs = C_SIFS_BG;
 		priv->difs = C_SIFS_BG + 2 * C_SLOT_LONG;
@@ -793,7 +793,7 @@ void vnt_set_bss_mode(struct vnt_private *priv)
 	else
 		vnt_mac_set_bb_type(priv, priv->bb_type);
 
-	priv->byPacketType = vnt_get_pkt_type(priv);
+	priv->packet_type = vnt_get_pkt_type(priv);
 
 	if (priv->bb_type == BB_TYPE_11A)
 		vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x88, 0x03);
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 7b5779a..1f9ea51 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -331,7 +331,7 @@ struct vnt_private {
 
 	/* Rate */
 	u8 bb_type; /* 0: 11A, 1:11B, 2:11G */
-	u8 byPacketType; /* 0:11a 1:11b 2:11gb 3:11ga */
+	u8 packet_type; /* 0:11a 1:11b 2:11gb 3:11ga */
 	u32 wBasicRate;
 	u8 byTopOFDMBasicRate;
 	u8 byTopCCKBasicRate;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 5ca28c2..85142b7 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -122,7 +122,7 @@ static void device_set_options(struct vnt_private *priv)
 	priv->byLongRetryLimit = LONG_RETRY_DEF;
 	priv->op_mode = NL80211_IFTYPE_UNSPECIFIED;
 	priv->bb_type = BBP_TYPE_DEF;
-	priv->byPacketType = priv->bb_type;
+	priv->packet_type = priv->bb_type;
 	priv->byAutoFBCtrl = AUTO_FB_0;
 	priv->byPreambleType = 0;
 	priv->exist_sw_net_addr = false;
@@ -142,7 +142,7 @@ static int device_init_registers(struct vnt_private *priv)
 	u8 calib_tx_iq = 0, calib_tx_dc = 0, calib_rx_iq = 0;
 
 	dev_dbg(&priv->usb->dev, "---->INIbInitAdapter. [%d][%d]\n",
-				DEVICE_INIT_COLD, priv->byPacketType);
+				DEVICE_INIT_COLD, priv->packet_type);
 
 	if (!vnt_check_firmware_version(priv)) {
 		if (vnt_download_firmware(priv) == true) {
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 3347a72..03f299d 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -771,7 +771,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 	}
 
 	if (current_rate > RATE_11M)
-		pkt_type = priv->byPacketType;
+		pkt_type = priv->packet_type;
 	else
 		pkt_type = PK_TYPE_11B;
 
-- 
2.0.1

