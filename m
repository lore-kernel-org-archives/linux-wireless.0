Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:52870 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaGPVXS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:23:18 -0400
Received: by mail-we0-f171.google.com with SMTP id p10so1569704wes.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:23:16 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/21] staging: vt6656: rename BBvSetVGAGainOffset to vnt_set_vga_gain_offset
Date: Wed, 16 Jul 2014 22:21:55 +0100
Message-Id: <1405545731-6082-5-git-send-email-tvboxspy@gmail.com> (sfid-20140716_232326_535227_BEB82A63)
In-Reply-To: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
References: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dropping BB

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 2 +-
 drivers/staging/vt6656/baseband.h | 2 +-
 drivers/staging/vt6656/card.c     | 2 +-
 drivers/staging/vt6656/main_usb.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 3138826..184f416 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -543,7 +543,7 @@ void vnt_set_short_slot_time(struct vnt_private *priv)
 	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x0a, priv->byBBRxConf);
 }
 
-void BBvSetVGAGainOffset(struct vnt_private *priv, u8 data)
+void vnt_set_vga_gain_offset(struct vnt_private *priv, u8 data)
 {
 
 	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0xE7, data);
diff --git a/drivers/staging/vt6656/baseband.h b/drivers/staging/vt6656/baseband.h
index 1a36e13..a3aff07 100644
--- a/drivers/staging/vt6656/baseband.h
+++ b/drivers/staging/vt6656/baseband.h
@@ -94,7 +94,7 @@ void vnt_get_phy_field(struct vnt_private *, u32 frame_length,
 	u16 tx_rate, u8 pkt_type, struct vnt_phy_field *);
 
 void vnt_set_short_slot_time(struct vnt_private *);
-void BBvSetVGAGainOffset(struct vnt_private *, u8 byData);
+void vnt_set_vga_gain_offset(struct vnt_private *, u8);
 void vnt_set_antenna_mode(struct vnt_private *, u8);
 int vnt_vt3184_init(struct vnt_private *);
 void BBvSetDeepSleep(struct vnt_private *);
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 37cd96b..1cbdfee 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -836,5 +836,5 @@ void vnt_set_bss_mode(struct vnt_private *priv)
 		priv->abyBBVGA[3] = 0x0;
 	}
 
-	BBvSetVGAGainOffset(priv, priv->abyBBVGA[0]);
+	vnt_set_vga_gain_offset(priv, priv->abyBBVGA[0]);
 }
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index a418d1d..695c541 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -881,7 +881,7 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 			priv->bShortSlotTime = false;
 
 		vnt_set_short_slot_time(priv);
-		BBvSetVGAGainOffset(priv, priv->abyBBVGA[0]);
+		vnt_set_vga_gain_offset(priv, priv->abyBBVGA[0]);
 		BBvUpdatePreEDThreshold(priv, false);
 	}
 
-- 
2.0.1

