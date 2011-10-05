Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35975 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932963Ab1JEJzt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:55:49 -0400
Received: by mail-ey0-f174.google.com with SMTP id 28so1405752eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:55:48 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 05/29] wl12xx: move rate_set into wlvif
Date: Wed,  5 Oct 2011 11:55:42 +0200
Message-Id: <1317808566-18857-6-git-send-email-eliad@wizery.com> (sfid-20111005_115553_223917_DA8D5622)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move rate_set into the per-interface data, rather than
being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c     |    6 +++---
 drivers/net/wireless/wl12xx/acx.h     |    2 +-
 drivers/net/wireless/wl12xx/cmd.c     |   12 ++++++------
 drivers/net/wireless/wl12xx/debugfs.c |    1 -
 drivers/net/wireless/wl12xx/init.c    |    6 +++---
 drivers/net/wireless/wl12xx/main.c    |   24 ++++++++++++------------
 drivers/net/wireless/wl12xx/wl12xx.h  |    9 ++++++++-
 7 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index ca044a7..1ef9b0b 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -739,7 +739,7 @@ int wl1271_acx_statistics(struct wl1271 *wl, struct acx_statistics *stats)
 	return 0;
 }
 
-int wl1271_acx_sta_rate_policies(struct wl1271 *wl)
+int wl1271_acx_sta_rate_policies(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct acx_rate_policy *acx;
 	struct conf_tx_rate_class *c = &wl->conf.tx.sta_rc_conf;
@@ -755,7 +755,7 @@ int wl1271_acx_sta_rate_policies(struct wl1271 *wl)
 	}
 
 	wl1271_debug(DEBUG_ACX, "basic_rate: 0x%x, full_rate: 0x%x",
-		wl->basic_rate, wl->rate_set);
+		wl->basic_rate, wlvif->rate_set);
 
 	/* configure one basic rate class */
 	acx->rate_policy_idx = cpu_to_le32(ACX_TX_BASIC_RATE);
@@ -772,7 +772,7 @@ int wl1271_acx_sta_rate_policies(struct wl1271 *wl)
 
 	/* configure one AP supported rate class */
 	acx->rate_policy_idx = cpu_to_le32(ACX_TX_AP_FULL_RATE);
-	acx->rate_policy.enabled_rates = cpu_to_le32(wl->rate_set);
+	acx->rate_policy.enabled_rates = cpu_to_le32(wlvif->rate_set);
 	acx->rate_policy.short_retry_limit = c->short_retry_limit;
 	acx->rate_policy.long_retry_limit = c->long_retry_limit;
 	acx->rate_policy.aflags = c->aflags;
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index e3f93b4..81779f4 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1261,7 +1261,7 @@ int wl1271_acx_set_preamble(struct wl1271 *wl, enum acx_preamble_type preamble);
 int wl1271_acx_cts_protect(struct wl1271 *wl,
 			   enum acx_ctsprotect_type ctsprotect);
 int wl1271_acx_statistics(struct wl1271 *wl, struct acx_statistics *stats);
-int wl1271_acx_sta_rate_policies(struct wl1271 *wl);
+int wl1271_acx_sta_rate_policies(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl1271_acx_ap_rate_policy(struct wl1271 *wl, struct conf_tx_rate_class *c,
 		      u8 idx);
 int wl1271_acx_ac_cfg(struct wl1271 *wl, u8 ac, u8 cw_min, u16 cw_max,
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index f28e429..2ae6799 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -578,7 +578,7 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->sta.ssid_len = wl->ssid_len;
 	memcpy(cmd->sta.ssid, wl->ssid, wl->ssid_len);
 	memcpy(cmd->sta.bssid, wl->bssid, ETH_ALEN);
-	cmd->sta.local_rates = cpu_to_le32(wl->rate_set);
+	cmd->sta.local_rates = cpu_to_le32(wlvif->rate_set);
 
 	if (wl->sta_hlid == WL12XX_INVALID_LINK_ID) {
 		ret = wl12xx_allocate_link(wl, &wl->sta_hlid);
@@ -587,12 +587,12 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	}
 	cmd->sta.hlid = wl->sta_hlid;
 	cmd->sta.session = wl12xx_get_new_session_id(wl);
-	cmd->sta.remote_rates = cpu_to_le32(wl->rate_set);
+	cmd->sta.remote_rates = cpu_to_le32(wlvif->rate_set);
 
 	wl1271_debug(DEBUG_CMD, "role start: roleid=%d, hlid=%d, session=%d "
 		     "basic_rate_set: 0x%x, remote_rates: 0x%x",
 		     wl->role_id, cmd->sta.hlid, cmd->sta.session,
-		     wlvif->basic_rate_set, wl->rate_set);
+		     wlvif->basic_rate_set, wlvif->rate_set);
 
 	ret = wl1271_cmd_send(wl, CMD_ROLE_START, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
@@ -792,7 +792,7 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->ibss.ssid_len = wl->ssid_len;
 	memcpy(cmd->ibss.ssid, wl->ssid, wl->ssid_len);
 	memcpy(cmd->ibss.bssid, wl->bssid, ETH_ALEN);
-	cmd->sta.local_rates = cpu_to_le32(wl->rate_set);
+	cmd->sta.local_rates = cpu_to_le32(wlvif->rate_set);
 
 	if (wl->sta_hlid == WL12XX_INVALID_LINK_ID) {
 		ret = wl12xx_allocate_link(wl, &wl->sta_hlid);
@@ -800,12 +800,12 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 			goto out_free;
 	}
 	cmd->ibss.hlid = wl->sta_hlid;
-	cmd->ibss.remote_rates = cpu_to_le32(wl->rate_set);
+	cmd->ibss.remote_rates = cpu_to_le32(wlvif->rate_set);
 
 	wl1271_debug(DEBUG_CMD, "role start: roleid=%d, hlid=%d, session=%d "
 		     "basic_rate_set: 0x%x, remote_rates: 0x%x",
 		     wl->role_id, cmd->sta.hlid, cmd->sta.session,
-		     wlvif->basic_rate_set, wl->rate_set);
+		     wlvif->basic_rate_set, wlvif->rate_set);
 
 	wl1271_debug(DEBUG_CMD, "wl->bssid = %pM", wl->bssid);
 
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 0419aaf..e63fea4 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -352,7 +352,6 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_INT(state);
 	DRIVER_STATE_PRINT_INT(bss_type);
 	DRIVER_STATE_PRINT_INT(channel);
-	DRIVER_STATE_PRINT_HEX(rate_set);
 	DRIVER_STATE_PRINT_HEX(basic_rate);
 	DRIVER_STATE_PRINT_INT(band);
 	DRIVER_STATE_PRINT_INT(beacon_int);
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index d9da36c..6e87e72 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -320,7 +320,7 @@ static int wl12xx_init_fwlog(struct wl1271 *wl)
 }
 
 /* generic sta initialization (non vif-specific) */
-static int wl1271_sta_hw_init(struct wl1271 *wl)
+static int wl1271_sta_hw_init(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	int ret;
 
@@ -345,7 +345,7 @@ static int wl1271_sta_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_acx_sta_rate_policies(wl);
+	ret = wl1271_acx_sta_rate_policies(wl, wlvif);
 	if (ret < 0)
 		return ret;
 
@@ -586,7 +586,7 @@ int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif)
 		if (ret < 0)
 			return ret;
 	} else {
-		ret = wl1271_sta_hw_init(wl);
+		ret = wl1271_sta_hw_init(wl, wlvif);
 		if (ret < 0)
 			return ret;
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index b1a3967..9afe8b9 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1840,6 +1840,7 @@ static u8 wl12xx_get_role_type(struct wl1271 *wl)
 static void wl12xx_init_vif_data(struct wl12xx_vif *wlvif)
 {
 	wlvif->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
+	wlvif->rate_set = CONF_TX_RATE_MASK_BASIC;
 }
 
 static int wl1271_op_add_interface(struct ieee80211_hw *hw,
@@ -2106,7 +2107,6 @@ deinit:
 	wl->tx_packets_count = 0;
 	wl->time_offset = 0;
 	wl->session_counter = 0;
-	wl->rate_set = CONF_TX_RATE_MASK_BASIC;
 	wl->bitrate_masks[IEEE80211_BAND_2GHZ] = wl->conf.tx.basic_rate;
 	wl->bitrate_masks[IEEE80211_BAND_5GHZ] = wl->conf.tx.basic_rate_5;
 	wl->vif = NULL;
@@ -2249,7 +2249,7 @@ out:
 static void wl1271_set_band_rate(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	wlvif->basic_rate_set = wl->bitrate_masks[wl->band];
-	wl->rate_set = wlvif->basic_rate_set;
+	wlvif->rate_set = wlvif->basic_rate_set;
 }
 
 static bool wl12xx_is_roc(struct wl1271 *wl)
@@ -2279,9 +2279,9 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			if (ret < 0)
 				goto out;
 		}
-		wl->rate_set = wl1271_tx_min_rate_get(wl,
-						      wlvif->basic_rate_set);
-		ret = wl1271_acx_sta_rate_policies(wl);
+		wlvif->rate_set =
+			wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
+		ret = wl1271_acx_sta_rate_policies(wl, wlvif);
 		if (ret < 0)
 			goto out;
 		ret = wl1271_acx_keep_alive_config(
@@ -2382,7 +2382,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 			wl->basic_rate =
 				wl1271_tx_min_rate_get(wl,
 						       wlvif->basic_rate_set);
-			ret = wl1271_acx_sta_rate_policies(wl);
+			ret = wl1271_acx_sta_rate_policies(wl, wlvif);
 			if (ret < 0)
 				wl1271_warning("rate policy for channel "
 					       "failed %d", ret);
@@ -3497,10 +3497,11 @@ sta_not_found:
 				wl1271_tx_min_rate_get(wl,
 						       wlvif->basic_rate_set);
 			if (sta_rate_set)
-				wl->rate_set = wl1271_tx_enabled_rates_get(wl,
+				wlvif->rate_set =
+					wl1271_tx_enabled_rates_get(wl,
 								sta_rate_set,
 								wl->band);
-			ret = wl1271_acx_sta_rate_policies(wl);
+			ret = wl1271_acx_sta_rate_policies(wl, wlvif);
 			if (ret < 0)
 				goto out;
 
@@ -3549,7 +3550,7 @@ sta_not_found:
 			wl->basic_rate =
 				wl1271_tx_min_rate_get(wl,
 						       wlvif->basic_rate_set);
-			ret = wl1271_acx_sta_rate_policies(wl);
+			ret = wl1271_acx_sta_rate_policies(wl, wlvif);
 			if (ret < 0)
 				goto out;
 
@@ -3607,8 +3608,8 @@ sta_not_found:
 						       wlvif->basic_rate_set);
 
 			/* by default, use 11b + OFDM rates */
-			wl->rate_set = CONF_TX_IBSS_DEFAULT_RATES;
-			ret = wl1271_acx_sta_rate_policies(wl);
+			wlvif->rate_set = CONF_TX_IBSS_DEFAULT_RATES;
+			ret = wl1271_acx_sta_rate_policies(wl, wlvif);
 			if (ret < 0)
 				goto out;
 		}
@@ -4803,7 +4804,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->psm_entry_retry = 0;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
 	wl->basic_rate = CONF_TX_RATE_MASK_BASIC;
-	wl->rate_set = CONF_TX_RATE_MASK_BASIC;
 	wl->band = IEEE80211_BAND_2GHZ;
 	wl->vif = NULL;
 	wl->flags = 0;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index d531e09..78e7320 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -525,7 +525,6 @@ struct wl1271 {
 	 * support only 1 stream, thus only 8 bits for the MCS rates (0-7).
 	 */
 	u32 basic_rate;
-	u32 rate_set;
 	u32 bitrate_masks[IEEE80211_NUM_BANDS];
 
 	/* The current band */
@@ -639,6 +638,14 @@ struct wl1271_station {
 
 struct wl12xx_vif {
 	u32 basic_rate_set;
+
+	/*
+	 * currently configured rate set:
+	 *	bits  0-15 - 802.11abg rates
+	 *	bits 16-23 - 802.11n   MCS index mask
+	 * support only 1 stream, thus only 8 bits for the MCS rates (0-7).
+	 */
+	u32 rate_set;
 };
 
 static inline struct wl12xx_vif *wl12xx_vif_to_data(struct ieee80211_vif *vif)
-- 
1.7.6.401.g6a319

