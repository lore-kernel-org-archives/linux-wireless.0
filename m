Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48155 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbaHNLIH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2014 07:08:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>,
	Eliad Peller <eliad@wizery.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 2/2] cfg80211: allow passing frame type to cfg80211_inform_bss()
Date: Thu, 14 Aug 2014 13:07:58 +0200
Message-Id: <1408014478-20401-2-git-send-email-johannes@sipsolutions.net> (sfid-20140814_130812_821869_E6D8A1B7)
In-Reply-To: <1408014478-20401-1-git-send-email-johannes@sipsolutions.net>
References: <1408014478-20401-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When using the cfg80211_inform_bss[_width]() functions drivers
cannot currently indicate whether the data was received in a
beacon or probe response. Fix that by passing a new enum that
indicates such (or unknown).

For good measure, use it in ath6kl.

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com> [ath6kl]
Acked-by: Arend van Spriel <arend@broadcom.com> [brcmfmac]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  1 +
 drivers/net/wireless/ath/ath6kl/wmi.c              | 43 +++++-----------------
 drivers/net/wireless/ath/wil6210/wmi.c             |  2 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  | 18 ++++++---
 drivers/net/wireless/libertas/cfg.c                |  2 +
 drivers/net/wireless/mwifiex/cfg80211.c            |  1 +
 drivers/net/wireless/mwifiex/scan.c                |  3 +-
 drivers/net/wireless/orinoco/scan.c                | 14 ++++---
 drivers/net/wireless/rndis_wlan.c                  | 14 ++++---
 drivers/staging/wlan-ng/cfg80211.c                 |  1 +
 include/net/cfg80211.h                             | 20 +++++++++-
 net/wireless/scan.c                                | 15 +++++++-
 12 files changed, 76 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 0e26f4a34fda..357515b1c882 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -717,6 +717,7 @@ ath6kl_add_bss_if_needed(struct ath6kl_vif *vif,
 		memcpy(ie + 2, vif->ssid, vif->ssid_len);
 		memcpy(ie + 2 + vif->ssid_len, beacon_ie, beacon_ie_len);
 		bss = cfg80211_inform_bss(ar->wiphy, chan,
+					  CFG80211_BSS_FTYPE_UNKNOWN,
 					  bssid, 0, cap_val, 100,
 					  ie, 2 + vif->ssid_len + beacon_ie_len,
 					  0, GFP_KERNEL);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index eca3014e9544..929ba5d4bb4b 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1043,7 +1043,6 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len,
 	u8 *buf;
 	struct ieee80211_channel *channel;
 	struct ath6kl *ar = wmi->parent_dev;
-	struct ieee80211_mgmt *mgmt;
 	struct cfg80211_bss *bss;
 
 	if (len <= sizeof(struct wmi_bss_info_hdr2))
@@ -1089,39 +1088,15 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len,
 		}
 	}
 
-	/*
-	 * In theory, use of cfg80211_inform_bss() would be more natural here
-	 * since we do not have the full frame. However, at least for now,
-	 * cfg80211 can only distinguish Beacon and Probe Response frames from
-	 * each other when using cfg80211_inform_bss_frame(), so let's build a
-	 * fake IEEE 802.11 header to be able to take benefit of this.
-	 */
-	mgmt = kmalloc(24 + len, GFP_ATOMIC);
-	if (mgmt == NULL)
-		return -EINVAL;
-
-	if (bih->frame_type == BEACON_FTYPE) {
-		mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-						  IEEE80211_STYPE_BEACON);
-		memset(mgmt->da, 0xff, ETH_ALEN);
-	} else {
-		struct net_device *dev = vif->ndev;
-
-		mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-						  IEEE80211_STYPE_PROBE_RESP);
-		memcpy(mgmt->da, dev->dev_addr, ETH_ALEN);
-	}
-	mgmt->duration = cpu_to_le16(0);
-	memcpy(mgmt->sa, bih->bssid, ETH_ALEN);
-	memcpy(mgmt->bssid, bih->bssid, ETH_ALEN);
-	mgmt->seq_ctrl = cpu_to_le16(0);
-
-	memcpy(&mgmt->u.beacon, buf, len);
-
-	bss = cfg80211_inform_bss_frame(ar->wiphy, channel, mgmt,
-					24 + len, (bih->snr - 95) * 100,
-					GFP_ATOMIC);
-	kfree(mgmt);
+	bss = cfg80211_inform_bss(ar->wiphy, channel,
+				  bih->frame_type == BEACON_FTYPE ?
+					CFG80211_BSS_FTYPE_BEACON :
+					CFG80211_BSS_FTYPE_PRESP,
+				  bih->bssid, get_unaligned_le64((__le64 *)buf),
+				  get_unaligned_le16(((__le16 *)buf) + 5),
+				  get_unaligned_le16(((__le16 *)buf) + 4),
+				  buf + 8 + 2 + 2, len - 8 - 2 - 2,
+				  (bih->snr - 95) * 100, GFP_ATOMIC);
 	if (bss == NULL)
 		return -ENOMEM;
 	cfg80211_put_bss(ar->wiphy, bss);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 16787e9124a2..bc4932142f63 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -335,7 +335,7 @@ static void wmi_evt_rx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
 				    rx_mgmt_frame->bssid);
 			cfg80211_put_bss(wiphy, bss);
 		} else {
-			wil_err(wil, "cfg80211_inform_bss() failed\n");
+			wil_err(wil, "cfg80211_inform_bss_frame() failed\n");
 		}
 	} else {
 		cfg80211_rx_mgmt(wil->wdev, freq, signal,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index d8fa276e368b..9a45ef064dd9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2429,9 +2429,13 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 	brcmf_dbg(CONN, "Beacon interval: %d\n", notify_interval);
 	brcmf_dbg(CONN, "Signal: %d\n", notify_signal);
 
-	bss = cfg80211_inform_bss(wiphy, notify_channel, (const u8 *)bi->BSSID,
-		0, notify_capability, notify_interval, notify_ie,
-		notify_ielen, notify_signal, GFP_KERNEL);
+	bss = cfg80211_inform_bss(wiphy, notify_channel,
+				  CFG80211_BSS_FTYPE_UNKNOWN,
+				  (const u8 *)bi->BSSID,
+				  0, notify_capability,
+				  notify_interval, notify_ie,
+				  notify_ielen, notify_signal,
+				  GFP_KERNEL);
 
 	if (!bss)
 		return -ENOMEM;
@@ -2533,9 +2537,11 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_info *cfg,
 	brcmf_dbg(CONN, "beacon interval: %d\n", notify_interval);
 	brcmf_dbg(CONN, "signal: %d\n", notify_signal);
 
-	bss = cfg80211_inform_bss(wiphy, notify_channel, bssid,
-		0, notify_capability, notify_interval,
-		notify_ie, notify_ielen, notify_signal, GFP_KERNEL);
+	bss = cfg80211_inform_bss(wiphy, notify_channel,
+				  CFG80211_BSS_FTYPE_UNKNOWN, bssid, 0,
+				  notify_capability, notify_interval,
+				  notify_ie, notify_ielen, notify_signal,
+				  GFP_KERNEL);
 
 	if (!bss) {
 		err = -ENOMEM;
diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 47a998d8f99e..22884ba7d6cc 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -653,6 +653,7 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
 			if (channel &&
 			    !(channel->flags & IEEE80211_CHAN_DISABLED)) {
 				bss = cfg80211_inform_bss(wiphy, channel,
+					CFG80211_BSS_FTYPE_UNKNOWN,
 					bssid, get_unaligned_le64(tsfdesc),
 					capa, intvl, ie, ielen,
 					LBS_SCAN_RSSI_TO_MBM(rssi),
@@ -1754,6 +1755,7 @@ static void lbs_join_post(struct lbs_private *priv,
 
 	bss = cfg80211_inform_bss(priv->wdev->wiphy,
 				  params->chandef.chan,
+				  CFG80211_BSS_FTYPE_UNKNOWN,
 				  bssid,
 				  0,
 				  capability,
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 149d2e693bdd..00e4d7a3281f 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1588,6 +1588,7 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 						       band));
 
 	bss = cfg80211_inform_bss(priv->wdev->wiphy, chan,
+				  CFG80211_BSS_FTYPE_UNKNOWN,
 				  bss_info.bssid, 0, WLAN_CAPABILITY_IBSS,
 				  0, ie_buf, ie_len, 0, GFP_KERNEL);
 	cfg80211_put_bss(priv->wdev->wiphy, bss);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 45c5b3450cf5..f0f3257fe968 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1719,7 +1719,8 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 
 		if (chan && !(chan->flags & IEEE80211_CHAN_DISABLED)) {
 			bss = cfg80211_inform_bss(priv->wdev->wiphy,
-					    chan, bssid, timestamp,
+					    chan, CFG80211_BSS_FTYPE_UNKNOWN,
+					    bssid, timestamp,
 					    cap_info_bitmap, beacon_period,
 					    ie_buf, ie_len, rssi, GFP_KERNEL);
 			bss_priv = (struct mwifiex_bss_priv *)bss->priv;
diff --git a/drivers/net/wireless/orinoco/scan.c b/drivers/net/wireless/orinoco/scan.c
index e175b9b8561b..2c66166add70 100644
--- a/drivers/net/wireless/orinoco/scan.c
+++ b/drivers/net/wireless/orinoco/scan.c
@@ -123,9 +123,10 @@ static void orinoco_add_hostscan_result(struct orinoco_private *priv,
 	beacon_interval = le16_to_cpu(bss->a.beacon_interv);
 	signal = SIGNAL_TO_MBM(le16_to_cpu(bss->a.level));
 
-	cbss = cfg80211_inform_bss(wiphy, channel, bss->a.bssid, timestamp,
-				   capability, beacon_interval, ie_buf, ie_len,
-				   signal, GFP_KERNEL);
+	cbss = cfg80211_inform_bss(wiphy, channel, CFG80211_BSS_FTYPE_UNKNOWN,
+				   bss->a.bssid, timestamp, capability,
+				   beacon_interval, ie_buf, ie_len, signal,
+				   GFP_KERNEL);
 	cfg80211_put_bss(wiphy, cbss);
 }
 
@@ -156,9 +157,10 @@ void orinoco_add_extscan_result(struct orinoco_private *priv,
 	ie = bss->data;
 	signal = SIGNAL_TO_MBM(bss->level);
 
-	cbss = cfg80211_inform_bss(wiphy, channel, bss->bssid, timestamp,
-				   capability, beacon_interval, ie, ie_len,
-				   signal, GFP_KERNEL);
+	cbss = cfg80211_inform_bss(wiphy, channel, CFG80211_BSS_FTYPE_UNKNOWN,
+				   bss->bssid, timestamp, capability,
+				   beacon_interval, ie, ie_len, signal,
+				   GFP_KERNEL);
 	cfg80211_put_bss(wiphy, cbss);
 }
 
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index d2a9a08210be..1a4facd1fbf3 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2022,9 +2022,10 @@ static bool rndis_bss_info_update(struct usbnet *usbdev,
 	capability = le16_to_cpu(fixed->capabilities);
 	beacon_interval = le16_to_cpu(fixed->beacon_interval);
 
-	bss = cfg80211_inform_bss(priv->wdev.wiphy, channel, bssid->mac,
-		timestamp, capability, beacon_interval, ie, ie_len, signal,
-		GFP_KERNEL);
+	bss = cfg80211_inform_bss(priv->wdev.wiphy, channel,
+				  CFG80211_BSS_FTYPE_UNKNOWN, bssid->mac,
+				  timestamp, capability, beacon_interval,
+				  ie, ie_len, signal, GFP_KERNEL);
 	cfg80211_put_bss(priv->wdev.wiphy, bss);
 
 	return (bss != NULL);
@@ -2711,9 +2712,10 @@ static void rndis_wlan_craft_connected_bss(struct usbnet *usbdev, u8 *bssid,
 		bssid, (u32)timestamp, capability, beacon_period, ie_len,
 		ssid.essid, signal);
 
-	bss = cfg80211_inform_bss(priv->wdev.wiphy, channel, bssid,
-		timestamp, capability, beacon_period, ie_buf, ie_len,
-		signal, GFP_KERNEL);
+	bss = cfg80211_inform_bss(priv->wdev.wiphy, channel,
+				  CFG80211_BSS_FTYPE_UNKNOWN, bssid,
+				  timestamp, capability, beacon_period,
+				  ie_buf, ie_len, signal, GFP_KERNEL);
 	cfg80211_put_bss(priv->wdev.wiphy, bss);
 }
 
diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index 723319ee08f3..955ec2e6a95c 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -420,6 +420,7 @@ static int prism2_scan(struct wiphy *wiphy,
 						      IEEE80211_BAND_2GHZ);
 		bss = cfg80211_inform_bss(wiphy,
 			ieee80211_get_channel(wiphy, freq),
+			CFG80211_BSS_FTYPE_UNKNOWN,
 			(const u8 *) &(msg2.bssid.data.data),
 			msg2.timestamp.data, msg2.capinfo.data,
 			msg2.beaconperiod.data,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 77b85a89abca..ab21299c8f4d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3767,11 +3767,25 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 }
 
 /**
- * cfg80211_inform_bss - inform cfg80211 of a new BSS
+ * enum cfg80211_bss_frame_type - frame type that the BSS data came from
+ * @CFG80211_BSS_FTYPE_UNKNOWN: driver doesn't know whether the data is
+ *	from a beacon or probe response
+ * @CFG80211_BSS_FTYPE_BEACON: data comes from a beacon
+ * @CFG80211_BSS_FTYPE_PRESP: data comes from a probe response
+ */
+enum cfg80211_bss_frame_type {
+	CFG80211_BSS_FTYPE_UNKNOWN,
+	CFG80211_BSS_FTYPE_BEACON,
+	CFG80211_BSS_FTYPE_PRESP,
+};
+
+/**
+ * cfg80211_inform_bss_width - inform cfg80211 of a new BSS
  *
  * @wiphy: the wiphy reporting the BSS
  * @rx_channel: The channel the frame was received on
  * @scan_width: width of the control channel
+ * @ftype: frame type (if known)
  * @bssid: the BSSID of the BSS
  * @tsf: the TSF sent by the peer in the beacon/probe response (or 0)
  * @capability: the capability field sent by the peer
@@ -3791,6 +3805,7 @@ struct cfg80211_bss * __must_check
 cfg80211_inform_bss_width(struct wiphy *wiphy,
 			  struct ieee80211_channel *rx_channel,
 			  enum nl80211_bss_scan_width scan_width,
+			  enum cfg80211_bss_frame_type ftype,
 			  const u8 *bssid, u64 tsf, u16 capability,
 			  u16 beacon_interval, const u8 *ie, size_t ielen,
 			  s32 signal, gfp_t gfp);
@@ -3798,12 +3813,13 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
 static inline struct cfg80211_bss * __must_check
 cfg80211_inform_bss(struct wiphy *wiphy,
 		    struct ieee80211_channel *rx_channel,
+		    enum cfg80211_bss_frame_type ftype,
 		    const u8 *bssid, u64 tsf, u16 capability,
 		    u16 beacon_interval, const u8 *ie, size_t ielen,
 		    s32 signal, gfp_t gfp)
 {
 	return cfg80211_inform_bss_width(wiphy, rx_channel,
-					 NL80211_BSS_CHAN_WIDTH_20,
+					 NL80211_BSS_CHAN_WIDTH_20, ftype,
 					 bssid, tsf, capability,
 					 beacon_interval, ie, ielen, signal,
 					 gfp);
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 9b68ff01cd7a..e42666bbd949 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -884,6 +884,7 @@ struct cfg80211_bss*
 cfg80211_inform_bss_width(struct wiphy *wiphy,
 			  struct ieee80211_channel *rx_channel,
 			  enum nl80211_bss_scan_width scan_width,
+			  enum cfg80211_bss_frame_type ftype,
 			  const u8 *bssid, u64 tsf, u16 capability,
 			  u16 beacon_interval, const u8 *ie, size_t ielen,
 			  s32 signal, gfp_t gfp)
@@ -911,7 +912,7 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
 	tmp.pub.beacon_interval = beacon_interval;
 	tmp.pub.capability = capability;
 	/*
-	 * Since we do not know here whether the IEs are from a Beacon or Probe
+	 * If we do not know here whether the IEs are from a Beacon or Probe
 	 * Response frame, we need to pick one of the options and only use it
 	 * with the driver that does not provide the full Beacon/Probe Response
 	 * frame. Use Beacon frame pointer to avoid indicating that this should
@@ -926,7 +927,17 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
 	ies->from_beacon = false;
 	memcpy(ies->data, ie, ielen);
 
-	rcu_assign_pointer(tmp.pub.beacon_ies, ies);
+	switch (ftype) {
+	case CFG80211_BSS_FTYPE_BEACON:
+		ies->from_beacon = true;
+		/* fall through to assign */
+	case CFG80211_BSS_FTYPE_UNKNOWN:
+		rcu_assign_pointer(tmp.pub.beacon_ies, ies);
+		break;
+	case CFG80211_BSS_FTYPE_PRESP:
+		rcu_assign_pointer(tmp.pub.proberesp_ies, ies);
+		break;
+	}
 	rcu_assign_pointer(tmp.pub.ies, ies);
 
 	signal_valid = abs(rx_channel->center_freq - channel->center_freq) <=
-- 
2.0.0

