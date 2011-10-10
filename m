Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62854 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab1JJINY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:13:24 -0400
Received: by mail-ww0-f44.google.com with SMTP id 22so8786663wwf.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:13:23 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 27/29] wl12xx: use dynamic rate policies
Date: Mon, 10 Oct 2011 10:13:15 +0200
Message-Id: <1318234397-21081-28-git-send-email-eliad@wizery.com> (sfid-20111010_101336_975088_4B26C915)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

allocate the rate policies dynamically, instead of using hardcoded
indexes. this is needed for proper multi-role configuration.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c    |    6 ++--
 drivers/net/wireless/wl12xx/acx.h    |    5 ---
 drivers/net/wireless/wl12xx/init.c   |    7 ++--
 drivers/net/wireless/wl12xx/main.c   |   52 ++++++++++++++++++++++++++++++---
 drivers/net/wireless/wl12xx/tx.c     |   10 +++---
 drivers/net/wireless/wl12xx/wl12xx.h |   12 ++++++++
 6 files changed, 71 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 21e74ca..e2e4670 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -766,7 +766,7 @@ int wl1271_acx_sta_rate_policies(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		wlvif->basic_rate, wlvif->rate_set);
 
 	/* configure one basic rate class */
-	acx->rate_policy_idx = cpu_to_le32(ACX_TX_BASIC_RATE);
+	acx->rate_policy_idx = cpu_to_le32(wlvif->sta.basic_rate_idx);
 	acx->rate_policy.enabled_rates = cpu_to_le32(wlvif->basic_rate);
 	acx->rate_policy.short_retry_limit = c->short_retry_limit;
 	acx->rate_policy.long_retry_limit = c->long_retry_limit;
@@ -779,7 +779,7 @@ int wl1271_acx_sta_rate_policies(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	}
 
 	/* configure one AP supported rate class */
-	acx->rate_policy_idx = cpu_to_le32(ACX_TX_AP_FULL_RATE);
+	acx->rate_policy_idx = cpu_to_le32(wlvif->sta.ap_rate_idx);
 	acx->rate_policy.enabled_rates = cpu_to_le32(wlvif->rate_set);
 	acx->rate_policy.short_retry_limit = c->short_retry_limit;
 	acx->rate_policy.long_retry_limit = c->long_retry_limit;
@@ -796,7 +796,7 @@ int wl1271_acx_sta_rate_policies(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	 * (p2p packets should always go out with OFDM rates, even
 	 * if we are currently connected to 11b AP)
 	 */
-	acx->rate_policy_idx = cpu_to_le32(ACX_TX_BASIC_RATE_P2P);
+	acx->rate_policy_idx = cpu_to_le32(wlvif->sta.p2p_rate_idx);
 	acx->rate_policy.enabled_rates =
 				cpu_to_le32(CONF_TX_RATE_MASK_BASIC_P2P);
 	acx->rate_policy.short_retry_limit = c->short_retry_limit;
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index c06119b..b2d85be 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -654,11 +654,6 @@ struct acx_rate_class {
 	u8 reserved;
 };
 
-#define ACX_TX_BASIC_RATE      0
-#define ACX_TX_AP_FULL_RATE    1
-#define ACX_TX_BASIC_RATE_P2P  2
-#define ACX_TX_AP_MODE_MGMT_RATE 4
-#define ACX_TX_AP_MODE_BCST_RATE 5
 struct acx_rate_policy {
 	struct acx_header header;
 
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 42a696b..a4e510a 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -434,7 +434,7 @@ int wl1271_init_ap_rates(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	rc.long_retry_limit = 10;
 	rc.short_retry_limit = 10;
 	rc.aflags = 0;
-	ret = wl1271_acx_ap_rate_policy(wl, &rc, ACX_TX_AP_MODE_MGMT_RATE);
+	ret = wl1271_acx_ap_rate_policy(wl, &rc, wlvif->ap.mgmt_rate_idx);
 	if (ret < 0)
 		return ret;
 
@@ -443,7 +443,7 @@ int wl1271_init_ap_rates(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	rc.short_retry_limit = 10;
 	rc.long_retry_limit = 10;
 	rc.aflags = 0;
-	ret = wl1271_acx_ap_rate_policy(wl, &rc, ACX_TX_AP_MODE_BCST_RATE);
+	ret = wl1271_acx_ap_rate_policy(wl, &rc, wlvif->ap.bcast_rate_idx);
 	if (ret < 0)
 		return ret;
 
@@ -465,7 +465,8 @@ int wl1271_init_ap_rates(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		rc.short_retry_limit = 10;
 		rc.long_retry_limit = 10;
 		rc.aflags = 0;
-		ret = wl1271_acx_ap_rate_policy(wl, &rc, i);
+		ret = wl1271_acx_ap_rate_policy(wl, &rc,
+						wlvif->ap.ucast_rate_idx[i]);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index da89ff2..20a2a4b 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1910,6 +1910,27 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	mutex_unlock(&wl->mutex);
 }
 
+static int wl12xx_allocate_rate_policy(struct wl1271 *wl, u8 *idx)
+{
+	u8 policy = find_first_zero_bit(wl->rate_policies_map,
+					WL12XX_MAX_RATE_POLICIES);
+	if (policy >= WL12XX_MAX_RATE_POLICIES)
+		return -EBUSY;
+
+	__set_bit(policy, wl->rate_policies_map);
+	*idx = policy;
+	return 0;
+}
+
+static void wl12xx_free_rate_policy(struct wl1271 *wl, u8 *idx)
+{
+	if (WARN_ON(*idx >= WL12XX_MAX_RATE_POLICIES))
+		return;
+
+	__clear_bit(*idx, wl->rate_policies_map);
+	*idx = WL12XX_MAX_RATE_POLICIES;
+}
+
 static u8 wl12xx_get_role_type(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	switch (wlvif->bss_type) {
@@ -1937,6 +1958,7 @@ static u8 wl12xx_get_role_type(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 {
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	int i;
 
 	/* clear everything but the persistent data */
 	memset(wlvif, 0, offsetof(struct wl12xx_vif, persistent));
@@ -1970,11 +1992,18 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 	    wlvif->bss_type == BSS_TYPE_IBSS) {
 		/* init sta/ibss data */
 		wlvif->sta.hlid = WL12XX_INVALID_LINK_ID;
-
+		wl12xx_allocate_rate_policy(wl, &wlvif->sta.basic_rate_idx);
+		wl12xx_allocate_rate_policy(wl, &wlvif->sta.ap_rate_idx);
+		wl12xx_allocate_rate_policy(wl, &wlvif->sta.p2p_rate_idx);
 	} else {
 		/* init ap data */
 		wlvif->ap.bcast_hlid = WL12XX_INVALID_LINK_ID;
 		wlvif->ap.global_hlid = WL12XX_INVALID_LINK_ID;
+		wl12xx_allocate_rate_policy(wl, &wlvif->ap.mgmt_rate_idx);
+		wl12xx_allocate_rate_policy(wl, &wlvif->ap.bcast_rate_idx);
+		for (i = 0; i < CONF_TX_MAX_AC_COUNT; i++)
+			wl12xx_allocate_rate_policy(wl,
+						&wlvif->ap.ucast_rate_idx[i]);
 	}
 
 	wlvif->bitrate_masks[IEEE80211_BAND_2GHZ] = wl->conf.tx.basic_rate;
@@ -2176,7 +2205,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 					 bool reset_tx_queues)
 {
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
-	int ret;
+	int i, ret;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 remove interface");
 
@@ -2222,10 +2251,23 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	}
 deinit:
 	/* clear all hlids (except system_hlid) */
-	wlvif->sta.hlid = WL12XX_INVALID_LINK_ID;
 	wlvif->dev_hlid = WL12XX_INVALID_LINK_ID;
-	wlvif->ap.bcast_hlid = WL12XX_INVALID_LINK_ID;
-	wlvif->ap.global_hlid = WL12XX_INVALID_LINK_ID;
+
+	if (wlvif->bss_type == BSS_TYPE_STA_BSS ||
+	    wlvif->bss_type == BSS_TYPE_IBSS) {
+		wlvif->sta.hlid = WL12XX_INVALID_LINK_ID;
+		wl12xx_free_rate_policy(wl, &wlvif->sta.basic_rate_idx);
+		wl12xx_free_rate_policy(wl, &wlvif->sta.ap_rate_idx);
+		wl12xx_free_rate_policy(wl, &wlvif->sta.p2p_rate_idx);
+	} else {
+		wlvif->ap.bcast_hlid = WL12XX_INVALID_LINK_ID;
+		wlvif->ap.global_hlid = WL12XX_INVALID_LINK_ID;
+		wl12xx_free_rate_policy(wl, &wlvif->ap.mgmt_rate_idx);
+		wl12xx_free_rate_policy(wl, &wlvif->ap.bcast_rate_idx);
+		for (i = 0; i < CONF_TX_MAX_AC_COUNT; i++)
+			wl12xx_free_rate_policy(wl,
+						&wlvif->ap.ucast_rate_idx[i]);
+	}
 
 	wl12xx_tx_reset_wlvif(wl, wlvif);
 	wl1271_free_ap_keys(wl, wlvif);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index a0eefe7..f434331 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -339,16 +339,16 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		   send them with AP rate policies, otherwise use default
 		   basic rates */
 		if (control->control.sta)
-			rate_idx = ACX_TX_AP_FULL_RATE;
+			rate_idx = wlvif->sta.ap_rate_idx;
 		else
-			rate_idx = ACX_TX_BASIC_RATE;
+			rate_idx = wlvif->sta.basic_rate_idx;
 	} else {
 		if (hlid == wlvif->ap.global_hlid)
-			rate_idx = ACX_TX_AP_MODE_MGMT_RATE;
+			rate_idx = wlvif->ap.mgmt_rate_idx;
 		else if (hlid == wlvif->ap.bcast_hlid)
-			rate_idx = ACX_TX_AP_MODE_BCST_RATE;
+			rate_idx = wlvif->ap.bcast_rate_idx;
 		else
-			rate_idx = ac;
+			rate_idx = wlvif->ap.ucast_rate_idx[ac];
 	}
 
 	tx_attr |= rate_idx << TX_HW_ATTR_OFST_RATE_POLICY;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 0f1dfd2..3673994 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -142,6 +142,8 @@ extern u32 wl12xx_debug_level;
 #define WL12XX_INVALID_ROLE_ID     0xff
 #define WL12XX_INVALID_LINK_ID     0xff
 
+#define WL12XX_MAX_RATE_POLICIES 16
+
 /* Defined by FW as 0. Will not be freed or allocated. */
 #define WL12XX_SYSTEM_HLID         0
 
@@ -396,6 +398,8 @@ struct wl1271 {
 	unsigned long links_map[BITS_TO_LONGS(WL12XX_MAX_LINKS)];
 	unsigned long roles_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
 	unsigned long roc_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
+	unsigned long rate_policies_map[
+			BITS_TO_LONGS(WL12XX_MAX_RATE_POLICIES)];
 
 	struct list_head wlvif_list;
 
@@ -567,6 +571,10 @@ struct wl12xx_vif {
 		struct {
 			u8 hlid;
 			u8 ba_rx_bitmap;
+
+			u8 basic_rate_idx;
+			u8 ap_rate_idx;
+			u8 p2p_rate_idx;
 		} sta;
 		struct {
 			u8 global_hlid;
@@ -578,6 +586,10 @@ struct wl12xx_vif {
 
 			/* recoreded keys - set here before AP startup */
 			struct wl1271_ap_key *recorded_keys[MAX_NUM_KEYS];
+
+			u8 mgmt_rate_idx;
+			u8 bcast_rate_idx;
+			u8 ucast_rate_idx[CONF_TX_MAX_AC_COUNT];
 		} ap;
 	};
 
-- 
1.7.6.401.g6a319

