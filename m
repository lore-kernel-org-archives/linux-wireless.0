Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:52004 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaGPVXV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:23:21 -0400
Received: by mail-wg0-f52.google.com with SMTP id a1so1504415wgh.11
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:23:20 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/21] staging: vt6656: rename BBvUpdatePreEDThreshold to vnt_update_pre_ed_threshold
Date: Wed, 16 Jul 2014 22:21:58 +0100
Message-Id: <1405545731-6082-8-git-send-email-tvboxspy@gmail.com> (sfid-20140716_232327_168108_3B63E46E)
In-Reply-To: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
References: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dropping BB

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 2 +-
 drivers/staging/vt6656/baseband.h | 2 +-
 drivers/staging/vt6656/main_usb.c | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 39e2629..91c24a3 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -581,7 +581,7 @@ void vnt_exit_deep_sleep(struct vnt_private *priv)
 	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x0d, 0x01);/* CR13 */
 }
 
-void BBvUpdatePreEDThreshold(struct vnt_private *priv, int scanning)
+void vnt_update_pre_ed_threshold(struct vnt_private *priv, int scanning)
 {
 	u8 cr_201 = 0x0, cr_206 = 0x0;
 	u8 ed_inx = priv->byBBPreEDIndex;
diff --git a/drivers/staging/vt6656/baseband.h b/drivers/staging/vt6656/baseband.h
index aee51a1..771ea40 100644
--- a/drivers/staging/vt6656/baseband.h
+++ b/drivers/staging/vt6656/baseband.h
@@ -99,6 +99,6 @@ void vnt_set_antenna_mode(struct vnt_private *, u8);
 int vnt_vt3184_init(struct vnt_private *);
 void vnt_set_deep_sleep(struct vnt_private *);
 void vnt_exit_deep_sleep(struct vnt_private *);
-void BBvUpdatePreEDThreshold(struct vnt_private *, int scanning);
+void vnt_update_pre_ed_threshold(struct vnt_private *, int scanning);
 
 #endif /* __BASEBAND_H__ */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 695c541..e822572 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -882,7 +882,7 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 
 		vnt_set_short_slot_time(priv);
 		vnt_set_vga_gain_offset(priv, priv->abyBBVGA[0]);
-		BBvUpdatePreEDThreshold(priv, false);
+		vnt_update_pre_ed_threshold(priv, false);
 	}
 
 	if (changed & BSS_CHANGED_TXPOWER)
@@ -1003,7 +1003,7 @@ static void vnt_sw_scan_start(struct ieee80211_hw *hw)
 
 	vnt_set_bss_mode(priv);
 	/* Set max sensitivity*/
-	BBvUpdatePreEDThreshold(priv, true);
+	vnt_update_pre_ed_threshold(priv, true);
 }
 
 static void vnt_sw_scan_complete(struct ieee80211_hw *hw)
@@ -1011,7 +1011,7 @@ static void vnt_sw_scan_complete(struct ieee80211_hw *hw)
 	struct vnt_private *priv = hw->priv;
 
 	/* Return sensitivity to channel level*/
-	BBvUpdatePreEDThreshold(priv, false);
+	vnt_update_pre_ed_threshold(priv, false);
 }
 
 static int vnt_get_stats(struct ieee80211_hw *hw,
-- 
2.0.1

