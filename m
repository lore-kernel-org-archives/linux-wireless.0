Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:53780 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935500Ab3FTOLB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jun 2013 10:11:01 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH] nl80211/drivers: change bss channel to chandef
Date: Thu, 20 Jun 2013 16:10:35 +0200
Message-Id: <1371737435-5694-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130620_161126_007499_7434F007)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To prepare the wireless stack for 5/10 MHz channels, change the
cfg80211_bss structure to contain a chandef instead of a channel. This
allows to distinguish between BSSs with different widths (5, 10, 20+
MHz) on the same channel. Scanning or connecting explicitly in a
certain channel width can be added later.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |    4 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |    5 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |    5 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 +
 drivers/net/wireless/libertas/cfg.c                |    7 +-
 drivers/net/wireless/mwifiex/cfg80211.c            |    4 +-
 drivers/net/wireless/mwifiex/scan.c                |    3 +
 drivers/net/wireless/orinoco/scan.c                |    8 +-
 drivers/net/wireless/rndis_wlan.c                  |    4 +
 drivers/staging/wlan-ng/cfg80211.c                 |    9 +-
 include/net/cfg80211.h                             |   18 ++--
 net/mac80211/ibss.c                                |   20 ++--
 net/mac80211/mlme.c                                |   23 ++--
 net/mac80211/scan.c                                |    4 +-
 net/wireless/chan.c                                |    4 +-
 net/wireless/core.h                                |    2 +-
 net/wireless/ibss.c                                |    2 +-
 net/wireless/mlme.c                                |   16 +--
 net/wireless/nl80211.c                             |   14 +--
 net/wireless/scan.c                                |  111 ++++++++++++++------
 net/wireless/sme.c                                 |   21 +++-
 net/wireless/trace.h                               |   42 ++++----
 net/wireless/wext-sme.c                            |    2 +-
 23 files changed, 214 insertions(+), 116 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 2437ad2..0819e07 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -686,6 +686,7 @@ ath6kl_add_bss_if_needed(struct ath6kl_vif *vif,
 {
 	struct ath6kl *ar = vif->ar;
 	struct cfg80211_bss *bss;
+	struct cfg80211_chan_def chandef;
 	u16 cap_mask, cap_val;
 	u8 *ie;
 
@@ -716,7 +717,8 @@ ath6kl_add_bss_if_needed(struct ath6kl_vif *vif,
 		ie[1] = vif->ssid_len;
 		memcpy(ie + 2, vif->ssid, vif->ssid_len);
 		memcpy(ie + 2 + vif->ssid_len, beacon_ie, beacon_ie_len);
-		bss = cfg80211_inform_bss(ar->wiphy, chan,
+		cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_NO_HT);
+		bss = cfg80211_inform_bss(ar->wiphy, &chandef,
 					  bssid, 0, cap_val, 100,
 					  ie, 2 + vif->ssid_len + beacon_ie_len,
 					  0, GFP_KERNEL);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 87aefb4..4e42f29 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1044,6 +1044,7 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len,
 	struct wmi_bss_info_hdr2 *bih;
 	u8 *buf;
 	struct ieee80211_channel *channel;
+	struct cfg80211_chan_def chandef;
 	struct ath6kl *ar = wmi->parent_dev;
 	struct ieee80211_mgmt *mgmt;
 	struct cfg80211_bss *bss;
@@ -1120,7 +1121,9 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len,
 
 	memcpy(&mgmt->u.beacon, buf, len);
 
-	bss = cfg80211_inform_bss_frame(ar->wiphy, channel, mgmt,
+	cfg80211_chandef_create(&chandef, channel, NL80211_CHAN_NO_HT);
+
+	bss = cfg80211_inform_bss_frame(ar->wiphy, &chandef, mgmt,
 					24 + len, (bih->snr - 95) * 100,
 					GFP_ATOMIC);
 	kfree(mgmt);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 527ffb5..e2047e5 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -300,6 +300,7 @@ static void wmi_evt_rx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
 {
 	struct wmi_rx_mgmt_packet_event *data = d;
 	struct wiphy *wiphy = wil_to_wiphy(wil);
+	struct cfg80211_chan_def chandef;
 	struct ieee80211_mgmt *rx_mgmt_frame =
 			(struct ieee80211_mgmt *)data->payload;
 	int ch_no = data->info.channel+1;
@@ -327,7 +328,9 @@ static void wmi_evt_rx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
 	if (ieee80211_is_beacon(fc) || ieee80211_is_probe_resp(fc)) {
 		struct cfg80211_bss *bss;
 
-		bss = cfg80211_inform_bss_frame(wiphy, channel, rx_mgmt_frame,
+		/* TODO: this is actually no 20 MHz channel width ... */
+		cfg80211_chandef_create(&chandef, channel, NL80211_CHAN_NO_HT);
+		bss = cfg80211_inform_bss_frame(wiphy, &chandef, rx_mgmt_frame,
 						d_len, signal, GFP_KERNEL);
 		if (bss) {
 			wil_dbg_wmi(wil, "Added BSS %pM\n",
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 8bd256b..f6151d0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2235,6 +2235,7 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 {
 	struct wiphy *wiphy = cfg_to_wiphy(cfg);
 	struct ieee80211_channel *notify_channel;
+	struct cfg80211_chan_def chandef;
 	struct cfg80211_bss *bss;
 	struct ieee80211_supported_band *band;
 	struct brcmu_chan ch;
@@ -2279,6 +2280,7 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 	brcmf_dbg(CONN, "Beacon interval: %d\n", notify_interval);
 	brcmf_dbg(CONN, "Signal: %d\n", notify_signal);
 
+	cfg80211_chandef_create(&chandef, channel, NL80211_CHAN_NO_HT);
 	bss = cfg80211_inform_bss(wiphy, notify_channel, (const u8 *)bi->BSSID,
 		0, notify_capability, notify_interval, notify_ie,
 		notify_ielen, notify_signal, GFP_KERNEL);
diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 116f4ab..e252fd7 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -504,6 +504,7 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
 	struct cmd_header *resp)
 {
 	struct cfg80211_bss *bss;
+	struct cfg80211_chan_def chandef;
 	struct cmd_ds_802_11_scan_rsp *scanresp = (void *)resp;
 	int bsssize;
 	const u8 *pos;
@@ -652,7 +653,9 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
 
 			if (channel &&
 			    !(channel->flags & IEEE80211_CHAN_DISABLED)) {
-				bss = cfg80211_inform_bss(wiphy, channel,
+				cfg80211_chandef_create(&chandef, channel,
+							NL80211_CHAN_NO_HT);
+				bss = cfg80211_inform_bss(wiphy, &chandef,
 					bssid, get_unaligned_le64(tsfdesc),
 					capa, intvl, ie, ielen,
 					LBS_SCAN_RSSI_TO_MBM(rssi),
@@ -1759,7 +1762,7 @@ static void lbs_join_post(struct lbs_private *priv,
 	lbs_deb_hex(LBS_DEB_CFG80211, "IE", fake_ie, fake - fake_ie);
 
 	bss = cfg80211_inform_bss(priv->wdev->wiphy,
-				  params->chandef.chan,
+				  &params->chandef,
 				  bssid,
 				  0,
 				  capability,
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 856aea2..a2843fd 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1514,6 +1514,7 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 	struct ieee80211_channel *chan;
 	struct mwifiex_bss_info bss_info;
 	struct cfg80211_bss *bss;
+	struct cfg80211_chan_def chandef;
 	int ie_len;
 	u8 ie_buf[IEEE80211_MAX_SSID_LEN + sizeof(struct ieee_types_header)];
 	enum ieee80211_band band;
@@ -1533,7 +1534,8 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 			ieee80211_channel_to_frequency(bss_info.bss_chan,
 						       band));
 
-	bss = cfg80211_inform_bss(priv->wdev->wiphy, chan,
+	cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_NO_HT);
+	bss = cfg80211_inform_bss(priv->wdev->wiphy, &chandef,
 				  bss_info.bssid, 0, WLAN_CAPABILITY_IBSS,
 				  0, ie_buf, ie_len, 0, GFP_KERNEL);
 	cfg80211_put_bss(priv->wdev->wiphy, bss);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 801b6b7..410b281 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1559,6 +1559,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 	u8 is_bgscan_resp;
 	unsigned long flags;
 	struct cfg80211_bss *bss;
+	struct cfg80211_chan_def chandef;
 
 	is_bgscan_resp = (le16_to_cpu(resp->command)
 			  == HostCmd_CMD_802_11_BG_SCAN_QUERY);
@@ -1743,6 +1744,8 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 			chan = ieee80211_get_channel(priv->wdev->wiphy, freq);
 
 			if (chan && !(chan->flags & IEEE80211_CHAN_DISABLED)) {
+				cfg80211_chandef_create(&chandef, channel,
+							NL80211_CHAN_NO_HT);
 				bss = cfg80211_inform_bss(priv->wdev->wiphy,
 					      chan, bssid, timestamp,
 					      cap_info_bitmap, beacon_period,
diff --git a/drivers/net/wireless/orinoco/scan.c b/drivers/net/wireless/orinoco/scan.c
index e8c5714..8837a81 100644
--- a/drivers/net/wireless/orinoco/scan.c
+++ b/drivers/net/wireless/orinoco/scan.c
@@ -76,6 +76,7 @@ static void orinoco_add_hostscan_result(struct orinoco_private *priv,
 {
 	struct wiphy *wiphy = priv_to_wiphy(priv);
 	struct ieee80211_channel *channel;
+	struct cfg80211_chan_def chandef;
 	struct cfg80211_bss *cbss;
 	u8 *ie;
 	u8 ie_buf[46];
@@ -122,7 +123,8 @@ static void orinoco_add_hostscan_result(struct orinoco_private *priv,
 	beacon_interval = le16_to_cpu(bss->a.beacon_interv);
 	signal = SIGNAL_TO_MBM(le16_to_cpu(bss->a.level));
 
-	cbss = cfg80211_inform_bss(wiphy, channel, bss->a.bssid, timestamp,
+	cfg80211_chandef_create(&chandef, channel, NL80211_CHAN_NO_HT);
+	cbss = cfg80211_inform_bss(wiphy, &chandef, bss->a.bssid, timestamp,
 				   capability, beacon_interval, ie_buf, ie_len,
 				   signal, GFP_KERNEL);
 	cfg80211_put_bss(wiphy, cbss);
@@ -134,6 +136,7 @@ void orinoco_add_extscan_result(struct orinoco_private *priv,
 {
 	struct wiphy *wiphy = priv_to_wiphy(priv);
 	struct ieee80211_channel *channel;
+	struct cfg80211_chan_def chandef;
 	struct cfg80211_bss *cbss;
 	const u8 *ie;
 	u64 timestamp;
@@ -155,7 +158,8 @@ void orinoco_add_extscan_result(struct orinoco_private *priv,
 	ie = bss->data;
 	signal = SIGNAL_TO_MBM(bss->level);
 
-	cbss = cfg80211_inform_bss(wiphy, channel, bss->bssid, timestamp,
+	cfg80211_chandef_create(&chandef, channel, NL80211_CHAN_NO_HT);
+	cbss = cfg80211_inform_bss(wiphy, &chandef, bss->bssid, timestamp,
 				   capability, beacon_interval, ie, ie_len,
 				   signal, GFP_KERNEL);
 	cfg80211_put_bss(wiphy, cbss);
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 8169a85..e8a4e16 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1984,6 +1984,7 @@ static bool rndis_bss_info_update(struct usbnet *usbdev,
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ieee80211_channel *channel;
+	struct cfg80211_chan_def chandef;
 	struct cfg80211_bss *bss;
 	s32 signal;
 	u64 timestamp;
@@ -2023,6 +2024,7 @@ static bool rndis_bss_info_update(struct usbnet *usbdev,
 	capability = le16_to_cpu(fixed->capabilities);
 	beacon_interval = le16_to_cpu(fixed->beacon_interval);
 
+	cfg80211_chandef_create(&chandef, channel, NL80211_CHAN_NO_HT);
 	bss = cfg80211_inform_bss(priv->wdev.wiphy, channel, bssid->mac,
 		timestamp, capability, beacon_interval, ie, ie_len, signal,
 		GFP_KERNEL);
@@ -2648,6 +2650,7 @@ static void rndis_wlan_craft_connected_bss(struct usbnet *usbdev, u8 *bssid,
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ieee80211_channel *channel;
 	struct ndis_80211_ssid ssid;
+	struct cfg80211_chan_def chandef;
 	struct cfg80211_bss *bss;
 	s32 signal;
 	u64 timestamp;
@@ -2712,6 +2715,7 @@ static void rndis_wlan_craft_connected_bss(struct usbnet *usbdev, u8 *bssid,
 		bssid, (u32)timestamp, capability, beacon_period, ie_len,
 		ssid.essid, signal);
 
+	cfg80211_chandef_create(&chandef, channel, NL80211_CHAN_NO_HT);
 	bss = cfg80211_inform_bss(priv->wdev.wiphy, channel, bssid,
 		timestamp, capability, beacon_period, ie_buf, ie_len,
 		signal, GFP_KERNEL);
diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index f1bce18..e91d50a 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -334,8 +334,11 @@ int prism2_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 	wlandevice_t *wlandev;
 	struct p80211msg_dot11req_scan msg1;
 	struct p80211msg_dot11req_scan_results msg2;
+	struct cfg80211_chan_def chandef;
 	struct cfg80211_bss *bss;
+	struct ieee80211_channel *channel;
 	int result;
+	int freq;
 	int err = 0;
 	int numbss = 0;
 	int i = 0;
@@ -408,8 +411,10 @@ int prism2_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 		ie_buf[1] = msg2.ssid.data.len;
 		ie_len = ie_buf[1] + 2;
 		memcpy(&ie_buf[2], &(msg2.ssid.data.data), msg2.ssid.data.len);
-		bss = cfg80211_inform_bss(wiphy,
-			ieee80211_get_channel(wiphy, ieee80211_dsss_chan_to_freq(msg2.dschannel.data)),
+		freq = ieee80211_dsss_chan_to_freq(msg2.dschannel.data);
+		channel = ieee80211_get_channel(wiphy, freq);
+		cfg80211_chandef_create(&chandef, channel, NL80211_CHAN_NO_HT);
+		bss = cfg80211_inform_bss(wiphy, &chandef,
 			(const u8 *) &(msg2.bssid.data.data),
 			msg2.timestamp.data, msg2.capinfo.data,
 			msg2.beaconperiod.data,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e3a39fc..18c0850 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1402,7 +1402,7 @@ struct cfg80211_bss_ies {
  * This structure describes a BSS (which may also be a mesh network)
  * for use in scan results and similar.
  *
- * @channel: channel this BSS is on
+ * @chandef: chandef of the channel this BSS is on
  * @bssid: BSSID of the BSS
  * @beacon_interval: the beacon interval as from the frame
  * @capability: the capability field in host byte order
@@ -1423,7 +1423,7 @@ struct cfg80211_bss_ies {
  * @priv: private area for driver use, has at least wiphy->bss_priv_size bytes
  */
 struct cfg80211_bss {
-	struct ieee80211_channel *channel;
+	struct cfg80211_chan_def chandef;
 
 	const struct cfg80211_bss_ies __rcu *ies;
 	const struct cfg80211_bss_ies __rcu *beacon_ies;
@@ -3382,7 +3382,7 @@ void cfg80211_sched_scan_stopped(struct wiphy *wiphy);
  * cfg80211_inform_bss_frame - inform cfg80211 of a received BSS frame
  *
  * @wiphy: the wiphy reporting the BSS
- * @channel: The channel the frame was received on
+ * @chandef: The chandef of the channel the frame was received on
  * @mgmt: the management frame (probe response or beacon)
  * @len: length of the management frame
  * @signal: the signal strength, type depends on the wiphy's signal_type
@@ -3396,7 +3396,7 @@ void cfg80211_sched_scan_stopped(struct wiphy *wiphy);
  */
 struct cfg80211_bss * __must_check
 cfg80211_inform_bss_frame(struct wiphy *wiphy,
-			  struct ieee80211_channel *channel,
+			  struct cfg80211_chan_def *chandef,
 			  struct ieee80211_mgmt *mgmt, size_t len,
 			  s32 signal, gfp_t gfp);
 
@@ -3404,7 +3404,7 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
  * cfg80211_inform_bss - inform cfg80211 of a new BSS
  *
  * @wiphy: the wiphy reporting the BSS
- * @channel: The channel the frame was received on
+ * @chandef: The chandef of the channel the frame was received on
  * @bssid: the BSSID of the BSS
  * @tsf: the TSF sent by the peer in the beacon/probe response (or 0)
  * @capability: the capability field sent by the peer
@@ -3422,22 +3422,22 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
  */
 struct cfg80211_bss * __must_check
 cfg80211_inform_bss(struct wiphy *wiphy,
-		    struct ieee80211_channel *channel,
+		    struct cfg80211_chan_def *chandef,
 		    const u8 *bssid, u64 tsf, u16 capability,
 		    u16 beacon_interval, const u8 *ie, size_t ielen,
 		    s32 signal, gfp_t gfp);
 
 struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
-				      struct ieee80211_channel *channel,
+				      struct cfg80211_chan_def *chandef,
 				      const u8 *bssid,
 				      const u8 *ssid, size_t ssid_len,
 				      u16 capa_mask, u16 capa_val);
 static inline struct cfg80211_bss *
 cfg80211_get_ibss(struct wiphy *wiphy,
-		  struct ieee80211_channel *channel,
+		  struct cfg80211_chan_def *chandef,
 		  const u8 *ssid, size_t ssid_len)
 {
-	return cfg80211_get_bss(wiphy, channel, NULL, ssid, ssid_len,
+	return cfg80211_get_bss(wiphy, chandef, NULL, ssid, ssid_len,
 				WLAN_CAPABILITY_IBSS, WLAN_CAPABILITY_IBSS);
 }
 
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index ea7b9c2..bef96b8 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -246,7 +246,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	mod_timer(&ifibss->timer,
 		  round_jiffies(jiffies + IEEE80211_IBSS_MERGE_INTERVAL));
 
-	bss = cfg80211_inform_bss_frame(local->hw.wiphy, chan,
+	bss = cfg80211_inform_bss_frame(local->hw.wiphy, &chandef,
 					mgmt, presp->head_len, 0, GFP_KERNEL);
 	cfg80211_put_bss(local->hw.wiphy, bss);
 	netif_carrier_on(sdata->dev);
@@ -270,7 +270,7 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	if (beacon_int < 10)
 		beacon_int = 10;
 
-	sband = sdata->local->hw.wiphy->bands[cbss->channel->band];
+	sband = sdata->local->hw.wiphy->bands[cbss->chandef.chan->band];
 
 	basic_rates = 0;
 
@@ -294,7 +294,7 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	__ieee80211_sta_join_ibss(sdata, cbss->bssid,
 				  beacon_int,
-				  cbss->channel,
+				  cbss->chandef.chan,
 				  basic_rates,
 				  cbss->capability,
 				  tsf, false);
@@ -546,7 +546,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 
 	/* different channel */
 	if (sdata->u.ibss.fixed_channel &&
-	    sdata->u.ibss.chandef.chan != cbss->channel)
+	    !cfg80211_chandef_compatible(&sdata->u.ibss.chandef,
+					 &cbss->chandef))
 		goto put_bss;
 
 	/* different SSID */
@@ -749,7 +750,7 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
 	struct cfg80211_bss *cbss;
-	struct ieee80211_channel *chan = NULL;
+	struct cfg80211_chan_def *chandef = NULL;
 	const u8 *bssid = NULL;
 	int active_ibss;
 	u16 capability;
@@ -768,10 +769,10 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 	if (ifibss->fixed_bssid)
 		bssid = ifibss->bssid;
 	if (ifibss->fixed_channel)
-		chan = ifibss->chandef.chan;
+		chandef = &ifibss->chandef;
 	if (!is_zero_ether_addr(ifibss->bssid))
 		bssid = ifibss->bssid;
-	cbss = cfg80211_get_bss(local->hw.wiphy, chan, bssid,
+	cbss = cfg80211_get_bss(local->hw.wiphy, chandef, bssid,
 				ifibss->ssid, ifibss->ssid_len,
 				WLAN_CAPABILITY_IBSS | WLAN_CAPABILITY_PRIVACY,
 				capability);
@@ -800,7 +801,8 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 		sdata_info(sdata, "Trigger new scan to find an IBSS to join\n");
 
 		ieee80211_request_ibss_scan(sdata, ifibss->ssid,
-					    ifibss->ssid_len, chan);
+					    ifibss->ssid_len,
+					    chandef ? chandef->chan : NULL);
 	} else {
 		int interval = IEEE80211_SCAN_INTERVAL;
 
@@ -1094,7 +1096,7 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 		if (ifibss->privacy)
 			capability |= WLAN_CAPABILITY_PRIVACY;
 
-		cbss = cfg80211_get_bss(local->hw.wiphy, ifibss->chandef.chan,
+		cbss = cfg80211_get_bss(local->hw.wiphy, &ifibss->chandef,
 					ifibss->bssid, ifibss->ssid,
 					ifibss->ssid_len, WLAN_CAPABILITY_IBSS |
 					WLAN_CAPABILITY_PRIVACY,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e0939eb..c7ffbc9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -953,7 +953,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	}
 
 	/* XXX: shouldn't really modify cfg80211-owned data! */
-	ifmgd->associated->channel = local->_oper_chandef.chan;
+	ifmgd->associated->chandef = local->_oper_chandef;
 
 	/* XXX: wait for a beacon first? */
 	ieee80211_wake_queues_by_reason(&local->hw,
@@ -1053,7 +1053,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		count = elems->ext_chansw_ie->count;
 		mode = elems->ext_chansw_ie->mode;
 	} else if (elems->ch_switch_ie) {
-		new_band = cbss->channel->band;
+		new_band = cbss->chandef.chan->band;
 		new_chan_no = elems->ch_switch_ie->new_ch_num;
 		count = elems->ch_switch_ie->count;
 		mode = elems->ch_switch_ie->mode;
@@ -2030,7 +2030,8 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 
 		ieee80211_send_probe_req(sdata, dst, ssid + 2, ssid_len, NULL,
 					 0, (u32) -1, true, 0,
-					 ifmgd->associated->channel, false);
+					 ifmgd->associated->chandef.chan,
+					 false);
 		rcu_read_unlock();
 	}
 
@@ -2138,7 +2139,7 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 		ssid_len = ssid[1];
 
 	skb = ieee80211_build_probe_req(sdata, cbss->bssid,
-					(u32) -1, cbss->channel,
+					(u32) -1, cbss->chandef.chan,
 					ssid + 2, ssid_len,
 					NULL, 0, true);
 	rcu_read_unlock();
@@ -3316,7 +3317,7 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 		 */
 		ieee80211_send_probe_req(sdata, NULL, ssidie + 2, ssidie[1],
 					 NULL, 0, (u32) -1, true, 0,
-					 auth_data->bss->channel, false);
+					 auth_data->bss->chandef.chan, false);
 		rcu_read_unlock();
 	}
 
@@ -3711,7 +3712,7 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_chan_def chandef;
 	int ret;
 
-	sband = local->hw.wiphy->bands[cbss->channel->band];
+	sband = local->hw.wiphy->bands[cbss->chandef.chan->band];
 
 	ifmgd->flags &= ~(IEEE80211_STA_DISABLE_40MHZ |
 			  IEEE80211_STA_DISABLE_80P80MHZ |
@@ -3758,7 +3759,7 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	}
 
 	ifmgd->flags |= ieee80211_determine_chantype(sdata, sband,
-						     cbss->channel,
+						     cbss->chandef.chan,
 						     ht_oper, vht_oper,
 						     &chandef, true);
 
@@ -3823,7 +3824,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 		struct ieee80211_supported_band *sband;
 		const struct cfg80211_bss_ies *ies;
 
-		sband = local->hw.wiphy->bands[cbss->channel->band];
+		sband = local->hw.wiphy->bands[cbss->chandef.chan->band];
 
 		err = ieee80211_prep_channel(sdata, cbss);
 		if (err) {
@@ -3851,11 +3852,11 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 			basic_rates = BIT(min_rate_index);
 		}
 
-		new_sta->sta.supp_rates[cbss->channel->band] = rates;
+		new_sta->sta.supp_rates[cbss->chandef.chan->band] = rates;
 		sdata->vif.bss_conf.basic_rates = basic_rates;
 
 		/* cf. IEEE 802.11 9.2.12 */
-		if (cbss->channel->band == IEEE80211_BAND_2GHZ &&
+		if (cbss->chandef.chan->band == IEEE80211_BAND_2GHZ &&
 		    have_higher_than_11mbit)
 			sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
 		else
@@ -4117,7 +4118,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
 
 	/* Also disable HT if we don't support it or the AP doesn't use WMM */
-	sband = local->hw.wiphy->bands[req->bss->channel->band];
+	sband = local->hw.wiphy->bands[req->bss->chandef.chan->band];
 	if (!sband->ht_cap.ht_supported ||
 	    local->hw.queues < IEEE80211_NUM_ACS || !bss->wmm_used) {
 		ifmgd->flags |= IEEE80211_STA_DISABLE_HT;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 1b122a7..2f460e4 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -65,6 +65,7 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	bool beacon = ieee80211_is_beacon(mgmt->frame_control);
 	struct cfg80211_bss *cbss;
 	struct ieee80211_bss *bss;
+	struct cfg80211_chan_def chandef;
 	int clen, srlen;
 	s32 signal = 0;
 
@@ -73,7 +74,8 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	else if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
 		signal = (rx_status->signal * 100) / local->hw.max_signal;
 
-	cbss = cfg80211_inform_bss_frame(local->hw.wiphy, channel,
+	cfg80211_chandef_create(&chandef, channel, NL80211_CHAN_NO_HT);
+	cbss = cfg80211_inform_bss_frame(local->hw.wiphy, &chandef,
 					 mgmt, len, signal, GFP_ATOMIC);
 	if (!cbss)
 		return NULL;
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 50f6195..ddfd779 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -502,7 +502,7 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_ADHOC:
 		if (wdev->current_bss) {
-			*chan = wdev->current_bss->pub.channel;
+			*chan = wdev->current_bss->pub.chandef.chan;
 			*chanmode = wdev->ibss_fixed
 				  ? CHAN_MODE_SHARED
 				  : CHAN_MODE_EXCLUSIVE;
@@ -511,7 +511,7 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
 		if (wdev->current_bss) {
-			*chan = wdev->current_bss->pub.channel;
+			*chan = wdev->current_bss->pub.chandef.chan;
 			*chanmode = CHAN_MODE_SHARED;
 			return;
 		}
diff --git a/net/wireless/core.h b/net/wireless/core.h
index a6b45bf..b6c4749 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -285,7 +285,7 @@ int cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 /* MLME */
 int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev,
-		       struct ieee80211_channel *chan,
+		       struct cfg80211_chan_def *chandef,
 		       enum nl80211_auth_type auth_type,
 		       const u8 *bssid,
 		       const u8 *ssid, int ssid_len,
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 39bff7d..c9761c8 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -373,7 +373,7 @@ int cfg80211_ibss_wext_giwfreq(struct net_device *dev,
 
 	wdev_lock(wdev);
 	if (wdev->current_bss)
-		chan = wdev->current_bss->pub.channel;
+		chan = wdev->current_bss->pub.chandef.chan;
 	else if (wdev->wext.ibss.chandef.chan)
 		chan = wdev->wext.ibss.chandef.chan;
 	wdev_unlock(wdev);
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index a61a44b..70546aa 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -193,7 +193,7 @@ EXPORT_SYMBOL(cfg80211_michael_mic_failure);
 /* some MLME handling for userspace SME */
 int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev,
-		       struct ieee80211_channel *chan,
+		       struct cfg80211_chan_def *chandef,
 		       enum nl80211_auth_type auth_type,
 		       const u8 *bssid,
 		       const u8 *ssid, int ssid_len,
@@ -224,12 +224,13 @@ int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 	    ether_addr_equal(bssid, wdev->current_bss->pub.bssid))
 		return -EALREADY;
 
-	req.bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
-				   WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+	req.bss = cfg80211_get_bss(&rdev->wiphy, chandef, bssid, ssid,
+				   ssid_len, WLAN_CAPABILITY_ESS,
+				   WLAN_CAPABILITY_ESS);
 	if (!req.bss)
 		return -ENOENT;
 
-	err = cfg80211_can_use_chan(rdev, wdev, req.bss->channel,
+	err = cfg80211_can_use_chan(rdev, wdev, req.bss->chandef.chan,
 				    CHAN_MODE_SHARED);
 	if (err)
 		goto out;
@@ -283,6 +284,7 @@ int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			struct cfg80211_assoc_request *req)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_chan_def chandef;
 	int err;
 
 	ASSERT_WDEV_LOCK(wdev);
@@ -297,8 +299,10 @@ int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 	cfg80211_oper_and_vht_capa(&req->vht_capa_mask,
 				   rdev->wiphy.vht_capa_mod_mask);
 
-	req->bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
-				    WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+	cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_NO_HT);
+	req->bss = cfg80211_get_bss(&rdev->wiphy, &chandef, bssid, ssid,
+				    ssid_len, WLAN_CAPABILITY_ESS,
+				    WLAN_CAPABILITY_ESS);
 	if (!req->bss)
 		return -ENOENT;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4ab1ffa..70d2b63 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5608,7 +5608,8 @@ static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 	    nla_put_u16(msg, NL80211_BSS_BEACON_INTERVAL, res->beacon_interval))
 		goto nla_put_failure;
 	if (nla_put_u16(msg, NL80211_BSS_CAPABILITY, res->capability) ||
-	    nla_put_u32(msg, NL80211_BSS_FREQUENCY, res->channel->center_freq) ||
+	    nla_put_u32(msg, NL80211_BSS_FREQUENCY,
+			res->chandef.chan->center_freq) ||
 	    nla_put_u32(msg, NL80211_BSS_SEEN_MS_AGO,
 			jiffies_to_msecs(jiffies - intbss->ts)))
 		goto nla_put_failure;
@@ -5823,7 +5824,7 @@ static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
-	struct ieee80211_channel *chan;
+	struct cfg80211_chan_def chandef;
 	const u8 *bssid, *ssid, *ie = NULL, *sae_data = NULL;
 	int err, ssid_len, ie_len = 0, sae_data_len = 0;
 	enum nl80211_auth_type auth_type;
@@ -5887,10 +5888,9 @@ static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
 		return -EOPNOTSUPP;
 
 	bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
-	chan = ieee80211_get_channel(&rdev->wiphy,
-		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
-	if (!chan || (chan->flags & IEEE80211_CHAN_DISABLED))
-		return -EINVAL;
+	err = nl80211_parse_chandef(rdev, info, &chandef);
+	if (!err)
+		return err;
 
 	ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
 	ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
@@ -5928,7 +5928,7 @@ static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
 		return 0;
 
 	wdev_lock(dev->ieee80211_ptr);
-	err = cfg80211_mlme_auth(rdev, dev, chan, auth_type, bssid,
+	err = cfg80211_mlme_auth(rdev, dev, &chandef, auth_type, bssid,
 				 ssid, ssid_len, ie, ie_len,
 				 key.p.key, key.p.key_len, key.idx,
 				 sae_data, sae_data_len);
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index dd01b58..2dfb357 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -419,6 +419,20 @@ enum bss_compare_mode {
 	BSS_CMP_HIDE_NUL,
 };
 
+static int cfg80211_chandef_compare(struct cfg80211_chan_def *a,
+				    struct cfg80211_chan_def *b)
+{
+	if (a->center_freq1 != b->center_freq1)
+		return b->center_freq1 - a->center_freq1;
+	if (a->center_freq2 != b->center_freq2)
+		return b->center_freq2 - a->center_freq2;
+	/* this is used only to create an order */
+	if (b->width > a->width)
+		return 1;
+	else
+		return -1;
+}
+
 static int cmp_bss(struct cfg80211_bss *a,
 		   struct cfg80211_bss *b,
 		   enum bss_compare_mode mode)
@@ -428,8 +442,8 @@ static int cmp_bss(struct cfg80211_bss *a,
 	const u8 *ie2 = NULL;
 	int i, r;
 
-	if (a->channel != b->channel)
-		return b->channel->center_freq - a->channel->center_freq;
+	if (!cfg80211_chandef_compatible(&a->chandef, &b->chandef))
+		return cfg80211_chandef_compare(&a->chandef, &b->chandef);
 
 	a_ies = rcu_access_pointer(a->ies);
 	if (!a_ies)
@@ -524,7 +538,7 @@ static int cmp_bss(struct cfg80211_bss *a,
 }
 
 struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
-				      struct ieee80211_channel *channel,
+				      struct cfg80211_chan_def *chandef,
 				      const u8 *bssid,
 				      const u8 *ssid, size_t ssid_len,
 				      u16 capa_mask, u16 capa_val)
@@ -533,7 +547,7 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 	struct cfg80211_internal_bss *bss, *res = NULL;
 	unsigned long now = jiffies;
 
-	trace_cfg80211_get_bss(wiphy, channel, bssid, ssid, ssid_len, capa_mask,
+	trace_cfg80211_get_bss(wiphy, chandef, bssid, ssid, ssid_len, capa_mask,
 			       capa_val);
 
 	spin_lock_bh(&dev->bss_lock);
@@ -541,7 +555,8 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 	list_for_each_entry(bss, &dev->bss_list, list) {
 		if ((bss->pub.capability & capa_mask) != capa_val)
 			continue;
-		if (channel && bss->pub.channel != channel)
+		if (chandef && chandef->chan &&
+		    !cfg80211_chandef_compatible(&bss->pub.chandef, chandef))
 			continue;
 		/* Don't get expired BSS structs */
 		if (time_after(now, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE) &&
@@ -648,7 +663,8 @@ static bool cfg80211_combine_bsses(struct cfg80211_registered_device *dev,
 	list_for_each_entry(bss, &dev->bss_list, list) {
 		if (!ether_addr_equal(bss->pub.bssid, new->pub.bssid))
 			continue;
-		if (bss->pub.channel != new->pub.channel)
+		if (!cfg80211_chandef_compatible(&bss->pub.chandef,
+						 &new->pub.chandef))
 			continue;
 		if (rcu_access_pointer(bss->pub.beacon_ies))
 			continue;
@@ -684,7 +700,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 {
 	struct cfg80211_internal_bss *found = NULL;
 
-	if (WARN_ON(!tmp->pub.channel))
+	if (WARN_ON(!tmp->pub.chandef.chan))
 		return NULL;
 
 	tmp->ts = jiffies;
@@ -834,9 +850,10 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 	return NULL;
 }
 
-static struct ieee80211_channel *
-cfg80211_get_bss_channel(struct wiphy *wiphy, const u8 *ie, size_t ielen,
-			 struct ieee80211_channel *channel)
+static int
+cfg80211_get_bss_chandef(struct wiphy *wiphy, const u8 *ie, size_t ielen,
+			 struct cfg80211_chan_def *new_chandef,
+			 struct cfg80211_chan_def *chandef)
 {
 	const u8 *tmp;
 	u32 freq;
@@ -854,27 +871,54 @@ cfg80211_get_bss_channel(struct wiphy *wiphy, const u8 *ie, size_t ielen,
 		}
 	}
 
-	if (channel_number < 0)
-		return channel;
+	if (channel_number < 0) {
+		*new_chandef = *chandef;
+	} else {
+		freq = ieee80211_channel_to_frequency(channel_number,
+						      chandef->chan->band);
+		new_chandef->chan = ieee80211_get_channel(wiphy, freq);
+	}
+	if (!new_chandef->chan)
+		return -EINVAL;
+	if (!new_chandef->chan->flags & IEEE80211_CHAN_DISABLED)
+		return -EINVAL;
 
-	freq = ieee80211_channel_to_frequency(channel_number, channel->band);
-	channel = ieee80211_get_channel(wiphy, freq);
-	if (!channel)
-		return NULL;
-	if (channel->flags & IEEE80211_CHAN_DISABLED)
-		return NULL;
-	return channel;
+	/* use 20 MHz width on compatible channels. 5/10 MHz channels will
+	 * have a different width stored.
+	 */
+	switch (chandef->width) {
+	default:
+		WARN_ON_ONCE(1);
+		/* fall through */
+	case NL80211_CHAN_WIDTH_20:
+	case NL80211_CHAN_WIDTH_40:
+	case NL80211_CHAN_WIDTH_80:
+	case NL80211_CHAN_WIDTH_80P80:
+	case NL80211_CHAN_WIDTH_160:
+		new_chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
+		break;
+	case NL80211_CHAN_WIDTH_5:
+		new_chandef->width = NL80211_CHAN_WIDTH_5;
+		break;
+	case NL80211_CHAN_WIDTH_10:
+		new_chandef->width = NL80211_CHAN_WIDTH_10;
+		break;
+	}
+	new_chandef->center_freq1 = new_chandef->chan->center_freq;
+	new_chandef->center_freq2 = 0;
+	return 0;
 }
 
 struct cfg80211_bss*
 cfg80211_inform_bss(struct wiphy *wiphy,
-		    struct ieee80211_channel *channel,
+		    struct cfg80211_chan_def *chandef,
 		    const u8 *bssid, u64 tsf, u16 capability,
 		    u16 beacon_interval, const u8 *ie, size_t ielen,
 		    s32 signal, gfp_t gfp)
 {
 	struct cfg80211_bss_ies *ies;
 	struct cfg80211_internal_bss tmp = {}, *res;
+	struct cfg80211_chan_def new_chandef;
 
 	if (WARN_ON(!wiphy))
 		return NULL;
@@ -883,12 +927,11 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 			(signal < 0 || signal > 100)))
 		return NULL;
 
-	channel = cfg80211_get_bss_channel(wiphy, ie, ielen, channel);
-	if (!channel)
+	if (!cfg80211_get_bss_chandef(wiphy, ie, ielen, &new_chandef, chandef))
 		return NULL;
 
 	memcpy(tmp.pub.bssid, bssid, ETH_ALEN);
-	tmp.pub.channel = channel;
+	tmp.pub.chandef = new_chandef;
 	tmp.pub.signal = signal;
 	tmp.pub.beacon_interval = beacon_interval;
 	tmp.pub.capability = capability;
@@ -915,7 +958,7 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 		return NULL;
 
 	if (res->pub.capability & WLAN_CAPABILITY_ESS)
-		regulatory_hint_found_beacon(wiphy, channel, gfp);
+		regulatory_hint_found_beacon(wiphy, new_chandef.chan, gfp);
 
 	trace_cfg80211_return_bss(&res->pub);
 	/* cfg80211_bss_update gives us a referenced result */
@@ -925,19 +968,20 @@ EXPORT_SYMBOL(cfg80211_inform_bss);
 
 struct cfg80211_bss *
 cfg80211_inform_bss_frame(struct wiphy *wiphy,
-			  struct ieee80211_channel *channel,
+			  struct cfg80211_chan_def *chandef,
 			  struct ieee80211_mgmt *mgmt, size_t len,
 			  s32 signal, gfp_t gfp)
 {
 	struct cfg80211_internal_bss tmp = {}, *res;
 	struct cfg80211_bss_ies *ies;
+	struct cfg80211_chan_def new_chandef;
 	size_t ielen = len - offsetof(struct ieee80211_mgmt,
 				      u.probe_resp.variable);
 
 	BUILD_BUG_ON(offsetof(struct ieee80211_mgmt, u.probe_resp.variable) !=
 			offsetof(struct ieee80211_mgmt, u.beacon.variable));
 
-	trace_cfg80211_inform_bss_frame(wiphy, channel, mgmt, len, signal);
+	trace_cfg80211_inform_bss_frame(wiphy, chandef, mgmt, len, signal);
 
 	if (WARN_ON(!mgmt))
 		return NULL;
@@ -952,9 +996,8 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 	if (WARN_ON(len < offsetof(struct ieee80211_mgmt, u.probe_resp.variable)))
 		return NULL;
 
-	channel = cfg80211_get_bss_channel(wiphy, mgmt->u.beacon.variable,
-					   ielen, channel);
-	if (!channel)
+	if (!cfg80211_get_bss_chandef(wiphy, mgmt->u.beacon.variable,
+				      ielen, &new_chandef, chandef))
 		return NULL;
 
 	ies = kmalloc(sizeof(*ies) + ielen, gfp);
@@ -971,7 +1014,7 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 	rcu_assign_pointer(tmp.pub.ies, ies);
 	
 	memcpy(tmp.pub.bssid, mgmt->bssid, ETH_ALEN);
-	tmp.pub.channel = channel;
+	tmp.pub.chandef = new_chandef;
 	tmp.pub.signal = signal;
 	tmp.pub.beacon_interval = le16_to_cpu(mgmt->u.probe_resp.beacon_int);
 	tmp.pub.capability = le16_to_cpu(mgmt->u.probe_resp.capab_info);
@@ -981,7 +1024,7 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 		return NULL;
 
 	if (res->pub.capability & WLAN_CAPABILITY_ESS)
-		regulatory_hint_found_beacon(wiphy, channel, gfp);
+		regulatory_hint_found_beacon(wiphy, new_chandef.chan, gfp);
 
 	trace_cfg80211_return_bss(&res->pub);
 	/* cfg80211_bss_update gives us a referenced result */
@@ -1241,6 +1284,7 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 	      char *end_buf)
 {
 	const struct cfg80211_bss_ies *ies;
+	int freq;
 	struct iw_event iwe;
 	const u8 *ie;
 	u8 *buf, *cfg, *p;
@@ -1256,14 +1300,15 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWFREQ;
-	iwe.u.freq.m = ieee80211_frequency_to_channel(bss->pub.channel->center_freq);
+	freq = bss->pub.chandef.chan->center_freq;
+	iwe.u.freq.m = ieee80211_frequency_to_channel(freq);
 	iwe.u.freq.e = 0;
 	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
 					  IW_EV_FREQ_LEN);
 
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWFREQ;
-	iwe.u.freq.m = bss->pub.channel->center_freq;
+	iwe.u.freq.m = bss->pub.chandef.chan->center_freq;
 	iwe.u.freq.e = 6;
 	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
 					  IW_EV_FREQ_LEN);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index ae7e2cb..112c024 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -139,6 +139,7 @@ static int cfg80211_conn_do_work(struct wireless_dev *wdev)
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 	struct cfg80211_connect_params *params;
 	struct cfg80211_assoc_request req = {};
+	struct cfg80211_chan_def chandef;
 	int err;
 
 	ASSERT_WDEV_LOCK(wdev);
@@ -157,8 +158,13 @@ static int cfg80211_conn_do_work(struct wireless_dev *wdev)
 	case CFG80211_CONN_AUTHENTICATE_NEXT:
 		BUG_ON(!rdev->ops->auth);
 		wdev->conn->state = CFG80211_CONN_AUTHENTICATING;
+		/* cfg80211_connect_params may hold an chandef in the future
+		 * to allow to connect to 5 or 10 MHz networks.
+		 */
+		cfg80211_chandef_create(&chandef, params->channel,
+					NL80211_CHAN_NO_HT);
 		return cfg80211_mlme_auth(rdev, wdev->netdev,
-					  params->channel, params->auth_type,
+					  &chandef, params->auth_type,
 					  params->bssid,
 					  params->ssid, params->ssid_len,
 					  NULL, 0,
@@ -242,6 +248,7 @@ void cfg80211_conn_work(struct work_struct *work)
 static struct cfg80211_bss *cfg80211_get_conn_bss(struct wireless_dev *wdev)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_chan_def chandef;
 	struct cfg80211_bss *bss;
 	u16 capa = WLAN_CAPABILITY_ESS;
 
@@ -250,7 +257,9 @@ static struct cfg80211_bss *cfg80211_get_conn_bss(struct wireless_dev *wdev)
 	if (wdev->conn->params.privacy)
 		capa |= WLAN_CAPABILITY_PRIVACY;
 
-	bss = cfg80211_get_bss(wdev->wiphy, wdev->conn->params.channel,
+	cfg80211_chandef_create(&chandef, wdev->conn->params.channel,
+				NL80211_CHAN_NO_HT);
+	bss = cfg80211_get_bss(wdev->wiphy, &chandef,
 			       wdev->conn->params.bssid,
 			       wdev->conn->params.ssid,
 			       wdev->conn->params.ssid_len,
@@ -261,7 +270,7 @@ static struct cfg80211_bss *cfg80211_get_conn_bss(struct wireless_dev *wdev)
 
 	memcpy(wdev->conn->bssid, bss->bssid, ETH_ALEN);
 	wdev->conn->params.bssid = wdev->conn->bssid;
-	wdev->conn->params.channel = bss->channel;
+	wdev->conn->params.channel = bss->chandef.chan;
 	wdev->conn->state = CFG80211_CONN_AUTHENTICATE_NEXT;
 	schedule_work(&rdev->conn_work);
 
@@ -650,7 +659,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 	 * - country_ie + 2, the start of the country ie data, and
 	 * - and country_ie[1] which is the IE length
 	 */
-	regulatory_hint_11d(wdev->wiphy, bss->channel->band,
+	regulatory_hint_11d(wdev->wiphy, bss->chandef.chan->band,
 			    country_ie + 2, country_ie[1]);
 	kfree(country_ie);
 }
@@ -754,9 +763,11 @@ void cfg80211_roamed(struct net_device *dev,
 		     const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_chan_def chandef;
 	struct cfg80211_bss *bss;
 
-	bss = cfg80211_get_bss(wdev->wiphy, channel, bssid, wdev->ssid,
+	cfg80211_chandef_create(&chandef, channel, NL80211_CHAN_NO_HT);
+	bss = cfg80211_get_bss(wdev->wiphy, &chandef, bssid, wdev->ssid,
 			       wdev->ssid_len, WLAN_CAPABILITY_ESS,
 			       WLAN_CAPABILITY_ESS);
 	if (WARN_ON(!bss))
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index e1534baf..e06d313 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1900,15 +1900,15 @@ TRACE_EVENT(cfg80211_send_rx_assoc,
 	TP_STRUCT__entry(
 		NETDEV_ENTRY
 		MAC_ENTRY(bssid)
-		CHAN_ENTRY
+		CHAN_DEF_ENTRY
 	),
 	TP_fast_assign(
 		NETDEV_ASSIGN;
 		MAC_ASSIGN(bssid, bss->bssid);
-		CHAN_ASSIGN(bss->channel);
+		CHAN_DEF_ASSIGN(&bss->chandef);
 	),
-	TP_printk(NETDEV_PR_FMT ", " MAC_PR_FMT ", " CHAN_PR_FMT,
-		  NETDEV_PR_ARG, MAC_PR_ARG(bssid), CHAN_PR_ARG)
+	TP_printk(NETDEV_PR_FMT ", " MAC_PR_FMT ", " CHAN_DEF_PR_FMT,
+		  NETDEV_PR_ARG, MAC_PR_ARG(bssid), CHAN_DEF_PR_ARG)
 );
 
 DECLARE_EVENT_CLASS(netdev_frame_event,
@@ -2365,13 +2365,13 @@ DEFINE_EVENT(wiphy_only_evt, cfg80211_sched_scan_stopped,
 );
 
 TRACE_EVENT(cfg80211_get_bss,
-	TP_PROTO(struct wiphy *wiphy, struct ieee80211_channel *channel,
+	TP_PROTO(struct wiphy *wiphy, struct cfg80211_chan_def *chandef,
 		 const u8 *bssid, const u8 *ssid, size_t ssid_len,
 		 u16 capa_mask, u16 capa_val),
-	TP_ARGS(wiphy, channel, bssid, ssid, ssid_len, capa_mask, capa_val),
+	TP_ARGS(wiphy, chandef, bssid, ssid, ssid_len, capa_mask, capa_val),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
-		CHAN_ENTRY
+		CHAN_DEF_ENTRY
 		MAC_ENTRY(bssid)
 		__dynamic_array(u8, ssid, ssid_len)
 		__field(u16, capa_mask)
@@ -2379,38 +2379,39 @@ TRACE_EVENT(cfg80211_get_bss,
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
-		CHAN_ASSIGN(channel);
+		CHAN_DEF_ASSIGN(chandef);
 		MAC_ASSIGN(bssid, bssid);
 		memcpy(__get_dynamic_array(ssid), ssid, ssid_len);
 		__entry->capa_mask = capa_mask;
 		__entry->capa_val = capa_val;
 	),
-	TP_printk(WIPHY_PR_FMT ", " CHAN_PR_FMT ", " MAC_PR_FMT ", buf: %#.2x, "
-		  "capa_mask: %d, capa_val: %u", WIPHY_PR_ARG, CHAN_PR_ARG,
-		  MAC_PR_ARG(bssid), ((u8 *)__get_dynamic_array(ssid))[0],
+	TP_printk(WIPHY_PR_FMT ", " CHAN_DEF_PR_FMT ", " MAC_PR_FMT
+		  ", buf: %#.2x, capa_mask: %d, capa_val: %u", WIPHY_PR_ARG,
+		  CHAN_DEF_PR_ARG, MAC_PR_ARG(bssid),
+		  ((u8 *)__get_dynamic_array(ssid))[0],
 		  __entry->capa_mask, __entry->capa_val)
 );
 
 TRACE_EVENT(cfg80211_inform_bss_frame,
-	TP_PROTO(struct wiphy *wiphy, struct ieee80211_channel *channel,
+	TP_PROTO(struct wiphy *wiphy, struct cfg80211_chan_def *chandef,
 		 struct ieee80211_mgmt *mgmt, size_t len,
 		 s32 signal),
-	TP_ARGS(wiphy, channel, mgmt, len, signal),
+	TP_ARGS(wiphy, chandef, mgmt, len, signal),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
-		CHAN_ENTRY
+		CHAN_DEF_ENTRY
 		__dynamic_array(u8, mgmt, len)
 		__field(s32, signal)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
-		CHAN_ASSIGN(channel);
+		CHAN_DEF_ASSIGN(chandef);
 		if (mgmt)
 			memcpy(__get_dynamic_array(mgmt), mgmt, len);
 		__entry->signal = signal;
 	),
-	TP_printk(WIPHY_PR_FMT ", " CHAN_PR_FMT "signal: %d",
-		  WIPHY_PR_ARG, CHAN_PR_ARG, __entry->signal)
+	TP_printk(WIPHY_PR_FMT ", " CHAN_DEF_PR_FMT "signal: %d",
+		  WIPHY_PR_ARG, CHAN_DEF_PR_ARG, __entry->signal)
 );
 
 DECLARE_EVENT_CLASS(cfg80211_bss_evt,
@@ -2418,13 +2419,14 @@ DECLARE_EVENT_CLASS(cfg80211_bss_evt,
 	TP_ARGS(pub),
 	TP_STRUCT__entry(
 		MAC_ENTRY(bssid)
-		CHAN_ENTRY
+		CHAN_DEF_ENTRY
 	),
 	TP_fast_assign(
 		MAC_ASSIGN(bssid, pub->bssid);
-		CHAN_ASSIGN(pub->channel);
+		CHAN_DEF_ASSIGN(&pub->chandef);
 	),
-	TP_printk(MAC_PR_FMT ", " CHAN_PR_FMT, MAC_PR_ARG(bssid), CHAN_PR_ARG)
+	TP_printk(MAC_PR_FMT ", " CHAN_DEF_PR_FMT, MAC_PR_ARG(bssid),
+		  CHAN_DEF_PR_ARG)
 );
 
 DEFINE_EVENT(cfg80211_bss_evt, cfg80211_return_bss,
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index 14c9a25..bca1c26 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -149,7 +149,7 @@ int cfg80211_mgd_wext_giwfreq(struct net_device *dev,
 
 	wdev_lock(wdev);
 	if (wdev->current_bss)
-		chan = wdev->current_bss->pub.channel;
+		chan = wdev->current_bss->pub.chandef.chan;
 	else if (wdev->wext.connect.channel)
 		chan = wdev->wext.connect.channel;
 	wdev_unlock(wdev);
-- 
1.7.10.4

