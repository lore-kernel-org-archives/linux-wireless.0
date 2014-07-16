Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:60986 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaGPVXO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:23:14 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so6958195wib.10
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:23:13 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/21] staging: vt6656: rename BBvSetShortSlotTime to vnt_set_short_slot_time
Date: Wed, 16 Jul 2014 22:21:54 +0100
Message-Id: <1405545731-6082-4-git-send-email-tvboxspy@gmail.com> (sfid-20140716_232325_898932_8FF6EB8E)
In-Reply-To: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
References: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dropping BB

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 2 +-
 drivers/staging/vt6656/baseband.h | 2 +-
 drivers/staging/vt6656/main_usb.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 44068d0..3138826 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -526,7 +526,7 @@ int vnt_vt3184_init(struct vnt_private *priv)
  * Return Value: none
  *
  */
-void BBvSetShortSlotTime(struct vnt_private *priv)
+void vnt_set_short_slot_time(struct vnt_private *priv)
 {
 	u8 bb_vga = 0;
 
diff --git a/drivers/staging/vt6656/baseband.h b/drivers/staging/vt6656/baseband.h
index f102ec0..1a36e13 100644
--- a/drivers/staging/vt6656/baseband.h
+++ b/drivers/staging/vt6656/baseband.h
@@ -93,7 +93,7 @@ unsigned int vnt_get_frame_time(u8 preamble_type, u8 pkt_type,
 void vnt_get_phy_field(struct vnt_private *, u32 frame_length,
 	u16 tx_rate, u8 pkt_type, struct vnt_phy_field *);
 
-void BBvSetShortSlotTime(struct vnt_private *);
+void vnt_set_short_slot_time(struct vnt_private *);
 void BBvSetVGAGainOffset(struct vnt_private *, u8 byData);
 void vnt_set_antenna_mode(struct vnt_private *, u8);
 int vnt_vt3184_init(struct vnt_private *);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index caafb93..a418d1d 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -441,7 +441,7 @@ static int device_init_registers(struct vnt_private *pDevice)
 	else
 		pDevice->bShortSlotTime = false;
 
-	BBvSetShortSlotTime(pDevice);
+	vnt_set_short_slot_time(pDevice);
 
 	pDevice->byRadioCtl = pDevice->abyEEPROM[EEP_OFS_RADIOCTL];
 	pDevice->bHWRadioOff = false;
@@ -880,7 +880,7 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 		else
 			priv->bShortSlotTime = false;
 
-		BBvSetShortSlotTime(priv);
+		vnt_set_short_slot_time(priv);
 		BBvSetVGAGainOffset(priv, priv->abyBBVGA[0]);
 		BBvUpdatePreEDThreshold(priv, false);
 	}
-- 
2.0.1

