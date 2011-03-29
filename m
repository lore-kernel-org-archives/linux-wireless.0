Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:36008 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab1C2Av5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 20:51:57 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/4] mwifiex: remove MWIFIEX_BSS_MODE_ macros
Date: Mon, 28 Mar 2011 17:55:41 -0700
Message-Id: <1301360144-4986-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

replace them with NL80211_IFTYPE_ macros

Also remove redundant functions mwifiex_drv_get_mode()
and mwifiex_bss_ioctl_mode().

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c         |    4 +-
 drivers/net/wireless/mwifiex/cfg80211.c    |   85 +++++++++++++---------------
 drivers/net/wireless/mwifiex/cfp.c         |    3 +-
 drivers/net/wireless/mwifiex/init.c        |    2 +-
 drivers/net/wireless/mwifiex/ioctl.h       |    6 --
 drivers/net/wireless/mwifiex/join.c        |   12 ++--
 drivers/net/wireless/mwifiex/main.h        |    7 +--
 drivers/net/wireless/mwifiex/scan.c        |   29 +++++-----
 drivers/net/wireless/mwifiex/sta_cmd.c     |    4 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    2 +-
 drivers/net/wireless/mwifiex/sta_event.c   |    2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c   |   83 ++-------------------------
 12 files changed, 74 insertions(+), 165 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index ce6421f..73a6e62 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -109,7 +109,7 @@ mwifiex_fill_cap_info(struct mwifiex_private *priv,
 	memset(&mcs[rx_mcs_supp], 0,
 			sizeof(struct ieee80211_mcs_info) - rx_mcs_supp);
 
-	if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA ||
+	if (priv->bss_mode == NL80211_IFTYPE_STATION ||
 			(ht_cap_info & IEEE80211_HT_CAP_SUP_WIDTH_20_40))
 		/* Set MCS32 for infra mode or ad-hoc mode with 40MHz support */
 		SETHT_MCS32(ht_cap->ht_cap.mcs.rx_mask);
@@ -418,7 +418,7 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 	}
 
 	if (bss_desc->bcn_ht_info) {
-		if (priv->bss_mode == MWIFIEX_BSS_MODE_IBSS) {
+		if (priv->bss_mode == NL80211_IFTYPE_ADHOC) {
 			ht_info = (struct mwifiex_ie_types_htinfo *) *buffer;
 			memset(ht_info, 0,
 			       sizeof(struct mwifiex_ie_types_htinfo));
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index de86ef8..701c179 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -398,13 +398,9 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 	int ret = 0;
 	int status = 0;
 	struct mwifiex_ds_band_cfg band_cfg;
-	int mode;
-	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 	u32 config_bands = 0;
 	struct wiphy *wiphy = priv->wdev->wiphy;
 
-	mode = mwifiex_drv_get_mode(priv, wait_option);
-
 	if (chan) {
 		memset(&band_cfg, 0, sizeof(band_cfg));
 		/* Set appropriate bands */
@@ -412,10 +408,10 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 			config_bands = BAND_B | BAND_G | BAND_GN;
 		else
 			config_bands = BAND_AN | BAND_A;
-		if (mode == MWIFIEX_BSS_MODE_INFRA
-		    || mode == MWIFIEX_BSS_MODE_AUTO) {
+		if (priv->bss_mode == NL80211_IFTYPE_STATION
+		    || priv->bss_mode == NL80211_IFTYPE_UNSPECIFIED) {
 			band_cfg.config_bands = config_bands;
-		} else if (mode == MWIFIEX_BSS_MODE_IBSS) {
+		} else if (priv->bss_mode == NL80211_IFTYPE_ADHOC) {
 			band_cfg.config_bands = config_bands;
 			band_cfg.adhoc_start_band = config_bands;
 		}
@@ -432,7 +428,8 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 	}
 
 	wiphy_dbg(wiphy, "info: setting band %d, channel offset %d and "
-		"mode %d\n", config_bands, band_cfg.sec_chan_offset, mode);
+		"mode %d\n", config_bands, band_cfg.sec_chan_offset,
+		priv->bss_mode);
 	if (!chan)
 		return ret;
 
@@ -561,14 +558,6 @@ mwifiex_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 
 /*
  * CFG802.11 operation handler to change interface type.
- *
- * This function creates an IOCTL request, populates it accordingly
- * and issues an IOCTL.
- *
- * The function also maps the CFG802.11 mode type into driver mode type.
- *      NL80211_IFTYPE_ADHOC        -> MWIFIEX_BSS_MODE_IBSS
- *      NL80211_IFTYPE_STATION      -> MWIFIEX_BSS_MODE_INFRA
- *      NL80211_IFTYPE_UNSPECIFIED  -> MWIFIEX_BSS_MODE_AUTO
  */
 static int
 mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
@@ -578,41 +567,50 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 {
 	int ret = 0;
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
-	int mode = -1;
 	struct mwifiex_wait_queue *wait = NULL;
-	int status = 0;
 
-	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait)
-		return -ENOMEM;
+	if (priv->bss_mode == type) {
+		wiphy_warn(wiphy, "already set to required type\n");
+		return 0;
+	}
+
+	priv->bss_mode = type;
 
 	switch (type) {
 	case NL80211_IFTYPE_ADHOC:
-		mode = MWIFIEX_BSS_MODE_IBSS;
 		dev->ieee80211_ptr->iftype = NL80211_IFTYPE_ADHOC;
 		wiphy_dbg(wiphy, "info: setting interface type to adhoc\n");
 		break;
 	case NL80211_IFTYPE_STATION:
-		mode = MWIFIEX_BSS_MODE_INFRA;
 		dev->ieee80211_ptr->iftype = NL80211_IFTYPE_STATION;
-		wiphy_dbg(wiphy, "info: Setting interface type to managed\n");
+		wiphy_dbg(wiphy, "info: setting interface type to managed\n");
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
-		mode = MWIFIEX_BSS_MODE_AUTO;
 		dev->ieee80211_ptr->iftype = NL80211_IFTYPE_STATION;
 		wiphy_dbg(wiphy, "info: setting interface type to auto\n");
-		break;
+		return 0;
 	default:
-		ret = -EINVAL;
+		wiphy_err(wiphy, "unknown interface type: %d\n", type);
+		return -EINVAL;
 	}
-	if (ret)
-		goto done;
-	status = mwifiex_bss_ioctl_mode(priv, wait, HostCmd_ACT_GEN_SET, &mode);
 
-	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT))
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait)
+		return -ENOMEM;
+
+	mwifiex_deauthenticate(priv, wait, NULL);
+
+	priv->sec_info.authentication_mode = MWIFIEX_AUTH_MODE_OPEN;
+
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
+				  HostCmd_ACT_GEN_SET, 0, wait, NULL);
+	if (!ret)
+		ret = -EINPROGRESS;
+
+	ret = mwifiex_request_ioctl(priv, wait, ret, MWIFIEX_IOCTL_WAIT);
+	if (ret)
 		ret = -EFAULT;
 
-done:
 	kfree(wait);
 	return ret;
 }
@@ -1046,7 +1044,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 
 	ret = mwifiex_set_encode(priv, NULL, 0, 0, 1);	/* Disable keys */
 
-	if (mode == MWIFIEX_BSS_MODE_IBSS) {
+	if (mode == NL80211_IFTYPE_ADHOC) {
 		/* "privacy" is set only for ad-hoc mode */
 		if (privacy) {
 			/*
@@ -1108,7 +1106,7 @@ done:
 
 	memcpy(&ssid_bssid.ssid, &req_ssid, sizeof(struct mwifiex_802_11_ssid));
 
-	if (mode != MWIFIEX_BSS_MODE_IBSS) {
+	if (mode != NL80211_IFTYPE_ADHOC) {
 		if (mwifiex_find_best_bss(priv, MWIFIEX_IOCTL_WAIT,
 					  &ssid_bssid))
 			return -EFAULT;
@@ -1129,7 +1127,7 @@ done:
 	if (mwifiex_bss_start(priv, MWIFIEX_IOCTL_WAIT, &ssid_bssid))
 		return -EFAULT;
 
-	if (mode == MWIFIEX_BSS_MODE_IBSS) {
+	if (mode == NL80211_IFTYPE_ADHOC) {
 		/* Inform the BSS information to kernel, otherwise
 		 * kernel will give a panic after successful assoc */
 		if (mwifiex_cfg80211_inform_ibss_bss(priv))
@@ -1152,14 +1150,11 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	int ret = 0;
-	int mode = 0;
 
 	if (priv->assoc_request)
 		return -EBUSY;
 
-	mode = mwifiex_drv_get_mode(priv, MWIFIEX_IOCTL_WAIT);
-
-	if (mode == MWIFIEX_BSS_MODE_IBSS) {
+	if (priv->bss_mode == NL80211_IFTYPE_ADHOC) {
 		wiphy_err(wiphy, "received infra assoc request "
 				"when station is in ibss mode\n");
 		goto done;
@@ -1171,7 +1166,7 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	       (char *) sme->ssid, sme->bssid);
 
 	ret = mwifiex_cfg80211_assoc(priv, sme->ssid_len, sme->ssid, sme->bssid,
-				     mode, sme->channel, sme, 0);
+				     priv->bss_mode, sme->channel, sme, 0);
 
 done:
 	priv->assoc_result = ret;
@@ -1191,13 +1186,11 @@ mwifiex_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 	int ret = 0;
-	int mode = 0;
 
 	if (priv->ibss_join_request)
 		return -EBUSY;
 
-	mode = mwifiex_drv_get_mode(priv, MWIFIEX_IOCTL_WAIT);
-	if (mode != MWIFIEX_BSS_MODE_IBSS) {
+	if (priv->bss_mode != NL80211_IFTYPE_ADHOC) {
 		wiphy_err(wiphy, "request to join ibss received "
 				"when station is not in ibss mode\n");
 		goto done;
@@ -1209,8 +1202,8 @@ mwifiex_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	       (char *) params->ssid, params->bssid);
 
 	ret = mwifiex_cfg80211_assoc(priv, params->ssid_len, params->ssid,
-				     params->bssid, mode, params->channel, NULL,
-				     params->privacy);
+				params->bssid, priv->bss_mode,
+				params->channel, NULL, params->privacy);
 done:
 	priv->ibss_join_result = ret;
 	queue_work(priv->workqueue, &priv->cfg_workqueue);
@@ -1301,7 +1294,7 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
 	/* Clear all the other values */
 	memset(&mcs[rx_mcs_supp], 0,
 			sizeof(struct ieee80211_mcs_info) - rx_mcs_supp);
-	if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA ||
+	if (priv->bss_mode == NL80211_IFTYPE_STATION ||
 			ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap))
 		/* Set MCS32 for infra mode or ad-hoc mode with 40MHz support */
 		SETHT_MCS32(mcs_set.rx_mask);
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index 999ed81..07187a4 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -288,8 +288,7 @@ u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 {
 	u32 k = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA) {
-		/* Infra. mode */
+	if (priv->bss_mode == NL80211_IFTYPE_STATION) {
 		switch (adapter->config_bands) {
 		case BAND_B:
 			dev_dbg(adapter->dev, "info: infra band=%d "
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 1c9315d..00e73ea 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -78,7 +78,7 @@ static int mwifiex_init_priv(struct mwifiex_private *priv)
 	memset(priv->curr_addr, 0xff, ETH_ALEN);
 
 	priv->pkt_tx_ctrl = 0;
-	priv->bss_mode = MWIFIEX_BSS_MODE_INFRA;
+	priv->bss_mode = NL80211_IFTYPE_STATION;
 	priv->data_rate = 0;	/* Initially indicate the rate as auto */
 	priv->is_data_rate_auto = true;
 	priv->bcn_avg_factor = DEFAULT_BCN_AVG_FACTOR;
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index b7e4571..7fb81df 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -66,12 +66,6 @@ struct mwifiex_scan_resp {
 	u8 *scan_table;
 };
 
-enum {
-	MWIFIEX_BSS_MODE_INFRA = 1,
-	MWIFIEX_BSS_MODE_IBSS,
-	MWIFIEX_BSS_MODE_AUTO
-};
-
 #define MWIFIEX_PROMISC_MODE            1
 #define MWIFIEX_MULTICAST_MODE		2
 #define	MWIFIEX_ALL_MULTI_MODE		4
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 08fa721..d8c7c5f 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -808,7 +808,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 
 	/* Set the BSS mode */
 	adhoc_start->bss_mode = HostCmd_BSS_MODE_IBSS;
-	bss_desc->bss_mode = MWIFIEX_BSS_MODE_IBSS;
+	bss_desc->bss_mode = NL80211_IFTYPE_ADHOC;
 	adhoc_start->beacon_period = cpu_to_le16(priv->beacon_period);
 	bss_desc->beacon_period = priv->beacon_period;
 
@@ -1289,8 +1289,8 @@ int mwifiex_associate(struct mwifiex_private *priv,
 	u8 current_bssid[ETH_ALEN];
 
 	/* Return error if the adapter or table entry is not marked as infra */
-	if ((priv->bss_mode != MWIFIEX_BSS_MODE_INFRA) ||
-	    (bss_desc->bss_mode != MWIFIEX_BSS_MODE_INFRA))
+	if ((priv->bss_mode != NL80211_IFTYPE_STATION) ||
+	    (bss_desc->bss_mode != NL80211_IFTYPE_STATION))
 		return -1;
 
 	memcpy(&current_bssid,
@@ -1358,7 +1358,7 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
 	    !mwifiex_ssid_cmp(&bss_desc->ssid,
 			      &priv->curr_bss_params.bss_descriptor.ssid) &&
 	    (priv->curr_bss_params.bss_descriptor.bss_mode ==
-	     MWIFIEX_BSS_MODE_IBSS)) {
+							NL80211_IFTYPE_ADHOC)) {
 		dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: new ad-hoc SSID"
 			" is the same as current; not attempting to re-join\n");
 		return -1;
@@ -1421,9 +1421,9 @@ int mwifiex_deauthenticate(struct mwifiex_private *priv,
 	int ret = 0;
 
 	if (priv->media_connected) {
-		if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA) {
+		if (priv->bss_mode == NL80211_IFTYPE_STATION) {
 			ret = mwifiex_deauthenticate_infra(priv, wait, mac);
-		} else if (priv->bss_mode == MWIFIEX_BSS_MODE_IBSS) {
+		} else if (priv->bss_mode == NL80211_IFTYPE_ADHOC) {
 			ret = mwifiex_prepare_cmd(priv,
 					HostCmd_CMD_802_11_AD_HOC_STOP,
 					HostCmd_ACT_GEN_SET, 0, wait, NULL);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 7bcb2e9..12b9a36 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -877,7 +877,7 @@ mwifiex_queuing_ra_based(struct mwifiex_private *priv)
 	 * Currently we assume if we are in Infra, then DA=RA. This might not be
 	 * true in the future
 	 */
-	if ((priv->bss_mode == MWIFIEX_BSS_MODE_INFRA) &&
+	if ((priv->bss_mode == NL80211_IFTYPE_STATION) &&
 	    (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA))
 		return false;
 
@@ -1003,8 +1003,6 @@ int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
 int mwifiex_change_adhoc_chan(struct mwifiex_private *priv, int channel);
 int mwifiex_set_radio(struct mwifiex_private *priv, u8 option);
 
-int mwifiex_drv_get_mode(struct mwifiex_private *priv, u8 wait_option);
-
 int mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel);
 
 int mwifiex_set_encode(struct mwifiex_private *priv, const u8 *key,
@@ -1043,9 +1041,6 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv, int type, int dbm);
 
 int mwifiex_main_process(struct mwifiex_adapter *);
 
-int mwifiex_bss_ioctl_mode(struct mwifiex_private *,
-			   struct mwifiex_wait_queue *,
-			   u16 action, int *mode);
 int mwifiex_bss_ioctl_channel(struct mwifiex_private *,
 			      u16 action,
 			      struct mwifiex_chan_freq_power *cfp);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 1152beb..69ea32f 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -455,8 +455,8 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index, u32 mode)
 	bss_desc->disable_11n = false;
 
 	/* Don't check for compatibility if roaming */
-	if (priv->media_connected && (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA)
-	    && (bss_desc->bss_mode == MWIFIEX_BSS_MODE_INFRA))
+	if (priv->media_connected && (priv->bss_mode == NL80211_IFTYPE_STATION)
+	    && (bss_desc->bss_mode == NL80211_IFTYPE_STATION))
 		return index;
 
 	if (priv->wps.session_enable) {
@@ -573,8 +573,8 @@ mwifiex_find_best_network_in_list(struct mwifiex_private *priv)
 
 	for (i = 0; i < adapter->num_in_scan_table; i++) {
 		switch (mode) {
-		case MWIFIEX_BSS_MODE_INFRA:
-		case MWIFIEX_BSS_MODE_IBSS:
+		case NL80211_IFTYPE_STATION:
+		case NL80211_IFTYPE_ADHOC:
 			if (mwifiex_is_network_compatible(priv, i, mode) >= 0) {
 				if (SCAN_RSSI(adapter->scan_table[i].rssi) >
 				    best_rssi) {
@@ -584,7 +584,7 @@ mwifiex_find_best_network_in_list(struct mwifiex_private *priv)
 				}
 			}
 			break;
-		case MWIFIEX_BSS_MODE_AUTO:
+		case NL80211_IFTYPE_UNSPECIFIED:
 		default:
 			if (SCAN_RSSI(adapter->scan_table[i].rssi) >
 			    best_rssi) {
@@ -1314,9 +1314,9 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 	}
 
 	if (bss_entry->cap_info_bitmap & WLAN_CAPABILITY_IBSS)
-		bss_entry->bss_mode = MWIFIEX_BSS_MODE_IBSS;
+		bss_entry->bss_mode = NL80211_IFTYPE_ADHOC;
 	else
-		bss_entry->bss_mode = MWIFIEX_BSS_MODE_INFRA;
+		bss_entry->bss_mode = NL80211_IFTYPE_STATION;
 
 
 	/* Process variable IE */
@@ -2251,8 +2251,7 @@ mwifiex_scan_delete_ssid_table_entry(struct mwifiex_private *priv,
 	   searching the table for multiple entires for the SSID until no
 	   more are found */
 	while ((table_idx = mwifiex_find_ssid_in_list(priv, del_ssid, NULL,
-						      MWIFIEX_BSS_MODE_AUTO)) >=
-	       0) {
+					NL80211_IFTYPE_UNSPECIFIED)) >= 0) {
 		dev_dbg(priv->adapter->dev,
 			"info: Scan: Delete SSID Entry: Found Idx = %d\n",
 		       table_idx);
@@ -2746,8 +2745,8 @@ mwifiex_find_ssid_in_list(struct mwifiex_private *priv,
 		     (priv, (u8) adapter->scan_table[i].bss_band,
 		      (u16) adapter->scan_table[i].channel))) {
 			switch (mode) {
-			case MWIFIEX_BSS_MODE_INFRA:
-			case MWIFIEX_BSS_MODE_IBSS:
+			case NL80211_IFTYPE_STATION:
+			case NL80211_IFTYPE_ADHOC:
 				j = mwifiex_is_network_compatible(priv, i,
 								  mode);
 
@@ -2765,7 +2764,7 @@ mwifiex_find_ssid_in_list(struct mwifiex_private *priv,
 						net = j;
 				}
 				break;
-			case MWIFIEX_BSS_MODE_AUTO:
+			case NL80211_IFTYPE_UNSPECIFIED:
 			default:
 				/*
 				 * Do not check compatibility if the mode
@@ -2829,8 +2828,8 @@ mwifiex_find_bssid_in_list(struct mwifiex_private *priv, u8 *bssid,
 							    scan_table[i].
 							    channel)) {
 			switch (mode) {
-			case MWIFIEX_BSS_MODE_INFRA:
-			case MWIFIEX_BSS_MODE_IBSS:
+			case NL80211_IFTYPE_STATION:
+			case NL80211_IFTYPE_ADHOC:
 				net = mwifiex_is_network_compatible(priv, i,
 								    mode);
 				break;
@@ -2881,7 +2880,7 @@ int mwifiex_find_best_network(struct mwifiex_private *priv,
 		       (u8 *) &req_bss->mac_address, ETH_ALEN);
 
 		/* Make sure we are in the right mode */
-		if (priv->bss_mode == MWIFIEX_BSS_MODE_AUTO)
+		if (priv->bss_mode == NL80211_IFTYPE_UNSPECIFIED)
 			priv->bss_mode = req_bss->bss_mode;
 	}
 
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 795b1ea..6fff261 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1089,10 +1089,10 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		break;
 	case HostCmd_CMD_SET_BSS_MODE:
 		cmd_ptr->command = cpu_to_le16(cmd_no);
-		if (priv->bss_mode == MWIFIEX_BSS_MODE_IBSS)
+		if (priv->bss_mode == NL80211_IFTYPE_ADHOC)
 			cmd_ptr->params.bss_mode.con_type =
 				CONNECTION_TYPE_ADHOC;
-		else if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA)
+		else if (priv->bss_mode == NL80211_IFTYPE_STATION)
 			cmd_ptr->params.bss_mode.con_type =
 				CONNECTION_TYPE_INFRA;
 		cmd_ptr->size = cpu_to_le16(sizeof(struct
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index ae960dd..b220b8b 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -65,7 +65,7 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 			if (le16_to_cpu(pm->action) == EN_AUTO_PS &&
 				(le16_to_cpu(pm->params.auto_ps.ps_bitmap) &
 				 BITMAP_STA_PS)
-				&& priv->bss_mode == MWIFIEX_BSS_MODE_IBSS)
+				&& priv->bss_mode == NL80211_IFTYPE_ADHOC)
 				adapter->ps_mode =
 					MWIFIEX_802_11_POWER_MODE_CAM;
 		}
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index d4a5c1f..0187185 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -82,7 +82,7 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 	priv->is_data_rate_auto = true;
 	priv->data_rate = 0;
 
-	if (priv->bss_mode == MWIFIEX_BSS_MODE_IBSS) {
+	if (priv->bss_mode == NL80211_IFTYPE_ADHOC) {
 		priv->adhoc_state = ADHOC_IDLE;
 		priv->adhoc_is_link_sensed = false;
 	}
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 362301f..abad07e 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -404,7 +404,7 @@ static int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 	if (!ssid_bssid)
 		return -1;
 
-	if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA) {
+	if (priv->bss_mode == NL80211_IFTYPE_STATION) {
 		/* Infra mode */
 		ret = mwifiex_deauthenticate(priv, NULL, NULL);
 		if (ret)
@@ -413,11 +413,11 @@ static int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 		/* Search for the requested SSID in the scan table */
 		if (ssid_bssid->ssid.ssid_len)
 			i = mwifiex_find_ssid_in_list(priv, &ssid_bssid->ssid,
-						NULL, MWIFIEX_BSS_MODE_INFRA);
+						NULL, NL80211_IFTYPE_STATION);
 		else
 			i = mwifiex_find_bssid_in_list(priv,
 						(u8 *) &ssid_bssid->bssid,
-						MWIFIEX_BSS_MODE_INFRA);
+						NL80211_IFTYPE_STATION);
 		if (i < 0)
 			return -1;
 
@@ -451,11 +451,11 @@ static int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 		if (ssid_bssid->ssid.ssid_len)
 			i = mwifiex_find_ssid_in_list(priv,
 						      &ssid_bssid->ssid, NULL,
-						      MWIFIEX_BSS_MODE_IBSS);
+						      NL80211_IFTYPE_ADHOC);
 		else
 			i = mwifiex_find_bssid_in_list(priv,
 						       (u8 *)&ssid_bssid->bssid,
-						       MWIFIEX_BSS_MODE_IBSS);
+						       NL80211_IFTYPE_ADHOC);
 
 		if (i >= 0) {
 			dev_dbg(adapter->dev, "info: network found in scan"
@@ -1021,50 +1021,6 @@ int mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
 }
 
 /*
- * IOCTL request handler to set/get BSS mode.
- *
- * This function prepares the correct firmware command and
- * issues it to set or get the BSS mode.
- *
- * In case the mode is changed, a deauthentication is performed
- * first by the function automatically.
- */
-int mwifiex_bss_ioctl_mode(struct mwifiex_private *priv,
-			   struct mwifiex_wait_queue *wait,
-			   u16 action, int *mode)
-{
-	int ret = 0;
-
-	if (!mode)
-		return -1;
-
-	if (action == HostCmd_ACT_GEN_GET) {
-		*mode = priv->bss_mode;
-		return 0;
-	}
-
-	if ((priv->bss_mode == *mode) || (*mode == MWIFIEX_BSS_MODE_AUTO)) {
-		dev_dbg(priv->adapter->dev,
-			"info: Already set to required mode! No change!\n");
-		priv->bss_mode = *mode;
-		return 0;
-	}
-
-	ret = mwifiex_deauthenticate(priv, wait, NULL);
-
-	priv->sec_info.authentication_mode = MWIFIEX_AUTH_MODE_OPEN;
-	priv->bss_mode = *mode;
-	if (priv->bss_mode != MWIFIEX_BSS_MODE_AUTO) {
-		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
-					  HostCmd_ACT_GEN_SET, 0, wait, NULL);
-		if (!ret)
-			ret = -EINPROGRESS;
-	}
-
-	return ret;
-}
-
-/*
  * IOCTL request handler to set/get Ad-Hoc channel.
  *
  * This function prepares the correct firmware command and
@@ -1237,33 +1193,6 @@ done:
 }
 
 /*
- * IOCTL request handler to get current driver mode.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_drv_get_mode(struct mwifiex_private *priv, u8 wait_option)
-{
-	struct mwifiex_wait_queue *wait = NULL;
-	int status = 0;
-	int mode = -1;
-
-	/* Allocate wait buffer */
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -1;
-
-	status = mwifiex_bss_ioctl_mode(priv, wait, HostCmd_ACT_GEN_GET, &mode);
-
-	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
-
-	if (wait && (status != -EINPROGRESS))
-		kfree(wait);
-	return mode;
-}
-
-/*
  * IOCTL request handler to get rate.
  *
  * This function prepares the correct firmware command and
@@ -1780,7 +1709,7 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
 		return -1;
 	}
 
-	if (priv->bss_mode == MWIFIEX_BSS_MODE_IBSS) {
+	if (priv->bss_mode == NL80211_IFTYPE_ADHOC) {
 		/*
 		 * IBSS/WPA-None uses only one key (Group) for both receiving
 		 * and sending unicast and multicast packets.
-- 
1.7.0.2

