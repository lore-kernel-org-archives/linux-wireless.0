Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34847 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933537Ab1JYOGM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:06:12 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 17/31] ath6kl: Maintain firmware interface index in struct ath6kl_vif
Date: Tue, 25 Oct 2011 19:34:12 +0530
Message-ID: <1319551466-29070-18-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160617_708703_81AF7F7F)
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass this index to target in wmi commands to specify the interface
for which the command needs to be handled.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  125 ++++++++++++---------
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    3 +-
 drivers/net/wireless/ath/ath6kl/core.h     |    5 +-
 drivers/net/wireless/ath/ath6kl/debug.c    |    4 +-
 drivers/net/wireless/ath/ath6kl/init.c     |    2 +-
 drivers/net/wireless/ath/ath6kl/main.c     |   42 ++++---
 drivers/net/wireless/ath/ath6kl/sdio.c     |    2 +-
 drivers/net/wireless/ath/ath6kl/txrx.c     |    5 +-
 drivers/net/wireless/ath/ath6kl/wmi.c      |  172 ++++++++++++++++------------
 drivers/net/wireless/ath/ath6kl/wmi.h      |   63 ++++++-----
 10 files changed, 243 insertions(+), 180 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 55e4c92..c8c5712 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -269,9 +269,10 @@ static bool ath6kl_is_rsn_ie(const u8 *pos)
 	return pos[0] == WLAN_EID_RSN;
 }
 
-static int ath6kl_set_assoc_req_ies(struct ath6kl *ar, const u8 *ies,
-					size_t ies_len)
+static int ath6kl_set_assoc_req_ies(struct ath6kl_vif *vif, const u8 *ies,
+				    size_t ies_len)
 {
+	struct ath6kl *ar = vif->ar;
 	const u8 *pos;
 	u8 *buf = NULL;
 	size_t len = 0;
@@ -298,8 +299,8 @@ static int ath6kl_set_assoc_req_ies(struct ath6kl *ar, const u8 *ies,
 		}
 	}
 
-	ret = ath6kl_wmi_set_appie_cmd(ar->wmi, WMI_FRAME_ASSOC_REQ,
-				       buf, len);
+	ret = ath6kl_wmi_set_appie_cmd(ar->wmi, vif->fw_vif_idx,
+				       WMI_FRAME_ASSOC_REQ, buf, len);
 	kfree(buf);
 	return ret;
 }
@@ -354,7 +355,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	if (sme->ie && (sme->ie_len > 0)) {
-		status = ath6kl_set_assoc_req_ies(ar, sme->ie, sme->ie_len);
+		status = ath6kl_set_assoc_req_ies(vif, sme->ie, sme->ie_len);
 		if (status)
 			return status;
 	}
@@ -363,7 +364,8 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	    vif->ssid_len == sme->ssid_len &&
 	    !memcmp(vif->ssid, sme->ssid, vif->ssid_len)) {
 		vif->reconnect_flag = true;
-		status = ath6kl_wmi_reconnect_cmd(ar->wmi, vif->req_bssid,
+		status = ath6kl_wmi_reconnect_cmd(ar->wmi, vif->fw_vif_idx,
+						  vif->req_bssid,
 						  vif->ch_hint);
 
 		up(&ar->sem);
@@ -374,7 +376,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		return 0;
 	} else if (vif->ssid_len == sme->ssid_len &&
 		   !memcmp(vif->ssid, sme->ssid, vif->ssid_len)) {
-		ath6kl_disconnect(ar);
+		ath6kl_disconnect(ar, vif->fw_vif_idx);
 	}
 
 	memset(vif->ssid, 0, sizeof(vif->ssid));
@@ -425,7 +427,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		key->cipher = vif->prwise_crypto;
 		vif->def_txkey_index = sme->key_idx;
 
-		ath6kl_wmi_addkey_cmd(ar->wmi, sme->key_idx,
+		ath6kl_wmi_addkey_cmd(ar->wmi, vif->fw_vif_idx, sme->key_idx,
 				      vif->prwise_crypto,
 				      GROUP_USAGE | TX_USAGE,
 				      key->key_len,
@@ -455,7 +457,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		   vif->grp_crypto_len, vif->ch_hint);
 
 	vif->reconnect_flag = 0;
-	status = ath6kl_wmi_connect_cmd(ar->wmi, vif->nw_type,
+	status = ath6kl_wmi_connect_cmd(ar->wmi, vif->fw_vif_idx, vif->nw_type,
 					vif->dot11_auth_mode, vif->auth_mode,
 					vif->prwise_crypto,
 					vif->prwise_crypto_len,
@@ -639,7 +641,7 @@ static int ath6kl_cfg80211_disconnect(struct wiphy *wiphy,
 	}
 
 	vif->reconnect_flag = 0;
-	ath6kl_disconnect(ar);
+	ath6kl_disconnect(ar, vif->fw_vif_idx);
 	memset(vif->ssid, 0, sizeof(vif->ssid));
 	vif->ssid_len = 0;
 
@@ -695,7 +697,7 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
 	 */
 
 	if (reason != DISCONNECT_CMD) {
-		ath6kl_wmi_disconnect_cmd(ar->wmi);
+		ath6kl_wmi_disconnect_cmd(ar->wmi, vif->fw_vif_idx);
 		return;
 	}
 
@@ -747,14 +749,15 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 			request->n_ssids = MAX_PROBED_SSID_INDEX - 1;
 
 		for (i = 0; i < request->n_ssids; i++)
-			ath6kl_wmi_probedssid_cmd(ar->wmi, i + 1,
-						  SPECIFIC_SSID_FLAG,
+			ath6kl_wmi_probedssid_cmd(ar->wmi, vif->fw_vif_idx,
+						  i + 1, SPECIFIC_SSID_FLAG,
 						  request->ssids[i].ssid_len,
 						  request->ssids[i].ssid);
 	}
 
 	if (request->ie) {
-		ret = ath6kl_wmi_set_appie_cmd(ar->wmi, WMI_FRAME_PROBE_REQ,
+		ret = ath6kl_wmi_set_appie_cmd(ar->wmi, vif->fw_vif_idx,
+					       WMI_FRAME_PROBE_REQ,
 					       request->ie, request->ie_len);
 		if (ret) {
 			ath6kl_err("failed to set Probe Request appie for "
@@ -788,8 +791,9 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	if (test_bit(CONNECTED, &vif->flags))
 		force_fg_scan = 1;
 
-	ret = ath6kl_wmi_startscan_cmd(ar->wmi, WMI_LONG_SCAN, force_fg_scan,
-				       false, 0, 0, n_channels, channels);
+	ret = ath6kl_wmi_startscan_cmd(ar->wmi, vif->fw_vif_idx, WMI_LONG_SCAN,
+				       force_fg_scan, false, 0, 0, n_channels,
+				       channels);
 	if (ret)
 		ath6kl_err("wmi_startscan_cmd failed\n");
 	else
@@ -820,8 +824,8 @@ void ath6kl_cfg80211_scan_complete_event(struct ath6kl *ar, int status)
 
 	if (vif->scan_req->n_ssids && vif->scan_req->ssids[0].ssid_len) {
 		for (i = 0; i < vif->scan_req->n_ssids; i++) {
-			ath6kl_wmi_probedssid_cmd(ar->wmi, i + 1,
-						  DISABLE_SSID_FLAG,
+			ath6kl_wmi_probedssid_cmd(ar->wmi, vif->fw_vif_idx,
+						  i + 1, DISABLE_SSID_FLAG,
 						  0, NULL);
 		}
 	}
@@ -942,7 +946,8 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		return 0;
 	}
 
-	status = ath6kl_wmi_addkey_cmd(ar->wmi, vif->def_txkey_index,
+	status = ath6kl_wmi_addkey_cmd(ar->wmi, vif->fw_vif_idx,
+				       vif->def_txkey_index,
 				       key_type, key_usage, key->key_len,
 				       key->seq, key->key, KEY_OP_INIT_VAL,
 				       (u8 *) mac_addr, SYNC_BOTH_WMIFLAG);
@@ -980,7 +985,7 @@ static int ath6kl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	vif->keys[key_index].key_len = 0;
 
-	return ath6kl_wmi_deletekey_cmd(ar->wmi, key_index);
+	return ath6kl_wmi_deletekey_cmd(ar->wmi, vif->fw_vif_idx, key_index);
 }
 
 static int ath6kl_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
@@ -1062,7 +1067,8 @@ static int ath6kl_cfg80211_set_default_key(struct wiphy *wiphy,
 	if (vif->next_mode == AP_NETWORK && !test_bit(CONNECTED, &vif->flags))
 		return 0; /* Delay until AP mode has been started */
 
-	status = ath6kl_wmi_addkey_cmd(ar->wmi, vif->def_txkey_index,
+	status = ath6kl_wmi_addkey_cmd(ar->wmi, vif->fw_vif_idx,
+				       vif->def_txkey_index,
 				       key_type, key_usage,
 				       key->key_len, key->seq, key->key,
 				       KEY_OP_INIT_VAL, NULL,
@@ -1179,6 +1185,7 @@ static int ath6kl_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
 	struct wmi_power_mode_cmd mode;
+	struct ath6kl_vif *vif = netdev_priv(dev);
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: pmgmt %d, timeout %d\n",
 		   __func__, pmgmt, timeout);
@@ -1194,7 +1201,8 @@ static int ath6kl_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 		mode.pwr_mode = MAX_PERF_POWER;
 	}
 
-	if (ath6kl_wmi_powermode_cmd(ar->wmi, mode.pwr_mode) != 0) {
+	if (ath6kl_wmi_powermode_cmd(ar->wmi, vif->fw_vif_idx,
+	     mode.pwr_mode) != 0) {
 		ath6kl_err("wmi_powermode_cmd failed\n");
 		return -EIO;
 	}
@@ -1299,7 +1307,7 @@ static int ath6kl_cfg80211_join_ibss(struct wiphy *wiphy,
 		   vif->prwise_crypto_len, vif->grp_crypto,
 		   vif->grp_crypto_len, vif->ch_hint);
 
-	status = ath6kl_wmi_connect_cmd(ar->wmi, vif->nw_type,
+	status = ath6kl_wmi_connect_cmd(ar->wmi, vif->fw_vif_idx, vif->nw_type,
 					vif->dot11_auth_mode, vif->auth_mode,
 					vif->prwise_crypto,
 					vif->prwise_crypto_len,
@@ -1321,7 +1329,7 @@ static int ath6kl_cfg80211_leave_ibss(struct wiphy *wiphy,
 	if (!ath6kl_cfg80211_ready(ar))
 		return -EIO;
 
-	ath6kl_disconnect(ar);
+	ath6kl_disconnect(ar, vif->fw_vif_idx);
 	memset(vif->ssid, 0, sizeof(vif->ssid));
 	vif->ssid_len = 0;
 
@@ -1416,7 +1424,7 @@ static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
 
 	set_bit(STATS_UPDATE_PEND, &vif->flags);
 
-	ret = ath6kl_wmi_get_stats_cmd(ar->wmi);
+	ret = ath6kl_wmi_get_stats_cmd(ar->wmi, vif->fw_vif_idx);
 
 	if (ret != 0) {
 		up(&ar->sem);
@@ -1500,7 +1508,9 @@ static int ath6kl_set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 			    struct cfg80211_pmksa *pmksa)
 {
 	struct ath6kl *ar = ath6kl_priv(netdev);
-	return ath6kl_wmi_setpmkid_cmd(ar->wmi, pmksa->bssid,
+	struct ath6kl_vif *vif = netdev_priv(netdev);
+
+	return ath6kl_wmi_setpmkid_cmd(ar->wmi, vif->fw_vif_idx, pmksa->bssid,
 				       pmksa->pmkid, true);
 }
 
@@ -1508,7 +1518,9 @@ static int ath6kl_del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 			    struct cfg80211_pmksa *pmksa)
 {
 	struct ath6kl *ar = ath6kl_priv(netdev);
-	return ath6kl_wmi_setpmkid_cmd(ar->wmi, pmksa->bssid,
+	struct ath6kl_vif *vif = netdev_priv(netdev);
+
+	return ath6kl_wmi_setpmkid_cmd(ar->wmi, vif->fw_vif_idx, pmksa->bssid,
 				       pmksa->pmkid, false);
 }
 
@@ -1518,8 +1530,8 @@ static int ath6kl_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 	struct ath6kl_vif *vif = netdev_priv(netdev);
 
 	if (test_bit(CONNECTED, &vif->flags))
-		return ath6kl_wmi_setpmkid_cmd(ar->wmi, vif->bssid,
-					       NULL, false);
+		return ath6kl_wmi_setpmkid_cmd(ar->wmi, vif->fw_vif_idx,
+					       vif->bssid, NULL, false);
 	return 0;
 }
 
@@ -1564,9 +1576,10 @@ static bool ath6kl_is_p2p_ie(const u8 *pos)
 		pos[4] == 0x9a && pos[5] == 0x09;
 }
 
-static int ath6kl_set_ap_probe_resp_ies(struct ath6kl *ar, const u8 *ies,
-					size_t ies_len)
+static int ath6kl_set_ap_probe_resp_ies(struct ath6kl_vif *vif,
+					const u8 *ies, size_t ies_len)
 {
+	struct ath6kl *ar = vif->ar;
 	const u8 *pos;
 	u8 *buf = NULL;
 	size_t len = 0;
@@ -1593,8 +1606,8 @@ static int ath6kl_set_ap_probe_resp_ies(struct ath6kl *ar, const u8 *ies,
 		}
 	}
 
-	ret = ath6kl_wmi_set_appie_cmd(ar->wmi, WMI_FRAME_PROBE_RESP,
-				       buf, len);
+	ret = ath6kl_wmi_set_appie_cmd(ar->wmi, vif->fw_vif_idx,
+				       WMI_FRAME_PROBE_RESP, buf, len);
 	kfree(buf);
 	return ret;
 }
@@ -1620,20 +1633,22 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 		return -EOPNOTSUPP;
 
 	if (info->beacon_ies) {
-		res = ath6kl_wmi_set_appie_cmd(ar->wmi, WMI_FRAME_BEACON,
+		res = ath6kl_wmi_set_appie_cmd(ar->wmi, vif->fw_vif_idx,
+					       WMI_FRAME_BEACON,
 					       info->beacon_ies,
 					       info->beacon_ies_len);
 		if (res)
 			return res;
 	}
 	if (info->proberesp_ies) {
-		res = ath6kl_set_ap_probe_resp_ies(ar, info->proberesp_ies,
+		res = ath6kl_set_ap_probe_resp_ies(vif, info->proberesp_ies,
 						   info->proberesp_ies_len);
 		if (res)
 			return res;
 	}
 	if (info->assocresp_ies) {
-		res = ath6kl_wmi_set_appie_cmd(ar->wmi, WMI_FRAME_ASSOC_RESP,
+		res = ath6kl_wmi_set_appie_cmd(ar->wmi, vif->fw_vif_idx,
+					       WMI_FRAME_ASSOC_RESP,
 					       info->assocresp_ies,
 					       info->assocresp_ies_len);
 		if (res)
@@ -1734,7 +1749,7 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 	p.dot11_auth_mode = vif->dot11_auth_mode;
 	p.ch = cpu_to_le16(vif->next_chan);
 
-	res = ath6kl_wmi_ap_profile_commit(ar->wmi, &p);
+	res = ath6kl_wmi_ap_profile_commit(ar->wmi, vif->fw_vif_idx, &p);
 	if (res < 0)
 		return res;
 
@@ -1763,7 +1778,7 @@ static int ath6kl_del_beacon(struct wiphy *wiphy, struct net_device *dev)
 	if (!test_bit(CONNECTED, &vif->flags))
 		return -ENOTCONN;
 
-	ath6kl_wmi_disconnect_cmd(ar->wmi);
+	ath6kl_wmi_disconnect_cmd(ar->wmi, vif->fw_vif_idx);
 	clear_bit(CONNECTED, &vif->flags);
 
 	return 0;
@@ -1783,10 +1798,10 @@ static int ath6kl_change_station(struct wiphy *wiphy, struct net_device *dev,
 		return -EOPNOTSUPP;
 
 	if (params->sta_flags_set & BIT(NL80211_STA_FLAG_AUTHORIZED))
-		return ath6kl_wmi_ap_set_mlme(ar->wmi, WMI_AP_MLME_AUTHORIZE,
-					      mac, 0);
-	return ath6kl_wmi_ap_set_mlme(ar->wmi, WMI_AP_MLME_UNAUTHORIZE, mac,
-				      0);
+		return ath6kl_wmi_ap_set_mlme(ar->wmi, vif->fw_vif_idx,
+					      WMI_AP_MLME_AUTHORIZE, mac, 0);
+	return ath6kl_wmi_ap_set_mlme(ar->wmi, vif->fw_vif_idx,
+				      WMI_AP_MLME_UNAUTHORIZE, mac, 0);
 }
 
 static int ath6kl_remain_on_channel(struct wiphy *wiphy,
@@ -1797,13 +1812,14 @@ static int ath6kl_remain_on_channel(struct wiphy *wiphy,
 				    u64 *cookie)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
 
 	/* TODO: if already pending or ongoing remain-on-channel,
 	 * return -EBUSY */
 	*cookie = 1; /* only a single pending request is supported */
 
-	return ath6kl_wmi_remain_on_chnl_cmd(ar->wmi, chan->center_freq,
-					     duration);
+	return ath6kl_wmi_remain_on_chnl_cmd(ar->wmi, vif->fw_vif_idx,
+					     chan->center_freq, duration);
 }
 
 static int ath6kl_cancel_remain_on_channel(struct wiphy *wiphy,
@@ -1811,16 +1827,19 @@ static int ath6kl_cancel_remain_on_channel(struct wiphy *wiphy,
 					   u64 cookie)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
 
 	if (cookie != 1)
 		return -ENOENT;
 
-	return ath6kl_wmi_cancel_remain_on_chnl_cmd(ar->wmi);
+	return ath6kl_wmi_cancel_remain_on_chnl_cmd(ar->wmi, vif->fw_vif_idx);
 }
 
-static int ath6kl_send_go_probe_resp(struct ath6kl *ar, const u8 *buf,
-				     size_t len, unsigned int freq)
+static int ath6kl_send_go_probe_resp(struct ath6kl_vif *vif,
+				     const u8 *buf, size_t len,
+				     unsigned int freq)
 {
+	struct ath6kl *ar = vif->ar;
 	const u8 *pos;
 	u8 *p2p;
 	int p2p_len;
@@ -1847,8 +1866,8 @@ static int ath6kl_send_go_probe_resp(struct ath6kl *ar, const u8 *buf,
 		pos += 2 + pos[1];
 	}
 
-	ret = ath6kl_wmi_send_probe_response_cmd(ar->wmi, freq, mgmt->da,
-						 p2p, p2p_len);
+	ret = ath6kl_wmi_send_probe_response_cmd(ar->wmi, vif->fw_vif_idx, freq,
+						 mgmt->da, p2p, p2p_len);
 	kfree(p2p);
 	return ret;
 }
@@ -1873,7 +1892,7 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 		 * command to allow the target to fill in the generic IEs.
 		 */
 		*cookie = 0; /* TX status not supported */
-		return ath6kl_send_go_probe_resp(ar, buf, len,
+		return ath6kl_send_go_probe_resp(vif, buf, len,
 						 chan->center_freq);
 	}
 
@@ -1887,7 +1906,8 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	*cookie = id;
-	return ath6kl_wmi_send_action_cmd(ar->wmi, id, chan->center_freq, wait,
+	return ath6kl_wmi_send_action_cmd(ar->wmi, vif->fw_vif_idx, id,
+					  chan->center_freq, wait,
 					  buf, len);
 }
 
@@ -2092,7 +2112,7 @@ void ath6kl_deinit_if_data(struct ath6kl_vif *vif)
 }
 
 struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
-					enum nl80211_iftype type)
+					enum nl80211_iftype type, u8 fw_vif_idx)
 {
 	struct net_device *ndev;
 	struct ath6kl_vif *vif;
@@ -2110,6 +2130,7 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	SET_NETDEV_DEV(ndev, wiphy_dev(vif->wdev.wiphy));
 	vif->wdev.netdev = ndev;
 	vif->wdev.iftype = type;
+	vif->fw_vif_idx = fw_vif_idx;
 	ar->wdev = &vif->wdev;
 	ar->net_dev = ndev;
 
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index 5daf685..033e742 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -18,7 +18,8 @@
 #define ATH6KL_CFG80211_H
 
 struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
-					enum nl80211_iftype type);
+					enum nl80211_iftype type,
+					u8 fw_vif_idx);
 int ath6kl_register_ieee80211_hw(struct ath6kl *ar);
 struct ath6kl *ath6kl_core_alloc(struct device *dev);
 void ath6kl_deinit_ieee80211_hw(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 41d6ae0..f21d777 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -380,6 +380,8 @@ struct ath6kl_req_key {
 	u8 key_len;
 };
 
+#define MAX_NUM_VIF	1
+
 /* vif flags info */
 enum ath6kl_vif_state {
 	CONNECTED,
@@ -398,6 +400,7 @@ struct ath6kl_vif {
 	struct wireless_dev wdev;
 	struct net_device *ndev;
 	struct ath6kl *ar;
+	u8 fw_vif_idx;
 	unsigned long flags;
 	int ssid_len;
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
@@ -647,7 +650,7 @@ enum htc_endpoint_id ath6kl_ac2_endpoint_id(void *devt, u8 ac);
 void ath6kl_pspoll_event(struct ath6kl *ar, u8 aid);
 
 void ath6kl_dtimexpiry_event(struct ath6kl *ar);
-void ath6kl_disconnect(struct ath6kl *ar);
+void ath6kl_disconnect(struct ath6kl *ar, u8 if_idx);
 void ath6kl_deep_sleep_enable(struct ath6kl *ar);
 void aggr_recv_delba_req_evt(struct ath6kl *ar, u8 tid);
 void aggr_recv_addba_req_evt(struct ath6kl *ar, u8 tid, u16 seq_no,
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 9a89b42..870e9b1 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -417,7 +417,7 @@ static ssize_t read_file_tgt_stats(struct file *file, char __user *user_buf,
 
 	set_bit(STATS_UPDATE_PEND, &vif->flags);
 
-	if (ath6kl_wmi_get_stats_cmd(ar->wmi)) {
+	if (ath6kl_wmi_get_stats_cmd(ar->wmi, 0)) {
 		up(&ar->sem);
 		kfree(buf);
 		return -EIO;
@@ -1477,7 +1477,7 @@ static ssize_t ath6kl_bgscan_int_write(struct file *file,
 	if (bgscan_int == 0)
 		bgscan_int = 0xffff;
 
-	ath6kl_wmi_scanparams_cmd(ar->wmi, 0, 0, bgscan_int, 0, 0, 0, 3,
+	ath6kl_wmi_scanparams_cmd(ar->wmi, 0, 0, 0, bgscan_int, 0, 0, 0, 3,
 				  0, 0, 0);
 
 	return count;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index a26faae..fb78a2a 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1407,7 +1407,7 @@ static int ath6kl_init(struct ath6kl *ar)
 	}
 
 	/* Add an initial station interface */
-	ndev = ath6kl_interface_add(ar, "wlan%d", NL80211_IFTYPE_STATION);
+	ndev = ath6kl_interface_add(ar, "wlan%d", NL80211_IFTYPE_STATION, 0);
 	if (!ndev) {
 		ath6kl_err("Failed to instantiate a network device\n");
 		status = -ENOMEM;
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index fff1f4a..9929901 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -441,7 +441,7 @@ void ath6kl_stop_endpoint(struct net_device *dev, bool keep_profile,
 	if (test_bit(WMI_READY, &ar->flag)) {
 		discon_issued = (test_bit(CONNECTED, &vif->flags) ||
 				 test_bit(CONNECT_PEND, &vif->flags));
-		ath6kl_disconnect(ar);
+		ath6kl_disconnect(ar, vif->fw_vif_idx);
 		if (!keep_profile)
 			ath6kl_init_profile_info(ar);
 
@@ -511,7 +511,7 @@ static void ath6kl_install_static_wep_keys(struct ath6kl *ar)
 			if (index == vif->def_txkey_index)
 				keyusage |= TX_USAGE;
 
-			ath6kl_wmi_addkey_cmd(ar->wmi,
+			ath6kl_wmi_addkey_cmd(ar->wmi, vif->fw_vif_idx,
 					      index,
 					      WEP_CRYPT,
 					      keyusage,
@@ -551,7 +551,7 @@ void ath6kl_connect_ap_mode_bss(struct ath6kl *ar, u16 channel)
 			   "the initial group key for AP mode\n");
 		memset(key_rsc, 0, sizeof(key_rsc));
 		res = ath6kl_wmi_addkey_cmd(
-			ar->wmi, ik->key_index, ik->key_type,
+			ar->wmi, vif->fw_vif_idx, ik->key_index, ik->key_type,
 			GROUP_USAGE, ik->key_len, key_rsc, ik->key,
 			KEY_OP_INIT_VAL, NULL, SYNC_BOTH_WMIFLAG);
 		if (res) {
@@ -913,20 +913,20 @@ void ath6k_credit_distribute(struct htc_credit_state_info *cred_info,
 void disconnect_timer_handler(unsigned long ptr)
 {
 	struct net_device *dev = (struct net_device *)ptr;
-	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
 
-	ath6kl_init_profile_info(ar);
-	ath6kl_disconnect(ar);
+	ath6kl_init_profile_info(vif->ar);
+	ath6kl_disconnect(vif->ar, vif->fw_vif_idx);
 }
 
-void ath6kl_disconnect(struct ath6kl *ar)
+void ath6kl_disconnect(struct ath6kl *ar, u8 if_idx)
 {
 	/* TODO: Pass vif instead of taking it from ar */
 	struct ath6kl_vif *vif = ar->vif;
 
 	if (test_bit(CONNECTED, &vif->flags) ||
 	    test_bit(CONNECT_PEND, &vif->flags)) {
-		ath6kl_wmi_disconnect_cmd(ar->wmi);
+		ath6kl_wmi_disconnect_cmd(ar->wmi, if_idx);
 		/*
 		 * Disconnect command is issued, clear the connect pending
 		 * flag. The connected flag will be cleared in
@@ -961,13 +961,13 @@ void ath6kl_deep_sleep_enable(struct ath6kl *ar)
 
 	if (test_bit(CONNECTED, &vif->flags) ||
 	    test_bit(CONNECT_PEND, &vif->flags))
-		ath6kl_wmi_disconnect_cmd(ar->wmi);
+		ath6kl_wmi_disconnect_cmd(ar->wmi, vif->fw_vif_idx);
 
 	vif->sme_state = SME_DISCONNECTED;
 
 	/* disable scanning */
-	if (ath6kl_wmi_scanparams_cmd(ar->wmi, 0xFFFF, 0, 0, 0, 0, 0, 0, 0,
-				      0, 0) != 0)
+	if (ath6kl_wmi_scanparams_cmd(ar->wmi, vif->fw_vif_idx, 0xFFFF, 0, 0,
+				      0, 0, 0, 0, 0, 0, 0) != 0)
 		printk(KERN_WARNING "ath6kl: failed to disable scan "
 		       "during suspend\n");
 
@@ -976,7 +976,7 @@ void ath6kl_deep_sleep_enable(struct ath6kl *ar)
 	/* save the current power mode before enabling power save */
 	ar->wmi->saved_pwr_mode = ar->wmi->pwr_mode;
 
-	if (ath6kl_wmi_powermode_cmd(ar->wmi, REC_POWER) != 0)
+	if (ath6kl_wmi_powermode_cmd(ar->wmi, 0, REC_POWER) != 0)
 		ath6kl_warn("ath6kl_deep_sleep_enable: "
 			"wmi_powermode_cmd failed\n");
 }
@@ -1061,7 +1061,8 @@ void ath6kl_connect_event(struct ath6kl *ar, u16 channel, u8 *bssid,
 	vif->bss_ch = channel;
 
 	if ((vif->nw_type == INFRA_NETWORK))
-		ath6kl_wmi_listeninterval_cmd(ar->wmi, ar->listen_intvl_t,
+		ath6kl_wmi_listeninterval_cmd(ar->wmi, vif->fw_vif_idx,
+					      ar->listen_intvl_t,
 					      ar->listen_intvl_b);
 
 	netif_wake_queue(ar->net_dev);
@@ -1280,6 +1281,8 @@ void ath6kl_pspoll_event(struct ath6kl *ar, u8 aid)
 	struct ath6kl_sta *conn;
 	struct sk_buff *skb;
 	bool psq_empty = false;
+	/* TODO: Pass vif instead of taking it from ar */
+	struct ath6kl_vif *vif = ar->vif;
 
 	conn = ath6kl_find_sta_by_aid(ar, aid);
 
@@ -1310,7 +1313,7 @@ void ath6kl_pspoll_event(struct ath6kl *ar, u8 aid)
 	spin_unlock_bh(&conn->psq_lock);
 
 	if (psq_empty)
-		ath6kl_wmi_set_pvb_cmd(ar->wmi, conn->aid, 0);
+		ath6kl_wmi_set_pvb_cmd(ar->wmi, vif->fw_vif_idx, conn->aid, 0);
 }
 
 void ath6kl_dtimexpiry_event(struct ath6kl *ar)
@@ -1355,7 +1358,7 @@ void ath6kl_dtimexpiry_event(struct ath6kl *ar)
 	clear_bit(DTIM_EXPIRED, &vif->flags);
 
 	/* clear the LSB of the BitMapCtl field of the TIM IE */
-	ath6kl_wmi_set_pvb_cmd(ar->wmi, MCAST_AID, 0);
+	ath6kl_wmi_set_pvb_cmd(ar->wmi, vif->fw_vif_idx, MCAST_AID, 0);
 }
 
 void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
@@ -1377,7 +1380,8 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 
 			/* clear the LSB of the TIM IE's BitMapCtl field */
 			if (test_bit(WMI_READY, &ar->flag))
-				ath6kl_wmi_set_pvb_cmd(ar->wmi, MCAST_AID, 0);
+				ath6kl_wmi_set_pvb_cmd(ar->wmi, vif->fw_vif_idx,
+						       MCAST_AID, 0);
 		}
 
 		if (!is_broadcast_ether_addr(bssid)) {
@@ -1468,11 +1472,11 @@ static int ath6kl_close(struct net_device *dev)
 
 	netif_stop_queue(dev);
 
-	ath6kl_disconnect(ar);
+	ath6kl_disconnect(ar, vif->fw_vif_idx);
 
 	if (test_bit(WMI_READY, &ar->flag)) {
-		if (ath6kl_wmi_scanparams_cmd(ar->wmi, 0xFFFF, 0, 0, 0, 0, 0, 0,
-					      0, 0, 0))
+		if (ath6kl_wmi_scanparams_cmd(ar->wmi, vif->fw_vif_idx, 0xFFFF,
+					      0, 0, 0, 0, 0, 0, 0, 0, 0))
 			return -EIO;
 
 		clear_bit(WLAN_ENABLED, &vif->flags);
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 4e43878..f73e14f 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -747,7 +747,7 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar)
 static int ath6kl_sdio_resume(struct ath6kl *ar)
 {
 	if (ar->wmi->pwr_mode != ar->wmi->saved_pwr_mode) {
-		if (ath6kl_wmi_powermode_cmd(ar->wmi,
+		if (ath6kl_wmi_powermode_cmd(ar->wmi, 0,
 			ar->wmi->saved_pwr_mode) != 0)
 			ath6kl_warn("ath6kl_sdio_resume: "
 				"wmi_powermode_cmd failed\n");
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index cada197..c54f1a9 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -118,6 +118,7 @@ static bool ath6kl_powersave_ap(struct ath6kl *ar, struct sk_buff *skb,
 				 */
 				if (is_mcastq_empty)
 					ath6kl_wmi_set_pvb_cmd(ar->wmi,
+							       vif->fw_vif_idx,
 							       MCAST_AID, 1);
 
 				ps_queued = true;
@@ -156,6 +157,7 @@ static bool ath6kl_powersave_ap(struct ath6kl *ar, struct sk_buff *skb,
 				 */
 				if (is_psq_empty)
 					ath6kl_wmi_set_pvb_cmd(ar->wmi,
+							       vif->fw_vif_idx,
 							       conn->aid, 1);
 
 				ps_queued = true;
@@ -1176,7 +1178,8 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 				}
 				spin_unlock_bh(&conn->psq_lock);
 				/* Clear the PVB for this STA */
-				ath6kl_wmi_set_pvb_cmd(ar->wmi, conn->aid, 0);
+				ath6kl_wmi_set_pvb_cmd(ar->wmi, vif->fw_vif_idx,
+						       conn->aid, 0);
 			}
 		}
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 8e7e7b5..a4ad7cb 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -627,7 +627,8 @@ static inline struct sk_buff *ath6kl_wmi_get_new_buf(u32 size)
 }
 
 /* Send a "simple" wmi command -- one with no arguments */
-static int ath6kl_wmi_simple_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id)
+static int ath6kl_wmi_simple_cmd(struct wmi *wmi, u8 if_idx,
+				 enum wmi_cmd_id cmd_id)
 {
 	struct sk_buff *skb;
 	int ret;
@@ -636,7 +637,7 @@ static int ath6kl_wmi_simple_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id)
 	if (!skb)
 		return -ENOMEM;
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, cmd_id, NO_SYNC_WMIFLAG);
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, cmd_id, NO_SYNC_WMIFLAG);
 
 	return ret;
 }
@@ -679,7 +680,8 @@ int ath6kl_wmi_set_roam_lrssi_cmd(struct wmi *wmi, u8 lrssi)
 	cmd->info.params.roam_rssi_floor = DEF_LRSSI_ROAM_FLOOR;
 	cmd->roam_ctrl = WMI_SET_LRSSI_SCAN_PARAMS;
 
-	ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_ROAM_CTRL_CMDID, NO_SYNC_WMIFLAG);
+	ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_ROAM_CTRL_CMDID,
+			    NO_SYNC_WMIFLAG);
 
 	return 0;
 }
@@ -700,7 +702,7 @@ int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid)
 	cmd->roam_ctrl = WMI_FORCE_ROAM;
 
 	ath6kl_dbg(ATH6KL_DBG_WMI, "force roam to %pM\n", bssid);
-	return ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_ROAM_CTRL_CMDID,
+	return ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_ROAM_CTRL_CMDID,
 				   NO_SYNC_WMIFLAG);
 }
 
@@ -720,7 +722,7 @@ int ath6kl_wmi_set_roam_mode_cmd(struct wmi *wmi, enum wmi_roam_mode mode)
 	cmd->roam_ctrl = WMI_SET_ROAM_MODE;
 
 	ath6kl_dbg(ATH6KL_DBG_WMI, "set roam mode %d\n", mode);
-	return ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_ROAM_CTRL_CMDID,
+	return ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_ROAM_CTRL_CMDID,
 				   NO_SYNC_WMIFLAG);
 }
 
@@ -1270,7 +1272,7 @@ static int ath6kl_wmi_send_rssi_threshold_params(struct wmi *wmi,
 	cmd = (struct wmi_rssi_threshold_params_cmd *) skb->data;
 	memcpy(cmd, rssi_cmd, sizeof(struct wmi_rssi_threshold_params_cmd));
 
-	return ath6kl_wmi_cmd_send(wmi, skb, WMI_RSSI_THRESHOLD_PARAMS_CMDID,
+	return ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_RSSI_THRESHOLD_PARAMS_CMDID,
 				   NO_SYNC_WMIFLAG);
 }
 
@@ -1451,7 +1453,7 @@ static int ath6kl_wmi_send_snr_threshold_params(struct wmi *wmi,
 	cmd = (struct wmi_snr_threshold_params_cmd *) skb->data;
 	memcpy(cmd, snr_cmd, sizeof(struct wmi_snr_threshold_params_cmd));
 
-	return ath6kl_wmi_cmd_send(wmi, skb, WMI_SNR_THRESHOLD_PARAMS_CMDID,
+	return ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SNR_THRESHOLD_PARAMS_CMDID,
 				   NO_SYNC_WMIFLAG);
 }
 
@@ -1576,14 +1578,15 @@ static int ath6kl_wmi_aplist_event_rx(struct wmi *wmi, u8 *datap, int len)
 	return 0;
 }
 
-int ath6kl_wmi_cmd_send(struct wmi *wmi, struct sk_buff *skb,
+int ath6kl_wmi_cmd_send(struct wmi *wmi, u8 if_idx, struct sk_buff *skb,
 			enum wmi_cmd_id cmd_id, enum wmi_sync_flag sync_flag)
 {
 	struct wmi_cmd_hdr *cmd_hdr;
 	enum htc_endpoint_id ep_id = wmi->ep_id;
 	int ret;
+	u16 info1;
 
-	if (WARN_ON(skb == NULL))
+	if (WARN_ON(skb == NULL || (if_idx > (MAX_NUM_VIF - 1))))
 		return -EINVAL;
 
 	ath6kl_dbg(ATH6KL_DBG_WMI, "wmi tx id %d len %d flag %d\n",
@@ -1609,7 +1612,8 @@ int ath6kl_wmi_cmd_send(struct wmi *wmi, struct sk_buff *skb,
 
 	cmd_hdr = (struct wmi_cmd_hdr *) skb->data;
 	cmd_hdr->cmd_id = cpu_to_le16(cmd_id);
-	cmd_hdr->info1 = 0;	/* added for virtual interface */
+	info1 = if_idx & WMI_CMD_HDR_IF_ID_MASK;
+	cmd_hdr->info1 = cpu_to_le16(info1);
 
 	/* Only for OPT_TX_CMD, use BE endpoint. */
 	if (cmd_id == WMI_OPT_TX_FRAME_CMDID) {
@@ -1636,7 +1640,8 @@ int ath6kl_wmi_cmd_send(struct wmi *wmi, struct sk_buff *skb,
 	return 0;
 }
 
-int ath6kl_wmi_connect_cmd(struct wmi *wmi, enum network_type nw_type,
+int ath6kl_wmi_connect_cmd(struct wmi *wmi, u8 if_idx,
+			   enum network_type nw_type,
 			   enum dot11_auth_mode dot11_auth_mode,
 			   enum auth_mode auth_mode,
 			   enum crypto_type pairwise_crypto,
@@ -1687,12 +1692,14 @@ int ath6kl_wmi_connect_cmd(struct wmi *wmi, enum network_type nw_type,
 	if (bssid != NULL)
 		memcpy(cc->bssid, bssid, ETH_ALEN);
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_CONNECT_CMDID, NO_SYNC_WMIFLAG);
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_CONNECT_CMDID,
+				  NO_SYNC_WMIFLAG);
 
 	return ret;
 }
 
-int ath6kl_wmi_reconnect_cmd(struct wmi *wmi, u8 *bssid, u16 channel)
+int ath6kl_wmi_reconnect_cmd(struct wmi *wmi, u8 if_idx, u8 *bssid,
+			     u16 channel)
 {
 	struct sk_buff *skb;
 	struct wmi_reconnect_cmd *cc;
@@ -1713,13 +1720,13 @@ int ath6kl_wmi_reconnect_cmd(struct wmi *wmi, u8 *bssid, u16 channel)
 	if (bssid != NULL)
 		memcpy(cc->bssid, bssid, ETH_ALEN);
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_RECONNECT_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_RECONNECT_CMDID,
 				  NO_SYNC_WMIFLAG);
 
 	return ret;
 }
 
-int ath6kl_wmi_disconnect_cmd(struct wmi *wmi)
+int ath6kl_wmi_disconnect_cmd(struct wmi *wmi, u8 if_idx)
 {
 	int ret;
 
@@ -1728,12 +1735,13 @@ int ath6kl_wmi_disconnect_cmd(struct wmi *wmi)
 	wmi->traffic_class = 100;
 
 	/* Disconnect command does not need to do a SYNC before. */
-	ret = ath6kl_wmi_simple_cmd(wmi, WMI_DISCONNECT_CMDID);
+	ret = ath6kl_wmi_simple_cmd(wmi, if_idx, WMI_DISCONNECT_CMDID);
 
 	return ret;
 }
 
-int ath6kl_wmi_startscan_cmd(struct wmi *wmi, enum wmi_scan_type scan_type,
+int ath6kl_wmi_startscan_cmd(struct wmi *wmi, u8 if_idx,
+			     enum wmi_scan_type scan_type,
 			     u32 force_fgscan, u32 is_legacy,
 			     u32 home_dwell_time, u32 force_scan_interval,
 			     s8 num_chan, u16 *ch_list)
@@ -1769,13 +1777,14 @@ int ath6kl_wmi_startscan_cmd(struct wmi *wmi, enum wmi_scan_type scan_type,
 	for (i = 0; i < num_chan; i++)
 		sc->ch_list[i] = cpu_to_le16(ch_list[i]);
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_START_SCAN_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_START_SCAN_CMDID,
 				  NO_SYNC_WMIFLAG);
 
 	return ret;
 }
 
-int ath6kl_wmi_scanparams_cmd(struct wmi *wmi, u16 fg_start_sec,
+int ath6kl_wmi_scanparams_cmd(struct wmi *wmi, u8 if_idx,
+			      u16 fg_start_sec,
 			      u16 fg_end_sec, u16 bg_sec,
 			      u16 minact_chdw_msec, u16 maxact_chdw_msec,
 			      u16 pas_chdw_msec, u8 short_scan_ratio,
@@ -1802,7 +1811,7 @@ int ath6kl_wmi_scanparams_cmd(struct wmi *wmi, u16 fg_start_sec,
 	sc->max_dfsch_act_time = cpu_to_le32(max_dfsch_act_time);
 	sc->maxact_scan_per_ssid = cpu_to_le16(maxact_scan_per_ssid);
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_SCAN_PARAMS_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SET_SCAN_PARAMS_CMDID,
 				  NO_SYNC_WMIFLAG);
 	return ret;
 }
@@ -1824,12 +1833,12 @@ int ath6kl_wmi_bssfilter_cmd(struct wmi *wmi, u8 filter, u32 ie_mask)
 	cmd->bss_filter = filter;
 	cmd->ie_mask = cpu_to_le32(ie_mask);
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_BSS_FILTER_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_BSS_FILTER_CMDID,
 				  NO_SYNC_WMIFLAG);
 	return ret;
 }
 
-int ath6kl_wmi_probedssid_cmd(struct wmi *wmi, u8 index, u8 flag,
+int ath6kl_wmi_probedssid_cmd(struct wmi *wmi, u8 if_idx, u8 index, u8 flag,
 			      u8 ssid_len, u8 *ssid)
 {
 	struct sk_buff *skb;
@@ -1861,12 +1870,13 @@ int ath6kl_wmi_probedssid_cmd(struct wmi *wmi, u8 index, u8 flag,
 	cmd->ssid_len = ssid_len;
 	memcpy(cmd->ssid, ssid, ssid_len);
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_PROBED_SSID_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SET_PROBED_SSID_CMDID,
 				  NO_SYNC_WMIFLAG);
 	return ret;
 }
 
-int ath6kl_wmi_listeninterval_cmd(struct wmi *wmi, u16 listen_interval,
+int ath6kl_wmi_listeninterval_cmd(struct wmi *wmi, u8 if_idx,
+				  u16 listen_interval,
 				  u16 listen_beacons)
 {
 	struct sk_buff *skb;
@@ -1881,12 +1891,12 @@ int ath6kl_wmi_listeninterval_cmd(struct wmi *wmi, u16 listen_interval,
 	cmd->listen_intvl = cpu_to_le16(listen_interval);
 	cmd->num_beacons = cpu_to_le16(listen_beacons);
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_LISTEN_INT_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SET_LISTEN_INT_CMDID,
 				  NO_SYNC_WMIFLAG);
 	return ret;
 }
 
-int ath6kl_wmi_powermode_cmd(struct wmi *wmi, u8 pwr_mode)
+int ath6kl_wmi_powermode_cmd(struct wmi *wmi, u8 if_idx, u8 pwr_mode)
 {
 	struct sk_buff *skb;
 	struct wmi_power_mode_cmd *cmd;
@@ -1900,7 +1910,7 @@ int ath6kl_wmi_powermode_cmd(struct wmi *wmi, u8 pwr_mode)
 	cmd->pwr_mode = pwr_mode;
 	wmi->pwr_mode = pwr_mode;
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_POWER_MODE_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SET_POWER_MODE_CMDID,
 				  NO_SYNC_WMIFLAG);
 	return ret;
 }
@@ -1926,7 +1936,7 @@ int ath6kl_wmi_pmparams_cmd(struct wmi *wmi, u16 idle_period,
 	pm->num_tx_to_wakeup = cpu_to_le16(num_tx_to_wakeup);
 	pm->ps_fail_event_policy = cpu_to_le16(ps_fail_event_policy);
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_POWER_PARAMS_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_POWER_PARAMS_CMDID,
 				  NO_SYNC_WMIFLAG);
 	return ret;
 }
@@ -1944,14 +1954,16 @@ int ath6kl_wmi_disctimeout_cmd(struct wmi *wmi, u8 timeout)
 	cmd = (struct wmi_disc_timeout_cmd *) skb->data;
 	cmd->discon_timeout = timeout;
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_DISC_TIMEOUT_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_DISC_TIMEOUT_CMDID,
 				  NO_SYNC_WMIFLAG);
+
 	if (ret == 0)
 		ath6kl_debug_set_disconnect_timeout(wmi->parent_dev, timeout);
+
 	return ret;
 }
 
-int ath6kl_wmi_addkey_cmd(struct wmi *wmi, u8 key_index,
+int ath6kl_wmi_addkey_cmd(struct wmi *wmi, u8 if_idx, u8 key_index,
 			  enum crypto_type key_type,
 			  u8 key_usage, u8 key_len,
 			  u8 *key_rsc, u8 *key_material,
@@ -1992,7 +2004,7 @@ int ath6kl_wmi_addkey_cmd(struct wmi *wmi, u8 key_index,
 	if (mac_addr)
 		memcpy(cmd->key_mac_addr, mac_addr, ETH_ALEN);
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_ADD_CIPHER_KEY_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_ADD_CIPHER_KEY_CMDID,
 				  sync_flag);
 
 	return ret;
@@ -2011,12 +2023,13 @@ int ath6kl_wmi_add_krk_cmd(struct wmi *wmi, u8 *krk)
 	cmd = (struct wmi_add_krk_cmd *) skb->data;
 	memcpy(cmd->krk, krk, WMI_KRK_LEN);
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_ADD_KRK_CMDID, NO_SYNC_WMIFLAG);
+	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_ADD_KRK_CMDID,
+				  NO_SYNC_WMIFLAG);
 
 	return ret;
 }
 
-int ath6kl_wmi_deletekey_cmd(struct wmi *wmi, u8 key_index)
+int ath6kl_wmi_deletekey_cmd(struct wmi *wmi, u8 if_idx, u8 key_index)
 {
 	struct sk_buff *skb;
 	struct wmi_delete_cipher_key_cmd *cmd;
@@ -2032,13 +2045,13 @@ int ath6kl_wmi_deletekey_cmd(struct wmi *wmi, u8 key_index)
 	cmd = (struct wmi_delete_cipher_key_cmd *) skb->data;
 	cmd->key_index = key_index;
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_DELETE_CIPHER_KEY_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_DELETE_CIPHER_KEY_CMDID,
 				  NO_SYNC_WMIFLAG);
 
 	return ret;
 }
 
-int ath6kl_wmi_setpmkid_cmd(struct wmi *wmi, const u8 *bssid,
+int ath6kl_wmi_setpmkid_cmd(struct wmi *wmi, u8 if_idx, const u8 *bssid,
 			    const u8 *pmkid, bool set)
 {
 	struct sk_buff *skb;
@@ -2065,7 +2078,7 @@ int ath6kl_wmi_setpmkid_cmd(struct wmi *wmi, const u8 *bssid,
 		cmd->enable = PMKID_DISABLE;
 	}
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_PMKID_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SET_PMKID_CMDID,
 				  NO_SYNC_WMIFLAG);
 
 	return ret;
@@ -2147,7 +2160,7 @@ static int ath6kl_wmi_sync_point(struct wmi *wmi)
 	 * Send sync cmd followed by sync data messages on all
 	 * endpoints being used
 	 */
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SYNCHRONIZE_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SYNCHRONIZE_CMDID,
 				  NO_SYNC_WMIFLAG);
 
 	if (ret)
@@ -2278,7 +2291,7 @@ int ath6kl_wmi_create_pstream_cmd(struct wmi *wmi,
 		ath6kl_indicate_tx_activity(wmi->parent_dev,
 					    params->traffic_class, true);
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_CREATE_PSTREAM_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_CREATE_PSTREAM_CMDID,
 				  NO_SYNC_WMIFLAG);
 	return ret;
 }
@@ -2319,7 +2332,7 @@ int ath6kl_wmi_delete_pstream_cmd(struct wmi *wmi, u8 traffic_class, u8 tsid)
 		   "sending delete_pstream_cmd: traffic class: %d tsid=%d\n",
 		   traffic_class, tsid);
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_DELETE_PSTREAM_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_DELETE_PSTREAM_CMDID,
 				  SYNC_BEFORE_WMIFLAG);
 
 	spin_lock_bh(&wmi->lock);
@@ -2358,7 +2371,8 @@ int ath6kl_wmi_set_ip_cmd(struct wmi *wmi, struct wmi_set_ip_cmd *ip_cmd)
 	cmd = (struct wmi_set_ip_cmd *) skb->data;
 	memcpy(cmd, ip_cmd, sizeof(struct wmi_set_ip_cmd));
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_IP_CMDID, NO_SYNC_WMIFLAG);
+	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_IP_CMDID,
+				  NO_SYNC_WMIFLAG);
 	return ret;
 }
 
@@ -2383,7 +2397,7 @@ static int ath6kl_wmi_cmd_send_xtnd(struct wmi *wmi, struct sk_buff *skb,
 	cmd_hdr = (struct wmix_cmd_hdr *) skb->data;
 	cmd_hdr->cmd_id = cpu_to_le32(cmd_id);
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_EXTENSION_CMDID, sync_flag);
+	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_EXTENSION_CMDID, sync_flag);
 
 	return ret;
 }
@@ -2426,9 +2440,9 @@ int ath6kl_wmi_config_debug_module_cmd(struct wmi *wmi, u32 valid, u32 config)
 	return ret;
 }
 
-int ath6kl_wmi_get_stats_cmd(struct wmi *wmi)
+int ath6kl_wmi_get_stats_cmd(struct wmi *wmi, u8 if_idx)
 {
-	return ath6kl_wmi_simple_cmd(wmi, WMI_GET_STATISTICS_CMDID);
+	return ath6kl_wmi_simple_cmd(wmi, if_idx, WMI_GET_STATISTICS_CMDID);
 }
 
 int ath6kl_wmi_set_tx_pwr_cmd(struct wmi *wmi, u8 dbM)
@@ -2444,7 +2458,7 @@ int ath6kl_wmi_set_tx_pwr_cmd(struct wmi *wmi, u8 dbM)
 	cmd = (struct wmi_set_tx_pwr_cmd *) skb->data;
 	cmd->dbM = dbM;
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_TX_PWR_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_TX_PWR_CMDID,
 				  NO_SYNC_WMIFLAG);
 
 	return ret;
@@ -2452,12 +2466,12 @@ int ath6kl_wmi_set_tx_pwr_cmd(struct wmi *wmi, u8 dbM)
 
 int ath6kl_wmi_get_tx_pwr_cmd(struct wmi *wmi)
 {
-	return ath6kl_wmi_simple_cmd(wmi, WMI_GET_TX_PWR_CMDID);
+	return ath6kl_wmi_simple_cmd(wmi, 0, WMI_GET_TX_PWR_CMDID);
 }
 
 int ath6kl_wmi_get_roam_tbl_cmd(struct wmi *wmi)
 {
-	return ath6kl_wmi_simple_cmd(wmi, WMI_GET_ROAM_TBL_CMDID);
+	return ath6kl_wmi_simple_cmd(wmi, 0, WMI_GET_ROAM_TBL_CMDID);
 }
 
 int ath6kl_wmi_set_lpreamble_cmd(struct wmi *wmi, u8 status, u8 preamble_policy)
@@ -2474,7 +2488,7 @@ int ath6kl_wmi_set_lpreamble_cmd(struct wmi *wmi, u8 status, u8 preamble_policy)
 	cmd->status = status;
 	cmd->preamble_policy = preamble_policy;
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_LPREAMBLE_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_LPREAMBLE_CMDID,
 				  NO_SYNC_WMIFLAG);
 	return ret;
 }
@@ -2492,7 +2506,8 @@ int ath6kl_wmi_set_rts_cmd(struct wmi *wmi, u16 threshold)
 	cmd = (struct wmi_set_rts_cmd *) skb->data;
 	cmd->threshold = cpu_to_le16(threshold);
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_RTS_CMDID, NO_SYNC_WMIFLAG);
+	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_RTS_CMDID,
+				  NO_SYNC_WMIFLAG);
 	return ret;
 }
 
@@ -2512,7 +2527,7 @@ int ath6kl_wmi_set_wmm_txop(struct wmi *wmi, enum wmi_txop_cfg cfg)
 	cmd = (struct wmi_set_wmm_txop_cmd *) skb->data;
 	cmd->txop_enable = cfg;
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_WMM_TXOP_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_WMM_TXOP_CMDID,
 				  NO_SYNC_WMIFLAG);
 	return ret;
 }
@@ -2530,10 +2545,12 @@ int ath6kl_wmi_set_keepalive_cmd(struct wmi *wmi, u8 keep_alive_intvl)
 	cmd = (struct wmi_set_keepalive_cmd *) skb->data;
 	cmd->keep_alive_intvl = keep_alive_intvl;
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_KEEPALIVE_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_KEEPALIVE_CMDID,
 				  NO_SYNC_WMIFLAG);
+
 	if (ret == 0)
 		ath6kl_debug_set_keepalive(wmi->parent_dev, keep_alive_intvl);
+
 	return ret;
 }
 
@@ -2548,7 +2565,7 @@ int ath6kl_wmi_test_cmd(struct wmi *wmi, void *buf, size_t len)
 
 	memcpy(skb->data, buf, len);
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_TEST_CMDID, NO_SYNC_WMIFLAG);
+	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_TEST_CMDID, NO_SYNC_WMIFLAG);
 
 	return ret;
 }
@@ -2602,7 +2619,8 @@ static int ath6kl_wmi_delba_req_event_rx(struct wmi *wmi, u8 *datap, int len)
 
 /*  AP mode functions */
 
-int ath6kl_wmi_ap_profile_commit(struct wmi *wmip, struct wmi_connect_cmd *p)
+int ath6kl_wmi_ap_profile_commit(struct wmi *wmip, u8 if_idx,
+				 struct wmi_connect_cmd *p)
 {
 	struct sk_buff *skb;
 	struct wmi_connect_cmd *cm;
@@ -2615,7 +2633,7 @@ int ath6kl_wmi_ap_profile_commit(struct wmi *wmip, struct wmi_connect_cmd *p)
 	cm = (struct wmi_connect_cmd *) skb->data;
 	memcpy(cm, p, sizeof(*cm));
 
-	res = ath6kl_wmi_cmd_send(wmip, skb, WMI_AP_CONFIG_COMMIT_CMDID,
+	res = ath6kl_wmi_cmd_send(wmip, if_idx, skb, WMI_AP_CONFIG_COMMIT_CMDID,
 				  NO_SYNC_WMIFLAG);
 	ath6kl_dbg(ATH6KL_DBG_WMI, "%s: nw_type=%u auth_mode=%u ch=%u "
 		   "ctrl_flags=0x%x-> res=%d\n",
@@ -2624,7 +2642,8 @@ int ath6kl_wmi_ap_profile_commit(struct wmi *wmip, struct wmi_connect_cmd *p)
 	return res;
 }
 
-int ath6kl_wmi_ap_set_mlme(struct wmi *wmip, u8 cmd, const u8 *mac, u16 reason)
+int ath6kl_wmi_ap_set_mlme(struct wmi *wmip, u8 if_idx, u8 cmd, const u8 *mac,
+			   u16 reason)
 {
 	struct sk_buff *skb;
 	struct wmi_ap_set_mlme_cmd *cm;
@@ -2638,7 +2657,7 @@ int ath6kl_wmi_ap_set_mlme(struct wmi *wmip, u8 cmd, const u8 *mac, u16 reason)
 	cm->reason = cpu_to_le16(reason);
 	cm->cmd = cmd;
 
-	return ath6kl_wmi_cmd_send(wmip, skb, WMI_AP_SET_MLME_CMDID,
+	return ath6kl_wmi_cmd_send(wmip, if_idx, skb, WMI_AP_SET_MLME_CMDID,
 				   NO_SYNC_WMIFLAG);
 }
 
@@ -2663,7 +2682,8 @@ static int ath6kl_wmi_dtimexpiry_event_rx(struct wmi *wmi, u8 *datap, int len)
 	return 0;
 }
 
-int ath6kl_wmi_set_pvb_cmd(struct wmi *wmi, u16 aid, bool flag)
+int ath6kl_wmi_set_pvb_cmd(struct wmi *wmi, u8 if_idx, u16 aid,
+			   bool flag)
 {
 	struct sk_buff *skb;
 	struct wmi_ap_set_pvb_cmd *cmd;
@@ -2678,7 +2698,7 @@ int ath6kl_wmi_set_pvb_cmd(struct wmi *wmi, u16 aid, bool flag)
 	cmd->rsvd = cpu_to_le16(0);
 	cmd->flag = cpu_to_le32(flag);
 
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_AP_SET_PVB_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_AP_SET_PVB_CMDID,
 				  NO_SYNC_WMIFLAG);
 
 	return 0;
@@ -2701,14 +2721,14 @@ int ath6kl_wmi_set_rx_frame_format_cmd(struct wmi *wmi, u8 rx_meta_ver,
 	cmd->meta_ver = rx_meta_ver;
 
 	/* Delete the local aggr state, on host */
-	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_RX_FRAME_FORMAT_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_RX_FRAME_FORMAT_CMDID,
 				  NO_SYNC_WMIFLAG);
 
 	return ret;
 }
 
-int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 mgmt_frm_type, const u8 *ie,
-			     u8 ie_len)
+int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 if_idx, u8 mgmt_frm_type,
+			     const u8 *ie, u8 ie_len)
 {
 	struct sk_buff *skb;
 	struct wmi_set_appie_cmd *p;
@@ -2723,7 +2743,7 @@ int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 mgmt_frm_type, const u8 *ie,
 	p->mgmt_frm_type = mgmt_frm_type;
 	p->ie_len = ie_len;
 	memcpy(p->ie_info, ie, ie_len);
-	return ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_APPIE_CMDID,
+	return ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SET_APPIE_CMDID,
 				   NO_SYNC_WMIFLAG);
 }
 
@@ -2741,11 +2761,11 @@ int ath6kl_wmi_disable_11b_rates_cmd(struct wmi *wmi, bool disable)
 	cmd = (struct wmi_disable_11b_rates_cmd *) skb->data;
 	cmd->disable = disable ? 1 : 0;
 
-	return ath6kl_wmi_cmd_send(wmi, skb, WMI_DISABLE_11B_RATES_CMDID,
+	return ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_DISABLE_11B_RATES_CMDID,
 				   NO_SYNC_WMIFLAG);
 }
 
-int ath6kl_wmi_remain_on_chnl_cmd(struct wmi *wmi, u32 freq, u32 dur)
+int ath6kl_wmi_remain_on_chnl_cmd(struct wmi *wmi, u8 if_idx, u32 freq, u32 dur)
 {
 	struct sk_buff *skb;
 	struct wmi_remain_on_chnl_cmd *p;
@@ -2759,12 +2779,12 @@ int ath6kl_wmi_remain_on_chnl_cmd(struct wmi *wmi, u32 freq, u32 dur)
 	p = (struct wmi_remain_on_chnl_cmd *) skb->data;
 	p->freq = cpu_to_le32(freq);
 	p->duration = cpu_to_le32(dur);
-	return ath6kl_wmi_cmd_send(wmi, skb, WMI_REMAIN_ON_CHNL_CMDID,
+	return ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_REMAIN_ON_CHNL_CMDID,
 				   NO_SYNC_WMIFLAG);
 }
 
-int ath6kl_wmi_send_action_cmd(struct wmi *wmi, u32 id, u32 freq, u32 wait,
-			       const u8 *data, u16 data_len)
+int ath6kl_wmi_send_action_cmd(struct wmi *wmi, u8 if_idx, u32 id, u32 freq,
+			       u32 wait, const u8 *data, u16 data_len)
 {
 	struct sk_buff *skb;
 	struct wmi_send_action_cmd *p;
@@ -2795,13 +2815,13 @@ int ath6kl_wmi_send_action_cmd(struct wmi *wmi, u32 id, u32 freq, u32 wait,
 	p->wait = cpu_to_le32(wait);
 	p->len = cpu_to_le16(data_len);
 	memcpy(p->data, data, data_len);
-	return ath6kl_wmi_cmd_send(wmi, skb, WMI_SEND_ACTION_CMDID,
+	return ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SEND_ACTION_CMDID,
 				   NO_SYNC_WMIFLAG);
 }
 
-int ath6kl_wmi_send_probe_response_cmd(struct wmi *wmi, u32 freq,
-				       const u8 *dst,
-				       const u8 *data, u16 data_len)
+int ath6kl_wmi_send_probe_response_cmd(struct wmi *wmi, u8 if_idx, u32 freq,
+				       const u8 *dst, const u8 *data,
+				       u16 data_len)
 {
 	struct sk_buff *skb;
 	struct wmi_p2p_probe_response_cmd *p;
@@ -2817,7 +2837,8 @@ int ath6kl_wmi_send_probe_response_cmd(struct wmi *wmi, u32 freq,
 	memcpy(p->destination_addr, dst, ETH_ALEN);
 	p->len = cpu_to_le16(data_len);
 	memcpy(p->data, data, data_len);
-	return ath6kl_wmi_cmd_send(wmi, skb, WMI_SEND_PROBE_RESPONSE_CMDID,
+	return ath6kl_wmi_cmd_send(wmi, if_idx, skb,
+				   WMI_SEND_PROBE_RESPONSE_CMDID,
 				   NO_SYNC_WMIFLAG);
 }
 
@@ -2834,7 +2855,7 @@ int ath6kl_wmi_probe_report_req_cmd(struct wmi *wmi, bool enable)
 		   enable);
 	p = (struct wmi_probe_req_report_cmd *) skb->data;
 	p->enable = enable ? 1 : 0;
-	return ath6kl_wmi_cmd_send(wmi, skb, WMI_PROBE_REQ_REPORT_CMDID,
+	return ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_PROBE_REQ_REPORT_CMDID,
 				   NO_SYNC_WMIFLAG);
 }
 
@@ -2851,14 +2872,15 @@ int ath6kl_wmi_info_req_cmd(struct wmi *wmi, u32 info_req_flags)
 		   info_req_flags);
 	p = (struct wmi_get_p2p_info *) skb->data;
 	p->info_req_flags = cpu_to_le32(info_req_flags);
-	return ath6kl_wmi_cmd_send(wmi, skb, WMI_GET_P2P_INFO_CMDID,
+	return ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_GET_P2P_INFO_CMDID,
 				   NO_SYNC_WMIFLAG);
 }
 
-int ath6kl_wmi_cancel_remain_on_chnl_cmd(struct wmi *wmi)
+int ath6kl_wmi_cancel_remain_on_chnl_cmd(struct wmi *wmi, u8 if_idx)
 {
 	ath6kl_dbg(ATH6KL_DBG_WMI, "cancel_remain_on_chnl_cmd\n");
-	return ath6kl_wmi_simple_cmd(wmi, WMI_CANCEL_REMAIN_ON_CHNL_CMDID);
+	return ath6kl_wmi_simple_cmd(wmi, if_idx,
+				     WMI_CANCEL_REMAIN_ON_CHNL_CMDID);
 }
 
 static int ath6kl_wmi_control_rx_xtnd(struct wmi *wmi, struct sk_buff *skb)
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index f0ca899..83bf46c 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -288,6 +288,8 @@ struct wmi_rx_meta_v2 {
 	u8 csum_flags;
 } __packed;
 
+#define WMI_CMD_HDR_IF_ID_MASK 0xF
+
 /* Control Path */
 struct wmi_cmd_hdr {
 	__le16 cmd_id;
@@ -2175,10 +2177,11 @@ int ath6kl_wmi_implicit_create_pstream(struct wmi *wmi, struct sk_buff *skb,
 
 int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb);
 
-int ath6kl_wmi_cmd_send(struct wmi *wmi, struct sk_buff *skb,
+int ath6kl_wmi_cmd_send(struct wmi *wmi, u8 if_idx, struct sk_buff *skb,
 			enum wmi_cmd_id cmd_id, enum wmi_sync_flag sync_flag);
 
-int ath6kl_wmi_connect_cmd(struct wmi *wmi, enum network_type nw_type,
+int ath6kl_wmi_connect_cmd(struct wmi *wmi, u8 if_idx,
+			   enum network_type nw_type,
 			   enum dot11_auth_mode dot11_auth_mode,
 			   enum auth_mode auth_mode,
 			   enum crypto_type pairwise_crypto,
@@ -2187,24 +2190,27 @@ int ath6kl_wmi_connect_cmd(struct wmi *wmi, enum network_type nw_type,
 			   u8 group_crypto_len, int ssid_len, u8 *ssid,
 			   u8 *bssid, u16 channel, u32 ctrl_flags);
 
-int ath6kl_wmi_reconnect_cmd(struct wmi *wmi, u8 *bssid, u16 channel);
-int ath6kl_wmi_disconnect_cmd(struct wmi *wmi);
-int ath6kl_wmi_startscan_cmd(struct wmi *wmi, enum wmi_scan_type scan_type,
+int ath6kl_wmi_reconnect_cmd(struct wmi *wmi, u8 if_idx, u8 *bssid,
+			     u16 channel);
+int ath6kl_wmi_disconnect_cmd(struct wmi *wmi, u8 if_idx);
+int ath6kl_wmi_startscan_cmd(struct wmi *wmi, u8 if_idx,
+			     enum wmi_scan_type scan_type,
 			     u32 force_fgscan, u32 is_legacy,
 			     u32 home_dwell_time, u32 force_scan_interval,
 			     s8 num_chan, u16 *ch_list);
-int ath6kl_wmi_scanparams_cmd(struct wmi *wmi, u16 fg_start_sec,
+int ath6kl_wmi_scanparams_cmd(struct wmi *wmi, u8 if_idx, u16 fg_start_sec,
 			      u16 fg_end_sec, u16 bg_sec,
 			      u16 minact_chdw_msec, u16 maxact_chdw_msec,
 			      u16 pas_chdw_msec, u8 short_scan_ratio,
 			      u8 scan_ctrl_flag, u32 max_dfsch_act_time,
 			      u16 maxact_scan_per_ssid);
 int ath6kl_wmi_bssfilter_cmd(struct wmi *wmi, u8 filter, u32 ie_mask);
-int ath6kl_wmi_probedssid_cmd(struct wmi *wmi, u8 index, u8 flag,
+int ath6kl_wmi_probedssid_cmd(struct wmi *wmi, u8 if_idx, u8 index, u8 flag,
 			      u8 ssid_len, u8 *ssid);
-int ath6kl_wmi_listeninterval_cmd(struct wmi *wmi, u16 listen_interval,
+int ath6kl_wmi_listeninterval_cmd(struct wmi *wmi, u8 if_idx,
+				  u16 listen_interval,
 				  u16 listen_beacons);
-int ath6kl_wmi_powermode_cmd(struct wmi *wmi, u8 pwr_mode);
+int ath6kl_wmi_powermode_cmd(struct wmi *wmi, u8 if_idx, u8 pwr_mode);
 int ath6kl_wmi_pmparams_cmd(struct wmi *wmi, u16 idle_period,
 			    u16 ps_poll_num, u16 dtim_policy,
 			    u16 tx_wakup_policy, u16 num_tx_to_wakeup,
@@ -2221,16 +2227,16 @@ int ath6kl_wmi_set_lpreamble_cmd(struct wmi *wmi, u8 status,
 int ath6kl_wmi_get_challenge_resp_cmd(struct wmi *wmi, u32 cookie, u32 source);
 int ath6kl_wmi_config_debug_module_cmd(struct wmi *wmi, u32 valid, u32 config);
 
-int ath6kl_wmi_get_stats_cmd(struct wmi *wmi);
-int ath6kl_wmi_addkey_cmd(struct wmi *wmi, u8 key_index,
+int ath6kl_wmi_get_stats_cmd(struct wmi *wmi, u8 if_idx);
+int ath6kl_wmi_addkey_cmd(struct wmi *wmi, u8 if_idx, u8 key_index,
 			  enum crypto_type key_type,
 			  u8 key_usage, u8 key_len,
 			  u8 *key_rsc, u8 *key_material,
 			  u8 key_op_ctrl, u8 *mac_addr,
 			  enum wmi_sync_flag sync_flag);
 int ath6kl_wmi_add_krk_cmd(struct wmi *wmi, u8 *krk);
-int ath6kl_wmi_deletekey_cmd(struct wmi *wmi, u8 key_index);
-int ath6kl_wmi_setpmkid_cmd(struct wmi *wmi, const u8 *bssid,
+int ath6kl_wmi_deletekey_cmd(struct wmi *wmi, u8 if_idx, u8 key_index);
+int ath6kl_wmi_setpmkid_cmd(struct wmi *wmi, u8 if_idx, const u8 *bssid,
 			    const u8 *pmkid, bool set);
 int ath6kl_wmi_set_tx_pwr_cmd(struct wmi *wmi, u8 dbM);
 int ath6kl_wmi_get_tx_pwr_cmd(struct wmi *wmi);
@@ -2248,38 +2254,41 @@ int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid);
 int ath6kl_wmi_set_roam_mode_cmd(struct wmi *wmi, enum wmi_roam_mode mode);
 
 /* AP mode */
-int ath6kl_wmi_ap_profile_commit(struct wmi *wmip, struct wmi_connect_cmd *p);
+int ath6kl_wmi_ap_profile_commit(struct wmi *wmip, u8 if_idx,
+				 struct wmi_connect_cmd *p);
 
-int ath6kl_wmi_ap_set_mlme(struct wmi *wmip, u8 cmd, const u8 *mac, u16 reason);
+int ath6kl_wmi_ap_set_mlme(struct wmi *wmip, u8 if_idx, u8 cmd,
+			   const u8 *mac, u16 reason);
 
-int ath6kl_wmi_set_pvb_cmd(struct wmi *wmi, u16 aid, bool flag);
+int ath6kl_wmi_set_pvb_cmd(struct wmi *wmi, u8 if_idx, u16 aid, bool flag);
 
 int ath6kl_wmi_set_rx_frame_format_cmd(struct wmi *wmi, u8 rx_meta_version,
 				       bool rx_dot11_hdr, bool defrag_on_host);
 
-int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 mgmt_frm_type, const u8 *ie,
-			     u8 ie_len);
+int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 if_idx, u8 mgmt_frm_type,
+			     const u8 *ie, u8 ie_len);
 
 /* P2P */
 int ath6kl_wmi_disable_11b_rates_cmd(struct wmi *wmi, bool disable);
 
-int ath6kl_wmi_remain_on_chnl_cmd(struct wmi *wmi, u32 freq, u32 dur);
+int ath6kl_wmi_remain_on_chnl_cmd(struct wmi *wmi, u8 if_idx, u32 freq,
+				  u32 dur);
 
-int ath6kl_wmi_send_action_cmd(struct wmi *wmi, u32 id, u32 freq, u32 wait,
-			       const u8 *data, u16 data_len);
+int ath6kl_wmi_send_action_cmd(struct wmi *wmi, u8 if_idx, u32 id, u32 freq,
+			       u32 wait, const u8 *data, u16 data_len);
 
-int ath6kl_wmi_send_probe_response_cmd(struct wmi *wmi, u32 freq,
-				       const u8 *dst,
-				       const u8 *data, u16 data_len);
+int ath6kl_wmi_send_probe_response_cmd(struct wmi *wmi, u8 if_idx, u32 freq,
+				       const u8 *dst, const u8 *data,
+				       u16 data_len);
 
 int ath6kl_wmi_probe_report_req_cmd(struct wmi *wmi, bool enable);
 
 int ath6kl_wmi_info_req_cmd(struct wmi *wmi, u32 info_req_flags);
 
-int ath6kl_wmi_cancel_remain_on_chnl_cmd(struct wmi *wmi);
+int ath6kl_wmi_cancel_remain_on_chnl_cmd(struct wmi *wmi, u8 if_idx);
 
-int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 mgmt_frm_type, const u8 *ie,
-			     u8 ie_len);
+int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 if_idx, u8 mgmt_frm_type,
+			     const u8 *ie, u8 ie_len);
 
 void *ath6kl_wmi_init(struct ath6kl *devt);
 void ath6kl_wmi_shutdown(struct wmi *wmi);
-- 
1.7.0.4

