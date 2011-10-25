Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8396 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab1JYKLW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:11:22 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <nataraja@qca.qualcomm.com>,
	<athiruve@qca.qualcomm.com>
Subject: [PATCH 08/34] ath6kl: Move nw_type to vif structure
Date: Tue, 25 Oct 2011 15:40:04 +0530
Message-ID: <1319537430-12459-9-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_121124_782294_5AB2BCF2)
In-Reply-To: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   42 ++++++++++++++-------------
 drivers/net/wireless/ath/ath6kl/core.h     |    4 +-
 drivers/net/wireless/ath/ath6kl/init.c     |    2 +-
 drivers/net/wireless/ath/ath6kl/main.c     |   20 ++++++++----
 drivers/net/wireless/ath/ath6kl/txrx.c     |   18 +++++++----
 drivers/net/wireless/ath/ath6kl/wmi.c      |    8 ++++-
 6 files changed, 55 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 11fd01f..89cdebf 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -443,7 +443,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		}
 	}
 
-	ar->nw_type = ar->next_mode;
+	vif->nw_type = vif->next_mode;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 		   "%s: connect called with authmode %d dot11 auth %d"
@@ -455,7 +455,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		   vif->grp_crypto_len, ar->ch_hint);
 
 	ar->reconnect_flag = 0;
-	status = ath6kl_wmi_connect_cmd(ar->wmi, ar->nw_type,
+	status = ath6kl_wmi_connect_cmd(ar->wmi, vif->nw_type,
 					vif->dot11_auth_mode, vif->auth_mode,
 					vif->prwise_crypto,
 					vif->prwise_crypto_len,
@@ -665,7 +665,7 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
 		ar->scan_req = NULL;
 	}
 
-	if (ar->nw_type & ADHOC_NETWORK) {
+	if (vif->nw_type & ADHOC_NETWORK) {
 		if (ar->wdev->iftype != NL80211_IFTYPE_ADHOC) {
 			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 				   "%s: ath6k not in ibss mode\n", __func__);
@@ -676,7 +676,7 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
 		return;
 	}
 
-	if (ar->nw_type & INFRA_NETWORK) {
+	if (vif->nw_type & INFRA_NETWORK) {
 		if (ar->wdev->iftype != NL80211_IFTYPE_STATION &&
 		    ar->wdev->iftype != NL80211_IFTYPE_P2P_CLIENT) {
 			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
@@ -906,7 +906,7 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	vif->def_txkey_index = key_index;
 
-	if (ar->nw_type == AP_NETWORK && !pairwise &&
+	if (vif->nw_type == AP_NETWORK && !pairwise &&
 	    (key_type == TKIP_CRYPT || key_type == AES_CRYPT) && params) {
 		ar->ap_mode_bkey.valid = true;
 		ar->ap_mode_bkey.key_index = key_index;
@@ -925,7 +925,7 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		}
 	}
 
-	if (ar->next_mode == AP_NETWORK && key_type == WEP_CRYPT &&
+	if (vif->next_mode == AP_NETWORK && key_type == WEP_CRYPT &&
 	    !test_bit(CONNECTED, &vif->flags)) {
 		/*
 		 * Store the key locally so that it can be re-configured after
@@ -1054,7 +1054,7 @@ static int ath6kl_cfg80211_set_default_key(struct wiphy *wiphy,
 	if (multicast)
 		key_type = vif->grp_crypto;
 
-	if (ar->next_mode == AP_NETWORK && !test_bit(CONNECTED, &vif->flags))
+	if (vif->next_mode == AP_NETWORK && !test_bit(CONNECTED, &vif->flags))
 		return 0; /* Delay until AP mode has been started */
 
 	status = ath6kl_wmi_addkey_cmd(ar->wmi, vif->def_txkey_index,
@@ -1201,6 +1201,7 @@ static int ath6kl_cfg80211_change_iface(struct wiphy *wiphy,
 {
 	struct ath6kl *ar = ath6kl_priv(ndev);
 	struct wireless_dev *wdev = ar->wdev;
+	struct ath6kl_vif *vif = netdev_priv(ndev);
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: type %u\n", __func__, type);
 
@@ -1209,19 +1210,19 @@ static int ath6kl_cfg80211_change_iface(struct wiphy *wiphy,
 
 	switch (type) {
 	case NL80211_IFTYPE_STATION:
-		ar->next_mode = INFRA_NETWORK;
+		vif->next_mode = INFRA_NETWORK;
 		break;
 	case NL80211_IFTYPE_ADHOC:
-		ar->next_mode = ADHOC_NETWORK;
+		vif->next_mode = ADHOC_NETWORK;
 		break;
 	case NL80211_IFTYPE_AP:
-		ar->next_mode = AP_NETWORK;
+		vif->next_mode = AP_NETWORK;
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
-		ar->next_mode = INFRA_NETWORK;
+		vif->next_mode = INFRA_NETWORK;
 		break;
 	case NL80211_IFTYPE_P2P_GO:
-		ar->next_mode = AP_NETWORK;
+		vif->next_mode = AP_NETWORK;
 		break;
 	default:
 		ath6kl_err("invalid interface type %u\n", type);
@@ -1278,7 +1279,7 @@ static int ath6kl_cfg80211_join_ibss(struct wiphy *wiphy,
 		ath6kl_set_cipher(ar, 0, false);
 	}
 
-	ar->nw_type = ar->next_mode;
+	vif->nw_type = vif->next_mode;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 		   "%s: connect called with authmode %d dot11 auth %d"
@@ -1289,7 +1290,7 @@ static int ath6kl_cfg80211_join_ibss(struct wiphy *wiphy,
 		   vif->prwise_crypto_len, vif->grp_crypto,
 		   vif->grp_crypto_len, ar->ch_hint);
 
-	status = ath6kl_wmi_connect_cmd(ar->wmi, ar->nw_type,
+	status = ath6kl_wmi_connect_cmd(ar->wmi, vif->nw_type,
 					vif->dot11_auth_mode, vif->auth_mode,
 					vif->prwise_crypto,
 					vif->prwise_crypto_len,
@@ -1476,7 +1477,7 @@ static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (test_bit(CONNECTED, &vif->flags) &&
 	    test_bit(DTIM_PERIOD_AVAIL, &vif->flags) &&
-	    ar->nw_type == INFRA_NETWORK) {
+	    vif->nw_type == INFRA_NETWORK) {
 		sinfo->filled |= STATION_INFO_BSS_PARAM;
 		sinfo->bss_param.flags = 0;
 		sinfo->bss_param.dtim_period = ar->assoc_bss_dtim_period;
@@ -1604,7 +1605,7 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 	if (!ath6kl_cfg80211_ready(ar))
 		return -EIO;
 
-	if (ar->next_mode != AP_NETWORK)
+	if (vif->next_mode != AP_NETWORK)
 		return -EOPNOTSUPP;
 
 	if (info->beacon_ies) {
@@ -1715,7 +1716,7 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 	ath6kl_set_cipher(ar, info->crypto.cipher_group, false);
 
 	p.nw_type = AP_NETWORK;
-	ar->nw_type = ar->next_mode;
+	vif->nw_type = vif->next_mode;
 
 	p.ssid_len = vif->ssid_len;
 	memcpy(p.ssid, vif->ssid, vif->ssid_len);
@@ -1746,7 +1747,7 @@ static int ath6kl_del_beacon(struct wiphy *wiphy, struct net_device *dev)
 	struct ath6kl *ar = ath6kl_priv(dev);
 	struct ath6kl_vif *vif = netdev_priv(dev);
 
-	if (ar->nw_type != AP_NETWORK)
+	if (vif->nw_type != AP_NETWORK)
 		return -EOPNOTSUPP;
 	if (!test_bit(CONNECTED, &vif->flags))
 		return -ENOTCONN;
@@ -1761,8 +1762,9 @@ static int ath6kl_change_station(struct wiphy *wiphy, struct net_device *dev,
 				 u8 *mac, struct station_parameters *params)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
 
-	if (ar->nw_type != AP_NETWORK)
+	if (vif->nw_type != AP_NETWORK)
 		return -EOPNOTSUPP;
 
 	/* Use this only for authorizing/unauthorizing a station */
@@ -1853,7 +1855,7 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 
 	mgmt = (const struct ieee80211_mgmt *) buf;
 	if (buf + len >= mgmt->u.probe_resp.variable &&
-	    ar->nw_type == AP_NETWORK && test_bit(CONNECTED, &vif->flags) &&
+	    vif->nw_type == AP_NETWORK && test_bit(CONNECTED, &vif->flags) &&
 	    ieee80211_is_probe_resp(mgmt->frame_control)) {
 		/*
 		 * Send Probe Response frame in AP mode using a separate WMI
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 02733d3..c3e2fd9 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -407,6 +407,8 @@ struct ath6kl_vif {
 	u8 grp_crypto;
 	u8 grp_crypto_len;
 	u8 def_txkey_index;
+	u8 next_mode;
+	u8 nw_type;
 };
 
 /* Flag info */
@@ -435,8 +437,6 @@ struct ath6kl {
 	struct ath6kl_vif *vif;
 	spinlock_t lock;
 	struct semaphore sem;
-	u8 next_mode;
-	u8 nw_type;
 	struct ath6kl_wep_key wep_key_list[WMI_MAX_KEY_INDEX + 1];
 	u8 bssid[ETH_ALEN];
 	u8 req_bssid[ETH_ALEN];
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 6d79024..ce2ed23 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -91,7 +91,7 @@ void ath6kl_init_profile_info(struct ath6kl *ar)
 	memset(ar->req_bssid, 0, sizeof(ar->req_bssid));
 	memset(ar->bssid, 0, sizeof(ar->bssid));
 	ar->bss_ch = 0;
-	ar->nw_type = ar->next_mode = INFRA_NETWORK;
+	vif->nw_type = vif->next_mode = INFRA_NETWORK;
 }
 
 static int ath6kl_set_host_app_area(struct ath6kl *ar)
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 55c2b46..a4ea392 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -22,10 +22,12 @@
 
 struct ath6kl_sta *ath6kl_find_sta(struct ath6kl *ar, u8 *node_addr)
 {
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
 	struct ath6kl_sta *conn = NULL;
 	u8 i, max_conn;
 
-	max_conn = (ar->nw_type == AP_NETWORK) ? AP_MAX_NUM_STA : 0;
+	max_conn = (vif->nw_type == AP_NETWORK) ? AP_MAX_NUM_STA : 0;
 
 	for (i = 0; i < max_conn; i++) {
 		if (memcmp(node_addr, ar->sta_list[i].mac, ETH_ALEN) == 0) {
@@ -461,7 +463,7 @@ void ath6kl_stop_endpoint(struct net_device *dev, bool keep_profile,
 		 */
 		if (discon_issued)
 			ath6kl_disconnect_event(ar, DISCONNECT_CMD,
-						(ar->nw_type & AP_NETWORK) ?
+						(vif->nw_type & AP_NETWORK) ?
 						bcast_mac : ar->bssid,
 						0, NULL, 0);
 
@@ -777,7 +779,7 @@ void ath6kl_connect_event(struct ath6kl *ar, u16 channel, u8 *bssid,
 	memcpy(ar->bssid, bssid, sizeof(ar->bssid));
 	ar->bss_ch = channel;
 
-	if ((ar->nw_type == INFRA_NETWORK))
+	if ((vif->nw_type == INFRA_NETWORK))
 		ath6kl_wmi_listeninterval_cmd(ar->wmi, ar->listen_intvl_t,
 					      ar->listen_intvl_b);
 
@@ -793,7 +795,7 @@ void ath6kl_connect_event(struct ath6kl *ar, u16 channel, u8 *bssid,
 	aggr_reset_state(ar->aggr_cntxt);
 	ar->reconnect_flag = 0;
 
-	if ((ar->nw_type == ADHOC_NETWORK) && ar->ibss_ps_enable) {
+	if ((vif->nw_type == ADHOC_NETWORK) && ar->ibss_ps_enable) {
 		memset(ar->node_map, 0, sizeof(ar->node_map));
 		ar->node_num = 0;
 		ar->next_ep_id = ENDPOINT_2;
@@ -808,12 +810,14 @@ void ath6kl_connect_event(struct ath6kl *ar, u16 channel, u8 *bssid,
 void ath6kl_tkip_micerr_event(struct ath6kl *ar, u8 keyid, bool ismcast)
 {
 	struct ath6kl_sta *sta;
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
 	u8 tsc[6];
 	/*
 	 * For AP case, keyid will have aid of STA which sent pkt with
 	 * MIC error. Use this aid to get MAC & send it to hostapd.
 	 */
-	if (ar->nw_type == AP_NETWORK) {
+	if (vif->nw_type == AP_NETWORK) {
 		sta = ath6kl_find_sta_by_aid(ar, (keyid >> 2));
 		if (!sta)
 			return;
@@ -946,9 +950,11 @@ void ath6kl_tgt_stats_event(struct ath6kl *ar, u8 *ptr, u32 len)
 	struct wmi_ap_mode_stat *p = (struct wmi_ap_mode_stat *) ptr;
 	struct wmi_ap_mode_stat *ap = &ar->ap_stats;
 	struct wmi_per_sta_stat *st_ap, *st_p;
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
 	u8 ac;
 
-	if (ar->nw_type == AP_NETWORK) {
+	if (vif->nw_type == AP_NETWORK) {
 		if (len < sizeof(*p))
 			return;
 
@@ -1076,7 +1082,7 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 	/* TODO: Findout vif instead of taking it from ar */
 	struct ath6kl_vif *vif = ar->vif;
 
-	if (ar->nw_type == AP_NETWORK) {
+	if (vif->nw_type == AP_NETWORK) {
 		if (!ath6kl_remove_sta(ar, bssid, prot_reason_status))
 			return;
 
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index d1652bd..6b1795c 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -258,7 +258,7 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 		goto fail_tx;
 
 	/* AP mode Power saving processing */
-	if (ar->nw_type == AP_NETWORK) {
+	if (vif->nw_type == AP_NETWORK) {
 		if (ath6kl_powersave_ap(ar, skb, &more_data))
 			return 0;
 	}
@@ -280,7 +280,7 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 			goto fail_tx;
 		}
 
-		if ((ar->nw_type == ADHOC_NETWORK) &&
+		if ((vif->nw_type == ADHOC_NETWORK) &&
 		     ar->ibss_ps_enable && test_bit(CONNECTED, &vif->flags))
 			chk_adhoc_ps_mapping = true;
 		else {
@@ -450,7 +450,7 @@ enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
 	if (packet->info.tx.tag == ATH6KL_CONTROL_PKT_TAG)
 		return HTC_SEND_FULL_KEEP;
 
-	if (ar->nw_type == ADHOC_NETWORK)
+	if (vif->nw_type == ADHOC_NETWORK)
 		/*
 		 * In adhoc mode, we cannot differentiate traffic
 		 * priorities so there is no need to continue, however we
@@ -484,9 +484,11 @@ stop_net_queues:
 static void ath6kl_tx_clear_node_map(struct ath6kl *ar,
 				     enum htc_endpoint_id eid, u32 map_no)
 {
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
 	u32 i;
 
-	if (ar->nw_type != ADHOC_NETWORK)
+	if (vif->nw_type != ADHOC_NETWORK)
 		return;
 
 	if (!ar->ibss_ps_enable)
@@ -1048,6 +1050,8 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	struct ath6kl_sta *conn = NULL;
 	struct sk_buff *skb1 = NULL;
 	struct ethhdr *datap = NULL;
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
 	u16 seq_no, offset;
 	u8 tid;
 
@@ -1103,7 +1107,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	 * that do not have LLC hdr. They are 16 bytes in size.
 	 * Allow these frames in the AP mode.
 	 */
-	if (ar->nw_type != AP_NETWORK &&
+	if (vif->nw_type != AP_NETWORK &&
 	    ((packet->act_len < min_hdr_len) ||
 	     (packet->act_len > WMI_MAX_AMSDU_RX_DATA_FRAME_LENGTH))) {
 		ath6kl_info("frame len is too short or too long\n");
@@ -1114,7 +1118,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	}
 
 	/* Get the Power save state of the STA */
-	if (ar->nw_type == AP_NETWORK) {
+	if (vif->nw_type == AP_NETWORK) {
 		meta_type = wmi_data_hdr_get_meta(dhdr);
 
 		ps_state = !!((dhdr->info >> WMI_DATA_HDR_PS_SHIFT) &
@@ -1227,7 +1231,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 		return;
 	}
 
-	if (ar->nw_type == AP_NETWORK) {
+	if (vif->nw_type == AP_NETWORK) {
 		datap = (struct ethhdr *) skb->data;
 		if (is_multicast_ether_addr(datap->h_dest))
 			/*
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index a71d773..701d26d 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -504,6 +504,8 @@ static int ath6kl_wmi_rx_probe_req_event_rx(struct wmi *wmi, u8 *datap, int len)
 	u32 freq;
 	u16 dlen;
 	struct ath6kl *ar = wmi->parent_dev;
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
 
 	if (len < sizeof(*ev))
 		return -EINVAL;
@@ -520,7 +522,7 @@ static int ath6kl_wmi_rx_probe_req_event_rx(struct wmi *wmi, u8 *datap, int len)
 		   "probe_req_report=%d\n",
 		   dlen, freq, ar->probe_req_report);
 
-	if (ar->probe_req_report || ar->nw_type == AP_NETWORK)
+	if (ar->probe_req_report || vif->nw_type == AP_NETWORK)
 		cfg80211_rx_mgmt(ar->net_dev, freq, ev->data, dlen, GFP_ATOMIC);
 
 	return 0;
@@ -727,13 +729,15 @@ static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len)
 	struct wmi_connect_event *ev;
 	u8 *pie, *peie;
 	struct ath6kl *ar = wmi->parent_dev;
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
 
 	if (len < sizeof(struct wmi_connect_event))
 		return -EINVAL;
 
 	ev = (struct wmi_connect_event *) datap;
 
-	if (ar->nw_type == AP_NETWORK) {
+	if (vif->nw_type == AP_NETWORK) {
 		/* AP mode start/STA connected event */
 		struct net_device *dev = ar->net_dev;
 		if (memcmp(dev->dev_addr, ev->u.ap_bss.bssid, ETH_ALEN) == 0) {
-- 
1.7.0.4

