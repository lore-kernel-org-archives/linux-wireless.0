Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:39669 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab1DPDq3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 23:46:29 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/3] mwifiex: remove redundant local variables and comments
Date: Fri, 15 Apr 2011 20:50:40 -0700
Message-Id: <1302925842-27718-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Remove some local variables (mainly function return values)
that are used only once. Also, one dummy function and some
wordy comments are removed.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   24 +----
 drivers/net/wireless/mwifiex/cfg80211.c      |  131 +++++++++-----------------
 drivers/net/wireless/mwifiex/cfp.c           |    8 +-
 drivers/net/wireless/mwifiex/init.c          |    5 +-
 drivers/net/wireless/mwifiex/join.c          |   50 +++-------
 drivers/net/wireless/mwifiex/main.c          |   19 +---
 drivers/net/wireless/mwifiex/scan.c          |   23 ++---
 drivers/net/wireless/mwifiex/sdio.c          |   16 +---
 drivers/net/wireless/mwifiex/sta_ioctl.c     |   85 ++++-------------
 drivers/net/wireless/mwifiex/sta_tx.c        |    6 +-
 drivers/net/wireless/mwifiex/txrx.c          |    4 +-
 drivers/net/wireless/mwifiex/util.c          |    6 +-
 drivers/net/wireless/mwifiex/wmm.c           |    5 +-
 13 files changed, 105 insertions(+), 277 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 755e5d5..a93c03f 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -27,19 +27,6 @@
 #include "11n_rxreorder.h"
 
 /*
- * This function processes a received packet and forwards
- * it to the kernel/upper layer.
- */
-static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
-{
-	int ret = 0;
-	struct mwifiex_adapter *adapter = priv->adapter;
-
-	ret = mwifiex_process_rx_packet(adapter, (struct sk_buff *) payload);
-	return ret;
-}
-
-/*
  * This function dispatches all packets in the Rx reorder table.
  *
  * There could be holes in the buffer, which are skipped by the function.
@@ -51,7 +38,7 @@ mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
 					 struct mwifiex_rx_reorder_tbl
 					 *rx_reor_tbl_ptr, int start_win)
 {
-	int no_pkt_to_send, i, xchg;
+	int no_pkt_to_send, i;
 	void *rx_tmp_ptr = NULL;
 	unsigned long flags;
 
@@ -68,7 +55,7 @@ mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
 		}
 		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 		if (rx_tmp_ptr)
-			mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
+			mwifiex_process_rx_packet(priv->adapter, rx_tmp_ptr);
 	}
 
 	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
@@ -76,8 +63,7 @@ mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
 	 * We don't have a circular buffer, hence use rotation to simulate
 	 * circular buffer
 	 */
-	xchg = rx_reor_tbl_ptr->win_size - no_pkt_to_send;
-	for (i = 0; i < xchg; ++i) {
+	for (i = 0; i < rx_reor_tbl_ptr->win_size - no_pkt_to_send; ++i) {
 		rx_reor_tbl_ptr->rx_reorder_ptr[i] =
 			rx_reor_tbl_ptr->rx_reorder_ptr[no_pkt_to_send + i];
 		rx_reor_tbl_ptr->rx_reorder_ptr[no_pkt_to_send + i] = NULL;
@@ -114,7 +100,7 @@ mwifiex_11n_scan_and_dispatch(struct mwifiex_private *priv,
 		rx_tmp_ptr = rx_reor_tbl_ptr->rx_reorder_ptr[i];
 		rx_reor_tbl_ptr->rx_reorder_ptr[i] = NULL;
 		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
-		mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
+		mwifiex_process_rx_packet(priv->adapter, rx_tmp_ptr);
 	}
 
 	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
@@ -429,7 +415,7 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 						tid, ta);
 	if (!rx_reor_tbl_ptr) {
 		if (pkt_type != PKT_TYPE_BAR)
-			mwifiex_11n_dispatch_pkt(priv, payload);
+			mwifiex_process_rx_packet(priv->adapter, payload);
 		return 0;
 	}
 	start_win = rx_reor_tbl_ptr->start_win;
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 74b6cf2..b99ae26 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -34,22 +34,17 @@ static int
 mwifiex_cfg80211_channel_type_to_mwifiex_channels(enum nl80211_channel_type
 						  channel_type)
 {
-	int channel;
 	switch (channel_type) {
 	case NL80211_CHAN_NO_HT:
 	case NL80211_CHAN_HT20:
-		channel = NO_SEC_CHANNEL;
-		break;
+		return NO_SEC_CHANNEL;
 	case NL80211_CHAN_HT40PLUS:
-		channel = SEC_CHANNEL_ABOVE;
-		break;
+		return SEC_CHANNEL_ABOVE;
 	case NL80211_CHAN_HT40MINUS:
-		channel = SEC_CHANNEL_BELOW;
-		break;
+		return SEC_CHANNEL_BELOW;
 	default:
-		channel = NO_SEC_CHANNEL;
+		return NO_SEC_CHANNEL;
 	}
-	return channel;
 }
 
 /*
@@ -64,21 +59,16 @@ mwifiex_cfg80211_channel_type_to_mwifiex_channels(enum nl80211_channel_type
 static enum nl80211_channel_type
 mwifiex_channels_to_cfg80211_channel_type(int channel_type)
 {
-	int channel;
 	switch (channel_type) {
 	case NO_SEC_CHANNEL:
-		channel = NL80211_CHAN_HT20;
-		break;
+		return NL80211_CHAN_HT20;
 	case SEC_CHANNEL_ABOVE:
-		channel = NL80211_CHAN_HT40PLUS;
-		break;
+		return NL80211_CHAN_HT40PLUS;
 	case SEC_CHANNEL_BELOW:
-		channel = NL80211_CHAN_HT40MINUS;
-		break;
+		return NL80211_CHAN_HT40MINUS;
 	default:
-		channel = NL80211_CHAN_HT20;
+		return NL80211_CHAN_HT20;
 	}
-	return channel;
 }
 
 /*
@@ -117,10 +107,8 @@ mwifiex_cfg80211_del_key(struct wiphy *wiphy, struct net_device *netdev,
 			 u8 key_index, bool pairwise, const u8 *mac_addr)
 {
 	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
-	int ret = 0;
 
-	ret = mwifiex_set_encode(priv, NULL, 0, key_index, 1);
-	if (ret) {
+	if (mwifiex_set_encode(priv, NULL, 0, key_index, 1)) {
 		wiphy_err(wiphy, "deleting the crypto keys\n");
 		return -EFAULT;
 	}
@@ -137,7 +125,6 @@ mwifiex_cfg80211_set_tx_power(struct wiphy *wiphy,
 			      enum nl80211_tx_power_setting type,
 			      int dbm)
 {
-	int ret = 0;
 	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 	struct mwifiex_power_cfg power_cfg;
 
@@ -148,9 +135,7 @@ mwifiex_cfg80211_set_tx_power(struct wiphy *wiphy,
 		power_cfg.is_power_auto = 1;
 	}
 
-	ret = mwifiex_set_tx_power(priv, &power_cfg);
-
-	return ret;
+	return mwifiex_set_tx_power(priv, &power_cfg);
 }
 
 /*
@@ -163,7 +148,6 @@ mwifiex_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 				struct net_device *dev,
 				bool enabled, int timeout)
 {
-	int ret = 0;
 	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 	u32 ps_mode;
 
@@ -173,9 +157,8 @@ mwifiex_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 			" for IEEE power save\n");
 
 	ps_mode = enabled;
-	ret = mwifiex_drv_set_power(priv, &ps_mode);
 
-	return ret;
+	return mwifiex_drv_set_power(priv, &ps_mode);
 }
 
 /*
@@ -187,18 +170,15 @@ mwifiex_cfg80211_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
 				 bool multicast)
 {
 	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
-	int ret;
 
 	/* Return if WEP key not configured */
 	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED)
 		return 0;
 
-	ret = mwifiex_set_encode(priv, NULL, 0, key_index, 0);
-
-	wiphy_dbg(wiphy, "info: set default Tx key index\n");
-
-	if (ret)
+	if (mwifiex_set_encode(priv, NULL, 0, key_index, 0)) {
+		wiphy_err(wiphy, "set default Tx key index\n");
 		return -EFAULT;
+	}
 
 	return 0;
 }
@@ -212,15 +192,12 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
 			 struct key_params *params)
 {
 	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
-	int ret = 0;
 
-	ret = mwifiex_set_encode(priv, params->key, params->key_len,
-								key_index, 0);
-
-	wiphy_dbg(wiphy, "info: crypto keys added\n");
-
-	if (ret)
+	if (mwifiex_set_encode(priv, params->key, params->key_len,
+							key_index, 0)) {
+		wiphy_err(wiphy, "crypto keys added\n");
 		return -EFAULT;
+	}
 
 	return 0;
 }
@@ -245,7 +222,6 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_802_11d_domain_reg *domain_info = &adapter->domain_reg;
-	int ret = 0;
 
 	/* Set country code */
 	domain_info->country_code[0] = priv->country_code[0];
@@ -300,13 +276,14 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 	}
 
 	domain_info->no_of_triplet = no_of_triplet;
-	/* Send cmd to FW to set domain info */
-	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_802_11D_DOMAIN_INFO,
-				     HostCmd_ACT_GEN_SET, 0, NULL);
-	if (ret)
+
+	if (mwifiex_send_cmd_async(priv, HostCmd_CMD_802_11D_DOMAIN_INFO,
+				     HostCmd_ACT_GEN_SET, 0, NULL)) {
 		wiphy_err(wiphy, "11D: setting domain info in FW\n");
+		return -1;
+	}
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -356,7 +333,6 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 		       enum nl80211_channel_type channel_type)
 {
 	struct mwifiex_chan_freq_power cfp;
-	int ret = 0;
 	struct mwifiex_ds_band_cfg band_cfg;
 	u32 config_bands = 0;
 	struct wiphy *wiphy = priv->wdev->wiphy;
@@ -375,14 +351,14 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 			band_cfg.config_bands = config_bands;
 			band_cfg.adhoc_start_band = config_bands;
 		}
-		/* Set channel offset */
+
 		band_cfg.sec_chan_offset =
 			mwifiex_cfg80211_channel_type_to_mwifiex_channels
 			(channel_type);
-		ret = mwifiex_set_radio_band_cfg(priv, &band_cfg);
 
-		if (ret)
+		if (mwifiex_set_radio_band_cfg(priv, &band_cfg))
 			return -EFAULT;
+
 		mwifiex_send_domain_info_cmd_fw(wiphy);
 	}
 
@@ -390,20 +366,16 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 		"mode %d\n", config_bands, band_cfg.sec_chan_offset,
 		priv->bss_mode);
 	if (!chan)
-		return ret;
+		return 0;
 
 	memset(&cfp, 0, sizeof(cfp));
 	cfp.freq = chan->center_freq;
-	/* Convert frequency to channel */
 	cfp.channel = ieee80211_frequency_to_channel(chan->center_freq);
 
-	ret = mwifiex_bss_set_channel(priv, &cfp);
-	if (ret)
+	if (mwifiex_bss_set_channel(priv, &cfp))
 		return -EFAULT;
 
-	ret = mwifiex_drv_change_adhoc_chan(priv, cfp.channel);
-
-	return ret;
+	return mwifiex_drv_change_adhoc_chan(priv, cfp.channel);
 }
 
 /*
@@ -459,17 +431,12 @@ mwifiex_set_frag(struct mwifiex_private *priv, u32 frag_thr)
 static int
 mwifiex_set_rts(struct mwifiex_private *priv, u32 rts_thr)
 {
-	int ret = 0;
-
 	if (rts_thr < MWIFIEX_RTS_MIN_VALUE || rts_thr > MWIFIEX_RTS_MAX_VALUE)
 		rts_thr = MWIFIEX_RTS_MAX_VALUE;
 
-	/* Send request to firmware */
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_SNMP_MIB,
+	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_SNMP_MIB,
 				    HostCmd_ACT_GEN_SET, RTS_THRESH_I,
 				    &rts_thr);
-
-	return ret;
 }
 
 /*
@@ -485,8 +452,11 @@ mwifiex_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 
 	int ret = 0;
 
-	if (changed & WIPHY_PARAM_RTS_THRESHOLD)
+	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
 		ret = mwifiex_set_rts(priv, wiphy->rts_threshold);
+		if (ret)
+			return ret;
+	}
 
 	if (changed & WIPHY_PARAM_FRAG_THRESHOLD)
 		ret = mwifiex_set_frag(priv, wiphy->frag_threshold);
@@ -598,7 +568,6 @@ mwifiex_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 			     u8 *mac, struct station_info *sinfo)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
-	int ret = 0;
 
 	mwifiex_dump_station_info(priv, sinfo);
 
@@ -607,10 +576,7 @@ mwifiex_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 	if (memcmp(mac, priv->cfg_bssid, ETH_ALEN))
 		return -ENOENT;
 
-
-	ret = mwifiex_dump_station_info(priv, sinfo);
-
-	return ret;
+	return mwifiex_dump_station_info(priv, sinfo);
 }
 
 /* Supported rates to be advertised to the cfg80211 */
@@ -749,15 +715,13 @@ mwifiex_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
  */
 static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 {
-	int ret = 0;
 	struct ieee80211_channel *chan;
 	struct mwifiex_bss_info bss_info;
 	int ie_len = 0;
 	u8 ie_buf[IEEE80211_MAX_SSID_LEN + sizeof(struct ieee_types_header)];
 
-	ret = mwifiex_get_bss_info(priv, &bss_info);
-	if (ret)
-		return ret;
+	if (mwifiex_get_bss_info(priv, &bss_info))
+		return -1;
 
 	ie_buf[0] = WLAN_EID_SSID;
 	ie_buf[1] = bss_info.ssid.ssid_len;
@@ -776,7 +740,7 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 		0, ie_buf, ie_len, 0, GFP_KERNEL);
 	memcpy(priv->cfg_bssid, bss_info.bssid, ETH_ALEN);
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -805,9 +769,8 @@ static int mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 	struct mwifiex_bssdescriptor *scan_table;
 	int i, j;
 	struct ieee80211_channel *chan;
-	u8 *ie, *tmp, *ie_buf;
+	u8 *ie, *ie_buf;
 	u32 ie_len;
-	u64 ts = 0;
 	u8 *beacon;
 	int beacon_size;
 	u8 element_id, element_len;
@@ -889,9 +852,9 @@ static int mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 			case WLAN_EID_BSS_AC_ACCESS_DELAY:
 				ie[0] = element_id;
 				ie[1] = element_len;
-				tmp = (u8 *) beacon;
 				memcpy(&ie[sizeof(struct ieee_types_header)],
-				       tmp + sizeof(struct ieee_types_header),
+				       (u8 *) beacon
+				       + sizeof(struct ieee_types_header),
 				       element_len);
 				ie_len += ie[1] +
 					sizeof(struct ieee_types_header);
@@ -908,7 +871,7 @@ static int mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 						scan_table[i].freq);
 		cfg80211_inform_bss(priv->wdev->wiphy, chan,
 					scan_table[i].mac_address,
-					ts, scan_table[i].cap_info_bitmap,
+					0, scan_table[i].cap_info_bitmap,
 					scan_table[i].beacon_period,
 					ie_buf, ie_len,
 					scan_table[i].rssi, GFP_KERNEL);
@@ -941,9 +904,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	struct mwifiex_802_11_ssid req_ssid;
 	struct mwifiex_ssid_bssid ssid_bssid;
 	int ret = 0;
-	int auth_type = 0, pairwise_encrypt_mode = 0;
-	int group_encrypt_mode = 0;
-	int alg_is_wep = 0;
+	int auth_type = 0;
 
 	memset(&req_ssid, 0, sizeof(struct mwifiex_802_11_ssid));
 	memset(&ssid_bssid, 0, sizeof(struct mwifiex_ssid_bssid));
@@ -1009,9 +970,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 		ret = mwifiex_set_gen_ie(priv, sme->ie, sme->ie_len);
 
 	if (sme->key) {
-		alg_is_wep = mwifiex_is_alg_wep(pairwise_encrypt_mode)
-			| mwifiex_is_alg_wep(group_encrypt_mode);
-		if (alg_is_wep) {
+		if (mwifiex_is_alg_wep(0) | mwifiex_is_alg_wep(0)) {
 			dev_dbg(priv->adapter->dev,
 				"info: setting wep encryption"
 				" with key len %d\n", sme->key_len);
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index bb73cfe..d0cada5 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -145,16 +145,12 @@ u8 mwifiex_data_rate_to_index(u32 rate)
  */
 u32 mwifiex_get_active_data_rates(struct mwifiex_private *priv, u8 *rates)
 {
-	u32 k;
-
 	if (!priv->media_connected)
-		k = mwifiex_get_supported_rates(priv, rates);
+		return mwifiex_get_supported_rates(priv, rates);
 	else
-		k = mwifiex_copy_rates(rates, 0,
+		return mwifiex_copy_rates(rates, 0,
 				       priv->curr_bss_params.data_rates,
 				       priv->curr_bss_params.num_of_rates);
-
-	return k;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 1b79a5a..fc2c0c5 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -71,7 +71,6 @@ static int mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
 static int mwifiex_init_priv(struct mwifiex_private *priv)
 {
 	u32 i;
-	int ret = 0;
 
 	priv->media_connected = false;
 	memset(priv->curr_addr, 0xff, ETH_ALEN);
@@ -139,9 +138,7 @@ static int mwifiex_init_priv(struct mwifiex_private *priv)
 
 	priv->scan_block = false;
 
-	ret = mwifiex_add_bss_prio_tbl(priv);
-
-	return ret;
+	return mwifiex_add_bss_prio_tbl(priv);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 60d25c6..8e1cb4b 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -749,7 +749,7 @@ int
 mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 				struct host_cmd_ds_command *cmd, void *data_buf)
 {
-	int ret = 0, rsn_ie_len = 0;
+	int rsn_ie_len = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_802_11_ad_hoc_start *adhoc_start =
 		&cmd->params.adhoc_start;
@@ -879,11 +879,9 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	mwifiex_get_active_data_rates(priv, adhoc_start->DataRate);
 	if ((adapter->adhoc_start_band & BAND_G) &&
 	    (priv->curr_pkt_filter & HostCmd_ACT_MAC_ADHOC_G_PROTECTION_ON)) {
-		ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_MAC_CONTROL,
+		if (mwifiex_send_cmd_async(priv, HostCmd_CMD_MAC_CONTROL,
 					     HostCmd_ACT_GEN_SET, 0,
-					     &priv->curr_pkt_filter);
-
-		if (ret) {
+					     &priv->curr_pkt_filter)) {
 			dev_err(adapter->dev,
 			       "ADHOC_S_CMD: G Protection config failed\n");
 			return -1;
@@ -1039,7 +1037,7 @@ int
 mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 			       struct host_cmd_ds_command *cmd, void *data_buf)
 {
-	int ret = 0, rsn_ie_len = 0;
+	int rsn_ie_len = 0;
 	struct host_cmd_ds_802_11_ad_hoc_join *adhoc_join =
 		&cmd->params.adhoc_join;
 	struct mwifiex_bssdescriptor *bss_desc =
@@ -1060,10 +1058,9 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 			priv->
 			curr_pkt_filter | HostCmd_ACT_MAC_ADHOC_G_PROTECTION_ON;
 
-		ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_MAC_CONTROL,
+		if (mwifiex_send_cmd_async(priv, HostCmd_CMD_MAC_CONTROL,
 					     HostCmd_ACT_GEN_SET, 0,
-					     &curr_pkt_filter);
-		if (ret) {
+					     &curr_pkt_filter)) {
 			dev_err(priv->adapter->dev,
 			       "ADHOC_J_CMD: G Protection config failed\n");
 			return -1;
@@ -1174,7 +1171,7 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 
 	adhoc_join->bss_descriptor.cap_info_bitmap = cpu_to_le16(tmp_cap);
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -1192,15 +1189,13 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_802_11_ad_hoc_result *adhoc_result;
 	struct mwifiex_bssdescriptor *bss_desc;
-	u16 command = le16_to_cpu(resp->command);
-	u16 result = le16_to_cpu(resp->result);
 
 	adhoc_result = &resp->params.adhoc_result;
 
 	bss_desc = priv->attempted_bss_desc;
 
 	/* Join result code 0 --> SUCCESS */
-	if (result) {
+	if (le16_to_cpu(resp->result)) {
 		dev_err(priv->adapter->dev, "ADHOC_RESP: failed\n");
 		if (priv->media_connected)
 			mwifiex_reset_connect_state(priv);
@@ -1215,7 +1210,7 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 	/* Send a Media Connected event, according to the Spec */
 	priv->media_connected = true;
 
-	if (command == HostCmd_CMD_802_11_AD_HOC_START) {
+	if (le16_to_cpu(resp->command) == HostCmd_CMD_802_11_AD_HOC_START) {
 		dev_dbg(priv->adapter->dev, "info: ADHOC_S_RESP %s\n",
 				bss_desc->ssid.ssid);
 
@@ -1278,7 +1273,6 @@ done:
 int mwifiex_associate(struct mwifiex_private *priv,
 		      struct mwifiex_bssdescriptor *bss_desc)
 {
-	int ret = 0;
 	u8 current_bssid[ETH_ALEN];
 
 	/* Return error if the adapter or table entry is not marked as infra */
@@ -1294,10 +1288,8 @@ int mwifiex_associate(struct mwifiex_private *priv,
 	   retrieval */
 	priv->assoc_rsp_size = 0;
 
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_ASSOCIATE,
+	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_ASSOCIATE,
 				    HostCmd_ACT_GEN_SET, 0, bss_desc);
-
-	return ret;
 }
 
 /*
@@ -1309,8 +1301,6 @@ int
 mwifiex_adhoc_start(struct mwifiex_private *priv,
 		    struct mwifiex_802_11_ssid *adhoc_ssid)
 {
-	int ret = 0;
-
 	dev_dbg(priv->adapter->dev, "info: Adhoc Channel = %d\n",
 		priv->adhoc_channel);
 	dev_dbg(priv->adapter->dev, "info: curr_bss_params.channel = %d\n",
@@ -1318,10 +1308,8 @@ mwifiex_adhoc_start(struct mwifiex_private *priv,
 	dev_dbg(priv->adapter->dev, "info: curr_bss_params.band = %d\n",
 	       priv->curr_bss_params.band);
 
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_AD_HOC_START,
+	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_AD_HOC_START,
 				    HostCmd_ACT_GEN_SET, 0, adhoc_ssid);
-
-	return ret;
 }
 
 /*
@@ -1333,8 +1321,6 @@ mwifiex_adhoc_start(struct mwifiex_private *priv,
 int mwifiex_adhoc_join(struct mwifiex_private *priv,
 		       struct mwifiex_bssdescriptor *bss_desc)
 {
-	int ret = 0;
-
 	dev_dbg(priv->adapter->dev, "info: adhoc join: curr_bss ssid =%s\n",
 	       priv->curr_bss_params.bss_descriptor.ssid.ssid);
 	dev_dbg(priv->adapter->dev, "info: adhoc join: curr_bss ssid_len =%u\n",
@@ -1360,10 +1346,8 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
 	dev_dbg(priv->adapter->dev, "info: curr_bss_params.band = %c\n",
 	       priv->curr_bss_params.band);
 
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_AD_HOC_JOIN,
+	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_AD_HOC_JOIN,
 				    HostCmd_ACT_GEN_SET, 0, bss_desc);
-
-	return ret;
 }
 
 /*
@@ -1424,21 +1408,15 @@ EXPORT_SYMBOL_GPL(mwifiex_deauthenticate);
 u8
 mwifiex_band_to_radio_type(u8 band)
 {
-	u8 ret_radio_type;
-
 	switch (band) {
 	case BAND_A:
 	case BAND_AN:
 	case BAND_A | BAND_AN:
-		ret_radio_type = HostCmd_SCAN_RADIO_TYPE_A;
-		break;
+		return HostCmd_SCAN_RADIO_TYPE_A;
 	case BAND_B:
 	case BAND_G:
 	case BAND_B | BAND_G:
 	default:
-		ret_radio_type = HostCmd_SCAN_RADIO_TYPE_BG;
-		break;
+		return HostCmd_SCAN_RADIO_TYPE_BG;
 	}
-
-	return ret_radio_type;
 }
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 77abfc3..2c376dd 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -68,7 +68,6 @@ static struct mwifiex_drv_mode mwifiex_drv_mode_tbl[] = {
 static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 			    struct mwifiex_device *mdevice, void **padapter)
 {
-	int ret = 0;
 	struct mwifiex_adapter *adapter = NULL;
 	u8 i = 0;
 
@@ -84,8 +83,7 @@ static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 	memmove(&adapter->if_ops, if_ops, sizeof(struct mwifiex_if_ops));
 
 	/* card specific initialization has been deferred until now .. */
-	ret = adapter->if_ops.init_if(adapter);
-	if (ret)
+	if (adapter->if_ops.init_if(adapter))
 		goto error;
 
 	adapter->priv_num = 0;
@@ -893,7 +891,6 @@ int
 mwifiex_add_card(void *card, struct semaphore *sem,
 		 struct mwifiex_if_ops *if_ops)
 {
-	int status = 0;
 	int i;
 	struct mwifiex_adapter *adapter = NULL;
 	struct mwifiex_drv_mode *drv_mode_info = &mwifiex_drv_mode_tbl[0];
@@ -943,12 +940,9 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 	for (i = 0; i < drv_mode_info->intf_num; i++) {
 		if (!mwifiex_add_interface(adapter, i,
 				adapter->drv_mode->bss_attr[i].bss_type)) {
-			status = -1;
-			break;
+			goto err_add_intf;
 		}
 	}
-	if (status)
-		goto err_add_intf;
 
 	up(sem);
 
@@ -969,8 +963,8 @@ err_kmalloc:
 	    (adapter->hw_status == MWIFIEX_HW_STATUS_READY)) {
 		pr_debug("info: %s: shutdown mwifiex\n", __func__);
 		adapter->init_wait_q_woken = false;
-		status = mwifiex_shutdown_drv(adapter);
-		if (status == -EINPROGRESS)
+
+		if (mwifiex_shutdown_drv(adapter) == -EINPROGRESS)
 			wait_event_interruptible(adapter->init_wait_q,
 						 adapter->init_wait_q_woken);
 	}
@@ -999,7 +993,6 @@ EXPORT_SYMBOL_GPL(mwifiex_add_card);
 int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 {
 	struct mwifiex_private *priv = NULL;
-	int status;
 	int i;
 
 	if (down_interruptible(sem))
@@ -1023,8 +1016,8 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 
 	dev_dbg(adapter->dev, "cmd: calling mwifiex_shutdown_drv...\n");
 	adapter->init_wait_q_woken = false;
-	status = mwifiex_shutdown_drv(adapter);
-	if (status == -EINPROGRESS)
+
+	if (mwifiex_shutdown_drv(adapter) == -EINPROGRESS)
 		wait_event_interruptible(adapter->init_wait_q,
 					 adapter->init_wait_q_woken);
 	dev_dbg(adapter->dev, "cmd: mwifiex_shutdown_drv done\n");
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 8474271..68d905d 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -181,7 +181,6 @@ int mwifiex_find_best_bss(struct mwifiex_private *priv,
 			  struct mwifiex_ssid_bssid *ssid_bssid)
 {
 	struct mwifiex_ssid_bssid tmp_ssid_bssid;
-	int ret = 0;
 	u8 *mac = NULL;
 
 	if (!ssid_bssid)
@@ -189,17 +188,17 @@ int mwifiex_find_best_bss(struct mwifiex_private *priv,
 
 	memcpy(&tmp_ssid_bssid, ssid_bssid,
 	       sizeof(struct mwifiex_ssid_bssid));
-	ret = mwifiex_bss_ioctl_find_bss(priv, &tmp_ssid_bssid);
 
-	if (!ret) {
+	if (!mwifiex_bss_ioctl_find_bss(priv, &tmp_ssid_bssid)) {
 		memcpy(ssid_bssid, &tmp_ssid_bssid,
 		       sizeof(struct mwifiex_ssid_bssid));
 		mac = (u8 *) &ssid_bssid->bssid;
 		dev_dbg(priv->adapter->dev, "cmd: found network: ssid=%s,"
 				" %pM\n", ssid_bssid->ssid.ssid, mac);
+		return 0;
 	}
 
-	return ret;
+	return -1;
 }
 
 /*
@@ -2061,19 +2060,13 @@ mwifiex_process_scan_results(struct mwifiex_private *priv)
 static u8
 mwifiex_radio_type_to_band(u8 radio_type)
 {
-	u8 ret_band;
-
 	switch (radio_type) {
 	case HostCmd_SCAN_RADIO_TYPE_A:
-		ret_band = BAND_A;
-		break;
+		return BAND_A;
 	case HostCmd_SCAN_RADIO_TYPE_BG:
 	default:
-		ret_band = BAND_G;
-		break;
+		return BAND_G;
 	}
-
-	return ret_band;
 }
 
 /*
@@ -2226,8 +2219,7 @@ static int
 mwifiex_scan_delete_ssid_table_entry(struct mwifiex_private *priv,
 				     struct mwifiex_802_11_ssid *del_ssid)
 {
-	int ret = -1;
-	s32 table_idx;
+	s32 table_idx = -1;
 
 	dev_dbg(priv->adapter->dev, "info: scan: delete ssid entry: %-32s\n",
 			del_ssid->ssid);
@@ -2240,11 +2232,10 @@ mwifiex_scan_delete_ssid_table_entry(struct mwifiex_private *priv,
 		dev_dbg(priv->adapter->dev,
 			"info: Scan: Delete SSID Entry: Found Idx = %d\n",
 		       table_idx);
-		ret = 0;
 		mwifiex_scan_delete_table_entry(priv, table_idx);
 	}
 
-	return ret;
+	return table_idx == -1 ? -1 : 0;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 41c087d..5148d0e 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -347,12 +347,9 @@ static int mwifiex_read_data_sync(struct mwifiex_adapter *adapter, u8 *buffer,
  */
 static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 {
-	int ret;
-
 	dev_dbg(adapter->dev, "event: wakeup device...\n");
-	ret = mwifiex_write_reg(adapter, CONFIGURATION_REG, HOST_POWER_UP);
 
-	return ret;
+	return mwifiex_write_reg(adapter, CONFIGURATION_REG, HOST_POWER_UP);
 }
 
 /*
@@ -362,12 +359,9 @@ static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
  */
 static int mwifiex_pm_wakeup_card_complete(struct mwifiex_adapter *adapter)
 {
-	int ret;
-
 	dev_dbg(adapter->dev, "cmd: wakeup device completed\n");
-	ret = mwifiex_write_reg(adapter, CONFIGURATION_REG, 0);
 
-	return ret;
+	return mwifiex_write_reg(adapter, CONFIGURATION_REG, 0);
 }
 
 /*
@@ -1703,13 +1697,9 @@ static struct mwifiex_if_ops sdio_ops = {
 static int
 mwifiex_sdio_init_module(void)
 {
-	int ret;
-
 	sema_init(&add_remove_card_sem, 1);
 
-	ret = sdio_register_driver(&mwifiex_sdio);
-
-	return ret;
+	return sdio_register_driver(&mwifiex_sdio);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 6489f26..03085a3 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -216,7 +216,7 @@ int mwifiex_bss_start(struct mwifiex_private *priv,
 			ret = mwifiex_adhoc_join(priv, &adapter->scan_table[i]);
 			if (ret)
 				return ret;
-		} else {	/* i >= 0 */
+		} else {
 			dev_dbg(adapter->dev, "info: Network not found in "
 				"the list, creating adhoc with ssid = %s\n",
 			       ssid_bssid->ssid.ssid);
@@ -320,16 +320,13 @@ int mwifiex_set_hs_params(struct mwifiex_private *priv, u16 action,
  */
 int mwifiex_cancel_hs(struct mwifiex_private *priv, int cmd_type)
 {
-	int ret = 0;
 	struct mwifiex_ds_hs_cfg hscfg;
 
-	/* Cancel Host Sleep */
 	hscfg.conditions = HOST_SLEEP_CFG_CANCEL;
 	hscfg.is_invoke_hostcmd = true;
-	ret = mwifiex_set_hs_params(priv, HostCmd_ACT_GEN_SET,
-				    cmd_type, &hscfg);
 
-	return ret;
+	return mwifiex_set_hs_params(priv, HostCmd_ACT_GEN_SET,
+				    cmd_type, &hscfg);
 }
 EXPORT_SYMBOL_GPL(mwifiex_cancel_hs);
 
@@ -348,7 +345,6 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 		return true;
 	}
 
-	/* Enable Host Sleep */
 	adapter->hs_activate_wait_q_woken = false;
 
 	memset(&hscfg, 0, sizeof(struct mwifiex_hs_config_param));
@@ -385,23 +381,17 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
 	if (!info)
 		return -1;
 
-	/* Get current BSS info */
 	bss_desc = &priv->curr_bss_params.bss_descriptor;
 
-	/* BSS mode */
 	info->bss_mode = priv->bss_mode;
 
-	/* SSID */
 	memcpy(&info->ssid, &bss_desc->ssid,
 	       sizeof(struct mwifiex_802_11_ssid));
 
-	/* BSSID */
 	memcpy(&info->bssid, &bss_desc->mac_address, ETH_ALEN);
 
-	/* Channel */
 	info->bss_chan = bss_desc->channel;
 
-	/* Region code */
 	info->region_code = adapter->region_code;
 
 	/* Scan table index if connected */
@@ -415,20 +405,15 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
 			info->scan_table_idx = tbl_idx;
 	}
 
-	/* Connection status */
 	info->media_connected = priv->media_connected;
 
-	/* Tx power information */
 	info->max_power_level = priv->max_tx_power_level;
 	info->min_power_level = priv->min_tx_power_level;
 
-	/* AdHoc state */
 	info->adhoc_state = priv->adhoc_state;
 
-	/* Last beacon NF */
 	info->bcn_nf_last = priv->bcn_nf_last;
 
-	/* wep status */
 	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED)
 		info->wep_status = true;
 	else
@@ -574,22 +559,17 @@ int mwifiex_bss_set_channel(struct mwifiex_private *priv,
 static int mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *priv,
 					  u16 action, u16 *channel)
 {
-	int ret = 0;
-
 	if (action == HostCmd_ACT_GEN_GET) {
 		if (!priv->media_connected) {
 			*channel = priv->adhoc_channel;
-			return ret;
+			return 0;
 		}
 	} else {
 		priv->adhoc_channel = (u8) *channel;
 	}
 
-	/* Send request to firmware */
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_RF_CHANNEL,
+	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_RF_CHANNEL,
 				    action, 0, channel);
-
-	return ret;
 }
 
 /*
@@ -602,7 +582,6 @@ int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
 			       struct mwifiex_ssid_bssid *ssid_bssid)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	int ret = 0;
 	struct mwifiex_bssdescriptor *bss_desc;
 	u8 zero_mac[ETH_ALEN] = { 0, 0, 0, 0, 0, 0 };
 	u8 mac[ETH_ALEN];
@@ -631,10 +610,10 @@ int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
 		bss_desc = &adapter->scan_table[i];
 		memcpy(ssid_bssid->bssid, bss_desc->mac_address, ETH_ALEN);
 	} else {
-		ret = mwifiex_find_best_network(priv, ssid_bssid);
+		return mwifiex_find_best_network(priv, ssid_bssid);
 	}
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -718,7 +697,6 @@ static int mwifiex_rate_ioctl_get_rate_value(struct mwifiex_private *priv,
 					     struct mwifiex_rate_cfg *rate_cfg)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	int ret = 0;
 
 	rate_cfg->is_rate_auto = priv->is_data_rate_auto;
 	if (!priv->media_connected) {
@@ -757,13 +735,12 @@ static int mwifiex_rate_ioctl_get_rate_value(struct mwifiex_private *priv,
 			break;
 		}
 	} else {
-		/* Send request to firmware */
-		ret = mwifiex_send_cmd_sync(priv,
+		return mwifiex_send_cmd_sync(priv,
 					    HostCmd_CMD_802_11_TX_RATE_QUERY,
 					    HostCmd_ACT_GEN_GET, 0, NULL);
 	}
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -827,7 +804,6 @@ static int mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
 		}
 	}
 
-	/* Send request to firmware */
 	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_TX_RATE_CFG,
 				    HostCmd_ACT_GEN_SET, 0, bitmap_rates);
 
@@ -969,7 +945,6 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 		pg->power_max = (s8) dbm;
 		pg->ht_bandwidth = HT_BW_40;
 	}
-	/* Send request to firmware */
 	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_TXPWR_CFG,
 				    HostCmd_ACT_GEN_SET, 0, buf);
 
@@ -1088,13 +1063,10 @@ static int mwifiex_set_wapi_ie(struct mwifiex_private *priv,
 static int mwifiex_sec_ioctl_set_wapi_key(struct mwifiex_private *priv,
 			       struct mwifiex_ds_encrypt_key *encrypt_key)
 {
-	int ret = 0;
 
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
+	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
 				    HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
 				    encrypt_key);
-
-	return ret;
 }
 
 /*
@@ -1128,7 +1100,6 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_private *priv,
 		priv->sec_info.wep_status = MWIFIEX_802_11_WEP_ENABLED;
 	} else {
 		wep_key = &priv->wep_key[index];
-		/* Cleanup */
 		memset(wep_key, 0, sizeof(struct mwifiex_wep_key));
 		/* Copy the key in the driver */
 		memcpy(wep_key->key_material,
@@ -1151,7 +1122,6 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_private *priv,
 	else
 		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_WEP_ENABLE;
 
-	/* Send request to firmware */
 	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_MAC_CONTROL,
 				    HostCmd_ACT_GEN_SET, 0,
 				    &priv->curr_pkt_filter);
@@ -1216,13 +1186,11 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_private *priv,
 		encrypt_key->key_index = MWIFIEX_KEY_INDEX_UNICAST;
 
 	if (remove_key)
-		/* Send request to firmware */
 		ret = mwifiex_send_cmd_sync(priv,
 				       HostCmd_CMD_802_11_KEY_MATERIAL,
 				       HostCmd_ACT_GEN_SET, !(KEY_INFO_ENABLED),
 				       encrypt_key);
 	else
-		/* Send request to firmware */
 		ret = mwifiex_send_cmd_sync(priv,
 					HostCmd_CMD_802_11_KEY_MATERIAL,
 					HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
@@ -1297,7 +1265,6 @@ int mwifiex_get_signal_info(struct mwifiex_private *priv,
 		return -1;
 	}
 
-	/* Send request to firmware */
 	status = mwifiex_send_cmd_sync(priv, HostCmd_CMD_RSSI_INFO,
 				       HostCmd_ACT_GEN_GET, 0, signal);
 
@@ -1324,7 +1291,6 @@ int mwifiex_set_encode(struct mwifiex_private *priv, const u8 *key,
 			int key_len, u8 key_index, int disable)
 {
 	struct mwifiex_ds_encrypt_key encrypt_key;
-	int ret = 0;
 
 	memset(&encrypt_key, 0, sizeof(struct mwifiex_ds_encrypt_key));
 	encrypt_key.key_len = key_len;
@@ -1336,9 +1302,7 @@ int mwifiex_set_encode(struct mwifiex_private *priv, const u8 *key,
 		encrypt_key.key_disable = true;
 	}
 
-	ret = mwifiex_sec_ioctl_encrypt_key(priv, &encrypt_key);
-
-	return ret;
+	return mwifiex_sec_ioctl_encrypt_key(priv, &encrypt_key);
 }
 
 /*
@@ -1351,18 +1315,13 @@ int
 mwifiex_get_ver_ext(struct mwifiex_private *priv)
 {
 	struct mwifiex_ver_ext ver_ext;
-	int ret = 0;
 
-	/* get fw version */
 	memset(&ver_ext, 0, sizeof(struct host_cmd_ds_version_ext));
-	/* Send request to firmware */
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_VERSION_EXT,
-				    HostCmd_ACT_GEN_GET, 0, &ver_ext);
-
-	if (ret)
-		ret = -1;
+	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_VERSION_EXT,
+				    HostCmd_ACT_GEN_GET, 0, &ver_ext))
+		return -1;
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -1379,7 +1338,6 @@ mwifiex_get_stats_info(struct mwifiex_private *priv,
 	struct mwifiex_ds_get_stats get_log;
 
 	memset(&get_log, 0, sizeof(struct mwifiex_ds_get_stats));
-	/* Send request to firmware */
 	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_GET_LOG,
 				    HostCmd_ACT_GEN_GET, 0, &get_log);
 
@@ -1412,7 +1370,6 @@ static int mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *priv,
 					struct mwifiex_ds_reg_rw *reg_rw,
 					u16 action)
 {
-	int ret = 0;
 	u16 cmd_no;
 
 	switch (le32_to_cpu(reg_rw->type)) {
@@ -1435,10 +1392,8 @@ static int mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *priv,
 		return -1;
 	}
 
-	/* Send request to firmware */
-	ret = mwifiex_send_cmd_sync(priv, cmd_no, action, 0, reg_rw);
+	return mwifiex_send_cmd_sync(priv, cmd_no, action, 0, reg_rw);
 
-	return ret;
 }
 
 /*
@@ -1451,15 +1406,13 @@ int
 mwifiex_reg_write(struct mwifiex_private *priv, u32 reg_type,
 		  u32 reg_offset, u32 reg_value)
 {
-	int ret = 0;
 	struct mwifiex_ds_reg_rw reg_rw;
 
 	reg_rw.type = cpu_to_le32(reg_type);
 	reg_rw.offset = cpu_to_le32(reg_offset);
 	reg_rw.value = cpu_to_le32(reg_value);
-	ret = mwifiex_reg_mem_ioctl_reg_rw(priv, &reg_rw, HostCmd_ACT_GEN_SET);
 
-	return ret;
+	return mwifiex_reg_mem_ioctl_reg_rw(priv, &reg_rw, HostCmd_ACT_GEN_SET);
 }
 
 /*
@@ -1638,7 +1591,6 @@ int
 mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len)
 {
 	struct mwifiex_ds_misc_gen_ie gen_ie;
-	int status = 0;
 
 	if (ie_len > IW_CUSTOM_MAX)
 		return -EFAULT;
@@ -1646,8 +1598,7 @@ mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len)
 	gen_ie.type = MWIFIEX_IE_TYPE_GEN_IE;
 	gen_ie.len = ie_len;
 	memcpy(gen_ie.ie_data, ie, ie_len);
-	status = mwifiex_misc_ioctl_gen_ie(priv, &gen_ie, HostCmd_ACT_GEN_SET);
-	if (status)
+	if (mwifiex_misc_ioctl_gen_ie(priv, &gen_ie, HostCmd_ACT_GEN_SET))
 		return -EFAULT;
 
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index b261d81..5d37ef1 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -180,15 +180,11 @@ mwifiex_check_last_packet_indication(struct mwifiex_private *priv)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u8 ret = false;
-	u8 prop_ps = true;
 
 	if (!adapter->sleep_period.period)
 		return ret;
-	if (mwifiex_wmm_lists_empty(adapter)) {
-		if ((priv->curr_bss_params.wmm_uapsd_enabled &&
-		     priv->wmm_qosinfo) || prop_ps)
+	if (mwifiex_wmm_lists_empty(adapter))
 			ret = true;
-	}
 
 	if (ret && !adapter->cmd_sent && !adapter->curr_cmd
 	    && !is_command_pending(adapter)) {
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index f06923c..ce772e0 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -36,7 +36,6 @@
 int mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
 			     struct sk_buff *skb)
 {
-	int ret = 0;
 	struct mwifiex_private *priv =
 		mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 	struct rxpd *local_rx_pd;
@@ -50,9 +49,8 @@ int mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 
 	rx_info->bss_index = priv->bss_index;
-	ret = mwifiex_process_sta_rx_packet(adapter, skb);
 
-	return ret;
+	return mwifiex_process_sta_rx_packet(adapter, skb);
 }
 EXPORT_SYMBOL_GPL(mwifiex_handle_rx_packet);
 
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 9f65587..7ab4fb2 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -61,7 +61,6 @@ int mwifiex_shutdown_fw_complete(struct mwifiex_adapter *adapter)
 int mwifiex_init_shutdown_fw(struct mwifiex_private *priv,
 			     u32 func_init_shutdown)
 {
-	int ret;
 	u16 cmd;
 
 	if (func_init_shutdown == MWIFIEX_FUNC_INIT) {
@@ -73,10 +72,7 @@ int mwifiex_init_shutdown_fw(struct mwifiex_private *priv,
 		return -1;
 	}
 
-	/* Send command to firmware */
-	ret = mwifiex_send_cmd_sync(priv, cmd, HostCmd_ACT_GEN_SET, 0, NULL);
-
-	return ret;
+	return mwifiex_send_cmd_sync(priv, cmd, HostCmd_ACT_GEN_SET, 0, NULL);
 }
 EXPORT_SYMBOL_GPL(mwifiex_init_shutdown_fw);
 
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 99e8431..c009370 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -973,7 +973,6 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 	struct sk_buff *skb, *skb_next;
 	struct mwifiex_tx_param tx_param;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	int status = 0;
 	struct mwifiex_txinfo *tx_info;
 
 	if (skb_queue_empty(&ptr->skb_head)) {
@@ -1000,9 +999,7 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 	tx_param.next_pkt_len = ((skb_next) ? skb_next->len +
 				sizeof(struct txpd) : 0);
 
-	status = mwifiex_process_tx(priv, skb, &tx_param);
-
-	if (status == -EBUSY) {
+	if (mwifiex_process_tx(priv, skb, &tx_param) == -EBUSY) {
 		/* Queue the packet back at the head */
 		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
 
-- 
1.7.0.2

