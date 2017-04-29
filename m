Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33664 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426783AbdD2MEI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Apr 2017 08:04:08 -0400
Received: by mail-wm0-f68.google.com with SMTP id y10so15609324wmh.0
        for <linux-wireless@vger.kernel.org>; Sat, 29 Apr 2017 05:04:08 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/4] staging: vt6656: Only call vnt_set_bss_mode on basic rates change.
Date: Sat, 29 Apr 2017 13:03:45 +0100
Message-Id: <20170429120345.3782-4-tvboxspy@gmail.com> (sfid-20170429_140418_239597_6FC39C1F)
In-Reply-To: <20170429120345.3782-1-tvboxspy@gmail.com>
References: <20170429120345.3782-1-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To ensure the bss is always synchronized only call on basic rate
change.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 06f7841d44d3..095b85567306 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -637,7 +637,6 @@ static int vnt_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct vnt_private *priv = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
-	u8 bb_type;
 
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
 		if (conf->flags & IEEE80211_CONF_PS)
@@ -651,15 +650,9 @@ static int vnt_config(struct ieee80211_hw *hw, u32 changed)
 		vnt_set_channel(priv, conf->chandef.chan->hw_value);
 
 		if (conf->chandef.chan->band == NL80211_BAND_5GHZ)
-			bb_type = BB_TYPE_11A;
+			priv->bb_type = BB_TYPE_11A;
 		else
-			bb_type = BB_TYPE_11G;
-
-		if (priv->bb_type != bb_type) {
-			priv->bb_type = bb_type;
-
-			vnt_set_bss_mode(priv);
-		}
+			priv->bb_type = BB_TYPE_11G;
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
@@ -690,6 +683,7 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 		priv->basic_rates = conf->basic_rates;
 
 		vnt_update_top_rates(priv);
+		vnt_set_bss_mode(priv);
 
 		dev_dbg(&priv->usb->dev, "basic rates %x\n", conf->basic_rates);
 	}
@@ -850,7 +844,6 @@ static void vnt_sw_scan_start(struct ieee80211_hw *hw,
 {
 	struct vnt_private *priv = hw->priv;
 
-	vnt_set_bss_mode(priv);
 	/* Set max sensitivity*/
 	vnt_update_pre_ed_threshold(priv, true);
 }
-- 
2.11.0
