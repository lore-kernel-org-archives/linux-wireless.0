Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redpinesignals.com ([203.196.161.92]:24751 "EHLO
	mail.redpinesignals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbaCCIXq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 03:23:46 -0500
Received: from [192.168.40.2] ([192.168.40.2])
	(authenticated user fariya.f@redpinesignals.com)
	by mail.redpinesignals.com
	for linux-wireless@vger.kernel.org;
	Mon, 3 Mar 2014 13:53:43 +0530
Message-ID: <53143BB9.7070606@redpinesignals.com> (sfid-20140303_092349_694043_B90804A0)
Date: Mon, 03 Mar 2014 13:52:17 +0530
From: Fariya Fatima <fariya.f@redpinesignals.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3.14.0-rc5 v3 7/10] rsi: Management functions internal to
 device
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fariya Fatima

This patch has the remaining functions which prepare management

frames internal to the device.

Signed-off-by: Fariya Fatima <fariya.f@redpinesignals.com>
---

 rsi_91x_mgmt.c |  738 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 738 insertions(+)

diff -rupN linux-3.14-rc5/drivers/net/wireless/rsi/rsi_91x_mgmt.c linux-3.14-rc5_new/drivers/net/wireless/rsi/rsi_91x_mgmt.c
--- linux-3.14-rc5/drivers/net/wireless/rsi/rsi_91x_mgmt.c	2014-03-04 07:37:17.533276887 +0545
+++ linux-3.14-rc5_new/drivers/net/wireless/rsi/rsi_91x_mgmt.c	2014-03-04 07:37:20.075245108 +0545
@@ -558,4 +558,742 @@ int rsi_send_aggregation_params_frame(st
 	return rsi_send_internal_mgmt_frame(common, skb);
 }
 
+/**
+ * This function starts base band and RF programming.
+ * This is called after initial configurations are done.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return 0 on success, corresponding negative error code on failure.
+ */
+static int rsi_program_bb_rf(struct rsi_common *common)
+{
+	struct sk_buff *skb;
+	struct rsi_mac_frame *mgmt_frame;
 
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending program BB/RF frame\n", __func__);
+
+	skb = dev_alloc_skb(FRAME_DESC_SZ);
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, FRAME_DESC_SZ);
+	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+
+	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
+	mgmt_frame->desc_word[1] = cpu_to_le16(BBP_PROG_IN_TA);
+	mgmt_frame->desc_word[4] = cpu_to_le16(common->endpoint << 8);
+
+	if (common->rf_reset) {
+		mgmt_frame->desc_word[7] =  cpu_to_le16(RF_RESET_ENABLE);
+		rsi_dbg(MGMT_TX_ZONE, "%s: ===> RF RESET REQUEST SENT <===\n",
+			__func__);
+		common->rf_reset = 0;
+	}
+	common->bb_rf_prog_count = 1;
+	mgmt_frame->desc_word[7] |= cpu_to_le16(PUT_BBP_RESET |
+				     BBP_REG_WRITE | (RSI_RF_TYPE << 4));
+	skb_put(skb, FRAME_DESC_SZ);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/**
+ * This function sends vap capabilities to firmware.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  opmode Operating mode of device.
+ * @return 0 on success, corresponding negative error code on failure.
+ */
+int rsi_set_vap_capabilities(struct rsi_common *common, enum opmode mode)
+{
+	struct sk_buff *skb = NULL;
+	struct rsi_vap_caps *vap_caps;
+	u16 vap_id = 0;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending VAP capabilities frame\n", __func__);
+
+	skb = dev_alloc_skb(sizeof(struct rsi_vap_caps));
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, sizeof(struct rsi_vap_caps));
+	vap_caps = (struct rsi_vap_caps *)skb->data;
+
+	vap_caps->desc_word[0] = cpu_to_le16((sizeof(struct rsi_vap_caps) -
+					     FRAME_DESC_SZ) |
+					     (RSI_WIFI_MGMT_Q << 12));
+	vap_caps->desc_word[1] = cpu_to_le16(VAP_CAPABILITIES);
+	vap_caps->desc_word[4] = cpu_to_le16(mode |
+					     (common->channel_width << 8));
+	vap_caps->desc_word[7] = cpu_to_le16((vap_id << 8) |
+					     (common->mac_id << 4) |
+					     common->radio_id);
+
+	memcpy(vap_caps->mac_addr, common->mac_addr, IEEE80211_ADDR_LEN);
+	vap_caps->keep_alive_period = cpu_to_le16(90);
+	vap_caps->frag_threshold = cpu_to_le16(IEEE80211_MAX_FRAG_THRESHOLD);
+
+	vap_caps->rts_threshold = cpu_to_le16(common->rts_threshold);
+	vap_caps->default_mgmt_rate = 0;
+	if (conf_is_ht40(&common->priv->hw->conf)) {
+		vap_caps->default_ctrl_rate =
+				cpu_to_le32(RSI_RATE_6 | FULL40M_ENABLE << 16);
+	} else {
+		vap_caps->default_ctrl_rate = cpu_to_le32(RSI_RATE_6);
+	}
+	vap_caps->default_data_rate = 0;
+	vap_caps->beacon_interval = cpu_to_le16(200);
+	vap_caps->dtim_period = cpu_to_le16(4);
+
+	skb_put(skb, sizeof(*vap_caps));
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/**
+ * This function is used to load the keys within the firmware.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  data Pointer to the key data.
+ * @param  key_len Key length to be loaded.
+ * @param  key_type Type of key: GROUP/PAIRWISE.
+ * @param  key_id Key index.
+ * @param  cipher Type of cipher used.
+ * @return 0 on success, -1 on failure.
+ */
+int rsi_hal_load_key(struct rsi_common *common,
+		     u8 *data,
+		     u16 key_len,
+		     u8 key_type,
+		     u8 key_id,
+		     u32 cipher)
+{
+	struct sk_buff *skb = NULL;
+	struct rsi_set_key *set_key;
+	u16 key_descriptor = 0;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending load key frame\n", __func__);
+
+	skb = dev_alloc_skb(sizeof(struct rsi_set_key));
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, sizeof(struct rsi_set_key));
+	set_key = (struct rsi_set_key *)skb->data;
+
+	if ((cipher == WLAN_CIPHER_SUITE_WEP40) ||
+	    (cipher == WLAN_CIPHER_SUITE_WEP104)) {
+		key_len += 1;
+		key_descriptor |= BIT(2);
+		if (key_len >= 13)
+			key_descriptor |= BIT(3);
+	} else if (cipher != KEY_TYPE_CLEAR) {
+		key_descriptor |= BIT(4);
+		if (key_type == RSI_PAIRWISE_KEY)
+			key_id = 0;
+		if (cipher == WLAN_CIPHER_SUITE_TKIP)
+			key_descriptor |= BIT(5);
+	}
+	key_descriptor |= (key_type | BIT(13) | (key_id << 14));
+
+	set_key->desc_word[0] = cpu_to_le16((sizeof(struct rsi_set_key) -
+					    FRAME_DESC_SZ) |
+					    (RSI_WIFI_MGMT_Q << 12));
+	set_key->desc_word[1] = cpu_to_le16(SET_KEY_REQ);
+	set_key->desc_word[4] = cpu_to_le16(key_descriptor);
+
+	if ((cipher == WLAN_CIPHER_SUITE_WEP40) ||
+	    (cipher == WLAN_CIPHER_SUITE_WEP104)) {
+		memcpy(&set_key->key[key_id][1],
+		       data,
+		       key_len * 2);
+	} else {
+		memcpy(&set_key->key[0][0], data, key_len);
+	}
+
+	memcpy(set_key->tx_mic_key, &data[16], 8);
+	memcpy(set_key->rx_mic_key, &data[24], 8);
+
+	skb_put(skb, sizeof(struct rsi_set_key));
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/*
+ * This function sends bootup parameters to the firmware.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return 0 on success, corresponding error code on failure.
+ */
+static u8 rsi_load_bootup_params(struct rsi_common *common)
+{
+	struct sk_buff *skb;
+	struct rsi_boot_params *boot_params;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending boot params frame\n", __func__);
+	skb = dev_alloc_skb(sizeof(struct rsi_boot_params));
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, sizeof(struct rsi_boot_params));
+	boot_params = (struct rsi_boot_params *)skb->data;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s:\n", __func__);
+
+	if (common->channel_width == BW_40MHZ) {
+		memcpy(&boot_params->bootup_params,
+		       &boot_params_40,
+		       sizeof(struct bootup_params));
+		rsi_dbg(MGMT_TX_ZONE, "%s: Packet 40MHZ <=== %d\n", __func__,
+			UMAC_CLK_40BW);
+		boot_params->desc_word[7] = cpu_to_le16(UMAC_CLK_40BW);
+	} else {
+		memcpy(&boot_params->bootup_params,
+		       &boot_params_20,
+		       sizeof(struct bootup_params));
+		if (boot_params_20.valid != cpu_to_le32(VALID_20)) {
+			boot_params->desc_word[7] = cpu_to_le16(UMAC_CLK_20BW);
+			rsi_dbg(MGMT_TX_ZONE,
+				"%s: Packet 20MHZ <=== %d\n", __func__,
+				UMAC_CLK_20BW);
+		} else {
+			boot_params->desc_word[7] = cpu_to_le16(UMAC_CLK_40MHZ);
+			rsi_dbg(MGMT_TX_ZONE,
+				"%s: Packet 20MHZ <=== %d\n", __func__,
+				UMAC_CLK_40MHZ);
+		}
+	}
+
+	/**
+	 * Bit{0:11} indicates length of the Packet
+	 * Bit{12:15} indicates host queue number
+	 */
+	boot_params->desc_word[0] = cpu_to_le16(sizeof(struct bootup_params) |
+				    (RSI_WIFI_MGMT_Q << 12));
+	boot_params->desc_word[1] = cpu_to_le16(BOOTUP_PARAMS_REQUEST);
+
+	skb_put(skb, sizeof(struct rsi_boot_params));
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/**
+ * This function prepares reset MAC request and sends an internal
+ * management frame to indicate it to firmware.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return 0 on success, corresponding error code on failure.
+ */
+static int rsi_send_reset_mac(struct rsi_common *common)
+{
+	struct sk_buff *skb;
+	struct rsi_mac_frame *mgmt_frame;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending reset MAC frame\n", __func__);
+
+	skb = dev_alloc_skb(FRAME_DESC_SZ);
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, FRAME_DESC_SZ);
+	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+
+	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
+	mgmt_frame->desc_word[1] = cpu_to_le16(RESET_MAC_REQ);
+	mgmt_frame->desc_word[4] = cpu_to_le16(RETRY_COUNT << 8);
+
+	skb_put(skb, FRAME_DESC_SZ);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/**
+ * This function programs the channel.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  channel Channel value to be set.
+ * @return 0 on success, corresponding error code on failure.
+ */
+int rsi_set_channel(struct rsi_common *common, u16 channel)
+{
+	struct sk_buff *skb = NULL;
+	struct rsi_mac_frame *mgmt_frame;
+
+	rsi_dbg(MGMT_TX_ZONE,
+		"%s: Sending scan req frame\n", __func__);
+
+	skb = dev_alloc_skb(FRAME_DESC_SZ);
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, FRAME_DESC_SZ);
+	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+
+	if (common->band == IEEE80211_BAND_5GHZ) {
+		if ((channel >= 36) && (channel <= 64))
+			channel = ((channel - 32) / 4);
+		else if ((channel > 64) && (channel <= 140))
+			channel = ((channel - 102) / 4) + 8;
+		else if (channel >= 149)
+			channel = ((channel - 151) / 4) + 18;
+		else
+			return -1;
+	} else {
+		if (channel > 14) {
+			rsi_dbg(ERR_ZONE, "%s: Invalid chno %d, band = %d\n",
+				__func__, channel, common->band);
+			return 0;
+		}
+	}
+
+	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
+	mgmt_frame->desc_word[1] = cpu_to_le16(SCAN_REQUEST);
+	mgmt_frame->desc_word[4] = cpu_to_le16(channel);
+
+	mgmt_frame->desc_word[7] = cpu_to_le16(PUT_BBP_RESET |
+					       BBP_REG_WRITE |
+					       (RSI_RF_TYPE << 4));
+
+	mgmt_frame->desc_word[5] = cpu_to_le16(0x01);
+
+	if (common->channel_width == BW_40MHZ)
+		mgmt_frame->desc_word[5] |= cpu_to_le16(0x1 << 8);
+
+	common->channel = channel;
+
+	skb_put(skb, FRAME_DESC_SZ);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/**
+ * This function is used to compare two integers
+ *
+ * @param  pointer to the first integer
+ * @param  pointer to the second integer
+ * @return 0 if both are equal, -1 if the first is smaller, else 1
+ */
+static int rsi_compare(const void *a, const void *b)
+{
+	u16 _a = *(const u16 *)(a);
+	u16 _b = *(const u16 *)(b);
+
+	if (_a > _b)
+		return -1;
+
+	if (_a < _b)
+		return 1;
+
+	return 0;
+}
+
+/**
+ * This function is used to map the selected rates to hw rates
+ *
+ * @param  the standard rate to be mapped
+ * @param  offset that will be returned
+ * @return 0 if it is a mcs rate, else 1
+ */
+static bool rsi_map_rates(u16 rate, int *offset)
+{
+	int kk;
+	for (kk = 0; kk < ARRAY_SIZE(rsi_mcsrates); kk++) {
+		if (rate == mcs[kk]) {
+			*offset = kk;
+			return 0;
+		}
+	}
+
+	for (kk = 0; kk < ARRAY_SIZE(rsi_rates); kk++) {
+		if (rate == rsi_rates[kk].bitrate / 5) {
+			*offset = kk;
+			break;
+		}
+	}
+	return 1;
+}
+
+/**
+ * This function is to set rates for connection and send autorate
+ * request to firmware.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return 0 on success, corresponding error code on failure.
+ */
+static int rsi_send_auto_rate_request(struct rsi_common *common)
+{
+	struct sk_buff *skb;
+	struct rsi_auto_rate *auto_rate;
+	int ii = 0, jj = 0, kk = 0;
+	struct ieee80211_hw *hw = common->priv->hw;
+	u8 band = hw->conf.chandef.chan->band;
+	u8 num_supported_rates = 0;
+	u8 rate_offset = 0;
+	u32 rate_bitmap = common->bitrate_mask[band];
+
+	u16 *selected_rates, min_rate;
+
+	skb = dev_alloc_skb(sizeof(struct rsi_auto_rate));
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	selected_rates = kmalloc(2 * RSI_TBL_SZ, GFP_KERNEL);
+	if (!selected_rates) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of mem\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, sizeof(struct rsi_auto_rate));
+	memset(selected_rates, 0, 2 * RSI_TBL_SZ);
+
+	auto_rate = (struct rsi_auto_rate *)skb->data;
+
+	auto_rate->aarf_rssi = cpu_to_le16(((u16)3 << 6) | (u16)(18 & 0x3f));
+	auto_rate->collision_tolerance = cpu_to_le16(3);
+	auto_rate->failure_limit = cpu_to_le16(3);
+	auto_rate->initial_boundary = cpu_to_le16(3);
+	auto_rate->max_threshold_limt = cpu_to_le16(27);
+
+	auto_rate->desc_word[1] = cpu_to_le16(AUTO_RATE_IND);
+
+	if (common->channel_width == BW_40MHZ)
+		auto_rate->desc_word[7] |= cpu_to_le16(1);
+
+	if (band == IEEE80211_BAND_2GHZ)
+		min_rate = STD_RATE_01;
+	else
+		min_rate = STD_RATE_06;
+
+	for (ii = 0, jj = 0; ii < ARRAY_SIZE(rsi_rates); ii++) {
+		if (rate_bitmap & BIT(ii)) {
+			selected_rates[jj++] = (rsi_rates[ii].bitrate / 5);
+			rate_offset++;
+		}
+	}
+	num_supported_rates = jj;
+
+	if (common->vif_info[0].is_ht) {
+		for (ii = 0; ii < ARRAY_SIZE(mcs); ii++)
+			selected_rates[jj++] = mcs[ii];
+		num_supported_rates += ARRAY_SIZE(mcs);
+		rate_offset += ARRAY_SIZE(mcs);
+	}
+
+	if (rate_offset < (RSI_TBL_SZ / 2) - 1) {
+		for (ii = jj; ii < (RSI_TBL_SZ / 2); ii++) {
+			selected_rates[jj++] = min_rate;
+			rate_offset++;
+		}
+	}
+
+	sort(selected_rates, jj, sizeof(u16), &rsi_compare, NULL);
+
+	/* mapping the rates to RSI rates */
+	for (ii = 0; ii < jj; ii++) {
+		if (rsi_map_rates(selected_rates[ii], &kk)) {
+			auto_rate->supported_rates[ii] =
+				cpu_to_le16(rsi_rates[kk].hw_value);
+		} else {
+			auto_rate->supported_rates[ii] =
+				cpu_to_le16(rsi_mcsrates[kk]);
+		}
+	}
+
+	/* loading HT rates in the bottom half of the auto rate table */
+	if (common->vif_info[0].is_ht) {
+		if (common->vif_info[0].sgi)
+			auto_rate->supported_rates[rate_offset++] =
+				cpu_to_le16(RSI_RATE_MCS7_SG);
+
+		for (ii = rate_offset, kk = ARRAY_SIZE(rsi_mcsrates) - 1;
+		     ii < rate_offset + 2 * ARRAY_SIZE(rsi_mcsrates); ii++) {
+			if (common->vif_info[0].sgi)
+				auto_rate->supported_rates[ii++] =
+					cpu_to_le16(rsi_mcsrates[kk] | BIT(9));
+			auto_rate->supported_rates[ii] =
+				cpu_to_le16(rsi_mcsrates[kk--]);
+		}
+
+		for (; ii < RSI_TBL_SZ; ii++) {
+			auto_rate->supported_rates[ii] =
+				cpu_to_le16(rsi_mcsrates[0]);
+		}
+	}
+
+	auto_rate->num_supported_rates = cpu_to_le16(num_supported_rates * 2);
+	auto_rate->moderate_rate_inx = cpu_to_le16(num_supported_rates / 2);
+	auto_rate->desc_word[7] |= cpu_to_le16(0 << 8);
+	num_supported_rates *= 2;
+
+	auto_rate->desc_word[0] = cpu_to_le16((sizeof(*auto_rate) -
+					       FRAME_DESC_SZ) |
+					       (RSI_WIFI_MGMT_Q << 12));
+
+	skb_put(skb,
+		sizeof(struct rsi_auto_rate));
+	kfree(selected_rates);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/**
+ * This function informs about bss status with the help of sta notify
+ * params by sending an internal management frame to firmware.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  status Bss status type.
+ * @param  bssid Bssid.
+ * @param  qos_enable Qos is enabled.
+ * @param  aid Aid (unique for all STAs).
+ * @return None.
+ */
+void rsi_inform_bss_status(struct rsi_common *common,
+			   u8 status,
+			   const unsigned char *bssid,
+			   u8 qos_enable,
+			   u16 aid)
+{
+	if (status) {
+		rsi_hal_send_sta_notify_frame(common,
+					      NL80211_IFTYPE_STATION,
+					      STA_CONNECTED,
+					      bssid,
+					      qos_enable,
+					      aid);
+		if (common->min_rate == 0xffff)
+			rsi_send_auto_rate_request(common);
+	} else {
+		rsi_hal_send_sta_notify_frame(common,
+					      NL80211_IFTYPE_STATION,
+					      STA_DISCONNECTED,
+					      bssid,
+					      qos_enable,
+					      aid);
+	}
+	return;
+}
+
+/**
+ * This function sends a frame to read the
+ * mac address from the eeprom.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return 0 on success, -1 on failure.
+ */
+static int rsi_eeprom_read(struct rsi_common *common)
+{
+	struct rsi_mac_frame *mgmt_frame;
+	struct sk_buff *skb;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending EEPROM read req frame\n", __func__);
+
+	skb = dev_alloc_skb(FRAME_DESC_SZ);
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, FRAME_DESC_SZ);
+	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+
+	/* FrameType */
+	mgmt_frame->desc_word[1] = cpu_to_le16(EEPROM_READ_TYPE);
+	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
+	/* Number of bytes to read */
+	mgmt_frame->desc_word[3] = cpu_to_le16(ETH_ALEN +
+					       WLAN_MAC_MAGIC_WORD_LEN +
+					       WLAN_HOST_MODE_LEN +
+					       WLAN_FW_VERSION_LEN);
+	/* Address to read */
+	mgmt_frame->desc_word[4] = cpu_to_le16(WLAN_MAC_EEPROM_ADDR);
+
+	skb_put(skb, FRAME_DESC_SZ);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/**
+ * This function handles the confirm frames.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  msg Pointer to received packet.
+ * @return 0 on success, -1 on failure.
+ */
+static int rsi_handle_ta_confirm_type(struct rsi_common *common,
+				      u8 *msg)
+{
+	u8 sub_type = (msg[15] & 0xff);
+
+	switch (sub_type) {
+	case BOOTUP_PARAMS_REQUEST:
+		rsi_dbg(FSM_ZONE, "%s: Boot up params confirm received\n",
+			__func__);
+		if (common->fsm_state == FSM_BOOT_PARAMS_SENT) {
+			if (rsi_eeprom_read(common)) {
+				common->fsm_state = FSM_CARD_NOT_READY;
+				goto out;
+			} else {
+				common->fsm_state = FSM_EEPROM_READ_MAC_ADDR;
+			}
+		} else {
+			rsi_dbg(ERR_ZONE,
+				"%s: Received bootup params cfm in %d state\n",
+				 __func__, common->fsm_state);
+			return 0;
+		}
+		break;
+
+	case EEPROM_READ_TYPE:
+		if (common->fsm_state == FSM_EEPROM_READ_MAC_ADDR) {
+			if (msg[16] == MAGIC_WORD) {
+				u8 offset = (FRAME_DESC_SZ + WLAN_HOST_MODE_LEN
+					     + WLAN_MAC_MAGIC_WORD_LEN);
+				memcpy(common->mac_addr,
+				       &msg[offset],
+				       ETH_ALEN);
+				memcpy(&common->fw_ver,
+				       &msg[offset + ETH_ALEN],
+				       sizeof(struct version_info));
+
+			} else {
+				common->fsm_state = FSM_CARD_NOT_READY;
+				break;
+			}
+			if (rsi_send_reset_mac(common))
+				goto out;
+			else
+				common->fsm_state = FSM_RESET_MAC_SENT;
+		} else {
+			rsi_dbg(ERR_ZONE,
+				"%s: Received eeprom mac addr in %d state\n",
+				__func__, common->fsm_state);
+			return 0;
+		}
+		break;
+
+	case RESET_MAC_REQ:
+		if (common->fsm_state == FSM_RESET_MAC_SENT) {
+			rsi_dbg(FSM_ZONE, "%s: Reset MAC cfm received\n",
+				__func__);
+
+			if (rsi_load_radio_caps(common))
+				goto out;
+			else
+				common->fsm_state = FSM_RADIO_CAPS_SENT;
+		} else {
+			rsi_dbg(ERR_ZONE,
+				"%s: Received reset mac cfm in %d state\n",
+				 __func__, common->fsm_state);
+			return 0;
+		}
+		break;
+
+	case RADIO_CAPABILITIES:
+		if (common->fsm_state == FSM_RADIO_CAPS_SENT) {
+			common->rf_reset = 1;
+			if (rsi_program_bb_rf(common)) {
+				goto out;
+			} else {
+				common->fsm_state = FSM_BB_RF_PROG_SENT;
+				rsi_dbg(FSM_ZONE, "%s: Radio cap cfm received\n",
+					__func__);
+			}
+		} else {
+			rsi_dbg(ERR_ZONE,
+				"%s: Received radio caps cfm in %d state\n",
+				 __func__, common->fsm_state);
+			return 0;
+		}
+		break;
+
+	case BB_PROG_VALUES_REQUEST:
+	case RF_PROG_VALUES_REQUEST:
+	case BBP_PROG_IN_TA:
+		rsi_dbg(FSM_ZONE, "%s: BB/RF cfm received\n", __func__);
+		if (common->fsm_state == FSM_BB_RF_PROG_SENT) {
+			common->bb_rf_prog_count--;
+			if (!common->bb_rf_prog_count) {
+				common->fsm_state = FSM_MAC_INIT_DONE;
+				return rsi_mac80211_attach(common);
+			}
+		} else {
+			goto out;
+		}
+		break;
+
+	default:
+		rsi_dbg(INFO_ZONE, "%s: Invalid TA confirm pkt received\n",
+			__func__);
+		break;
+	}
+	return 0;
+out:
+	rsi_dbg(ERR_ZONE, "%s: Unable to send pkt/Invalid frame received\n",
+		__func__);
+	return -1;
+}
+
+/**
+ * This function processes the management packets recieved
+ * from the hardware.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  msg Pointer to the received packet.
+ * @return 0 on success, -1 on failure.
+ */
+int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg)
+{
+	s32 msg_len = (le16_to_cpu(*(__le16 *)&msg[0]) & 0x0fff);
+	u16 msg_type = (msg[2]);
+
+	rsi_dbg(FSM_ZONE, "%s: Msg Len: %d, Msg Type: %4x\n",
+		__func__, msg_len, msg_type);
+
+	if (msg_type == TA_CONFIRM_TYPE) {
+		return rsi_handle_ta_confirm_type(common, msg);
+	} else if (msg_type == CARD_READY_IND) {
+		rsi_dbg(FSM_ZONE, "%s: Card ready indication received\n",
+			__func__);
+		if (common->fsm_state == FSM_CARD_NOT_READY) {
+			rsi_set_default_parameters(common);
+
+			if (rsi_load_bootup_params(common))
+				return -1;
+			else
+				common->fsm_state = FSM_BOOT_PARAMS_SENT;
+		} else {
+			return -1;
+		}
+	} else if (msg_type == TX_STATUS_IND) {
+		if (msg[15] == PROBEREQ_CONFIRM)
+			common->mgmt_q_block = false;
+			rsi_dbg(FSM_ZONE, "%s: Probe confirm received\n",
+				__func__);
+	} else {
+		return rsi_mgmt_pkt_to_core(common, msg, msg_len, msg_type);
+	}
+	return 0;
+}


