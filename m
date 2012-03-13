Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:33988 "HELO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758329Ab2CMCis (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 22:38:48 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 14/15] mwifiex: fix checkpatch --strict warnings/errors  Part 8
Date: Mon, 12 Mar 2012 19:38:10 -0700
Message-Id: <1331606291-322-5-git-send-email-bzhao@marvell.com> (sfid-20120313_033851_768269_D7A044F3)
In-Reply-To: <1331606291-322-1-git-send-email-bzhao@marvell.com>
References: <1331606291-322-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

For files sta_event.c and sta_ioctl.c

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_event.c |   37 ++++++-----
 drivers/net/wireless/mwifiex/sta_ioctl.c |  102 +++++++++++++++---------------
 2 files changed, 71 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index b9b59db..0b2412f 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -93,11 +93,11 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 	 */
 
 	dev_dbg(adapter->dev, "info: previous SSID=%s, SSID len=%u\n",
-	       priv->prev_ssid.ssid, priv->prev_ssid.ssid_len);
+		priv->prev_ssid.ssid, priv->prev_ssid.ssid_len);
 
 	dev_dbg(adapter->dev, "info: current SSID=%s, SSID len=%u\n",
-	       priv->curr_bss_params.bss_descriptor.ssid.ssid,
-	       priv->curr_bss_params.bss_descriptor.ssid.ssid_len);
+		priv->curr_bss_params.bss_descriptor.ssid.ssid,
+		priv->curr_bss_params.bss_descriptor.ssid.ssid_len);
 
 	memcpy(&priv->prev_ssid,
 	       &priv->curr_bss_params.bss_descriptor.ssid,
@@ -116,8 +116,8 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 		return;
 	priv->media_connected = false;
 	dev_dbg(adapter->dev, "info: successfully disconnected from"
-			" %pM: reason code %d\n", priv->cfg_bssid,
-			WLAN_REASON_DEAUTH_LEAVING);
+		" %pM: reason code %d\n", priv->cfg_bssid,
+		WLAN_REASON_DEAUTH_LEAVING);
 	if (priv->bss_mode == NL80211_IFTYPE_STATION) {
 		cfg80211_disconnected(priv->netdev, WLAN_REASON_DEAUTH_LEAVING,
 				      NULL, 0, GFP_KERNEL);
@@ -193,7 +193,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 	switch (eventcause) {
 	case EVENT_DUMMY_HOST_WAKEUP_SIGNAL:
 		dev_err(adapter->dev, "invalid EVENT: DUMMY_HOST_WAKEUP_SIGNAL,"
-				" ignoring it\n");
+			" ignoring it\n");
 		break;
 	case EVENT_LINK_SENSED:
 		dev_dbg(adapter->dev, "event: LINK_SENSED\n");
@@ -235,8 +235,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 	case EVENT_PS_AWAKE:
 		dev_dbg(adapter->dev, "info: EVENT: AWAKE\n");
 		if (!adapter->pps_uapsd_mode &&
-			priv->media_connected &&
-			adapter->sleep_period.period) {
+		    priv->media_connected && adapter->sleep_period.period) {
 				adapter->pps_uapsd_mode = true;
 				dev_dbg(adapter->dev,
 					"event: PPS/UAPSD mode activated\n");
@@ -244,15 +243,19 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		adapter->tx_lock_flag = false;
 		if (adapter->pps_uapsd_mode && adapter->gen_null_pkt) {
 			if (mwifiex_check_last_packet_indication(priv)) {
-				if (!adapter->data_sent) {
-					if (!mwifiex_send_null_packet(priv,
-					MWIFIEX_TxPD_POWER_MGMT_NULL_PACKET
-					|
-					MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET))
+				if (adapter->data_sent) {
+					adapter->ps_state = PS_STATE_AWAKE;
+					adapter->pm_wakeup_card_req = false;
+					adapter->pm_wakeup_fw_try = false;
+					break;
+				}
+				if (!mwifiex_send_null_packet
+					(priv,
+					 MWIFIEX_TxPD_POWER_MGMT_NULL_PACKET |
+					 MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET))
 						adapter->ps_state =
 							PS_STATE_SLEEP;
 					return 0;
-				}
 			}
 		}
 		adapter->ps_state = PS_STATE_AWAKE;
@@ -371,12 +374,12 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 	case EVENT_AMSDU_AGGR_CTRL:
 		dev_dbg(adapter->dev, "event:  AMSDU_AGGR_CTRL %d\n",
-		       *(u16 *) adapter->event_body);
+			*(u16 *) adapter->event_body);
 		adapter->tx_buf_size =
 			min(adapter->curr_tx_buf_size,
 			    le16_to_cpu(*(__le16 *) adapter->event_body));
 		dev_dbg(adapter->dev, "event: tx_buf_size %d\n",
-				adapter->tx_buf_size);
+			adapter->tx_buf_size);
 		break;
 
 	case EVENT_WEP_ICV_ERR:
@@ -392,7 +395,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 	default:
 		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
-						eventcause);
+			eventcause);
 		break;
 	}
 
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index a3d79f4..64e0b10 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -71,7 +71,7 @@ int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter)
 
 	/* Wait for completion */
 	wait_event_interruptible(adapter->cmd_wait_q.wait,
-					*(cmd_queued->condition));
+				 *(cmd_queued->condition));
 	if (!*(cmd_queued->condition))
 		cancel_flag = true;
 
@@ -266,9 +266,8 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 		/* Adhoc mode */
 		/* If the requested SSID matches current SSID, return */
 		if (bss_desc && bss_desc->ssid.ssid_len &&
-		    (!mwifiex_ssid_cmp
-		     (&priv->curr_bss_params.bss_descriptor.ssid,
-		      &bss_desc->ssid))) {
+		    (!mwifiex_ssid_cmp(&priv->curr_bss_params.bss_descriptor.
+				       ssid, &bss_desc->ssid))) {
 			kfree(bss_desc);
 			kfree(beacon_ie);
 			return 0;
@@ -350,9 +349,8 @@ static int mwifiex_set_hs_params(struct mwifiex_private *priv, u16 action,
 				adapter->hs_cfg.gpio = (u8)hs_cfg->gpio;
 				if (hs_cfg->gap)
 					adapter->hs_cfg.gap = (u8)hs_cfg->gap;
-			} else if (adapter->hs_cfg.conditions ==
-						cpu_to_le32(
-						HOST_SLEEP_CFG_CANCEL)) {
+			} else if (adapter->hs_cfg.conditions
+				   == cpu_to_le32(HOST_SLEEP_CFG_CANCEL)) {
 				/* Return failure if no parameters for HS
 				   enable */
 				status = -1;
@@ -374,7 +372,7 @@ static int mwifiex_set_hs_params(struct mwifiex_private *priv, u16 action,
 						cpu_to_le32(prev_cond);
 		} else {
 			adapter->hs_cfg.conditions =
-				cpu_to_le32(hs_cfg->conditions);
+						cpu_to_le32(hs_cfg->conditions);
 			adapter->hs_cfg.gpio = (u8)hs_cfg->gpio;
 			adapter->hs_cfg.gap = (u8)hs_cfg->gap;
 		}
@@ -431,7 +429,7 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 	hscfg.is_invoke_hostcmd = true;
 
 	if (mwifiex_set_hs_params(mwifiex_get_priv(adapter,
-						       MWIFIEX_BSS_ROLE_STA),
+						   MWIFIEX_BSS_ROLE_STA),
 				  HostCmd_ACT_GEN_SET, MWIFIEX_SYNC_CMD,
 				  &hscfg)) {
 		dev_err(adapter->dev, "IOCTL request HS enable failed\n");
@@ -439,7 +437,7 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 	}
 
 	wait_event_interruptible(adapter->hs_activate_wait_q,
-			adapter->hs_activate_wait_q_woken);
+				 adapter->hs_activate_wait_q_woken);
 
 	return true;
 }
@@ -536,7 +534,7 @@ int mwifiex_bss_set_channel(struct mwifiex_private *priv,
 			if (cfp) {
 				if (adapter->adhoc_11n_enabled)
 					adapter->adhoc_start_band = BAND_A
-						| BAND_AN;
+								    | BAND_AN;
 				else
 					adapter->adhoc_start_band = BAND_A;
 			}
@@ -549,7 +547,7 @@ int mwifiex_bss_set_channel(struct mwifiex_private *priv,
 			if (cfp) {
 				if (adapter->adhoc_11n_enabled)
 					adapter->adhoc_start_band = BAND_A
-						| BAND_AN;
+								    | BAND_AN;
 				else
 					adapter->adhoc_start_band = BAND_A;
 			}
@@ -585,7 +583,7 @@ static int mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *priv,
 	}
 
 	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_RF_CHANNEL,
-				    action, 0, channel);
+				     action, 0, channel);
 }
 
 /*
@@ -631,7 +629,7 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, u16 channel)
 		goto done;
 	}
 	dev_dbg(priv->adapter->dev, "cmd: updating channel from %d to %d\n",
-			curr_chan, channel);
+		curr_chan, channel);
 
 	if (!bss_info.media_connected) {
 		ret = 0;
@@ -653,7 +651,8 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, u16 channel)
 
 	band = mwifiex_band_to_radio_type(priv->curr_bss_params.band);
 	chan = __ieee80211_get_channel(priv->wdev->wiphy,
-			ieee80211_channel_to_frequency(channel, band));
+				       ieee80211_channel_to_frequency(channel,
+								      band));
 
 	/* Find the BSS we want using available scan results */
 	bss = cfg80211_get_bss(priv->wdev->wiphy, chan, bss_info.bssid,
@@ -661,7 +660,7 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, u16 channel)
 			       WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
 	if (!bss)
 		wiphy_warn(priv->wdev->wiphy, "assoc: bss %pM not in scan results\n",
-			  bss_info.bssid);
+			   bss_info.bssid);
 
 	ret = mwifiex_bss_start(priv, bss, &bss_info.ssid);
 done:
@@ -790,7 +789,9 @@ int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
 	if (!ret) {
 		if (rate->is_rate_auto)
 			rate->rate = mwifiex_index_to_data_rate(priv,
-					priv->tx_rate, priv->tx_htinfo);
+								priv->tx_rate,
+								priv->tx_htinfo
+								);
 		else
 			rate->rate = priv->data_rate;
 	} else {
@@ -827,16 +828,16 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 		if ((dbm < priv->min_tx_power_level) ||
 		    (dbm > priv->max_tx_power_level)) {
 			dev_err(priv->adapter->dev, "txpower value %d dBm"
-					" is out of range (%d dBm-%d dBm)\n",
-					dbm, priv->min_tx_power_level,
-					priv->max_tx_power_level);
+				" is out of range (%d dBm-%d dBm)\n",
+				dbm, priv->min_tx_power_level,
+				priv->max_tx_power_level);
 			return -1;
 		}
 	}
 	buf = kzalloc(MWIFIEX_SIZE_OF_CMD_BUFFER, GFP_KERNEL);
 	if (!buf) {
 		dev_err(priv->adapter->dev, "%s: failed to alloc cmd buffer\n",
-				__func__);
+			__func__);
 		return -ENOMEM;
 	}
 
@@ -844,13 +845,13 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 	txp_cfg->action = cpu_to_le16(HostCmd_ACT_GEN_SET);
 	if (!power_cfg->is_power_auto) {
 		txp_cfg->mode = cpu_to_le32(1);
-		pg_tlv = (struct mwifiex_types_power_group *) (buf +
-				sizeof(struct host_cmd_ds_txpwr_cfg));
+		pg_tlv = (struct mwifiex_types_power_group *)
+			 (buf + sizeof(struct host_cmd_ds_txpwr_cfg));
 		pg_tlv->type = TLV_TYPE_POWER_GROUP;
 		pg_tlv->length = 4 * sizeof(struct mwifiex_power_group);
-		pg = (struct mwifiex_power_group *) (buf +
-				sizeof(struct host_cmd_ds_txpwr_cfg) +
-				sizeof(struct mwifiex_types_power_group));
+		pg = (struct mwifiex_power_group *)
+		     (buf + sizeof(struct host_cmd_ds_txpwr_cfg)
+		      + sizeof(struct mwifiex_types_power_group));
 		/* Power group for modulation class HR/DSSS */
 		pg->first_rate_code = 0x00;
 		pg->last_rate_code = 0x03;
@@ -913,8 +914,8 @@ int mwifiex_drv_set_power(struct mwifiex_private *priv, u32 *ps_mode)
 				    sub_cmd, BITMAP_STA_PS, NULL);
 	if ((!ret) && (sub_cmd == DIS_AUTO_PS))
 		ret = mwifiex_send_cmd_async(priv,
-				HostCmd_CMD_802_11_PS_MODE_ENH, GET_PS,
-				0, NULL);
+					     HostCmd_CMD_802_11_PS_MODE_ENH,
+					     GET_PS, 0, NULL);
 
 	return ret;
 }
@@ -938,7 +939,7 @@ static int mwifiex_set_wpa_ie_helper(struct mwifiex_private *priv,
 		memcpy(priv->wpa_ie, ie_data_ptr, ie_len);
 		priv->wpa_ie_len = (u8) ie_len;
 		dev_dbg(priv->adapter->dev, "cmd: Set Wpa_ie_len=%d IE=%#x\n",
-				priv->wpa_ie_len, priv->wpa_ie[0]);
+			priv->wpa_ie_len, priv->wpa_ie[0]);
 
 		if (priv->wpa_ie[0] == WLAN_EID_WPA) {
 			priv->sec_info.wpa_enabled = true;
@@ -979,7 +980,7 @@ static int mwifiex_set_wapi_ie(struct mwifiex_private *priv,
 		memcpy(priv->wapi_ie, ie_data_ptr, ie_len);
 		priv->wapi_ie_len = ie_len;
 		dev_dbg(priv->adapter->dev, "cmd: Set wapi_ie_len=%d IE=%#x\n",
-				priv->wapi_ie_len, priv->wapi_ie[0]);
+			priv->wapi_ie_len, priv->wapi_ie[0]);
 
 		if (priv->wapi_ie[0] == WLAN_EID_BSS_AC_ACCESS_DELAY)
 			priv->sec_info.wapi_enabled = true;
@@ -1005,8 +1006,8 @@ static int mwifiex_sec_ioctl_set_wapi_key(struct mwifiex_private *priv,
 {
 
 	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
-				    HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
-				    encrypt_key);
+				     HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
+				     encrypt_key);
 }
 
 /*
@@ -1100,9 +1101,9 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_private *priv,
 		/* Send the key as PTK to firmware */
 		encrypt_key->key_index = MWIFIEX_KEY_INDEX_UNICAST;
 		ret = mwifiex_send_cmd_async(priv,
-					HostCmd_CMD_802_11_KEY_MATERIAL,
-					HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
-					encrypt_key);
+					     HostCmd_CMD_802_11_KEY_MATERIAL,
+					     HostCmd_ACT_GEN_SET,
+					     KEY_INFO_ENABLED, encrypt_key);
 		if (ret)
 			return ret;
 
@@ -1127,14 +1128,14 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_private *priv,
 
 	if (remove_key)
 		ret = mwifiex_send_cmd_sync(priv,
-				       HostCmd_CMD_802_11_KEY_MATERIAL,
-				       HostCmd_ACT_GEN_SET, !(KEY_INFO_ENABLED),
-				       encrypt_key);
+					    HostCmd_CMD_802_11_KEY_MATERIAL,
+					    HostCmd_ACT_GEN_SET,
+					    !KEY_INFO_ENABLED, encrypt_key);
 	else
 		ret = mwifiex_send_cmd_sync(priv,
-					HostCmd_CMD_802_11_KEY_MATERIAL,
-					HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
-					encrypt_key);
+					    HostCmd_CMD_802_11_KEY_MATERIAL,
+					    HostCmd_ACT_GEN_SET,
+					    KEY_INFO_ENABLED, encrypt_key);
 
 	return ret;
 }
@@ -1253,7 +1254,7 @@ mwifiex_get_ver_ext(struct mwifiex_private *priv)
 
 	memset(&ver_ext, 0, sizeof(struct host_cmd_ds_version_ext));
 	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_VERSION_EXT,
-				    HostCmd_ACT_GEN_GET, 0, &ver_ext))
+				  HostCmd_ACT_GEN_GET, 0, &ver_ext))
 		return -1;
 
 	return 0;
@@ -1270,7 +1271,7 @@ mwifiex_get_stats_info(struct mwifiex_private *priv,
 		       struct mwifiex_ds_get_stats *log)
 {
 	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_GET_LOG,
-				    HostCmd_ACT_GEN_GET, 0, log);
+				     HostCmd_ACT_GEN_GET, 0, log);
 }
 
 /*
@@ -1410,9 +1411,9 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 	}
 	pvendor_ie = (struct ieee_types_vendor_header *) ie_data_ptr;
 	/* Test to see if it is a WPA IE, if not, then it is a gen IE */
-	if (((pvendor_ie->element_id == WLAN_EID_WPA)
-	     && (!memcmp(pvendor_ie->oui, wpa_oui, sizeof(wpa_oui))))
-			|| (pvendor_ie->element_id == WLAN_EID_RSN)) {
+	if (((pvendor_ie->element_id == WLAN_EID_WPA) &&
+	     (!memcmp(pvendor_ie->oui, wpa_oui, sizeof(wpa_oui)))) ||
+	    (pvendor_ie->element_id == WLAN_EID_RSN)) {
 
 		/* IE is a WPA/WPA2 IE so call set_wpa function */
 		ret = mwifiex_set_wpa_ie_helper(priv, ie_data_ptr, ie_len);
@@ -1435,9 +1436,8 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 		 * wps session flag
 		 */
 		pvendor_ie = (struct ieee_types_vendor_header *) ie_data_ptr;
-		if ((pvendor_ie->element_id == WLAN_EID_VENDOR_SPECIFIC)
-				&& (!memcmp(pvendor_ie->oui, wps_oui,
-						sizeof(wps_oui)))) {
+		if ((pvendor_ie->element_id == WLAN_EID_VENDOR_SPECIFIC) &&
+		    (!memcmp(pvendor_ie->oui, wps_oui, sizeof(wps_oui)))) {
 			priv->wps.session_enable = true;
 			dev_dbg(priv->adapter->dev,
 				"info: WPS Session Enabled.\n");
@@ -1446,7 +1446,7 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 		/* Append the passed data to the end of the
 		   genIeBuffer */
 		memcpy(priv->gen_ie_buf + priv->gen_ie_buf_len, ie_data_ptr,
-									ie_len);
+		       ie_len);
 		/* Increment the stored buffer length by the
 		   size passed */
 		priv->gen_ie_buf_len += ie_len;
@@ -1490,7 +1490,7 @@ static int mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
 			return -1;
 		} else {
 			memcpy(adapter->arp_filter, gen_ie->ie_data,
-								gen_ie->len);
+			       gen_ie->len);
 			adapter->arp_filter_size = gen_ie->len;
 		}
 		break;
-- 
1.7.0.2

