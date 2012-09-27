Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:41691 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab2I0Kip (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:45 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 26/31] wlcore: use dynamic keep-alive template ids
Date: Thu, 27 Sep 2012 13:38:04 +0300
Message-Id: <1348742289-6587-27-git-send-email-luca@coelho.fi> (sfid-20120927_123928_734165_F14472A0)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Currently, all the (station) roles use the same
keep-alive template id (0). However, the klv
template ids shouldn't be shared by different
roles.

Implement a simple klv_templates bitmap, and let
each role allocate its own klv template id on
role initialization.

[Arik - remove invalidation of KLV template when getting into "idle".
This is already handled in unjoin]

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wlcore/cmd.c      |    2 +-
 drivers/net/wireless/ti/wlcore/cmd.h      |    5 -----
 drivers/net/wireless/ti/wlcore/init.c     |   12 ++---------
 drivers/net/wireless/ti/wlcore/main.c     |   32 ++++++++++++++++++++++-------
 drivers/net/wireless/ti/wlcore/wlcore.h   |    2 ++
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    3 +++
 6 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 4c07a5b..eaef3f4 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -993,7 +993,7 @@ int wl12xx_cmd_build_klv_null_data(struct wl1271 *wl,
 
 	ret = wl1271_cmd_template_set(wl, wlvif->role_id, CMD_TEMPL_KLV,
 				      skb->data, skb->len,
-				      CMD_TEMPL_KLV_IDX_NULL_DATA,
+				      wlvif->sta.klv_template_id,
 				      wlvif->basic_rate);
 
 out:
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index 4ef0b09..2409f3d 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -157,11 +157,6 @@ enum wl1271_commands {
 
 #define MAX_CMD_PARAMS 572
 
-enum {
-	CMD_TEMPL_KLV_IDX_NULL_DATA = 0,
-	CMD_TEMPL_KLV_IDX_MAX = 4
-};
-
 enum cmd_templ {
 	CMD_TEMPL_NULL_DATA = 0,
 	CMD_TEMPL_BEACON,
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index a3c8677..32d157f 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -141,7 +141,7 @@ int wl1271_init_templates_config(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	for (i = 0; i < CMD_TEMPL_KLV_IDX_MAX; i++) {
+	for (i = 0; i < WLCORE_MAX_KLV_TEMPLATES; i++) {
 		ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
 					      CMD_TEMPL_KLV, NULL,
 					      sizeof(struct ieee80211_qos_hdr),
@@ -371,15 +371,7 @@ static int wl1271_sta_hw_init_post_mem(struct wl1271 *wl,
 				       struct ieee80211_vif *vif)
 {
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
-	int ret, i;
-
-	/* disable all keep-alive templates */
-	for (i = 0; i < CMD_TEMPL_KLV_IDX_MAX; i++) {
-		ret = wl1271_acx_keep_alive_config(wl, wlvif, i,
-						   ACX_KEEP_ALIVE_TPL_INVALID);
-		if (ret < 0)
-			return ret;
-	}
+	int ret;
 
 	/* disable the keep-alive feature */
 	ret = wl1271_acx_keep_alive_mode(wl, wlvif, false);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 7c04b0b..419c399 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1965,6 +1965,27 @@ static void wl12xx_free_rate_policy(struct wl1271 *wl, u8 *idx)
 	*idx = WL12XX_MAX_RATE_POLICIES;
 }
 
+static int wlcore_allocate_klv_template(struct wl1271 *wl, u8 *idx)
+{
+	u8 policy = find_first_zero_bit(wl->klv_templates_map,
+					WLCORE_MAX_KLV_TEMPLATES);
+	if (policy >= WLCORE_MAX_KLV_TEMPLATES)
+		return -EBUSY;
+
+	__set_bit(policy, wl->klv_templates_map);
+	*idx = policy;
+	return 0;
+}
+
+static void wlcore_free_klv_template(struct wl1271 *wl, u8 *idx)
+{
+	if (WARN_ON(*idx >= WLCORE_MAX_KLV_TEMPLATES))
+		return;
+
+	__clear_bit(*idx, wl->klv_templates_map);
+	*idx = WLCORE_MAX_KLV_TEMPLATES;
+}
+
 static u8 wl12xx_get_role_type(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	switch (wlvif->bss_type) {
@@ -2029,6 +2050,7 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 		wl12xx_allocate_rate_policy(wl, &wlvif->sta.basic_rate_idx);
 		wl12xx_allocate_rate_policy(wl, &wlvif->sta.ap_rate_idx);
 		wl12xx_allocate_rate_policy(wl, &wlvif->sta.p2p_rate_idx);
+		wlcore_allocate_klv_template(wl, &wlvif->sta.klv_template_id);
 		wlvif->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
 		wlvif->basic_rate = CONF_TX_RATE_MASK_BASIC;
 		wlvif->rate_set = CONF_TX_RATE_MASK_BASIC;
@@ -2360,6 +2382,7 @@ deinit:
 		wl12xx_free_rate_policy(wl, &wlvif->sta.basic_rate_idx);
 		wl12xx_free_rate_policy(wl, &wlvif->sta.ap_rate_idx);
 		wl12xx_free_rate_policy(wl, &wlvif->sta.p2p_rate_idx);
+		wlcore_free_klv_template(wl, &wlvif->sta.klv_template_id);
 	} else {
 		wlvif->ap.bcast_hlid = WL12XX_INVALID_LINK_ID;
 		wlvif->ap.global_hlid = WL12XX_INVALID_LINK_ID;
@@ -2524,7 +2547,7 @@ static int wl1271_join(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		goto out;
 
 	ret = wl1271_acx_keep_alive_config(wl, wlvif,
-					   CMD_TEMPL_KLV_IDX_NULL_DATA,
+					   wlvif->sta.klv_template_id,
 					   ACX_KEEP_ALIVE_TPL_VALID);
 	if (ret < 0)
 		goto out;
@@ -2546,7 +2569,7 @@ static int wl1271_unjoin(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 	/* invalidate keep-alive template */
 	wl1271_acx_keep_alive_config(wl, wlvif,
-				     CMD_TEMPL_KLV_IDX_NULL_DATA,
+				     wlvif->sta.klv_template_id,
 				     ACX_KEEP_ALIVE_TPL_INVALID);
 
 	/* to stop listening to a channel, we disconnect */
@@ -2589,11 +2612,6 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		ret = wl1271_acx_sta_rate_policies(wl, wlvif);
 		if (ret < 0)
 			goto out;
-		ret = wl1271_acx_keep_alive_config(
-			wl, wlvif, CMD_TEMPL_KLV_IDX_NULL_DATA,
-			ACX_KEEP_ALIVE_TPL_INVALID);
-		if (ret < 0)
-			goto out;
 		clear_bit(WLVIF_FLAG_IN_USE, &wlvif->flags);
 	} else {
 		/* The current firmware only supports sched_scan in idle */
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 165afae..8ad5f37 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -196,6 +196,8 @@ struct wl1271 {
 	unsigned long roc_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
 	unsigned long rate_policies_map[
 			BITS_TO_LONGS(WL12XX_MAX_RATE_POLICIES)];
+	unsigned long klv_templates_map[
+			BITS_TO_LONGS(WLCORE_MAX_KLV_TEMPLATES)];
 
 	struct list_head wlvif_list;
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 496e7c6..6678d4b 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -66,6 +66,7 @@
 #define WLCORE_NUM_BANDS           2
 
 #define WL12XX_MAX_RATE_POLICIES 16
+#define WLCORE_MAX_KLV_TEMPLATES 4
 
 /* Defined by FW as 0. Will not be freed or allocated. */
 #define WL12XX_SYSTEM_HLID         0
@@ -337,6 +338,8 @@ struct wl12xx_vif {
 			u8 ap_rate_idx;
 			u8 p2p_rate_idx;
 
+			u8 klv_template_id;
+
 			bool qos;
 		} sta;
 		struct {
-- 
1.7.10.4

