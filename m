Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35975 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932963Ab1JEJzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:55:47 -0400
Received: by mail-ey0-f174.google.com with SMTP id 28so1405752eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:55:46 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 04/29] wl12xx: define wl12xx_vif
Date: Wed,  5 Oct 2011 11:55:41 +0200
Message-Id: <1317808566-18857-5-git-send-email-eliad@wizery.com> (sfid-20111005_115551_491198_1EEB6108)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Define a per-vif data struct.
This struct holds all the vif-specifc data, which is
currently being hold by the global wl struct.

Start by moving the basic_rate_set field into it.

NOTE: in order to make the patches a bit smaller, start by
using wl->vif in some functions, instead of changing all
the function prototypes at once. finally, wl->vif will be
removed altogether.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c     |   21 +++++-----
 drivers/net/wireless/wl12xx/cmd.h     |    9 ++--
 drivers/net/wireless/wl12xx/debugfs.c |    1 -
 drivers/net/wireless/wl12xx/init.c    |   34 +++++++++-------
 drivers/net/wireless/wl12xx/init.h    |    2 +-
 drivers/net/wireless/wl12xx/main.c    |   70 ++++++++++++++++++++------------
 drivers/net/wireless/wl12xx/wl12xx.h  |   16 +++++++-
 7 files changed, 96 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index cbe544b..f28e429 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -555,7 +555,7 @@ out:
 	return ret;
 }
 
-int wl12xx_cmd_role_start_sta(struct wl1271 *wl)
+int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct wl12xx_cmd_role_start *cmd;
 	int ret;
@@ -572,7 +572,7 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl)
 	if (wl->band == IEEE80211_BAND_5GHZ)
 		cmd->band = WL12XX_BAND_5GHZ;
 	cmd->channel = wl->channel;
-	cmd->sta.basic_rate_set = cpu_to_le32(wl->basic_rate_set);
+	cmd->sta.basic_rate_set = cpu_to_le32(wlvif->basic_rate_set);
 	cmd->sta.beacon_interval = cpu_to_le16(wl->beacon_int);
 	cmd->sta.ssid_type = WL12XX_SSID_TYPE_ANY;
 	cmd->sta.ssid_len = wl->ssid_len;
@@ -592,7 +592,7 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl)
 	wl1271_debug(DEBUG_CMD, "role start: roleid=%d, hlid=%d, session=%d "
 		     "basic_rate_set: 0x%x, remote_rates: 0x%x",
 		     wl->role_id, cmd->sta.hlid, cmd->sta.session,
-		     wl->basic_rate_set, wl->rate_set);
+		     wlvif->basic_rate_set, wl->rate_set);
 
 	ret = wl1271_cmd_send(wl, CMD_ROLE_START, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
@@ -649,7 +649,7 @@ out:
 	return ret;
 }
 
-int wl12xx_cmd_role_start_ap(struct wl1271 *wl)
+int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct wl12xx_cmd_role_start *cmd;
 	struct ieee80211_bss_conf *bss_conf = &wl->vif->bss_conf;
@@ -683,7 +683,7 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl)
 	cmd->ap.bss_index = WL1271_AP_BSS_INDEX;
 	cmd->ap.global_hlid = wl->ap_global_hlid;
 	cmd->ap.broadcast_hlid = wl->ap_bcast_hlid;
-	cmd->ap.basic_rate_set = cpu_to_le32(wl->basic_rate_set);
+	cmd->ap.basic_rate_set = cpu_to_le32(wlvif->basic_rate_set);
 	cmd->ap.beacon_interval = cpu_to_le16(wl->beacon_int);
 	cmd->ap.dtim_interval = bss_conf->dtim_period;
 	cmd->ap.beacon_expiry = WL1271_AP_DEF_BEACON_EXP;
@@ -767,7 +767,7 @@ out:
 	return ret;
 }
 
-int wl12xx_cmd_role_start_ibss(struct wl1271 *wl)
+int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct wl12xx_cmd_role_start *cmd;
 	struct ieee80211_bss_conf *bss_conf = &wl->vif->bss_conf;
@@ -785,7 +785,7 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl)
 	if (wl->band == IEEE80211_BAND_5GHZ)
 		cmd->band = WL12XX_BAND_5GHZ;
 	cmd->channel = wl->channel;
-	cmd->ibss.basic_rate_set = cpu_to_le32(wl->basic_rate_set);
+	cmd->ibss.basic_rate_set = cpu_to_le32(wlvif->basic_rate_set);
 	cmd->ibss.beacon_interval = cpu_to_le16(wl->beacon_int);
 	cmd->ibss.dtim_interval = bss_conf->dtim_period;
 	cmd->ibss.ssid_type = WL12XX_SSID_TYPE_ANY;
@@ -805,7 +805,7 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl)
 	wl1271_debug(DEBUG_CMD, "role start: roleid=%d, hlid=%d, session=%d "
 		     "basic_rate_set: 0x%x, remote_rates: 0x%x",
 		     wl->role_id, cmd->sta.hlid, cmd->sta.session,
-		     wl->basic_rate_set, wl->rate_set);
+		     wlvif->basic_rate_set, wl->rate_set);
 
 	wl1271_debug(DEBUG_CMD, "wl->bssid = %pM", wl->bssid);
 
@@ -1085,7 +1085,8 @@ out:
 
 }
 
-int wl1271_cmd_build_ps_poll(struct wl1271 *wl, u16 aid)
+int wl1271_cmd_build_ps_poll(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			     u16 aid)
 {
 	struct sk_buff *skb;
 	int ret = 0;
@@ -1095,7 +1096,7 @@ int wl1271_cmd_build_ps_poll(struct wl1271 *wl, u16 aid)
 		goto out;
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_PS_POLL, skb->data,
-				      skb->len, 0, wl->basic_rate_set);
+				      skb->len, 0, wlvif->basic_rate_set);
 
 out:
 	dev_kfree_skb(skb);
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index a9cea86..e19967f 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -41,11 +41,11 @@ int wl12xx_cmd_role_enable(struct wl1271 *wl, u8 *addr, u8 role_type,
 int wl12xx_cmd_role_disable(struct wl1271 *wl, u8 *role_id);
 int wl12xx_cmd_role_start_dev(struct wl1271 *wl);
 int wl12xx_cmd_role_stop_dev(struct wl1271 *wl);
-int wl12xx_cmd_role_start_sta(struct wl1271 *wl);
+int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_cmd_role_stop_sta(struct wl1271 *wl);
-int wl12xx_cmd_role_start_ap(struct wl1271 *wl);
+int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_cmd_role_stop_ap(struct wl1271 *wl);
-int wl12xx_cmd_role_start_ibss(struct wl1271 *wl);
+int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer);
 int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len);
@@ -56,7 +56,8 @@ int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
 int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
 			    void *buf, size_t buf_len, int index, u32 rates);
 int wl1271_cmd_build_null_data(struct wl1271 *wl);
-int wl1271_cmd_build_ps_poll(struct wl1271 *wl, u16 aid);
+int wl1271_cmd_build_ps_poll(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			     u16 aid);
 int wl1271_cmd_build_probe_req(struct wl1271 *wl,
 			       const u8 *ssid, size_t ssid_len,
 			       const u8 *ie, size_t ie_len, u8 band);
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 3999fd5..0419aaf 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -353,7 +353,6 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_INT(bss_type);
 	DRIVER_STATE_PRINT_INT(channel);
 	DRIVER_STATE_PRINT_HEX(rate_set);
-	DRIVER_STATE_PRINT_HEX(basic_rate_set);
 	DRIVER_STATE_PRINT_HEX(basic_rate);
 	DRIVER_STATE_PRINT_INT(band);
 	DRIVER_STATE_PRINT_INT(beacon_int);
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index ff5c5f4..d9da36c 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -122,7 +122,8 @@ int wl1271_init_templates_config(struct wl1271 *wl)
 	return 0;
 }
 
-static int wl1271_ap_init_deauth_template(struct wl1271 *wl)
+static int wl1271_ap_init_deauth_template(struct wl1271 *wl,
+					  struct wl12xx_vif *wlvif)
 {
 	struct wl12xx_disconn_template *tmpl;
 	int ret;
@@ -137,7 +138,7 @@ static int wl1271_ap_init_deauth_template(struct wl1271 *wl)
 	tmpl->header.frame_ctl = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					     IEEE80211_STYPE_DEAUTH);
 
-	rate = wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
+	rate = wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_DEAUTH_AP,
 				      tmpl, sizeof(*tmpl), 0, rate);
 
@@ -149,6 +150,7 @@ out:
 static int wl1271_ap_init_null_template(struct wl1271 *wl,
 					struct ieee80211_vif *vif)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct ieee80211_hdr_3addr *nullfunc;
 	int ret;
 	u32 rate;
@@ -168,7 +170,7 @@ static int wl1271_ap_init_null_template(struct wl1271 *wl,
 	memcpy(nullfunc->addr2, vif->addr, ETH_ALEN);
 	memcpy(nullfunc->addr3, vif->addr, ETH_ALEN);
 
-	rate = wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
+	rate = wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, nullfunc,
 				      sizeof(*nullfunc), 0, rate);
 
@@ -180,6 +182,7 @@ out:
 static int wl1271_ap_init_qos_null_template(struct wl1271 *wl,
 					    struct ieee80211_vif *vif)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct ieee80211_qos_hdr *qosnull;
 	int ret;
 	u32 rate;
@@ -199,7 +202,7 @@ static int wl1271_ap_init_qos_null_template(struct wl1271 *wl,
 	memcpy(qosnull->addr2, vif->addr, ETH_ALEN);
 	memcpy(qosnull->addr3, vif->addr, ETH_ALEN);
 
-	rate = wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
+	rate = wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_QOS_NULL_DATA, qosnull,
 				      sizeof(*qosnull), 0, rate);
 
@@ -370,7 +373,7 @@ static int wl1271_sta_hw_init_post_mem(struct wl1271 *wl)
 }
 
 /* generic ap initialization (non vif-specific) */
-static int wl1271_ap_hw_init(struct wl1271 *wl)
+static int wl1271_ap_hw_init(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	int ret;
 
@@ -379,7 +382,7 @@ static int wl1271_ap_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_init_ap_rates(wl);
+	ret = wl1271_init_ap_rates(wl, wlvif);
 	if (ret < 0)
 		return ret;
 
@@ -388,9 +391,10 @@ static int wl1271_ap_hw_init(struct wl1271 *wl)
 
 int wl1271_ap_init_templates(struct wl1271 *wl, struct ieee80211_vif *vif)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int ret;
 
-	ret = wl1271_ap_init_deauth_template(wl);
+	ret = wl1271_ap_init_deauth_template(wl, wlvif);
 	if (ret < 0)
 		return ret;
 
@@ -419,18 +423,19 @@ static int wl1271_ap_hw_init_post_mem(struct wl1271 *wl,
 	return wl1271_ap_init_templates(wl, vif);
 }
 
-int wl1271_init_ap_rates(struct wl1271 *wl)
+int wl1271_init_ap_rates(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	int i, ret;
 	struct conf_tx_rate_class rc;
 	u32 supported_rates;
 
-	wl1271_debug(DEBUG_AP, "AP basic rate set: 0x%x", wl->basic_rate_set);
+	wl1271_debug(DEBUG_AP, "AP basic rate set: 0x%x",
+		     wlvif->basic_rate_set);
 
-	if (wl->basic_rate_set == 0)
+	if (wlvif->basic_rate_set == 0)
 		return -EINVAL;
 
-	rc.enabled_rates = wl->basic_rate_set;
+	rc.enabled_rates = wlvif->basic_rate_set;
 	rc.long_retry_limit = 10;
 	rc.short_retry_limit = 10;
 	rc.aflags = 0;
@@ -439,7 +444,7 @@ int wl1271_init_ap_rates(struct wl1271 *wl)
 		return ret;
 
 	/* use the min basic rate for AP broadcast/multicast */
-	rc.enabled_rates = wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
+	rc.enabled_rates = wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
 	rc.short_retry_limit = 10;
 	rc.long_retry_limit = 10;
 	rc.aflags = 0;
@@ -451,7 +456,7 @@ int wl1271_init_ap_rates(struct wl1271 *wl)
 	 * If the basic rates contain OFDM rates, use OFDM only
 	 * rates for unicast TX as well. Else use all supported rates.
 	 */
-	if ((wl->basic_rate_set & CONF_TX_OFDM_RATES))
+	if ((wlvif->basic_rate_set & CONF_TX_OFDM_RATES))
 		supported_rates = CONF_TX_OFDM_RATES;
 	else
 		supported_rates = CONF_TX_AP_ENABLED_RATES;
@@ -564,6 +569,7 @@ int wl12xx_init_ap_role(struct wl1271 *wl, struct ieee80211_vif *vif)
 
 int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct conf_tx_ac_category *conf_ac;
 	struct conf_tx_tid *conf_tid;
 	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
@@ -572,7 +578,7 @@ int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif)
 
 	/* Mode specific init */
 	if (is_ap) {
-		ret = wl1271_ap_hw_init(wl);
+		ret = wl1271_ap_hw_init(wl, wlvif);
 		if (ret < 0)
 			return ret;
 
diff --git a/drivers/net/wireless/wl12xx/init.h b/drivers/net/wireless/wl12xx/init.h
index 64320c0..81140b8 100644
--- a/drivers/net/wireless/wl12xx/init.h
+++ b/drivers/net/wireless/wl12xx/init.h
@@ -34,7 +34,7 @@ int wl1271_init_energy_detection(struct wl1271 *wl);
 int wl1271_chip_specific_init(struct wl1271 *wl);
 int wl1271_hw_init(struct wl1271 *wl);
 int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif);
-int wl1271_init_ap_rates(struct wl1271 *wl);
+int wl1271_init_ap_rates(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl1271_ap_init_templates(struct wl1271 *wl, struct ieee80211_vif *vif);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 28f47e0..b1a3967 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1837,6 +1837,11 @@ static u8 wl12xx_get_role_type(struct wl1271 *wl)
 	return WL12XX_INVALID_ROLE_TYPE;
 }
 
+static void wl12xx_init_vif_data(struct wl12xx_vif *wlvif)
+{
+	wlvif->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
+}
+
 static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
 {
@@ -1857,6 +1862,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		ret = -EBUSY;
 		goto out;
 	}
+	wl12xx_init_vif_data(wl12xx_vif_to_data(vif));
 
 	/*
 	 * in some very corner case HW recovery scenarios its possible to
@@ -2163,7 +2169,8 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	cancel_work_sync(&wl->recovery_work);
 }
 
-static int wl1271_join(struct wl1271 *wl, bool set_assoc)
+static int wl1271_join(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			  bool set_assoc)
 {
 	int ret;
 	bool is_ibss = (wl->bss_type == BSS_TYPE_IBSS);
@@ -2184,9 +2191,9 @@ static int wl1271_join(struct wl1271 *wl, bool set_assoc)
 		set_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags);
 
 	if (is_ibss)
-		ret = wl12xx_cmd_role_start_ibss(wl);
+		ret = wl12xx_cmd_role_start_ibss(wl, wlvif);
 	else
-		ret = wl12xx_cmd_role_start_sta(wl);
+		ret = wl12xx_cmd_role_start_sta(wl, wlvif);
 	if (ret < 0)
 		goto out;
 
@@ -2239,10 +2246,10 @@ out:
 	return ret;
 }
 
-static void wl1271_set_band_rate(struct wl1271 *wl)
+static void wl1271_set_band_rate(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
-	wl->basic_rate_set = wl->bitrate_masks[wl->band];
-	wl->rate_set = wl->basic_rate_set;
+	wlvif->basic_rate_set = wl->bitrate_masks[wl->band];
+	wl->rate_set = wlvif->basic_rate_set;
 }
 
 static bool wl12xx_is_roc(struct wl1271 *wl)
@@ -2256,7 +2263,8 @@ static bool wl12xx_is_roc(struct wl1271 *wl)
 	return true;
 }
 
-static int wl1271_sta_handle_idle(struct wl1271 *wl, bool idle)
+static int wl1271_sta_handle_idle(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				  bool idle)
 {
 	int ret;
 
@@ -2271,7 +2279,8 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, bool idle)
 			if (ret < 0)
 				goto out;
 		}
-		wl->rate_set = wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
+		wl->rate_set = wl1271_tx_min_rate_get(wl,
+						      wlvif->basic_rate_set);
 		ret = wl1271_acx_sta_rate_policies(wl);
 		if (ret < 0)
 			goto out;
@@ -2305,6 +2314,8 @@ out:
 static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct wl1271 *wl = hw->priv;
+	struct ieee80211_vif *vif = wl->vif; /* TODO: reconfig all vifs */
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct ieee80211_conf *conf = &hw->conf;
 	int channel, ret = 0;
 	bool is_ap;
@@ -2366,10 +2377,11 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 			 * association frames and other control messages.
 			 */
 			if (!test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
-				wl1271_set_band_rate(wl);
+				wl1271_set_band_rate(wl, wlvif);
 
 			wl->basic_rate =
-				wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
+				wl1271_tx_min_rate_get(wl,
+						       wlvif->basic_rate_set);
 			ret = wl1271_acx_sta_rate_policies(wl);
 			if (ret < 0)
 				wl1271_warning("rate policy for channel "
@@ -2382,7 +2394,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 					if (ret < 0)
 						goto out_sleep;
 				}
-				ret = wl1271_join(wl, false);
+				ret = wl1271_join(wl, wlvif, false);
 				if (ret < 0)
 					wl1271_warning("cmd join on channel "
 						       "failed %d", ret);
@@ -2408,7 +2420,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_IDLE && !is_ap) {
-		ret = wl1271_sta_handle_idle(wl,
+		ret = wl1271_sta_handle_idle(wl, wlvif,
 					conf->flags & IEEE80211_CONF_IDLE);
 		if (ret < 0)
 			wl1271_warning("idle mode change failed %d", ret);
@@ -3202,6 +3214,7 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 					  struct ieee80211_bss_conf *bss_conf,
 					  u32 changed)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
 	int ret = 0;
 
@@ -3230,7 +3243,7 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 			dev_kfree_skb(beacon);
 			goto out;
 		}
-		min_rate = wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
+		min_rate = wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
 		tmpl_id = is_ap ? CMD_TEMPL_AP_BEACON :
 				  CMD_TEMPL_BEACON;
 		ret = wl1271_cmd_template_set(wl, tmpl_id,
@@ -3285,17 +3298,18 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 				       struct ieee80211_bss_conf *bss_conf,
 				       u32 changed)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int ret = 0;
 
 	if ((changed & BSS_CHANGED_BASIC_RATES)) {
 		u32 rates = bss_conf->basic_rates;
 
-		wl->basic_rate_set = wl1271_tx_enabled_rates_get(wl, rates,
+		wlvif->basic_rate_set = wl1271_tx_enabled_rates_get(wl, rates,
 								 wl->band);
 		wl->basic_rate = wl1271_tx_min_rate_get(wl,
-							wl->basic_rate_set);
+							wlvif->basic_rate_set);
 
-		ret = wl1271_init_ap_rates(wl);
+		ret = wl1271_init_ap_rates(wl, wlvif);
 		if (ret < 0) {
 			wl1271_error("AP rate policy change failed %d", ret);
 			goto out;
@@ -3313,7 +3327,7 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 	if ((changed & BSS_CHANGED_BEACON_ENABLED)) {
 		if (bss_conf->enable_beacon) {
 			if (!test_bit(WL1271_FLAG_AP_STARTED, &wl->flags)) {
-				ret = wl12xx_cmd_role_start_ap(wl);
+				ret = wl12xx_cmd_role_start_ap(wl, wlvif);
 				if (ret < 0)
 					goto out;
 
@@ -3361,6 +3375,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 					struct ieee80211_bss_conf *bss_conf,
 					u32 changed)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	bool do_join = false, set_assoc = false;
 	bool is_ibss = (wl->bss_type == BSS_TYPE_IBSS);
 	bool ibss_joined = false;
@@ -3475,11 +3490,12 @@ sta_not_found:
 			 * to use with control frames.
 			 */
 			rates = bss_conf->basic_rates;
-			wl->basic_rate_set =
+			wlvif->basic_rate_set =
 				wl1271_tx_enabled_rates_get(wl, rates,
 							    wl->band);
 			wl->basic_rate =
-				wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
+				wl1271_tx_min_rate_get(wl,
+						       wlvif->basic_rate_set);
 			if (sta_rate_set)
 				wl->rate_set = wl1271_tx_enabled_rates_get(wl,
 								sta_rate_set,
@@ -3494,7 +3510,7 @@ sta_not_found:
 			 * updates it by itself when the first beacon is
 			 * received after a join.
 			 */
-			ret = wl1271_cmd_build_ps_poll(wl, wl->aid);
+			ret = wl1271_cmd_build_ps_poll(wl, wlvif, wl->aid);
 			if (ret < 0)
 				goto out;
 
@@ -3529,9 +3545,10 @@ sta_not_found:
 			ieee80211_enable_dyn_ps(wl->vif);
 
 			/* revert back to minimum rates for the current band */
-			wl1271_set_band_rate(wl);
+			wl1271_set_band_rate(wl, wlvif);
 			wl->basic_rate =
-				wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
+				wl1271_tx_min_rate_get(wl,
+						       wlvif->basic_rate_set);
 			ret = wl1271_acx_sta_rate_policies(wl);
 			if (ret < 0)
 				goto out;
@@ -3582,11 +3599,12 @@ sta_not_found:
 
 		if (bss_conf->ibss_joined) {
 			u32 rates = bss_conf->basic_rates;
-			wl->basic_rate_set =
+			wlvif->basic_rate_set =
 				wl1271_tx_enabled_rates_get(wl, rates,
 							    wl->band);
 			wl->basic_rate =
-				wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
+				wl1271_tx_min_rate_get(wl,
+						       wlvif->basic_rate_set);
 
 			/* by default, use 11b + OFDM rates */
 			wl->rate_set = CONF_TX_IBSS_DEFAULT_RATES;
@@ -3629,7 +3647,7 @@ sta_not_found:
 	}
 
 	if (do_join) {
-		ret = wl1271_join(wl, set_assoc);
+		ret = wl1271_join(wl, wlvif, set_assoc);
 		if (ret < 0) {
 			wl1271_warning("cmd join failed %d", ret);
 			goto out;
@@ -4709,6 +4727,7 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	SET_IEEE80211_DEV(wl->hw, wl1271_wl_to_dev(wl));
 
 	wl->hw->sta_data_size = sizeof(struct wl1271_station);
+	wl->hw->vif_data_size = sizeof(struct wl12xx_vif);
 
 	wl->hw->max_rx_aggregation_subframes = 8;
 
@@ -4783,7 +4802,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->rx_counter = 0;
 	wl->psm_entry_retry = 0;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
-	wl->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
 	wl->basic_rate = CONF_TX_RATE_MASK_BASIC;
 	wl->rate_set = CONF_TX_RATE_MASK_BASIC;
 	wl->band = IEEE80211_BAND_2GHZ;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 006c34c..d531e09 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -524,7 +524,6 @@ struct wl1271 {
 	 *	bits 16-23 - 802.11n   MCS index mask
 	 * support only 1 stream, thus only 8 bits for the MCS rates (0-7).
 	 */
-	u32 basic_rate_set;
 	u32 basic_rate;
 	u32 rate_set;
 	u32 bitrate_masks[IEEE80211_NUM_BANDS];
@@ -638,6 +637,21 @@ struct wl1271_station {
 	u8 hlid;
 };
 
+struct wl12xx_vif {
+	u32 basic_rate_set;
+};
+
+static inline struct wl12xx_vif *wl12xx_vif_to_data(struct ieee80211_vif *vif)
+{
+	return (struct wl12xx_vif *)vif->drv_priv;
+}
+
+static inline
+struct ieee80211_vif *wl12xx_wlvif_to_vif(struct wl12xx_vif *wlvif)
+{
+	return container_of((void *)wlvif, struct ieee80211_vif, drv_priv);
+}
+
 int wl1271_plt_start(struct wl1271 *wl);
 int wl1271_plt_stop(struct wl1271 *wl);
 int wl1271_recalc_rx_streaming(struct wl1271 *wl);
-- 
1.7.6.401.g6a319

