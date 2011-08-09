Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54440 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab1HIJNp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:13:45 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so210739wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:13:44 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/40] wl12xx: wl12xx-fw-3 - update acx commands
Date: Tue,  9 Aug 2011 12:13:20 +0300
Message-Id: <1312881233-9366-8-git-send-email-eliad@wizery.com> (sfid-20110809_111352_073492_575038BA)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the acx commands according to the new fw api.

The main change in most of the ACXs is the addition
of a new role_id/link_id field, which is required
for multi-role operation.

Currently, we don't really support multi-role, as
most of our data (inside wl) is global.
As the current fw doesn't support concurrent roles
yet, keep it this way and add wl->role_id and
wl->sta_hlid to save the active role/link.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c    |  113 ++++++++++++---------------
 drivers/net/wireless/wl12xx/acx.h    |  141 +++++++++++++++++++---------------
 drivers/net/wireless/wl12xx/init.c   |    4 +-
 drivers/net/wireless/wl12xx/main.c   |    5 +-
 drivers/net/wireless/wl12xx/wl12xx.h |    4 +
 5 files changed, 137 insertions(+), 130 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 804bac9..42bfce8 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -43,12 +43,13 @@ int wl1271_acx_wake_up_conditions(struct wl1271 *wl)
 	wake_up = kzalloc(sizeof(*wake_up), GFP_KERNEL);
 	if (!wake_up) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	wake_up->role_id = wl->role_id;
 	wake_up->wake_up_event = wl->conf.conn.wake_up_event;
 	wake_up->listen_interval = wl->conf.conn.listen_interval;
 
 	ret = wl1271_cmd_configure(wl, ACX_WAKE_UP_CONDITIONS,
 				   wake_up, sizeof(*wake_up));
 	if (ret < 0) {
@@ -98,12 +99,13 @@ int wl1271_acx_tx_power(struct wl1271 *wl, int power)
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	acx->role_id = wl->role_id;
 	acx->current_tx_power = power * 10;
 
 	ret = wl1271_cmd_configure(wl, DOT11_CUR_TX_PWR, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl1271_warning("configure of tx power failed: %d", ret);
 		goto out;
@@ -125,12 +127,13 @@ int wl1271_acx_feature_cfg(struct wl1271 *wl)
 	if (!feature) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
 	/* DF_ENCRYPTION_DISABLE and DF_SNIFF_MODE_ENABLE are disabled */
+	feature->role_id = wl->role_id;
 	feature->data_flow_options = 0;
 	feature->options = 0;
 
 	ret = wl1271_cmd_configure(wl, ACX_FEATURE_CFG,
 				   feature, sizeof(*feature));
 	if (ret < 0) {
@@ -219,12 +222,13 @@ int wl1271_acx_slot(struct wl1271 *wl, enum acx_slot_type slot_time)
 	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
 	if (!slot) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	slot->role_id = wl->role_id;
 	slot->wone_index = STATION_WONE_INDEX;
 	slot->slot_time = slot_time;
 
 	ret = wl1271_cmd_configure(wl, ACX_SLOT, slot, sizeof(*slot));
 	if (ret < 0) {
 		wl1271_warning("failed to set slot time: %d", ret);
@@ -248,12 +252,13 @@ int wl1271_acx_group_address_tbl(struct wl1271 *wl, bool enable,
 	if (!acx) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
 	/* MAC filtering */
+	acx->role_id = wl->role_id;
 	acx->enabled = enable;
 	acx->num_groups = mc_list_len;
 	memcpy(acx->mac_table, mc_list, mc_list_len * ETH_ALEN);
 
 	ret = wl1271_cmd_configure(wl, DOT11_GROUP_ADDRESS_TBL,
 				   acx, sizeof(*acx));
@@ -277,12 +282,13 @@ int wl1271_acx_service_period_timeout(struct wl1271 *wl)
 		ret = -ENOMEM;
 		goto out;
 	}
 
 	wl1271_debug(DEBUG_ACX, "acx service period timeout");
 
+	rx_timeout->role_id = wl->role_id;
 	rx_timeout->ps_poll_timeout = cpu_to_le16(wl->conf.rx.ps_poll_timeout);
 	rx_timeout->upsd_timeout = cpu_to_le16(wl->conf.rx.upsd_timeout);
 
 	ret = wl1271_cmd_configure(wl, ACX_SERVICE_PERIOD_TIMEOUT,
 				   rx_timeout, sizeof(*rx_timeout));
 	if (ret < 0) {
@@ -313,12 +319,13 @@ int wl1271_acx_rts_threshold(struct wl1271 *wl, u32 rts_threshold)
 	rts = kzalloc(sizeof(*rts), GFP_KERNEL);
 	if (!rts) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	rts->role_id = wl->role_id;
 	rts->threshold = cpu_to_le16((u16)rts_threshold);
 
 	ret = wl1271_cmd_configure(wl, DOT11_RTS_THRESHOLD, rts, sizeof(*rts));
 	if (ret < 0) {
 		wl1271_warning("failed to set rts threshold: %d", ret);
 		goto out;
@@ -372,12 +379,13 @@ int wl1271_acx_beacon_filter_opt(struct wl1271 *wl, bool enable_filter)
 	beacon_filter = kzalloc(sizeof(*beacon_filter), GFP_KERNEL);
 	if (!beacon_filter) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	beacon_filter->role_id = wl->role_id;
 	beacon_filter->enable = enable_filter;
 
 	/*
 	 * When set to zero, and the filter is enabled, beacons
 	 * without the unicast TIM bit set are dropped.
 	 */
@@ -408,12 +416,13 @@ int wl1271_acx_beacon_filter_table(struct wl1271 *wl)
 	if (!ie_table) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
 	/* configure default beacon pass-through rules */
+	ie_table->role_id = wl->role_id;
 	ie_table->num_ie = 0;
 	for (i = 0; i < wl->conf.conn.bcn_filt_ie_count; i++) {
 		struct conf_bcn_filt_rule *r = &(wl->conf.conn.bcn_filt_ie[i]);
 		ie_table->table[idx++] = r->ie;
 		ie_table->table[idx++] = r->rule;
 
@@ -469,12 +478,13 @@ int wl1271_acx_conn_monit_params(struct wl1271 *wl, bool enable)
 
 	if (enable) {
 		threshold = wl->conf.conn.synch_fail_thold;
 		timeout = wl->conf.conn.bss_lose_timeout;
 	}
 
+	acx->role_id = wl->role_id;
 	acx->synch_fail_thold = cpu_to_le32(threshold);
 	acx->bss_lose_timeout = cpu_to_le32(timeout);
 
 	ret = wl1271_cmd_configure(wl, ACX_CONN_MONIT_PARAMS,
 				   acx, sizeof(*acx));
 	if (ret < 0) {
@@ -616,12 +626,13 @@ int wl1271_acx_bcn_dtim_options(struct wl1271 *wl)
 	bb = kzalloc(sizeof(*bb), GFP_KERNEL);
 	if (!bb) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	bb->role_id = wl->role_id;
 	bb->beacon_rx_timeout = cpu_to_le16(wl->conf.conn.beacon_rx_timeout);
 	bb->broadcast_timeout = cpu_to_le16(wl->conf.conn.broadcast_timeout);
 	bb->rx_broadcast_in_ps = wl->conf.conn.rx_broadcast_in_ps;
 	bb->ps_poll_threshold = wl->conf.conn.ps_poll_threshold;
 
 	ret = wl1271_cmd_configure(wl, ACX_BCN_DTIM_OPTIONS, bb, sizeof(*bb));
@@ -645,12 +656,13 @@ int wl1271_acx_aid(struct wl1271 *wl, u16 aid)
 	acx_aid = kzalloc(sizeof(*acx_aid), GFP_KERNEL);
 	if (!acx_aid) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	acx_aid->role_id = wl->role_id;
 	acx_aid->aid = cpu_to_le16(aid);
 
 	ret = wl1271_cmd_configure(wl, ACX_AID, acx_aid, sizeof(*acx_aid));
 	if (ret < 0) {
 		wl1271_warning("failed to set aid: %d", ret);
 		goto out;
@@ -700,12 +712,13 @@ int wl1271_acx_set_preamble(struct wl1271 *wl, enum acx_preamble_type preamble)
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	acx->role_id = wl->role_id;
 	acx->preamble = preamble;
 
 	ret = wl1271_cmd_configure(wl, ACX_PREAMBLE_TYPE, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl1271_warning("Setting of preamble failed: %d", ret);
 		goto out;
@@ -727,12 +740,13 @@ int wl1271_acx_cts_protect(struct wl1271 *wl,
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	acx->role_id = wl->role_id;
 	acx->ctsprotect = ctsprotect;
 
 	ret = wl1271_cmd_configure(wl, ACX_CTS_PROTECTION, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl1271_warning("Setting of ctsprotect failed: %d", ret);
 		goto out;
@@ -758,45 +772,49 @@ int wl1271_acx_statistics(struct wl1271 *wl, struct acx_statistics *stats)
 
 	return 0;
 }
 
 int wl1271_acx_sta_rate_policies(struct wl1271 *wl)
 {
-	struct acx_sta_rate_policy *acx;
+	struct acx_rate_policy *acx;
 	struct conf_tx_rate_class *c = &wl->conf.tx.sta_rc_conf;
-	int idx = 0;
 	int ret = 0;
 
 	wl1271_debug(DEBUG_ACX, "acx rate policies");
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 
 	if (!acx) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	wl1271_debug(DEBUG_ACX, "basic_rate: 0x%x, full_rate: 0x%x",
+		wl->basic_rate, wl->rate_set);
+
 	/* configure one basic rate class */
-	idx = ACX_TX_BASIC_RATE;
-	acx->rate_class[idx].enabled_rates = cpu_to_le32(wl->basic_rate);
-	acx->rate_class[idx].short_retry_limit = c->short_retry_limit;
-	acx->rate_class[idx].long_retry_limit = c->long_retry_limit;
-	acx->rate_class[idx].aflags = c->aflags;
+	acx->rate_policy_idx = cpu_to_le32(ACX_TX_BASIC_RATE);
+	acx->rate_policy.enabled_rates = cpu_to_le32(wl->basic_rate);
+	acx->rate_policy.short_retry_limit = c->short_retry_limit;
+	acx->rate_policy.long_retry_limit = c->long_retry_limit;
+	acx->rate_policy.aflags = c->aflags;
+
+	ret = wl1271_cmd_configure(wl, ACX_RATE_POLICY, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("Setting of rate policies failed: %d", ret);
+		goto out;
+	}
 
 	/* configure one AP supported rate class */
-	idx = ACX_TX_AP_FULL_RATE;
-	acx->rate_class[idx].enabled_rates = cpu_to_le32(wl->rate_set);
-	acx->rate_class[idx].short_retry_limit = c->short_retry_limit;
-	acx->rate_class[idx].long_retry_limit = c->long_retry_limit;
-	acx->rate_class[idx].aflags = c->aflags;
+	acx->rate_policy_idx = cpu_to_le32(ACX_TX_AP_FULL_RATE);
+	acx->rate_policy.enabled_rates = cpu_to_le32(wl->rate_set);
+	acx->rate_policy.short_retry_limit = c->short_retry_limit;
+	acx->rate_policy.long_retry_limit = c->long_retry_limit;
+	acx->rate_policy.aflags = c->aflags;
 
-	acx->rate_class_cnt = cpu_to_le32(ACX_TX_RATE_POLICY_CNT);
 
-	wl1271_debug(DEBUG_ACX, "basic_rate: 0x%x, full_rate: 0x%x",
-		acx->rate_class[ACX_TX_BASIC_RATE].enabled_rates,
-		acx->rate_class[ACX_TX_AP_FULL_RATE].enabled_rates);
 
 	ret = wl1271_cmd_configure(wl, ACX_RATE_POLICY, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl1271_warning("Setting of rate policies failed: %d", ret);
 		goto out;
 	}
@@ -806,13 +824,13 @@ out:
 	return ret;
 }
 
 int wl1271_acx_ap_rate_policy(struct wl1271 *wl, struct conf_tx_rate_class *c,
 		      u8 idx)
 {
-	struct acx_ap_rate_policy *acx;
+	struct acx_rate_policy *acx;
 	int ret = 0;
 
 	wl1271_debug(DEBUG_ACX, "acx ap rate policy %d rates 0x%x",
 		     idx, c->enabled_rates);
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
@@ -852,12 +870,13 @@ int wl1271_acx_ac_cfg(struct wl1271 *wl, u8 ac, u8 cw_min, u16 cw_max,
 
 	if (!acx) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	acx->role_id = wl->role_id;
 	acx->ac = ac;
 	acx->cw_min = cw_min;
 	acx->cw_max = cpu_to_le16(cw_max);
 	acx->aifsn = aifsn;
 	acx->tx_op_limit = cpu_to_le16(txop);
 
@@ -885,12 +904,13 @@ int wl1271_acx_tid_cfg(struct wl1271 *wl, u8 queue_id, u8 channel_type,
 
 	if (!acx) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	acx->role_id = wl->role_id;
 	acx->queue_id = queue_id;
 	acx->channel_type = channel_type;
 	acx->tsid = tsid;
 	acx->ps_scheme = ps_scheme;
 	acx->ack_policy = ack_policy;
 	acx->apsd_conf[0] = cpu_to_le32(apsd_conf0);
@@ -964,58 +984,15 @@ int wl1271_acx_tx_config_options(struct wl1271 *wl)
 
 out:
 	kfree(acx);
 	return ret;
 }
 
-int wl1271_acx_ap_mem_cfg(struct wl1271 *wl)
-{
-	struct wl1271_acx_ap_config_memory *mem_conf;
-	struct conf_memory_settings *mem;
-	int ret;
-
-	wl1271_debug(DEBUG_ACX, "wl1271 mem cfg");
-
-	mem_conf = kzalloc(sizeof(*mem_conf), GFP_KERNEL);
-	if (!mem_conf) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	if (wl->chip.id == CHIP_ID_1283_PG20)
-		/*
-		 * FIXME: The 128x AP FW does not yet support dynamic memory.
-		 * Use the base memory configuration for 128x for now. This
-		 * should be fine tuned in the future.
-		 */
-		mem = &wl->conf.mem_wl128x;
-	else
-		mem = &wl->conf.mem_wl127x;
-
-	/* memory config */
-	mem_conf->num_stations = mem->num_stations;
-	mem_conf->rx_mem_block_num = mem->rx_block_num;
-	mem_conf->tx_min_mem_block_num = mem->tx_min_block_num;
-	mem_conf->num_ssid_profiles = mem->ssid_profiles;
-	mem_conf->total_tx_descriptors = cpu_to_le32(ACX_TX_DESCRIPTORS);
-
-	ret = wl1271_cmd_configure(wl, ACX_MEM_CFG, mem_conf,
-				   sizeof(*mem_conf));
-	if (ret < 0) {
-		wl1271_warning("wl1271 mem config failed: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(mem_conf);
-	return ret;
-}
-
-int wl1271_acx_sta_mem_cfg(struct wl1271 *wl)
+int wl1271_acx_mem_cfg(struct wl1271 *wl)
 {
-	struct wl1271_acx_sta_config_memory *mem_conf;
+	struct wl1271_acx_config_memory *mem_conf;
 	struct conf_memory_settings *mem;
 	int ret;
 
 	wl1271_debug(DEBUG_ACX, "wl1271 mem cfg");
 
 	mem_conf = kzalloc(sizeof(*mem_conf), GFP_KERNEL);
@@ -1152,12 +1129,13 @@ int wl1271_acx_bet_enable(struct wl1271 *wl, bool enable)
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	acx->role_id = wl->role_id;
 	acx->enable = enable ? CONF_BET_MODE_ENABLE : CONF_BET_MODE_DISABLE;
 	acx->max_consecutive = wl->conf.conn.bet_max_consecutive;
 
 	ret = wl1271_cmd_configure(wl, ACX_BET_ENABLE, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl1271_warning("acx bet enable failed: %d", ret);
@@ -1179,12 +1157,13 @@ int wl1271_acx_arp_ip_filter(struct wl1271 *wl, u8 enable, __be32 address)
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	acx->role_id = wl->role_id;
 	acx->version = ACX_IPV4_VERSION;
 	acx->enable = enable;
 
 	if (enable)
 		memcpy(acx->address, &address, ACX_IPV4_ADDR_SIZE);
 
@@ -1238,12 +1217,13 @@ int wl1271_acx_keep_alive_mode(struct wl1271 *wl, bool enable)
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	acx->role_id = wl->role_id;
 	acx->enabled = enable;
 
 	ret = wl1271_cmd_configure(wl, ACX_KEEP_ALIVE_MODE, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl1271_warning("acx keep alive mode failed: %d", ret);
 		goto out;
@@ -1264,12 +1244,13 @@ int wl1271_acx_keep_alive_config(struct wl1271 *wl, u8 index, u8 tpl_valid)
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	acx->role_id = wl->role_id;
 	acx->period = cpu_to_le32(wl->conf.conn.keep_alive_interval);
 	acx->index = index;
 	acx->tpl_validation = tpl_valid;
 	acx->trigger = ACX_KEEP_ALIVE_NO_TX;
 
 	ret = wl1271_cmd_configure(wl, ACX_SET_KEEP_ALIVE_CONFIG,
@@ -1297,12 +1278,13 @@ int wl1271_acx_rssi_snr_trigger(struct wl1271 *wl, bool enable,
 		ret = -ENOMEM;
 		goto out;
 	}
 
 	wl->last_rssi_event = -1;
 
+	acx->role_id = wl->role_id;
 	acx->pacing = cpu_to_le16(wl->conf.roam_trigger.trigger_pacing);
 	acx->metric = WL1271_ACX_TRIG_METRIC_RSSI_BEACON;
 	acx->type = WL1271_ACX_TRIG_TYPE_EDGE;
 	if (enable)
 		acx->enable = WL1271_ACX_TRIG_ENABLE;
 	else
@@ -1335,12 +1317,13 @@ int wl1271_acx_rssi_snr_avg_weights(struct wl1271 *wl)
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	acx->role_id = wl->role_id;
 	acx->rssi_beacon = c->avg_weight_rssi_beacon;
 	acx->rssi_data = c->avg_weight_rssi_data;
 	acx->snr_beacon = c->avg_weight_snr_beacon;
 	acx->snr_data = c->avg_weight_snr_data;
 
 	ret = wl1271_cmd_configure(wl, ACX_RSSI_SNR_WEIGHTS, acx, sizeof(*acx));
@@ -1356,13 +1339,12 @@ out:
 
 int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
 				    struct ieee80211_sta_ht_cap *ht_cap,
 				    bool allow_ht_operation)
 {
 	struct wl1271_acx_ht_capabilities *acx;
-	u8 mac_address[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	int ret = 0;
 	u32 ht_capabilites = 0;
 
 	wl1271_debug(DEBUG_ACX, "acx ht capabilities setting");
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
@@ -1387,13 +1369,13 @@ int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
 
 		/* get data from A-MPDU parameters field */
 		acx->ampdu_max_length = ht_cap->ampdu_factor;
 		acx->ampdu_min_spacing = ht_cap->ampdu_density;
 	}
 
-	memcpy(acx->mac_address, mac_address, ETH_ALEN);
+	acx->hlid = wl->sta_hlid;
 	acx->ht_capabilites = cpu_to_le32(ht_capabilites);
 
 	ret = wl1271_cmd_configure(wl, ACX_PEER_HT_CAP, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl1271_warning("acx ht capabilities setting failed: %d", ret);
 		goto out;
@@ -1415,12 +1397,13 @@ int wl1271_acx_set_ht_information(struct wl1271 *wl,
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	acx->role_id = wl->role_id;
 	acx->ht_protection =
 		(u8)(ht_operation_mode & IEEE80211_HT_OP_MODE_PROTECTION);
 	acx->rifs_mode = 0;
 	acx->gf_protection =
 		!!(ht_operation_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
 	acx->ht_tx_burst_limit = 0;
@@ -1583,12 +1566,13 @@ int wl1271_acx_ps_rx_streaming(struct wl1271 *wl, bool enable)
 		 * this check assumes conf.rx_streaming.queues can't
 		 * be changed while rx_streaming is enabled.
 		 */
 		if (!(conf_queues & BIT(i)))
 			continue;
 
+		rx_streaming->role_id = wl->role_id;
 		rx_streaming->tid = i;
 		rx_streaming->enable = enable_queues & BIT(i);
 		rx_streaming->period = wl->conf.rx_streaming.interval;
 		rx_streaming->timeout = wl->conf.rx_streaming.interval;
 
 		ret = wl1271_cmd_configure(wl, ACX_PS_RX_STREAMING,
@@ -1612,12 +1596,13 @@ int wl1271_acx_ap_max_tx_retry(struct wl1271 *wl)
 	wl1271_debug(DEBUG_ACX, "acx ap max tx retry");
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx)
 		return -ENOMEM;
 
+	acx->role_id = wl->role_id;
 	acx->max_tx_retry = cpu_to_le16(wl->conf.tx.max_tx_retries);
 
 	ret = wl1271_cmd_configure(wl, ACX_MAX_TX_FAILURE, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl1271_warning("acx ap max tx retry failed: %d", ret);
 		goto out;
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 4ae0085..9cc5d62 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -98,12 +98,21 @@ struct acx_error_counter {
 
 	/* the number of missed sequence numbers in the squentially */
 	/* values of frames seq numbers */
 	__le32 seq_num_miss;
 } __packed;
 
+enum wl1271_role {
+	WL1271_ROLE_STA = 0,
+	WL1271_ROLE_IBSS,
+	WL1271_ROLE_AP,
+	WL1271_ROLE_DEVICE,
+	WL1271_ROLE_P2P_CL,
+	WL1271_ROLE_P2P_GO,
+};
+
 enum wl1271_psm_mode {
 	/* Active mode */
 	WL1271_PSM_CAM = 0,
 
 	/* Power save mode */
 	WL1271_PSM_PS = 1,
@@ -176,57 +185,64 @@ enum acx_slot_type {
 
 #define STATION_WONE_INDEX 0
 
 struct acx_slot {
 	struct acx_header header;
 
+	u8 role_id;
 	u8 wone_index; /* Reserved */
 	u8 slot_time;
-	u8 reserved[6];
+	u8 reserved[5];
 } __packed;
 
 
 #define ACX_MC_ADDRESS_GROUP_MAX	(8)
 #define ADDRESS_GROUP_MAX_LEN	        (ETH_ALEN * ACX_MC_ADDRESS_GROUP_MAX)
 
 struct acx_dot11_grp_addr_tbl {
 	struct acx_header header;
 
+	u8 role_id;
 	u8 enabled;
 	u8 num_groups;
-	u8 pad[2];
+	u8 pad[1];
 	u8 mac_table[ADDRESS_GROUP_MAX_LEN];
 } __packed;
 
 struct acx_rx_timeout {
 	struct acx_header header;
 
+	u8 role_id;
+	u8 reserved;
 	__le16 ps_poll_timeout;
 	__le16 upsd_timeout;
+	u8 padding[2];
 } __packed;
 
 struct acx_rts_threshold {
 	struct acx_header header;
 
+	u8 role_id;
+	u8 reserved;
 	__le16 threshold;
-	u8 pad[2];
 } __packed;
 
 struct acx_beacon_filter_option {
 	struct acx_header header;
 
+	u8 role_id;
 	u8 enable;
 	/*
 	 * The number of beacons without the unicast TIM
 	 * bit set that the firmware buffers before
 	 * signaling the host about ready frames.
 	 * When set to 0 and the filter is enabled, beacons
 	 * without the unicast TIM bit set are dropped.
 	 */
 	u8 max_num_beacons;
-	u8 pad[2];
+	u8 pad[1];
 } __packed;
 
 /*
  * ACXBeaconFilterEntry (not 221)
  * Byte Offset     Size (Bytes)    Definition
  * ===========     ============    ==========
@@ -259,20 +275,23 @@ struct acx_beacon_filter_option {
 			   (BEACON_FILTER_TABLE_MAX_VENDOR_SPECIFIC_IE_NUM * \
 			    BEACON_FILTER_TABLE_EXTRA_VENDOR_SPECIFIC_IE_SIZE))
 
 struct acx_beacon_filter_ie_table {
 	struct acx_header header;
 
+	u8 role_id;
 	u8 num_ie;
-	u8 pad[3];
+	u8 pad[2];
 	u8 table[BEACON_FILTER_TABLE_MAX_SIZE];
 } __packed;
 
 struct acx_conn_monit_params {
        struct acx_header header;
 
+	   u8 role_id;
+	   u8 padding[3];
        __le32 synch_fail_thold; /* number of beacons missed */
        __le32 bss_lose_timeout; /* number of TU's from synch fail */
 } __packed;
 
 struct acx_bt_wlan_coex {
 	struct acx_header header;
@@ -315,21 +334,22 @@ struct acx_energy_detection {
 	u8 pad;
 } __packed;
 
 struct acx_beacon_broadcast {
 	struct acx_header header;
 
-	__le16 beacon_rx_timeout;
-	__le16 broadcast_timeout;
-
+	u8 role_id;
 	/* Enables receiving of broadcast packets in PS mode */
 	u8 rx_broadcast_in_ps;
 
+	__le16 beacon_rx_timeout;
+	__le16 broadcast_timeout;
+
 	/* Consecutive PS Poll failures before updating the host */
 	u8 ps_poll_threshold;
-	u8 pad[2];
+	u8 pad[1];
 } __packed;
 
 struct acx_event_mask {
 	struct acx_header header;
 
 	__le32 event_mask;
@@ -345,39 +365,44 @@ struct acx_event_mask {
 #define DF_ENCRYPTION_DISABLE      0x01
 #define DF_SNIFF_MODE_ENABLE       0x80
 
 struct acx_feature_config {
 	struct acx_header header;
 
+	u8 role_id;
+	u8 padding[3];
 	__le32 options;
 	__le32 data_flow_options;
 } __packed;
 
 struct acx_current_tx_power {
 	struct acx_header header;
 
+	u8  role_id;
 	u8  current_tx_power;
-	u8  padding[3];
+	u8  padding[2];
 } __packed;
 
 struct acx_wake_up_condition {
 	struct acx_header header;
 
+	u8 role_id;
 	u8 wake_up_event; /* Only one bit can be set */
 	u8 listen_interval;
-	u8 pad[2];
+	u8 pad[1];
 } __packed;
 
 struct acx_aid {
 	struct acx_header header;
 
 	/*
 	 * To be set when associated with an AP.
 	 */
+	u8 role_id;
+	u8 reserved;
 	__le16 aid;
-	u8 pad[2];
 } __packed;
 
 enum acx_preamble_type {
 	ACX_PREAMBLE_LONG = 0,
 	ACX_PREAMBLE_SHORT = 1
 };
@@ -386,25 +411,27 @@ struct acx_preamble {
 	struct acx_header header;
 
 	/*
 	 * When set, the WiLink transmits the frames with a short preamble and
 	 * when cleared, the WiLink transmits the frames with a long preamble.
 	 */
+	u8 role_id;
 	u8 preamble;
-	u8 padding[3];
+	u8 padding[2];
 } __packed;
 
 enum acx_ctsprotect_type {
 	CTSPROTECT_DISABLE = 0,
 	CTSPROTECT_ENABLE = 1
 };
 
 struct acx_ctsprotect {
 	struct acx_header header;
+	u8 role_id;
 	u8 ctsprotect;
-	u8 padding[3];
+	u8 padding[2];
 } __packed;
 
 struct acx_tx_statistics {
 	__le32 internal_desc_overflow;
 }  __packed;
 
@@ -633,48 +660,40 @@ struct acx_rate_class {
 	u8 aflags;
 	u8 reserved;
 };
 
 #define ACX_TX_BASIC_RATE      0
 #define ACX_TX_AP_FULL_RATE    1
-#define ACX_TX_RATE_POLICY_CNT 2
-struct acx_sta_rate_policy {
-	struct acx_header header;
-
-	__le32 rate_class_cnt;
-	struct acx_rate_class rate_class[CONF_TX_MAX_RATE_CLASSES];
-} __packed;
-
-
 #define ACX_TX_AP_MODE_MGMT_RATE 4
 #define ACX_TX_AP_MODE_BCST_RATE 5
-struct acx_ap_rate_policy {
+struct acx_rate_policy {
 	struct acx_header header;
 
 	__le32 rate_policy_idx;
 	struct acx_rate_class rate_policy;
 } __packed;
 
 struct acx_ac_cfg {
 	struct acx_header header;
+	u8 role_id;
 	u8 ac;
+	u8 aifsn;
 	u8 cw_min;
 	__le16 cw_max;
-	u8 aifsn;
-	u8 reserved;
 	__le16 tx_op_limit;
 } __packed;
 
 struct acx_tid_config {
 	struct acx_header header;
+	u8 role_id;
 	u8 queue_id;
 	u8 channel_type;
 	u8 tsid;
 	u8 ps_scheme;
 	u8 ack_policy;
-	u8 padding[3];
+	u8 padding[2];
 	__le32 apsd_conf[2];
 } __packed;
 
 struct acx_frag_threshold {
 	struct acx_header header;
 	__le16 frag_threshold;
@@ -684,25 +703,13 @@ struct acx_frag_threshold {
 struct acx_tx_config_options {
 	struct acx_header header;
 	__le16 tx_compl_timeout;     /* msec */
 	__le16 tx_compl_threshold;   /* number of packets */
 } __packed;
 
-#define ACX_TX_DESCRIPTORS    32
-
-struct wl1271_acx_ap_config_memory {
-	struct acx_header header;
-
-	u8 rx_mem_block_num;
-	u8 tx_min_mem_block_num;
-	u8 num_stations;
-	u8 num_ssid_profiles;
-	__le32 total_tx_descriptors;
-} __packed;
-
-struct wl1271_acx_sta_config_memory {
+struct wl1271_acx_config_memory {
 	struct acx_header header;
 
 	u8 rx_mem_block_num;
 	u8 tx_min_mem_block_num;
 	u8 num_stations;
 	u8 num_ssid_profiles;
@@ -770,30 +777,32 @@ struct wl1271_acx_rx_config_opt {
 } __packed;
 
 
 struct wl1271_acx_bet_enable {
 	struct acx_header header;
 
+	u8 role_id;
 	u8 enable;
 	u8 max_consecutive;
-	u8 padding[2];
+	u8 padding[1];
 } __packed;
 
 #define ACX_IPV4_VERSION 4
 #define ACX_IPV6_VERSION 6
 #define ACX_IPV4_ADDR_SIZE 4
 
 /* bitmap of enabled arp_filter features */
 #define ACX_ARP_FILTER_ARP_FILTERING	BIT(0)
 #define ACX_ARP_FILTER_AUTO_ARP		BIT(1)
 
 struct wl1271_acx_arp_filter {
 	struct acx_header header;
+	u8 role_id;
 	u8 version;         /* ACX_IPV4_VERSION, ACX_IPV6_VERSION */
 	u8 enable;          /* bitmap of enabled ARP filtering features */
-	u8 padding[2];
+	u8 padding[1];
 	u8 address[16];     /* The configured device IP address - all ARP
 			       requests directed to this IP address will pass
 			       through. For IPv4, the first four bytes are
 			       used. */
 } __packed;
 
@@ -805,14 +814,15 @@ struct wl1271_acx_pm_config {
 	u8 padding[3];
 } __packed;
 
 struct wl1271_acx_keep_alive_mode {
 	struct acx_header header;
 
+	u8 role_id;
 	u8 enabled;
-	u8 padding[3];
+	u8 padding[2];
 } __packed;
 
 enum {
 	ACX_KEEP_ALIVE_NO_TX = 0,
 	ACX_KEEP_ALIVE_PERIOD_ONLY
 };
@@ -822,17 +832,17 @@ enum {
 	ACX_KEEP_ALIVE_TPL_VALID
 };
 
 struct wl1271_acx_keep_alive_config {
 	struct acx_header header;
 
-	__le32 period;
+	u8 role_id;
 	u8 index;
 	u8 tpl_validation;
 	u8 trigger;
-	u8 padding;
+	__le32 period;
 } __packed;
 
 #define HOST_IF_CFG_RX_FIFO_ENABLE     BIT(0)
 #define HOST_IF_CFG_TX_EXTRA_BLKS_SWAP BIT(1)
 #define HOST_IF_CFG_TX_PAD_TO_SDIO_BLK BIT(3)
 
@@ -870,26 +880,29 @@ enum {
 	WL1271_ACX_TRIG_COUNT = 8,
 };
 
 struct wl1271_acx_rssi_snr_trigger {
 	struct acx_header header;
 
-	__le16 threshold;
-	__le16 pacing; /* 0 - 60000 ms */
+	u8 role_id;
 	u8 metric;
 	u8 type;
 	u8 dir;
+	__le16 threshold;
+	__le16 pacing; /* 0 - 60000 ms */
 	u8 hysteresis;
 	u8 index;
 	u8 enable;
-	u8 padding[2];
+	u8 padding[1];
 };
 
 struct wl1271_acx_rssi_snr_avg_weights {
 	struct acx_header header;
 
+	u8 role_id;
+	u8 padding[3];
 	u8 rssi_beacon;
 	u8 rssi_data;
 	u8 snr_beacon;
 	u8 snr_data;
 };
 
@@ -913,28 +926,25 @@ struct wl1271_acx_ht_capabilities {
 	 * bit 5 - Allow RD initiation in TXOP. FW is allowed to initate RD.
 	 *         Exact policy setting for this feature is TBD.
 	 *         Note, this bit can only be set to 1 if bit 3 is set to 1.
 	 */
 	__le32 ht_capabilites;
 
-	/*
-	 * Indicates to which peer these capabilities apply.
-	 * For infrastructure use ff:ff:ff:ff:ff:ff that indicates relevance
-	 * for all peers.
-	 * Only valid for IBSS/DLS operation.
-	 */
-	u8 mac_address[ETH_ALEN];
+	/* Indicates to which link these capabilities apply. */
+	u8 hlid;
 
 	/*
 	 * This the maximum A-MPDU length supported by the AP. The FW may not
 	 * exceed this length when sending A-MPDUs
 	 */
 	u8 ampdu_max_length;
 
 	/* This is the minimal spacing required when sending A-MPDUs to the AP*/
 	u8 ampdu_min_spacing;
+
+	u8 padding;
 } __packed;
 
 /* HT Capabilites Fw Bit Mask Mapping */
 #define WL1271_ACX_FW_CAP_HT_OPERATION                 BIT(0)
 #define WL1271_ACX_FW_CAP_GREENFIELD_FRAME_FORMAT      BIT(1)
 #define WL1271_ACX_FW_CAP_SHORT_GI_FOR_20MHZ_PACKETS   BIT(2)
@@ -947,12 +957,14 @@ struct wl1271_acx_ht_capabilities {
  * ACX_HT_BSS_OPERATION
  * Configure HT capabilities - AP rules for behavior in the BSS.
  */
 struct wl1271_acx_ht_information {
 	struct acx_header header;
 
+	u8 role_id;
+
 	/* Values: 0 - RIFS not allowed, 1 - RIFS allowed */
 	u8 rifs_mode;
 
 	/* Values: 0 - 3 like in spec */
 	u8 ht_protection;
 
@@ -968,13 +980,13 @@ struct wl1271_acx_ht_information {
 	 * Note: When this value is set to 1 FW will protect all TXOP with RTS
 	 * frame and will not use CTS-to-self regardless of the value of the
 	 * ACX_CTS_PROTECTION information element
 	 */
 	u8 dual_cts_protection;
 
-	u8 padding[3];
+	u8 padding[2];
 } __packed;
 
 #define RX_BA_WIN_SIZE 8
 
 struct wl1271_acx_ba_session_policy {
 	struct acx_header header;
@@ -1038,31 +1050,35 @@ struct wl1271_acx_fw_tsf_information {
 	u8 padding[3];
 } __packed;
 
 struct wl1271_acx_ps_rx_streaming {
 	struct acx_header header;
 
+	u8 role_id;
 	u8 tid;
 	u8 enable;
 
 	/* interval between triggers (10-100 msec) */
 	u8 period;
 
 	/* timeout before first trigger (0-200 msec) */
 	u8 timeout;
+	u8 padding[3];
 } __packed;
 
 struct wl1271_acx_ap_max_tx_retry {
 	struct acx_header header;
 
+	u8 role_id;
+	u8 padding_1;
+
 	/*
 	 * the number of frames transmission failures before
 	 * issuing the aging event.
 	 */
 	__le16 max_tx_retry;
-	u8 padding_1[2];
 } __packed;
 
 struct wl1271_acx_config_ps {
 	struct acx_header header;
 
 	u8 exit_retries;
@@ -1148,16 +1164,13 @@ enum {
 	ACX_WAKE_UP_CONDITIONS      = 0x0002,
 	ACX_MEM_CFG                 = 0x0003,
 	ACX_SLOT                    = 0x0004,
 	ACX_AC_CFG                  = 0x0007,
 	ACX_MEM_MAP                 = 0x0008,
 	ACX_AID                     = 0x000A,
-	/* ACX_FW_REV is missing in the ref driver, but seems to work */
-	ACX_FW_REV                  = 0x000D,
 	ACX_MEDIUM_USAGE            = 0x000F,
-	ACX_RX_CFG                  = 0x0010,
 	ACX_TX_QUEUE_CFG            = 0x0011, /* FIXME: only used by wl1251 */
 	ACX_STATISTICS              = 0x0013, /* Debug API */
 	ACX_PWR_CONSUMPTION_STATISTICS = 0x0014,
 	ACX_FEATURE_CFG             = 0x0015,
 	ACX_TID_CFG                 = 0x001A,
 	ACX_PS_RX_STREAMING         = 0x001B,
@@ -1167,13 +1180,12 @@ enum {
 	ACX_HDK_VERSION             = 0x0022, /* ??? */
 	ACX_PD_THRESHOLD            = 0x0023,
 	ACX_TX_CONFIG_OPT           = 0x0024,
 	ACX_CCA_THRESHOLD           = 0x0025,
 	ACX_EVENT_MBOX_MASK         = 0x0026,
 	ACX_CONN_MONIT_PARAMS       = 0x002D,
-	ACX_CONS_TX_FAILURE         = 0x002F,
 	ACX_BCN_DTIM_OPTIONS        = 0x0031,
 	ACX_SG_ENABLE               = 0x0032,
 	ACX_SG_CFG                  = 0x0033,
 	ACX_FM_COEX_CFG             = 0x0034,
 	ACX_BEACON_FILTER_TABLE     = 0x0038,
 	ACX_ARP_IP_FILTER           = 0x0039,
@@ -1199,12 +1211,16 @@ enum {
 	ACX_SET_KEEP_ALIVE_CONFIG   = 0x0054,
 	ACX_BA_SESSION_POLICY_CFG   = 0x0055,
 	ACX_BA_SESSION_RX_SETUP     = 0x0056,
 	ACX_PEER_HT_CAP             = 0x0057,
 	ACX_HT_BSS_OPERATION        = 0x0058,
 	ACX_COEX_ACTIVITY           = 0x0059,
+	ACX_BURST_MODE              = 0x005C,
+
+	ACX_SET_RATE_MAMAGEMENT_PARAMS = 0x005D,
+	ACX_SET_RATE_ADAPT_PARAMS   = 0x0060,
 	ACX_SET_DCO_ITRIM_PARAMS    = 0x0061,
 	ACX_GEN_FW_CMD              = 0x0070,
 	ACX_HOST_IF_CFG_BITMAP      = 0x0071,
 	ACX_MAX_TX_FAILURE          = 0x0072,
 	ACX_UPDATE_INCONNECTION_STA_LIST = 0x0073,
 	DOT11_RX_MSDU_LIFE_TIME     = 0x1004,
@@ -1253,14 +1269,13 @@ int wl1271_acx_ac_cfg(struct wl1271 *wl, u8 ac, u8 cw_min, u16 cw_max,
 		      u8 aifsn, u16 txop);
 int wl1271_acx_tid_cfg(struct wl1271 *wl, u8 queue_id, u8 channel_type,
 		       u8 tsid, u8 ps_scheme, u8 ack_policy,
 		       u32 apsd_conf0, u32 apsd_conf1);
 int wl1271_acx_frag_threshold(struct wl1271 *wl, u32 frag_threshold);
 int wl1271_acx_tx_config_options(struct wl1271 *wl);
-int wl1271_acx_ap_mem_cfg(struct wl1271 *wl);
-int wl1271_acx_sta_mem_cfg(struct wl1271 *wl);
+int wl1271_acx_mem_cfg(struct wl1271 *wl);
 int wl1271_acx_init_mem_config(struct wl1271 *wl);
 int wl1271_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap);
 int wl1271_acx_init_rx_interrupt(struct wl1271 *wl);
 int wl1271_acx_smart_reflex(struct wl1271 *wl);
 int wl1271_acx_bet_enable(struct wl1271 *wl, bool enable);
 int wl1271_acx_arp_ip_filter(struct wl1271 *wl, u8 enable, __be32 address);
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 7aa8fc7..a02bfbb 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -385,13 +385,13 @@ static int wl1271_sta_hw_init(struct wl1271 *wl)
 		return ret;
 
 	ret = wl1271_acx_sta_rate_policies(wl);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_acx_sta_mem_cfg(wl);
+	ret = wl1271_acx_mem_cfg(wl);
 	if (ret < 0)
 		return ret;
 
 	/* Configure the FW logger */
 	ret = wl12xx_init_fwlog(wl);
 	if (ret < 0)
@@ -444,13 +444,13 @@ static int wl1271_ap_hw_init(struct wl1271 *wl)
 		return ret;
 
 	ret = wl1271_acx_ap_max_tx_retry(wl);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_acx_ap_mem_cfg(wl);
+	ret = wl1271_acx_mem_cfg(wl);
 	if (ret < 0)
 		return ret;
 
 	/* initialize Tx power */
 	ret = wl1271_acx_tx_power(wl, wl->power_level);
 	if (ret < 0)
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 1ac1762..0ee98e0 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -715,13 +715,13 @@ static int wl1271_plt_init(struct wl1271 *wl)
 
 	/* Energy detection */
 	ret = wl1271_init_energy_detection(wl);
 	if (ret < 0)
 		goto out_free_memmap;
 
-	ret = wl1271_acx_sta_mem_cfg(wl);
+	ret = wl1271_acx_mem_cfg(wl);
 	if (ret < 0)
 		goto out_free_memmap;
 
 	/* Default fragmentation threshold */
 	ret = wl1271_acx_frag_threshold(wl, wl->conf.tx.frag_threshold);
 	if (ret < 0)
@@ -1972,12 +1972,13 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	wl->vif = NULL;
 	wl1271_free_ap_keys(wl);
 	memset(wl->ap_hlid_map, 0, sizeof(wl->ap_hlid_map));
 	wl->ap_fw_ps_map = 0;
 	wl->ap_ps_map = 0;
 	wl->sched_scanning = false;
+	wl->role_id = WL1271_INVALID_ROLE_ID;
 
 	/*
 	 * this is performed after the cancel_work calls and the associated
 	 * mutex_lock, so that wl1271_op_add_interface does not accidentally
 	 * get executed before all these vars have been reset.
 	 */
@@ -4308,12 +4309,14 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->ap_fw_ps_map = 0;
 	wl->quirks = 0;
 	wl->platform_quirks = 0;
 	wl->sched_scanning = false;
 	wl->tx_security_seq = 0;
 	wl->tx_security_last_seq_lsb = 0;
+	wl->role_id = WL1271_INVALID_ROLE_ID;
+	wl->sta_hlid = WL1271_INVALID_LINK_ID;
 
 	setup_timer(&wl->rx_streaming_timer, wl1271_rx_streaming_timer,
 		    (unsigned long) wl);
 	wl->fwlog_size = 0;
 	init_waitqueue_head(&wl->fwlog_waitq);
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 260b78c..4e4bafc 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -135,12 +135,14 @@ extern u32 wl12xx_debug_level;
 #define WL1271_ELP_HW_STATE_IRQ    1
 
 #define WL1271_DEFAULT_BEACON_INT  100
 #define WL1271_DEFAULT_DTIM_PERIOD 1
 
 #define WL1271_MAX_LINKS           8
+#define WL1271_INVALID_ROLE_ID     0xff
+#define WL1271_INVALID_LINK_ID     0xff
 #define WL1271_AP_GLOBAL_HLID      0
 #define WL1271_AP_BROADCAST_HLID   1
 #define WL1271_AP_STA_HLID_START   2
 
 /*
  * When in AP-mode, we allow (at least) this number of mem-blocks
@@ -387,12 +389,14 @@ struct wl1271 {
 	u8 mac_addr[ETH_ALEN];
 	u8 bss_type;
 	u8 set_bss_type;
 	u8 ssid[IW_ESSID_MAX_SIZE + 1];
 	u8 ssid_len;
 	int channel;
+	u8 role_id;
+	u8 sta_hlid;
 
 	struct wl1271_acx_mem_map *target_mem_map;
 
 	/* Accounting for allocated / available TX blocks on HW */
 	u32 tx_blocks_freed;
 	u32 tx_blocks_available;
-- 
1.7.6.401.g6a319

