Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:25459 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab0D1Guk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 02:50:40 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 3/4] wl1271: Rewrite hardware keep-alive handling
Date: Wed, 28 Apr 2010 09:50:01 +0300
Message-Id: <1272437402-28801-4-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1272437402-28801-1-git-send-email-luciano.coelho@nokia.com>
References: <1272437402-28801-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The driver had a join command without keep-alive restart procedures in the
channel changing code. After associated scans, the mac80211 does re-set the
current channel, causing the join to occur. This would stop the hardware
keep alive.

To make the joins safer in this respect, this patch adds a join function that
does the hardware-keep-alive magic along the join. This is now invoked in the
above mentioned scenario, and also other scenarios.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   91 +++++++++++++++--------------
 1 files changed, 46 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 26e8fb1..466106e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1118,14 +1118,13 @@ static void wl1271_configure_filters(struct wl1271 *wl, unsigned int filters)
 	}
 }
 
-static int wl1271_join_channel(struct wl1271 *wl, int channel)
+static int wl1271_dummy_join(struct wl1271 *wl)
 {
 	int ret = 0;
 	/* we need to use a dummy BSSID for now */
 	static const u8 dummy_bssid[ETH_ALEN] = { 0x0b, 0xad, 0xde,
 						  0xad, 0xbe, 0xef };
 
-	wl->channel = channel;
 	memcpy(wl->bssid, dummy_bssid, ETH_ALEN);
 
 	/* pass through frames from all BSS */
@@ -1141,7 +1140,47 @@ out:
 	return ret;
 }
 
-static int wl1271_unjoin_channel(struct wl1271 *wl)
+static int wl1271_join(struct wl1271 *wl)
+{
+	int ret;
+
+	ret = wl1271_cmd_join(wl, wl->set_bss_type);
+	if (ret < 0)
+		goto out;
+
+	set_bit(WL1271_FLAG_JOINED, &wl->flags);
+
+	if (!test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
+		goto out;
+
+	/*
+	 * The join command disable the keep-alive mode, shut down its process,
+	 * and also clear the template config, so we need to reset it all after
+	 * the join. The acx_aid starts the keep-alive process, and the order
+	 * of the commands below is relevant.
+	 */
+	ret = wl1271_acx_keep_alive_mode(wl, true);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_acx_aid(wl, wl->aid);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_cmd_build_klv_null_data(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_acx_keep_alive_config(wl, CMD_TEMPL_KLV_IDX_NULL_DATA,
+					   ACX_KEEP_ALIVE_TPL_VALID);
+	if (ret < 0)
+		goto out;
+
+out:
+	return ret;
+}
+
+static int wl1271_unjoin(struct wl1271 *wl)
 {
 	int ret;
 
@@ -1231,7 +1270,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 				       "failed %d", ret);
 
 		if (test_bit(WL1271_FLAG_JOINED, &wl->flags)) {
-			ret = wl1271_cmd_join(wl, wl->set_bss_type);
+			ret = wl1271_join(wl);
 			if (ret < 0)
 				wl1271_warning("cmd join to update channel "
 					       "failed %d", ret);
@@ -1241,9 +1280,9 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
 		if (conf->flags & IEEE80211_CONF_IDLE &&
 		    test_bit(WL1271_FLAG_JOINED, &wl->flags))
-			wl1271_unjoin_channel(wl);
+			wl1271_unjoin(wl);
 		else if (!(conf->flags & IEEE80211_CONF_IDLE))
-			wl1271_join_channel(wl, channel);
+			wl1271_dummy_join(wl);
 
 		if (conf->flags & IEEE80211_CONF_IDLE) {
 			wl->rate_set = wl1271_min_rate_get(wl);
@@ -1613,7 +1652,6 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	enum wl1271_cmd_ps_mode mode;
 	struct wl1271 *wl = hw->priv;
 	bool do_join = false;
-	bool do_keepalive = false;
 	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 bss info changed");
@@ -1756,19 +1794,6 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			ret = wl1271_cmd_build_probe_req(wl, NULL, 0,
 							 NULL, 0, wl->band);
 
-			/* Enable the keep-alive feature */
-			ret = wl1271_acx_keep_alive_mode(wl, true);
-			if (ret < 0)
-				goto out_sleep;
-
-			/*
-			 * This is awkward. The keep-alive configs must be done
-			 * *after* the join command, because otherwise it will
-			 * not work, but it must only be done *once* because
-			 * otherwise the firmware will start complaining.
-			 */
-			do_keepalive = true;
-
 			/* enable the connection monitoring feature */
 			ret = wl1271_acx_conn_monit_params(wl, true);
 			if (ret < 0)
@@ -1836,35 +1861,11 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (do_join) {
-		ret = wl1271_cmd_join(wl, wl->set_bss_type);
+		ret = wl1271_join(wl);
 		if (ret < 0) {
 			wl1271_warning("cmd join failed %d", ret);
 			goto out_sleep;
 		}
-		set_bit(WL1271_FLAG_JOINED, &wl->flags);
-	}
-
-	/*
-	 * The JOIN operation shuts down the firmware keep-alive as a side
-	 * effect, and the ACX_AID will start the keep-alive as a side effect.
-	 * Hence, for non-IBSS, the ACX_AID must always happen *after* the
-	 * JOIN operation, and the template config after the ACX_AID.
-	 */
-	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
-		ret = wl1271_acx_aid(wl, wl->aid);
-		if (ret < 0)
-			goto out_sleep;
-	}
-
-	if (do_keepalive) {
-		ret = wl1271_cmd_build_klv_null_data(wl);
-		if (ret < 0)
-			goto out_sleep;
-		ret = wl1271_acx_keep_alive_config(
-			wl, CMD_TEMPL_KLV_IDX_NULL_DATA,
-			ACX_KEEP_ALIVE_TPL_VALID);
-		if (ret < 0)
-			goto out_sleep;
 	}
 
 out_sleep:
-- 
1.6.3.3

