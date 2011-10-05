Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45334 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934315Ab1JEJ4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:56:33 -0400
Received: by mail-ey0-f174.google.com with SMTP id 28so1406494eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:56:32 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 29/29] wl12xx: move recorded_ap_keys into wlvif
Date: Wed,  5 Oct 2011 11:56:06 +0200
Message-Id: <1317808566-18857-30-git-send-email-eliad@wizery.com> (sfid-20111005_115638_078200_AAC646E9)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move recorded_ap_keys into the per-interface data, rather than
being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   31 ++++++++++++++++---------------
 drivers/net/wireless/wl12xx/wl12xx.h |    6 +++---
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 6deb507..2eeb4e2 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -379,7 +379,7 @@ static bool bug_on_recovery;
 static void __wl1271_op_remove_interface(struct wl1271 *wl,
 					 struct ieee80211_vif *vif,
 					 bool reset_tx_queues);
-static void wl1271_free_ap_keys(struct wl1271 *wl);
+static void wl1271_free_ap_keys(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 
 
 static void wl1271_device_release(struct device *dev)
@@ -2132,7 +2132,7 @@ deinit:
 	wl->bitrate_masks[IEEE80211_BAND_5GHZ] = wl->conf.tx.basic_rate_5;
 	wl->vif = NULL;
 	wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
-	wl1271_free_ap_keys(wl);
+	wl1271_free_ap_keys(wl, wlvif);
 	memset(wlvif->ap.sta_hlid_map, 0, sizeof(wlvif->ap.sta_hlid_map));
 	wl->ap_fw_ps_map = 0;
 	wl->ap_ps_map = 0;
@@ -2598,9 +2598,10 @@ out:
 	kfree(fp);
 }
 
-static int wl1271_record_ap_key(struct wl1271 *wl, u8 id, u8 key_type,
-			u8 key_size, const u8 *key, u8 hlid, u32 tx_seq_32,
-			u16 tx_seq_16)
+static int wl1271_record_ap_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				u8 id, u8 key_type, u8 key_size,
+				const u8 *key, u8 hlid, u32 tx_seq_32,
+				u16 tx_seq_16)
 {
 	struct wl1271_ap_key *ap_key;
 	int i;
@@ -2615,10 +2616,10 @@ static int wl1271_record_ap_key(struct wl1271 *wl, u8 id, u8 key_type,
 	 * an existing key.
 	 */
 	for (i = 0; i < MAX_NUM_KEYS; i++) {
-		if (wl->recorded_ap_keys[i] == NULL)
+		if (wlvif->ap.recorded_keys[i] == NULL)
 			break;
 
-		if (wl->recorded_ap_keys[i]->id == id) {
+		if (wlvif->ap.recorded_keys[i]->id == id) {
 			wl1271_warning("trying to record key replacement");
 			return -EINVAL;
 		}
@@ -2639,17 +2640,17 @@ static int wl1271_record_ap_key(struct wl1271 *wl, u8 id, u8 key_type,
 	ap_key->tx_seq_32 = tx_seq_32;
 	ap_key->tx_seq_16 = tx_seq_16;
 
-	wl->recorded_ap_keys[i] = ap_key;
+	wlvif->ap.recorded_keys[i] = ap_key;
 	return 0;
 }
 
-static void wl1271_free_ap_keys(struct wl1271 *wl)
+static void wl1271_free_ap_keys(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	int i;
 
 	for (i = 0; i < MAX_NUM_KEYS; i++) {
-		kfree(wl->recorded_ap_keys[i]);
-		wl->recorded_ap_keys[i] = NULL;
+		kfree(wlvif->ap.recorded_keys[i]);
+		wlvif->ap.recorded_keys[i] = NULL;
 	}
 }
 
@@ -2661,10 +2662,10 @@ static int wl1271_ap_init_hwenc(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 	for (i = 0; i < MAX_NUM_KEYS; i++) {
 		u8 hlid;
-		if (wl->recorded_ap_keys[i] == NULL)
+		if (wlvif->ap.recorded_keys[i] == NULL)
 			break;
 
-		key = wl->recorded_ap_keys[i];
+		key = wlvif->ap.recorded_keys[i];
 		hlid = key->hlid;
 		if (hlid == WL12XX_INVALID_LINK_ID)
 			hlid = wlvif->ap.bcast_hlid;
@@ -2689,7 +2690,7 @@ static int wl1271_ap_init_hwenc(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	}
 
 out:
-	wl1271_free_ap_keys(wl);
+	wl1271_free_ap_keys(wl, wlvif);
 	return ret;
 }
 
@@ -2720,7 +2721,7 @@ static int wl1271_set_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			if (action != KEY_ADD_OR_REPLACE)
 				return 0;
 
-			ret = wl1271_record_ap_key(wl, id,
+			ret = wl1271_record_ap_key(wl, wlvif, id,
 					     key_type, key_size,
 					     key, hlid, tx_seq_32,
 					     tx_seq_16);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 1b5320a..2b1c2e9 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -523,9 +523,6 @@ struct wl1271 {
 	/* Most recently reported noise in dBm */
 	s8 noise;
 
-	/* recoreded keys for AP-mode - set here before AP startup */
-	struct wl1271_ap_key *recorded_ap_keys[MAX_NUM_KEYS];
-
 	/* bands supported by this instance of wl12xx */
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 
@@ -592,6 +589,9 @@ struct wl12xx_vif {
 			/* HLIDs bitmap of associated stations */
 			unsigned long sta_hlid_map[BITS_TO_LONGS(
 							WL12XX_MAX_LINKS)];
+
+			/* recoreded keys - set here before AP startup */
+			struct wl1271_ap_key *recorded_keys[MAX_NUM_KEYS];
 		} ap;
 	};
 
-- 
1.7.6.401.g6a319

