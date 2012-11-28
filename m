Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58463 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab2K1Jnd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:43:33 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so3507315wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 01:43:32 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 19/20] wl18xx: count HW block spare based correctly on keys
Date: Wed, 28 Nov 2012 11:42:48 +0200
Message-Id: <1354095769-8724-20-git-send-email-arik@wizery.com> (sfid-20121128_104351_639874_84D3B99F)
In-Reply-To: <1354095769-8724-1-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have no idea how many VIFs there are requiring a special spare, we
know just about the number of keys set. Rename the counter appropriately
and toggle it whenever a special key is added/removed.
Previously this was only changed once, since it was toggled whenever
the actual spare was changed.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c   |   56 +++++++++++++++++--------------
 drivers/net/wireless/ti/wl18xx/wl18xx.h |    4 +--
 2 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 5529c4b..e4fa3f9 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1052,7 +1052,7 @@ static int wl18xx_hw_init(struct wl1271 *wl)
 
 	/* (re)init private structures. Relevant on recovery as well. */
 	priv->last_fw_rls_idx = 0;
-	priv->extra_spare_vif_count = 0;
+	priv->extra_spare_key_count = 0;
 
 	/* set the default amount of spare blocks in the bitmap */
 	ret = wl18xx_set_host_cfg_bitmap(wl, WL18XX_TX_HW_BLOCK_SPARE);
@@ -1317,8 +1317,8 @@ static int wl18xx_get_spare_blocks(struct wl1271 *wl, bool is_gem)
 {
 	struct wl18xx_priv *priv = wl->priv;
 
-	/* If we have VIFs requiring extra spare, indulge them */
-	if (priv->extra_spare_vif_count)
+	/* If we have keys requiring extra spare, indulge them */
+	if (priv->extra_spare_key_count)
 		return WL18XX_TX_HW_EXTRA_BLOCK_SPARE;
 
 	return WL18XX_TX_HW_BLOCK_SPARE;
@@ -1330,42 +1330,48 @@ static int wl18xx_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 			  struct ieee80211_key_conf *key_conf)
 {
 	struct wl18xx_priv *priv = wl->priv;
-	bool change_spare = false;
+	bool change_spare = false, special_enc;
 	int ret;
 
+	wl1271_debug(DEBUG_CRYPT, "extra spare keys before: %d",
+		     priv->extra_spare_key_count);
+
+	special_enc = key_conf->cipher == WL1271_CIPHER_SUITE_GEM ||
+		      key_conf->cipher == WLAN_CIPHER_SUITE_TKIP;
+
+	ret = wlcore_set_key(wl, cmd, vif, sta, key_conf);
+	if (ret < 0)
+		goto out;
+
 	/*
-	 * when adding the first or removing the last GEM/TKIP interface,
+	 * when adding the first or removing the last GEM/TKIP key,
 	 * we have to adjust the number of spare blocks.
 	 */
-	change_spare = (key_conf->cipher == WL1271_CIPHER_SUITE_GEM ||
-		key_conf->cipher == WLAN_CIPHER_SUITE_TKIP) &&
-		((priv->extra_spare_vif_count == 0 && cmd == SET_KEY) ||
-		 (priv->extra_spare_vif_count == 1 && cmd == DISABLE_KEY));
+	if (special_enc) {
+		if (cmd == SET_KEY) {
+			/* first key */
+			change_spare = (priv->extra_spare_key_count == 0);
+			priv->extra_spare_key_count++;
+		} else if (cmd == DISABLE_KEY) {
+			/* last key */
+			change_spare = (priv->extra_spare_key_count == 1);
+			priv->extra_spare_key_count--;
+		}
+	}
 
-	/* no need to change spare - just regular set_key */
-	if (!change_spare)
-		return wlcore_set_key(wl, cmd, vif, sta, key_conf);
+	wl1271_debug(DEBUG_CRYPT, "extra spare keys after: %d",
+		     priv->extra_spare_key_count);
 
-	ret = wlcore_set_key(wl, cmd, vif, sta, key_conf);
-	if (ret < 0)
+	if (!change_spare)
 		goto out;
 
 	/* key is now set, change the spare blocks */
-	if (cmd == SET_KEY) {
+	if (priv->extra_spare_key_count)
 		ret = wl18xx_set_host_cfg_bitmap(wl,
 					WL18XX_TX_HW_EXTRA_BLOCK_SPARE);
-		if (ret < 0)
-			goto out;
-
-		priv->extra_spare_vif_count++;
-	} else {
+	else
 		ret = wl18xx_set_host_cfg_bitmap(wl,
 					WL18XX_TX_HW_BLOCK_SPARE);
-		if (ret < 0)
-			goto out;
-
-		priv->extra_spare_vif_count--;
-	}
 
 out:
 	return ret;
diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index 53bae22..a4c4374 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -49,8 +49,8 @@ struct wl18xx_priv {
 	/* Index of last released Tx desc in FW */
 	u8 last_fw_rls_idx;
 
-	/* number of VIFs requiring extra spare mem-blocks */
-	int extra_spare_vif_count;
+	/* number of keys requiring extra spare mem-blocks */
+	int extra_spare_key_count;
 };
 
 #define WL18XX_FW_MAX_TX_STATUS_DESC 33
-- 
1.7.9.5

