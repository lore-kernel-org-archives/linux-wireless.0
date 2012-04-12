Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:49838 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab2DLICl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 04:02:41 -0400
Subject: [PATCH] ath6kl: merge split format strings into one
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Thu, 12 Apr 2012 11:02:18 +0300
Message-ID: <20120412080218.8613.67472.stgit@localhost6.localdomain6> (sfid-20120412_100247_309155_CCC61FE2)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Found by checkpatch:

WARNING: quoted string split across lines

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   29 +++++-------
 drivers/net/wireless/ath/ath6kl/init.c     |   11 ++--
 drivers/net/wireless/ath/ath6kl/main.c     |    8 ++-
 drivers/net/wireless/ath/ath6kl/sdio.c     |    9 ++--
 drivers/net/wireless/ath/ath6kl/wmi.c      |   69 +++++++++++++++-------------
 5 files changed, 64 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 12f2f61..fffae87 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -693,8 +693,8 @@ ath6kl_add_bss_if_needed(struct ath6kl_vif *vif,
 					  ie, 2 + vif->ssid_len + beacon_ie_len,
 					  0, GFP_KERNEL);
 		if (bss)
-			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "added bss %pM to "
-				   "cfg80211\n", bssid);
+			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
+				   "added bss %pM to cfg80211\n", bssid);
 		kfree(ie);
 	} else
 		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "cfg80211 already has a bss\n");
@@ -927,8 +927,7 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 				       WMI_FRAME_PROBE_REQ,
 				       request->ie, request->ie_len);
 	if (ret) {
-		ath6kl_err("failed to set Probe Request appie for "
-			   "scan");
+		ath6kl_err("failed to set Probe Request appie for scan");
 		return ret;
 	}
 
@@ -945,8 +944,7 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 
 		channels = kzalloc(n_channels * sizeof(u16), GFP_KERNEL);
 		if (channels == NULL) {
-			ath6kl_warn("failed to set scan channels, "
-				    "scan all channels");
+			ath6kl_warn("failed to set scan channels, scan all channels");
 			n_channels = 0;
 		}
 
@@ -1125,9 +1123,8 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		ar->ap_mode_bkey.key_len = key->key_len;
 		memcpy(ar->ap_mode_bkey.key, key->key, key->key_len);
 		if (!test_bit(CONNECTED, &vif->flags)) {
-			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "Delay initial group "
-				   "key configuration until AP mode has been "
-				   "started\n");
+			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
+				   "Delay initial group key configuration until AP mode has been started\n");
 			/*
 			 * The key will be set in ath6kl_connect_ap_mode() once
 			 * the connected event is received from the target.
@@ -1143,8 +1140,8 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		 * the AP mode has properly started
 		 * (ath6kl_install_statioc_wep_keys).
 		 */
-		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "Delay WEP key configuration "
-			   "until AP mode has been started\n");
+		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
+			   "Delay WEP key configuration until AP mode has been started\n");
 		vif->wep_key_list[key_index].key_len = key->key_len;
 		memcpy(vif->wep_key_list[key_index].key, key->key,
 		       key->key_len);
@@ -1976,8 +1973,7 @@ static int ath6kl_wow_sta(struct ath6kl *ar, struct ath6kl_vif *vif)
 				sizeof(discvr_pattern), discvr_offset,
 				discvr_pattern, discvr_mask);
 		if (ret) {
-			ath6kl_err("failed to add WOW mDNS/SSDP/LLMNR "
-				   "pattern\n");
+			ath6kl_err("failed to add WOW mDNS/SSDP/LLMNR pattern\n");
 			return ret;
 		}
 	}
@@ -2161,8 +2157,8 @@ static int ath6kl_wow_resume(struct ath6kl *ar)
 	ret = ath6kl_wmi_set_host_sleep_mode_cmd(ar->wmi, vif->fw_vif_idx,
 						 ATH6KL_HOST_MODE_AWAKE);
 	if (ret) {
-		ath6kl_warn("Failed to configure host sleep mode for "
-			    "wow resume: %d\n", ret);
+		ath6kl_warn("Failed to configure host sleep mode for wow resume: %d\n",
+			    ret);
 		ar->state = ATH6KL_STATE_WOW;
 		return ret;
 	}
@@ -3292,8 +3288,7 @@ void ath6kl_cfg80211_stop_all(struct ath6kl *ar)
 		ar->wmi->saved_pwr_mode = ar->wmi->pwr_mode;
 
 		if (ath6kl_wmi_powermode_cmd(ar->wmi, 0, REC_POWER) != 0)
-			ath6kl_warn("ath6kl_deep_sleep_enable: "
-				    "wmi_powermode_cmd failed\n");
+			ath6kl_warn("ath6kl_deep_sleep_enable: wmi_powermode_cmd failed\n");
 		return;
 	}
 
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 29ef50e..42dcabf 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -445,9 +445,9 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar, int idx)
 					      P2P_FLAG_MACADDR_REQ |
 					      P2P_FLAG_HMODEL_REQ);
 		if (ret) {
-			ath6kl_dbg(ATH6KL_DBG_TRC, "failed to request P2P "
-				   "capabilities (%d) - assuming P2P not "
-				   "supported\n", ret);
+			ath6kl_dbg(ATH6KL_DBG_TRC,
+				   "failed to request P2P capabilities (%d) - assuming P2P not supported\n",
+				   ret);
 			ar->p2p = false;
 		}
 	}
@@ -456,8 +456,9 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar, int idx)
 		/* Enable Probe Request reporting for P2P */
 		ret = ath6kl_wmi_probe_report_req_cmd(ar->wmi, idx, true);
 		if (ret) {
-			ath6kl_dbg(ATH6KL_DBG_TRC, "failed to enable Probe "
-				   "Request reporting (%d)\n", ret);
+			ath6kl_dbg(ATH6KL_DBG_TRC,
+				   "failed to enable Probe Request reporting (%d)\n",
+				   ret);
 		}
 	}
 
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 4602be7..4f3aab2 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -421,8 +421,8 @@ void ath6kl_connect_ap_mode_bss(struct ath6kl_vif *vif, u16 channel)
 		if (!ik->valid)
 			break;
 
-		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "Delayed addkey for "
-			   "the initial group key for AP mode\n");
+		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
+			   "Delayed addkey for the initial group key for AP mode\n");
 		memset(key_rsc, 0, sizeof(key_rsc));
 		res = ath6kl_wmi_addkey_cmd(
 			ar->wmi, vif->fw_vif_idx, ik->key_index, ik->key_type,
@@ -430,8 +430,8 @@ void ath6kl_connect_ap_mode_bss(struct ath6kl_vif *vif, u16 channel)
 			ik->key,
 			KEY_OP_INIT_VAL, NULL, SYNC_BOTH_WMIFLAG);
 		if (res) {
-			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "Delayed "
-				   "addkey failed: %d\n", res);
+			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
+				   "Delayed addkey failed: %d\n", res);
 		}
 		break;
 	}
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 44ea7a7..4dc62c1 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -985,9 +985,8 @@ static int ath6kl_set_addrwin_reg(struct ath6kl *ar, u32 reg_addr, u32 addr)
 	}
 
 	if (status) {
-		ath6kl_err("%s: failed to write initial bytes of 0x%x "
-			   "to window reg: 0x%X\n", __func__,
-			   addr, reg_addr);
+		ath6kl_err("%s: failed to write initial bytes of 0x%x to window reg: 0x%X\n",
+			   __func__, addr, reg_addr);
 		return status;
 	}
 
@@ -1076,8 +1075,8 @@ static int ath6kl_sdio_bmi_credits(struct ath6kl *ar)
 					 (u8 *)&ar->bmi.cmd_credits, 4,
 					 HIF_RD_SYNC_BYTE_INC);
 		if (ret) {
-			ath6kl_err("Unable to decrement the command credit "
-						"count register: %d\n", ret);
+			ath6kl_err("Unable to decrement the command credit count register: %d\n",
+				   ret);
 			return ret;
 		}
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 7c8a997..db688a2 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -460,8 +460,9 @@ static int ath6kl_wmi_remain_on_chnl_event_rx(struct wmi *wmi, u8 *datap,
 		   freq, dur);
 	chan = ieee80211_get_channel(ar->wiphy, freq);
 	if (!chan) {
-		ath6kl_dbg(ATH6KL_DBG_WMI, "remain_on_chnl: Unknown channel "
-			   "(freq=%u)\n", freq);
+		ath6kl_dbg(ATH6KL_DBG_WMI,
+			   "remain_on_chnl: Unknown channel (freq=%u)\n",
+			   freq);
 		return -EINVAL;
 	}
 	id = vif->last_roc_id;
@@ -488,12 +489,14 @@ static int ath6kl_wmi_cancel_remain_on_chnl_event_rx(struct wmi *wmi,
 	ev = (struct wmi_cancel_remain_on_chnl_event *) datap;
 	freq = le32_to_cpu(ev->freq);
 	dur = le32_to_cpu(ev->duration);
-	ath6kl_dbg(ATH6KL_DBG_WMI, "cancel_remain_on_chnl: freq=%u dur=%u "
-		   "status=%u\n", freq, dur, ev->status);
+	ath6kl_dbg(ATH6KL_DBG_WMI,
+		   "cancel_remain_on_chnl: freq=%u dur=%u status=%u\n",
+		   freq, dur, ev->status);
 	chan = ieee80211_get_channel(ar->wiphy, freq);
 	if (!chan) {
-		ath6kl_dbg(ATH6KL_DBG_WMI, "cancel_remain_on_chnl: Unknown "
-			   "channel (freq=%u)\n", freq);
+		ath6kl_dbg(ATH6KL_DBG_WMI,
+			   "cancel_remain_on_chnl: Unknown channel (freq=%u)\n",
+			   freq);
 		return -EINVAL;
 	}
 	if (vif->last_cancel_roc_id &&
@@ -548,12 +551,12 @@ static int ath6kl_wmi_rx_probe_req_event_rx(struct wmi *wmi, u8 *datap, int len,
 	freq = le32_to_cpu(ev->freq);
 	dlen = le16_to_cpu(ev->len);
 	if (datap + len < ev->data + dlen) {
-		ath6kl_err("invalid wmi_p2p_rx_probe_req_event: "
-			   "len=%d dlen=%u\n", len, dlen);
+		ath6kl_err("invalid wmi_p2p_rx_probe_req_event: len=%d dlen=%u\n",
+			   len, dlen);
 		return -EINVAL;
 	}
-	ath6kl_dbg(ATH6KL_DBG_WMI, "rx_probe_req: len=%u freq=%u "
-		   "probe_req_report=%d\n",
+	ath6kl_dbg(ATH6KL_DBG_WMI,
+		   "rx_probe_req: len=%u freq=%u probe_req_report=%d\n",
 		   dlen, freq, vif->probe_req_report);
 
 	if (vif->probe_req_report || vif->nw_type == AP_NETWORK)
@@ -592,8 +595,8 @@ static int ath6kl_wmi_rx_action_event_rx(struct wmi *wmi, u8 *datap, int len,
 	freq = le32_to_cpu(ev->freq);
 	dlen = le16_to_cpu(ev->len);
 	if (datap + len < ev->data + dlen) {
-		ath6kl_err("invalid wmi_rx_action_event: "
-			   "len=%d dlen=%u\n", len, dlen);
+		ath6kl_err("invalid wmi_rx_action_event: len=%d dlen=%u\n",
+			   len, dlen);
 		return -EINVAL;
 	}
 	ath6kl_dbg(ATH6KL_DBG_WMI, "rx_action: len=%u freq=%u\n", dlen, freq);
@@ -777,16 +780,15 @@ static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len,
 		/* AP mode start/STA connected event */
 		struct net_device *dev = vif->ndev;
 		if (memcmp(dev->dev_addr, ev->u.ap_bss.bssid, ETH_ALEN) == 0) {
-			ath6kl_dbg(ATH6KL_DBG_WMI, "%s: freq %d bssid %pM "
-				   "(AP started)\n",
+			ath6kl_dbg(ATH6KL_DBG_WMI,
+				   "%s: freq %d bssid %pM (AP started)\n",
 				   __func__, le16_to_cpu(ev->u.ap_bss.ch),
 				   ev->u.ap_bss.bssid);
 			ath6kl_connect_ap_mode_bss(
 				vif, le16_to_cpu(ev->u.ap_bss.ch));
 		} else {
-			ath6kl_dbg(ATH6KL_DBG_WMI, "%s: aid %u mac_addr %pM "
-				   "auth=%u keymgmt=%u cipher=%u apsd_info=%u "
-				   "(STA connected)\n",
+			ath6kl_dbg(ATH6KL_DBG_WMI,
+				   "%s: aid %u mac_addr %pM auth=%u keymgmt=%u cipher=%u apsd_info=%u (STA connected)\n",
 				   __func__, ev->u.ap_sta.aid,
 				   ev->u.ap_sta.mac_addr,
 				   ev->u.ap_sta.auth,
@@ -1229,8 +1231,9 @@ static int ath6kl_wmi_neighbor_report_event_rx(struct wmi *wmi, u8 *datap,
 	ev = (struct wmi_neighbor_report_event *) datap;
 	if (sizeof(*ev) + ev->num_neighbors * sizeof(struct wmi_neighbor_info)
 	    > len) {
-		ath6kl_dbg(ATH6KL_DBG_WMI, "truncated neighbor event "
-			   "(num=%d len=%d)\n", ev->num_neighbors, len);
+		ath6kl_dbg(ATH6KL_DBG_WMI,
+			   "truncated neighbor event (num=%d len=%d)\n",
+			   ev->num_neighbors, len);
 		return -EINVAL;
 	}
 	for (i = 0; i < ev->num_neighbors; i++) {
@@ -2129,8 +2132,8 @@ int ath6kl_wmi_addkey_cmd(struct wmi *wmi, u8 if_idx, u8 key_index,
 	struct wmi_add_cipher_key_cmd *cmd;
 	int ret;
 
-	ath6kl_dbg(ATH6KL_DBG_WMI, "addkey cmd: key_index=%u key_type=%d "
-		   "key_usage=%d key_len=%d key_op_ctrl=%d\n",
+	ath6kl_dbg(ATH6KL_DBG_WMI,
+		   "addkey cmd: key_index=%u key_type=%d key_usage=%d key_len=%d key_op_ctrl=%d\n",
 		   key_index, key_type, key_usage, key_len, key_op_ctrl);
 
 	if ((key_index > WMI_MAX_KEY_INDEX) || (key_len > WMI_MAX_KEY_LEN) ||
@@ -3047,8 +3050,8 @@ int ath6kl_wmi_ap_profile_commit(struct wmi *wmip, u8 if_idx,
 
 	res = ath6kl_wmi_cmd_send(wmip, if_idx, skb, WMI_AP_CONFIG_COMMIT_CMDID,
 				  NO_SYNC_WMIFLAG);
-	ath6kl_dbg(ATH6KL_DBG_WMI, "%s: nw_type=%u auth_mode=%u ch=%u "
-		   "ctrl_flags=0x%x-> res=%d\n",
+	ath6kl_dbg(ATH6KL_DBG_WMI,
+		   "%s: nw_type=%u auth_mode=%u ch=%u ctrl_flags=0x%x-> res=%d\n",
 		   __func__, p->nw_type, p->auth_mode, le16_to_cpu(p->ch),
 		   le32_to_cpu(p->ctrl_flags), res);
 	return res;
@@ -3208,8 +3211,9 @@ int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 if_idx, u8 mgmt_frm_type,
 	if (!skb)
 		return -ENOMEM;
 
-	ath6kl_dbg(ATH6KL_DBG_WMI, "set_appie_cmd: mgmt_frm_type=%u "
-		   "ie_len=%u\n", mgmt_frm_type, ie_len);
+	ath6kl_dbg(ATH6KL_DBG_WMI,
+		   "set_appie_cmd: mgmt_frm_type=%u ie_len=%u\n",
+		   mgmt_frm_type, ie_len);
 	p = (struct wmi_set_appie_cmd *) skb->data;
 	p->mgmt_frm_type = mgmt_frm_type;
 	p->ie_len = ie_len;
@@ -3310,8 +3314,9 @@ static int ath6kl_wmi_send_action_cmd(struct wmi *wmi, u8 if_idx, u32 id,
 	wmi->last_mgmt_tx_frame = buf;
 	wmi->last_mgmt_tx_frame_len = data_len;
 
-	ath6kl_dbg(ATH6KL_DBG_WMI, "send_action_cmd: id=%u freq=%u wait=%u "
-		   "len=%u\n", id, freq, wait, data_len);
+	ath6kl_dbg(ATH6KL_DBG_WMI,
+		   "send_action_cmd: id=%u freq=%u wait=%u len=%u\n",
+		   id, freq, wait, data_len);
 	p = (struct wmi_send_action_cmd *) skb->data;
 	p->id = cpu_to_le32(id);
 	p->freq = cpu_to_le32(freq);
@@ -3348,8 +3353,9 @@ static int __ath6kl_wmi_send_mgmt_cmd(struct wmi *wmi, u8 if_idx, u32 id,
 	wmi->last_mgmt_tx_frame = buf;
 	wmi->last_mgmt_tx_frame_len = data_len;
 
-	ath6kl_dbg(ATH6KL_DBG_WMI, "send_action_cmd: id=%u freq=%u wait=%u "
-		   "len=%u\n", id, freq, wait, data_len);
+	ath6kl_dbg(ATH6KL_DBG_WMI,
+		   "send_action_cmd: id=%u freq=%u wait=%u len=%u\n",
+		   id, freq, wait, data_len);
 	p = (struct wmi_send_mgmt_cmd *) skb->data;
 	p->id = cpu_to_le32(id);
 	p->freq = cpu_to_le32(freq);
@@ -3402,8 +3408,9 @@ int ath6kl_wmi_send_probe_response_cmd(struct wmi *wmi, u8 if_idx, u32 freq,
 	if (!skb)
 		return -ENOMEM;
 
-	ath6kl_dbg(ATH6KL_DBG_WMI, "send_probe_response_cmd: freq=%u dst=%pM "
-		   "len=%u\n", freq, dst, data_len);
+	ath6kl_dbg(ATH6KL_DBG_WMI,
+		   "send_probe_response_cmd: freq=%u dst=%pM len=%u\n",
+		   freq, dst, data_len);
 	p = (struct wmi_p2p_probe_response_cmd *) skb->data;
 	p->freq = cpu_to_le32(freq);
 	memcpy(p->destination_addr, dst, ETH_ALEN);

