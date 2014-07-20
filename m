Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35594 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbaGTOeo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:44 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so2898430wib.16
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:43 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 15/25] staging: vt6656: struct vnt_private replace abyBBVGA with bb_vga
Date: Sun, 20 Jul 2014 15:33:25 +0100
Message-Id: <1405866815-2687-15-git-send-email-tvboxspy@gmail.com> (sfid-20140720_165109_253334_51C14A44)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing type prefix and camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 34 +++++++++++++++++-----------------
 drivers/staging/vt6656/card.c     | 18 +++++++++---------
 drivers/staging/vt6656/device.h   |  2 +-
 drivers/staging/vt6656/main_usb.c |  2 +-
 4 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 8b2b2e7..11c098c 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -406,10 +406,10 @@ int vnt_vt3184_init(struct vnt_private *priv)
 		agc = vnt_vt3184_agc;
 		length_agc = sizeof(vnt_vt3184_agc);
 
-		priv->abyBBVGA[0] = 0x1C;
-		priv->abyBBVGA[1] = 0x10;
-		priv->abyBBVGA[2] = 0x0;
-		priv->abyBBVGA[3] = 0x0;
+		priv->bb_vga[0] = 0x1C;
+		priv->bb_vga[1] = 0x10;
+		priv->bb_vga[2] = 0x0;
+		priv->bb_vga[3] = 0x0;
 		priv->ldBmThreshold[0] = -70;
 		priv->ldBmThreshold[1] = -48;
 		priv->ldBmThreshold[2] = 0;
@@ -423,10 +423,10 @@ int vnt_vt3184_init(struct vnt_private *priv)
 
 		addr[0xd7] = 0x06;
 
-		priv->abyBBVGA[0] = 0x1c;
-		priv->abyBBVGA[1] = 0x10;
-		priv->abyBBVGA[2] = 0x0;
-		priv->abyBBVGA[3] = 0x0;
+		priv->bb_vga[0] = 0x1c;
+		priv->bb_vga[1] = 0x10;
+		priv->bb_vga[2] = 0x0;
+		priv->bb_vga[3] = 0x0;
 		priv->ldBmThreshold[0] = -70;
 		priv->ldBmThreshold[1] = -48;
 		priv->ldBmThreshold[2] = 0;
@@ -439,10 +439,10 @@ int vnt_vt3184_init(struct vnt_private *priv)
 		agc = vnt_vt3184_agc;
 		length_agc = sizeof(vnt_vt3184_agc);
 
-		priv->abyBBVGA[0] = 0x20;
-		priv->abyBBVGA[1] = 0x10;
-		priv->abyBBVGA[2] = 0x0;
-		priv->abyBBVGA[3] = 0x0;
+		priv->bb_vga[0] = 0x20;
+		priv->bb_vga[1] = 0x10;
+		priv->bb_vga[2] = 0x0;
+		priv->bb_vga[3] = 0x0;
 		priv->ldBmThreshold[0] = -70;
 		priv->ldBmThreshold[1] = -48;
 		priv->ldBmThreshold[2] = 0;
@@ -457,10 +457,10 @@ int vnt_vt3184_init(struct vnt_private *priv)
 		agc = vnt_vt3184_agc;
 		length_agc = sizeof(vnt_vt3184_agc);
 
-		priv->abyBBVGA[0] = 0x20;
-		priv->abyBBVGA[1] = 0x10;
-		priv->abyBBVGA[2] = 0x0;
-		priv->abyBBVGA[3] = 0x0;
+		priv->bb_vga[0] = 0x20;
+		priv->bb_vga[1] = 0x10;
+		priv->bb_vga[2] = 0x0;
+		priv->bb_vga[3] = 0x0;
 		priv->ldBmThreshold[0] = -70;
 		priv->ldBmThreshold[1] = -48;
 		priv->ldBmThreshold[2] = 0;
@@ -533,7 +533,7 @@ void vnt_set_short_slot_time(struct vnt_private *priv)
 
 	vnt_control_in_u8(priv, MESSAGE_REQUEST_BBREG, 0xe7, &bb_vga);
 
-	if (bb_vga == priv->abyBBVGA[0])
+	if (bb_vga == priv->bb_vga[0])
 		priv->bb_rx_conf |= 0x20;
 
 	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x0a, priv->bb_rx_conf);
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 75b586b..c06dd9d 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -807,25 +807,25 @@ void vnt_set_bss_mode(struct vnt_private *priv)
 
 	if (priv->bb_type == BB_TYPE_11A) {
 		if (priv->rf_type == RF_AIROHA7230) {
-			priv->abyBBVGA[0] = 0x20;
+			priv->bb_vga[0] = 0x20;
 
 			vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG,
-						0xe7, priv->abyBBVGA[0]);
+						0xe7, priv->bb_vga[0]);
 		}
 
-		priv->abyBBVGA[2] = 0x10;
-		priv->abyBBVGA[3] = 0x10;
+		priv->bb_vga[2] = 0x10;
+		priv->bb_vga[3] = 0x10;
 	} else {
 		if (priv->rf_type == RF_AIROHA7230) {
-			priv->abyBBVGA[0] = 0x1c;
+			priv->bb_vga[0] = 0x1c;
 
 			vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG,
-						0xe7, priv->abyBBVGA[0]);
+						0xe7, priv->bb_vga[0]);
 		}
 
-		priv->abyBBVGA[2] = 0x0;
-		priv->abyBBVGA[3] = 0x0;
+		priv->bb_vga[2] = 0x0;
+		priv->bb_vga[3] = 0x0;
 	}
 
-	vnt_set_vga_gain_offset(priv, priv->abyBBVGA[0]);
+	vnt_set_vga_gain_offset(priv, priv->bb_vga[0]);
 }
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index ef9b505..e3c2509 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -383,7 +383,7 @@ struct vnt_private {
 	u8 auto_fb_ctrl;
 
 	/* For Update BaseBand VGA Gain Offset */
-	u8 abyBBVGA[BB_VGA_LEVEL];
+	u8 bb_vga[BB_VGA_LEVEL];
 	signed long ldBmThreshold[BB_VGA_LEVEL];
 
 	u8 byBBPreEDRSSI;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index fac13b1..b99def7 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -773,7 +773,7 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 			priv->short_slot_time = false;
 
 		vnt_set_short_slot_time(priv);
-		vnt_set_vga_gain_offset(priv, priv->abyBBVGA[0]);
+		vnt_set_vga_gain_offset(priv, priv->bb_vga[0]);
 		vnt_update_pre_ed_threshold(priv, false);
 	}
 
-- 
2.0.1

