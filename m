Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38312 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab2EREqs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 00:46:48 -0400
Received: by wgbdr13 with SMTP id dr13so2395245wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 21:46:47 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/5] wlcore/wl12xx/wl18xx: introduce quirk to remove TKIP header space
Date: Fri, 18 May 2012 07:46:36 +0300
Message-Id: <1337316400-23875-2-git-send-email-arik@wizery.com> (sfid-20120518_064651_716205_A959DB75)
In-Reply-To: <1337316400-23875-1-git-send-email-arik@wizery.com>
References: <1337316400-23875-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

18xx chips do not require extra space in the TKIP header. Introduce a
new HW quirk to allow us to make this feature arch-specific. 12xx chip
will now have this quirk.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    7 +++++--
 drivers/net/wireless/ti/wl18xx/tx.c     |    3 ++-
 drivers/net/wireless/ti/wlcore/cmd.c    |    5 +++--
 drivers/net/wireless/ti/wlcore/main.c   |    8 +++++---
 drivers/net/wireless/ti/wlcore/tx.c     |    9 ++++++---
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 +++
 6 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 522c898..982cb20 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -632,7 +632,8 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		/* clear the alignment quirk, since we don't support it */
 		wl->quirks &= ~WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN;
 
-		wl->quirks |= WLCORE_QUIRK_LEGACY_NVS;
+		wl->quirks |= WLCORE_QUIRK_LEGACY_NVS |
+			      WLCORE_QUIRK_TKIP_HEADER_SPACE;
 		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
 		wl->mr_fw_name = WL127X_FW_NAME_MULTI;
 		memcpy(&wl->conf.mem, &wl12xx_default_priv_conf.mem_wl127x,
@@ -650,7 +651,8 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		/* clear the alignment quirk, since we don't support it */
 		wl->quirks &= ~WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN;
 
-		wl->quirks |= WLCORE_QUIRK_LEGACY_NVS;
+		wl->quirks |= WLCORE_QUIRK_LEGACY_NVS |
+			      WLCORE_QUIRK_TKIP_HEADER_SPACE;
 		wl->plt_fw_name = WL127X_PLT_FW_NAME;
 		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
 		wl->mr_fw_name = WL127X_FW_NAME_MULTI;
@@ -665,6 +667,7 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 	case CHIP_ID_1283_PG20:
 		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (1283 PG20)",
 			     wl->chip.id);
+		wl->quirks |= WLCORE_QUIRK_TKIP_HEADER_SPACE;
 		wl->plt_fw_name = WL128X_PLT_FW_NAME;
 		wl->sr_fw_name = WL128X_FW_NAME_SINGLE;
 		wl->mr_fw_name = WL128X_FW_NAME_MULTI;
diff --git a/drivers/net/wireless/ti/wl18xx/tx.c b/drivers/net/wireless/ti/wl18xx/tx.c
index 4de00b9..5b1fb10 100644
--- a/drivers/net/wireless/ti/wl18xx/tx.c
+++ b/drivers/net/wireless/ti/wl18xx/tx.c
@@ -75,7 +75,8 @@ static void wl18xx_tx_complete_packet(struct wl1271 *wl, u8 tx_stat_byte)
 	skb_pull(skb, sizeof(struct wl1271_tx_hw_descr));
 
 	/* remove TKIP header space if present */
-	if (info->control.hw_key &&
+	if ((wl->quirks & WLCORE_QUIRK_TKIP_HEADER_SPACE) &&
+	    info->control.hw_key &&
 	    info->control.hw_key->cipher == WLAN_CIPHER_SUITE_TKIP) {
 		int hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 		memmove(skb->data + WL1271_EXTRA_SPACE_TKIP, skb->data, hdrlen);
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index df8d672..885364c 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1046,7 +1046,7 @@ out:
 
 int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
-	int ret, extra;
+	int ret, extra = 0;
 	u16 fc;
 	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 	struct sk_buff *skb;
@@ -1085,7 +1085,8 @@ int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	/* encryption space */
 	switch (wlvif->encryption_type) {
 	case KEY_TKIP:
-		extra = WL1271_EXTRA_SPACE_TKIP;
+		if (wl->quirks & WLCORE_QUIRK_TKIP_HEADER_SPACE)
+			extra = WL1271_EXTRA_SPACE_TKIP;
 		break;
 	case KEY_AES:
 		extra = WL1271_EXTRA_SPACE_AES;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 0dc3ae3..d6e6509 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4978,9 +4978,11 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 		WL1271_CIPHER_SUITE_GEM,
 	};
 
-	/* The tx descriptor buffer and the TKIP space. */
-	wl->hw->extra_tx_headroom = WL1271_EXTRA_SPACE_TKIP +
-		sizeof(struct wl1271_tx_hw_descr);
+	/* The tx descriptor buffer */
+	wl->hw->extra_tx_headroom = sizeof(struct wl1271_tx_hw_descr);
+
+	if (wl->quirks & WLCORE_QUIRK_TKIP_HEADER_SPACE)
+		wl->hw->extra_tx_headroom += WL1271_EXTRA_SPACE_TKIP;
 
 	/* unit us */
 	/* FIXME: find a proper value */
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index e8a2998..6b68e29 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -358,7 +358,8 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	/* TODO: handle dummy packets on multi-vifs */
 	is_dummy = wl12xx_is_dummy_packet(wl, skb);
 
-	if (info->control.hw_key &&
+	if ((wl->quirks & WLCORE_QUIRK_TKIP_HEADER_SPACE) &&
+	    info->control.hw_key &&
 	    info->control.hw_key->cipher == WLAN_CIPHER_SUITE_TKIP)
 		extra = WL1271_EXTRA_SPACE_TKIP;
 
@@ -852,7 +853,8 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 	skb_pull(skb, sizeof(struct wl1271_tx_hw_descr));
 
 	/* remove TKIP header space if present */
-	if (info->control.hw_key &&
+	if ((wl->quirks & WLCORE_QUIRK_TKIP_HEADER_SPACE) &&
+	    info->control.hw_key &&
 	    info->control.hw_key->cipher == WLAN_CIPHER_SUITE_TKIP) {
 		int hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 		memmove(skb->data + WL1271_EXTRA_SPACE_TKIP, skb->data,
@@ -1001,7 +1003,8 @@ void wl12xx_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
 			 */
 			info = IEEE80211_SKB_CB(skb);
 			skb_pull(skb, sizeof(struct wl1271_tx_hw_descr));
-			if (info->control.hw_key &&
+			if ((wl->quirks & WLCORE_QUIRK_TKIP_HEADER_SPACE) &&
+			    info->control.hw_key &&
 			    info->control.hw_key->cipher ==
 			    WLAN_CIPHER_SUITE_TKIP) {
 				int hdrlen = ieee80211_get_hdrlen_from_skb(skb);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 001777a..5a35a33 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -412,6 +412,9 @@ int wlcore_free_hw(struct wl1271 *wl);
 /* Some firmwares may not support ELP */
 #define WLCORE_QUIRK_NO_ELP			BIT(6)
 
+/* extra header space is required for TKIP */
+#define WLCORE_QUIRK_TKIP_HEADER_SPACE		BIT(8)
+
 /* TODO: move to the lower drivers when all usages are abstracted */
 #define CHIP_ID_1271_PG10              (0x4030101)
 #define CHIP_ID_1271_PG20              (0x4030111)
-- 
1.7.9.5

