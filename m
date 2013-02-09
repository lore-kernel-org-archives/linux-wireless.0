Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33304 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947344Ab3BIAfd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 19:35:33 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] cfg80211/mac80211: allow changing AP channel bandwidth while active
Date: Sat,  9 Feb 2013 01:35:26 +0100
Message-Id: <1360370126-20665-1-git-send-email-johannes@sipsolutions.net> (sfid-20130209_013537_234267_516E9FB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

An HT/VHT AP is allowed to change its bandwidth while operating,
create a new capability and cfg80211 API to allow this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       |  3 +++
 include/uapi/linux/nl80211.h |  3 +++
 net/mac80211/cfg.c           | 18 ++++++++++++++++++
 net/wireless/ap.c            | 10 ++++++++++
 net/wireless/core.c          |  6 ++++++
 net/wireless/core.h          |  3 +++
 net/wireless/nl80211.c       | 14 ++++++++++----
 7 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1cc4c36..bc670b2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1754,6 +1754,7 @@ struct cfg80211_gtk_rekey_data {
  * @start_ap: Start acting in AP mode defined by the parameters.
  * @change_beacon: Change the beacon parameters for an access point mode
  *	interface. This should reject the call when AP mode wasn't started.
+ * @change_bandwidth: Change the AP's operating bandwidth.
  * @stop_ap: Stop being an AP, including stopping beaconing.
  *
  * @add_station: Add a new station.
@@ -1957,6 +1958,8 @@ struct cfg80211_ops {
 			    struct cfg80211_ap_settings *settings);
 	int	(*change_beacon)(struct wiphy *wiphy, struct net_device *dev,
 				 struct cfg80211_beacon_data *info);
+	int	(*change_bandwidth)(struct wiphy *wiphy, struct net_device *dev,
+				    const struct cfg80211_chan_def *chandef);
 	int	(*stop_ap)(struct wiphy *wiphy, struct net_device *dev);
 
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 122e9fd..1ed7e1c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3412,6 +3412,8 @@ enum nl80211_ap_sme_features {
  *	stations the authenticated/associated bits have to be set in the mask.
  * @NL80211_FEATURE_ADVERTISE_CHAN_LIMITS: cfg80211 advertises channel limits
  *	(HT40, VHT 80/160 MHz) if this flag is set
+ * @NL80211_FEATURE_HAVE_AP_BW_SWITCH: AP mode can switch bandwidth (by using
+ *	the normal set channel command)
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3429,6 +3431,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_P2P_GO_OPPPS			= 1 << 12,
 	NL80211_FEATURE_FULL_AP_CLIENT_STATE		= 1 << 13,
 	NL80211_FEATURE_ADVERTISE_CHAN_LIMITS		= 1 << 14,
+	NL80211_FEATURE_HAVE_AP_BW_SWITCH		= 1 << 15,
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 68eca17..d7fa932 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1005,6 +1005,23 @@ static int ieee80211_change_beacon(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static int ieee80211_change_bandwidth(struct wiphy *wiphy,
+				      struct net_device *dev,
+				      const struct cfg80211_chan_def *chandef)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	int ret;
+	u32 changed;
+
+	ret = ieee80211_vif_change_bandwidth(sdata, chandef, &changed);
+	if (ret)
+		return ret;
+
+	ieee80211_bss_info_change_notify(sdata, changed);
+
+	return 0;
+}
+
 static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -3283,6 +3300,7 @@ struct cfg80211_ops mac80211_config_ops = {
 	.set_default_mgmt_key = ieee80211_config_default_mgmt_key,
 	.start_ap = ieee80211_start_ap,
 	.change_beacon = ieee80211_change_beacon,
+	.change_bandwidth = ieee80211_change_bandwidth,
 	.stop_ap = ieee80211_stop_ap,
 	.add_station = ieee80211_add_station,
 	.del_station = ieee80211_del_station,
diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index a4a14e8..aca91c6 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -108,3 +108,13 @@ bool cfg80211_rx_unexpected_4addr_frame(struct net_device *dev,
 	return ret;
 }
 EXPORT_SYMBOL(cfg80211_rx_unexpected_4addr_frame);
+
+int cfg80211_change_ap_bandwidth(struct cfg80211_registered_device *rdev,
+				 struct net_device *dev,
+				 struct cfg80211_chan_def *chandef)
+{
+	/* XXX tracing */
+	if (!rdev->ops->change_bandwidth)
+		return -EBUSY;
+	return rdev->ops->change_bandwidth(&rdev->wiphy, dev, chandef);
+}
diff --git a/net/wireless/core.c b/net/wireless/core.c
index d915376..8d57a6f 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -546,6 +546,12 @@ int wiphy_register(struct wiphy *wiphy)
 		have_band = true;
 	}
 
+	if (rdev->ops->change_bandwidth &&
+	    wiphy->interface_modes & BIT(NL80211_IFTYPE_AP))
+		wiphy->features |= NL80211_FEATURE_HAVE_AP_BW_SWITCH;
+	else
+		wiphy->features &= ~NL80211_FEATURE_HAVE_AP_BW_SWITCH;
+
 	if (!have_band) {
 		WARN_ON(1);
 		return -EINVAL;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 949c957..2dd6d34 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -307,6 +307,9 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
 /* AP */
 int cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 		     struct net_device *dev);
+int cfg80211_change_ap_bandwidth(struct cfg80211_registered_device *rdev,
+				 struct net_device *dev,
+				 struct cfg80211_chan_def *chandef);
 
 /* MLME */
 int __cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cae3968..b19c822 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1538,14 +1538,20 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 	switch (iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
-		if (wdev->beacon_interval) {
-			result = -EBUSY;
-			break;
-		}
 		if (!cfg80211_reg_can_beacon(&rdev->wiphy, &chandef)) {
 			result = -EINVAL;
 			break;
 		}
+		if (wdev->beacon_interval) {
+			if (wdev->channel != chandef.chan) {
+				result = -EBUSY;
+				break;
+			}
+			result = cfg80211_change_ap_bandwidth(rdev,
+							      wdev->netdev,
+							      &chandef);
+			break;
+		}
 		wdev->preset_chandef = chandef;
 		result = 0;
 		break;
-- 
1.8.0

