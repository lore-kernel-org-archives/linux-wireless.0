Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:38890 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbZFLLOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:14:34 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 01/33] wl12xx: cmd and acx interface rework
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:14:19 +0300
Message-ID: <20090612111419.8877.80538.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Rework cmd and acx interfaces, it was just too confusing earlier. Now
all commands need to contain all the needed headers, either just cmd
headers or both cmd and acx headers. This accomplish to remove the
extra copy done for each command. The interfaces are now properly
documented as well.

Also try to make all commands safe for DMA transfers. I might have missed
some, but most of them should be fixed now.

And this is not all! As a free bonus you will also get some cosmetic
cleanups and code reorganisation. Order today!

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/acx.c    |  690 +++++++++++++++++++++-------------
 drivers/net/wireless/wl12xx/acx.h    |  126 +-----
 drivers/net/wireless/wl12xx/cmd.c    |  311 ++++++++++-----
 drivers/net/wireless/wl12xx/cmd.h    |  168 ++++++++
 drivers/net/wireless/wl12xx/main.c   |   87 +++-
 drivers/net/wireless/wl12xx/ps.c     |    2 
 drivers/net/wireless/wl12xx/ps.h     |    2 
 drivers/net/wireless/wl12xx/rx.c     |   27 -
 drivers/net/wireless/wl12xx/wl1251.c |   74 ++--
 9 files changed, 896 insertions(+), 591 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 1cfd458..d0daf69 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -13,126 +13,160 @@
 int wl12xx_acx_frame_rates(struct wl12xx *wl, u8 ctrl_rate, u8 ctrl_mod,
 			   u8 mgt_rate, u8 mgt_mod)
 {
+	struct acx_fw_gen_frame_rates *rates;
 	int ret;
-	struct acx_fw_gen_frame_rates rates;
 
 	wl12xx_debug(DEBUG_ACX, "acx frame rates");
 
-	rates.header.id = ACX_FW_GEN_FRAME_RATES;
-	rates.header.len = sizeof(struct acx_fw_gen_frame_rates) -
-		sizeof(struct acx_header);
+	rates = kzalloc(sizeof(*rates), GFP_KERNEL);
+	if (!rates) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	rates.tx_ctrl_frame_rate = ctrl_rate;
-	rates.tx_ctrl_frame_mod = ctrl_mod;
-	rates.tx_mgt_frame_rate = mgt_rate;
-	rates.tx_mgt_frame_mod = mgt_mod;
+	rates->tx_ctrl_frame_rate = ctrl_rate;
+	rates->tx_ctrl_frame_mod = ctrl_mod;
+	rates->tx_mgt_frame_rate = mgt_rate;
+	rates->tx_mgt_frame_mod = mgt_mod;
 
-	ret = wl12xx_cmd_configure(wl, &rates, sizeof(rates));
+	ret = wl12xx_cmd_configure(wl, ACX_FW_GEN_FRAME_RATES,
+				   rates, sizeof(*rates));
 	if (ret < 0) {
 		wl12xx_error("Failed to set FW rates and modulation");
-		return ret;
+		goto out;
 	}
 
-	return 0;
+out:
+	kfree(rates);
+	return ret;
 }
 
 
 int wl12xx_acx_station_id(struct wl12xx *wl)
 {
+	struct acx_dot11_station_id *mac;
 	int ret, i;
-	struct dot11_station_id mac;
 
 	wl12xx_debug(DEBUG_ACX, "acx dot11_station_id");
 
-	mac.header.id = DOT11_STATION_ID;
-	mac.header.len = sizeof(mac) - sizeof(struct acx_header);
+	mac = kzalloc(sizeof(*mac), GFP_KERNEL);
+	if (!mac) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	for (i = 0; i < ETH_ALEN; i++)
-		mac.mac[i] = wl->mac_addr[ETH_ALEN - 1 - i];
+		mac->mac[i] = wl->mac_addr[ETH_ALEN - 1 - i];
 
-	ret = wl12xx_cmd_configure(wl, &mac, sizeof(mac));
+	ret = wl12xx_cmd_configure(wl, DOT11_STATION_ID, mac, sizeof(*mac));
 	if (ret < 0)
-		return ret;
+		goto out;
 
-	return 0;
+out:
+	kfree(mac);
+	return ret;
 }
 
 int wl12xx_acx_default_key(struct wl12xx *wl, u8 key_id)
 {
-	struct acx_dot11_default_key default_key;
+	struct acx_dot11_default_key *default_key;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx dot11_default_key (%d)", key_id);
 
-	default_key.header.id = DOT11_DEFAULT_KEY;
-	default_key.header.len = sizeof(default_key) -
-		sizeof(struct acx_header);
+	default_key = kzalloc(sizeof(*default_key), GFP_KERNEL);
+	if (!default_key) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	default_key.id = key_id;
+	default_key->id = key_id;
 
-	ret = wl12xx_cmd_configure(wl, &default_key, sizeof(default_key));
+	ret = wl12xx_cmd_configure(wl, DOT11_DEFAULT_KEY,
+				   default_key, sizeof(*default_key));
 	if (ret < 0) {
 		wl12xx_error("Couldnt set default key");
-		return ret;
+		goto out;
 	}
 
 	wl->default_key = key_id;
 
-	return 0;
+out:
+	kfree(default_key);
+	return ret;
 }
 
 int wl12xx_acx_wake_up_conditions(struct wl12xx *wl, u8 listen_interval)
 {
-	struct acx_wake_up_condition wake_up;
+	struct acx_wake_up_condition *wake_up;
+	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx wake up conditions");
 
-	wake_up.header.id = ACX_WAKE_UP_CONDITIONS;
-	wake_up.header.len = sizeof(wake_up) - sizeof(struct acx_header);
+	wake_up = kzalloc(sizeof(*wake_up), GFP_KERNEL);
+	if (!wake_up) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	wake_up.wake_up_event = WAKE_UP_EVENT_DTIM_BITMAP;
-	wake_up.listen_interval = listen_interval;
+	wake_up->wake_up_event = WAKE_UP_EVENT_DTIM_BITMAP;
+	wake_up->listen_interval = listen_interval;
 
-	return wl12xx_cmd_configure(wl, &wake_up, sizeof(wake_up));
+	ret = wl12xx_cmd_configure(wl, ACX_WAKE_UP_CONDITIONS,
+				   wake_up, sizeof(*wake_up));
+	if (ret < 0) {
+		wl12xx_warning("could not set wake up conditions: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(wake_up);
+	return ret;
 }
 
 int wl12xx_acx_sleep_auth(struct wl12xx *wl, u8 sleep_auth)
 {
+	struct acx_sleep_auth *auth;
 	int ret;
-	struct acx_sleep_auth auth;
 
 	wl12xx_debug(DEBUG_ACX, "acx sleep auth");
 
-	auth.header.id = ACX_SLEEP_AUTH;
-	auth.header.len = sizeof(auth) - sizeof(struct acx_header);
+	auth = kzalloc(sizeof(*auth), GFP_KERNEL);
+	if (!auth) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	auth.sleep_auth = sleep_auth;
+	auth->sleep_auth = sleep_auth;
 
-	ret = wl12xx_cmd_configure(wl, &auth, sizeof(auth));
+	ret = wl12xx_cmd_configure(wl, ACX_SLEEP_AUTH, auth, sizeof(*auth));
 	if (ret < 0)
 		return ret;
 
-	return 0;
+out:
+	kfree(auth);
+	return ret;
 }
 
 int wl12xx_acx_fw_version(struct wl12xx *wl, char *buf, size_t len)
 {
-	struct wl12xx_command cmd;
 	struct acx_revision *rev;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx fw rev");
 
-	memset(&cmd, 0, sizeof(cmd));
+	rev = kzalloc(sizeof(*rev), GFP_KERNEL);
+	if (!rev) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	ret = wl12xx_cmd_interrogate(wl, ACX_FW_REV, sizeof(*rev), &cmd);
+	ret = wl12xx_cmd_interrogate(wl, ACX_FW_REV, rev, sizeof(*rev));
 	if (ret < 0) {
 		wl12xx_warning("ACX_FW_REV interrogate failed");
-		return ret;
+		goto out;
 	}
 
-	rev = (struct acx_revision *) &cmd.parameters;
-
 	/* be careful with the buffer sizes */
 	strncpy(buf, rev->fw_version, min(len, sizeof(rev->fw_version)));
 
@@ -143,12 +177,14 @@ int wl12xx_acx_fw_version(struct wl12xx *wl, char *buf, size_t len)
 	 */
 	buf[min(len, sizeof(rev->fw_version)) - 1] = '\0';
 
-	return 0;
+out:
+	kfree(rev);
+	return ret;
 }
 
 int wl12xx_acx_tx_power(struct wl12xx *wl, int power)
 {
-	struct acx_current_tx_power ie;
+	struct acx_current_tx_power *acx;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx dot11_cur_tx_pwr");
@@ -156,534 +192,648 @@ int wl12xx_acx_tx_power(struct wl12xx *wl, int power)
 	if (power < 0 || power > 25)
 		return -EINVAL;
 
-	memset(&ie, 0, sizeof(ie));
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	ie.header.id = DOT11_CUR_TX_PWR;
-	ie.header.len = sizeof(ie) - sizeof(struct acx_header);
-	ie.current_tx_power = power * 10;
+	acx->current_tx_power = power * 10;
 
-	ret = wl12xx_cmd_configure(wl, &ie, sizeof(ie));
+	ret = wl12xx_cmd_configure(wl, DOT11_CUR_TX_PWR, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl12xx_warning("configure of tx power failed: %d", ret);
-		return ret;
+		goto out;
 	}
 
-	return 0;
+out:
+	kfree(acx);
+	return ret;
 }
 
 int wl12xx_acx_feature_cfg(struct wl12xx *wl)
 {
-	struct acx_feature_config feature;
+	struct acx_feature_config *feature;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx feature cfg");
 
-	memset(&feature, 0, sizeof(feature));
-
-	feature.header.id = ACX_FEATURE_CFG;
-	feature.header.len = sizeof(feature) - sizeof(struct acx_header);
+	feature = kzalloc(sizeof(*feature), GFP_KERNEL);
+	if (!feature) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	/* DF_ENCRYPTION_DISABLE and DF_SNIFF_MODE_ENABLE are disabled */
-	feature.data_flow_options = 0;
-	feature.options = 0;
+	feature->data_flow_options = 0;
+	feature->options = 0;
 
-	ret = wl12xx_cmd_configure(wl, &feature, sizeof(feature));
-	if (ret < 0)
+	ret = wl12xx_cmd_configure(wl, ACX_FEATURE_CFG,
+				   feature, sizeof(*feature));
+	if (ret < 0) {
 		wl12xx_error("Couldnt set HW encryption");
+		goto out;
+	}
 
+out:
+	kfree(feature);
 	return ret;
 }
 
-int wl12xx_acx_mem_map(struct wl12xx *wl, void *mem_map, size_t len)
+int wl12xx_acx_mem_map(struct wl12xx *wl, struct acx_header *mem_map,
+		       size_t len)
 {
-	struct wl12xx_command cmd;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx mem map");
 
-	ret = wl12xx_cmd_interrogate(wl, ACX_MEM_MAP, len, &cmd);
+	ret = wl12xx_cmd_interrogate(wl, ACX_MEM_MAP, mem_map, len);
 	if (ret < 0)
 		return ret;
-	else if (cmd.status != CMD_STATUS_SUCCESS)
-		return -EIO;
-
-	memcpy(mem_map, &cmd.parameters, len);
 
 	return 0;
 }
 
 int wl12xx_acx_data_path_params(struct wl12xx *wl,
-				struct acx_data_path_params_resp *data_path)
+				struct acx_data_path_params_resp *resp)
 {
-	struct acx_data_path_params params;
-	struct wl12xx_command cmd;
+	struct acx_data_path_params *params;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx data path params");
 
-	params.rx_packet_ring_chunk_size = DP_RX_PACKET_RING_CHUNK_SIZE;
-	params.tx_packet_ring_chunk_size = DP_TX_PACKET_RING_CHUNK_SIZE;
+	params = kzalloc(sizeof(*params), GFP_KERNEL);
+	if (!params) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	params.rx_packet_ring_chunk_num = DP_RX_PACKET_RING_CHUNK_NUM;
-	params.tx_packet_ring_chunk_num = DP_TX_PACKET_RING_CHUNK_NUM;
+	params->rx_packet_ring_chunk_size = DP_RX_PACKET_RING_CHUNK_SIZE;
+	params->tx_packet_ring_chunk_size = DP_TX_PACKET_RING_CHUNK_SIZE;
 
-	params.tx_complete_threshold = 1;
+	params->rx_packet_ring_chunk_num = DP_RX_PACKET_RING_CHUNK_NUM;
+	params->tx_packet_ring_chunk_num = DP_TX_PACKET_RING_CHUNK_NUM;
 
-	params.tx_complete_ring_depth = FW_TX_CMPLT_BLOCK_SIZE;
+	params->tx_complete_threshold = 1;
 
-	params.tx_complete_timeout = DP_TX_COMPLETE_TIME_OUT;
+	params->tx_complete_ring_depth = FW_TX_CMPLT_BLOCK_SIZE;
 
-	params.header.id = ACX_DATA_PATH_PARAMS;
-	params.header.len = sizeof(params) - sizeof(struct acx_header);
+	params->tx_complete_timeout = DP_TX_COMPLETE_TIME_OUT;
 
-	ret = wl12xx_cmd_configure(wl, &params, sizeof(params));
+	ret = wl12xx_cmd_configure(wl, ACX_DATA_PATH_PARAMS,
+				   params, sizeof(*params));
 	if (ret < 0)
-		return ret;
-
+		goto out;
 
+	/* FIXME: shouldn't this be ACX_DATA_PATH_RESP_PARAMS? */
 	ret = wl12xx_cmd_interrogate(wl, ACX_DATA_PATH_PARAMS,
-				     sizeof(struct acx_data_path_params_resp),
-				     &cmd);
+				     resp, sizeof(*resp));
 
 	if (ret < 0) {
 		wl12xx_warning("failed to read data path parameters: %d", ret);
-		return ret;
-	} else if (cmd.status != CMD_STATUS_SUCCESS) {
+		goto out;
+	} else if (resp->header.cmd.status != CMD_STATUS_SUCCESS) {
 		wl12xx_warning("data path parameter acx status failed");
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
-	memcpy(data_path, &cmd.parameters, sizeof(*data_path));
-
-	return 0;
+out:
+	kfree(params);
+	return ret;
 }
 
 int wl12xx_acx_rx_msdu_life_time(struct wl12xx *wl, u32 life_time)
 {
-	struct rx_msdu_lifetime msdu_lifetime;
+	struct acx_rx_msdu_lifetime *acx;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx rx msdu life time");
 
-	msdu_lifetime.header.id = DOT11_RX_MSDU_LIFE_TIME;
-	msdu_lifetime.header.len = sizeof(msdu_lifetime) -
-		sizeof(struct acx_header);
-	msdu_lifetime.lifetime = life_time;
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	ret = wl12xx_cmd_configure(wl, &msdu_lifetime, sizeof(msdu_lifetime));
+	ret = wl12xx_cmd_configure(wl, DOT11_RX_MSDU_LIFE_TIME,
+				   acx, sizeof(*acx));
 	if (ret < 0) {
 		wl12xx_warning("failed to set rx msdu life time: %d", ret);
-		return ret;
+		goto out;
 	}
 
-	return 0;
+out:
+	kfree(acx);
+	return ret;
 }
 
 int wl12xx_acx_rx_config(struct wl12xx *wl, u32 config, u32 filter)
 {
-	struct acx_rx_config rx_config;
+	struct acx_rx_config *rx_config;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx rx config");
 
-	rx_config.header.id = ACX_RX_CFG;
-	rx_config.header.len = sizeof(rx_config) - sizeof(struct acx_header);
-	rx_config.config_options = config;
-	rx_config.filter_options = filter;
+	rx_config = kzalloc(sizeof(*rx_config), GFP_KERNEL);
+	if (!rx_config) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	rx_config->config_options = config;
+	rx_config->filter_options = filter;
 
-	ret = wl12xx_cmd_configure(wl, &rx_config, sizeof(rx_config));
+	ret = wl12xx_cmd_configure(wl, ACX_RX_CFG,
+				   rx_config, sizeof(*rx_config));
 	if (ret < 0) {
 		wl12xx_warning("failed to set rx config: %d", ret);
-		return ret;
+		goto out;
 	}
 
-	return 0;
+out:
+	kfree(rx_config);
+	return ret;
 }
 
 int wl12xx_acx_pd_threshold(struct wl12xx *wl)
 {
-	struct acx_packet_detection packet_detection;
+	struct acx_packet_detection *pd;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx data pd threshold");
 
+	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
+	if (!pd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	/* FIXME: threshold value not set */
-	packet_detection.header.id = ACX_PD_THRESHOLD;
-	packet_detection.header.len = sizeof(packet_detection) -
-		sizeof(struct acx_header);
 
-	ret = wl12xx_cmd_configure(wl, &packet_detection,
-				   sizeof(packet_detection));
+	ret = wl12xx_cmd_configure(wl, ACX_PD_THRESHOLD, pd, sizeof(*pd));
 	if (ret < 0) {
 		wl12xx_warning("failed to set pd threshold: %d", ret);
-		return ret;
+		goto out;
 	}
 
+out:
+	kfree(pd);
 	return 0;
 }
 
 int wl12xx_acx_slot(struct wl12xx *wl, enum acx_slot_type slot_time)
 {
-	struct acx_slot slot;
+	struct acx_slot *slot;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx slot");
 
-	slot.header.id = ACX_SLOT;
-	slot.header.len = sizeof(slot) - sizeof(struct acx_header);
+	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
+	if (!slot) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	slot.wone_index = STATION_WONE_INDEX;
-	slot.slot_time = slot_time;
+	slot->wone_index = STATION_WONE_INDEX;
+	slot->slot_time = slot_time;
 
-	ret = wl12xx_cmd_configure(wl, &slot, sizeof(slot));
+	ret = wl12xx_cmd_configure(wl, ACX_SLOT, slot, sizeof(*slot));
 	if (ret < 0) {
 		wl12xx_warning("failed to set slot time: %d", ret);
-		return ret;
+		goto out;
 	}
 
-	return 0;
+out:
+	kfree(slot);
+	return ret;
 }
 
 int wl12xx_acx_group_address_tbl(struct wl12xx *wl)
 {
-	struct multicast_grp_addr_start multicast;
+	struct acx_dot11_grp_addr_tbl *acx;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx group address tbl");
 
-	/* MAC filtering */
-	multicast.header.id = DOT11_GROUP_ADDRESS_TBL;
-	multicast.header.len = sizeof(multicast) - sizeof(struct acx_header);
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	multicast.enabled = 0;
-	multicast.num_groups = 0;
-	memset(multicast.mac_table, 0, ADDRESS_GROUP_MAX_LEN);
+	/* MAC filtering */
+	acx->enabled = 0;
+	acx->num_groups = 0;
+	memset(acx->mac_table, 0, ADDRESS_GROUP_MAX_LEN);
 
-	ret = wl12xx_cmd_configure(wl, &multicast, sizeof(multicast));
+	ret = wl12xx_cmd_configure(wl, DOT11_GROUP_ADDRESS_TBL,
+				   acx, sizeof(*acx));
 	if (ret < 0) {
 		wl12xx_warning("failed to set group addr table: %d", ret);
-		return ret;
+		goto out;
 	}
 
-	return 0;
+out:
+	kfree(acx);
+	return ret;
 }
 
 int wl12xx_acx_service_period_timeout(struct wl12xx *wl)
 {
-	struct acx_rx_timeout rx_timeout;
+	struct acx_rx_timeout *rx_timeout;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx service period timeout");
+	rx_timeout = kzalloc(sizeof(*rx_timeout), GFP_KERNEL);
+	if (!rx_timeout) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	/* RX timeout */
-	rx_timeout.header.id = ACX_SERVICE_PERIOD_TIMEOUT;
-	rx_timeout.header.len = sizeof(rx_timeout) - sizeof(struct acx_header);
+	wl12xx_debug(DEBUG_ACX, "acx service period timeout");
 
-	rx_timeout.ps_poll_timeout = RX_TIMEOUT_PS_POLL_DEF;
-	rx_timeout.upsd_timeout = RX_TIMEOUT_UPSD_DEF;
+	rx_timeout->ps_poll_timeout = RX_TIMEOUT_PS_POLL_DEF;
+	rx_timeout->upsd_timeout = RX_TIMEOUT_UPSD_DEF;
 
-	ret = wl12xx_cmd_configure(wl, &rx_timeout, sizeof(rx_timeout));
+	ret = wl12xx_cmd_configure(wl, ACX_SERVICE_PERIOD_TIMEOUT,
+				   rx_timeout, sizeof(*rx_timeout));
 	if (ret < 0) {
 		wl12xx_warning("failed to set service period timeout: %d",
 			       ret);
-		return ret;
+		goto out;
 	}
 
-	return 0;
+out:
+	kfree(rx_timeout);
+	return ret;
 }
 
 int wl12xx_acx_rts_threshold(struct wl12xx *wl, u16 rts_threshold)
 {
-	struct acx_rts_threshold rts;
+	struct acx_rts_threshold *rts;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx rts threshold");
 
-	rts.header.id = DOT11_RTS_THRESHOLD;
-	rts.header.len = sizeof(rts) - sizeof(struct acx_header);
+	rts = kzalloc(sizeof(*rts), GFP_KERNEL);
+	if (!rts) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	rts.threshold = rts_threshold;
+	rts->threshold = rts_threshold;
 
-	ret = wl12xx_cmd_configure(wl, &rts, sizeof(rts));
+	ret = wl12xx_cmd_configure(wl, DOT11_RTS_THRESHOLD, rts, sizeof(*rts));
 	if (ret < 0) {
 		wl12xx_warning("failed to set rts threshold: %d", ret);
-		return ret;
+		goto out;
 	}
 
-	return 0;
+out:
+	kfree(rts);
+	return ret;
 }
 
 int wl12xx_acx_beacon_filter_opt(struct wl12xx *wl)
 {
-	struct acx_beacon_filter_option beacon_filter;
+	struct acx_beacon_filter_option *beacon_filter;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx beacon filter opt");
 
-	beacon_filter.header.id = ACX_BEACON_FILTER_OPT;
-	beacon_filter.header.len = sizeof(beacon_filter) -
-		sizeof(struct acx_header);
+	beacon_filter = kzalloc(sizeof(*beacon_filter), GFP_KERNEL);
+	if (!beacon_filter) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	beacon_filter.enable = 0;
-	beacon_filter.max_num_beacons = 0;
+	beacon_filter->enable = 0;
+	beacon_filter->max_num_beacons = 0;
 
-	ret = wl12xx_cmd_configure(wl, &beacon_filter, sizeof(beacon_filter));
+	ret = wl12xx_cmd_configure(wl, ACX_BEACON_FILTER_OPT,
+				   beacon_filter, sizeof(*beacon_filter));
 	if (ret < 0) {
 		wl12xx_warning("failed to set beacon filter opt: %d", ret);
-		return ret;
+		goto out;
 	}
 
-	return 0;
+out:
+	kfree(beacon_filter);
+	return ret;
 }
 
 int wl12xx_acx_beacon_filter_table(struct wl12xx *wl)
 {
-	struct acx_beacon_filter_ie_table ie_table;
+	struct acx_beacon_filter_ie_table *ie_table;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx beacon filter table");
 
-	ie_table.header.id = ACX_BEACON_FILTER_TABLE;
-	ie_table.header.len = sizeof(ie_table) - sizeof(struct acx_header);
+	ie_table = kzalloc(sizeof(*ie_table), GFP_KERNEL);
+	if (!ie_table) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	ie_table.num_ie = 0;
-	memset(ie_table.table, 0, BEACON_FILTER_TABLE_MAX_SIZE);
+	ie_table->num_ie = 0;
+	memset(ie_table->table, 0, BEACON_FILTER_TABLE_MAX_SIZE);
 
-	ret = wl12xx_cmd_configure(wl, &ie_table, sizeof(ie_table));
+	ret = wl12xx_cmd_configure(wl, ACX_BEACON_FILTER_TABLE,
+				   ie_table, sizeof(*ie_table));
 	if (ret < 0) {
 		wl12xx_warning("failed to set beacon filter table: %d", ret);
-		return ret;
+		goto out;
 	}
 
-	return 0;
+out:
+	kfree(ie_table);
+	return ret;
 }
 
 int wl12xx_acx_sg_enable(struct wl12xx *wl)
 {
-	struct acx_bt_wlan_coex pta;
+	struct acx_bt_wlan_coex *pta;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx sg enable");
 
-	pta.header.id = ACX_SG_ENABLE;
-	pta.header.len = sizeof(pta) - sizeof(struct acx_header);
+	pta = kzalloc(sizeof(*pta), GFP_KERNEL);
+	if (!pta) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	pta.enable = SG_ENABLE;
+	pta->enable = SG_ENABLE;
 
-	ret = wl12xx_cmd_configure(wl, &pta, sizeof(pta));
+	ret = wl12xx_cmd_configure(wl, ACX_SG_ENABLE, pta, sizeof(*pta));
 	if (ret < 0) {
 		wl12xx_warning("failed to set softgemini enable: %d", ret);
-		return ret;
+		goto out;
 	}
 
-	return 0;
+out:
+	kfree(pta);
+	return ret;
 }
 
 int wl12xx_acx_sg_cfg(struct wl12xx *wl)
 {
-	struct acx_bt_wlan_coex_param param;
+	struct acx_bt_wlan_coex_param *param;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx sg cfg");
 
+	param = kzalloc(sizeof(*param), GFP_KERNEL);
+	if (!param) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	/* BT-WLAN coext parameters */
-	param.header.id = ACX_SG_CFG;
-	param.header.len = sizeof(param) - sizeof(struct acx_header);
-
-	param.min_rate = RATE_INDEX_24MBPS;
-	param.bt_hp_max_time = PTA_BT_HP_MAXTIME_DEF;
-	param.wlan_hp_max_time = PTA_WLAN_HP_MAX_TIME_DEF;
-	param.sense_disable_timer = PTA_SENSE_DISABLE_TIMER_DEF;
-	param.rx_time_bt_hp = PTA_PROTECTIVE_RX_TIME_DEF;
-	param.tx_time_bt_hp = PTA_PROTECTIVE_TX_TIME_DEF;
-	param.rx_time_bt_hp_fast = PTA_PROTECTIVE_RX_TIME_FAST_DEF;
-	param.tx_time_bt_hp_fast = PTA_PROTECTIVE_TX_TIME_FAST_DEF;
-	param.wlan_cycle_fast = PTA_CYCLE_TIME_FAST_DEF;
-	param.bt_anti_starvation_period = PTA_ANTI_STARVE_PERIOD_DEF;
-	param.next_bt_lp_packet = PTA_TIMEOUT_NEXT_BT_LP_PACKET_DEF;
-	param.wake_up_beacon = PTA_TIME_BEFORE_BEACON_DEF;
-	param.hp_dm_max_guard_time = PTA_HPDM_MAX_TIME_DEF;
-	param.next_wlan_packet = PTA_TIME_OUT_NEXT_WLAN_DEF;
-	param.antenna_type = PTA_ANTENNA_TYPE_DEF;
-	param.signal_type = PTA_SIGNALING_TYPE_DEF;
-	param.afh_leverage_on = PTA_AFH_LEVERAGE_ON_DEF;
-	param.quiet_cycle_num = PTA_NUMBER_QUIET_CYCLE_DEF;
-	param.max_cts = PTA_MAX_NUM_CTS_DEF;
-	param.wlan_packets_num = PTA_NUMBER_OF_WLAN_PACKETS_DEF;
-	param.bt_packets_num = PTA_NUMBER_OF_BT_PACKETS_DEF;
-	param.missed_rx_avalanche = PTA_RX_FOR_AVALANCHE_DEF;
-	param.wlan_elp_hp = PTA_ELP_HP_DEF;
-	param.bt_anti_starvation_cycles = PTA_ANTI_STARVE_NUM_CYCLE_DEF;
-	param.ack_mode_dual_ant = PTA_ACK_MODE_DEF;
-	param.pa_sd_enable = PTA_ALLOW_PA_SD_DEF;
-	param.pta_auto_mode_enable = PTA_AUTO_MODE_NO_CTS_DEF;
-	param.bt_hp_respected_num = PTA_BT_HP_RESPECTED_DEF;
-
-	ret = wl12xx_cmd_configure(wl, &param, sizeof(param));
+	param->min_rate = RATE_INDEX_24MBPS;
+	param->bt_hp_max_time = PTA_BT_HP_MAXTIME_DEF;
+	param->wlan_hp_max_time = PTA_WLAN_HP_MAX_TIME_DEF;
+	param->sense_disable_timer = PTA_SENSE_DISABLE_TIMER_DEF;
+	param->rx_time_bt_hp = PTA_PROTECTIVE_RX_TIME_DEF;
+	param->tx_time_bt_hp = PTA_PROTECTIVE_TX_TIME_DEF;
+	param->rx_time_bt_hp_fast = PTA_PROTECTIVE_RX_TIME_FAST_DEF;
+	param->tx_time_bt_hp_fast = PTA_PROTECTIVE_TX_TIME_FAST_DEF;
+	param->wlan_cycle_fast = PTA_CYCLE_TIME_FAST_DEF;
+	param->bt_anti_starvation_period = PTA_ANTI_STARVE_PERIOD_DEF;
+	param->next_bt_lp_packet = PTA_TIMEOUT_NEXT_BT_LP_PACKET_DEF;
+	param->wake_up_beacon = PTA_TIME_BEFORE_BEACON_DEF;
+	param->hp_dm_max_guard_time = PTA_HPDM_MAX_TIME_DEF;
+	param->next_wlan_packet = PTA_TIME_OUT_NEXT_WLAN_DEF;
+	param->antenna_type = PTA_ANTENNA_TYPE_DEF;
+	param->signal_type = PTA_SIGNALING_TYPE_DEF;
+	param->afh_leverage_on = PTA_AFH_LEVERAGE_ON_DEF;
+	param->quiet_cycle_num = PTA_NUMBER_QUIET_CYCLE_DEF;
+	param->max_cts = PTA_MAX_NUM_CTS_DEF;
+	param->wlan_packets_num = PTA_NUMBER_OF_WLAN_PACKETS_DEF;
+	param->bt_packets_num = PTA_NUMBER_OF_BT_PACKETS_DEF;
+	param->missed_rx_avalanche = PTA_RX_FOR_AVALANCHE_DEF;
+	param->wlan_elp_hp = PTA_ELP_HP_DEF;
+	param->bt_anti_starvation_cycles = PTA_ANTI_STARVE_NUM_CYCLE_DEF;
+	param->ack_mode_dual_ant = PTA_ACK_MODE_DEF;
+	param->pa_sd_enable = PTA_ALLOW_PA_SD_DEF;
+	param->pta_auto_mode_enable = PTA_AUTO_MODE_NO_CTS_DEF;
+	param->bt_hp_respected_num = PTA_BT_HP_RESPECTED_DEF;
+
+	ret = wl12xx_cmd_configure(wl, ACX_SG_CFG, param, sizeof(*param));
 	if (ret < 0) {
 		wl12xx_warning("failed to set sg config: %d", ret);
-		return ret;
+		goto out;
 	}
 
-	return 0;
+out:
+	kfree(param);
+	return ret;
 }
 
 int wl12xx_acx_cca_threshold(struct wl12xx *wl)
 {
-	struct acx_energy_detection detection;
+	struct acx_energy_detection *detection;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx cca threshold");
 
-	detection.header.id = ACX_CCA_THRESHOLD;
-	detection.header.len = sizeof(detection) - sizeof(struct acx_header);
+	detection = kzalloc(sizeof(*detection), GFP_KERNEL);
+	if (!detection) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	detection.rx_cca_threshold = CCA_THRSH_DISABLE_ENERGY_D;
-	detection.tx_energy_detection = 0;
+	detection->rx_cca_threshold = CCA_THRSH_DISABLE_ENERGY_D;
+	detection->tx_energy_detection = 0;
 
-	ret = wl12xx_cmd_configure(wl, &detection, sizeof(detection));
+	ret = wl12xx_cmd_configure(wl, ACX_CCA_THRESHOLD,
+				   detection, sizeof(*detection));
 	if (ret < 0) {
 		wl12xx_warning("failed to set cca threshold: %d", ret);
 		return ret;
 	}
 
-	return 0;
+out:
+	kfree(detection);
+	return ret;
 }
 
 int wl12xx_acx_bcn_dtim_options(struct wl12xx *wl)
 {
-	struct acx_beacon_broadcast bb;
+	struct acx_beacon_broadcast *bb;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx bcn dtim options");
 
-	bb.header.id = ACX_BCN_DTIM_OPTIONS;
-	bb.header.len = sizeof(bb) - sizeof(struct acx_header);
+	bb = kzalloc(sizeof(*bb), GFP_KERNEL);
+	if (!bb) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	bb.beacon_rx_timeout = BCN_RX_TIMEOUT_DEF_VALUE;
-	bb.broadcast_timeout = BROADCAST_RX_TIMEOUT_DEF_VALUE;
-	bb.rx_broadcast_in_ps = RX_BROADCAST_IN_PS_DEF_VALUE;
-	bb.ps_poll_threshold = CONSECUTIVE_PS_POLL_FAILURE_DEF;
+	bb->beacon_rx_timeout = BCN_RX_TIMEOUT_DEF_VALUE;
+	bb->broadcast_timeout = BROADCAST_RX_TIMEOUT_DEF_VALUE;
+	bb->rx_broadcast_in_ps = RX_BROADCAST_IN_PS_DEF_VALUE;
+	bb->ps_poll_threshold = CONSECUTIVE_PS_POLL_FAILURE_DEF;
 
-	ret = wl12xx_cmd_configure(wl, &bb, sizeof(bb));
+	ret = wl12xx_cmd_configure(wl, ACX_BCN_DTIM_OPTIONS, bb, sizeof(*bb));
 	if (ret < 0) {
 		wl12xx_warning("failed to set rx config: %d", ret);
-		return ret;
+		goto out;
 	}
 
-	return 0;
+out:
+	kfree(bb);
+	return ret;
 }
 
 int wl12xx_acx_aid(struct wl12xx *wl, u16 aid)
 {
-	struct acx_aid acx_aid;
+	struct acx_aid *acx_aid;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx aid");
 
-	acx_aid.header.id = ACX_AID;
-	acx_aid.header.len = sizeof(acx_aid) - sizeof(struct acx_header);
+	acx_aid = kzalloc(sizeof(*acx_aid), GFP_KERNEL);
+	if (!acx_aid) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	acx_aid.aid = aid;
+	acx_aid->aid = aid;
 
-	ret = wl12xx_cmd_configure(wl, &acx_aid, sizeof(acx_aid));
+	ret = wl12xx_cmd_configure(wl, ACX_AID, acx_aid, sizeof(*acx_aid));
 	if (ret < 0) {
 		wl12xx_warning("failed to set aid: %d", ret);
-		return ret;
+		goto out;
 	}
 
-	return 0;
+out:
+	kfree(acx_aid);
+	return ret;
 }
 
 int wl12xx_acx_event_mbox_mask(struct wl12xx *wl, u32 event_mask)
 {
-	struct acx_event_mask mask;
+	struct acx_event_mask *mask;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx event mbox mask");
 
-	mask.header.id = ACX_EVENT_MBOX_MASK;
-	mask.header.len = sizeof(mask) - sizeof(struct acx_header);
+	mask = kzalloc(sizeof(*mask), GFP_KERNEL);
+	if (!mask) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	/* high event mask is unused */
-	mask.high_event_mask = 0xffffffff;
+	mask->high_event_mask = 0xffffffff;
 
-	mask.event_mask = event_mask;
+	mask->event_mask = event_mask;
 
-	ret = wl12xx_cmd_configure(wl, &mask, sizeof(mask));
+	ret = wl12xx_cmd_configure(wl, ACX_EVENT_MBOX_MASK,
+				   mask, sizeof(*mask));
 	if (ret < 0) {
 		wl12xx_warning("failed to set aid: %d", ret);
-		return ret;
+		goto out;
 	}
 
-	return 0;
+out:
+	kfree(mask);
+	return ret;
 }
 
 int wl12xx_acx_set_preamble(struct wl12xx *wl, enum acx_preamble_type preamble)
 {
-	struct acx_preamble ie;
+	struct acx_preamble *acx;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx_set_preamble");
 
-	memset(&ie, 0, sizeof(ie));
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	ie.header.id = ACX_PREAMBLE_TYPE;
-	ie.header.len = sizeof(ie) - sizeof(struct acx_header);
-	ie.preamble = preamble;
-	ret = wl12xx_cmd_configure(wl, &ie, sizeof(ie));
+	acx->preamble = preamble;
+
+	ret = wl12xx_cmd_configure(wl, ACX_PREAMBLE_TYPE, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl12xx_warning("Setting of preamble failed: %d", ret);
-		return ret;
+		goto out;
 	}
-	return 0;
+
+out:
+	kfree(acx);
+	return ret;
 }
 
 int wl12xx_acx_cts_protect(struct wl12xx *wl,
 			   enum acx_ctsprotect_type ctsprotect)
 {
-	struct acx_ctsprotect ie;
+	struct acx_ctsprotect *acx;
 	int ret;
 
 	wl12xx_debug(DEBUG_ACX, "acx_set_ctsprotect");
 
-	memset(&ie, 0, sizeof(ie));
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->ctsprotect = ctsprotect;
 
-	ie.header.id = ACX_CTS_PROTECTION;
-	ie.header.len = sizeof(ie) - sizeof(struct acx_header);
-	ie.ctsprotect = ctsprotect;
-	ret = wl12xx_cmd_configure(wl, &ie, sizeof(ie));
+	ret = wl12xx_cmd_configure(wl, ACX_CTS_PROTECTION, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl12xx_warning("Setting of ctsprotect failed: %d", ret);
-		return ret;
+		goto out;
 	}
-	return 0;
+
+out:
+	kfree(acx);
+	return ret;
 }
 
-int wl12xx_acx_statistics(struct wl12xx *wl, struct acx_statistics *stats)
+int wl12xx_acx_tsf_info(struct wl12xx *wl, u64 *mactime)
 {
-	struct wl12xx_command *answer;
+	struct acx_tsf_info *tsf_info;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx statistics");
-
-	answer = kmalloc(sizeof(*answer), GFP_KERNEL);
-	if (!answer) {
-		wl12xx_warning("could not allocate memory for acx statistics");
+	tsf_info = kzalloc(sizeof(*tsf_info), GFP_KERNEL);
+	if (!tsf_info) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	ret = wl12xx_cmd_interrogate(wl, ACX_STATISTICS, sizeof(*answer),
-				     answer);
+	ret = wl12xx_cmd_interrogate(wl, ACX_TSF_INFO,
+				     tsf_info, sizeof(*tsf_info));
 	if (ret < 0) {
-		wl12xx_warning("acx statistics failed: %d", ret);
+		wl12xx_warning("ACX_FW_REV interrogate failed");
 		goto out;
 	}
 
-	memcpy(stats, answer->parameters, sizeof(*stats));
+	*mactime = tsf_info->current_tsf_lsb |
+		(tsf_info->current_tsf_msb << 31);
 
 out:
-	kfree(answer);
+	kfree(tsf_info);
 	return ret;
 }
+
+int wl12xx_acx_statistics(struct wl12xx *wl, struct acx_statistics *stats)
+{
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx statistics");
+
+	ret = wl12xx_cmd_interrogate(wl, ACX_STATISTICS, stats,
+				     sizeof(*stats));
+	if (ret < 0) {
+		wl12xx_warning("acx statistics failed: %d", ret);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index fb2d234..549e537 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -26,10 +26,16 @@
 #define __WL12XX_ACX_H__
 
 #include "wl12xx.h"
+#include "cmd.h"
 
 /* Target's information element */
 struct acx_header {
+	struct wl12xx_cmd_header cmd;
+
+	/* acx (or information element) header */
 	u16 id;
+
+	/* payload length (not including headers */
 	u16 len;
 };
 
@@ -107,25 +113,6 @@ struct acx_sleep_auth {
 	u8  padding[3];
 } __attribute__ ((packed));
 
-#define TIM_ELE_ID    5
-#define PARTIAL_VBM_MAX    251
-
-struct tim {
-	u8 identity;
-	u8 length;
-	u8 dtim_count;
-	u8 dtim_period;
-	u8 bitmap_ctrl;
-	u8 pvb_field[PARTIAL_VBM_MAX]; /* Partial Virtual Bitmap */
-} __attribute__ ((packed));
-
-/* Virtual Bit Map update */
-struct vbm_update_request {
-	__le16 len;
-	u8  padding[2];
-	struct tim tim;
-} __attribute__ ((packed));
-
 enum {
 	HOSTIF_PCI_MASTER_HOST_INDIRECT,
 	HOSTIF_PCI_MASTER_HOST_DIRECT,
@@ -202,7 +189,7 @@ struct acx_data_path_params_resp {
 #define RX_MSDU_LIFETIME_MAX       0xFFFFFFFF
 #define RX_MSDU_LIFETIME_DEF       512000
 
-struct rx_msdu_lifetime {
+struct acx_rx_msdu_lifetime {
 	struct acx_header header;
 
 	/*
@@ -368,7 +355,7 @@ struct acx_slot {
 #define ADDRESS_GROUP_MAX	(8)
 #define ADDRESS_GROUP_MAX_LEN	(ETH_ALEN * ADDRESS_GROUP_MAX)
 
-struct multicast_grp_addr_start {
+struct acx_dot11_grp_addr_tbl {
 	struct acx_header header;
 
 	u8 enabled;
@@ -730,22 +717,13 @@ struct acx_fw_gen_frame_rates {
 } __attribute__ ((packed));
 
 /* STA MAC */
-struct dot11_station_id {
+struct acx_dot11_station_id {
 	struct acx_header header;
 
 	u8 mac[ETH_ALEN];
 	u8 pad[2];
 } __attribute__ ((packed));
 
-/* HW encryption keys */
-#define NUM_ACCESS_CATEGORIES_COPY 4
-#define MAX_KEY_SIZE 32
-
-/* When set, disable HW encryption */
-#define DF_ENCRYPTION_DISABLE      0x01
-/* When set, disable HW decryption */
-#define DF_SNIFF_MODE_ENABLE       0x80
-
 struct acx_feature_config {
 	struct acx_header header;
 
@@ -753,67 +731,6 @@ struct acx_feature_config {
 	u32 data_flow_options;
 } __attribute__ ((packed));
 
-enum acx_key_action {
-	KEY_ADD_OR_REPLACE = 1,
-	KEY_REMOVE         = 2,
-	KEY_SET_ID         = 3,
-	MAX_KEY_ACTION     = 0xffff,
-};
-
-enum acx_key_type {
-	KEY_WEP_DEFAULT       = 0,
-	KEY_WEP_ADDR          = 1,
-	KEY_AES_GROUP         = 4,
-	KEY_AES_PAIRWISE      = 5,
-	KEY_WEP_GROUP         = 6,
-	KEY_TKIP_MIC_GROUP    = 10,
-	KEY_TKIP_MIC_PAIRWISE = 11,
-};
-
-/*
- *
- * key_type_e   key size    key format
- * ----------   ---------   ----------
- * 0x00         5, 13, 29   Key data
- * 0x01         5, 13, 29   Key data
- * 0x04         16          16 bytes of key data
- * 0x05         16          16 bytes of key data
- * 0x0a         32          16 bytes of TKIP key data
- *                          8 bytes of RX MIC key data
- *                          8 bytes of TX MIC key data
- * 0x0b         32          16 bytes of TKIP key data
- *                          8 bytes of RX MIC key data
- *                          8 bytes of TX MIC key data
- *
- */
-
-struct acx_set_key {
-	/* Ignored for default WEP key */
-	u8 addr[ETH_ALEN];
-
-	/* key_action_e */
-	u16 key_action;
-
-	u16 reserved_1;
-
-	/* key size in bytes */
-	u8 key_size;
-
-	/* key_type_e */
-	u8 key_type;
-	u8 ssid_profile;
-
-	/*
-	 * TKIP, AES: frame's key id field.
-	 * For WEP default key: key id;
-	 */
-	u8 id;
-	u8 reserved_2[6];
-	u8 key[MAX_KEY_SIZE];
-	u16 ac_seq_num16[NUM_ACCESS_CATEGORIES_COPY];
-	u32 ac_seq_num32[NUM_ACCESS_CATEGORIES_COPY];
-} __attribute__ ((packed));
-
 struct acx_current_tx_power {
 	struct acx_header header;
 
@@ -839,26 +756,6 @@ struct acx_tsf_info {
 	u8 pad[3];
 } __attribute__ ((packed));
 
-/* 802.11 PS */
-enum acx_ps_mode {
-	STATION_ACTIVE_MODE,
-	STATION_POWER_SAVE_MODE
-};
-
-struct acx_ps_params {
-	u8 ps_mode; /* STATION_* */
-	u8 send_null_data; /* Do we have to send NULL data packet ? */
-	u8 retries; /* Number of retires for the initial NULL data packet */
-
-	 /*
-	  * TUs during which the target stays awake after switching
-	  * to power save mode.
-	  */
-	u8 hang_over_period;
-	u16 null_data_rate;
-	u8 pad[2];
-} __attribute__ ((packed));
-
 enum acx_wake_up_event {
 	WAKE_UP_EVENT_BEACON_BITMAP	= 0x01, /* Wake on every Beacon*/
 	WAKE_UP_EVENT_DTIM_BITMAP	= 0x02,	/* Wake on every DTIM*/
@@ -892,6 +789,7 @@ enum acx_preamble_type {
 
 struct acx_preamble {
 	struct acx_header header;
+
 	/*
 	 * When set, the WiLink transmits the frames with a short preamble and
 	 * when cleared, the WiLink transmits the frames with a long preamble.
@@ -1219,7 +1117,8 @@ int wl12xx_acx_sleep_auth(struct wl12xx *wl, u8 sleep_auth);
 int wl12xx_acx_fw_version(struct wl12xx *wl, char *buf, size_t len);
 int wl12xx_acx_tx_power(struct wl12xx *wl, int power);
 int wl12xx_acx_feature_cfg(struct wl12xx *wl);
-int wl12xx_acx_mem_map(struct wl12xx *wl, void *mem_map, size_t len);
+int wl12xx_acx_mem_map(struct wl12xx *wl,
+		       struct acx_header *mem_map, size_t len);
 int wl12xx_acx_data_path_params(struct wl12xx *wl,
 				struct acx_data_path_params_resp *data_path);
 int wl12xx_acx_rx_msdu_life_time(struct wl12xx *wl, u32 life_time);
@@ -1241,5 +1140,6 @@ int wl12xx_acx_set_preamble(struct wl12xx *wl, enum acx_preamble_type preamble);
 int wl12xx_acx_cts_protect(struct wl12xx *wl,
 			    enum acx_ctsprotect_type ctsprotect);
 int wl12xx_acx_statistics(struct wl12xx *wl, struct acx_statistics *stats);
+int wl12xx_acx_tsf_info(struct wl12xx *wl, u64 *mactime);
 
 #endif /* __WL12XX_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index f73ab60..0a02cdd 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -9,24 +9,32 @@
 #include "reg.h"
 #include "spi.h"
 #include "ps.h"
-
-int wl12xx_cmd_send(struct wl12xx *wl, u16 type, void *buf, size_t buf_len)
+#include "acx.h"
+
+/**
+ * send command to firmware
+ *
+ * @wl: wl struct
+ * @id: command id
+ * @buf: buffer containing the command, must work with dma
+ * @len: length of the buffer
+ */
+int wl12xx_cmd_send(struct wl12xx *wl, u16 id, void *buf, size_t len)
 {
-	struct wl12xx_command cmd;
+	struct wl12xx_cmd_header *cmd;
 	unsigned long timeout;
-	size_t cmd_len;
 	u32 intr;
 	int ret = 0;
 
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.id = type;
-	cmd.status = 0;
-	memcpy(cmd.parameters, buf, buf_len);
-	cmd_len = ALIGN(buf_len, 4) + CMDMBOX_HEADER_LEN;
+	cmd = buf;
+	cmd->id = id;
+	cmd->status = 0;
+
+	WARN_ON(len % 4 != 0);
 
 	wl12xx_ps_elp_wakeup(wl);
 
-	wl12xx_spi_mem_write(wl, wl->cmd_box_addr, &cmd, cmd_len);
+	wl12xx_spi_mem_write(wl, wl->cmd_box_addr, buf, len);
 
 	wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_CMD);
 
@@ -54,21 +62,42 @@ out:
 	return ret;
 }
 
+/**
+ * send test command to firmware
+ *
+ * @wl: wl struct
+ * @buf: buffer containing the command, without headers, no dma requirements
+ * @len: length of the buffer
+ * @answer: is answer needed
+ *
+ * FIXME: cmd_test users need to be converted to the new interface
+ */
 int wl12xx_cmd_test(struct wl12xx *wl, void *buf, size_t buf_len, u8 answer)
 {
+	struct wl12xx_command *cmd;
+	size_t cmd_len;
 	int ret;
 
 	wl12xx_debug(DEBUG_CMD, "cmd test");
 
-	ret = wl12xx_cmd_send(wl, CMD_TEST, buf, buf_len);
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(cmd->parameters, buf, buf_len);
+
+	/* FIXME: ugly */
+	cmd_len = sizeof(struct wl12xx_cmd_header) + buf_len;
+
+	ret = wl12xx_cmd_send(wl, CMD_TEST, cmd, cmd_len);
 	if (ret < 0) {
 		wl12xx_warning("TEST command failed");
-		return ret;
+		goto out;
 	}
 
 	if (answer) {
-		struct wl12xx_command *cmd_answer;
-
 		/*
 		 * The test command got in, we can read the answer.
 		 * The answer would be a wl12xx_command, where the
@@ -77,109 +106,146 @@ int wl12xx_cmd_test(struct wl12xx *wl, void *buf, size_t buf_len, u8 answer)
 
 		wl12xx_ps_elp_wakeup(wl);
 
-		wl12xx_spi_mem_read(wl, wl->cmd_box_addr, buf, buf_len);
+		wl12xx_spi_mem_read(wl, wl->cmd_box_addr, cmd, cmd_len);
 
 		wl12xx_ps_elp_sleep(wl);
 
-		cmd_answer = buf;
-		if (cmd_answer->status != CMD_STATUS_SUCCESS)
+		if (cmd->header.status != CMD_STATUS_SUCCESS)
 			wl12xx_error("TEST command answer error: %d",
-				     cmd_answer->status);
+				     cmd->header.status);
+		memcpy(buf, cmd->parameters, buf_len);
 	}
 
-	return 0;
+out:
+	kfree(cmd);
+	return ret;
 }
 
-
-int wl12xx_cmd_interrogate(struct wl12xx *wl, u16 ie_id, u16 ie_len,
-			   void *answer)
+/**
+ * read acx from firmware
+ *
+ * @wl: wl struct
+ * @id: acx id
+ * @buf: buffer for the response, including all headers, must work with dma
+ * @len: lenght of buf
+ */
+int wl12xx_cmd_interrogate(struct wl12xx *wl, u16 id, void *buf, size_t len)
 {
-	struct wl12xx_command *cmd;
-	struct acx_header header;
+	struct acx_header *acx = buf;
 	int ret;
 
 	wl12xx_debug(DEBUG_CMD, "cmd interrogate");
 
-	header.id = ie_id;
-	header.len = ie_len - sizeof(header);
+	acx->id = id;
 
-	ret = wl12xx_cmd_send(wl, CMD_INTERROGATE, &header, sizeof(header));
+	/* payload length, does not include any headers */
+	acx->len = len - sizeof(*acx);
+
+	ret = wl12xx_cmd_send(wl, CMD_INTERROGATE, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl12xx_error("INTERROGATE command failed");
-		return ret;
+		goto out;
 	}
 
 	wl12xx_ps_elp_wakeup(wl);
 
 	/* the interrogate command got in, we can read the answer */
-	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, answer,
-			    CMDMBOX_HEADER_LEN + ie_len);
+	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, buf, len);
 
 	wl12xx_ps_elp_sleep(wl);
 
-	cmd = answer;
-	if (cmd->status != CMD_STATUS_SUCCESS)
+	acx = buf;
+	if (acx->cmd.status != CMD_STATUS_SUCCESS)
 		wl12xx_error("INTERROGATE command error: %d",
-			     cmd->status);
-
-	return 0;
+			     acx->cmd.status);
 
+out:
+	return ret;
 }
 
-int wl12xx_cmd_configure(struct wl12xx *wl, void *ie, int ie_len)
+/**
+ * write acx value to firmware
+ *
+ * @wl: wl struct
+ * @id: acx id
+ * @buf: buffer containing acx, including all headers, must work with dma
+ * @len: length of buf
+ */
+int wl12xx_cmd_configure(struct wl12xx *wl, u16 id, void *buf, size_t len)
 {
+	struct acx_header *acx = buf;
 	int ret;
 
 	wl12xx_debug(DEBUG_CMD, "cmd configure");
 
-	ret = wl12xx_cmd_send(wl, CMD_CONFIGURE, ie,
-			      ie_len);
+	acx->id = id;
+
+	/* payload length, does not include any headers */
+	acx->len = len - sizeof(*acx);
+
+	ret = wl12xx_cmd_send(wl, CMD_CONFIGURE, acx, len);
 	if (ret < 0) {
 		wl12xx_warning("CONFIGURE command NOK");
 		return ret;
 	}
 
 	return 0;
-
 }
 
 int wl12xx_cmd_vbm(struct wl12xx *wl, u8 identity,
 		   void *bitmap, u16 bitmap_len, u8 bitmap_control)
 {
-	struct vbm_update_request vbm;
+	struct wl12xx_cmd_vbm_update *vbm;
 	int ret;
 
 	wl12xx_debug(DEBUG_CMD, "cmd vbm");
 
+	vbm = kzalloc(sizeof(*vbm), GFP_KERNEL);
+	if (!vbm) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	/* Count and period will be filled by the target */
-	vbm.tim.bitmap_ctrl = bitmap_control;
+	vbm->tim.bitmap_ctrl = bitmap_control;
 	if (bitmap_len > PARTIAL_VBM_MAX) {
 		wl12xx_warning("cmd vbm len is %d B, truncating to %d",
 			       bitmap_len, PARTIAL_VBM_MAX);
 		bitmap_len = PARTIAL_VBM_MAX;
 	}
-	memcpy(vbm.tim.pvb_field, bitmap, bitmap_len);
-	vbm.tim.identity = identity;
-	vbm.tim.length = bitmap_len + 3;
+	memcpy(vbm->tim.pvb_field, bitmap, bitmap_len);
+	vbm->tim.identity = identity;
+	vbm->tim.length = bitmap_len + 3;
 
-	vbm.len = cpu_to_le16(bitmap_len + 5);
+	vbm->len = cpu_to_le16(bitmap_len + 5);
 
-	ret = wl12xx_cmd_send(wl, CMD_VBM, &vbm, sizeof(vbm));
+	ret = wl12xx_cmd_send(wl, CMD_VBM, vbm, sizeof(*vbm));
 	if (ret < 0) {
 		wl12xx_error("VBM command failed");
-		return ret;
+		goto out;
 	}
 
+out:
+	kfree(vbm);
 	return 0;
 }
 
-int wl12xx_cmd_data_path(struct wl12xx *wl, u8 channel, u8 enable)
+int wl12xx_cmd_data_path(struct wl12xx *wl, u8 channel, bool enable)
 {
+	struct cmd_enabledisable_path *cmd;
 	int ret;
 	u16 cmd_rx, cmd_tx;
 
 	wl12xx_debug(DEBUG_CMD, "cmd data path");
 
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->channel = channel;
+
 	if (enable) {
 		cmd_rx = CMD_ENABLE_RX;
 		cmd_tx = CMD_ENABLE_TX;
@@ -188,17 +254,17 @@ int wl12xx_cmd_data_path(struct wl12xx *wl, u8 channel, u8 enable)
 		cmd_tx = CMD_DISABLE_TX;
 	}
 
-	ret = wl12xx_cmd_send(wl, cmd_rx, &channel, sizeof(channel));
+	ret = wl12xx_cmd_send(wl, cmd_rx, cmd, sizeof(*cmd));
 	if (ret < 0) {
 		wl12xx_error("rx %s cmd for channel %d failed",
 			     enable ? "start" : "stop", channel);
-		return ret;
+		goto out;
 	}
 
 	wl12xx_debug(DEBUG_BOOT, "rx %s cmd channel %d",
 		     enable ? "start" : "stop", channel);
 
-	ret = wl12xx_cmd_send(wl, cmd_tx, &channel, sizeof(channel));
+	ret = wl12xx_cmd_send(wl, cmd_tx, cmd, sizeof(*cmd));
 	if (ret < 0) {
 		wl12xx_error("tx %s cmd for channel %d failed",
 			     enable ? "start" : "stop", channel);
@@ -208,48 +274,56 @@ int wl12xx_cmd_data_path(struct wl12xx *wl, u8 channel, u8 enable)
 	wl12xx_debug(DEBUG_BOOT, "tx %s cmd channel %d",
 		     enable ? "start" : "stop", channel);
 
-	return 0;
+out:
+	kfree(cmd);
+	return ret;
 }
 
 int wl12xx_cmd_join(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
 		    u16 beacon_interval, u8 wait)
 {
 	unsigned long timeout;
-	struct cmd_join join = {};
+	struct cmd_join *join;
 	int ret, i;
 	u8 *bssid;
 
+	join = kzalloc(sizeof(*join), GFP_KERNEL);
+	if (!join) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	/* FIXME: this should be in main.c */
 	ret = wl12xx_acx_frame_rates(wl, DEFAULT_HW_GEN_TX_RATE,
 				     DEFAULT_HW_GEN_MODULATION_TYPE,
 				     wl->tx_mgmt_frm_rate,
 				     wl->tx_mgmt_frm_mod);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	wl12xx_debug(DEBUG_CMD, "cmd join");
 
 	/* Reverse order BSSID */
-	bssid = (u8 *)&join.bssid_lsb;
+	bssid = (u8 *) &join->bssid_lsb;
 	for (i = 0; i < ETH_ALEN; i++)
 		bssid[i] = wl->bssid[ETH_ALEN - i - 1];
 
-	join.rx_config_options = wl->rx_config;
-	join.rx_filter_options = wl->rx_filter;
+	join->rx_config_options = wl->rx_config;
+	join->rx_filter_options = wl->rx_filter;
 
-	join.basic_rate_set = RATE_MASK_1MBPS | RATE_MASK_2MBPS |
+	join->basic_rate_set = RATE_MASK_1MBPS | RATE_MASK_2MBPS |
 		RATE_MASK_5_5MBPS | RATE_MASK_11MBPS;
 
-	join.beacon_interval = beacon_interval;
-	join.dtim_interval = dtim_interval;
-	join.bss_type = bss_type;
-	join.channel = wl->channel;
-	join.ctrl = JOIN_CMD_CTRL_TX_FLUSH;
+	join->beacon_interval = beacon_interval;
+	join->dtim_interval = dtim_interval;
+	join->bss_type = bss_type;
+	join->channel = wl->channel;
+	join->ctrl = JOIN_CMD_CTRL_TX_FLUSH;
 
-	ret = wl12xx_cmd_send(wl, CMD_START_JOIN, &join, sizeof(join));
+	ret = wl12xx_cmd_send(wl, CMD_START_JOIN, join, sizeof(*join));
 	if (ret < 0) {
 		wl12xx_error("failed to initiate cmd join");
-		return ret;
+		goto out;
 	}
 
 	timeout = msecs_to_jiffies(JOIN_TIMEOUT);
@@ -261,93 +335,120 @@ int wl12xx_cmd_join(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
 	if (wait)
 		msleep(10);
 
-	return 0;
+out:
+	kfree(join);
+	return ret;
 }
 
 int wl12xx_cmd_ps_mode(struct wl12xx *wl, u8 ps_mode)
 {
-	int ret;
-	struct acx_ps_params ps_params;
+	struct wl12xx_cmd_ps_params *ps_params = NULL;
+	int ret = 0;
 
 	/* FIXME: this should be in ps.c */
 	ret = wl12xx_acx_wake_up_conditions(wl, wl->listen_int);
 	if (ret < 0) {
-		wl12xx_error("Couldnt set wake up conditions");
-		return ret;
+		wl12xx_error("couldn't set wake up conditions");
+		goto out;
 	}
 
 	wl12xx_debug(DEBUG_CMD, "cmd set ps mode");
 
-	ps_params.ps_mode = ps_mode;
-	ps_params.send_null_data = 1;
-	ps_params.retries = 5;
-	ps_params.hang_over_period = 128;
-	ps_params.null_data_rate = 1; /* 1 Mbps */
+	ps_params = kzalloc(sizeof(*ps_params), GFP_KERNEL);
+	if (!ps_params) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ps_params->ps_mode = ps_mode;
+	ps_params->send_null_data = 1;
+	ps_params->retries = 5;
+	ps_params->hang_over_period = 128;
+	ps_params->null_data_rate = 1; /* 1 Mbps */
 
-	ret = wl12xx_cmd_send(wl, CMD_SET_PS_MODE, &ps_params,
-			      sizeof(ps_params));
+	ret = wl12xx_cmd_send(wl, CMD_SET_PS_MODE, ps_params,
+			      sizeof(*ps_params));
 	if (ret < 0) {
 		wl12xx_error("cmd set_ps_mode failed");
-		return ret;
+		goto out;
 	}
 
-	return 0;
+out:
+	kfree(ps_params);
+	return ret;
 }
 
-int wl12xx_cmd_read_memory(struct wl12xx *wl, u32 addr, u32 len, void *answer)
+int wl12xx_cmd_read_memory(struct wl12xx *wl, u32 addr, void *answer,
+			   size_t len)
 {
-	struct cmd_read_write_memory mem_cmd, *mem_answer;
-	struct wl12xx_command cmd;
-	int ret;
+	struct cmd_read_write_memory *cmd;
+	int ret = 0;
 
 	wl12xx_debug(DEBUG_CMD, "cmd read memory");
 
-	memset(&mem_cmd, 0, sizeof(mem_cmd));
-	mem_cmd.addr = addr;
-	mem_cmd.size = len;
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	WARN_ON(len > MAX_READ_SIZE);
+	len = min_t(size_t, len, MAX_READ_SIZE);
+
+	cmd->addr = addr;
+	cmd->size = len;
 
-	ret = wl12xx_cmd_send(wl, CMD_READ_MEMORY, &mem_cmd, sizeof(mem_cmd));
+	ret = wl12xx_cmd_send(wl, CMD_READ_MEMORY, cmd, sizeof(*cmd));
 	if (ret < 0) {
 		wl12xx_error("read memory command failed: %d", ret);
-		return ret;
+		goto out;
 	}
 
 	/* the read command got in, we can now read the answer */
-	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, &cmd,
-			    CMDMBOX_HEADER_LEN + sizeof(mem_cmd));
+	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, cmd, sizeof(*cmd));
 
-	if (cmd.status != CMD_STATUS_SUCCESS)
-		wl12xx_error("error in read command result: %d", cmd.status);
+	if (cmd->header.status != CMD_STATUS_SUCCESS)
+		wl12xx_error("error in read command result: %d",
+			     cmd->header.status);
 
-	mem_answer = (struct cmd_read_write_memory *) cmd.parameters;
-	memcpy(answer, mem_answer->value, len);
+	memcpy(answer, cmd->value, len);
 
-	return 0;
+out:
+	kfree(cmd);
+	return ret;
 }
 
 int wl12xx_cmd_template_set(struct wl12xx *wl, u16 cmd_id,
 			    void *buf, size_t buf_len)
 {
-	struct wl12xx_cmd_packet_template template;
-	int ret;
+	struct wl12xx_cmd_packet_template *cmd;
+	size_t cmd_len;
+	int ret = 0;
 
 	wl12xx_debug(DEBUG_CMD, "cmd template %d", cmd_id);
 
-	memset(&template, 0, sizeof(template));
-
 	WARN_ON(buf_len > WL12XX_MAX_TEMPLATE_SIZE);
 	buf_len = min_t(size_t, buf_len, WL12XX_MAX_TEMPLATE_SIZE);
-	template.size = cpu_to_le16(buf_len);
+	cmd_len = ALIGN(sizeof(*cmd) + buf_len, 4);
+
+	cmd = kzalloc(cmd_len, GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->size = cpu_to_le16(buf_len);
 
 	if (buf)
-		memcpy(template.template, buf, buf_len);
+		memcpy(cmd->data, buf, buf_len);
 
-	ret = wl12xx_cmd_send(wl, cmd_id, &template,
-			      sizeof(template.size) + buf_len);
+	ret = wl12xx_cmd_send(wl, cmd_id, cmd, cmd_len);
 	if (ret < 0) {
 		wl12xx_warning("cmd set_template failed: %d", ret);
-		return ret;
+		goto out;
 	}
 
-	return 0;
+out:
+	kfree(cmd);
+	return ret;
 }
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index aa307dc..7aef1f2 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -27,31 +27,26 @@
 
 #include "wl12xx.h"
 
+struct acx_header;
+
 int wl12xx_cmd_send(struct wl12xx *wl, u16 type, void *buf, size_t buf_len);
 int wl12xx_cmd_test(struct wl12xx *wl, void *buf, size_t buf_len, u8 answer);
-int wl12xx_cmd_interrogate(struct wl12xx *wl, u16 ie_id, u16 ie_len,
-			   void *answer);
-int wl12xx_cmd_configure(struct wl12xx *wl, void *ie, int ie_len);
+int wl12xx_cmd_interrogate(struct wl12xx *wl, u16 id, void *buf, size_t len);
+int wl12xx_cmd_configure(struct wl12xx *wl, u16 id, void *buf, size_t len);
 int wl12xx_cmd_vbm(struct wl12xx *wl, u8 identity,
 		   void *bitmap, u16 bitmap_len, u8 bitmap_control);
-int wl12xx_cmd_data_path(struct wl12xx *wl, u8 channel, u8 enable);
+int wl12xx_cmd_data_path(struct wl12xx *wl, u8 channel, bool enable);
 int wl12xx_cmd_join(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
 		    u16 beacon_interval, u8 wait);
 int wl12xx_cmd_ps_mode(struct wl12xx *wl, u8 ps_mode);
-int wl12xx_cmd_read_memory(struct wl12xx *wl, u32 addr, u32 len, void *answer);
+int wl12xx_cmd_read_memory(struct wl12xx *wl, u32 addr, void *answer,
+			   size_t len);
 int wl12xx_cmd_template_set(struct wl12xx *wl, u16 cmd_id,
 			    void *buf, size_t buf_len);
 
 /* unit ms */
 #define WL12XX_COMMAND_TIMEOUT 2000
 
-#define WL12XX_MAX_TEMPLATE_SIZE 300
-
-struct wl12xx_cmd_packet_template {
-	__le16 size;
-	u8 template[WL12XX_MAX_TEMPLATE_SIZE];
-} __attribute__ ((packed));
-
 enum wl12xx_commands {
 	CMD_RESET           = 0,
 	CMD_INTERROGATE     = 1,    /*use this to read information elements*/
@@ -100,9 +95,15 @@ enum wl12xx_commands {
 
 #define MAX_CMD_PARAMS 572
 
-struct  wl12xx_command {
+struct wl12xx_cmd_header {
 	u16 id;
 	u16 status;
+	/* payload */
+	u8 data[0];
+} __attribute__ ((packed));
+
+struct  wl12xx_command {
+	struct wl12xx_cmd_header header;
 	u8  parameters[MAX_CMD_PARAMS];
 };
 
@@ -144,6 +145,8 @@ enum {
 #define MAX_READ_SIZE 256
 
 struct cmd_read_write_memory {
+	struct wl12xx_cmd_header header;
+
 	/* The address of the memory to read from or write to.*/
 	u32 addr;
 
@@ -211,6 +214,8 @@ struct basic_scan_channel_parameters {
 #define SCAN_MAX_NUM_OF_CHANNELS 16
 
 struct cmd_scan {
+	struct wl12xx_cmd_header header;
+
 	struct basic_scan_parameters params;
 	struct basic_scan_channel_parameters channels[SCAN_MAX_NUM_OF_CHANNELS];
 } __attribute__ ((packed));
@@ -227,6 +232,8 @@ enum {
 
 
 struct cmd_join {
+	struct wl12xx_cmd_header header;
+
 	u32 bssid_lsb;
 	u16 bssid_msb;
 	u16 beacon_interval; /* in TBTTs */
@@ -261,5 +268,140 @@ struct cmd_join {
 	u8 reserved;
 } __attribute__ ((packed));
 
+struct cmd_enabledisable_path {
+	struct wl12xx_cmd_header header;
+
+	u8 channel;
+	u8 padding[3];
+} __attribute__ ((packed));
+
+#define WL12XX_MAX_TEMPLATE_SIZE 300
+
+struct wl12xx_cmd_packet_template {
+	struct wl12xx_cmd_header header;
+
+	__le16 size;
+	u8 data[0];
+} __attribute__ ((packed));
+
+#define TIM_ELE_ID    5
+#define PARTIAL_VBM_MAX    251
+
+struct wl12xx_tim {
+	u8 identity;
+	u8 length;
+	u8 dtim_count;
+	u8 dtim_period;
+	u8 bitmap_ctrl;
+	u8 pvb_field[PARTIAL_VBM_MAX]; /* Partial Virtual Bitmap */
+} __attribute__ ((packed));
+
+/* Virtual Bit Map update */
+struct wl12xx_cmd_vbm_update {
+	struct wl12xx_cmd_header header;
+	__le16 len;
+	u8  padding[2];
+	struct wl12xx_tim tim;
+} __attribute__ ((packed));
+
+enum wl12xx_cmd_ps_mode {
+	STATION_ACTIVE_MODE,
+	STATION_POWER_SAVE_MODE
+};
+
+struct wl12xx_cmd_ps_params {
+	struct wl12xx_cmd_header header;
+
+	u8 ps_mode; /* STATION_* */
+	u8 send_null_data; /* Do we have to send NULL data packet ? */
+	u8 retries; /* Number of retires for the initial NULL data packet */
+
+	 /*
+	  * TUs during which the target stays awake after switching
+	  * to power save mode.
+	  */
+	u8 hang_over_period;
+	u16 null_data_rate;
+	u8 pad[2];
+} __attribute__ ((packed));
+
+struct wl12xx_cmd_trigger_scan_to {
+	struct wl12xx_cmd_header header;
+
+	u32 timeout;
+};
+
+/* HW encryption keys */
+#define NUM_ACCESS_CATEGORIES_COPY 4
+#define MAX_KEY_SIZE 32
+
+/* When set, disable HW encryption */
+#define DF_ENCRYPTION_DISABLE      0x01
+/* When set, disable HW decryption */
+#define DF_SNIFF_MODE_ENABLE       0x80
+
+enum wl12xx_cmd_key_action {
+	KEY_ADD_OR_REPLACE = 1,
+	KEY_REMOVE         = 2,
+	KEY_SET_ID         = 3,
+	MAX_KEY_ACTION     = 0xffff,
+};
+
+enum wl12xx_cmd_key_type {
+	KEY_WEP_DEFAULT       = 0,
+	KEY_WEP_ADDR          = 1,
+	KEY_AES_GROUP         = 4,
+	KEY_AES_PAIRWISE      = 5,
+	KEY_WEP_GROUP         = 6,
+	KEY_TKIP_MIC_GROUP    = 10,
+	KEY_TKIP_MIC_PAIRWISE = 11,
+};
+
+/*
+ *
+ * key_type_e   key size    key format
+ * ----------   ---------   ----------
+ * 0x00         5, 13, 29   Key data
+ * 0x01         5, 13, 29   Key data
+ * 0x04         16          16 bytes of key data
+ * 0x05         16          16 bytes of key data
+ * 0x0a         32          16 bytes of TKIP key data
+ *                          8 bytes of RX MIC key data
+ *                          8 bytes of TX MIC key data
+ * 0x0b         32          16 bytes of TKIP key data
+ *                          8 bytes of RX MIC key data
+ *                          8 bytes of TX MIC key data
+ *
+ */
+
+struct wl12xx_cmd_set_keys {
+	struct wl12xx_cmd_header header;
+
+	/* Ignored for default WEP key */
+	u8 addr[ETH_ALEN];
+
+	/* key_action_e */
+	u16 key_action;
+
+	u16 reserved_1;
+
+	/* key size in bytes */
+	u8 key_size;
+
+	/* key_type_e */
+	u8 key_type;
+	u8 ssid_profile;
+
+	/*
+	 * TKIP, AES: frame's key id field.
+	 * For WEP default key: key id;
+	 */
+	u8 id;
+	u8 reserved_2[6];
+	u8 key[MAX_KEY_SIZE];
+	u16 ac_seq_num16[NUM_ACCESS_CATEGORIES_COPY];
+	u32 ac_seq_num32[NUM_ACCESS_CATEGORIES_COPY];
+} __attribute__ ((packed));
+
 
 #endif /* __WL12XX_CMD_H__ */
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 603d611..c6a4544 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -618,7 +618,8 @@ static void wl12xx_op_configure_filter(struct ieee80211_hw *hw,
 }
 
 /* HW encryption */
-static int wl12xx_set_key_type(struct wl12xx *wl, struct acx_set_key *key,
+static int wl12xx_set_key_type(struct wl12xx *wl,
+			       struct wl12xx_cmd_set_keys *key,
 			       enum set_key_cmd cmd,
 			       struct ieee80211_key_conf *mac80211_key,
 			       const u8 *addr)
@@ -661,7 +662,7 @@ static int wl12xx_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			     struct ieee80211_key_conf *key)
 {
 	struct wl12xx *wl = hw->priv;
-	struct acx_set_key wl_key;
+	struct wl12xx_cmd_set_keys *wl_cmd;
 	const u8 *addr;
 	int ret;
 
@@ -670,7 +671,11 @@ static int wl12xx_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	wl12xx_debug(DEBUG_MAC80211, "mac80211 set key");
 
-	memset(&wl_key, 0, sizeof(wl_key));
+	wl_cmd = kzalloc(sizeof(*wl_cmd), GFP_KERNEL);
+	if (!wl_cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	addr = sta ? sta->addr : bcast_addr;
 
@@ -680,59 +685,69 @@ static int wl12xx_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		     key->alg, key->keyidx, key->keylen, key->flags);
 	wl12xx_dump(DEBUG_CRYPT, "KEY: ", key->key, key->keylen);
 
+	if (is_zero_ether_addr(addr)) {
+		/* We dont support TX only encryption */
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
 	mutex_lock(&wl->mutex);
 
 	switch (cmd) {
 	case SET_KEY:
-		wl_key.key_action = KEY_ADD_OR_REPLACE;
+		wl_cmd->key_action = KEY_ADD_OR_REPLACE;
 		break;
 	case DISABLE_KEY:
-		wl_key.key_action = KEY_REMOVE;
+		wl_cmd->key_action = KEY_REMOVE;
 		break;
 	default:
 		wl12xx_error("Unsupported key cmd 0x%x", cmd);
 		break;
 	}
 
-	ret = wl12xx_set_key_type(wl, &wl_key, cmd, key, addr);
+	ret = wl12xx_set_key_type(wl, wl_cmd, cmd, key, addr);
 	if (ret < 0) {
 		wl12xx_error("Set KEY type failed");
-		goto out;
+		goto out_unlock;
 	}
 
-	if (wl_key.key_type != KEY_WEP_DEFAULT)
-		memcpy(wl_key.addr, addr, ETH_ALEN);
+	if (wl_cmd->key_type != KEY_WEP_DEFAULT)
+		memcpy(wl_cmd->addr, addr, ETH_ALEN);
 
-	if ((wl_key.key_type == KEY_TKIP_MIC_GROUP) ||
-	    (wl_key.key_type == KEY_TKIP_MIC_PAIRWISE)) {
+	if ((wl_cmd->key_type == KEY_TKIP_MIC_GROUP) ||
+	    (wl_cmd->key_type == KEY_TKIP_MIC_PAIRWISE)) {
 		/*
 		 * We get the key in the following form:
 		 * TKIP (16 bytes) - TX MIC (8 bytes) - RX MIC (8 bytes)
 		 * but the target is expecting:
 		 * TKIP - RX MIC - TX MIC
 		 */
-		memcpy(wl_key.key, key->key, 16);
-		memcpy(wl_key.key + 16, key->key + 24, 8);
-		memcpy(wl_key.key + 24, key->key + 16, 8);
+		memcpy(wl_cmd->key, key->key, 16);
+		memcpy(wl_cmd->key + 16, key->key + 24, 8);
+		memcpy(wl_cmd->key + 24, key->key + 16, 8);
 
 	} else {
-		memcpy(wl_key.key, key->key, key->keylen);
+		memcpy(wl_cmd->key, key->key, key->keylen);
 	}
-	wl_key.key_size = key->keylen;
+	wl_cmd->key_size = key->keylen;
 
-	wl_key.id = key->keyidx;
-	wl_key.ssid_profile = 0;
+	wl_cmd->id = key->keyidx;
+	wl_cmd->ssid_profile = 0;
 
-	wl12xx_dump(DEBUG_CRYPT, "TARGET KEY: ", &wl_key, sizeof(wl_key));
+	wl12xx_dump(DEBUG_CRYPT, "TARGET KEY: ", wl_cmd, sizeof(*wl_cmd));
 
-	if (wl12xx_cmd_send(wl, CMD_SET_KEYS, &wl_key, sizeof(wl_key)) < 0) {
-		wl12xx_error("Set KEY failed");
-		ret = -EOPNOTSUPP;
-		goto out;
+	ret = wl12xx_cmd_send(wl, CMD_SET_KEYS, wl_cmd, sizeof(*wl_cmd));
+	if (ret < 0) {
+		wl12xx_warning("could not set keys");
+		goto out_unlock;
 	}
 
-out:
+out_unlock:
 	mutex_unlock(&wl->mutex);
+
+out:
+	kfree(wl_cmd);
+
 	return ret;
 }
 
@@ -812,11 +827,10 @@ static int wl12xx_hw_scan(struct wl12xx *wl, u8 *ssid, size_t len,
 			  u8 active_scan, u8 high_prio, u8 num_channels,
 			  u8 probe_requests)
 {
+	struct wl12xx_cmd_trigger_scan_to *trigger = NULL;
+	struct cmd_scan *params = NULL;
 	int i, ret;
-	u32 split_scan = 0;
 	u16 scan_options = 0;
-	struct cmd_scan *params;
-	struct wl12xx_command *cmd_answer;
 
 	if (wl->scanning)
 		return -EINVAL;
@@ -870,10 +884,16 @@ static int wl12xx_hw_scan(struct wl12xx *wl, u8 *ssid, size_t len,
 		goto out;
 	}
 
-	ret = wl12xx_cmd_send(wl, CMD_TRIGGER_SCAN_TO, &split_scan,
-			      sizeof(u32));
+	trigger = kzalloc(sizeof(*trigger), GFP_KERNEL);
+	if (!trigger)
+		goto out;
+
+	trigger->timeout = 0;
+
+	ret = wl12xx_cmd_send(wl, CMD_TRIGGER_SCAN_TO, trigger,
+			      sizeof(*trigger));
 	if (ret < 0) {
-		wl12xx_error("Split SCAN failed");
+		wl12xx_error("trigger scan to failed for hw scan");
 		goto out;
 	}
 
@@ -887,10 +907,9 @@ static int wl12xx_hw_scan(struct wl12xx *wl, u8 *ssid, size_t len,
 
 	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, params, sizeof(*params));
 
-	cmd_answer = (struct wl12xx_command *) params;
-	if (cmd_answer->status != CMD_STATUS_SUCCESS) {
+	if (params->header.status != CMD_STATUS_SUCCESS) {
 		wl12xx_error("TEST command answer error: %d",
-			     cmd_answer->status);
+			     params->header.status);
 		wl->scanning = false;
 		ret = -EIO;
 		goto out;
@@ -942,7 +961,7 @@ static void wl12xx_op_bss_info_changed(struct ieee80211_hw *hw,
 				       struct ieee80211_bss_conf *bss_conf,
 				       u32 changed)
 {
-	enum acx_ps_mode mode;
+	enum wl12xx_cmd_ps_mode mode;
 	struct wl12xx *wl = hw->priv;
 	struct sk_buff *beacon;
 	int ret;
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index 83a1011..fe5e2d1 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -114,7 +114,7 @@ static int wl12xx_ps_set_elp(struct wl12xx *wl, bool enable)
 	return 0;
 }
 
-int wl12xx_ps_set_mode(struct wl12xx *wl, enum acx_ps_mode mode)
+int wl12xx_ps_set_mode(struct wl12xx *wl, enum wl12xx_cmd_ps_mode mode)
 {
 	int ret;
 
diff --git a/drivers/net/wireless/wl12xx/ps.h b/drivers/net/wireless/wl12xx/ps.h
index 5d7c525..ad61b4a 100644
--- a/drivers/net/wireless/wl12xx/ps.h
+++ b/drivers/net/wireless/wl12xx/ps.h
@@ -28,7 +28,7 @@
 #include "wl12xx.h"
 #include "acx.h"
 
-int wl12xx_ps_set_mode(struct wl12xx *wl, enum acx_ps_mode mode);
+int wl12xx_ps_set_mode(struct wl12xx *wl, enum wl12xx_cmd_ps_mode mode);
 void wl12xx_ps_elp_sleep(struct wl12xx *wl);
 int wl12xx_ps_elp_wakeup(struct wl12xx *wl);
 
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 981ea25..5fd916a 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -48,6 +48,9 @@ static void wl12xx_rx_status(struct wl12xx *wl,
 			     struct ieee80211_rx_status *status,
 			     u8 beacon)
 {
+	u64 mactime;
+	int ret;
+
 	memset(status, 0, sizeof(struct ieee80211_rx_status));
 
 	status->band = IEEE80211_BAND_2GHZ;
@@ -62,27 +65,9 @@ static void wl12xx_rx_status(struct wl12xx *wl,
 	 * this one must be atomic, while our SPI routines can sleep.
 	 */
 	if ((wl->bss_type == BSS_TYPE_IBSS) && beacon) {
-		u64 mactime;
-		int ret;
-		struct wl12xx_command cmd;
-		struct acx_tsf_info *tsf_info;
-
-		memset(&cmd, 0, sizeof(cmd));
-
-		ret = wl12xx_cmd_interrogate(wl, ACX_TSF_INFO,
-					     sizeof(struct acx_tsf_info),
-					     &cmd);
-		if (ret < 0) {
-			wl12xx_warning("ACX_FW_REV interrogate failed");
-			return;
-		}
-
-		tsf_info = (struct acx_tsf_info *)&(cmd.parameters);
-
-		mactime = tsf_info->current_tsf_lsb |
-			(tsf_info->current_tsf_msb << 31);
-
-		status->mactime = mactime;
+		ret = wl12xx_acx_tsf_info(wl, &mactime);
+		if (ret == 0)
+			status->mactime = mactime;
 	}
 
 	status->signal = desc->rssi;
diff --git a/drivers/net/wireless/wl12xx/wl1251.c b/drivers/net/wireless/wl12xx/wl1251.c
index ce1561a..1a352cf 100644
--- a/drivers/net/wireless/wl12xx/wl1251.c
+++ b/drivers/net/wireless/wl12xx/wl1251.c
@@ -297,45 +297,48 @@ out:
 
 static int wl1251_mem_cfg(struct wl12xx *wl)
 {
-	struct wl1251_acx_config_memory mem_conf;
+	struct wl1251_acx_config_memory *mem_conf;
 	int ret, i;
 
 	wl12xx_debug(DEBUG_ACX, "wl1251 mem cfg");
 
+	mem_conf = kzalloc(sizeof(*mem_conf), GFP_KERNEL);
+	if (!mem_conf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	/* memory config */
-	mem_conf.mem_config.num_stations = cpu_to_le16(DEFAULT_NUM_STATIONS);
-	mem_conf.mem_config.rx_mem_block_num = 35;
-	mem_conf.mem_config.tx_min_mem_block_num = 64;
-	mem_conf.mem_config.num_tx_queues = MAX_TX_QUEUES;
-	mem_conf.mem_config.host_if_options = HOSTIF_PKT_RING;
-	mem_conf.mem_config.num_ssid_profiles = 1;
-	mem_conf.mem_config.debug_buffer_size =
+	mem_conf->mem_config.num_stations = cpu_to_le16(DEFAULT_NUM_STATIONS);
+	mem_conf->mem_config.rx_mem_block_num = 35;
+	mem_conf->mem_config.tx_min_mem_block_num = 64;
+	mem_conf->mem_config.num_tx_queues = MAX_TX_QUEUES;
+	mem_conf->mem_config.host_if_options = HOSTIF_PKT_RING;
+	mem_conf->mem_config.num_ssid_profiles = 1;
+	mem_conf->mem_config.debug_buffer_size =
 		cpu_to_le16(TRACE_BUFFER_MAX_SIZE);
 
 	/* RX queue config */
-	mem_conf.rx_queue_config.dma_address = 0;
-	mem_conf.rx_queue_config.num_descs = ACX_RX_DESC_DEF;
-	mem_conf.rx_queue_config.priority = DEFAULT_RXQ_PRIORITY;
-	mem_conf.rx_queue_config.type = DEFAULT_RXQ_TYPE;
+	mem_conf->rx_queue_config.dma_address = 0;
+	mem_conf->rx_queue_config.num_descs = ACX_RX_DESC_DEF;
+	mem_conf->rx_queue_config.priority = DEFAULT_RXQ_PRIORITY;
+	mem_conf->rx_queue_config.type = DEFAULT_RXQ_TYPE;
 
 	/* TX queue config */
 	for (i = 0; i < MAX_TX_QUEUES; i++) {
-		mem_conf.tx_queue_config[i].num_descs = ACX_TX_DESC_DEF;
-		mem_conf.tx_queue_config[i].attributes = i;
+		mem_conf->tx_queue_config[i].num_descs = ACX_TX_DESC_DEF;
+		mem_conf->tx_queue_config[i].attributes = i;
 	}
 
-	mem_conf.header.id = ACX_MEM_CFG;
-	mem_conf.header.len = sizeof(struct wl1251_acx_config_memory) -
-		sizeof(struct acx_header);
-	mem_conf.header.len -=
-		(MAX_TX_QUEUE_CONFIGS - mem_conf.mem_config.num_tx_queues) *
-		sizeof(struct wl1251_acx_tx_queue_config);
-
-	ret = wl12xx_cmd_configure(wl, &mem_conf,
-				   sizeof(struct wl1251_acx_config_memory));
-	if (ret < 0)
+	ret = wl12xx_cmd_configure(wl, ACX_MEM_CFG, mem_conf,
+				   sizeof(*mem_conf));
+	if (ret < 0) {
 		wl12xx_warning("wl1251 mem config failed: %d", ret);
+		goto out;
+	}
 
+out:
+	kfree(mem_conf);
 	return ret;
 }
 
@@ -529,28 +532,33 @@ static int wl1251_hw_init_txq_fill(u8 qid,
 
 static int wl1251_hw_init_tx_queue_config(struct wl12xx *wl)
 {
-	struct acx_tx_queue_qos_config config;
+	struct acx_tx_queue_qos_config *config;
 	struct wl1251_acx_mem_map *wl_mem_map = wl->target_mem_map;
 	int ret, i;
 
 	wl12xx_debug(DEBUG_ACX, "acx tx queue config");
 
-	config.header.id = ACX_TX_QUEUE_CFG;
-	config.header.len = sizeof(struct acx_tx_queue_qos_config) -
-		sizeof(struct acx_header);
+	config = kzalloc(sizeof(*config), GFP_KERNEL);
+	if (!config) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	for (i = 0; i < MAX_NUM_OF_AC; i++) {
-		ret = wl1251_hw_init_txq_fill(i, &config,
+		ret = wl1251_hw_init_txq_fill(i, config,
 					      wl_mem_map->num_tx_mem_blocks);
 		if (ret < 0)
-			return ret;
+			goto out;
 
-		ret = wl12xx_cmd_configure(wl, &config, sizeof(config));
+		ret = wl12xx_cmd_configure(wl, ACX_TX_QUEUE_CFG,
+					   config, sizeof(*config));
 		if (ret < 0)
-			return ret;
+			goto out;
 	}
 
-	return 0;
+out:
+	kfree(config);
+	return ret;
 }
 
 static int wl1251_hw_init_data_path_config(struct wl12xx *wl)

