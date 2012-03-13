Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:48572 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759369Ab2CMCgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 22:36:06 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 09/15] mwifiex: fix checkpatch --strict warnings/errors  Part 3
Date: Mon, 12 Mar 2012 19:35:16 -0700
Message-Id: <1331606116-32745-10-git-send-email-bzhao@marvell.com> (sfid-20120313_033610_884112_8EEACF8B)
In-Reply-To: <1331606116-32745-1-git-send-email-bzhao@marvell.com>
References: <1331606116-32745-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

For files fw.h, init.c and join.c

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h   |    4 +-
 drivers/net/wireless/mwifiex/init.c |   32 ++++----
 drivers/net/wireless/mwifiex/join.c |  147 +++++++++++++++++------------------
 3 files changed, 89 insertions(+), 94 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index fc4ffee..e98fc5a 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -117,8 +117,8 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define BA_STREAM_NOT_ALLOWED   0xff
 
 #define IS_11N_ENABLED(priv) ((priv->adapter->config_bands & BAND_GN || \
-			priv->adapter->config_bands & BAND_AN) \
-			&& priv->curr_bss_params.bss_descriptor.bcn_ht_cap)
+			priv->adapter->config_bands & BAND_AN) && \
+			priv->curr_bss_params.bss_descriptor.bcn_ht_cap)
 #define INITIATOR_BIT(DelBAParamSet) (((DelBAParamSet) &\
 			BIT(DELBA_INITIATOR_POS)) >> DELBA_INITIATOR_POS)
 
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index e81bf6e..945461f 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -35,28 +35,24 @@ static int mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_bss_prio_node *bss_prio;
+	struct mwifiex_bss_prio_tbl *tbl = adapter->bss_prio_tbl;
 	unsigned long flags;
 
 	bss_prio = kzalloc(sizeof(struct mwifiex_bss_prio_node), GFP_KERNEL);
 	if (!bss_prio) {
 		dev_err(adapter->dev, "%s: failed to alloc bss_prio\n",
-						__func__);
+			__func__);
 		return -ENOMEM;
 	}
 
 	bss_prio->priv = priv;
 	INIT_LIST_HEAD(&bss_prio->list);
-	if (!adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur)
-		adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
-			bss_prio;
-
-	spin_lock_irqsave(&adapter->bss_prio_tbl[priv->bss_priority]
-			.bss_prio_lock, flags);
-	list_add_tail(&bss_prio->list,
-			&adapter->bss_prio_tbl[priv->bss_priority]
-			.bss_prio_head);
-	spin_unlock_irqrestore(&adapter->bss_prio_tbl[priv->bss_priority]
-			.bss_prio_lock, flags);
+	if (!tbl[priv->bss_priority].bss_prio_cur)
+		tbl[priv->bss_priority].bss_prio_cur = bss_prio;
+
+	spin_lock_irqsave(&tbl[priv->bss_priority].bss_prio_lock, flags);
+	list_add_tail(&bss_prio->list, &tbl[priv->bss_priority].bss_prio_head);
+	spin_unlock_irqrestore(&tbl[priv->bss_priority].bss_prio_lock, flags);
 
 	return 0;
 }
@@ -157,13 +153,13 @@ static int mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
 	ret = mwifiex_alloc_cmd_buffer(adapter);
 	if (ret) {
 		dev_err(adapter->dev, "%s: failed to alloc cmd buffer\n",
-		       __func__);
+			__func__);
 		return -1;
 	}
 
 	adapter->sleep_cfm =
 		dev_alloc_skb(sizeof(struct mwifiex_opt_sleep_confirm)
-				+ INTF_HEADER_LEN);
+			      + INTF_HEADER_LEN);
 
 	if (!adapter->sleep_cfm) {
 		dev_err(adapter->dev, "%s: failed to alloc sleep cfm"
@@ -520,7 +516,7 @@ static void mwifiex_delete_bss_prio_tbl(struct mwifiex_private *priv)
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_bss_prio_node *bssprio_node, *tmp_node, **cur;
 	struct list_head *head;
-	spinlock_t *lock;
+	spinlock_t *lock; /* bss priority lock */
 	unsigned long flags;
 
 	for (i = 0; i < adapter->priv_num; ++i) {
@@ -638,7 +634,7 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 	ret = adapter->if_ops.check_fw_status(adapter, poll_num);
 	if (!ret) {
 		dev_notice(adapter->dev,
-				"WLAN FW already running! Skip FW download\n");
+			   "WLAN FW already running! Skip FW download\n");
 		goto done;
 	}
 	poll_num = MAX_FIRMWARE_POLL_TRIES;
@@ -646,8 +642,8 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 	/* Check if we are the winner for downloading FW */
 	if (!adapter->winner) {
 		dev_notice(adapter->dev,
-				"Other interface already running!"
-				" Skip FW download\n");
+			   "Other interface already running!"
+			   " Skip FW download\n");
 		poll_num = MAX_MULTI_INTERFACE_POLL_TRIES;
 		goto poll_fw;
 	}
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 803275f..b841131 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -53,7 +53,7 @@ mwifiex_cmd_append_generic_ie(struct mwifiex_private *priv, u8 **buffer)
 	 */
 	if (priv->gen_ie_buf_len) {
 		dev_dbg(priv->adapter->dev, "info: %s: append generic %d to %p\n",
-				__func__, priv->gen_ie_buf_len, *buffer);
+			__func__, priv->gen_ie_buf_len, *buffer);
 
 		/* Wrap the generic IE buffer with a pass through TLV type */
 		ie_header.type = cpu_to_le16(TLV_TYPE_PASSTHROUGH);
@@ -124,7 +124,7 @@ mwifiex_cmd_append_tsf_tlv(struct mwifiex_private *priv, u8 **buffer,
 	memcpy(&tsf_val, bss_desc->time_stamp, sizeof(tsf_val));
 
 	dev_dbg(priv->adapter->dev, "info: %s: TSF offset calc: %016llx - "
-			"%016llx\n", __func__, tsf_val, bss_desc->network_tsf);
+		"%016llx\n", __func__, tsf_val, bss_desc->network_tsf);
 
 	memcpy(*buffer, &tsf_val, sizeof(tsf_val));
 	*buffer += sizeof(tsf_val);
@@ -167,7 +167,7 @@ static int mwifiex_get_common_rates(struct mwifiex_private *priv, u8 *rate1,
 	}
 
 	dev_dbg(priv->adapter->dev, "info: Tx data rate set to %#x\n",
-						priv->data_rate);
+		priv->data_rate);
 
 	if (!priv->is_data_rate_auto) {
 		while (*ptr) {
@@ -212,7 +212,7 @@ mwifiex_setup_rates_from_bssdesc(struct mwifiex_private *priv,
 				     card_rates, card_rates_size)) {
 		*out_rates_size = 0;
 		dev_err(priv->adapter->dev, "%s: cannot get common rates\n",
-						__func__);
+			__func__);
 		return -1;
 	}
 
@@ -248,7 +248,7 @@ mwifiex_cmd_append_wapi_ie(struct mwifiex_private *priv, u8 **buffer)
 	 */
 	if (priv->wapi_ie_len) {
 		dev_dbg(priv->adapter->dev, "cmd: append wapi ie %d to %p\n",
-				priv->wapi_ie_len, *buffer);
+			priv->wapi_ie_len, *buffer);
 
 		/* Wrap the generic IE buffer with a pass through TLV type */
 		ie_header.type = cpu_to_le16(TLV_TYPE_WAPI_IE);
@@ -293,10 +293,10 @@ static int mwifiex_append_rsn_ie_wpa_wpa2(struct mwifiex_private *priv,
 				 le16_to_cpu(rsn_ie_tlv->header.type) & 0x00FF);
 	rsn_ie_tlv->header.len = cpu_to_le16((u16) priv->wpa_ie[1]);
 	rsn_ie_tlv->header.len = cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.len)
-							& 0x00FF);
+							 & 0x00FF);
 	if (le16_to_cpu(rsn_ie_tlv->header.len) <= (sizeof(priv->wpa_ie) - 2))
 		memcpy(rsn_ie_tlv->rsn_ie, &priv->wpa_ie[2],
-					le16_to_cpu(rsn_ie_tlv->header.len));
+		       le16_to_cpu(rsn_ie_tlv->header.len));
 	else
 		return -1;
 
@@ -379,7 +379,7 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	ssid_tlv->header.type = cpu_to_le16(WLAN_EID_SSID);
 	ssid_tlv->header.len = cpu_to_le16((u16) bss_desc->ssid.ssid_len);
 	memcpy(ssid_tlv->ssid, bss_desc->ssid.ssid,
-		le16_to_cpu(ssid_tlv->header.len));
+	       le16_to_cpu(ssid_tlv->header.len));
 	pos += sizeof(ssid_tlv->header) + le16_to_cpu(ssid_tlv->header.len);
 
 	phy_tlv = (struct mwifiex_ie_types_phy_param_set *) pos;
@@ -411,7 +411,7 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	memcpy(rates_tlv->rates, rates, rates_size);
 	pos += sizeof(rates_tlv->header) + rates_size;
 	dev_dbg(priv->adapter->dev, "info: ASSOC_CMD: rates size = %d\n",
-					rates_size);
+		rates_size);
 
 	/* Add the Authentication type to be used for Auth frames */
 	auth_tlv = (struct mwifiex_ie_types_auth_type *) pos;
@@ -425,12 +425,12 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 
 	pos += sizeof(auth_tlv->header) + le16_to_cpu(auth_tlv->header.len);
 
-	if (IS_SUPPORT_MULTI_BANDS(priv->adapter)
-	    && !(ISSUPP_11NENABLED(priv->adapter->fw_cap_info)
-		&& (!bss_desc->disable_11n)
-		 && (priv->adapter->config_bands & BAND_GN
-		     || priv->adapter->config_bands & BAND_AN)
-		 && (bss_desc->bcn_ht_cap)
+	if (IS_SUPPORT_MULTI_BANDS(priv->adapter) &&
+	    !(ISSUPP_11NENABLED(priv->adapter->fw_cap_info) &&
+	    (!bss_desc->disable_11n) &&
+	    (priv->adapter->config_bands & BAND_GN ||
+	     priv->adapter->config_bands & BAND_AN) &&
+	    (bss_desc->bcn_ht_cap)
 	    )
 		) {
 		/* Append a channel TLV for the channel the attempted AP was
@@ -445,13 +445,13 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 		chan_tlv->chan_scan_param[0].chan_number =
 			(bss_desc->phy_param_set.ds_param_set.current_chan);
 		dev_dbg(priv->adapter->dev, "info: Assoc: TLV Chan = %d\n",
-		       chan_tlv->chan_scan_param[0].chan_number);
+			chan_tlv->chan_scan_param[0].chan_number);
 
 		chan_tlv->chan_scan_param[0].radio_type =
 			mwifiex_band_to_radio_type((u8) bss_desc->bss_band);
 
 		dev_dbg(priv->adapter->dev, "info: Assoc: TLV Band = %d\n",
-		       chan_tlv->chan_scan_param[0].radio_type);
+			chan_tlv->chan_scan_param[0].radio_type);
 		pos += sizeof(chan_tlv->header) +
 			sizeof(struct mwifiex_chan_scan_param_set);
 	}
@@ -464,10 +464,10 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 			return -1;
 	}
 
-	if (ISSUPP_11NENABLED(priv->adapter->fw_cap_info)
-		&& (!bss_desc->disable_11n)
-	    && (priv->adapter->config_bands & BAND_GN
-		|| priv->adapter->config_bands & BAND_AN))
+	if (ISSUPP_11NENABLED(priv->adapter->fw_cap_info) &&
+	    (!bss_desc->disable_11n) &&
+	    (priv->adapter->config_bands & BAND_GN ||
+	     priv->adapter->config_bands & BAND_AN))
 		mwifiex_cmd_append_11n_tlv(priv, bss_desc, &pos);
 
 	/* Append vendor specific IE TLV */
@@ -493,7 +493,7 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 
 	tmp_cap &= CAPINFO_MASK;
 	dev_dbg(priv->adapter->dev, "info: ASSOC_CMD: tmp_cap=%4X CAPINFO_MASK=%4lX\n",
-	       tmp_cap, CAPINFO_MASK);
+		tmp_cap, CAPINFO_MASK);
 	assoc->cap_info_bitmap = cpu_to_le16(tmp_cap);
 
 	return 0;
@@ -573,17 +573,17 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 	assoc_rsp = (struct ieee_types_assoc_rsp *) &resp->params;
 
 	priv->assoc_rsp_size = min(le16_to_cpu(resp->size) - S_DS_GEN,
-				     sizeof(priv->assoc_rsp_buf));
+				   sizeof(priv->assoc_rsp_buf));
 
 	memcpy(priv->assoc_rsp_buf, &resp->params, priv->assoc_rsp_size);
 
 	if (le16_to_cpu(assoc_rsp->status_code)) {
 		priv->adapter->dbg.num_cmd_assoc_failure++;
 		dev_err(priv->adapter->dev, "ASSOC_RESP: association failed, "
-		       "status code = %d, error = 0x%x, a_id = 0x%x\n",
-		       le16_to_cpu(assoc_rsp->status_code),
-		       le16_to_cpu(assoc_rsp->cap_info_bitmap),
-		       le16_to_cpu(assoc_rsp->a_id));
+			"status code = %d, error = 0x%x, a_id = 0x%x\n",
+			le16_to_cpu(assoc_rsp->status_code),
+			le16_to_cpu(assoc_rsp->cap_info_bitmap),
+			le16_to_cpu(assoc_rsp->a_id));
 
 		ret = le16_to_cpu(assoc_rsp->status_code);
 		goto done;
@@ -600,7 +600,7 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 	bss_desc = priv->attempted_bss_desc;
 
 	dev_dbg(priv->adapter->dev, "info: ASSOC_RESP: %s\n",
-						bss_desc->ssid.ssid);
+		bss_desc->ssid.ssid);
 
 	/* Make a copy of current BSSID descriptor */
 	memcpy(&priv->curr_bss_params.bss_descriptor,
@@ -617,8 +617,8 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 	else
 		priv->curr_bss_params.wmm_enabled = false;
 
-	if ((priv->wmm_required || bss_desc->bcn_ht_cap)
-			&& priv->curr_bss_params.wmm_enabled)
+	if ((priv->wmm_required || bss_desc->bcn_ht_cap) &&
+	    priv->curr_bss_params.wmm_enabled)
 		priv->wmm_enabled = true;
 	else
 		priv->wmm_enabled = false;
@@ -631,7 +631,7 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 				IEEE80211_WMM_IE_AP_QOSINFO_UAPSD) ? 1 : 0);
 
 	dev_dbg(priv->adapter->dev, "info: ASSOC_RESP: curr_pkt_filter is %#x\n",
-	       priv->curr_pkt_filter);
+		priv->curr_pkt_filter);
 	if (priv->sec_info.wpa_enabled || priv->sec_info.wpa2_enabled)
 		priv->wpa_is_gtk_set = false;
 
@@ -755,7 +755,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	memcpy(adhoc_start->ssid, req_ssid->ssid, req_ssid->ssid_len);
 
 	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: SSID = %s\n",
-				adhoc_start->ssid);
+		adhoc_start->ssid);
 
 	memset(bss_desc->ssid.ssid, 0, IEEE80211_MAX_SSID_LEN);
 	memcpy(bss_desc->ssid.ssid, req_ssid->ssid, req_ssid->ssid_len);
@@ -792,7 +792,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	}
 
 	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: creating ADHOC on channel %d\n",
-				priv->adhoc_channel);
+		priv->adhoc_channel);
 
 	priv->curr_bss_params.bss_descriptor.channel = priv->adhoc_channel;
 	priv->curr_bss_params.band = adapter->adhoc_start_band;
@@ -813,7 +813,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	adhoc_start->ss_param_set.ibss_param_set.element_id = IBSS_PARA_IE_ID;
 	adhoc_start->ss_param_set.ibss_param_set.len = IBSS_PARA_IE_LEN;
 	adhoc_start->ss_param_set.ibss_param_set.atim_window
-		= cpu_to_le16(priv->atim_window);
+					= cpu_to_le16(priv->atim_window);
 	memcpy(&bss_desc->ss_param_set, &adhoc_start->ss_param_set,
 	       sizeof(union ieee_types_ss_param_set));
 
@@ -841,10 +841,10 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	if ((adapter->adhoc_start_band & BAND_G) &&
 	    (priv->curr_pkt_filter & HostCmd_ACT_MAC_ADHOC_G_PROTECTION_ON)) {
 		if (mwifiex_send_cmd_async(priv, HostCmd_CMD_MAC_CONTROL,
-					     HostCmd_ACT_GEN_SET, 0,
-					     &priv->curr_pkt_filter)) {
+					   HostCmd_ACT_GEN_SET, 0,
+					   &priv->curr_pkt_filter)) {
 			dev_err(adapter->dev,
-			       "ADHOC_S_CMD: G Protection config failed\n");
+				"ADHOC_S_CMD: G Protection config failed\n");
 			return -1;
 		}
 	}
@@ -860,8 +860,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	       &adhoc_start->data_rate, priv->curr_bss_params.num_of_rates);
 
 	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: rates=%02x %02x %02x %02x\n",
-	       adhoc_start->data_rate[0], adhoc_start->data_rate[1],
-	       adhoc_start->data_rate[2], adhoc_start->data_rate[3]);
+		adhoc_start->data_rate[0], adhoc_start->data_rate[1],
+		adhoc_start->data_rate[2], adhoc_start->data_rate[3]);
 
 	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: AD-HOC Start command is ready\n");
 
@@ -878,12 +878,12 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 			(u8) priv->curr_bss_params.bss_descriptor.channel;
 
 		dev_dbg(adapter->dev, "info: ADHOC_S_CMD: TLV Chan = %d\n",
-		       chan_tlv->chan_scan_param[0].chan_number);
+			chan_tlv->chan_scan_param[0].chan_number);
 
 		chan_tlv->chan_scan_param[0].radio_type
 		       = mwifiex_band_to_radio_type(priv->curr_bss_params.band);
-		if (adapter->adhoc_start_band & BAND_GN
-		    || adapter->adhoc_start_band & BAND_AN) {
+		if (adapter->adhoc_start_band & BAND_GN ||
+		    adapter->adhoc_start_band & BAND_AN) {
 			if (adapter->sec_chan_offset ==
 					    IEEE80211_HT_PARAM_CHA_SEC_ABOVE)
 				chan_tlv->chan_scan_param[0].radio_type |=
@@ -894,7 +894,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 					(IEEE80211_HT_PARAM_CHA_SEC_BELOW << 4);
 		}
 		dev_dbg(adapter->dev, "info: ADHOC_S_CMD: TLV Band = %d\n",
-		       chan_tlv->chan_scan_param[0].radio_type);
+			chan_tlv->chan_scan_param[0].radio_type);
 		pos += sizeof(chan_tlv->header) +
 			sizeof(struct mwifiex_chan_scan_param_set);
 		cmd_append_size +=
@@ -925,15 +925,14 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 		mwifiex_fill_cap_info(priv, radio_type, ht_cap);
 
 		pos += sizeof(struct mwifiex_ie_types_htcap);
-		cmd_append_size +=
-			sizeof(struct mwifiex_ie_types_htcap);
+		cmd_append_size += sizeof(struct mwifiex_ie_types_htcap);
 
 		/* Fill HT INFORMATION */
 		ht_info = (struct mwifiex_ie_types_htinfo *) pos;
 		memset(ht_info, 0, sizeof(struct mwifiex_ie_types_htinfo));
 		ht_info->header.type = cpu_to_le16(WLAN_EID_HT_INFORMATION);
 		ht_info->header.len =
-			cpu_to_le16(sizeof(struct ieee80211_ht_info));
+				cpu_to_le16(sizeof(struct ieee80211_ht_info));
 
 		ht_info->ht_info.control_chan =
 			(u8) priv->curr_bss_params.bss_descriptor.channel;
@@ -947,12 +946,12 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 		ht_info->ht_info.basic_set[0] = 0xff;
 		pos += sizeof(struct mwifiex_ie_types_htinfo);
 		cmd_append_size +=
-			sizeof(struct mwifiex_ie_types_htinfo);
+				sizeof(struct mwifiex_ie_types_htinfo);
 	}
 
-	cmd->size = cpu_to_le16((u16)
-			    (sizeof(struct host_cmd_ds_802_11_ad_hoc_start)
-			     + S_DS_GEN + cmd_append_size));
+	cmd->size =
+		cpu_to_le16((u16)(sizeof(struct host_cmd_ds_802_11_ad_hoc_start)
+				  + S_DS_GEN + cmd_append_size));
 
 	if (adapter->adhoc_start_band == BAND_B)
 		tmp_cap &= ~WLAN_CAPABILITY_SHORT_SLOT_TIME;
@@ -1005,10 +1004,10 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 			curr_pkt_filter | HostCmd_ACT_MAC_ADHOC_G_PROTECTION_ON;
 
 		if (mwifiex_send_cmd_async(priv, HostCmd_CMD_MAC_CONTROL,
-					     HostCmd_ACT_GEN_SET, 0,
-					     &curr_pkt_filter)) {
+					   HostCmd_ACT_GEN_SET, 0,
+					   &curr_pkt_filter)) {
 			dev_err(priv->adapter->dev,
-			       "ADHOC_J_CMD: G Protection config failed\n");
+				"ADHOC_J_CMD: G Protection config failed\n");
 			return -1;
 		}
 	}
@@ -1040,12 +1039,12 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 	tmp_cap &= CAPINFO_MASK;
 
 	dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: tmp_cap=%4X"
-			" CAPINFO_MASK=%4lX\n", tmp_cap, CAPINFO_MASK);
+		" CAPINFO_MASK=%4lX\n", tmp_cap, CAPINFO_MASK);
 
 	/* Information on BSSID descriptor passed to FW */
 	dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: BSSID = %pM, SSID = %s\n",
-				adhoc_join->bss_descriptor.bssid,
-				adhoc_join->bss_descriptor.ssid);
+		adhoc_join->bss_descriptor.bssid,
+		adhoc_join->bss_descriptor.ssid);
 
 	for (i = 0; bss_desc->supported_rates[i] &&
 			i < MWIFIEX_SUPPORTED_RATES;
@@ -1083,17 +1082,17 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 		chan_tlv->chan_scan_param[0].chan_number =
 			(bss_desc->phy_param_set.ds_param_set.current_chan);
 		dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: TLV Chan = %d\n",
-		       chan_tlv->chan_scan_param[0].chan_number);
+			chan_tlv->chan_scan_param[0].chan_number);
 
 		chan_tlv->chan_scan_param[0].radio_type =
 			mwifiex_band_to_radio_type((u8) bss_desc->bss_band);
 
 		dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: TLV Band = %d\n",
-		       chan_tlv->chan_scan_param[0].radio_type);
+			chan_tlv->chan_scan_param[0].radio_type);
 		pos += sizeof(chan_tlv->header) +
-			sizeof(struct mwifiex_chan_scan_param_set);
+				sizeof(struct mwifiex_chan_scan_param_set);
 		cmd_append_size += sizeof(chan_tlv->header) +
-			sizeof(struct mwifiex_chan_scan_param_set);
+				sizeof(struct mwifiex_chan_scan_param_set);
 	}
 
 	if (priv->sec_info.wpa_enabled)
@@ -1110,9 +1109,9 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 	cmd_append_size += mwifiex_cmd_append_vsie_tlv(priv,
 			MWIFIEX_VSIE_MASK_ADHOC, &pos);
 
-	cmd->size = cpu_to_le16((u16)
-			    (sizeof(struct host_cmd_ds_802_11_ad_hoc_join)
-			     + S_DS_GEN + cmd_append_size));
+	cmd->size = cpu_to_le16
+		((u16) (sizeof(struct host_cmd_ds_802_11_ad_hoc_join)
+			+ S_DS_GEN + cmd_append_size));
 
 	adhoc_join->bss_descriptor.cap_info_bitmap = cpu_to_le16(tmp_cap);
 
@@ -1157,7 +1156,7 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 
 	if (le16_to_cpu(resp->command) == HostCmd_CMD_802_11_AD_HOC_START) {
 		dev_dbg(priv->adapter->dev, "info: ADHOC_S_RESP %s\n",
-				bss_desc->ssid.ssid);
+			bss_desc->ssid.ssid);
 
 		/* Update the created network descriptor with the new BSSID */
 		memcpy(bss_desc->mac_address,
@@ -1170,7 +1169,7 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 		 * If BSSID has changed use SSID to compare instead of BSSID
 		 */
 		dev_dbg(priv->adapter->dev, "info: ADHOC_J_RESP %s\n",
-				bss_desc->ssid.ssid);
+			bss_desc->ssid.ssid);
 
 		/*
 		 * Make a copy of current BSSID descriptor, only needed for
@@ -1184,9 +1183,9 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 	}
 
 	dev_dbg(priv->adapter->dev, "info: ADHOC_RESP: channel = %d\n",
-				priv->adhoc_channel);
+		priv->adhoc_channel);
 	dev_dbg(priv->adapter->dev, "info: ADHOC_RESP: BSSID = %pM\n",
-	       priv->curr_bss_params.bss_descriptor.mac_address);
+		priv->curr_bss_params.bss_descriptor.mac_address);
 
 	if (!netif_carrier_ok(priv->netdev))
 		netif_carrier_on(priv->netdev);
@@ -1249,9 +1248,9 @@ mwifiex_adhoc_start(struct mwifiex_private *priv,
 	dev_dbg(priv->adapter->dev, "info: Adhoc Channel = %d\n",
 		priv->adhoc_channel);
 	dev_dbg(priv->adapter->dev, "info: curr_bss_params.channel = %d\n",
-	       priv->curr_bss_params.bss_descriptor.channel);
+		priv->curr_bss_params.bss_descriptor.channel);
 	dev_dbg(priv->adapter->dev, "info: curr_bss_params.band = %d\n",
-	       priv->curr_bss_params.band);
+		priv->curr_bss_params.band);
 
 	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_AD_HOC_START,
 				    HostCmd_ACT_GEN_SET, 0, adhoc_ssid);
@@ -1267,13 +1266,13 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
 		       struct mwifiex_bssdescriptor *bss_desc)
 {
 	dev_dbg(priv->adapter->dev, "info: adhoc join: curr_bss ssid =%s\n",
-	       priv->curr_bss_params.bss_descriptor.ssid.ssid);
+		priv->curr_bss_params.bss_descriptor.ssid.ssid);
 	dev_dbg(priv->adapter->dev, "info: adhoc join: curr_bss ssid_len =%u\n",
-	       priv->curr_bss_params.bss_descriptor.ssid.ssid_len);
+		priv->curr_bss_params.bss_descriptor.ssid.ssid_len);
 	dev_dbg(priv->adapter->dev, "info: adhoc join: ssid =%s\n",
 		bss_desc->ssid.ssid);
 	dev_dbg(priv->adapter->dev, "info: adhoc join: ssid_len =%u\n",
-	       bss_desc->ssid.ssid_len);
+		bss_desc->ssid.ssid_len);
 
 	/* Check if the requested SSID is already joined */
 	if (priv->curr_bss_params.bss_descriptor.ssid.ssid_len &&
@@ -1287,9 +1286,9 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
 	}
 
 	dev_dbg(priv->adapter->dev, "info: curr_bss_params.channel = %d\n",
-	       priv->curr_bss_params.bss_descriptor.channel);
+		priv->curr_bss_params.bss_descriptor.channel);
 	dev_dbg(priv->adapter->dev, "info: curr_bss_params.band = %c\n",
-	       priv->curr_bss_params.band);
+		priv->curr_bss_params.band);
 
 	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_AD_HOC_JOIN,
 				    HostCmd_ACT_GEN_SET, 0, bss_desc);
-- 
1.7.0.2

