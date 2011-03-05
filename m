Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:46497 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1CEGkq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2011 01:40:46 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: remove or add braces where applicable
Date: Fri,  4 Mar 2011 22:43:40 -0800
Message-Id: <1299307420-10089-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marc Yang <yangyang@marvell.com>

coding style changes

Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           |    9 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   10 +-
 drivers/net/wireless/mwifiex/cfg80211.c      |    3 +-
 drivers/net/wireless/mwifiex/cfp.c           |    8 +-
 drivers/net/wireless/mwifiex/cmdevt.c        |   19 ++--
 drivers/net/wireless/mwifiex/debugfs.c       |   11 +-
 drivers/net/wireless/mwifiex/join.c          |    6 +-
 drivers/net/wireless/mwifiex/scan.c          |  172 +++++++++-----------------
 drivers/net/wireless/mwifiex/sdio.c          |   38 +++----
 drivers/net/wireless/mwifiex/sdio.h          |   16 +--
 drivers/net/wireless/mwifiex/sta_cmd.c       |   20 ++--
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |   23 ++--
 drivers/net/wireless/mwifiex/sta_ioctl.c     |   57 +++------
 drivers/net/wireless/mwifiex/sta_tx.c        |    3 +-
 drivers/net/wireless/mwifiex/wmm.c           |   18 +--
 15 files changed, 152 insertions(+), 261 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index ffc005a..9076ef8 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -524,10 +524,9 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 		mwifiex_11n_delete_ba_stream_tbl(priv, tid,
 						add_ba_rsp->peer_mac_addr,
 						TYPE_DELBA_SENT, true);
-		if (add_ba_rsp->add_rsp_result != BA_RESULT_TIMEOUT) {
+		if (add_ba_rsp->add_rsp_result != BA_RESULT_TIMEOUT)
 			priv->aggr_prio_tbl[tid].ampdu_ap =
 				BA_STREAM_NOT_ALLOWED;
-		}
 	}
 
 	return 0;
@@ -732,9 +731,8 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 			if (!ISSUPP_CHANWIDTH40
 			    (priv->adapter->hw_dot_11n_dev_cap)
 			    || !ISSUPP_CHANWIDTH40(priv->adapter->
-						   usr_dot_11n_dev_cap)) {
+						   usr_dot_11n_dev_cap))
 				RESET_CHANWIDTH40(ht_info->ht_info.ht_param);
-			}
 
 			*buffer += sizeof(struct mwifiex_ie_types_htinfo);
 			ret_len += sizeof(struct mwifiex_ie_types_htinfo);
@@ -903,10 +901,9 @@ mwifiex_11n_delete_all_tx_ba_stream_tbl(struct mwifiex_private *priv)
 
 	INIT_LIST_HEAD(&priv->tx_ba_stream_tbl_ptr);
 
-	for (i = 0; i < MAX_NUM_TID; ++i) {
+	for (i = 0; i < MAX_NUM_TID; ++i)
 		priv->aggr_prio_tbl[i].ampdu_ap =
 			priv->aggr_prio_tbl[i].ampdu_user;
-	}
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index ef9b4f4..f2ee1d6 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -202,12 +202,10 @@ mwifiex_11n_find_last_seq_num(struct mwifiex_rx_reorder_tbl *rx_reorder_tbl_ptr)
 {
 	int i;
 
-	for (i = (rx_reorder_tbl_ptr->win_size - 1); i >= 0; --i) {
+	for (i = (rx_reorder_tbl_ptr->win_size - 1); i >= 0; --i)
 		if (rx_reorder_tbl_ptr->rx_reorder_ptr[i])
 			return i;
 
-	}
-
 	return -1;
 }
 
@@ -260,9 +258,10 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 	 * the packets and move the window size until the ssn
 	 */
 	rx_reor_tbl_ptr = mwifiex_11n_get_rx_reorder_tbl(priv, tid, ta);
-	if (rx_reor_tbl_ptr)
+	if (rx_reor_tbl_ptr) {
 		mwifiex_11n_dispatch_pkt_until_start_win(priv, rx_reor_tbl_ptr,
 							 seq_num);
+	}
 	else {
 		new_node = kzalloc(sizeof(struct mwifiex_rx_reorder_tbl),
 						GFP_KERNEL);
@@ -449,8 +448,9 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 		mwifiex_11n_get_rx_reorder_tbl((struct mwifiex_private *) priv,
 						tid, ta);
 	if (!rx_reor_tbl_ptr) {
-		if (pkt_type == PKT_TYPE_BAR)
+		if (pkt_type == PKT_TYPE_BAR) {
 			return ret;
+		}
 		else {
 			mwifiex_11n_dispatch_pkt(priv, payload);
 			return ret;
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 1e1b397..049eb59 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1062,11 +1062,10 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	/* disconnect before try to associate */
 	mwifiex_disconnect(priv, MWIFIEX_IOCTL_WAIT, NULL);
 
-	if (channel) {
+	if (channel)
 		ret = mwifiex_set_rf_channel(priv, channel,
 				mwifiex_channels_to_cfg80211_channel_type
 				(priv->adapter->chan_offset));
-	}
 
 	/* reset eWPA mode */
 	priv->sec_info.ewpa_enabled = false;
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index f337af5..017b0b9 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -152,13 +152,12 @@ mwifiex_get_active_data_rates(struct mwifiex_private *priv, u8 *rates)
 {
 	u32 k;
 
-	if (!priv->media_connected) {
+	if (!priv->media_connected)
 		k = mwifiex_get_supported_rates(priv, rates);
-	} else {
+	else
 		k = mwifiex_copy_rates(rates, 0,
 				       priv->curr_bss_params.data_rates,
 				       priv->curr_bss_params.num_of_rates);
-	}
 
 	return k;
 }
@@ -278,10 +277,9 @@ mwifiex_get_rate_index(struct mwifiex_adapter *adapter, u16 *rate_bitmap,
 {
 	int i;
 
-	for (i = 0; i < size * 8; i++) {
+	for (i = 0; i < size * 8; i++)
 		if (rate_bitmap[i / 16] & (1 << (i % 16)))
 			return i;
-	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 41b5d87..6a5da48 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -278,13 +278,12 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 		if (GET_BSS_ROLE(mwifiex_get_priv(adapter,
 				 MWIFIEX_BSS_ROLE_ANY))
 				 == MWIFIEX_BSS_ROLE_STA) {
-			if (!sleep_cfm_buf->ps_cfm_sleep.sleep_cfm.resp_ctrl) {
+			if (!sleep_cfm_buf->ps_cfm_sleep.sleep_cfm.resp_ctrl)
 				/* Response is not needed for sleep
 				   confirm command */
 				adapter->ps_state = PS_STATE_SLEEP;
-			} else {
+			else
 				adapter->ps_state = PS_STATE_SLEEP_CFM;
-			}
 
 			if (!sleep_cfm_buf->ps_cfm_sleep.sleep_cfm.resp_ctrl
 			    && (adapter->is_hs_configured &&
@@ -1057,15 +1056,14 @@ void
 mwifiex_check_ps_cond(struct mwifiex_adapter *adapter)
 {
 	if (!adapter->cmd_sent &&
-	    !adapter->curr_cmd && !IS_CARD_RX_RCVD(adapter)) {
+	    !adapter->curr_cmd && !IS_CARD_RX_RCVD(adapter))
 		mwifiex_dnld_sleep_confirm_cmd(adapter);
-	} else {
+	else
 		dev_dbg(adapter->dev,
 			"cmd: Delay Sleep Confirm (%s%s%s)\n",
 		       (adapter->cmd_sent) ? "D" : "",
 		       (adapter->curr_cmd) ? "C" : "",
 		       (IS_CARD_RX_RCVD(adapter)) ? "R" : "");
-	}
 }
 
 /*
@@ -1214,12 +1212,11 @@ mwifiex_process_sleep_confirm_resp(struct mwifiex_adapter *adapter,
 		return;
 	}
 	adapter->pm_wakeup_card_req = true;
-	if (adapter->is_hs_configured) {
+	if (adapter->is_hs_configured)
 		mwifiex_hs_activated_event(mwifiex_get_priv
 						   (adapter,
 						    MWIFIEX_BSS_ROLE_ANY),
 						   true);
-	}
 	adapter->ps_state = PS_STATE_SLEEP;
 	cmd->command = cpu_to_le16(command);
 	cmd->seq_num = cpu_to_le16(seq_num);
@@ -1456,8 +1453,9 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 		if (adapter->fw_bands & BAND_AN) {
 			adapter->adhoc_start_band = BAND_A | BAND_AN;
 			adapter->adhoc_11n_enabled = true;
-		} else
+		} else {
 			adapter->adhoc_start_band = BAND_A;
+		}
 		priv->adhoc_channel = DEFAULT_AD_HOC_CHANNEL_A;
 	} else if (adapter->fw_bands & BAND_GN) {
 		adapter->adhoc_start_band = BAND_G | BAND_B | BAND_GN;
@@ -1488,11 +1486,10 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 
 	adapter->region_code = le16_to_cpu(hw_spec->region_code);
 
-	for (i = 0; i < MWIFIEX_MAX_REGION_CODE; i++) {
+	for (i = 0; i < MWIFIEX_MAX_REGION_CODE; i++)
 		/* Use the region code to search for the index */
 		if (adapter->region_code == region_code_index[i])
 			break;
-	}
 
 	/* If it's unidentified region code, use the default (USA) */
 	if (i >= MWIFIEX_MAX_REGION_CODE) {
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 35011ea..9a53364 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -450,7 +450,7 @@ mwifiex_debug_read(struct file *file, char __user *ubuf,
 
 	if (info.tx_tbl_num) {
 		p += sprintf(p, "Tx BA stream table:\n");
-		for (i = 0; i < info.tx_tbl_num; i++) {
+		for (i = 0; i < info.tx_tbl_num; i++)
 			p += sprintf(p, "tid = %d, "
 				     "ra = %02x:%02x:%02x:%02x:%02x:%02x\n",
 				     info.tx_tbl[i].tid,
@@ -458,7 +458,6 @@ mwifiex_debug_read(struct file *file, char __user *ubuf,
 				     info.tx_tbl[i].ra[2], info.tx_tbl[i].ra[3],
 				     info.tx_tbl[i].ra[4],
 				     info.tx_tbl[i].ra[5]);
-		}
 	}
 
 	if (info.rx_tbl_num) {
@@ -711,13 +710,13 @@ mwifiex_hscfg_write(struct file *file,
 		goto done;
 	}
 
-	if (cond == HOST_SLEEP_CFG_CANCEL)
+	if (cond == HOST_SLEEP_CFG_CANCEL) {
 		ret = mwifiex_cancel_hs(priv, MWIFIEX_IOCTL_WAIT);
-	else if (action == 1)
+	} else if (action == 1) {
 		ret = mwifiex_set_hs_cfg(priv, cond, gap, ret, true);
-	else if (action == 0)
+	} else if (action == 0) {
 		ret = mwifiex_set_hs_cfg(priv, cond, gap, ret, false);
-	else {
+	} else {
 		ret = -EINVAL;
 		dev_err(priv->adapter->dev, "invalid action argument %d\n",
 							action);
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 4294914..49d1747 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -245,9 +245,8 @@ mwifiex_update_tsf_timestamps(struct mwifiex_private *priv,
 	       new_bss_desc->network_tsf, new_tsf_base);
 
 	for (table_idx = 0; table_idx < adapter->num_in_scan_table;
-	     table_idx++) {
+	     table_idx++)
 		adapter->scan_table[table_idx].network_tsf += tsf_delta;
-	}
 }
 
 /*
@@ -1588,11 +1587,10 @@ int mwifiex_deauthenticate(struct mwifiex_private *priv,
 					       curr_bss_params.bss_descriptor.
 					       mac_address,
 					       MWIFIEX_MAC_ADDR_LENGTH);
-				else {
+				else
 					memcpy((u8 *) &mac_address,
 					       (u8 *) mac,
 					       MWIFIEX_MAC_ADDR_LENGTH);
-				}
 			} else {
 				memcpy((u8 *) &mac_address,
 				       (u8 *) &priv->curr_bss_params.
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 2e33588..aa339db 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -97,13 +97,11 @@ mwifiex_search_oui_in_ie(struct ie_body *iebody, u8 *oui)
 		if (!memcmp(iebody->ptk_body, oui, sizeof(iebody->ptk_body)))
 			return MWIFIEX_OUI_PRESENT;
 
-
 		--count;
-		if (count) {
+		if (count)
 			iebody =
 				(struct ie_body *) ((u8 *) iebody +
 						sizeof(iebody->ptk_body));
-		}
 	}
 
 	pr_debug("info: %s: OUI is not found in PTK\n", __func__);
@@ -298,16 +296,15 @@ int mwifiex_request_scan(struct mwifiex_private *priv, u8 wait_option,
 		goto done;
 	}
 
-	if (req_ssid && req_ssid->ssid_len != 0) {
+	if (req_ssid && req_ssid->ssid_len != 0)
 		/* Specific SSID scan */
 		status = mwifiex_scan_specific_ssid(priv, wait,
 						    HostCmd_ACT_GEN_SET,
 						    req_ssid, NULL);
-	} else {
+	else
 		/* Normal scan */
 		status = mwifiex_scan_networks(priv, wait, HostCmd_ACT_GEN_SET,
 					       NULL, NULL);
-	}
 	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
 	if (status == -1)
 		ret = -1;
@@ -667,19 +664,18 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
 			scan_chan_list[chan_idx].radio_type = band;
 			scan_type = ch->flags & IEEE80211_CHAN_PASSIVE_SCAN;
 			if (user_scan_in &&
-				user_scan_in->chan_list[0].scan_time) {
+				user_scan_in->chan_list[0].scan_time)
 				scan_chan_list[chan_idx].max_scan_time =
 					cpu_to_le16((u16) user_scan_in->
 					chan_list[0].scan_time);
-			} else if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE) {
+			else if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE)
 				scan_chan_list[chan_idx].max_scan_time =
 					cpu_to_le16(adapter->
 							passive_scan_time);
-			} else {
+			else
 				scan_chan_list[chan_idx].max_scan_time =
 					cpu_to_le16(adapter->
 							active_scan_time);
-			}
 			if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE)
 				scan_chan_list[chan_idx].chan_scan_mode_bitmap
 					|= MWIFIEX_PASSIVE_SCAN;
@@ -817,9 +813,8 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 			if (!filtered_scan
 			    && (tmp_chan_list->chan_number == 1
 				|| tmp_chan_list->chan_number == 6
-				|| tmp_chan_list->chan_number == 11)) {
+				|| tmp_chan_list->chan_number == 11))
 				done_early = true;
-			}
 
 			/* Increment the tmp pointer to the next channel to
 			   be scanned */
@@ -831,9 +826,8 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 			if (!filtered_scan
 			    && (tmp_chan_list->chan_number == 1
 				|| tmp_chan_list->chan_number == 6
-				|| tmp_chan_list->chan_number == 11)) {
+				|| tmp_chan_list->chan_number == 11))
 				done_early = true;
-			}
 		}
 
 		/* The total scan time should be less than scan command timeout
@@ -1016,10 +1010,8 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 		 */
 		if ((ssid_idx && ssid_filter)
 		    || memcmp(scan_cfg_out->specific_bssid, &zero_mac,
-			      sizeof(zero_mac))) {
+			      sizeof(zero_mac)))
 			*filtered_scan = true;
-		}
-
 	} else {
 		scan_cfg_out->bss_mode = (u8) adapter->scan_mode;
 		num_probes = adapter->scan_probes;
@@ -1111,29 +1103,27 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 			scan_type =
 				user_scan_in->chan_list[chan_idx].scan_type;
 
-			if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE) {
+			if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE)
 				(scan_chan_list +
 				 chan_idx)->chan_scan_mode_bitmap
 					|= MWIFIEX_PASSIVE_SCAN;
-			} else {
+			else
 				(scan_chan_list +
 				 chan_idx)->chan_scan_mode_bitmap
 					&= ~MWIFIEX_PASSIVE_SCAN;
-			}
 
 			if (user_scan_in->chan_list[chan_idx].scan_time) {
 				scan_dur =
 					(u16) user_scan_in->
 					chan_list[chan_idx].scan_time;
 			} else {
-				if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE) {
+				if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE)
 					scan_dur = adapter->passive_scan_time;
-				} else if (*filtered_scan) {
+				else if (*filtered_scan)
 					scan_dur =
 						adapter->specific_scan_time;
-				} else {
+				else
 					scan_dur = adapter->active_scan_time;
-				}
 			}
 
 			(scan_chan_list + chan_idx)->min_scan_time =
@@ -1459,13 +1449,12 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			 */
 			if (found_data_rate_ie) {
 				if ((element_len + rate_size) >
-				    MWIFIEX_SUPPORTED_RATES) {
+				    MWIFIEX_SUPPORTED_RATES)
 					bytes_to_copy =
 						(MWIFIEX_SUPPORTED_RATES -
 						 rate_size);
-				} else {
+				else
 					bytes_to_copy = element_len;
-				}
 
 				rate = (u8 *) bss_entry->data_rates;
 				rate += rate_size;
@@ -1497,8 +1486,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				if (total_ie_len ==
 				    sizeof(struct ieee_types_wmm_parameter)
 				    || total_ie_len ==
-				    sizeof(struct ieee_types_wmm_info)) {
-
+				    sizeof(struct ieee_types_wmm_info))
 					/*
 					 * Only accept and copy the WMM IE if
 					 * it matches the size expected for the
@@ -1506,7 +1494,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 					 */
 					memcpy((u8 *) &bss_entry->wmm_ie,
 					       current_ptr, total_ie_len);
-				}
 			}
 			break;
 		case WLAN_EID_RSN:
@@ -1622,55 +1609,47 @@ mwifiex_adjust_beacon_buffer_ptrs(struct mwifiex_private *priv,
 				adapter->scan_table[adj_idx].beacon_buf -=
 					rem_bcn_size;
 
-			if (adapter->scan_table[adj_idx].bcn_wpa_ie) {
+			if (adapter->scan_table[adj_idx].bcn_wpa_ie)
 				adapter->scan_table[adj_idx].bcn_wpa_ie =
 				(struct ieee_types_vendor_specific *)
 				(adapter->scan_table[adj_idx].beacon_buf +
 				 adapter->scan_table[adj_idx].wpa_offset);
-			}
-			if (adapter->scan_table[adj_idx].bcn_rsn_ie) {
+			if (adapter->scan_table[adj_idx].bcn_rsn_ie)
 				adapter->scan_table[adj_idx].bcn_rsn_ie =
 				(struct ieee_types_generic *)
 				(adapter->scan_table[adj_idx].beacon_buf +
 				 adapter->scan_table[adj_idx].rsn_offset);
-			}
-			if (adapter->scan_table[adj_idx].bcn_wapi_ie) {
+			if (adapter->scan_table[adj_idx].bcn_wapi_ie)
 				adapter->scan_table[adj_idx].bcn_wapi_ie =
 				(struct ieee_types_generic *)
 				(adapter->scan_table[adj_idx].beacon_buf +
 				 adapter->scan_table[adj_idx].wapi_offset);
-			}
-			if (adapter->scan_table[adj_idx].bcn_ht_cap) {
+			if (adapter->scan_table[adj_idx].bcn_ht_cap)
 				adapter->scan_table[adj_idx].bcn_ht_cap =
 				(struct ieee80211_ht_cap *)
 				(adapter->scan_table[adj_idx].beacon_buf +
 				 adapter->scan_table[adj_idx].ht_cap_offset);
-			}
 
-			if (adapter->scan_table[adj_idx].bcn_ht_info) {
+			if (adapter->scan_table[adj_idx].bcn_ht_info)
 				adapter->scan_table[adj_idx].bcn_ht_info =
 				(struct ieee80211_ht_info *)
 				(adapter->scan_table[adj_idx].beacon_buf +
 				 adapter->scan_table[adj_idx].ht_info_offset);
-			}
-			if (adapter->scan_table[adj_idx].bcn_bss_co_2040) {
+			if (adapter->scan_table[adj_idx].bcn_bss_co_2040)
 				adapter->scan_table[adj_idx].bcn_bss_co_2040 =
 				(u8 *)
 				(adapter->scan_table[adj_idx].beacon_buf +
 			       adapter->scan_table[adj_idx].bss_co_2040_offset);
-			}
-			if (adapter->scan_table[adj_idx].bcn_ext_cap) {
+			if (adapter->scan_table[adj_idx].bcn_ext_cap)
 				adapter->scan_table[adj_idx].bcn_ext_cap =
 				(u8 *)
 				(adapter->scan_table[adj_idx].beacon_buf +
 				 adapter->scan_table[adj_idx].ext_cap_offset);
-			}
-			if (adapter->scan_table[adj_idx].bcn_obss_scan) {
+			if (adapter->scan_table[adj_idx].bcn_obss_scan)
 				adapter->scan_table[adj_idx].bcn_obss_scan =
 				(struct ieee_types_obss_scan_param *)
 				(adapter->scan_table[adj_idx].beacon_buf +
 			       adapter->scan_table[adj_idx].overlap_bss_offset);
-			}
 		}
 	}
 }
@@ -1892,50 +1871,41 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 		}
 		/* Point the new entry to its permanent storage space */
 		new_beacon->beacon_buf = bcn_store;
-		if (new_beacon->bcn_wpa_ie) {
+		if (new_beacon->bcn_wpa_ie)
 			new_beacon->bcn_wpa_ie =
 				(struct ieee_types_vendor_specific *)
 				(new_beacon->beacon_buf +
 				 new_beacon->wpa_offset);
-		}
-		if (new_beacon->bcn_rsn_ie) {
+		if (new_beacon->bcn_rsn_ie)
 			new_beacon->bcn_rsn_ie = (struct ieee_types_generic *)
 				(new_beacon->beacon_buf +
 				 new_beacon->rsn_offset);
-		}
-		if (new_beacon->bcn_wapi_ie) {
+		if (new_beacon->bcn_wapi_ie)
 			new_beacon->bcn_wapi_ie = (struct ieee_types_generic *)
 				(new_beacon->beacon_buf +
 				 new_beacon->wapi_offset);
-		}
-		if (new_beacon->bcn_ht_cap) {
+		if (new_beacon->bcn_ht_cap)
 			new_beacon->bcn_ht_cap = (struct ieee80211_ht_cap *)
 				(new_beacon->beacon_buf +
 				 new_beacon->ht_cap_offset);
-		}
 
-		if (new_beacon->bcn_ht_info) {
+		if (new_beacon->bcn_ht_info)
 			new_beacon->bcn_ht_info = (struct ieee80211_ht_info *)
 				(new_beacon->beacon_buf +
 				 new_beacon->ht_info_offset);
-		}
-		if (new_beacon->bcn_bss_co_2040) {
+		if (new_beacon->bcn_bss_co_2040)
 			new_beacon->bcn_bss_co_2040 = (u8 *)
 				(new_beacon->beacon_buf +
 				 new_beacon->bss_co_2040_offset);
-		}
-		if (new_beacon->bcn_ext_cap) {
+		if (new_beacon->bcn_ext_cap)
 			new_beacon->bcn_ext_cap = (u8 *)
 				(new_beacon->beacon_buf +
 				 new_beacon->ext_cap_offset);
-		}
-		if (new_beacon->bcn_obss_scan) {
+		if (new_beacon->bcn_obss_scan)
 			new_beacon->bcn_obss_scan =
 				(struct ieee_types_obss_scan_param *)
 				(new_beacon->beacon_buf +
 				 new_beacon->overlap_bss_offset);
-		}
-
 	} else {
 		/*
 		 * No existing beacon data exists for this entry, check to see
@@ -1961,53 +1931,45 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 				(new_beacon->beacon_buf_size +
 				 SCAN_BEACON_ENTRY_PAD);
 
-			if (new_beacon->bcn_wpa_ie) {
+			if (new_beacon->bcn_wpa_ie)
 				new_beacon->bcn_wpa_ie =
 					(struct ieee_types_vendor_specific *)
 					(new_beacon->beacon_buf +
 					 new_beacon->wpa_offset);
-			}
-			if (new_beacon->bcn_rsn_ie) {
+			if (new_beacon->bcn_rsn_ie)
 				new_beacon->bcn_rsn_ie =
 					(struct ieee_types_generic *)
 					(new_beacon->beacon_buf +
 					 new_beacon->rsn_offset);
-			}
-			if (new_beacon->bcn_wapi_ie) {
+			if (new_beacon->bcn_wapi_ie)
 				new_beacon->bcn_wapi_ie =
 					(struct ieee_types_generic *)
 					(new_beacon->beacon_buf +
 					 new_beacon->wapi_offset);
-			}
-			if (new_beacon->bcn_ht_cap) {
+			if (new_beacon->bcn_ht_cap)
 				new_beacon->bcn_ht_cap =
 					(struct ieee80211_ht_cap *)
 					(new_beacon->beacon_buf +
 					 new_beacon->ht_cap_offset);
-			}
 
-			if (new_beacon->bcn_ht_info) {
+			if (new_beacon->bcn_ht_info)
 				new_beacon->bcn_ht_info =
 					(struct ieee80211_ht_info *)
 					(new_beacon->beacon_buf +
 					 new_beacon->ht_info_offset);
-			}
-			if (new_beacon->bcn_bss_co_2040) {
+			if (new_beacon->bcn_bss_co_2040)
 				new_beacon->bcn_bss_co_2040 =
 					(u8 *) (new_beacon->beacon_buf +
 					 new_beacon->bss_co_2040_offset);
-			}
-			if (new_beacon->bcn_ext_cap) {
+			if (new_beacon->bcn_ext_cap)
 				new_beacon->bcn_ext_cap =
 					(u8 *) (new_beacon->beacon_buf +
 					 new_beacon->ext_cap_offset);
-			}
-			if (new_beacon->bcn_obss_scan) {
+			if (new_beacon->bcn_obss_scan)
 				new_beacon->bcn_obss_scan =
 					(struct ieee_types_obss_scan_param *)
 					(new_beacon->beacon_buf +
 					 new_beacon->overlap_bss_offset);
-			}
 
 			/* Increment the end pointer by the size reserved */
 			adapter->bcn_buf_end +=
@@ -2240,67 +2202,58 @@ mwifiex_scan_delete_table_entry(struct mwifiex_private *priv, s32 table_idx)
 		if (adapter->scan_table[del_idx].beacon_buf) {
 			adapter->scan_table[del_idx].beacon_buf -=
 				beacon_buf_adj;
-			if (adapter->scan_table[del_idx].bcn_wpa_ie) {
+			if (adapter->scan_table[del_idx].bcn_wpa_ie)
 				adapter->scan_table[del_idx].bcn_wpa_ie =
 					(struct ieee_types_vendor_specific *)
 					(adapter->scan_table[del_idx].
 					 beacon_buf +
 					 adapter->scan_table[del_idx].
 					 wpa_offset);
-			}
-			if (adapter->scan_table[del_idx].bcn_rsn_ie) {
+			if (adapter->scan_table[del_idx].bcn_rsn_ie)
 				adapter->scan_table[del_idx].bcn_rsn_ie =
 					(struct ieee_types_generic *)
 					(adapter->scan_table[del_idx].
 					 beacon_buf +
 					 adapter->scan_table[del_idx].
 					 rsn_offset);
-			}
-			if (adapter->scan_table[del_idx].bcn_wapi_ie) {
+			if (adapter->scan_table[del_idx].bcn_wapi_ie)
 				adapter->scan_table[del_idx].bcn_wapi_ie =
 					(struct ieee_types_generic *)
 					(adapter->scan_table[del_idx].beacon_buf
 					 + adapter->scan_table[del_idx].
 					 wapi_offset);
-			}
-			if (adapter->scan_table[del_idx].bcn_ht_cap) {
+			if (adapter->scan_table[del_idx].bcn_ht_cap)
 				adapter->scan_table[del_idx].bcn_ht_cap =
 					(struct ieee80211_ht_cap *)
 					(adapter->scan_table[del_idx].beacon_buf
 					 + adapter->scan_table[del_idx].
 					  ht_cap_offset);
-			}
 
-			if (adapter->scan_table[del_idx].bcn_ht_info) {
+			if (adapter->scan_table[del_idx].bcn_ht_info)
 				adapter->scan_table[del_idx].bcn_ht_info =
 					(struct ieee80211_ht_info *)
 					(adapter->scan_table[del_idx].beacon_buf
 					 + adapter->scan_table[del_idx].
 					  ht_info_offset);
-			}
-			if (adapter->scan_table[del_idx].bcn_bss_co_2040) {
+			if (adapter->scan_table[del_idx].bcn_bss_co_2040)
 				adapter->scan_table[del_idx].bcn_bss_co_2040 =
 					(u8 *)
 					(adapter->scan_table[del_idx].beacon_buf
 					 + adapter->scan_table[del_idx].
 					   bss_co_2040_offset);
-			}
-			if (adapter->scan_table[del_idx].bcn_ext_cap) {
+			if (adapter->scan_table[del_idx].bcn_ext_cap)
 				adapter->scan_table[del_idx].bcn_ext_cap =
 					(u8 *)
 					(adapter->scan_table[del_idx].beacon_buf
 					 + adapter->scan_table[del_idx].
 					     ext_cap_offset);
-			}
-			if (adapter->scan_table[del_idx].bcn_obss_scan) {
+			if (adapter->scan_table[del_idx].bcn_obss_scan)
 				adapter->scan_table[del_idx].
 					bcn_obss_scan =
 					(struct ieee_types_obss_scan_param *)
 					(adapter->scan_table[del_idx].beacon_buf
 					 + adapter->scan_table[del_idx].
 					     overlap_bss_offset);
-			}
-
 		}
 	}
 
@@ -2682,7 +2635,6 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 					bss_idx--;
 				else
 					num_in_table++;
-
 			}
 
 			/*
@@ -2886,7 +2838,6 @@ mwifiex_find_ssid_in_list(struct mwifiex_private *priv,
 				} else {
 					if (net == -1)
 						net = j;
-
 				}
 				break;
 			case MWIFIEX_BSS_MODE_AUTO:
@@ -3151,10 +3102,10 @@ mwifiex_save_curr_bcn(struct mwifiex_private *priv)
 
 		priv->curr_bcn_buf = kzalloc(curr_bss->beacon_buf_size,
 						GFP_KERNEL);
-		if (!priv->curr_bcn_buf)
+		if (!priv->curr_bcn_buf) {
 			dev_err(priv->adapter->dev,
 					"failed to alloc curr_bcn_buf\n");
-		else {
+		} else {
 			memcpy(priv->curr_bcn_buf, curr_bss->beacon_buf,
 			       curr_bss->beacon_buf_size);
 			dev_dbg(priv->adapter->dev,
@@ -3189,48 +3140,41 @@ mwifiex_restore_curr_bcn(struct mwifiex_private *priv)
 		adapter->bcn_buf_end += priv->curr_bcn_size;
 
 		/* adjust the pointers in the current BSS descriptor */
-		if (curr_bss->bcn_wpa_ie) {
+		if (curr_bss->bcn_wpa_ie)
 			curr_bss->bcn_wpa_ie =
 				(struct ieee_types_vendor_specific *)
 				(curr_bss->beacon_buf +
 				 curr_bss->wpa_offset);
-		}
 
-		if (curr_bss->bcn_rsn_ie) {
+		if (curr_bss->bcn_rsn_ie)
 			curr_bss->bcn_rsn_ie = (struct ieee_types_generic *)
 				(curr_bss->beacon_buf +
 				 curr_bss->rsn_offset);
-		}
 
-		if (curr_bss->bcn_ht_cap) {
+		if (curr_bss->bcn_ht_cap)
 			curr_bss->bcn_ht_cap = (struct ieee80211_ht_cap *)
 				(curr_bss->beacon_buf +
 				 curr_bss->ht_cap_offset);
-		}
 
-		if (curr_bss->bcn_ht_info) {
+		if (curr_bss->bcn_ht_info)
 			curr_bss->bcn_ht_info = (struct ieee80211_ht_info *)
 				(curr_bss->beacon_buf +
 				 curr_bss->ht_info_offset);
-		}
 
-		if (curr_bss->bcn_bss_co_2040) {
+		if (curr_bss->bcn_bss_co_2040)
 			curr_bss->bcn_bss_co_2040 =
 				(u8 *) (curr_bss->beacon_buf +
 				 curr_bss->bss_co_2040_offset);
-		}
 
-		if (curr_bss->bcn_ext_cap) {
+		if (curr_bss->bcn_ext_cap)
 			curr_bss->bcn_ext_cap = (u8 *) (curr_bss->beacon_buf +
 				 curr_bss->ext_cap_offset);
-		}
 
-		if (curr_bss->bcn_obss_scan) {
+		if (curr_bss->bcn_obss_scan)
 			curr_bss->bcn_obss_scan =
 				(struct ieee_types_obss_scan_param *)
 				(curr_bss->beacon_buf +
 				 curr_bss->overlap_bss_offset);
-		}
 
 		spin_unlock_irqrestore(&priv->curr_bcn_buf_lock, flags);
 
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 4201239..00158ff 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -405,17 +405,17 @@ static int mwifiex_init_sdio_ioport(struct mwifiex_adapter *adapter)
 	pr_debug("info: SDIO FUNC1 IO port: %#x\n", adapter->ioport);
 
 	/* Set Host interrupt reset to read to clear */
-	if (!mwifiex_read_reg(adapter, HOST_INT_RSR_REG, &reg)) {
+	if (!mwifiex_read_reg(adapter, HOST_INT_RSR_REG, &reg))
 		mwifiex_write_reg(adapter, HOST_INT_RSR_REG,
 				  reg | SDIO_INT_MASK);
-	} else
+	else
 		return -1;
 
 	/* Dnld/Upld ready set to auto reset */
-	if (!mwifiex_read_reg(adapter, CARD_MISC_CFG_REG, &reg)) {
+	if (!mwifiex_read_reg(adapter, CARD_MISC_CFG_REG, &reg))
 		mwifiex_write_reg(adapter, CARD_MISC_CFG_REG,
 				  reg | AUTO_RE_ENABLE_INT);
-	} else
+	else
 		return -1;
 
 	return 0;
@@ -732,9 +732,9 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			udelay(10);
 		}
 
-		if (!len)
+		if (!len) {
 			break;
-		else if (len > MWIFIEX_UPLD_SIZE) {
+		} else if (len > MWIFIEX_UPLD_SIZE) {
 			dev_err(adapter->dev, "FW download failed @ %d,"
 				" invalid length %d\n", offset, len);
 			ret = -1;
@@ -1028,16 +1028,14 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 
 		if (MP_RX_AGGR_IN_PROGRESS(card)) {
 			f_do_rx_aggr = 1;
-			if (MP_RX_AGGR_BUF_HAS_ROOM(card, skb->len)) {
+			if (MP_RX_AGGR_BUF_HAS_ROOM(card, skb->len))
 				f_aggr_cur = 1;
-			} else {
+			else
 				/* No room in Aggr buf, do rx aggr now */
 				f_do_rx_cur = 1;
-			}
 		} else {
 			f_do_rx_cur = 1;
 		}
-
 	}
 
 	if (f_aggr_cur) {
@@ -1052,7 +1050,6 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 			/* No more pkts allowed in Aggr buf, rx it */
 			f_do_rx_aggr = 1;
 		}
-
 	}
 
 	if (f_do_rx_aggr) {
@@ -1384,20 +1381,18 @@ int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 				if (!(card->mp_wr_bitmap &
 						(1 << card->curr_wr_port))
 						|| !MP_TX_AGGR_BUF_HAS_ROOM(
-							card, next_pkt_len)) {
+							card, next_pkt_len))
 					f_send_aggr_buf = 1;
-				}
 			} else {
 				/* No room in Aggr buf, send it */
 				f_send_aggr_buf = 1;
 
 				if (MP_TX_AGGR_PORT_LIMIT_REACHED(card) ||
 				    !(card->mp_wr_bitmap &
-				      (1 << card->curr_wr_port))) {
+				      (1 << card->curr_wr_port)))
 					f_send_cur_buf = 1;
-				} else {
+				else
 					f_postcopy_cur_buf = 1;
-				}
 			}
 		} else {
 			if (MP_TX_AGGR_BUF_HAS_ROOM(card, pkt_len)
@@ -1415,12 +1410,11 @@ int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 			/* some packs in Aggr buf already */
 			f_send_aggr_buf = 1;
 
-			if (MP_TX_AGGR_BUF_HAS_ROOM(card, pkt_len)) {
+			if (MP_TX_AGGR_BUF_HAS_ROOM(card, pkt_len))
 				f_precopy_cur_buf = 1;
-			} else {
+			else
 				/* No room in Aggr buf, send it */
 				f_send_cur_buf = 1;
-			}
 		} else {
 			f_send_cur_buf = 1;
 		}
@@ -1882,13 +1876,11 @@ mwifiex_sdio_cleanup_module(void)
 	if (adapter->is_suspended)
 		mwifiex_sdio_resume(adapter->dev);
 
-	for (i = 0; i < adapter->priv_num; i++) {
+	for (i = 0; i < adapter->priv_num; i++)
 		if ((GET_BSS_ROLE(adapter->priv[i]) == MWIFIEX_BSS_ROLE_STA) &&
-		    adapter->priv[i]->media_connected) {
+		    adapter->priv[i]->media_connected)
 			mwifiex_disconnect(adapter->priv[i], MWIFIEX_CMD_WAIT,
 					   NULL);
-		}
-	}
 
 	if (!adapter->surprise_removed)
 		mwifiex_shutdown_fw(mwifiex_get_priv
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index cf77d11..a5fffa3 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -185,15 +185,13 @@
 	memmove(&a->mpa_tx.buf[a->mpa_tx.buf_len], \
 			payload, pkt_len);				\
 	a->mpa_tx.buf_len += pkt_len;                        \
-	if (!a->mpa_tx.pkt_cnt) {                                     \
+	if (!a->mpa_tx.pkt_cnt)                                     \
 		a->mpa_tx.start_port = port;                            \
-	}                                                           \
-	if (a->mpa_tx.start_port <= port) {                             \
+	if (a->mpa_tx.start_port <= port)                             \
 		a->mpa_tx.ports |= (1<<(a->mpa_tx.pkt_cnt));		\
-	} else{                                                      \
+	else                                                     \
 		a->mpa_tx.ports |= (1<<(a->mpa_tx.pkt_cnt+1+(MAX_PORT - \
 						a->mp_end_port)));	\
-	}                                                           \
 	a->mpa_tx.pkt_cnt++;                                        \
 } while (0);
 
@@ -232,14 +230,12 @@
 /* Prepare to copy current packet from card to SDIO Rx aggregation buffer */
 #define MP_RX_AGGR_SETUP(a, skb, port) do {    \
 	a->mpa_rx.buf_len += skb->len;                       \
-	if (!a->mpa_rx.pkt_cnt) {                            \
+	if (!a->mpa_rx.pkt_cnt)                            \
 		a->mpa_rx.start_port = port;                   \
-	}                                                  \
-	if (a->mpa_rx.start_port <= port) {                    \
+	if (a->mpa_rx.start_port <= port)                    \
 		a->mpa_rx.ports |= (1<<(a->mpa_rx.pkt_cnt));   \
-	} else {                                             \
+	else                                             \
 		a->mpa_rx.ports |= (1<<(a->mpa_rx.pkt_cnt+1)); \
-	}                                                  \
 	a->mpa_rx.skb_arr[a->mpa_rx.pkt_cnt] = skb;      \
 	a->mpa_rx.len_arr[a->mpa_rx.pkt_cnt] = skb->len;     \
 	a->mpa_rx.pkt_cnt++;                               \
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index d73108f..f44427f 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -347,10 +347,9 @@ static int mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
 	struct host_cmd_ds_802_11_hs_cfg_enh *hs_cfg = &cmd->params.opt_hs_cfg;
 	u16 hs_activate = false;
 
-	if (data_buf == NULL) {
+	if (data_buf == NULL)
 		/* New Activate command */
 		hs_activate = true;
-	}
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_HS_CFG_ENH);
 
 	if (!hs_activate &&
@@ -368,12 +367,12 @@ static int mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
 			cpu_to_le16(adapter->arp_filter_size +
 				    sizeof(struct host_cmd_ds_802_11_hs_cfg_enh)
 				    + S_DS_GEN);
-	} else
+	} else {
 		cmd->size =
 			cpu_to_le16(S_DS_GEN +
 				    sizeof(struct
 					   host_cmd_ds_802_11_hs_cfg_enh));
-
+	}
 	if (hs_activate) {
 		hs_cfg->action = cpu_to_le16(HS_ACTIVATE);
 		hs_cfg->params.hs_activate.resp_ctrl = RESP_NEEDED;
@@ -414,10 +413,9 @@ static int mwifiex_cmd_802_11_mac_address(struct mwifiex_private *priv,
 
 	cmd->params.mac_addr.action = cpu_to_le16(cmd_action);
 
-	if (cmd_action == HostCmd_ACT_GEN_SET) {
+	if (cmd_action == HostCmd_ACT_GEN_SET)
 		memcpy(cmd->params.mac_addr.mac_addr, priv->curr_addr,
 		       MWIFIEX_MAC_ADDR_LENGTH);
-	}
 	return 0;
 }
 
@@ -655,11 +653,11 @@ static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 			/* set 0 when re-key */
 			key_material->key_param_set.key[1] = 0;
 
-		if (0 != memcmp(enc_key->mac_addr, bc_mac, sizeof(bc_mac)))
+		if (0 != memcmp(enc_key->mac_addr, bc_mac, sizeof(bc_mac))) {
 			/* WAPI pairwise key: unicast */
 			key_material->key_param_set.key_info |=
 				cpu_to_le16(KEY_INFO_WAPI_UNICAST);
-		else {	/* WAPI group key: multicast */
+		} else {	/* WAPI group key: multicast */
 			key_material->key_param_set.key_info |=
 				cpu_to_le16(KEY_INFO_WAPI_MCAST);
 			priv->sec_info.wapi_key_on = true;
@@ -958,11 +956,11 @@ static int mwifiex_cmd_802_11_rf_channel(struct mwifiex_private *priv,
 
 	if (cmd_action == HostCmd_ACT_GEN_SET) {
 		if ((priv->adapter->adhoc_start_band & BAND_A)
-		    || (priv->adapter->adhoc_start_band & BAND_AN)
-			)
+		    || (priv->adapter->adhoc_start_band & BAND_AN))
 			rf_chan->rf_type =
 				cpu_to_le16(HostCmd_SCAN_RADIO_TYPE_A);
-			rf_type = le16_to_cpu(rf_chan->rf_type);
+
+		rf_type = le16_to_cpu(rf_chan->rf_type);
 		SET_SECONDARYCHAN(rf_type,
 				  priv->adapter->chan_offset);
 		rf_chan->current_channel = cpu_to_le16(*((u16 *) data_buf));
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index ebd40b2..2ebd544 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -60,13 +60,13 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 			struct host_cmd_ds_802_11_ps_mode_enh *pm =
 				&resp->params.psmode_enh;
 			dev_err(adapter->dev, "PS_MODE_ENH cmd failed: "
-					"result=0x%x action=0x%X\n",
-					resp->result, le16_to_cpu(pm->action));
+				"result=0x%x action=0x%X\n",
+				resp->result, le16_to_cpu(pm->action));
 			/* We do not re-try enter-ps command in ad-hoc mode. */
 			if (le16_to_cpu(pm->action) == EN_AUTO_PS &&
-			    (le16_to_cpu(pm->params.auto_ps.ps_bitmap) &
-			     BITMAP_STA_PS)
-			    && priv->bss_mode == MWIFIEX_BSS_MODE_IBSS)
+				(le16_to_cpu(pm->params.auto_ps.ps_bitmap) &
+				 BITMAP_STA_PS)
+				&& priv->bss_mode == MWIFIEX_BSS_MODE_IBSS)
 				adapter->ps_mode =
 					MWIFIEX_802_11_POWER_MODE_CAM;
 		}
@@ -331,15 +331,13 @@ static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 
 	priv->is_data_rate_auto = mwifiex_is_rate_auto(priv);
 
-	if (priv->is_data_rate_auto) {
+	if (priv->is_data_rate_auto)
 		priv->data_rate = 0;
-	} else {
+	else
 		ret = mwifiex_prepare_cmd(priv,
 					  HostCmd_CMD_802_11_TX_RATE_QUERY,
 					  HostCmd_ACT_GEN_GET, 0, NULL, NULL);
 
-	}
-
 	if (data_buf) {
 		ds_rate = (struct mwifiex_rate_cfg *) data_buf;
 		if (le16_to_cpu(rate_cfg->action) == HostCmd_ACT_GEN_GET) {
@@ -568,11 +566,10 @@ static int mwifiex_ret_802_11_tx_rate_query(struct mwifiex_private *priv,
 
 	priv->tx_rate = resp->params.tx_rate.tx_rate;
 	priv->tx_htinfo = resp->params.tx_rate.ht_info;
-	if (!priv->is_data_rate_auto) {
+	if (!priv->is_data_rate_auto)
 		priv->data_rate =
 			mwifiex_index_to_data_rate(adapter, priv->tx_rate,
 						   priv->tx_htinfo);
-	}
 
 	return 0;
 }
@@ -592,9 +589,9 @@ static int mwifiex_ret_802_11_deauthenticate(struct mwifiex_private *priv,
 	adapter->dbg.num_cmd_deauth++;
 	if (!memcmp(resp->params.deauth.mac_addr,
 		    &priv->curr_bss_params.bss_descriptor.mac_address,
-		    sizeof(resp->params.deauth.mac_addr))) {
+		    sizeof(resp->params.deauth.mac_addr)))
 		mwifiex_reset_connect_state(priv);
-	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index a6f0c62..dd926f3 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -677,11 +677,9 @@ int mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *priv,
 				radio_cfg->adhoc_channel =
 					DEFAULT_AD_HOC_CHANNEL;
 				if ((adapter->adhoc_start_band & BAND_A)
-				    || (adapter->adhoc_start_band & BAND_AN)
-					) {
+				    || (adapter->adhoc_start_band & BAND_AN))
 					radio_cfg->adhoc_channel =
 						DEFAULT_AD_HOC_CHANNEL_A;
-				}
 			}
 		} else {	/* Retrurn error if adhoc_band and
 				   adhoc_channel combination is invalid */
@@ -692,12 +690,10 @@ int mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *priv,
 			priv->adhoc_channel = (u8) adhoc_channel;
 		}
 		if ((adhoc_band & BAND_GN)
-		    || (adhoc_band & BAND_AN)
-			) {
+		    || (adhoc_band & BAND_AN))
 			adapter->adhoc_11n_enabled = true;
-		} else {
+		else
 			adapter->adhoc_11n_enabled = false;
-		}
 	} else {
 		/* Infra Bands */
 		radio_cfg->config_bands = adapter->config_bands;
@@ -903,7 +899,6 @@ int mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
 						BAND_A | BAND_AN;
 				else
 					adapter->adhoc_start_band = BAND_A;
-
 			}
 		}
 	} else {
@@ -1005,15 +1000,14 @@ int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 			return ret;
 
 		/* Search for the requested SSID in the scan table */
-		if (ssid_bssid->ssid.ssid_len) {
+		if (ssid_bssid->ssid.ssid_len)
 			i = mwifiex_find_ssid_in_list(priv,
 						      &ssid_bssid->ssid, NULL,
 						      MWIFIEX_BSS_MODE_INFRA);
-		} else {
+		else
 			i = mwifiex_find_bssid_in_list(priv,
 						(u8 *) &ssid_bssid->bssid,
 						MWIFIEX_BSS_MODE_INFRA);
-		}
 
 		if (i >= 0) {
 			dev_dbg(adapter->dev,
@@ -1047,15 +1041,14 @@ int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 		priv->adhoc_is_link_sensed = false;
 
 		/* Search for the requested network in the scan table */
-		if (ssid_bssid->ssid.ssid_len) {
+		if (ssid_bssid->ssid.ssid_len)
 			i = mwifiex_find_ssid_in_list(priv,
 						      &ssid_bssid->ssid, NULL,
 						      MWIFIEX_BSS_MODE_IBSS);
-		} else {
+		else
 			i = mwifiex_find_bssid_in_list(priv,
 						       (u8 *)&ssid_bssid->bssid,
 						       MWIFIEX_BSS_MODE_IBSS);
-		}
 
 		if (i >= 0) {
 			dev_dbg(adapter->dev, "info: network found in scan"
@@ -1407,9 +1400,9 @@ static int mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
 
 		/* Only allow b/g rates to be set */
 		if (rate_index >= MWIFIEX_RATE_INDEX_HRDSSS0 &&
-		    rate_index <= MWIFIEX_RATE_INDEX_HRDSSS3)
+		    rate_index <= MWIFIEX_RATE_INDEX_HRDSSS3) {
 			bitmap_rates[0] = 1 << rate_index;
-		else {
+		} else {
 			rate_index -= 1; /* There is a 0x00 in the table */
 			if (rate_index >= MWIFIEX_RATE_INDEX_OFDM0 &&
 			    rate_index <= MWIFIEX_RATE_INDEX_OFDM7)
@@ -1673,11 +1666,10 @@ int mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *priv,
 		sub_cmd = (*ps_mode) ? EN_AUTO_PS : DIS_AUTO_PS;
 		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
 					  sub_cmd, BITMAP_STA_PS, wait, NULL);
-		if ((!ret) && (sub_cmd == DIS_AUTO_PS)) {
+		if ((!ret) && (sub_cmd == DIS_AUTO_PS))
 			ret = mwifiex_prepare_cmd(priv,
 					HostCmd_CMD_802_11_PS_MODE_ENH, GET_PS,
 					0, NULL, NULL);
-		}
 	} else {
 		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
 					  GET_PS, 0, wait, NULL);
@@ -1713,10 +1705,9 @@ int mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *priv,
 		}
 		if (hs_cfg->is_invoke_hostcmd) {
 			if (hs_cfg->conditions == HOST_SLEEP_CFG_CANCEL) {
-				if (!adapter->is_hs_configured) {
+				if (!adapter->is_hs_configured)
 					/* Already cancelled */
 					break;
-				}
 				/* Save previous condition */
 				prev_cond = le32_to_cpu(adapter->hs_cfg
 							.conditions);
@@ -1744,11 +1735,10 @@ int mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *priv,
 					0, wait, &adapter->hs_cfg);
 			if (!status)
 				status = -EINPROGRESS;
-			if (hs_cfg->conditions == HOST_SLEEP_CFG_CANCEL) {
+			if (hs_cfg->conditions == HOST_SLEEP_CFG_CANCEL)
 				/* Restore previous condition */
 				adapter->hs_cfg.conditions =
 						cpu_to_le32(prev_cond);
-			}
 		} else {
 			adapter->hs_cfg.conditions =
 				cpu_to_le32(hs_cfg->conditions);
@@ -2003,7 +1993,7 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
 		       encrypt_key->key_len);
 		wep_key->key_index = index;
 		wep_key->key_length = encrypt_key->key_len;
-		if (priv->sec_info.wep_status != MWIFIEX_802_11_WEP_ENABLED) {
+		if (priv->sec_info.wep_status != MWIFIEX_802_11_WEP_ENABLED)
 			/*
 			 * The status is set as Key Absent
 			 * so as to make sure we display the
@@ -2011,7 +2001,6 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
 			 */
 			priv->sec_info.wep_status =
 				MWIFIEX_802_11_WEP_KEY_ABSENT;
-		}
 	}
 	if (wep_key->key_length) {
 		/* Send request to firmware */
@@ -2098,18 +2087,17 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
 	if (!encrypt_key->key_index)
 		encrypt_key->key_index = MWIFIEX_KEY_INDEX_UNICAST;
 
-	if (remove_key) {
+	if (remove_key)
 		/* Send request to firmware */
 		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
 					  HostCmd_ACT_GEN_SET,
 					  !(KEY_INFO_ENABLED),
 					  wait, encrypt_key);
-	} else {
+	else
 		/* Send request to firmware */
 		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
 					  HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
 					  wait, encrypt_key);
-	}
 
 	if (!ret)
 		ret = -EINPROGRESS;
@@ -2135,11 +2123,10 @@ static int mwifiex_sec_ioctl_get_key(struct mwifiex_adapter *adapter,
 	if ((priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED)
 	    || (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_KEY_ABSENT)
 	    || priv->sec_info.ewpa_enabled
-	    || priv->sec_info.wpa_enabled || priv->sec_info.wpa2_enabled) {
+	    || priv->sec_info.wpa_enabled || priv->sec_info.wpa2_enabled)
 		encrypt_key->key_disable = false;
-	} else {
+	else
 		encrypt_key->key_disable = true;
-	}
 
 	if (encrypt_key->is_current_wep_key) {
 		if ((priv->wep_key[priv->wep_key_curr_index].key_length) &&
@@ -2494,11 +2481,10 @@ mwifiex_set_drv_txbuf_cfg(struct mwifiex_private *priv, int max_tx_buf_size)
 
 	if ((max_tx_buf_size == MWIFIEX_TX_DATA_BUF_SIZE_2K) ||
 	    (max_tx_buf_size == MWIFIEX_TX_DATA_BUF_SIZE_4K) ||
-	    (max_tx_buf_size == MWIFIEX_TX_DATA_BUF_SIZE_8K)) {
+	    (max_tx_buf_size == MWIFIEX_TX_DATA_BUF_SIZE_8K))
 		priv->adapter->max_tx_buf_size = (u16) max_tx_buf_size;
-	} else {
+	else
 		status = -1;
-	}
 
 	return status;
 }
@@ -2538,7 +2524,6 @@ mwifiex_get_tx_aggr_prio_tbl(struct mwifiex_private *priv, int *data)
 	for (i = 0, j = 0; i < (MAX_NUM_TID * 2); i = i + 2, ++j) {
 		data[i] = aggr_prio_tbl.ampdu[j];
 		data[i + 1] = aggr_prio_tbl.amsdu[j];
-
 	}
 
 	return 0;
@@ -2591,7 +2576,6 @@ mwifiex_set_sleep_pd(struct mwifiex_private *priv, int sleeppd)
 	if ((sleeppd <= MAX_SLEEP_PERIOD && sleeppd >= MIN_SLEEP_PERIOD)
 	    || (sleeppd == 0) || (sleeppd == SLEEP_PERIOD_RESERVED_FF)) {
 		sleep_period = sleeppd;
-
 	} else {
 		ret = -EINVAL;
 		goto done;
@@ -2739,10 +2723,9 @@ int mwifiex_get_scan_table(struct mwifiex_private *priv, u8 wait_option,
 
 	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
 	if (!status) {
-		if (scan_resp) {
+		if (scan_resp)
 			memcpy(scan_resp, &scan,
 			       sizeof(struct mwifiex_scan_resp));
-		}
 	}
 
 	if (wait && (status != -EINPROGRESS))
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index e171ef3..f819928 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -96,10 +96,9 @@ mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 	/* make space for INTF_HEADER_LEN */
 	skb_push(skb, INTF_HEADER_LEN);
 
-	if (!local_tx_pd->tx_control) {
+	if (!local_tx_pd->tx_control)
 		/* TxCtrl set by user or default */
 		local_tx_pd->tx_control = cpu_to_le32(priv->pkt_tx_ctrl);
-	}
 
 	return skb->data;
 }
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 2195656..6ef2a9b 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -273,10 +273,9 @@ mwifiex_wmm_setup_queue_priorities(struct mwifiex_private *priv,
 				     priv->wmm.queue_priority[j]);
 			} else if (tmp[j - 1] == tmp[j]) {
 				if (priv->wmm.queue_priority[j - 1]
-				    < priv->wmm.queue_priority[j]) {
+				    < priv->wmm.queue_priority[j])
 					swap(priv->wmm.queue_priority[j - 1],
 					     priv->wmm.queue_priority[j]);
-				}
 			}
 		}
 	}
@@ -338,10 +337,9 @@ mwifiex_wmm_setup_ac_downgrade(struct mwifiex_private *priv)
 
 	if (!priv->wmm_enabled) {
 		/* WMM is not enabled, default priorities */
-		for (ac_val = WMM_AC_BK; ac_val <= WMM_AC_VO; ac_val++) {
+		for (ac_val = WMM_AC_BK; ac_val <= WMM_AC_VO; ac_val++)
 			priv->wmm.ac_down_graded_vals[ac_val] =
 				(enum mwifiex_wmm_ac_e) ac_val;
-		}
 	} else {
 		for (ac_val = WMM_AC_BK; ac_val <= WMM_AC_VO; ac_val++) {
 			priv->wmm.ac_down_graded_vals[ac_val]
@@ -458,15 +456,13 @@ mwifiex_wmm_lists_empty(struct mwifiex_adapter *adapter)
 	for (j = 0; j < adapter->priv_num; ++j) {
 		priv = adapter->priv[j];
 		if (priv) {
-
-			for (i = 0; i < MAX_NUM_TID; i++) {
+			for (i = 0; i < MAX_NUM_TID; i++)
 				if (!mwifiex_wmm_is_ra_list_empty(adapter,
 								  &priv->wmm.
 								  tid_tbl_ptr
 								  [i].
 								  ra_list))
 					return false;
-			}
 		}
 	}
 
@@ -516,11 +512,10 @@ mwifiex_wmm_cleanup_queues(struct mwifiex_private *priv)
 {
 	int i;
 
-	for (i = 0; i < MAX_NUM_TID; i++) {
+	for (i = 0; i < MAX_NUM_TID; i++)
 		mwifiex_wmm_del_pkts_in_ralist(priv,
 					       &priv->wmm.tid_tbl_ptr[i].
 					       ra_list);
-	}
 }
 
 /*
@@ -1245,16 +1240,15 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 		if (mwifiex_is_amsdu_allowed(priv, ptr, tid) &&
 		    (mwifiex_num_pkts_in_txq(priv, ptr,
 					     adapter->tx_buf_size) >=
-		     MIN_NUM_AMSDU)) {
+		     MIN_NUM_AMSDU))
 			mwifiex_11n_aggregate_pkt(priv, ptr, INTF_HEADER_LEN,
 						  ptr_index, flags);
 			/* ra_list_spinlock has been freed in
 			   mwifiex_11n_aggregate_pkt() */
-		} else {
+		else
 			mwifiex_send_single_packet(priv, ptr, ptr_index, flags);
 			/* ra_list_spinlock has been freed in
 			   mwifiex_send_single_packet() */
-		}
 	}
 	return 0;
 }
-- 
1.7.0.2

