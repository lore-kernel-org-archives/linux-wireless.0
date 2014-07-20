Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:42498 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbaGTOeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:37 -0400
Received: by mail-we0-f176.google.com with SMTP id q58so6477594wes.35
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:36 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/25] staging: vt6656: struct vnt_private replace bShortSlotTime with short_slot_time
Date: Sun, 20 Jul 2014 15:33:21 +0100
Message-Id: <1405866815-2687-11-git-send-email-tvboxspy@gmail.com> (sfid-20140720_165109_605238_D037B317)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing type prefix and camel case

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 4 ++--
 drivers/staging/vt6656/card.c     | 2 +-
 drivers/staging/vt6656/device.h   | 2 +-
 drivers/staging/vt6656/main_usb.c | 8 ++++----
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index ab5ce02..8b2b2e7 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -526,7 +526,7 @@ void vnt_set_short_slot_time(struct vnt_private *priv)
 {
 	u8 bb_vga = 0;
 
-	if (priv->bShortSlotTime)
+	if (priv->short_slot_time)
 		priv->bb_rx_conf &= 0xdf;
 	else
 		priv->bb_rx_conf |= 0x20;
@@ -545,7 +545,7 @@ void vnt_set_vga_gain_offset(struct vnt_private *priv, u8 data)
 	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0xE7, data);
 
 	/* patch for 3253B0 Baseband with Cardbus module */
-	if (priv->bShortSlotTime)
+	if (priv->short_slot_time)
 		priv->bb_rx_conf &= 0xdf; /* 1101 1111 */
 	else
 		priv->bb_rx_conf |= 0x20; /* 0010 0000 */
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 8e00377..75b586b 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -381,7 +381,7 @@ void vnt_update_ifs(struct vnt_private *priv)
 
 		priv->sifs = C_SIFS_BG;
 
-		if (priv->bShortSlotTime)
+		if (priv->short_slot_time)
 			priv->slot = C_SLOT_SHORT;
 		else
 			priv->slot = C_SLOT_LONG;
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index fd230b3..35bc8c6 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -358,7 +358,7 @@ struct vnt_private {
 
 	enum nl80211_iftype op_mode;
 
-	int bShortSlotTime;
+	int short_slot_time;
 	int bBarkerPreambleMd;
 
 	/* Power save */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index e8ce52d..f7f4dcc 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -342,9 +342,9 @@ static int device_init_registers(struct vnt_private *priv)
 	* set Short Slot Time, xIFS, and RSPINF
 	*/
 	if (priv->bb_type == BB_TYPE_11A)
-		priv->bShortSlotTime = true;
+		priv->short_slot_time = true;
 	else
-		priv->bShortSlotTime = false;
+		priv->short_slot_time = false;
 
 	vnt_set_short_slot_time(priv);
 
@@ -768,9 +768,9 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
 		if (conf->use_short_slot)
-			priv->bShortSlotTime = true;
+			priv->short_slot_time = true;
 		else
-			priv->bShortSlotTime = false;
+			priv->short_slot_time = false;
 
 		vnt_set_short_slot_time(priv);
 		vnt_set_vga_gain_offset(priv, priv->abyBBVGA[0]);
-- 
2.0.1

