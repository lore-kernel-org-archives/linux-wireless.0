Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:55855 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1A3STd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 13:19:33 -0500
Message-ID: <4D45A5DE.70507@davizone.at>
Date: Sun, 30 Jan 2011 18:54:38 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH 11/18] wl1251: configure hardware en-/decryption for monitor
 mode
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disable hardware encryption (DF_ENCRYPTION_DISABLE) and decryption
(DF_SNIFF_MODE_ENABLE) via wl1251_acx_feature_cfg while monitor interface is
present.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
 drivers/net/wireless/wl1251/acx.c    |    6 +++---
 drivers/net/wireless/wl1251/acx.h    |    2 +-
 drivers/net/wireless/wl1251/init.c   |    2 +-
 drivers/net/wireless/wl1251/main.c   |   34 +++++++++++++++++++++++++++++-----
 drivers/net/wireless/wl1251/rx.c     |    2 +-
 drivers/net/wireless/wl1251/tx.c     |    3 +++
 drivers/net/wireless/wl1251/wl1251.h |    1 +
 7 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl1251/acx.c b/drivers/net/wireless/wl1251/acx.c
index 0a1c22a..b002cfa 100644
--- a/drivers/net/wireless/wl1251/acx.c
+++ b/drivers/net/wireless/wl1251/acx.c
@@ -211,7 +211,7 @@ out:
 	return ret;
 }
 -int wl1251_acx_feature_cfg(struct wl1251 *wl)
+int wl1251_acx_feature_cfg(struct wl1251 *wl, u32 data_flow_options)
 {
 	struct acx_feature_config *feature;
 	int ret;
@@ -224,8 +224,8 @@ int wl1251_acx_feature_cfg(struct wl1251 *wl)
 		goto out;
 	}
 -	/* DF_ENCRYPTION_DISABLE and DF_SNIFF_MODE_ENABLE are disabled */
-	feature->data_flow_options = 0;
+	/* DF_ENCRYPTION_DISABLE and DF_SNIFF_MODE_ENABLE can be set */
+	feature->data_flow_options = data_flow_options;
 	feature->options = 0;
  	ret = wl1251_cmd_configure(wl, ACX_FEATURE_CFG,
diff --git a/drivers/net/wireless/wl1251/acx.h b/drivers/net/wireless/wl1251/acx.h
index 9958676..d9bc497 100644
--- a/drivers/net/wireless/wl1251/acx.h
+++ b/drivers/net/wireless/wl1251/acx.h
@@ -1455,7 +1455,7 @@ int wl1251_acx_wake_up_conditions(struct wl1251 *wl, u8
wake_up_event,
 int wl1251_acx_sleep_auth(struct wl1251 *wl, u8 sleep_auth);
 int wl1251_acx_fw_version(struct wl1251 *wl, char *buf, size_t len);
 int wl1251_acx_tx_power(struct wl1251 *wl, int power);
-int wl1251_acx_feature_cfg(struct wl1251 *wl);
+int wl1251_acx_feature_cfg(struct wl1251 *wl, u32 data_flow_options);
 int wl1251_acx_mem_map(struct wl1251 *wl,
 		       struct acx_header *mem_map, size_t len);
 int wl1251_acx_data_path_params(struct wl1251 *wl,
diff --git a/drivers/net/wireless/wl1251/init.c b/drivers/net/wireless/wl1251/init.c
index 424ce01..92de289 100644
--- a/drivers/net/wireless/wl1251/init.c
+++ b/drivers/net/wireless/wl1251/init.c
@@ -33,7 +33,7 @@ int wl1251_hw_init_hwenc_config(struct wl1251 *wl)
 {
 	int ret;
 -	ret = wl1251_acx_feature_cfg(wl);
+	ret = wl1251_acx_feature_cfg(wl, 0);
 	if (ret < 0) {
 		wl1251_warning("couldn't set feature config");
 		return ret;
diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/wl1251/main.c
index 4a6d529..5078705 100644
--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -506,6 +506,7 @@ static void wl1251_op_stop(struct ieee80211_hw *hw)
 	wl->power_level = WL1251_DEFAULT_POWER_LEVEL;
 	wl->rssi_thold = 0;
 	wl->channel = WL1251_DEFAULT_CHANNEL;
+	wl->monitor_present = false;
  	wl1251_debugfs_reset(wl);
 @@ -594,8 +595,10 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32
changed)
  	channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
 -	wl1251_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d",
+	wl1251_debug(DEBUG_MAC80211,
+		     "mac80211 config ch %d monitor %s psm %s power %d",
 		     channel,
+		     conf->flags & IEEE80211_CONF_MONITOR ? "on" : "off",
 		     conf->flags & IEEE80211_CONF_PS ? "on" : "off",
 		     conf->power_level);
 @@ -605,6 +608,22 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32
changed)
 	if (ret < 0)
 		goto out;
 +	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
+		u32 mode;
+
+		if (conf->flags & IEEE80211_CONF_MONITOR) {
+			wl->monitor_present = true;
+			mode = DF_SNIFF_MODE_ENABLE | DF_ENCRYPTION_DISABLE;
+		} else {
+			wl->monitor_present = false;
+			mode = 0;
+		}
+
+		ret = wl1251_acx_feature_cfg(wl, mode);
+		if (ret < 0)
+			goto out_sleep;
+	}
+
 	if (channel != wl->channel) {
 		wl->channel = channel;
 @@ -793,12 +812,12 @@ static int wl1251_op_set_key(struct ieee80211_hw *hw,
enum set_key_cmd cmd,
  	mutex_lock(&wl->mutex);
 -	ret = wl1251_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto out_unlock;
-
 	switch (cmd) {
 	case SET_KEY:
+		if (wl->monitor_present) {
+			ret = -EOPNOTSUPP;
+			goto out_unlock;
+		}
 		wl_cmd->key_action = KEY_ADD_OR_REPLACE;
 		break;
 	case DISABLE_KEY:
@@ -809,6 +828,10 @@ static int wl1251_op_set_key(struct ieee80211_hw *hw, enum
set_key_cmd cmd,
 		break;
 	}
 +	ret = wl1251_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out_unlock;
+
 	ret = wl1251_set_key_type(wl, wl_cmd, cmd, key, addr);
 	if (ret < 0) {
 		wl1251_error("Set KEY type failed");
@@ -1493,6 +1516,7 @@ struct ieee80211_hw *wl1251_alloc_hw(void)
 	INIT_WORK(&wl->filter_work, wl1251_filter_work);
 	INIT_DELAYED_WORK(&wl->elp_work, wl1251_elp_work);
 	wl->channel = WL1251_DEFAULT_CHANNEL;
+	wl->monitor_present = false;
 	wl->scanning = false;
 	wl->default_key = 0;
 	wl->listen_int = 1;
diff --git a/drivers/net/wireless/wl1251/rx.c b/drivers/net/wireless/wl1251/rx.c
index 86eef45..99308af 100644
--- a/drivers/net/wireless/wl1251/rx.c
+++ b/drivers/net/wireless/wl1251/rx.c
@@ -83,7 +83,7 @@ static void wl1251_rx_status(struct wl1251 *wl,
  	status->flag |= RX_FLAG_TSFT;
 -	if (desc->flags & RX_DESC_ENCRYPTION_MASK) {
+	if (!wl->monitor_present && (desc->flags & RX_DESC_ENCRYPTION_MASK)) {
 		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED;
  		if (likely(!(desc->flags & RX_DESC_DECRYPT_FAIL)))
diff --git a/drivers/net/wireless/wl1251/tx.c b/drivers/net/wireless/wl1251/tx.c
index 28121c5..3cc82fd 100644
--- a/drivers/net/wireless/wl1251/tx.c
+++ b/drivers/net/wireless/wl1251/tx.c
@@ -287,6 +287,9 @@ static int wl1251_tx_frame(struct wl1251 *wl, struct sk_buff
*skb)
 	info = IEEE80211_SKB_CB(skb);
  	if (info->control.hw_key) {
+		if (unlikely(wl->monitor_present))
+			return -1;
+
 		idx = info->control.hw_key->hw_key_idx;
 		if (unlikely(wl->default_key != idx)) {
 			ret = wl1251_acx_default_key(wl, idx);
diff --git a/drivers/net/wireless/wl1251/wl1251.h
b/drivers/net/wireless/wl1251/wl1251.h
index d2a289d..875c1bf 100644
--- a/drivers/net/wireless/wl1251/wl1251.h
+++ b/drivers/net/wireless/wl1251/wl1251.h
@@ -303,6 +303,7 @@ struct wl1251 {
 	u8 bss_type;
 	u8 listen_int;
 	int channel;
+	bool monitor_present;
  	void *target_mem_map;
 	struct acx_data_path_params_resp *data_path;
-- 
1.7.0.4


