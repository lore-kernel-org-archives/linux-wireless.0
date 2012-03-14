Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:48690 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030413Ab2CNCW7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 22:22:59 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 2/9] mwifiex: fix checkpatch --strict warnings/errors Part 2
Date: Tue, 13 Mar 2012 19:22:35 -0700
Message-Id: <1331691762-5514-3-git-send-email-bzhao@marvell.com> (sfid-20120314_032304_543474_8027486A)
In-Reply-To: <1331691762-5514-1-git-send-email-bzhao@marvell.com>
References: <1331691762-5514-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

For files cfg80211.c, cfp.c, and cmdevt.c

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   90 ++++++++---------
 drivers/net/wireless/mwifiex/cfp.c      |    4 +-
 drivers/net/wireless/mwifiex/cmdevt.c   |  166 ++++++++++++++++---------------
 3 files changed, 133 insertions(+), 127 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 84508b0..6505038 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -127,8 +127,7 @@ mwifiex_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 
 	if (timeout)
 		wiphy_dbg(wiphy,
-			"info: ignoring the timeout value"
-			" for IEEE power save\n");
+			  "info: ignore timeout value for IEEE Power Save\n");
 
 	ps_mode = enabled;
 
@@ -168,7 +167,7 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(netdev);
 
 	if (mwifiex_set_encode(priv, params->key, params->key_len,
-							key_index, 0)) {
+			       key_index, 0)) {
 		wiphy_err(wiphy, "crypto keys added\n");
 		return -EFAULT;
 	}
@@ -225,7 +224,7 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 		}
 
 		if (ch->hw_value == next_chan + 1 &&
-				ch->max_power == max_pwr) {
+		    ch->max_power == max_pwr) {
 			next_chan++;
 			no_of_parsed_chan++;
 		} else {
@@ -252,7 +251,7 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 	domain_info->no_of_triplet = no_of_triplet;
 
 	if (mwifiex_send_cmd_async(priv, HostCmd_CMD_802_11D_DOMAIN_INFO,
-				     HostCmd_ACT_GEN_SET, 0, NULL)) {
+				   HostCmd_ACT_GEN_SET, 0, NULL)) {
 		wiphy_err(wiphy, "11D: setting domain info in FW\n");
 		return -1;
 	}
@@ -271,7 +270,7 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
  *      - Set bt Country IE
  */
 static int mwifiex_reg_notifier(struct wiphy *wiphy,
-		struct regulatory_request *request)
+				struct regulatory_request *request)
 {
 	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 
@@ -316,7 +315,7 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 		if (chan->band == IEEE80211_BAND_2GHZ) {
 			if (channel_type == NL80211_CHAN_NO_HT)
 				if (priv->adapter->config_bands == BAND_B ||
-					  priv->adapter->config_bands == BAND_G)
+				    priv->adapter->config_bands == BAND_G)
 					config_bands =
 						priv->adapter->config_bands;
 				else
@@ -336,7 +335,7 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 			if (priv->bss_mode == NL80211_IFTYPE_ADHOC) {
 				adapter->adhoc_start_band = config_bands;
 				if ((config_bands & BAND_GN) ||
-						(config_bands & BAND_AN))
+				    (config_bands & BAND_AN))
 					adapter->adhoc_11n_enabled = true;
 				else
 					adapter->adhoc_11n_enabled = false;
@@ -350,9 +349,8 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 		mwifiex_send_domain_info_cmd_fw(wiphy);
 	}
 
-	wiphy_dbg(wiphy, "info: setting band %d, channel offset %d and "
-		"mode %d\n", config_bands, adapter->sec_chan_offset,
-		priv->bss_mode);
+	wiphy_dbg(wiphy, "info: setting band %d, chan offset %d, mode %d\n",
+		  config_bands, adapter->sec_chan_offset, priv->bss_mode);
 	if (!chan)
 		return 0;
 
@@ -403,8 +401,8 @@ mwifiex_set_frag(struct mwifiex_private *priv, u32 frag_thr)
 {
 	int ret;
 
-	if (frag_thr < MWIFIEX_FRAG_MIN_VALUE
-	    || frag_thr > MWIFIEX_FRAG_MAX_VALUE)
+	if (frag_thr < MWIFIEX_FRAG_MIN_VALUE ||
+	    frag_thr > MWIFIEX_FRAG_MAX_VALUE)
 		return -EINVAL;
 
 	/* Send request to firmware */
@@ -746,8 +744,7 @@ static int mwifiex_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
 	adapter->channel_type = NL80211_CHAN_NO_HT;
 
 	wiphy_debug(wiphy, "info: device configured in 802.11%s%s mode\n",
-				(mode & BAND_B) ? "b" : "",
-				(mode & BAND_G) ? "g" : "");
+		    (mode & BAND_B) ? "b" : "", (mode & BAND_G) ? "g" : "");
 
 	return 0;
 }
@@ -802,8 +799,7 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 	ie_buf[1] = bss_info.ssid.ssid_len;
 
 	memcpy(&ie_buf[sizeof(struct ieee_types_header)],
-			&bss_info.ssid.ssid,
-			bss_info.ssid.ssid_len);
+	       &bss_info.ssid.ssid, bss_info.ssid.ssid_len);
 	ie_len = ie_buf[1] + sizeof(struct ieee_types_header);
 
 	band = mwifiex_band_to_radio_type(priv->curr_bss_params.band);
@@ -812,8 +808,8 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 						       band));
 
 	bss = cfg80211_inform_bss(priv->wdev->wiphy, chan,
-		bss_info.bssid, 0, WLAN_CAPABILITY_IBSS,
-		0, ie_buf, ie_len, 0, GFP_KERNEL);
+				  bss_info.bssid, 0, WLAN_CAPABILITY_IBSS,
+				  0, ie_buf, ie_len, 0, GFP_KERNEL);
 	cfg80211_put_bss(bss);
 	memcpy(priv->cfg_bssid, bss_info.bssid, ETH_ALEN);
 
@@ -952,14 +948,15 @@ done:
 
 		if (!bss) {
 			if (is_scanning_required) {
-				dev_warn(priv->adapter->dev, "assoc: requested "
-					 "bss not found in scan results\n");
+				dev_warn(priv->adapter->dev,
+					 "assoc: requested bss not found in scan results\n");
 				break;
 			}
 			is_scanning_required = 1;
 		} else {
-			dev_dbg(priv->adapter->dev, "info: trying to associate to %s and bssid %pM\n",
-					(char *) req_ssid.ssid, bss->bssid);
+			dev_dbg(priv->adapter->dev,
+				"info: trying to associate to '%s' bssid %pM\n",
+				(char *) req_ssid.ssid, bss->bssid);
 			memcpy(&priv->cfg_bssid, bss->bssid, ETH_ALEN);
 			break;
 		}
@@ -999,7 +996,7 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	wiphy_dbg(wiphy, "info: Trying to associate to %s and bssid %pM\n",
-	       (char *) sme->ssid, sme->bssid);
+		  (char *) sme->ssid, sme->bssid);
 
 	ret = mwifiex_cfg80211_assoc(priv, sme->ssid_len, sme->ssid, sme->bssid,
 				     priv->bss_mode, sme->channel, sme, 0);
@@ -1041,11 +1038,11 @@ mwifiex_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	wiphy_dbg(wiphy, "info: trying to join to %s and bssid %pM\n",
-	       (char *) params->ssid, params->bssid);
+		  (char *) params->ssid, params->bssid);
 
 	ret = mwifiex_cfg80211_assoc(priv, params->ssid_len, params->ssid,
-				params->bssid, priv->bss_mode,
-				params->channel, NULL, params->privacy);
+				     params->bssid, priv->bss_mode,
+				     params->channel, NULL, params->privacy);
 done:
 	if (!ret) {
 		cfg80211_ibss_joined(priv->netdev, priv->cfg_bssid, GFP_KERNEL);
@@ -1072,7 +1069,7 @@ mwifiex_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
 	wiphy_dbg(wiphy, "info: disconnecting from essid %pM\n",
-			priv->cfg_bssid);
+		  priv->cfg_bssid);
 	if (mwifiex_deauthenticate(priv, NULL))
 		return -EFAULT;
 
@@ -1101,7 +1098,7 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy, struct net_device *dev,
 	priv->scan_request = request;
 
 	priv->user_scan_cfg = kzalloc(sizeof(struct mwifiex_user_scan_cfg),
-					GFP_KERNEL);
+				      GFP_KERNEL);
 	if (!priv->user_scan_cfg) {
 		dev_err(priv->adapter->dev, "failed to alloc scan_req\n");
 		return -ENOMEM;
@@ -1117,10 +1114,10 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy, struct net_device *dev,
 
 		if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN)
 			priv->user_scan_cfg->chan_list[i].scan_type =
-				MWIFIEX_SCAN_TYPE_PASSIVE;
+						MWIFIEX_SCAN_TYPE_PASSIVE;
 		else
 			priv->user_scan_cfg->chan_list[i].scan_type =
-				MWIFIEX_SCAN_TYPE_ACTIVE;
+						MWIFIEX_SCAN_TYPE_ACTIVE;
 
 		priv->user_scan_cfg->chan_list[i].scan_time = 0;
 	}
@@ -1191,9 +1188,9 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
 	memset(mcs, 0xff, rx_mcs_supp);
 	/* Clear all the other values */
 	memset(&mcs[rx_mcs_supp], 0,
-			sizeof(struct ieee80211_mcs_info) - rx_mcs_supp);
+	       sizeof(struct ieee80211_mcs_info) - rx_mcs_supp);
 	if (priv->bss_mode == NL80211_IFTYPE_STATION ||
-			ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap))
+	    ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap))
 		/* Set MCS32 for infra mode or ad-hoc mode with 40MHz support */
 		SETHT_MCS32(mcs_set.rx_mask);
 
@@ -1206,10 +1203,10 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
  *  create a new virtual interface with the given name
  */
 struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
-						char *name,
-						enum nl80211_iftype type,
-						u32 *flags,
-						struct vif_params *params)
+					    char *name,
+					    enum nl80211_iftype type,
+					    u32 *flags,
+					    struct vif_params *params)
 {
 	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 	struct mwifiex_adapter *adapter;
@@ -1367,11 +1364,12 @@ int mwifiex_register_cfg80211(struct mwifiex_private *priv)
 	int ret;
 	void *wdev_priv;
 	struct wireless_dev *wdev;
+	struct ieee80211_sta_ht_cap *ht_info;
 
 	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
 	if (!wdev) {
 		dev_err(priv->adapter->dev, "%s: allocating wireless device\n",
-						__func__);
+			__func__);
 		return -ENOMEM;
 	}
 	wdev->wiphy =
@@ -1383,17 +1381,17 @@ int mwifiex_register_cfg80211(struct mwifiex_private *priv)
 	}
 	wdev->iftype = NL80211_IFTYPE_STATION;
 	wdev->wiphy->max_scan_ssids = 10;
-	wdev->wiphy->interface_modes =
-		BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
+	wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				       BIT(NL80211_IFTYPE_ADHOC);
 
 	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &mwifiex_band_2ghz;
-	mwifiex_setup_ht_caps(
-		&wdev->wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap, priv);
+	ht_info = &wdev->wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap;
+	mwifiex_setup_ht_caps(ht_info, priv);
 
 	if (priv->adapter->config_bands & BAND_A) {
 		wdev->wiphy->bands[IEEE80211_BAND_5GHZ] = &mwifiex_band_5ghz;
-		mwifiex_setup_ht_caps(
-			&wdev->wiphy->bands[IEEE80211_BAND_5GHZ]->ht_cap, priv);
+		ht_info = &wdev->wiphy->bands[IEEE80211_BAND_5GHZ]->ht_cap;
+		mwifiex_setup_ht_caps(ht_info, priv);
 	} else {
 		wdev->wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
 	}
@@ -1420,13 +1418,13 @@ int mwifiex_register_cfg80211(struct mwifiex_private *priv)
 	ret = wiphy_register(wdev->wiphy);
 	if (ret < 0) {
 		dev_err(priv->adapter->dev, "%s: registering cfg80211 device\n",
-						__func__);
+			__func__);
 		wiphy_free(wdev->wiphy);
 		kfree(wdev);
 		return ret;
 	} else {
 		dev_dbg(priv->adapter->dev,
-				"info: successfully registered wiphy device\n");
+			"info: successfully registered wiphy device\n");
 	}
 
 	priv->wdev = wdev;
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index 7541d9a..2fe1c33 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -163,8 +163,8 @@ u32 mwifiex_get_active_data_rates(struct mwifiex_private *priv, u8 *rates)
 		return mwifiex_get_supported_rates(priv, rates);
 	else
 		return mwifiex_copy_rates(rates, 0,
-				       priv->curr_bss_params.data_rates,
-				       priv->curr_bss_params.num_of_rates);
+					  priv->curr_bss_params.data_rates,
+					  priv->curr_bss_params.num_of_rates);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index c82eb7f..07f6e00 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -67,7 +67,7 @@ mwifiex_get_cmd_node(struct mwifiex_adapter *adapter)
 		return NULL;
 	}
 	cmd_node = list_first_entry(&adapter->cmd_free_q,
-			struct cmd_ctrl_node, list);
+				    struct cmd_ctrl_node, list);
 	list_del(&cmd_node->list);
 	spin_unlock_irqrestore(&adapter->cmd_free_q_lock, flags);
 
@@ -158,8 +158,9 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	/* Set command sequence number */
 	adapter->seq_num++;
 	host_cmd->seq_num = cpu_to_le16(HostCmd_SET_SEQ_NO_BSS_INFO
-			    (adapter->seq_num, cmd_node->priv->bss_num,
-			     cmd_node->priv->bss_type));
+					(adapter->seq_num,
+					 cmd_node->priv->bss_num,
+					 cmd_node->priv->bss_type));
 
 	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 	adapter->curr_cmd = cmd_node;
@@ -174,8 +175,8 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	dev_dbg(adapter->dev, "cmd: DNLD_CMD: (%lu.%lu): %#x, act %#x, len %d,"
 		" seqno %#x\n",
 		tstamp.tv_sec, tstamp.tv_usec, cmd_code,
-	       le16_to_cpu(*(__le16 *) ((u8 *) host_cmd + S_DS_GEN)), cmd_size,
-	       le16_to_cpu(host_cmd->seq_num));
+		le16_to_cpu(*(__le16 *) ((u8 *) host_cmd + S_DS_GEN)), cmd_size,
+		le16_to_cpu(host_cmd->seq_num));
 
 	skb_push(cmd_node->cmd_skb, INTF_HEADER_LEN);
 
@@ -200,17 +201,17 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 
 	/* Save the last command id and action to debug log */
 	adapter->dbg.last_cmd_index =
-		(adapter->dbg.last_cmd_index + 1) % DBG_CMD_NUM;
+			(adapter->dbg.last_cmd_index + 1) % DBG_CMD_NUM;
 	adapter->dbg.last_cmd_id[adapter->dbg.last_cmd_index] = cmd_code;
 	adapter->dbg.last_cmd_act[adapter->dbg.last_cmd_index] =
-		le16_to_cpu(*(__le16 *) ((u8 *) host_cmd + S_DS_GEN));
+			le16_to_cpu(*(__le16 *) ((u8 *) host_cmd + S_DS_GEN));
 
 	/* Clear BSS_NO_BITS from HostCmd */
 	cmd_code &= HostCmd_CMD_ID_MASK;
 
 	/* Setup the timer after transmit command */
 	mod_timer(&adapter->cmd_timer,
-		jiffies + (MWIFIEX_TIMER_10S * HZ) / 1000);
+		  jiffies + (MWIFIEX_TIMER_10S * HZ) / 1000);
 
 	return 0;
 }
@@ -230,7 +231,7 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 	struct mwifiex_private *priv;
 	struct mwifiex_opt_sleep_confirm *sleep_cfm_buf =
 				(struct mwifiex_opt_sleep_confirm *)
-				adapter->sleep_cfm->data;
+						adapter->sleep_cfm->data;
 	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 
 	sleep_cfm_buf->seq_num =
@@ -250,7 +251,7 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 		return -1;
 	}
 	if (GET_BSS_ROLE(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY))
-			== MWIFIEX_BSS_ROLE_STA) {
+	    == MWIFIEX_BSS_ROLE_STA) {
 		if (!sleep_cfm_buf->resp_ctrl)
 			/* Response is not needed for sleep
 			   confirm command */
@@ -258,12 +259,12 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 		else
 			adapter->ps_state = PS_STATE_SLEEP_CFM;
 
-		if (!sleep_cfm_buf->resp_ctrl
-				&& (adapter->is_hs_configured
-					&& !adapter->sleep_period.period)) {
+		if (!sleep_cfm_buf->resp_ctrl &&
+		    (adapter->is_hs_configured &&
+		     !adapter->sleep_period.period)) {
 			adapter->pm_wakeup_card_req = true;
-			mwifiex_hs_activated_event(mwifiex_get_priv(adapter,
-						MWIFIEX_BSS_ROLE_STA), true);
+			mwifiex_hs_activated_event(mwifiex_get_priv
+					(adapter, MWIFIEX_BSS_ROLE_STA), true);
 		}
 	}
 
@@ -293,7 +294,7 @@ int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
 	cmd_array = kzalloc(buf_size, GFP_KERNEL);
 	if (!cmd_array) {
 		dev_err(adapter->dev, "%s: failed to alloc cmd_array\n",
-				__func__);
+			__func__);
 		return -ENOMEM;
 	}
 
@@ -376,9 +377,9 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 
 	/* Save the last event to debug log */
 	adapter->dbg.last_event_index =
-		(adapter->dbg.last_event_index + 1) % DBG_CMD_NUM;
+			(adapter->dbg.last_event_index + 1) % DBG_CMD_NUM;
 	adapter->dbg.last_event[adapter->dbg.last_event_index] =
-		(u16) eventcause;
+							(u16) eventcause;
 
 	/* Get BSS number and corresponding priv */
 	priv = mwifiex_get_priv_by_id(adapter, EVENT_GET_BSS_NUM(eventcause),
@@ -398,7 +399,7 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 	if (eventcause != EVENT_PS_SLEEP && eventcause != EVENT_PS_AWAKE) {
 		do_gettimeofday(&tstamp);
 		dev_dbg(adapter->dev, "event: %lu.%lu: cause: %#x\n",
-		       tstamp.tv_sec, tstamp.tv_usec, eventcause);
+			tstamp.tv_sec, tstamp.tv_usec, eventcause);
 	}
 
 	ret = mwifiex_process_sta_event(priv);
@@ -509,7 +510,7 @@ int mwifiex_send_cmd_async(struct mwifiex_private *priv, uint16_t cmd_no,
 	/* Return error, since the command preparation failed */
 	if (ret) {
 		dev_err(adapter->dev, "PREP_CMD: cmd %#x preparation failed\n",
-							cmd_no);
+			cmd_no);
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 		return -1;
 	}
@@ -577,9 +578,9 @@ mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
 	/* Exit_PS command needs to be queued in the header always. */
 	if (command == HostCmd_CMD_802_11_PS_MODE_ENH) {
 		struct host_cmd_ds_802_11_ps_mode_enh *pm =
-			&host_cmd->params.psmode_enh;
-		if ((le16_to_cpu(pm->action) == DIS_PS)
-		    || (le16_to_cpu(pm->action) == DIS_AUTO_PS)) {
+						&host_cmd->params.psmode_enh;
+		if ((le16_to_cpu(pm->action) == DIS_PS) ||
+		    (le16_to_cpu(pm->action) == DIS_AUTO_PS)) {
 			if (adapter->ps_state != PS_STATE_AWAKE)
 				add_tail = false;
 		}
@@ -692,7 +693,7 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	if (!adapter->curr_cmd || !adapter->curr_cmd->resp_skb) {
 		resp = (struct host_cmd_ds_command *) adapter->upld_buf;
 		dev_err(adapter->dev, "CMD_RESP: NULL curr_cmd, %#x\n",
-		       le16_to_cpu(resp->command));
+			le16_to_cpu(resp->command));
 		return -1;
 	}
 
@@ -701,7 +702,7 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	resp = (struct host_cmd_ds_command *) adapter->curr_cmd->resp_skb->data;
 	if (adapter->curr_cmd->cmd_flag & CMD_F_CANCELED) {
 		dev_err(adapter->dev, "CMD_RESP: %#x been canceled\n",
-				le16_to_cpu(resp->command));
+			le16_to_cpu(resp->command));
 		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->curr_cmd = NULL;
@@ -725,8 +726,8 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 
 	/* Get BSS number and corresponding priv */
 	priv = mwifiex_get_priv_by_id(adapter,
-			HostCmd_GET_BSS_NO(le16_to_cpu(resp->seq_num)),
-			HostCmd_GET_BSS_TYPE(le16_to_cpu(resp->seq_num)));
+			     HostCmd_GET_BSS_NO(le16_to_cpu(resp->seq_num)),
+			     HostCmd_GET_BSS_TYPE(le16_to_cpu(resp->seq_num)));
 	if (!priv)
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 	/* Clear RET_BIT from HostCmd */
@@ -737,9 +738,9 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 
 	/* Save the last command response to debug log */
 	adapter->dbg.last_cmd_resp_index =
-		(adapter->dbg.last_cmd_resp_index + 1) % DBG_CMD_NUM;
+			(adapter->dbg.last_cmd_resp_index + 1) % DBG_CMD_NUM;
 	adapter->dbg.last_cmd_resp_id[adapter->dbg.last_cmd_resp_index] =
-		orig_cmdresp_no;
+								orig_cmdresp_no;
 
 	do_gettimeofday(&tstamp);
 	dev_dbg(adapter->dev, "cmd: CMD_RESP: (%lu.%lu): 0x%x, result %d,"
@@ -761,8 +762,8 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 
 	if (adapter->curr_cmd->cmd_flag & CMD_F_HOSTCMD) {
 		adapter->curr_cmd->cmd_flag &= ~CMD_F_HOSTCMD;
-		if ((cmdresp_result == HostCmd_RESULT_OK)
-		    && (cmdresp_no == HostCmd_CMD_802_11_HS_CFG_ENH))
+		if ((cmdresp_result == HostCmd_RESULT_OK) &&
+		    (cmdresp_no == HostCmd_CMD_802_11_HS_CFG_ENH))
 			ret = mwifiex_ret_802_11_hs_cfg(priv, resp);
 	} else {
 		/* handle response */
@@ -824,44 +825,45 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 		adapter->dbg.timeout_cmd_act =
 			adapter->dbg.last_cmd_act[adapter->dbg.last_cmd_index];
 		do_gettimeofday(&tstamp);
-		dev_err(adapter->dev, "%s: Timeout cmd id (%lu.%lu) = %#x,"
-			" act = %#x\n", __func__,
-		       tstamp.tv_sec, tstamp.tv_usec,
-		       adapter->dbg.timeout_cmd_id,
-		       adapter->dbg.timeout_cmd_act);
+		dev_err(adapter->dev,
+			"%s: Timeout cmd id (%lu.%lu) = %#x, act = %#x\n",
+			__func__, tstamp.tv_sec, tstamp.tv_usec,
+			adapter->dbg.timeout_cmd_id,
+			adapter->dbg.timeout_cmd_act);
 
 		dev_err(adapter->dev, "num_data_h2c_failure = %d\n",
-		       adapter->dbg.num_tx_host_to_card_failure);
+			adapter->dbg.num_tx_host_to_card_failure);
 		dev_err(adapter->dev, "num_cmd_h2c_failure = %d\n",
-		       adapter->dbg.num_cmd_host_to_card_failure);
+			adapter->dbg.num_cmd_host_to_card_failure);
 
 		dev_err(adapter->dev, "num_cmd_timeout = %d\n",
-		       adapter->dbg.num_cmd_timeout);
+			adapter->dbg.num_cmd_timeout);
 		dev_err(adapter->dev, "num_tx_timeout = %d\n",
-		       adapter->dbg.num_tx_timeout);
+			adapter->dbg.num_tx_timeout);
 
 		dev_err(adapter->dev, "last_cmd_index = %d\n",
-		       adapter->dbg.last_cmd_index);
+			adapter->dbg.last_cmd_index);
 		print_hex_dump_bytes("last_cmd_id: ", DUMP_PREFIX_OFFSET,
-				adapter->dbg.last_cmd_id, DBG_CMD_NUM);
+				     adapter->dbg.last_cmd_id, DBG_CMD_NUM);
 		print_hex_dump_bytes("last_cmd_act: ", DUMP_PREFIX_OFFSET,
-				adapter->dbg.last_cmd_act, DBG_CMD_NUM);
+				     adapter->dbg.last_cmd_act, DBG_CMD_NUM);
 
 		dev_err(adapter->dev, "last_cmd_resp_index = %d\n",
-		       adapter->dbg.last_cmd_resp_index);
+			adapter->dbg.last_cmd_resp_index);
 		print_hex_dump_bytes("last_cmd_resp_id: ", DUMP_PREFIX_OFFSET,
-				adapter->dbg.last_cmd_resp_id, DBG_CMD_NUM);
+				     adapter->dbg.last_cmd_resp_id,
+				     DBG_CMD_NUM);
 
 		dev_err(adapter->dev, "last_event_index = %d\n",
-		       adapter->dbg.last_event_index);
+			adapter->dbg.last_event_index);
 		print_hex_dump_bytes("last_event: ", DUMP_PREFIX_OFFSET,
-				adapter->dbg.last_event, DBG_CMD_NUM);
+				     adapter->dbg.last_event, DBG_CMD_NUM);
 
 		dev_err(adapter->dev, "data_sent=%d cmd_sent=%d\n",
-		       adapter->data_sent, adapter->cmd_sent);
+			adapter->data_sent, adapter->cmd_sent);
 
 		dev_err(adapter->dev, "ps_mode=%d ps_state=%d\n",
-				adapter->ps_mode, adapter->ps_state);
+			adapter->ps_mode, adapter->ps_state);
 	}
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING)
 		mwifiex_init_fw_complete(adapter);
@@ -942,7 +944,7 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 	uint16_t cancel_scan_cmd = false;
 
 	if ((adapter->curr_cmd) &&
-	     (adapter->curr_cmd->wait_q_enabled)) {
+	    (adapter->curr_cmd->wait_q_enabled)) {
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
 		cmd_node = adapter->curr_cmd;
 		cmd_node->wait_q_enabled = false;
@@ -996,9 +998,9 @@ mwifiex_check_ps_cond(struct mwifiex_adapter *adapter)
 	else
 		dev_dbg(adapter->dev,
 			"cmd: Delay Sleep Confirm (%s%s%s)\n",
-		       (adapter->cmd_sent) ? "D" : "",
-		       (adapter->curr_cmd) ? "C" : "",
-		       (IS_CARD_RX_RCVD(adapter)) ? "R" : "");
+			(adapter->cmd_sent) ? "D" : "",
+			(adapter->curr_cmd) ? "C" : "",
+			(IS_CARD_RX_RCVD(adapter)) ? "R" : "");
 }
 
 /*
@@ -1050,8 +1052,8 @@ int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 		dev_dbg(adapter->dev, "cmd: CMD_RESP: HS_CFG cmd reply"
 			" result=%#x, conditions=0x%x gpio=0x%x gap=0x%x\n",
 			resp->result, conditions,
-		       phs_cfg->params.hs_config.gpio,
-		       phs_cfg->params.hs_config.gap);
+			phs_cfg->params.hs_config.gpio,
+			phs_cfg->params.hs_config.gap);
 	}
 	if (conditions != HOST_SLEEP_CFG_CANCEL) {
 		adapter->is_hs_configured = true;
@@ -1078,7 +1080,8 @@ mwifiex_process_hs_config(struct mwifiex_adapter *adapter)
 	adapter->hs_activated = false;
 	adapter->is_hs_configured = false;
 	mwifiex_hs_activated_event(mwifiex_get_priv(adapter,
-				   MWIFIEX_BSS_ROLE_ANY), false);
+						    MWIFIEX_BSS_ROLE_ANY),
+				   false);
 }
 
 /*
@@ -1114,22 +1117,24 @@ mwifiex_process_sleep_confirm_resp(struct mwifiex_adapter *adapter,
 	command &= HostCmd_CMD_ID_MASK;
 
 	if (command != HostCmd_CMD_802_11_PS_MODE_ENH) {
-		dev_err(adapter->dev, "%s: received unexpected response for"
-			" cmd %x, result = %x\n", __func__, command, result);
+		dev_err(adapter->dev,
+			"%s: rcvd unexpected resp for cmd %#x, result = %x\n",
+			__func__, command, result);
 		return;
 	}
 
 	if (result) {
 		dev_err(adapter->dev, "%s: sleep confirm cmd failed\n",
-						__func__);
+			__func__);
 		adapter->pm_wakeup_card_req = false;
 		adapter->ps_state = PS_STATE_AWAKE;
 		return;
 	}
 	adapter->pm_wakeup_card_req = true;
 	if (adapter->is_hs_configured)
-		mwifiex_hs_activated_event(mwifiex_get_priv(adapter,
-					   MWIFIEX_BSS_ROLE_ANY), true);
+		mwifiex_hs_activated_event(mwifiex_get_priv
+						(adapter, MWIFIEX_BSS_ROLE_ANY),
+					   true);
 	adapter->ps_state = PS_STATE_SLEEP;
 	cmd->command = cpu_to_le16(command);
 	cmd->seq_num = cpu_to_le16(seq_num);
@@ -1163,17 +1168,17 @@ int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
 		psmode_enh->action = cpu_to_le16(DIS_AUTO_PS);
 		psmode_enh->params.ps_bitmap = cpu_to_le16(ps_bitmap);
 		cmd->size = cpu_to_le16(S_DS_GEN + sizeof(psmode_enh->action) +
-				sizeof(psmode_enh->params.ps_bitmap));
+					sizeof(psmode_enh->params.ps_bitmap));
 	} else if (cmd_action == GET_PS) {
 		psmode_enh->action = cpu_to_le16(GET_PS);
 		psmode_enh->params.ps_bitmap = cpu_to_le16(ps_bitmap);
 		cmd->size = cpu_to_le16(S_DS_GEN + sizeof(psmode_enh->action) +
-				sizeof(psmode_enh->params.ps_bitmap));
+					sizeof(psmode_enh->params.ps_bitmap));
 	} else if (cmd_action == EN_AUTO_PS) {
 		psmode_enh->action = cpu_to_le16(EN_AUTO_PS);
 		psmode_enh->params.ps_bitmap = cpu_to_le16(ps_bitmap);
 		cmd_size = S_DS_GEN + sizeof(psmode_enh->action) +
-				sizeof(psmode_enh->params.ps_bitmap);
+					sizeof(psmode_enh->params.ps_bitmap);
 		tlv = (u8 *) cmd + cmd_size;
 		if (ps_bitmap & BITMAP_STA_PS) {
 			struct mwifiex_adapter *adapter = priv->adapter;
@@ -1187,19 +1192,18 @@ int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
 			tlv += sizeof(*ps_tlv);
 			dev_dbg(adapter->dev, "cmd: PS Command: Enter PS\n");
 			ps_mode->null_pkt_interval =
-				cpu_to_le16(adapter->null_pkt_interval);
+					cpu_to_le16(adapter->null_pkt_interval);
 			ps_mode->multiple_dtims =
-				cpu_to_le16(adapter->multiple_dtim);
+					cpu_to_le16(adapter->multiple_dtim);
 			ps_mode->bcn_miss_timeout =
-				cpu_to_le16(adapter->bcn_miss_time_out);
+					cpu_to_le16(adapter->bcn_miss_time_out);
 			ps_mode->local_listen_interval =
 				cpu_to_le16(adapter->local_listen_interval);
 			ps_mode->adhoc_wake_period =
 				cpu_to_le16(adapter->adhoc_awake_period);
 			ps_mode->delay_to_ps =
-				cpu_to_le16(adapter->delay_to_ps);
-			ps_mode->mode =
-				cpu_to_le16(adapter->enhanced_ps_mode);
+					cpu_to_le16(adapter->delay_to_ps);
+			ps_mode->mode = cpu_to_le16(adapter->enhanced_ps_mode);
 
 		}
 		if (ps_bitmap & BITMAP_AUTO_DS) {
@@ -1217,7 +1221,7 @@ int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
 			if (auto_ds)
 				idletime = auto_ds->idle_time;
 			dev_dbg(priv->adapter->dev,
-					"cmd: PS Command: Enter Auto Deep Sleep\n");
+				"cmd: PS Command: Enter Auto Deep Sleep\n");
 			auto_ds_tlv->deep_sleep_timeout = cpu_to_le16(idletime);
 		}
 		cmd->size = cpu_to_le16(cmd_size);
@@ -1244,8 +1248,9 @@ int mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
 	uint16_t auto_ps_bitmap =
 		le16_to_cpu(ps_mode->params.ps_bitmap);
 
-	dev_dbg(adapter->dev, "info: %s: PS_MODE cmd reply result=%#x action=%#X\n",
-					__func__, resp->result, action);
+	dev_dbg(adapter->dev,
+		"info: %s: PS_MODE cmd reply result=%#x action=%#X\n",
+		__func__, resp->result, action);
 	if (action == EN_AUTO_PS) {
 		if (auto_ps_bitmap & BITMAP_AUTO_DS) {
 			dev_dbg(adapter->dev, "cmd: Enabled auto deep sleep\n");
@@ -1254,7 +1259,8 @@ int mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
 		if (auto_ps_bitmap & BITMAP_STA_PS) {
 			dev_dbg(adapter->dev, "cmd: Enabled STA power save\n");
 			if (adapter->sleep_period.period)
-				dev_dbg(adapter->dev, "cmd: set to uapsd/pps mode\n");
+				dev_dbg(adapter->dev,
+					"cmd: set to uapsd/pps mode\n");
 		}
 	} else if (action == DIS_AUTO_PS) {
 		if (ps_bitmap & BITMAP_AUTO_DS) {
@@ -1373,12 +1379,13 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 	adapter->number_of_antenna = le16_to_cpu(hw_spec->number_of_antenna);
 
 	dev_dbg(adapter->dev, "info: GET_HW_SPEC: fw_release_number- %#x\n",
-	       adapter->fw_release_number);
+		adapter->fw_release_number);
 	dev_dbg(adapter->dev, "info: GET_HW_SPEC: permanent addr: %pM\n",
-					hw_spec->permanent_addr);
-	dev_dbg(adapter->dev, "info: GET_HW_SPEC: hw_if_version=%#x  version=%#x\n",
+		hw_spec->permanent_addr);
+	dev_dbg(adapter->dev,
+		"info: GET_HW_SPEC: hw_if_version=%#x version=%#x\n",
 		le16_to_cpu(hw_spec->hw_if_version),
-	       le16_to_cpu(hw_spec->version));
+		le16_to_cpu(hw_spec->version));
 
 	if (priv->curr_addr[0] == 0xff)
 		memmove(priv->curr_addr, hw_spec->permanent_addr, ETH_ALEN);
@@ -1393,7 +1400,8 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 	/* If it's unidentified region code, use the default (USA) */
 	if (i >= MWIFIEX_MAX_REGION_CODE) {
 		adapter->region_code = 0x10;
-		dev_dbg(adapter->dev, "cmd: unknown region code, use default (USA)\n");
+		dev_dbg(adapter->dev,
+			"cmd: unknown region code, use default (USA)\n");
 	}
 
 	adapter->hw_dot_11n_dev_cap = le32_to_cpu(hw_spec->dot_11n_dev_cap);
-- 
1.7.0.2

