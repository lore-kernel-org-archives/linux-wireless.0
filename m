Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31846 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757309AbaCDOwv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 09:52:51 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/2] cfg80211/mac80211: ignore signal if the frame was heard on wrong channel
Date: Tue,  4 Mar 2014 16:50:13 +0200
Message-Id: <1393944614-4465-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140304_155256_078713_174E11E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2.4Ghz band, the channels overlap since the delta
between different channels is 5Mhz while the width of the
receiver is 20Mhz (at least).

This means that we can hear beacons or probe responses from
adjacent channels. These frames will have a significant
lower RSSI which will feed all kinds of logic with inaccurate
data. An obvious example is the roaming algorithm that will
think our AP is getting weak and will try to move to another
AP.

In order to avoid this, update the signal only if the frame
has been heard on the same channel as the one advertised by
the AP in its DS / HT IEs.
We refrain from updating the values only if the AP is
already in the BSS list so that we will still have a valid
(but inaccurate) value if the AP was heard on an adjacent
channel only.

To achieve this, stop taking the channel from DS / HT IEs
in mac80211. The DS / HT IEs is taken into account to
discard the frame if it was received on a disabled channel.
This can happen due to the same phenomenon: the frame is
sent on channel 12, but heard on channel 11 while channel
12 can be disabled on certain devices. Since this check
is done in cfg80211, stop even checking this in mac80211.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/cfg80211.h | 16 ++++++++--------
 net/mac80211/ibss.c    | 12 ++----------
 net/mac80211/mlme.c    | 12 ++----------
 net/wireless/scan.c    | 30 +++++++++++++++++++++---------
 4 files changed, 33 insertions(+), 37 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e4a7124..8b4f6b2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3679,7 +3679,7 @@ void cfg80211_sched_scan_stopped(struct wiphy *wiphy);
  * cfg80211_inform_bss_width_frame - inform cfg80211 of a received BSS frame
  *
  * @wiphy: the wiphy reporting the BSS
- * @channel: The channel the frame was received on
+ * @rx_channel: The channel the frame was received on
  * @scan_width: width of the control channel
  * @mgmt: the management frame (probe response or beacon)
  * @len: length of the management frame
@@ -3694,18 +3694,18 @@ void cfg80211_sched_scan_stopped(struct wiphy *wiphy);
  */
 struct cfg80211_bss * __must_check
 cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
-				struct ieee80211_channel *channel,
+				struct ieee80211_channel *rx_channel,
 				enum nl80211_bss_scan_width scan_width,
 				struct ieee80211_mgmt *mgmt, size_t len,
 				s32 signal, gfp_t gfp);
 
 static inline struct cfg80211_bss * __must_check
 cfg80211_inform_bss_frame(struct wiphy *wiphy,
-			  struct ieee80211_channel *channel,
+			  struct ieee80211_channel *rx_channel,
 			  struct ieee80211_mgmt *mgmt, size_t len,
 			  s32 signal, gfp_t gfp)
 {
-	return cfg80211_inform_bss_width_frame(wiphy, channel,
+	return cfg80211_inform_bss_width_frame(wiphy, rx_channel,
 					       NL80211_BSS_CHAN_WIDTH_20,
 					       mgmt, len, signal, gfp);
 }
@@ -3714,7 +3714,7 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
  * cfg80211_inform_bss - inform cfg80211 of a new BSS
  *
  * @wiphy: the wiphy reporting the BSS
- * @channel: The channel the frame was received on
+ * @rx_channel: The channel the frame was received on
  * @scan_width: width of the control channel
  * @bssid: the BSSID of the BSS
  * @tsf: the TSF sent by the peer in the beacon/probe response (or 0)
@@ -3733,7 +3733,7 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
  */
 struct cfg80211_bss * __must_check
 cfg80211_inform_bss_width(struct wiphy *wiphy,
-			  struct ieee80211_channel *channel,
+			  struct ieee80211_channel *rx_channel,
 			  enum nl80211_bss_scan_width scan_width,
 			  const u8 *bssid, u64 tsf, u16 capability,
 			  u16 beacon_interval, const u8 *ie, size_t ielen,
@@ -3741,12 +3741,12 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
 
 static inline struct cfg80211_bss * __must_check
 cfg80211_inform_bss(struct wiphy *wiphy,
-		    struct ieee80211_channel *channel,
+		    struct ieee80211_channel *rx_channel,
 		    const u8 *bssid, u64 tsf, u16 capability,
 		    u16 beacon_interval, const u8 *ie, size_t ielen,
 		    s32 signal, gfp_t gfp)
 {
-	return cfg80211_inform_bss_width(wiphy, channel,
+	return cfg80211_inform_bss_width(wiphy, rx_channel,
 					 NL80211_BSS_CHAN_WIDTH_20,
 					 bssid, tsf, capability,
 					 beacon_interval, ie, ielen, signal,
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 64c7d6d..fc11b69 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -994,7 +994,6 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				  struct ieee802_11_elems *elems)
 {
 	struct ieee80211_local *local = sdata->local;
-	int freq;
 	struct cfg80211_bss *cbss;
 	struct ieee80211_bss *bss;
 	struct sta_info *sta;
@@ -1006,15 +1005,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
 	bool rates_updated = false;
 
-	if (elems->ds_params)
-		freq = ieee80211_channel_to_frequency(elems->ds_params[0],
-						      band);
-	else
-		freq = rx_status->freq;
-
-	channel = ieee80211_get_channel(local->hw.wiphy, freq);
-
-	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
+	channel = ieee80211_get_channel(local->hw.wiphy, rx_status->freq);
+	if (!channel)
 		return;
 
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 94f0af2..e3f71b0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2783,21 +2783,13 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				  struct ieee802_11_elems *elems)
 {
 	struct ieee80211_local *local = sdata->local;
-	int freq;
 	struct ieee80211_bss *bss;
 	struct ieee80211_channel *channel;
 
 	sdata_assert_lock(sdata);
 
-	if (elems->ds_params)
-		freq = ieee80211_channel_to_frequency(elems->ds_params[0],
-						      rx_status->band);
-	else
-		freq = rx_status->freq;
-
-	channel = ieee80211_get_channel(local->hw.wiphy, freq);
-
-	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
+	channel = ieee80211_get_channel(local->hw.wiphy, rx_status->freq);
+	if (!channel)
 		return;
 
 	bss = ieee80211_bss_info_update(local, rx_status, mgmt, len, elems,
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index beb3abd..48e8b5c 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -680,7 +680,8 @@ static bool cfg80211_combine_bsses(struct cfg80211_registered_device *dev,
 /* Returned bss is reference counted and must be cleaned up appropriately. */
 static struct cfg80211_internal_bss *
 cfg80211_bss_update(struct cfg80211_registered_device *dev,
-		    struct cfg80211_internal_bss *tmp)
+		    struct cfg80211_internal_bss *tmp,
+		    bool signal_valid)
 {
 	struct cfg80211_internal_bss *found = NULL;
 
@@ -765,7 +766,12 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 		}
 
 		found->pub.beacon_interval = tmp->pub.beacon_interval;
-		found->pub.signal = tmp->pub.signal;
+		/*
+		 * don't update the signal if beacon was heard on
+		 * adjacent channel.
+		 */
+		if (signal_valid)
+			found->pub.signal = tmp->pub.signal;
 		found->pub.capability = tmp->pub.capability;
 		found->ts = tmp->ts;
 	} else {
@@ -869,13 +875,14 @@ cfg80211_get_bss_channel(struct wiphy *wiphy, const u8 *ie, size_t ielen,
 /* Returned bss is reference counted and must be cleaned up appropriately. */
 struct cfg80211_bss*
 cfg80211_inform_bss_width(struct wiphy *wiphy,
-			  struct ieee80211_channel *channel,
+			  struct ieee80211_channel *rx_channel,
 			  enum nl80211_bss_scan_width scan_width,
 			  const u8 *bssid, u64 tsf, u16 capability,
 			  u16 beacon_interval, const u8 *ie, size_t ielen,
 			  s32 signal, gfp_t gfp)
 {
 	struct cfg80211_bss_ies *ies;
+	struct ieee80211_channel *channel;
 	struct cfg80211_internal_bss tmp = {}, *res;
 
 	if (WARN_ON(!wiphy))
@@ -885,7 +892,7 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
 			(signal < 0 || signal > 100)))
 		return NULL;
 
-	channel = cfg80211_get_bss_channel(wiphy, ie, ielen, channel);
+	channel = cfg80211_get_bss_channel(wiphy, ie, ielen, rx_channel);
 	if (!channel)
 		return NULL;
 
@@ -913,7 +920,8 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
 	rcu_assign_pointer(tmp.pub.beacon_ies, ies);
 	rcu_assign_pointer(tmp.pub.ies, ies);
 
-	res = cfg80211_bss_update(wiphy_to_dev(wiphy), &tmp);
+	res = cfg80211_bss_update(wiphy_to_dev(wiphy), &tmp,
+				  rx_channel == channel);
 	if (!res)
 		return NULL;
 
@@ -929,20 +937,22 @@ EXPORT_SYMBOL(cfg80211_inform_bss_width);
 /* Returned bss is reference counted and must be cleaned up appropriately. */
 struct cfg80211_bss *
 cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
-				struct ieee80211_channel *channel,
+				struct ieee80211_channel *rx_channel,
 				enum nl80211_bss_scan_width scan_width,
 				struct ieee80211_mgmt *mgmt, size_t len,
 				s32 signal, gfp_t gfp)
 {
 	struct cfg80211_internal_bss tmp = {}, *res;
 	struct cfg80211_bss_ies *ies;
+	struct ieee80211_channel *channel;
 	size_t ielen = len - offsetof(struct ieee80211_mgmt,
 				      u.probe_resp.variable);
+	u16 rx_freq;
 
 	BUILD_BUG_ON(offsetof(struct ieee80211_mgmt, u.probe_resp.variable) !=
 			offsetof(struct ieee80211_mgmt, u.beacon.variable));
 
-	trace_cfg80211_inform_bss_width_frame(wiphy, channel, scan_width, mgmt,
+	trace_cfg80211_inform_bss_width_frame(wiphy, rx_channel, scan_width, mgmt,
 					      len, signal);
 
 	if (WARN_ON(!mgmt))
@@ -958,8 +968,9 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
 	if (WARN_ON(len < offsetof(struct ieee80211_mgmt, u.probe_resp.variable)))
 		return NULL;
 
+	rx_freq = channel->center_freq;
 	channel = cfg80211_get_bss_channel(wiphy, mgmt->u.beacon.variable,
-					   ielen, channel);
+					   ielen, rx_channel);
 	if (!channel)
 		return NULL;
 
@@ -983,7 +994,8 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
 	tmp.pub.beacon_interval = le16_to_cpu(mgmt->u.probe_resp.beacon_int);
 	tmp.pub.capability = le16_to_cpu(mgmt->u.probe_resp.capab_info);
 
-	res = cfg80211_bss_update(wiphy_to_dev(wiphy), &tmp);
+	res = cfg80211_bss_update(wiphy_to_dev(wiphy), &tmp,
+				  rx_channel == channel);
 	if (!res)
 		return NULL;
 
-- 
1.8.3.2

