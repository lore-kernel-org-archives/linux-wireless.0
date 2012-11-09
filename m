Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54820 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab2KIURC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 15:17:02 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 3/8] cfg80211: pass a channel definition struct
Date: Fri,  9 Nov 2012 21:17:29 +0100
Message-Id: <1352492254-29399-4-git-send-email-johannes@sipsolutions.net> (sfid-20121109_211717_091484_9BE1106F)
In-Reply-To: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of passing a channel pointer and channel type
to all functions and driver methods, pass a new channel
definition struct. Right now, this struct contains just
the control channel and channel type, but for VHT this
will change.

Also, add a small inline cfg80211_get_chandef_type() so
that drivers don't need to use the _type field of the
new structure all the time, which will change.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  22 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  11 +-
 drivers/net/wireless/libertas/cfg.c                |  24 +-
 drivers/net/wireless/mwifiex/cfg80211.c            |  30 ++-
 drivers/net/wireless/orinoco/cfg.c                 |  11 +-
 drivers/net/wireless/rndis_wlan.c                  |   2 +-
 include/net/cfg80211.h                             |  65 +++---
 net/mac80211/cfg.c                                 |  43 ++--
 net/mac80211/ibss.c                                |  21 +-
 net/wireless/chan.c                                |  59 +----
 net/wireless/core.h                                |  11 +-
 net/wireless/ibss.c                                |  27 ++-
 net/wireless/mesh.c                                |  49 ++--
 net/wireless/mlme.c                                |  15 +-
 net/wireless/nl80211.c                             | 253 +++++++++++----------
 net/wireless/nl80211.h                             |   4 +-
 net/wireless/rdev-ops.h                            |  22 +-
 net/wireless/trace.h                               |  97 ++++----
 net/wireless/wext-compat.c                         |  26 ++-
 net/wireless/wext-sme.c                            |  10 +-
 20 files changed, 400 insertions(+), 402 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 74091d3..c0cc2e5 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1093,15 +1093,20 @@ out:
 void ath6kl_cfg80211_ch_switch_notify(struct ath6kl_vif *vif, int freq,
 				      enum wmi_phy_mode mode)
 {
-	enum nl80211_channel_type type;
+	struct cfg80211_chan_def chandef;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 		   "channel switch notify nw_type %d freq %d mode %d\n",
 		   vif->nw_type, freq, mode);
 
-	type = (mode == WMI_11G_HT20) ? NL80211_CHAN_HT20 : NL80211_CHAN_NO_HT;
+	chandef.chan = ieee80211_get_channel(vif->ar->wiphy, freq);
+	if (WARN_ON(!chandef.chan))
+		return;
+
+	chandef._type = (mode == WMI_11G_HT20) ?
+		NL80211_CHAN_HT20 : NL80211_CHAN_NO_HT;
 
-	cfg80211_ch_switch_notify(vif->ndev, freq, type);
+	cfg80211_ch_switch_notify(vif->ndev, &chandef);
 }
 
 static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
@@ -1613,8 +1618,8 @@ static int ath6kl_cfg80211_join_ibss(struct wiphy *wiphy,
 	vif->ssid_len = ibss_param->ssid_len;
 	memcpy(vif->ssid, ibss_param->ssid, vif->ssid_len);
 
-	if (ibss_param->channel)
-		vif->ch_hint = ibss_param->channel->center_freq;
+	if (ibss_param->chandef.chan)
+		vif->ch_hint = ibss_param->chandef.chan->center_freq;
 
 	if (ibss_param->channel_fixed) {
 		/*
@@ -2856,7 +2861,7 @@ static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	p.ssid_len = vif->ssid_len;
 	memcpy(p.ssid, vif->ssid, vif->ssid_len);
 	p.dot11_auth_mode = vif->dot11_auth_mode;
-	p.ch = cpu_to_le16(info->channel->center_freq);
+	p.ch = cpu_to_le16(info->chandef.chan->center_freq);
 
 	/* Enable uAPSD support by default */
 	res = ath6kl_wmi_ap_set_apsd(ar->wmi, vif->fw_vif_idx, true);
@@ -2880,8 +2885,9 @@ static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 			return res;
 	}
 
-	if (ath6kl_set_htcap(vif, info->channel->band,
-			     info->channel_type != NL80211_CHAN_NO_HT))
+	if (ath6kl_set_htcap(vif, info->chandef.chan->band,
+			     cfg80211_get_chandef_type(&info->chandef)
+					!= NL80211_CHAN_NO_HT))
 		return -EIO;
 
 	/*
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 904c941..b596ca4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1212,8 +1212,8 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	else
 		WL_CONN("No BSSID specified\n");
 
-	if (params->channel)
-		WL_CONN("channel: %d\n", params->channel->center_freq);
+	if (params->chandef.chan)
+		WL_CONN("channel: %d\n", params->chandef.chan->center_freq);
 	else
 		WL_CONN("no channel specified\n");
 
@@ -1286,12 +1286,12 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	/* Channel */
-	if (params->channel) {
+	if (params->chandef.chan) {
 		u32 target_channel;
 
 		cfg->channel =
 			ieee80211_frequency_to_channel(
-				params->channel->center_freq);
+				params->chandef.chan->center_freq);
 		if (params->channel_fixed) {
 			/* adding chanspec */
 			brcmf_ch_to_chanspec(cfg->channel,
@@ -3938,7 +3938,8 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	s32 bssidx = 0;
 
 	WL_TRACE("channel_type=%d, beacon_interval=%d, dtim_period=%d,\n",
-		 settings->channel_type, settings->beacon_interval,
+		 cfg80211_get_chandef_type(&settings->chandef),
+		 settings->beacon_interval,
 		 settings->dtim_period);
 	WL_TRACE("ssid=%s(%d), auth_type=%d, inactivity_timeout=%d\n",
 		 settings->ssid, settings->ssid_len, settings->auth_type,
diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 1c10b54..ec36868 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -436,19 +436,19 @@ static int lbs_add_wpa_tlv(u8 *tlv, const u8 *ie, u8 ie_len)
  */
 
 static int lbs_cfg_set_monitor_channel(struct wiphy *wiphy,
-				       struct ieee80211_channel *channel,
-				       enum nl80211_channel_type channel_type)
+				       struct cfg80211_chan_def *chandef)
 {
 	struct lbs_private *priv = wiphy_priv(wiphy);
 	int ret = -ENOTSUPP;
 
 	lbs_deb_enter_args(LBS_DEB_CFG80211, "freq %d, type %d",
-			   channel->center_freq, channel_type);
+			   chandef->chan->center_freq,
+			   cfg80211_get_chandef_type(chandef));
 
-	if (channel_type != NL80211_CHAN_NO_HT)
+	if (cfg80211_get_chandef_type(chandef) != NL80211_CHAN_NO_HT)
 		goto out;
 
-	ret = lbs_set_channel(priv, channel->hw_value);
+	ret = lbs_set_channel(priv, chandef->chan->hw_value);
 
  out:
 	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
@@ -1734,7 +1734,7 @@ static void lbs_join_post(struct lbs_private *priv,
 	/* Fake DS channel IE */
 	*fake++ = WLAN_EID_DS_PARAMS;
 	*fake++ = 1;
-	*fake++ = params->channel->hw_value;
+	*fake++ = params->chandef.chan->hw_value;
 	/* Fake IBSS params IE */
 	*fake++ = WLAN_EID_IBSS_PARAMS;
 	*fake++ = 2;
@@ -1755,7 +1755,7 @@ static void lbs_join_post(struct lbs_private *priv,
 	lbs_deb_hex(LBS_DEB_CFG80211, "IE", fake_ie, fake - fake_ie);
 
 	bss = cfg80211_inform_bss(priv->wdev->wiphy,
-				  params->channel,
+				  params->chandef.chan,
 				  bssid,
 				  0,
 				  capability,
@@ -1833,7 +1833,7 @@ static int lbs_ibss_join_existing(struct lbs_private *priv,
 	cmd.bss.beaconperiod = cpu_to_le16(params->beacon_interval);
 	cmd.bss.ds.header.id = WLAN_EID_DS_PARAMS;
 	cmd.bss.ds.header.len = 1;
-	cmd.bss.ds.channel = params->channel->hw_value;
+	cmd.bss.ds.channel = params->chandef.chan->hw_value;
 	cmd.bss.ibss.header.id = WLAN_EID_IBSS_PARAMS;
 	cmd.bss.ibss.header.len = 2;
 	cmd.bss.ibss.atimwindow = 0;
@@ -1942,7 +1942,7 @@ static int lbs_ibss_start_new(struct lbs_private *priv,
 	cmd.ibss.atimwindow = 0;
 	cmd.ds.header.id = WLAN_EID_DS_PARAMS;
 	cmd.ds.header.len = 1;
-	cmd.ds.channel = params->channel->hw_value;
+	cmd.ds.channel = params->chandef.chan->hw_value;
 	/* Only v8 and below support setting probe delay */
 	if (MRVL_FW_MAJOR_REV(priv->fwrelease) <= 8)
 		cmd.probedelay = cpu_to_le16(CMD_SCAN_PROBE_DELAY_TIME);
@@ -1987,18 +1987,18 @@ static int lbs_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
-	if (!params->channel) {
+	if (!params->chandef.chan) {
 		ret = -ENOTSUPP;
 		goto out;
 	}
 
-	ret = lbs_set_channel(priv, params->channel->hw_value);
+	ret = lbs_set_channel(priv, params->chandef.chan->hw_value);
 	if (ret)
 		goto out;
 
 	/* Search if someone is beaconing. This assumes that the
 	 * bss list is populated already */
-	bss = cfg80211_get_bss(wiphy, params->channel, params->bssid,
+	bss = cfg80211_get_bss(wiphy, params->chandef.chan, params->bssid,
 		params->ssid, params->ssid_len,
 		WLAN_CAPABILITY_IBSS, WLAN_CAPABILITY_IBSS);
 
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index f69190b..42be612 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1291,21 +1291,23 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 		return -EINVAL;
 	}
 
-	bss_cfg->channel =
-	    (u8)ieee80211_frequency_to_channel(params->channel->center_freq);
+	bss_cfg->channel = ieee80211_frequency_to_channel(
+				params->chandef.chan->center_freq);
 
 	/* Set appropriate bands */
-	if (params->channel->band == IEEE80211_BAND_2GHZ) {
+	if (params->chandef.chan->band == IEEE80211_BAND_2GHZ) {
 		bss_cfg->band_cfg = BAND_CONFIG_BG;
 
-		if (params->channel_type == NL80211_CHAN_NO_HT)
+		if (cfg80211_get_chandef_type(&params->chandef) ==
+						NL80211_CHAN_NO_HT)
 			config_bands = BAND_B | BAND_G;
 		else
 			config_bands = BAND_B | BAND_G | BAND_GN;
 	} else {
 		bss_cfg->band_cfg = BAND_CONFIG_A;
 
-		if (params->channel_type == NL80211_CHAN_NO_HT)
+		if (cfg80211_get_chandef_type(&params->chandef) ==
+						NL80211_CHAN_NO_HT)
 			config_bands = BAND_A;
 		else
 			config_bands = BAND_AN | BAND_A;
@@ -1678,7 +1680,7 @@ static int mwifiex_set_ibss_params(struct mwifiex_private *priv,
 	int index = 0, i;
 	u8 config_bands = 0;
 
-	if (params->channel->band == IEEE80211_BAND_2GHZ) {
+	if (params->chandef.chan->band == IEEE80211_BAND_2GHZ) {
 		if (!params->basic_rates) {
 			config_bands = BAND_B | BAND_G;
 		} else {
@@ -1703,10 +1705,12 @@ static int mwifiex_set_ibss_params(struct mwifiex_private *priv,
 			}
 		}
 
-		if (params->channel_type != NL80211_CHAN_NO_HT)
+		if (cfg80211_get_chandef_type(&params->chandef) !=
+						NL80211_CHAN_NO_HT)
 			config_bands |= BAND_GN;
 	} else {
-		if (params->channel_type == NL80211_CHAN_NO_HT)
+		if (cfg80211_get_chandef_type(&params->chandef) !=
+						NL80211_CHAN_NO_HT)
 			config_bands = BAND_A;
 		else
 			config_bands = BAND_AN | BAND_A;
@@ -1723,9 +1727,10 @@ static int mwifiex_set_ibss_params(struct mwifiex_private *priv,
 	}
 
 	adapter->sec_chan_offset =
-		mwifiex_chan_type_to_sec_chan_offset(params->channel_type);
-	priv->adhoc_channel =
-		ieee80211_frequency_to_channel(params->channel->center_freq);
+		mwifiex_chan_type_to_sec_chan_offset(
+			cfg80211_get_chandef_type(&params->chandef));
+	priv->adhoc_channel = ieee80211_frequency_to_channel(
+				params->chandef.chan->center_freq);
 
 	wiphy_dbg(wiphy, "info: set ibss band %d, chan %d, chan offset %d\n",
 		  config_bands, priv->adhoc_channel, adapter->sec_chan_offset);
@@ -1759,7 +1764,8 @@ mwifiex_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 
 	ret = mwifiex_cfg80211_assoc(priv, params->ssid_len, params->ssid,
 				     params->bssid, priv->bss_mode,
-				     params->channel, NULL, params->privacy);
+				     params->chandef.chan, NULL,
+				     params->privacy);
 done:
 	if (!ret) {
 		cfg80211_ibss_joined(priv->netdev, priv->cfg_bssid, GFP_KERNEL);
diff --git a/drivers/net/wireless/orinoco/cfg.c b/drivers/net/wireless/orinoco/cfg.c
index 7b751fb..d01edd2 100644
--- a/drivers/net/wireless/orinoco/cfg.c
+++ b/drivers/net/wireless/orinoco/cfg.c
@@ -161,24 +161,23 @@ static int orinoco_scan(struct wiphy *wiphy,
 }
 
 static int orinoco_set_monitor_channel(struct wiphy *wiphy,
-				       struct ieee80211_channel *chan,
-				       enum nl80211_channel_type channel_type)
+				       struct cfg80211_chan_def *chandef)
 {
 	struct orinoco_private *priv = wiphy_priv(wiphy);
 	int err = 0;
 	unsigned long flags;
 	int channel;
 
-	if (!chan)
+	if (!chandef->chan)
 		return -EINVAL;
 
-	if (channel_type != NL80211_CHAN_NO_HT)
+	if (cfg80211_get_chandef_type(chandef) != NL80211_CHAN_NO_HT)
 		return -EINVAL;
 
-	if (chan->band != IEEE80211_BAND_2GHZ)
+	if (chandef->chan->band != IEEE80211_BAND_2GHZ)
 		return -EINVAL;
 
-	channel = ieee80211_freq_to_dsss_chan(chan->center_freq);
+	channel = ieee80211_freq_to_dsss_chan(chandef->chan->center_freq);
 
 	if ((channel < 1) || (channel > NUM_CHANNELS) ||
 	     !(priv->channel_mask & (1 << (channel - 1))))
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 5390af3..abe1d03 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2293,7 +2293,7 @@ static int rndis_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
 	struct usbnet *usbdev = priv->usbdev;
-	struct ieee80211_channel *channel = params->channel;
+	struct ieee80211_channel *channel = params->chandef.chan;
 	struct ndis_80211_ssid ssid;
 	enum nl80211_auth_type auth_type;
 	int ret, alg, length, chan = -1;
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9de217e..ddcc6ca 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -306,6 +306,23 @@ struct key_params {
 };
 
 /**
+ * struct cfg80211_chan_def - channel definition
+ * @chan: the (control) channel
+ * @_type: the channel type, don't use this field,
+ *	use cfg80211_get_chandef_type() if needed.
+ */
+struct cfg80211_chan_def {
+	struct ieee80211_channel *chan;
+	enum nl80211_channel_type _type;
+};
+
+static inline enum nl80211_channel_type
+cfg80211_get_chandef_type(const struct cfg80211_chan_def *chandef)
+{
+	return chandef->_type;
+}
+
+/**
  * enum survey_info_flags - survey information flags
  *
  * @SURVEY_INFO_NOISE_DBM: noise (in dBm) was filled in
@@ -426,8 +443,7 @@ struct cfg80211_beacon_data {
  *
  * Used to configure an AP interface.
  *
- * @channel: the channel to start the AP on
- * @channel_type: the channel type to use
+ * @chandef: defines the channel to use
  * @beacon: beacon data
  * @beacon_interval: beacon interval
  * @dtim_period: DTIM period
@@ -441,8 +457,7 @@ struct cfg80211_beacon_data {
  * @inactivity_timeout: time in seconds to determine station's inactivity.
  */
 struct cfg80211_ap_settings {
-	struct ieee80211_channel *channel;
-	enum nl80211_channel_type channel_type;
+	struct cfg80211_chan_def chandef;
 
 	struct cfg80211_beacon_data beacon;
 
@@ -909,8 +924,7 @@ struct mesh_config {
 
 /**
  * struct mesh_setup - 802.11s mesh setup configuration
- * @channel: the channel to start the mesh network on
- * @channel_type: the channel type to use
+ * @chandef: defines the channel to use
  * @mesh_id: the mesh ID
  * @mesh_id_len: length of the mesh ID, at least 1 and at most 32 bytes
  * @sync_method: which synchronization method to use
@@ -925,8 +939,7 @@ struct mesh_config {
  * These parameters are fixed when the mesh is created.
  */
 struct mesh_setup {
-	struct ieee80211_channel *channel;
-	enum nl80211_channel_type channel_type;
+	struct cfg80211_chan_def chandef;
 	const u8 *mesh_id;
 	u8 mesh_id_len;
 	u8 sync_method;
@@ -1266,8 +1279,7 @@ struct cfg80211_disassoc_request {
  * @ssid_len: The length of the SSID, will always be non-zero.
  * @bssid: Fixed BSSID requested, maybe be %NULL, if set do not
  *	search for IBSSs with a different BSSID.
- * @channel: The channel to use if no IBSS can be found to join.
- * @channel_type: channel type (HT mode)
+ * @chandef: defines the channel to use if no other IBSS to join can be found
  * @channel_fixed: The channel should be fixed -- do not search for
  *	IBSSs to join on other channels.
  * @ie: information element(s) to include in the beacon
@@ -1285,8 +1297,7 @@ struct cfg80211_disassoc_request {
 struct cfg80211_ibss_params {
 	u8 *ssid;
 	u8 *bssid;
-	struct ieee80211_channel *channel;
-	enum nl80211_channel_type channel_type;
+	struct cfg80211_chan_def chandef;
 	u8 *ie;
 	u8 ssid_len, ie_len;
 	u16 beacon_interval;
@@ -1728,8 +1739,7 @@ struct cfg80211_ops {
 					     struct ieee80211_channel *chan);
 
 	int	(*set_monitor_channel)(struct wiphy *wiphy,
-				       struct ieee80211_channel *chan,
-				       enum nl80211_channel_type channel_type);
+				       struct cfg80211_chan_def *chandef);
 
 	int	(*scan)(struct wiphy *wiphy,
 			struct cfg80211_scan_request *request);
@@ -1855,10 +1865,9 @@ struct cfg80211_ops {
 	void	(*get_et_strings)(struct wiphy *wiphy, struct net_device *dev,
 				  u32 sset, u8 *data);
 
-	struct ieee80211_channel *
-		(*get_channel)(struct wiphy *wiphy,
+	int	(*get_channel)(struct wiphy *wiphy,
 			       struct wireless_dev *wdev,
-			       enum nl80211_channel_type *type);
+			       struct cfg80211_chan_def *chandef);
 
 	int	(*start_p2p_device)(struct wiphy *wiphy,
 				    struct wireless_dev *wdev);
@@ -2466,8 +2475,7 @@ struct wireless_dev {
 	spinlock_t event_lock;
 
 	struct cfg80211_internal_bss *current_bss; /* associated / joined */
-	struct ieee80211_channel *preset_chan;
-	enum nl80211_channel_type preset_chantype;
+	struct cfg80211_chan_def preset_chandef;
 
 	/* for AP and mesh channel tracking */
 	struct ieee80211_channel *channel;
@@ -3563,28 +3571,25 @@ void cfg80211_report_obss_beacon(struct wiphy *wiphy,
 				 int freq, int sig_dbm);
 
 /**
- * cfg80211_can_beacon_sec_chan - test if ht40 on extension channel can be used
+ * cfg80211_reg_can_beacon - check if beaconing is allowed
  * @wiphy: the wiphy
- * @chan: main channel
- * @channel_type: HT mode
+ * @chandef: the channel definition
  *
  * This function returns true if there is no secondary channel or the secondary
- * channel can be used for beaconing (i.e. is not a radar channel etc.)
+ * channel(s) can be used for beaconing (i.e. is not a radar channel etc.)
  */
-bool cfg80211_can_beacon_sec_chan(struct wiphy *wiphy,
-				  struct ieee80211_channel *chan,
-				  enum nl80211_channel_type channel_type);
+bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
+			     struct cfg80211_chan_def *chandef);
 
 /*
  * cfg80211_ch_switch_notify - update wdev channel and notify userspace
  * @dev: the device which switched channels
- * @freq: new channel frequency (in MHz)
- * @type: channel type
+ * @chandef: the new channel definition
  *
  * Acquires wdev_lock, so must only be called from sleepable driver context!
  */
-void cfg80211_ch_switch_notify(struct net_device *dev, int freq,
-			       enum nl80211_channel_type type);
+void cfg80211_ch_switch_notify(struct net_device *dev,
+			       struct cfg80211_chan_def *chandef);
 
 /**
  * ieee80211_operating_class_to_band - convert operating class to band
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 63f55d8..4327443 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -738,14 +738,16 @@ static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
-					 struct ieee80211_channel *chan,
-					 enum nl80211_channel_type channel_type)
+					 struct cfg80211_chan_def *chandef)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
+	enum nl80211_channel_type channel_type;
 	int ret = 0;
 
-	if (local->monitor_channel == chan &&
+	channel_type = cfg80211_get_chandef_type(chandef);
+
+	if (local->monitor_channel == chandef->chan &&
 	    local->monitor_channel_type == channel_type)
 		return 0;
 
@@ -757,17 +759,17 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 		if (sdata) {
 			ieee80211_vif_release_channel(sdata);
 			ret = ieee80211_vif_use_channel(
-					sdata, chan, channel_type,
+					sdata, chandef->chan, channel_type,
 					IEEE80211_CHANCTX_EXCLUSIVE);
 		}
 	} else if (local->open_count == local->monitors) {
-		local->_oper_channel = chan;
+		local->_oper_channel = chandef->chan;
 		local->_oper_channel_type = channel_type;
 		ieee80211_hw_config(local, 0);
 	}
 
 	if (ret == 0) {
-		local->monitor_channel = chan;
+		local->monitor_channel = chandef->chan;
 		local->monitor_channel_type = channel_type;
 	}
 	mutex_unlock(&local->iflist_mtx);
@@ -891,9 +893,10 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
 	sdata->needed_rx_chains = sdata->local->rx_chains;
 
-	err = ieee80211_vif_use_channel(sdata, params->channel,
-					params->channel_type,
-					IEEE80211_CHANCTX_SHARED);
+	err = ieee80211_vif_use_channel(
+		sdata, params->chandef.chan,
+		cfg80211_get_chandef_type(&params->chandef),
+		IEEE80211_CHANCTX_SHARED);
 	if (err)
 		return err;
 
@@ -1734,9 +1737,10 @@ static int ieee80211_join_mesh(struct wiphy *wiphy, struct net_device *dev,
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
 	sdata->needed_rx_chains = sdata->local->rx_chains;
 
-	err = ieee80211_vif_use_channel(sdata, setup->channel,
-					setup->channel_type,
-					IEEE80211_CHANCTX_SHARED);
+	err = ieee80211_vif_use_channel(
+		sdata, setup->chandef.chan,
+		cfg80211_get_chandef_type(&setup->chandef),
+		IEEE80211_CHANCTX_SHARED);
 	if (err)
 		return err;
 
@@ -3137,23 +3141,24 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
-static struct ieee80211_channel *
-ieee80211_cfg_get_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
-			  enum nl80211_channel_type *type)
+static int ieee80211_cfg_get_channel(struct wiphy *wiphy,
+				     struct wireless_dev *wdev,
+				     struct cfg80211_chan_def *chandef)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 	struct ieee80211_chanctx_conf *chanctx_conf;
-	struct ieee80211_channel *chan = NULL;
+	int ret = -ENODATA;
 
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	if (chanctx_conf) {
-		*type = chanctx_conf->channel_type;
-		chan = chanctx_conf->channel;
+		chandef->chan = chanctx_conf->channel;
+		chandef->_type = chanctx_conf->channel_type;
+		ret = 0;
 	}
 	rcu_read_unlock();
 
-	return chan;
+	return ret;
 }
 
 #ifdef CONFIG_PM
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index c7386b2..b7bfb4f 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -51,7 +51,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_bss *bss;
 	u32 bss_change;
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
-	enum nl80211_channel_type channel_type;
+	struct cfg80211_chan_def chandef;
 
 	lockdep_assert_held(&ifibss->mtx);
 
@@ -79,12 +79,13 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	channel_type = ifibss->channel_type;
-	if (!cfg80211_can_beacon_sec_chan(local->hw.wiphy, chan, channel_type))
-		channel_type = NL80211_CHAN_HT20;
+	chandef.chan = chan;
+	chandef._type = ifibss->channel_type;
+	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef))
+		chandef._type = NL80211_CHAN_HT20;
 
 	ieee80211_vif_release_channel(sdata);
-	if (ieee80211_vif_use_channel(sdata, chan, channel_type,
+	if (ieee80211_vif_use_channel(sdata, chan, chandef._type,
 				      ifibss->fixed_channel ?
 					IEEE80211_CHANCTX_SHARED :
 					IEEE80211_CHANCTX_EXCLUSIVE)) {
@@ -158,7 +159,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		       ifibss->ie, ifibss->ie_len);
 
 	/* add HT capability and information IEs */
-	if (channel_type && sband->ht_cap.ht_supported) {
+	if (chandef._type != NL80211_CHAN_NO_HT &&
+	    sband->ht_cap.ht_supported) {
 		pos = skb_put(skb, 4 +
 				   sizeof(struct ieee80211_ht_cap) +
 				   sizeof(struct ieee80211_ht_operation));
@@ -170,7 +172,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		 * keep them at 0
 		 */
 		pos = ieee80211_ie_build_ht_oper(pos, &sband->ht_cap,
-						 chan, channel_type, 0);
+						 chan, chandef._type, 0);
 	}
 
 	if (local->hw.queues >= IEEE80211_NUM_ACS) {
@@ -1095,8 +1097,9 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 
-	sdata->u.ibss.channel = params->channel;
-	sdata->u.ibss.channel_type = params->channel_type;
+	sdata->u.ibss.channel = params->chandef.chan;
+	sdata->u.ibss.channel_type =
+		cfg80211_get_chandef_type(&params->chandef);
 	sdata->u.ibss.fixed_channel = params->channel_fixed;
 
 	if (params->ie) {
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 48febd2..e834422 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -11,51 +11,15 @@
 #include "core.h"
 #include "rdev-ops.h"
 
-struct ieee80211_channel *
-rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
-		  int freq, enum nl80211_channel_type channel_type)
-{
-	struct ieee80211_channel *chan;
-	struct ieee80211_sta_ht_cap *ht_cap;
-
-	chan = ieee80211_get_channel(&rdev->wiphy, freq);
-
-	/* Primary channel not allowed */
-	if (!chan || chan->flags & IEEE80211_CHAN_DISABLED)
-		return NULL;
-
-	if (channel_type == NL80211_CHAN_HT40MINUS &&
-	    chan->flags & IEEE80211_CHAN_NO_HT40MINUS)
-		return NULL;
-	else if (channel_type == NL80211_CHAN_HT40PLUS &&
-		 chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
-		return NULL;
-
-	ht_cap = &rdev->wiphy.bands[chan->band]->ht_cap;
-
-	if (channel_type != NL80211_CHAN_NO_HT) {
-		if (!ht_cap->ht_supported)
-			return NULL;
-
-		if (channel_type != NL80211_CHAN_HT20 &&
-		    (!(ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) ||
-		    ht_cap->cap & IEEE80211_HT_CAP_40MHZ_INTOLERANT))
-			return NULL;
-	}
-
-	return chan;
-}
-
-bool cfg80211_can_beacon_sec_chan(struct wiphy *wiphy,
-				  struct ieee80211_channel *chan,
-				  enum nl80211_channel_type channel_type)
+bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
+			     struct cfg80211_chan_def *chandef)
 {
 	struct ieee80211_channel *sec_chan;
 	int diff;
 
-	trace_cfg80211_can_beacon_sec_chan(wiphy, chan, channel_type);
+	trace_cfg80211_reg_can_beacon(wiphy, chandef);
 
-	switch (channel_type) {
+	switch (chandef->_type) {
 	case NL80211_CHAN_HT40PLUS:
 		diff = 20;
 		break;
@@ -67,7 +31,8 @@ bool cfg80211_can_beacon_sec_chan(struct wiphy *wiphy,
 		return true;
 	}
 
-	sec_chan = ieee80211_get_channel(wiphy, chan->center_freq + diff);
+	sec_chan = ieee80211_get_channel(wiphy,
+					 chandef->chan->center_freq + diff);
 	if (!sec_chan) {
 		trace_cfg80211_return_bool(false);
 		return false;
@@ -84,23 +49,17 @@ bool cfg80211_can_beacon_sec_chan(struct wiphy *wiphy,
 	trace_cfg80211_return_bool(true);
 	return true;
 }
-EXPORT_SYMBOL(cfg80211_can_beacon_sec_chan);
+EXPORT_SYMBOL(cfg80211_reg_can_beacon);
 
 int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
-				 int freq, enum nl80211_channel_type chantype)
+				 struct cfg80211_chan_def *chandef)
 {
-	struct ieee80211_channel *chan;
-
 	if (!rdev->ops->set_monitor_channel)
 		return -EOPNOTSUPP;
 	if (!cfg80211_has_monitors_only(rdev))
 		return -EBUSY;
 
-	chan = rdev_freq_to_chan(rdev, freq, chantype);
-	if (!chan)
-		return -EINVAL;
-
-	return rdev_set_monitor_channel(rdev, chan, chantype);
+	return rdev_set_monitor_channel(rdev, chandef);
 }
 
 void
diff --git a/net/wireless/core.h b/net/wireless/core.h
index b0a09cf..6183a0d 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -309,9 +309,9 @@ int cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 		       const struct mesh_config *conf);
 int cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
 			struct net_device *dev);
-int cfg80211_set_mesh_freq(struct cfg80211_registered_device *rdev,
-			   struct wireless_dev *wdev, int freq,
-			   enum nl80211_channel_type channel_type);
+int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
+			      struct wireless_dev *wdev,
+			      struct cfg80211_chan_def *chandef);
 
 /* AP */
 int cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
@@ -470,11 +470,8 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 		        struct ieee80211_channel **chan,
 		        enum cfg80211_chan_mode *chanmode);
 
-struct ieee80211_channel *
-rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
-		  int freq, enum nl80211_channel_type channel_type);
 int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
-				 int freq, enum nl80211_channel_type chantype);
+				 struct cfg80211_chan_def *chandef);
 
 int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
 			   const u8 *rates, unsigned int n_rates,
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 27941d5..ccc8865 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -100,9 +100,9 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 		* 11a for maximum compatibility.
 		*/
 		struct ieee80211_supported_band *sband =
-			rdev->wiphy.bands[params->channel->band];
+			rdev->wiphy.bands[params->chandef.chan->band];
 		int j;
-		u32 flag = params->channel->band == IEEE80211_BAND_5GHZ ?
+		u32 flag = params->chandef.chan->band == IEEE80211_BAND_5GHZ ?
 			IEEE80211_RATE_MANDATORY_A :
 			IEEE80211_RATE_MANDATORY_B;
 
@@ -118,11 +118,11 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 
 	wdev->ibss_fixed = params->channel_fixed;
 #ifdef CONFIG_CFG80211_WEXT
-	wdev->wext.ibss.channel = params->channel;
+	wdev->wext.ibss.chandef = params->chandef;
 #endif
 	wdev->sme_state = CFG80211_SME_CONNECTING;
 
-	err = cfg80211_can_use_chan(rdev, wdev, params->channel,
+	err = cfg80211_can_use_chan(rdev, wdev, params->chandef.chan,
 				    params->channel_fixed
 				    ? CHAN_MODE_SHARED
 				    : CHAN_MODE_EXCLUSIVE);
@@ -251,7 +251,9 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 		wdev->wext.ibss.beacon_interval = 100;
 
 	/* try to find an IBSS channel if none requested ... */
-	if (!wdev->wext.ibss.channel) {
+	if (!wdev->wext.ibss.chandef.chan) {
+		wdev->wext.ibss.chandef._type = NL80211_CHAN_NO_HT;
+
 		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 			struct ieee80211_supported_band *sband;
 			struct ieee80211_channel *chan;
@@ -266,15 +268,15 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 					continue;
 				if (chan->flags & IEEE80211_CHAN_DISABLED)
 					continue;
-				wdev->wext.ibss.channel = chan;
+				wdev->wext.ibss.chandef.chan = chan;
 				break;
 			}
 
-			if (wdev->wext.ibss.channel)
+			if (wdev->wext.ibss.chandef.chan)
 				break;
 		}
 
-		if (!wdev->wext.ibss.channel)
+		if (!wdev->wext.ibss.chandef.chan)
 			return -EINVAL;
 	}
 
@@ -336,7 +338,7 @@ int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
 			return -EINVAL;
 	}
 
-	if (wdev->wext.ibss.channel == chan)
+	if (wdev->wext.ibss.chandef.chan == chan)
 		return 0;
 
 	wdev_lock(wdev);
@@ -349,7 +351,8 @@ int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
 		return err;
 
 	if (chan) {
-		wdev->wext.ibss.channel = chan;
+		wdev->wext.ibss.chandef.chan = chan;
+		wdev->wext.ibss.chandef._type = NL80211_CHAN_NO_HT;
 		wdev->wext.ibss.channel_fixed = true;
 	} else {
 		/* cfg80211_ibss_wext_join will pick one if needed */
@@ -379,8 +382,8 @@ int cfg80211_ibss_wext_giwfreq(struct net_device *dev,
 	wdev_lock(wdev);
 	if (wdev->current_bss)
 		chan = wdev->current_bss->pub.channel;
-	else if (wdev->wext.ibss.channel)
-		chan = wdev->wext.ibss.channel;
+	else if (wdev->wext.ibss.chandef.chan)
+		chan = wdev->wext.ibss.chandef.chan;
 	wdev_unlock(wdev);
 
 	if (chan) {
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 966cfc4..12b5a57 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -73,8 +73,6 @@ const struct mesh_config default_mesh_config = {
 
 const struct mesh_setup default_mesh_setup = {
 	/* cfg80211_join_mesh() will pick a channel if needed */
-	.channel = NULL,
-	.channel_type = NL80211_CHAN_NO_HT,
 	.sync_method = IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET,
 	.path_sel_proto = IEEE80211_PATH_PROTOCOL_HWMP,
 	.path_metric = IEEE80211_PATH_METRIC_AIRTIME,
@@ -111,13 +109,12 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	if (!rdev->ops->join_mesh)
 		return -EOPNOTSUPP;
 
-	if (!setup->channel) {
+	if (!setup->chandef.chan) {
 		/* if no channel explicitly given, use preset channel */
-		setup->channel = wdev->preset_chan;
-		setup->channel_type = wdev->preset_chantype;
+		setup->chandef = wdev->preset_chandef;
 	}
 
-	if (!setup->channel) {
+	if (!setup->chandef.chan) {
 		/* if we don't have that either, use the first usable channel */
 		enum ieee80211_band band;
 
@@ -137,26 +134,25 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 						   IEEE80211_CHAN_DISABLED |
 						   IEEE80211_CHAN_RADAR))
 					continue;
-				setup->channel = chan;
+				setup->chandef.chan = chan;
 				break;
 			}
 
-			if (setup->channel)
+			if (setup->chandef.chan)
 				break;
 		}
 
 		/* no usable channel ... */
-		if (!setup->channel)
+		if (!setup->chandef.chan)
 			return -EINVAL;
 
-		setup->channel_type = NL80211_CHAN_NO_HT;
+		setup->chandef._type = NL80211_CHAN_NO_HT;
 	}
 
-	if (!cfg80211_can_beacon_sec_chan(&rdev->wiphy, setup->channel,
-					  setup->channel_type))
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef))
 		return -EINVAL;
 
-	err = cfg80211_can_use_chan(rdev, wdev, setup->channel,
+	err = cfg80211_can_use_chan(rdev, wdev, setup->chandef.chan,
 				    CHAN_MODE_SHARED);
 	if (err)
 		return err;
@@ -165,7 +161,7 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	if (!err) {
 		memcpy(wdev->ssid, setup->mesh_id, setup->mesh_id_len);
 		wdev->mesh_id_len = setup->mesh_id_len;
-		wdev->channel = setup->channel;
+		wdev->channel = setup->chandef.chan;
 	}
 
 	return err;
@@ -188,20 +184,12 @@ int cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	return err;
 }
 
-int cfg80211_set_mesh_freq(struct cfg80211_registered_device *rdev,
-			   struct wireless_dev *wdev, int freq,
-			   enum nl80211_channel_type channel_type)
+int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
+			      struct wireless_dev *wdev,
+			      struct cfg80211_chan_def *chandef)
 {
-	struct ieee80211_channel *channel;
 	int err;
 
-	channel = rdev_freq_to_chan(rdev, freq, channel_type);
-	if (!channel || !cfg80211_can_beacon_sec_chan(&rdev->wiphy,
-						      channel,
-						      channel_type)) {
-		return -EINVAL;
-	}
-
 	/*
 	 * Workaround for libertas (only!), it puts the interface
 	 * into mesh mode but doesn't implement join_mesh. Instead,
@@ -210,21 +198,21 @@ int cfg80211_set_mesh_freq(struct cfg80211_registered_device *rdev,
 	 * compatible with 802.11 mesh.
 	 */
 	if (rdev->ops->libertas_set_mesh_channel) {
-		if (channel_type != NL80211_CHAN_NO_HT)
+		if (chandef->_type != NL80211_CHAN_NO_HT)
 			return -EINVAL;
 
 		if (!netif_running(wdev->netdev))
 			return -ENETDOWN;
 
-		err = cfg80211_can_use_chan(rdev, wdev, channel,
+		err = cfg80211_can_use_chan(rdev, wdev, chandef->chan,
 					    CHAN_MODE_SHARED);
 		if (err)
 			return err;
 
 		err = rdev_libertas_set_mesh_channel(rdev, wdev->netdev,
-						     channel);
+						     chandef->chan);
 		if (!err)
-			wdev->channel = channel;
+			wdev->channel = chandef->chan;
 
 		return err;
 	}
@@ -232,8 +220,7 @@ int cfg80211_set_mesh_freq(struct cfg80211_registered_device *rdev,
 	if (wdev->mesh_id_len)
 		return -EBUSY;
 
-	wdev->preset_chan = channel;
-	wdev->preset_chantype = channel_type;
+	wdev->preset_chandef = *chandef;
 	return 0;
 }
 
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index a9646b5..5e8123e 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -988,15 +988,14 @@ void cfg80211_pmksa_candidate_notify(struct net_device *dev, int index,
 }
 EXPORT_SYMBOL(cfg80211_pmksa_candidate_notify);
 
-void cfg80211_ch_switch_notify(struct net_device *dev, int freq,
-			       enum nl80211_channel_type type)
+void cfg80211_ch_switch_notify(struct net_device *dev,
+			       struct cfg80211_chan_def *chandef)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-	struct ieee80211_channel *chan;
 
-	trace_cfg80211_ch_switch_notify(dev, freq, type);
+	trace_cfg80211_ch_switch_notify(dev, chandef);
 
 	wdev_lock(wdev);
 
@@ -1004,12 +1003,8 @@ void cfg80211_ch_switch_notify(struct net_device *dev, int freq,
 		    wdev->iftype != NL80211_IFTYPE_P2P_GO))
 		goto out;
 
-	chan = rdev_freq_to_chan(rdev, freq, type);
-	if (WARN_ON(!chan))
-		goto out;
-
-	wdev->channel = chan;
-	nl80211_ch_switch_notify(rdev, dev, freq, type, GFP_KERNEL);
+	wdev->channel = chandef->chan;
+	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL);
 out:
 	wdev_unlock(wdev);
 	return;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7db26b6..bed5a0e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1381,30 +1381,82 @@ static bool nl80211_valid_channel_type(struct genl_info *info,
 	return true;
 }
 
+static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
+				 struct genl_info *info,
+				 struct cfg80211_chan_def *chandef)
+{
+	struct ieee80211_sta_ht_cap *ht_cap;
+	struct ieee80211_channel *sc;
+	u32 control_freq;
+	int offs;
+
+	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ])
+		return -EINVAL;
+
+	control_freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
+
+	chandef->chan = ieee80211_get_channel(&rdev->wiphy, control_freq);
+	chandef->_type = NL80211_CHAN_NO_HT;
+
+	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE] &&
+	    !nl80211_valid_channel_type(info, &chandef->_type))
+		return -EINVAL;
+
+	/* Primary channel not allowed */
+	if (!chandef->chan || chandef->chan->flags & IEEE80211_CHAN_DISABLED)
+		return -EINVAL;
+
+	ht_cap = &rdev->wiphy.bands[chandef->chan->band]->ht_cap;
+
+	switch (chandef->_type) {
+	case NL80211_CHAN_NO_HT:
+		break;
+	case NL80211_CHAN_HT40MINUS:
+		if (chandef->chan->flags & IEEE80211_CHAN_NO_HT40MINUS)
+			return -EINVAL;
+		offs = -20;
+		/* fall through */
+	case NL80211_CHAN_HT40PLUS:
+		if (chandef->_type == NL80211_CHAN_HT40PLUS) {
+			if (chandef->chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
+				return -EINVAL;
+			offs = 20;
+		}
+		if (!(ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) ||
+		    ht_cap->cap & IEEE80211_HT_CAP_40MHZ_INTOLERANT)
+			return -EINVAL;
+
+		sc = ieee80211_get_channel(&rdev->wiphy,
+					   chandef->chan->center_freq + offs);
+		if (!sc || sc->flags & IEEE80211_CHAN_DISABLED)
+			return -EINVAL;
+		/* fall through */
+	case NL80211_CHAN_HT20:
+		if (!ht_cap->ht_supported)
+			return -EINVAL;
+		break;
+	}
+
+	return 0;
+}
+
 static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 				 struct wireless_dev *wdev,
 				 struct genl_info *info)
 {
-	struct ieee80211_channel *channel;
-	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
-	u32 freq;
+	struct cfg80211_chan_def chandef;
 	int result;
 	enum nl80211_iftype iftype = NL80211_IFTYPE_MONITOR;
 
 	if (wdev)
 		iftype = wdev->iftype;
 
-	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ])
-		return -EINVAL;
-
 	if (!nl80211_can_set_dev_channel(wdev))
 		return -EOPNOTSUPP;
 
-	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE] &&
-	    !nl80211_valid_channel_type(info, &channel_type))
-		return -EINVAL;
-
-	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
+	result = nl80211_parse_chandef(rdev, info, &chandef);
+	if (result)
+		return result;
 
 	mutex_lock(&rdev->devlist_mtx);
 	switch (iftype) {
@@ -1414,22 +1466,18 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 			result = -EBUSY;
 			break;
 		}
-		channel = rdev_freq_to_chan(rdev, freq, channel_type);
-		if (!channel || !cfg80211_can_beacon_sec_chan(&rdev->wiphy,
-							      channel,
-							      channel_type)) {
+		if (!cfg80211_reg_can_beacon(&rdev->wiphy, &chandef)) {
 			result = -EINVAL;
 			break;
 		}
-		wdev->preset_chan = channel;
-		wdev->preset_chantype = channel_type;
+		wdev->preset_chandef = chandef;
 		result = 0;
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
-		result = cfg80211_set_mesh_freq(rdev, wdev, freq, channel_type);
+		result = cfg80211_set_mesh_channel(rdev, wdev, &chandef);
 		break;
 	case NL80211_IFTYPE_MONITOR:
-		result = cfg80211_set_monitor_channel(rdev, freq, channel_type);
+		result = cfg80211_set_monitor_channel(rdev, &chandef);
 		break;
 	default:
 		result = -EINVAL;
@@ -1749,6 +1797,17 @@ static inline u64 wdev_id(struct wireless_dev *wdev)
 	       ((u64)wiphy_to_dev(wdev->wiphy)->wiphy_idx << 32);
 }
 
+static int nl80211_send_chandef(struct sk_buff *msg,
+				 struct cfg80211_chan_def *chandef)
+{
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ,
+			chandef->chan->center_freq))
+		return -ENOBUFS;
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE, chandef->_type))
+		return -ENOBUFS;
+	return 0;
+}
+
 static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flags,
 			      struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev)
@@ -1775,16 +1834,14 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 		goto nla_put_failure;
 
 	if (rdev->ops->get_channel) {
-		struct ieee80211_channel *chan;
-		enum nl80211_channel_type channel_type;
-
-		chan = rdev_get_channel(rdev, wdev, &channel_type);
-		if (chan &&
-		    (nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ,
-				 chan->center_freq) ||
-		     nla_put_u32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE,
-				 channel_type)))
-			goto nla_put_failure;
+		int ret;
+		struct cfg80211_chan_def chandef;
+
+		ret = rdev_get_channel(rdev, wdev, &chandef);
+		if (ret == 0) {
+			if (nl80211_send_chandef(msg, &chandef))
+				goto nla_put_failure;
+		}
 	}
 
 	if (wdev->ssid_len) {
@@ -2492,11 +2549,10 @@ static bool nl80211_get_ap_channel(struct cfg80211_registered_device *rdev,
 		    wdev->iftype != NL80211_IFTYPE_P2P_GO)
 			continue;
 
-		if (!wdev->preset_chan)
+		if (!wdev->preset_chandef.chan)
 			continue;
 
-		params->channel = wdev->preset_chan;
-		params->channel_type = wdev->preset_chantype;
+		params->chandef = wdev->preset_chandef;
 		ret = true;
 		break;
 	}
@@ -2618,30 +2674,19 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
-		enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
-
-		if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE] &&
-		    !nl80211_valid_channel_type(info, &channel_type))
-			return -EINVAL;
-
-		params.channel = rdev_freq_to_chan(rdev,
-			nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]),
-			channel_type);
-		if (!params.channel)
-			return -EINVAL;
-		params.channel_type = channel_type;
-	} else if (wdev->preset_chan) {
-		params.channel = wdev->preset_chan;
-		params.channel_type = wdev->preset_chantype;
+		err = nl80211_parse_chandef(rdev, info, &params.chandef);
+		if (err)
+			return err;
+	} else if (wdev->preset_chandef.chan) {
+		params.chandef = wdev->preset_chandef;
 	} else if (!nl80211_get_ap_channel(rdev, &params))
 		return -EINVAL;
 
-	if (!cfg80211_can_beacon_sec_chan(&rdev->wiphy, params.channel,
-					  params.channel_type))
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
 		return -EINVAL;
 
 	mutex_lock(&rdev->devlist_mtx);
-	err = cfg80211_can_use_chan(rdev, wdev, params.channel,
+	err = cfg80211_can_use_chan(rdev, wdev, params.chandef.chan,
 				    CHAN_MODE_SHARED);
 	mutex_unlock(&rdev->devlist_mtx);
 
@@ -2650,10 +2695,9 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 
 	err = rdev_start_ap(rdev, dev, &params);
 	if (!err) {
-		wdev->preset_chan = params.channel;
-		wdev->preset_chantype = params.channel_type;
+		wdev->preset_chandef = params.chandef;
 		wdev->beacon_interval = params.beacon_interval;
-		wdev->channel = params.channel;
+		wdev->channel = params.chandef.chan;
 		wdev->ssid_len = params.ssid_len;
 		memcpy(wdev->ssid, params.ssid, wdev->ssid_len);
 	}
@@ -5354,8 +5398,7 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
 
-	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ] ||
-	    !info->attrs[NL80211_ATTR_SSID] ||
+	if (!info->attrs[NL80211_ATTR_SSID] ||
 	    !nla_len(info->attrs[NL80211_ATTR_SSID]))
 		return -EINVAL;
 
@@ -5390,34 +5433,11 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		ibss.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
-	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
-		enum nl80211_channel_type channel_type;
-
-		if (!nl80211_valid_channel_type(info, &channel_type))
-			return -EINVAL;
-
-		if (channel_type != NL80211_CHAN_NO_HT &&
-		    !(wiphy->features & NL80211_FEATURE_HT_IBSS))
-			return -EINVAL;
-
-		ibss.channel_type = channel_type;
-	} else {
-		ibss.channel_type = NL80211_CHAN_NO_HT;
-	}
-
-	ibss.channel = rdev_freq_to_chan(rdev,
-		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]),
-		ibss.channel_type);
-	if (!ibss.channel ||
-	    ibss.channel->flags & IEEE80211_CHAN_NO_IBSS ||
-	    ibss.channel->flags & IEEE80211_CHAN_DISABLED)
-		return -EINVAL;
+	err = nl80211_parse_chandef(rdev, info, &ibss.chandef);
+	if (err)
+		return err;
 
-	/* Both channels should be able to initiate communication */
-	if ((ibss.channel_type == NL80211_CHAN_HT40PLUS ||
-	     ibss.channel_type == NL80211_CHAN_HT40MINUS) &&
-	    !cfg80211_can_beacon_sec_chan(&rdev->wiphy, ibss.channel,
-					  ibss.channel_type))
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &ibss.chandef))
 		return -EINVAL;
 
 	ibss.channel_fixed = !!info->attrs[NL80211_ATTR_FREQ_FIXED];
@@ -5429,7 +5449,7 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		int n_rates =
 			nla_len(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
 		struct ieee80211_supported_band *sband =
-			wiphy->bands[ibss.channel->band];
+			wiphy->bands[ibss.chandef.chan->band];
 
 		err = ieee80211_get_ratemask(sband, rates, n_rates,
 					     &ibss.basic_rates);
@@ -5451,7 +5471,7 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		if (IS_ERR(connkeys))
 			return PTR_ERR(connkeys);
 
-		if ((ibss.channel_type != NL80211_CHAN_NO_HT) && no_ht) {
+		if ((ibss.chandef._type != NL80211_CHAN_NO_HT) && no_ht) {
 			kfree(connkeys);
 			return -EINVAL;
 		}
@@ -5972,11 +5992,11 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct wireless_dev *wdev = info->user_ptr[1];
-	struct ieee80211_channel *chan;
+	struct cfg80211_chan_def chandef;
 	struct sk_buff *msg;
 	void *hdr;
 	u64 cookie;
-	u32 freq, duration;
+	u32 duration;
 	int err;
 
 	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ] ||
@@ -5997,14 +6017,9 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 	    duration > rdev->wiphy.max_remain_on_channel_duration)
 		return -EINVAL;
 
-	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE] &&
-	    !nl80211_valid_channel_type(info, NULL))
-		return -EINVAL;
-
-	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
-	chan = rdev_freq_to_chan(rdev, freq, NL80211_CHAN_NO_HT);
-	if (chan == NULL)
-		return -EINVAL;
+	err = nl80211_parse_chandef(rdev, info, &chandef);
+	if (err)
+		return err;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
@@ -6018,7 +6033,8 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 		goto free_msg;
 	}
 
-	err = rdev_remain_on_channel(rdev, wdev, chan, duration, &cookie);
+	err = rdev_remain_on_channel(rdev, wdev, chandef.chan,
+				     duration, &cookie);
 
 	if (err)
 		goto free_msg;
@@ -6237,8 +6253,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct wireless_dev *wdev = info->user_ptr[1];
-	struct ieee80211_channel *chan;
-	u32 freq;
+	struct cfg80211_chan_def chandef;
 	int err;
 	void *hdr = NULL;
 	u64 cookie;
@@ -6248,8 +6263,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 
 	dont_wait_for_ack = info->attrs[NL80211_ATTR_DONT_WAIT_FOR_ACK];
 
-	if (!info->attrs[NL80211_ATTR_FRAME] ||
-	    !info->attrs[NL80211_ATTR_WIPHY_FREQ])
+	if (!info->attrs[NL80211_ATTR_FRAME])
 		return -EINVAL;
 
 	if (!rdev->ops->mgmt_tx)
@@ -6284,10 +6298,6 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 
 	}
 
-	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE] &&
-	    !nl80211_valid_channel_type(info, NULL))
-		return -EINVAL;
-
 	offchan = info->attrs[NL80211_ATTR_OFFCHANNEL_TX_OK];
 
 	if (offchan && !(rdev->wiphy.flags & WIPHY_FLAG_OFFCHAN_TX))
@@ -6295,10 +6305,9 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 
 	no_cck = nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
 
-	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
-	chan = rdev_freq_to_chan(rdev, freq, NL80211_CHAN_NO_HT);
-	if (chan == NULL)
-		return -EINVAL;
+	err = nl80211_parse_chandef(rdev, info, &chandef);
+	if (err)
+		return err;
 
 	if (!dont_wait_for_ack) {
 		msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
@@ -6314,7 +6323,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	err = cfg80211_mlme_mgmt_tx(rdev, wdev, chan, offchan, wait,
+	err = cfg80211_mlme_mgmt_tx(rdev, wdev, chandef.chan, offchan, wait,
 				    nla_data(info->attrs[NL80211_ATTR_FRAME]),
 				    nla_len(info->attrs[NL80211_ATTR_FRAME]),
 				    no_cck, dont_wait_for_ack, &cookie);
@@ -6578,21 +6587,12 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
-		enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
-
-		if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE] &&
-		    !nl80211_valid_channel_type(info, &channel_type))
-			return -EINVAL;
-
-		setup.channel = rdev_freq_to_chan(rdev,
-			nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]),
-			channel_type);
-		if (!setup.channel)
-			return -EINVAL;
-		setup.channel_type = channel_type;
+		err = nl80211_parse_chandef(rdev, info, &setup.chandef);
+		if (err)
+			return err;
 	} else {
 		/* cfg80211_join_mesh() will sort it out */
-		setup.channel = NULL;
+		setup.chandef.chan = NULL;
 	}
 
 	return cfg80211_join_mesh(rdev, dev, &setup, &cfg);
@@ -8824,8 +8824,8 @@ void nl80211_pmksa_candidate_notify(struct cfg80211_registered_device *rdev,
 }
 
 void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
-			      struct net_device *netdev, int freq,
-			      enum nl80211_channel_type type, gfp_t gfp)
+			      struct net_device *netdev,
+			      struct cfg80211_chan_def *chandef, gfp_t gfp)
 {
 	struct sk_buff *msg;
 	void *hdr;
@@ -8840,9 +8840,10 @@ void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
 		return;
 	}
 
-	if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
-	    nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ, freq) ||
-	    nla_put_u32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE, type))
+	if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex))
+		goto nla_put_failure;
+
+	if (nl80211_send_chandef(msg, chandef))
 		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 7adbd76..2acba847 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -127,8 +127,8 @@ void nl80211_pmksa_candidate_notify(struct cfg80211_registered_device *rdev,
 				    const u8 *bssid, bool preauth, gfp_t gfp);
 
 void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
-			      struct net_device *dev, int freq,
-			      enum nl80211_channel_type type, gfp_t gfp);
+			      struct net_device *dev,
+			      struct cfg80211_chan_def *chandef, gfp_t gfp);
 
 bool nl80211_unexpected_frame(struct net_device *dev,
 			      const u8 *addr, gfp_t gfp);
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index ee54a5a..6c0c819 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -359,12 +359,11 @@ rdev_libertas_set_mesh_channel(struct cfg80211_registered_device *rdev,
 
 static inline int
 rdev_set_monitor_channel(struct cfg80211_registered_device *rdev,
-			 struct ieee80211_channel *chan,
-			 enum nl80211_channel_type channel_type)
+			 struct cfg80211_chan_def *chandef)
 {
 	int ret;
-	trace_rdev_set_monitor_channel(&rdev->wiphy, chan, channel_type);
-	ret = rdev->ops->set_monitor_channel(&rdev->wiphy, chan, channel_type);
+	trace_rdev_set_monitor_channel(&rdev->wiphy, chandef);
+	ret = rdev->ops->set_monitor_channel(&rdev->wiphy, chandef);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
@@ -844,14 +843,17 @@ static inline void rdev_get_et_strings(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
-static inline struct ieee80211_channel
-*rdev_get_channel(struct cfg80211_registered_device *rdev,
-		  struct wireless_dev *wdev, enum nl80211_channel_type *type)
+static inline int
+rdev_get_channel(struct cfg80211_registered_device *rdev,
+		 struct wireless_dev *wdev,
+		 struct cfg80211_chan_def *chandef)
 {
-	struct ieee80211_channel *ret;
+	int ret;
+
 	trace_rdev_get_channel(&rdev->wiphy, wdev);
-	ret = rdev->ops->get_channel(&rdev->wiphy, wdev, type);
-	trace_rdev_return_channel(&rdev->wiphy, ret, *type);
+	ret = rdev->ops->get_channel(&rdev->wiphy, wdev, chandef);
+	trace_rdev_return_chandef(&rdev->wiphy, ret, chandef);
+
 	return ret;
 }
 
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 0128307..d3906db 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -126,6 +126,26 @@
 #define CHAN_PR_FMT ", band: %d, freq: %u"
 #define CHAN_PR_ARG __entry->band, __entry->center_freq
 
+#define CHAN_DEF_ENTRY __field(enum ieee80211_band, band)	\
+		       __field(u16, center_freq)		\
+		       __field(u32, channel_type)
+#define CHAN_DEF_ASSIGN(chandef)					\
+	do {								\
+		if ((chandef)->chan) {					\
+			__entry->band = (chandef)->chan->band;		\
+			__entry->center_freq =				\
+				(chandef)->chan->center_freq;		\
+			__entry->channel_type = (chandef)->_type;	\
+		} else {						\
+			__entry->band = 0;				\
+			__entry->center_freq = 0;			\
+			__entry->channel_type = 0;			\
+		}							\
+	} while (0)
+#define CHAN_DEF_PR_FMT ", band: %d, freq: %u, chantype: %d"
+#define CHAN_DEF_PR_ARG __entry->band, __entry->center_freq,		\
+			__entry->channel_type
+
 #define SINFO_ENTRY __field(int, generation)	    \
 		    __field(u32, connected_time)    \
 		    __field(u32, inactive_time)	    \
@@ -433,7 +453,7 @@ TRACE_EVENT(rdev_start_ap,
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		NETDEV_ENTRY
-		CHAN_ENTRY
+		CHAN_DEF_ENTRY
 		__field(int, beacon_interval)
 		__field(int, dtim_period)
 		__array(char, ssid, IEEE80211_MAX_SSID_LEN + 1)
@@ -446,7 +466,7 @@ TRACE_EVENT(rdev_start_ap,
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		NETDEV_ASSIGN;
-		CHAN_ASSIGN(settings->channel);
+		CHAN_DEF_ASSIGN(&settings->chandef);
 		__entry->beacon_interval = settings->beacon_interval;
 		__entry->dtim_period = settings->dtim_period;
 		__entry->hidden_ssid = settings->hidden_ssid;
@@ -458,10 +478,10 @@ TRACE_EVENT(rdev_start_ap,
 		memcpy(__entry->ssid, settings->ssid, settings->ssid_len);
 	),
 	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", AP settings - ssid: %s, "
-		  CHAN_PR_FMT ", beacon interval: %d, dtim period: %d, "
+		  CHAN_DEF_PR_FMT ", beacon interval: %d, dtim period: %d, "
 		  "hidden ssid: %d, wpa versions: %u, privacy: %s, "
 		  "auth type: %d, inactivity timeout: %d",
-		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->ssid, CHAN_PR_ARG,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->ssid, CHAN_DEF_PR_ARG,
 		  __entry->beacon_interval, __entry->dtim_period,
 		  __entry->hidden_ssid, __entry->wpa_ver,
 		  BOOL_TO_STR(__entry->privacy), __entry->auth_type,
@@ -933,21 +953,19 @@ TRACE_EVENT(rdev_libertas_set_mesh_channel,
 );
 
 TRACE_EVENT(rdev_set_monitor_channel,
-	TP_PROTO(struct wiphy *wiphy, struct ieee80211_channel *chan,
-		 enum nl80211_channel_type chan_type),
-	TP_ARGS(wiphy, chan, chan_type),
+	TP_PROTO(struct wiphy *wiphy,
+		 struct cfg80211_chan_def *chandef),
+	TP_ARGS(wiphy, chandef),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
-		CHAN_ENTRY
-		__field(enum nl80211_channel_type, chan_type)
+		CHAN_DEF_ENTRY
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
-		CHAN_ASSIGN(chan);
-		__entry->chan_type = chan_type;
+		CHAN_DEF_ASSIGN(chandef);
 	),
-	TP_printk(WIPHY_PR_FMT CHAN_PR_FMT ", channel type : %d",
-		  WIPHY_PR_ARG, CHAN_PR_ARG, __entry->chan_type)
+	TP_printk(WIPHY_PR_FMT CHAN_DEF_PR_FMT,
+		  WIPHY_PR_ARG, CHAN_DEF_PR_ARG)
 );
 
 TRACE_EVENT(rdev_auth,
@@ -1713,22 +1731,22 @@ DEFINE_EVENT(wiphy_wdev_evt, rdev_get_channel,
 	TP_ARGS(wiphy, wdev)
 );
 
-TRACE_EVENT(rdev_return_channel,
-	TP_PROTO(struct wiphy *wiphy, struct ieee80211_channel *chan,
-		 enum nl80211_channel_type type),
-	TP_ARGS(wiphy, chan, type),
+TRACE_EVENT(rdev_return_chandef,
+	TP_PROTO(struct wiphy *wiphy, int ret,
+		 struct cfg80211_chan_def *chandef),
+	TP_ARGS(wiphy, ret, chandef),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
-		CHAN_ENTRY
-		__field(enum nl80211_channel_type, type)
+		__field(int, ret)
+		CHAN_DEF_ENTRY
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
-		CHAN_ASSIGN(chan);
-		__entry->type = type;
+		CHAN_DEF_ASSIGN(chandef);
+		__entry->ret = ret;
 	),
-	TP_printk(WIPHY_PR_FMT CHAN_PR_FMT ", channel type: %d",
-		  WIPHY_PR_ARG, CHAN_PR_ARG, __entry->type)
+	TP_printk(WIPHY_PR_FMT CHAN_DEF_PR_FMT ", ret: %d",
+		  WIPHY_PR_ARG, CHAN_DEF_PR_ARG, __entry->ret)
 );
 
 DEFINE_EVENT(wiphy_wdev_evt, rdev_start_p2p_device,
@@ -1992,40 +2010,35 @@ TRACE_EVENT(cfg80211_cqm_rssi_notify,
 		  NETDEV_PR_ARG, __entry->rssi_event)
 );
 
-TRACE_EVENT(cfg80211_can_beacon_sec_chan,
-	TP_PROTO(struct wiphy *wiphy, struct ieee80211_channel *channel,
-		 enum nl80211_channel_type channel_type),
-	TP_ARGS(wiphy, channel, channel_type),
+TRACE_EVENT(cfg80211_reg_can_beacon,
+	TP_PROTO(struct wiphy *wiphy, struct cfg80211_chan_def *chandef),
+	TP_ARGS(wiphy, chandef),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
-		CHAN_ENTRY
-		__field(enum nl80211_channel_type, channel_type)
+		CHAN_DEF_ENTRY
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
-		CHAN_ASSIGN(channel);
-		__entry->channel_type = channel_type;
+		CHAN_DEF_ASSIGN(chandef);
 	),
-	TP_printk(WIPHY_PR_FMT CHAN_PR_FMT ", channel_type: %d",
-		  WIPHY_PR_ARG, CHAN_PR_ARG, __entry->channel_type)
+	TP_printk(WIPHY_PR_FMT CHAN_DEF_PR_FMT,
+		  WIPHY_PR_ARG, CHAN_DEF_PR_ARG)
 );
 
 TRACE_EVENT(cfg80211_ch_switch_notify,
-	TP_PROTO(struct net_device *netdev, int freq,
-		 enum nl80211_channel_type type),
-	TP_ARGS(netdev, freq, type),
+	TP_PROTO(struct net_device *netdev,
+		 struct cfg80211_chan_def *chandef),
+	TP_ARGS(netdev, chandef),
 	TP_STRUCT__entry(
 		NETDEV_ENTRY
-		__field(int, freq)
-		__field(enum nl80211_channel_type, type)
+		CHAN_DEF_ENTRY
 	),
 	TP_fast_assign(
 		NETDEV_ASSIGN;
-		__entry->freq = freq;
-		__entry->type = type;
+		CHAN_DEF_ASSIGN(chandef);
 	),
-	TP_printk(NETDEV_PR_FMT ", freq: %d, type: %d", NETDEV_PR_ARG,
-		  __entry->freq, __entry->type)
+	TP_printk(NETDEV_PR_FMT CHAN_DEF_PR_FMT,
+		  NETDEV_PR_ARG, CHAN_DEF_PR_ARG)
 );
 
 DECLARE_EVENT_CLASS(cfg80211_rx_evt,
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 742ab6e..da3307f 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -784,6 +784,9 @@ static int cfg80211_wext_siwfreq(struct net_device *dev,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_chan_def chandef = {
+		._type = NL80211_CHAN_NO_HT,
+	};
 	int freq, err;
 
 	switch (wdev->iftype) {
@@ -797,8 +800,11 @@ static int cfg80211_wext_siwfreq(struct net_device *dev,
 			return freq;
 		if (freq == 0)
 			return -EINVAL;
+		chandef.chan = ieee80211_get_channel(&rdev->wiphy, freq);
+		if (!chandef.chan)
+			return -EINVAL;
 		mutex_lock(&rdev->devlist_mtx);
-		err = cfg80211_set_monitor_channel(rdev, freq, NL80211_CHAN_NO_HT);
+		err = cfg80211_set_monitor_channel(rdev, &chandef);
 		mutex_unlock(&rdev->devlist_mtx);
 		return err;
 	case NL80211_IFTYPE_MESH_POINT:
@@ -807,9 +813,11 @@ static int cfg80211_wext_siwfreq(struct net_device *dev,
 			return freq;
 		if (freq == 0)
 			return -EINVAL;
+		chandef.chan = ieee80211_get_channel(&rdev->wiphy, freq);
+		if (!chandef.chan)
+			return -EINVAL;
 		mutex_lock(&rdev->devlist_mtx);
-		err = cfg80211_set_mesh_freq(rdev, wdev, freq,
-					     NL80211_CHAN_NO_HT);
+		err = cfg80211_set_mesh_channel(rdev, wdev, &chandef);
 		mutex_unlock(&rdev->devlist_mtx);
 		return err;
 	default:
@@ -823,8 +831,8 @@ static int cfg80211_wext_giwfreq(struct net_device *dev,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
-	struct ieee80211_channel *chan;
-	enum nl80211_channel_type channel_type;
+	struct cfg80211_chan_def chandef;
+	int ret;
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_STATION:
@@ -835,10 +843,10 @@ static int cfg80211_wext_giwfreq(struct net_device *dev,
 		if (!rdev->ops->get_channel)
 			return -EINVAL;
 
-		chan = rdev_get_channel(rdev, wdev, &channel_type);
-		if (!chan)
-			return -EINVAL;
-		freq->m = chan->center_freq;
+		ret = rdev_get_channel(rdev, wdev, &chandef);
+		if (ret)
+			return ret;
+		freq->m = chandef.chan->center_freq;
 		freq->e = 6;
 		return 0;
 	default:
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index 1f773f6..e6e5dbf 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -119,7 +119,15 @@ int cfg80211_mgd_wext_siwfreq(struct net_device *dev,
 	 * channel we disconnected above and reconnect below.
 	 */
 	if (chan && !wdev->wext.connect.ssid_len) {
-		err = cfg80211_set_monitor_channel(rdev, freq, NL80211_CHAN_NO_HT);
+		struct cfg80211_chan_def chandef = {
+			._type = NL80211_CHAN_NO_HT,
+		};
+
+		chandef.chan = ieee80211_get_channel(&rdev->wiphy, freq);
+		if (chandef.chan)
+			err = cfg80211_set_monitor_channel(rdev, &chandef);
+		else
+			err = -EINVAL;
 		goto out;
 	}
 
-- 
1.8.0

