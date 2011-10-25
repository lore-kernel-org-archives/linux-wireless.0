Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25588 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933413Ab1JYOEu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:04:50 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 06/31] ath6kl: Define interface specific states
Date: Tue, 25 Oct 2011 19:34:01 +0530
Message-ID: <1319551466-29070-7-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160453_369489_F2472A8C)
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently ar->flag maintains interface stats. Move interface
specific states from ar->flag to vif->flags.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   66 ++++++++++++++++++----------
 drivers/net/wireless/ath/ath6kl/core.h     |   41 ++++++++++-------
 drivers/net/wireless/ath/ath6kl/init.c     |    3 +-
 drivers/net/wireless/ath/ath6kl/main.c     |   64 ++++++++++++++++++---------
 drivers/net/wireless/ath/ath6kl/txrx.c     |   23 ++++++---
 drivers/net/wireless/ath/ath6kl/wmi.c      |   12 +++--
 6 files changed, 133 insertions(+), 76 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index e663d60..fed31cf 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -231,12 +231,14 @@ static void ath6kl_set_key_mgmt(struct ath6kl *ar, u32 key_mgmt)
 
 static bool ath6kl_cfg80211_ready(struct ath6kl *ar)
 {
+	struct ath6kl_vif *vif = ar->vif;
+
 	if (!test_bit(WMI_READY, &ar->flag)) {
 		ath6kl_err("wmi is not ready\n");
 		return false;
 	}
 
-	if (!test_bit(WLAN_ENABLED, &ar->flag)) {
+	if (!test_bit(WLAN_ENABLED, &vif->flags)) {
 		ath6kl_err("wlan disabled\n");
 		return false;
 	}
@@ -295,6 +297,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 				   struct cfg80211_connect_params *sme)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
 	int status;
 
 	ar->sme_state = SME_CONNECTING;
@@ -345,7 +348,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 			return status;
 	}
 
-	if (test_bit(CONNECTED, &ar->flag) &&
+	if (test_bit(CONNECTED, &vif->flags) &&
 	    ar->ssid_len == sme->ssid_len &&
 	    !memcmp(ar->ssid, sme->ssid, ar->ssid_len)) {
 		ar->reconnect_flag = true;
@@ -420,7 +423,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	if (!ar->usr_bss_filter) {
-		clear_bit(CLEAR_BSSFILTER_ON_BEACON, &ar->flag);
+		clear_bit(CLEAR_BSSFILTER_ON_BEACON, &vif->flags);
 		if (ath6kl_wmi_bssfilter_cmd(ar->wmi, ALL_BSS_FILTER, 0) != 0) {
 			ath6kl_err("couldn't set bss filtering\n");
 			up(&ar->sem);
@@ -469,7 +472,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	ar->connect_ctrl_flags &= ~CONNECT_DO_WPA_OFFLOAD;
-	set_bit(CONNECT_PEND, &ar->flag);
+	set_bit(CONNECT_PEND, &vif->flags);
 
 	return 0;
 }
@@ -529,6 +532,8 @@ void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
 				   u8 assoc_resp_len, u8 *assoc_info)
 {
 	struct ieee80211_channel *chan;
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
 
 	/* capinfo + listen interval */
 	u8 assoc_req_ie_offset = sizeof(u16) + sizeof(u16);
@@ -548,7 +553,7 @@ void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
 	 * a Beacon frame from the AP is seen.
 	 */
 	ar->assoc_bss_beacon_int = beacon_intvl;
-	clear_bit(DTIM_PERIOD_AVAIL, &ar->flag);
+	clear_bit(DTIM_PERIOD_AVAIL, &vif->flags);
 
 	if (nw_type & ADHOC_NETWORK) {
 		if (ar->wdev->iftype != NL80211_IFTYPE_ADHOC) {
@@ -637,6 +642,9 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
 				      u8 *bssid, u8 assoc_resp_len,
 				      u8 *assoc_info, u16 proto_reason)
 {
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
+
 	if (ar->scan_req) {
 		cfg80211_scan_done(ar->scan_req, true);
 		ar->scan_req = NULL;
@@ -676,7 +684,7 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
 		return;
 	}
 
-	clear_bit(CONNECT_PEND, &ar->flag);
+	clear_bit(CONNECT_PEND, &vif->flags);
 
 	if (ar->sme_state == SME_CONNECTING) {
 		cfg80211_connect_result(ar->net_dev,
@@ -696,6 +704,7 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 				struct cfg80211_scan_request *request)
 {
 	struct ath6kl *ar = (struct ath6kl *)ath6kl_priv(ndev);
+	struct ath6kl_vif *vif = netdev_priv(ndev);
 	s8 n_channels = 0;
 	u16 *channels = NULL;
 	int ret = 0;
@@ -705,10 +714,10 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		return -EIO;
 
 	if (!ar->usr_bss_filter) {
-		clear_bit(CLEAR_BSSFILTER_ON_BEACON, &ar->flag);
+		clear_bit(CLEAR_BSSFILTER_ON_BEACON, &vif->flags);
 		ret = ath6kl_wmi_bssfilter_cmd(
 			ar->wmi,
-			(test_bit(CONNECTED, &ar->flag) ?
+			(test_bit(CONNECTED, &vif->flags) ?
 			 ALL_BUT_BSS_FILTER : ALL_BSS_FILTER), 0);
 		if (ret) {
 			ath6kl_err("couldn't set bss filtering\n");
@@ -761,7 +770,7 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 			channels[i] = request->channels[i]->center_freq;
 	}
 
-	if (test_bit(CONNECTED, &ar->flag))
+	if (test_bit(CONNECTED, &vif->flags))
 		force_fg_scan = 1;
 
 	ret = ath6kl_wmi_startscan_cmd(ar->wmi, WMI_LONG_SCAN, force_fg_scan,
@@ -810,6 +819,7 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 				   struct key_params *params)
 {
 	struct ath6kl *ar = (struct ath6kl *)ath6kl_priv(ndev);
+	struct ath6kl_vif *vif = netdev_priv(ndev);
 	struct ath6kl_key *key = NULL;
 	u8 key_usage;
 	u8 key_type;
@@ -888,7 +898,7 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		ar->ap_mode_bkey.key_type = key_type;
 		ar->ap_mode_bkey.key_len = key->key_len;
 		memcpy(ar->ap_mode_bkey.key, key->key, key->key_len);
-		if (!test_bit(CONNECTED, &ar->flag)) {
+		if (!test_bit(CONNECTED, &vif->flags)) {
 			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "Delay initial group "
 				   "key configuration until AP mode has been "
 				   "started\n");
@@ -901,7 +911,7 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	if (ar->next_mode == AP_NETWORK && key_type == WEP_CRYPT &&
-	    !test_bit(CONNECTED, &ar->flag)) {
+	    !test_bit(CONNECTED, &vif->flags)) {
 		/*
 		 * Store the key locally so that it can be re-configured after
 		 * the AP mode has properly started
@@ -995,6 +1005,7 @@ static int ath6kl_cfg80211_set_default_key(struct wiphy *wiphy,
 					   bool multicast)
 {
 	struct ath6kl *ar = (struct ath6kl *)ath6kl_priv(ndev);
+	struct ath6kl_vif *vif = netdev_priv(ndev);
 	struct ath6kl_key *key = NULL;
 	int status = 0;
 	u8 key_usage;
@@ -1028,7 +1039,7 @@ static int ath6kl_cfg80211_set_default_key(struct wiphy *wiphy,
 	if (multicast)
 		key_type = ar->grp_crypto;
 
-	if (ar->next_mode == AP_NETWORK && !test_bit(CONNECTED, &ar->flag))
+	if (ar->next_mode == AP_NETWORK && !test_bit(CONNECTED, &vif->flags))
 		return 0; /* Delay until AP mode has been started */
 
 	status = ath6kl_wmi_addkey_cmd(ar->wmi, ar->def_txkey_index,
@@ -1113,11 +1124,12 @@ static int ath6kl_cfg80211_set_txpower(struct wiphy *wiphy,
 static int ath6kl_cfg80211_get_txpower(struct wiphy *wiphy, int *dbm)
 {
 	struct ath6kl *ar = (struct ath6kl *)wiphy_priv(wiphy);
+	struct ath6kl_vif *vif = ar->vif;
 
 	if (!ath6kl_cfg80211_ready(ar))
 		return -EIO;
 
-	if (test_bit(CONNECTED, &ar->flag)) {
+	if (test_bit(CONNECTED, &vif->flags)) {
 		ar->tx_pwr = 0;
 
 		if (ath6kl_wmi_get_tx_pwr_cmd(ar->wmi) != 0) {
@@ -1211,6 +1223,7 @@ static int ath6kl_cfg80211_join_ibss(struct wiphy *wiphy,
 				     struct cfg80211_ibss_params *ibss_param)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
 	int status;
 
 	if (!ath6kl_cfg80211_ready(ar))
@@ -1269,7 +1282,7 @@ static int ath6kl_cfg80211_join_ibss(struct wiphy *wiphy,
 					ar->ssid_len, ar->ssid,
 					ar->req_bssid, ar->ch_hint,
 					ar->connect_ctrl_flags);
-	set_bit(CONNECT_PEND, &ar->flag);
+	set_bit(CONNECT_PEND, &vif->flags);
 
 	return 0;
 }
@@ -1362,6 +1375,7 @@ static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
 			      u8 *mac, struct station_info *sinfo)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
 	long left;
 	bool sgi;
 	s32 rate;
@@ -1444,8 +1458,8 @@ static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
 
 	sinfo->filled |= STATION_INFO_TX_BITRATE;
 
-	if (test_bit(CONNECTED, &ar->flag) &&
-	    test_bit(DTIM_PERIOD_AVAIL, &ar->flag) &&
+	if (test_bit(CONNECTED, &vif->flags) &&
+	    test_bit(DTIM_PERIOD_AVAIL, &vif->flags) &&
 	    ar->nw_type == INFRA_NETWORK) {
 		sinfo->filled |= STATION_INFO_BSS_PARAM;
 		sinfo->bss_param.flags = 0;
@@ -1475,7 +1489,9 @@ static int ath6kl_del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 static int ath6kl_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 {
 	struct ath6kl *ar = ath6kl_priv(netdev);
-	if (test_bit(CONNECTED, &ar->flag))
+	struct ath6kl_vif *vif = netdev_priv(netdev);
+
+	if (test_bit(CONNECTED, &vif->flags))
 		return ath6kl_wmi_setpmkid_cmd(ar->wmi, ar->bssid, NULL, false);
 	return 0;
 }
@@ -1711,14 +1727,15 @@ static int ath6kl_set_beacon(struct wiphy *wiphy, struct net_device *dev,
 static int ath6kl_del_beacon(struct wiphy *wiphy, struct net_device *dev)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
 
 	if (ar->nw_type != AP_NETWORK)
 		return -EOPNOTSUPP;
-	if (!test_bit(CONNECTED, &ar->flag))
+	if (!test_bit(CONNECTED, &vif->flags))
 		return -ENOTCONN;
 
 	ath6kl_wmi_disconnect_cmd(ar->wmi);
-	clear_bit(CONNECTED, &ar->flag);
+	clear_bit(CONNECTED, &vif->flags);
 
 	return 0;
 }
@@ -1813,12 +1830,13 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 			  const u8 *buf, size_t len, bool no_cck, u64 *cookie)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
 	u32 id;
 	const struct ieee80211_mgmt *mgmt;
 
 	mgmt = (const struct ieee80211_mgmt *) buf;
 	if (buf + len >= mgmt->u.probe_resp.variable &&
-	    ar->nw_type == AP_NETWORK && test_bit(CONNECTED, &ar->flag) &&
+	    ar->nw_type == AP_NETWORK && test_bit(CONNECTED, &vif->flags) &&
 	    ieee80211_is_probe_resp(mgmt->frame_control)) {
 		/*
 		 * Send Probe Response frame in AP mode using a separate WMI
@@ -2038,9 +2056,9 @@ void ath6kl_deinit_if_data(struct ath6kl_vif *vif)
 
 	ar->aggr_cntxt = NULL;
 
-	if (test_bit(NETDEV_REGISTERED, &ar->flag)) {
+	if (test_bit(NETDEV_REGISTERED, &vif->flags)) {
 		unregister_netdev(vif->ndev);
-		clear_bit(NETDEV_REGISTERED, &ar->flag);
+		clear_bit(NETDEV_REGISTERED, &vif->flags);
 	}
 
 	free_netdev(vif->ndev);
@@ -2080,9 +2098,9 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 		goto err;
 
 	ar->sme_state = SME_DISCONNECTED;
-	set_bit(WLAN_ENABLED, &ar->flag);
+	set_bit(WLAN_ENABLED, &vif->flags);
 	ar->wlan_pwr_state = WLAN_POWER_STATE_ON;
-	set_bit(NETDEV_REGISTERED, &ar->flag);
+	set_bit(NETDEV_REGISTERED, &vif->flags);
 
 	return ndev;
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 0c1dee0..4777171 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -380,30 +380,37 @@ struct ath6kl_req_key {
 	u8 key_len;
 };
 
+/* vif flags info */
+enum ath6kl_vif_state {
+	CONNECTED,
+	CONNECT_PEND,
+	WMM_ENABLED,
+	NETQ_STOPPED,
+	DTIM_EXPIRED,
+	NETDEV_REGISTERED,
+	CLEAR_BSSFILTER_ON_BEACON,
+	DTIM_PERIOD_AVAIL,
+	WLAN_ENABLED,
+};
+
 struct ath6kl_vif {
 	struct wireless_dev wdev;
 	struct net_device *ndev;
 	struct ath6kl *ar;
+	unsigned long flags;
 };
 
 /* Flag info */
-#define WMI_ENABLED	0
-#define WMI_READY	1
-#define CONNECTED	2
-#define STATS_UPDATE_PEND 3
-#define CONNECT_PEND	  4
-#define WMM_ENABLED	  5
-#define NETQ_STOPPED	  6
-#define WMI_CTRL_EP_FULL  7
-#define DTIM_EXPIRED	  8
-#define DESTROY_IN_PROGRESS  9
-#define NETDEV_REGISTERED    10
-#define SKIP_SCAN	     11
-#define WLAN_ENABLED	     12
-#define TESTMODE	     13
-#define CLEAR_BSSFILTER_ON_BEACON 14
-#define DTIM_PERIOD_AVAIL    15
-#define ROAM_TBL_PEND        16
+enum ath6kl_dev_state {
+	WMI_ENABLED,
+	WMI_READY,
+	WMI_CTRL_EP_FULL,
+	TESTMODE,
+	DESTROY_IN_PROGRESS,
+	SKIP_SCAN,
+	STATS_UPDATE_PEND,
+	ROAM_TBL_PEND,
+};
 
 struct ath6kl {
 	struct device *dev;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 246399d..91c2783 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1574,6 +1574,7 @@ err_wq:
 void ath6kl_stop_txrx(struct ath6kl *ar)
 {
 	struct net_device *ndev = ar->net_dev;
+	struct ath6kl_vif *vif = ar->vif;
 
 	if (!ndev)
 		return;
@@ -1588,7 +1589,7 @@ void ath6kl_stop_txrx(struct ath6kl *ar)
 	if (ar->wlan_pwr_state != WLAN_POWER_STATE_CUT_PWR)
 		ath6kl_stop_endpoint(ndev, false, true);
 
-	clear_bit(WLAN_ENABLED, &ar->flag);
+	clear_bit(WLAN_ENABLED, &vif->flags);
 }
 
 /*
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 4470f6e..6a0eaea 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -429,6 +429,7 @@ void ath6kl_stop_endpoint(struct net_device *dev, bool keep_profile,
 			  bool get_dbglogs)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
 	static u8 bcast_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	bool discon_issued;
 
@@ -436,8 +437,8 @@ void ath6kl_stop_endpoint(struct net_device *dev, bool keep_profile,
 
 	/* disable the target and the interrupts associated with it */
 	if (test_bit(WMI_READY, &ar->flag)) {
-		discon_issued = (test_bit(CONNECTED, &ar->flag) ||
-				 test_bit(CONNECT_PEND, &ar->flag));
+		discon_issued = (test_bit(CONNECTED, &vif->flags) ||
+				 test_bit(CONNECT_PEND, &vif->flags));
 		ath6kl_disconnect(ar);
 		if (!keep_profile)
 			ath6kl_init_profile_info(ar);
@@ -524,6 +525,8 @@ void ath6kl_connect_ap_mode_bss(struct ath6kl *ar, u16 channel)
 	struct ath6kl_req_key *ik;
 	int res;
 	u8 key_rsc[ATH6KL_KEY_SEQ_LEN];
+	/* TODO: Pass vif instead of taking it from ar */
+	struct ath6kl_vif *vif = ar->vif;
 
 	ik = &ar->ap_mode_bkey;
 
@@ -555,7 +558,7 @@ void ath6kl_connect_ap_mode_bss(struct ath6kl *ar, u16 channel)
 	}
 
 	ath6kl_wmi_bssfilter_cmd(ar->wmi, NONE_BSS_FILTER, 0);
-	set_bit(CONNECTED, &ar->flag);
+	set_bit(CONNECTED, &vif->flags);
 	netif_carrier_on(ar->net_dev);
 }
 
@@ -914,20 +917,26 @@ void disconnect_timer_handler(unsigned long ptr)
 
 void ath6kl_disconnect(struct ath6kl *ar)
 {
-	if (test_bit(CONNECTED, &ar->flag) ||
-	    test_bit(CONNECT_PEND, &ar->flag)) {
+	/* TODO: Pass vif instead of taking it from ar */
+	struct ath6kl_vif *vif = ar->vif;
+
+	if (test_bit(CONNECTED, &vif->flags) ||
+	    test_bit(CONNECT_PEND, &vif->flags)) {
 		ath6kl_wmi_disconnect_cmd(ar->wmi);
 		/*
 		 * Disconnect command is issued, clear the connect pending
 		 * flag. The connected flag will be cleared in
 		 * disconnect event notification.
 		 */
-		clear_bit(CONNECT_PEND, &ar->flag);
+		clear_bit(CONNECT_PEND, &vif->flags);
 	}
 }
 
 void ath6kl_deep_sleep_enable(struct ath6kl *ar)
 {
+	/* TODO: Pass vif instead of taking it from ar */
+	struct ath6kl_vif *vif = ar->vif;
+
 	switch (ar->sme_state) {
 	case SME_CONNECTING:
 		cfg80211_connect_result(ar->net_dev, ar->bssid, NULL, 0,
@@ -946,8 +955,8 @@ void ath6kl_deep_sleep_enable(struct ath6kl *ar)
 		break;
 	}
 
-	if (test_bit(CONNECTED, &ar->flag) ||
-	    test_bit(CONNECT_PEND, &ar->flag))
+	if (test_bit(CONNECTED, &vif->flags) ||
+	    test_bit(CONNECT_PEND, &vif->flags))
 		ath6kl_wmi_disconnect_cmd(ar->wmi);
 
 	ar->sme_state = SME_DISCONNECTED;
@@ -1016,10 +1025,13 @@ void ath6kl_ready_event(void *devt, u8 *datap, u32 sw_ver, u32 abi_ver)
 
 void ath6kl_scan_complete_evt(struct ath6kl *ar, int status)
 {
+	/* TODO: Pass vif instead of taking it from ar */
+	struct ath6kl_vif *vif = ar->vif;
+
 	ath6kl_cfg80211_scan_complete_event(ar, status);
 
 	if (!ar->usr_bss_filter) {
-		clear_bit(CLEAR_BSSFILTER_ON_BEACON, &ar->flag);
+		clear_bit(CLEAR_BSSFILTER_ON_BEACON, &vif->flags);
 		ath6kl_wmi_bssfilter_cmd(ar->wmi, NONE_BSS_FILTER, 0);
 	}
 
@@ -1032,6 +1044,9 @@ void ath6kl_connect_event(struct ath6kl *ar, u16 channel, u8 *bssid,
 			  u8 assoc_req_len, u8 assoc_resp_len,
 			  u8 *assoc_info)
 {
+	/* TODO: findout  vif instead of taking it from ar */
+	struct ath6kl_vif *vif = ar->vif;
+
 	ath6kl_cfg80211_connect_event(ar, channel, bssid,
 				      listen_int, beacon_int,
 				      net_type, beacon_ie_len,
@@ -1049,8 +1064,8 @@ void ath6kl_connect_event(struct ath6kl *ar, u16 channel, u8 *bssid,
 
 	/* Update connect & link status atomically */
 	spin_lock_bh(&ar->lock);
-	set_bit(CONNECTED, &ar->flag);
-	clear_bit(CONNECT_PEND, &ar->flag);
+	set_bit(CONNECTED, &vif->flags);
+	clear_bit(CONNECT_PEND, &vif->flags);
 	netif_carrier_on(ar->net_dev);
 	spin_unlock_bh(&ar->lock);
 
@@ -1064,7 +1079,7 @@ void ath6kl_connect_event(struct ath6kl *ar, u16 channel, u8 *bssid,
 	}
 
 	if (!ar->usr_bss_filter) {
-		set_bit(CLEAR_BSSFILTER_ON_BEACON, &ar->flag);
+		set_bit(CLEAR_BSSFILTER_ON_BEACON, &vif->flags);
 		ath6kl_wmi_bssfilter_cmd(ar->wmi, CURRENT_BSS_FILTER, 0);
 	}
 }
@@ -1292,6 +1307,8 @@ void ath6kl_dtimexpiry_event(struct ath6kl *ar)
 {
 	bool mcastq_empty = false;
 	struct sk_buff *skb;
+	/* TODO: Pass vif instead of taking it from ar */
+	struct ath6kl_vif *vif = ar->vif;
 
 	/*
 	 * If there are no associated STAs, ignore the DTIM expiry event.
@@ -1313,7 +1330,7 @@ void ath6kl_dtimexpiry_event(struct ath6kl *ar)
 		return;
 
 	/* set the STA flag to dtim_expired for the frame to go out */
-	set_bit(DTIM_EXPIRED, &ar->flag);
+	set_bit(DTIM_EXPIRED, &vif->flags);
 
 	spin_lock_bh(&ar->mcastpsq_lock);
 	while ((skb = skb_dequeue(&ar->mcastpsq)) != NULL) {
@@ -1325,7 +1342,7 @@ void ath6kl_dtimexpiry_event(struct ath6kl *ar)
 	}
 	spin_unlock_bh(&ar->mcastpsq_lock);
 
-	clear_bit(DTIM_EXPIRED, &ar->flag);
+	clear_bit(DTIM_EXPIRED, &vif->flags);
 
 	/* clear the LSB of the BitMapCtl field of the TIM IE */
 	ath6kl_wmi_set_pvb_cmd(ar->wmi, MCAST_AID, 0);
@@ -1335,6 +1352,9 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 			     u8 assoc_resp_len, u8 *assoc_info,
 			     u16 prot_reason_status)
 {
+	/* TODO: Findout vif instead of taking it from ar */
+	struct ath6kl_vif *vif = ar->vif;
+
 	if (ar->nw_type == AP_NETWORK) {
 		if (!ath6kl_remove_sta(ar, bssid, prot_reason_status))
 			return;
@@ -1357,7 +1377,7 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 
 		if (memcmp(ar->net_dev->dev_addr, bssid, ETH_ALEN) == 0) {
 			memset(ar->wep_key_list, 0, sizeof(ar->wep_key_list));
-			clear_bit(CONNECTED, &ar->flag);
+			clear_bit(CONNECTED, &vif->flags);
 		}
 		return;
 	}
@@ -1382,19 +1402,19 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 		if (!ar->usr_bss_filter && test_bit(WMI_READY, &ar->flag))
 			ath6kl_wmi_bssfilter_cmd(ar->wmi, NONE_BSS_FILTER, 0);
 	} else {
-		set_bit(CONNECT_PEND, &ar->flag);
+		set_bit(CONNECT_PEND, &vif->flags);
 		if (((reason == ASSOC_FAILED) &&
 		    (prot_reason_status == 0x11)) ||
 		    ((reason == ASSOC_FAILED) && (prot_reason_status == 0x0)
 		     && (ar->reconnect_flag == 1))) {
-			set_bit(CONNECTED, &ar->flag);
+			set_bit(CONNECTED, &vif->flags);
 			return;
 		}
 	}
 
 	/* update connect & link status atomically */
 	spin_lock_bh(&ar->lock);
-	clear_bit(CONNECTED, &ar->flag);
+	clear_bit(CONNECTED, &vif->flags);
 	netif_carrier_off(ar->net_dev);
 	spin_unlock_bh(&ar->lock);
 
@@ -1414,12 +1434,13 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 static int ath6kl_open(struct net_device *dev)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
 
 	spin_lock_bh(&ar->lock);
 
-	set_bit(WLAN_ENABLED, &ar->flag);
+	set_bit(WLAN_ENABLED, &vif->flags);
 
-	if (test_bit(CONNECTED, &ar->flag)) {
+	if (test_bit(CONNECTED, &vif->flags)) {
 		netif_carrier_on(dev);
 		netif_wake_queue(dev);
 	} else
@@ -1433,6 +1454,7 @@ static int ath6kl_open(struct net_device *dev)
 static int ath6kl_close(struct net_device *dev)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
 
 	netif_stop_queue(dev);
 
@@ -1443,7 +1465,7 @@ static int ath6kl_close(struct net_device *dev)
 					      0, 0, 0))
 			return -EIO;
 
-		clear_bit(WLAN_ENABLED, &ar->flag);
+		clear_bit(WLAN_ENABLED, &vif->flags);
 	}
 
 	ath6kl_cfg80211_scan_complete_event(ar, -ECANCELED);
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index a9dff01..d1652bd 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -83,6 +83,8 @@ static bool ath6kl_powersave_ap(struct ath6kl *ar, struct sk_buff *skb,
 	struct ethhdr *datap = (struct ethhdr *) skb->data;
 	struct ath6kl_sta *conn = NULL;
 	bool ps_queued = false, is_psq_empty = false;
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
 
 	if (is_multicast_ether_addr(datap->h_dest)) {
 		u8 ctr = 0;
@@ -100,7 +102,7 @@ static bool ath6kl_powersave_ap(struct ath6kl *ar, struct sk_buff *skb,
 			 * If this transmit is not because of a Dtim Expiry
 			 * q it.
 			 */
-			if (!test_bit(DTIM_EXPIRED, &ar->flag)) {
+			if (!test_bit(DTIM_EXPIRED, &vif->flags)) {
 				bool is_mcastq_empty = false;
 
 				spin_lock_bh(&ar->mcastpsq_lock);
@@ -235,6 +237,7 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 	struct ath6kl *ar = ath6kl_priv(dev);
 	struct ath6kl_cookie *cookie = NULL;
 	enum htc_endpoint_id eid = ENDPOINT_UNUSED;
+	struct ath6kl_vif *vif = netdev_priv(dev);
 	u32 map_no = 0;
 	u16 htc_tag = ATH6KL_DATA_PKT_TAG;
 	u8 ac = 99 ; /* initialize to unmapped ac */
@@ -246,7 +249,7 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 		   skb, skb->data, skb->len);
 
 	/* If target is not associated */
-	if (!test_bit(CONNECTED, &ar->flag)) {
+	if (!test_bit(CONNECTED, &vif->flags)) {
 		dev_kfree_skb(skb);
 		return 0;
 	}
@@ -278,12 +281,12 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 		}
 
 		if ((ar->nw_type == ADHOC_NETWORK) &&
-		     ar->ibss_ps_enable && test_bit(CONNECTED, &ar->flag))
+		     ar->ibss_ps_enable && test_bit(CONNECTED, &vif->flags))
 			chk_adhoc_ps_mapping = true;
 		else {
 			/* get the stream mapping */
 			ret = ath6kl_wmi_implicit_create_pstream(ar->wmi, skb,
-				    0, test_bit(WMM_ENABLED, &ar->flag), &ac);
+				    0, test_bit(WMM_ENABLED, &vif->flags), &ac);
 			if (ret)
 				goto fail_tx;
 		}
@@ -426,6 +429,8 @@ enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
 					       struct htc_packet *packet)
 {
 	struct ath6kl *ar = target->dev->ar;
+	/* TODO: Findout vif properly */
+	struct ath6kl_vif *vif = ar->vif;
 	enum htc_endpoint_id endpoint = packet->endpoint;
 
 	if (endpoint == ar->ctrl_ep) {
@@ -468,7 +473,7 @@ enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
 
 stop_net_queues:
 	spin_lock_bh(&ar->lock);
-	set_bit(NETQ_STOPPED, &ar->flag);
+	set_bit(NETQ_STOPPED, &vif->flags);
 	spin_unlock_bh(&ar->lock);
 	netif_stop_queue(ar->net_dev);
 
@@ -524,6 +529,8 @@ void ath6kl_tx_complete(void *context, struct list_head *packet_queue)
 	enum htc_endpoint_id eid;
 	bool wake_event = false;
 	bool flushing = false;
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
 
 	skb_queue_head_init(&skb_queue);
 
@@ -597,15 +604,15 @@ void ath6kl_tx_complete(void *context, struct list_head *packet_queue)
 
 		ath6kl_free_cookie(ar, ath6kl_cookie);
 
-		if (test_bit(NETQ_STOPPED, &ar->flag))
-			clear_bit(NETQ_STOPPED, &ar->flag);
+		if (test_bit(NETQ_STOPPED, &vif->flags))
+			clear_bit(NETQ_STOPPED, &vif->flags);
 	}
 
 	spin_unlock_bh(&ar->lock);
 
 	__skb_queue_purge(&skb_queue);
 
-	if (test_bit(CONNECTED, &ar->flag)) {
+	if (test_bit(CONNECTED, &vif->flags)) {
 		if (!flushing)
 			netif_wake_queue(ar->net_dev);
 	}
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 7f4c2c2..a71d773 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -950,6 +950,8 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
 	struct ath6kl *ar = wmi->parent_dev;
 	struct ieee80211_mgmt *mgmt;
 	struct cfg80211_bss *bss;
+	/*TODO: Findout vif properly */
+	struct ath6kl_vif *vif = ar->vif;
 
 	if (len <= sizeof(struct wmi_bss_info_hdr2))
 		return -EINVAL;
@@ -969,8 +971,8 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
 		return 0; /* Only update BSS table for now */
 
 	if (bih->frame_type == BEACON_FTYPE &&
-	    test_bit(CLEAR_BSSFILTER_ON_BEACON, &ar->flag)) {
-		clear_bit(CLEAR_BSSFILTER_ON_BEACON, &ar->flag);
+	    test_bit(CLEAR_BSSFILTER_ON_BEACON, &vif->flags)) {
+		clear_bit(CLEAR_BSSFILTER_ON_BEACON, &vif->flags);
 		ath6kl_wmi_bssfilter_cmd(ar->wmi, NONE_BSS_FILTER, 0);
 	}
 
@@ -981,14 +983,14 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
 	if (len < 8 + 2 + 2)
 		return -EINVAL;
 
-	if (bih->frame_type == BEACON_FTYPE && test_bit(CONNECTED, &ar->flag) &&
-	    memcmp(bih->bssid, ar->bssid, ETH_ALEN) == 0) {
+	if (bih->frame_type == BEACON_FTYPE && test_bit(CONNECTED, &vif->flags)
+	    && memcmp(bih->bssid, ar->bssid, ETH_ALEN) == 0) {
 		const u8 *tim;
 		tim = cfg80211_find_ie(WLAN_EID_TIM, buf + 8 + 2 + 2,
 				       len - 8 - 2 - 2);
 		if (tim && tim[1] >= 2) {
 			ar->assoc_bss_dtim_period = tim[3];
-			set_bit(DTIM_PERIOD_AVAIL, &ar->flag);
+			set_bit(DTIM_PERIOD_AVAIL, &vif->flags);
 		}
 	}
 
-- 
1.7.0.4

