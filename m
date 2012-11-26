Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35921 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab2KZOYv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 09:24:51 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] cfg80211: rework chandef checking and export it
Date: Mon, 26 Nov 2012 15:25:13 +0100
Message-Id: <1353939915-25121-2-git-send-email-johannes@sipsolutions.net> (sfid-20121126_152456_921909_36041945)
In-Reply-To: <1353939915-25121-1-git-send-email-johannes@sipsolutions.net>
References: <1353939915-25121-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some of the chandef checking that we do in cfg80211
to check if a channel is supported or not is also
needed in mac80211, so rework that a bit and export
the functions that are needed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 21 ++++++++++--
 net/wireless/chan.c    | 92 ++++++++++++++++++++++++++++++++++----------------
 net/wireless/core.h    |  6 ----
 net/wireless/nl80211.c | 37 ++------------------
 4 files changed, 84 insertions(+), 72 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e78db2c..a238f41 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -58,6 +58,8 @@
  * structures here describe these capabilities in detail.
  */
 
+struct wiphy;
+
 /*
  * wireless hardware capability structures
  */
@@ -388,6 +390,22 @@ cfg80211_chandef_compatible(const struct cfg80211_chan_def *chandef1,
 			    const struct cfg80211_chan_def *chandef2);
 
 /**
+ * cfg80211_chandef_valid - check if a channel definition is valid
+ * @chandef: the channel definition to check
+ */
+bool cfg80211_chandef_valid(const struct cfg80211_chan_def *chandef);
+
+/**
+ * cfg80211_chandef_usable - check if secondary channels can be used
+ * @wiphy: the wiphy to validate against
+ * @chandef: the channel definition to check
+ * @prohibited_flags: the regulatory chanenl flags that must not be set
+ */
+bool cfg80211_chandef_usable(struct wiphy *wiphy,
+			     const struct cfg80211_chan_def *chandef,
+			     u32 prohibited_flags);
+
+/**
  * enum survey_info_flags - survey information flags
  *
  * @SURVEY_INFO_NOISE_DBM: noise (in dBm) was filled in
@@ -1045,9 +1063,6 @@ struct ieee80211_txq_params {
 	u8 aifs;
 };
 
-/* from net/wireless.h */
-struct wiphy;
-
 /**
  * DOC: Scanning and BSS list handling
  *
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index bf2dfd5..b5f6983 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -44,7 +44,7 @@ void cfg80211_chandef_create(struct cfg80211_chan_def *chandef,
 }
 EXPORT_SYMBOL(cfg80211_chandef_create);
 
-bool cfg80211_chan_def_valid(const struct cfg80211_chan_def *chandef)
+bool cfg80211_chandef_valid(const struct cfg80211_chan_def *chandef)
 {
 	u32 control_freq;
 
@@ -105,6 +105,7 @@ bool cfg80211_chan_def_valid(const struct cfg80211_chan_def *chandef)
 
 	return true;
 }
+EXPORT_SYMBOL(cfg80211_chandef_valid);
 
 static void chandef_primary_freqs(const struct cfg80211_chan_def *c,
 				  int *pri40, int *pri80)
@@ -187,9 +188,9 @@ cfg80211_chandef_compatible(const struct cfg80211_chan_def *c1,
 }
 EXPORT_SYMBOL(cfg80211_chandef_compatible);
 
-bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
-				 u32 center_freq, u32 bandwidth,
-				 u32 prohibited_flags)
+static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
+					u32 center_freq, u32 bandwidth,
+					u32 prohibited_flags)
 {
 	struct ieee80211_channel *c;
 	u32 freq;
@@ -205,55 +206,88 @@ bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
 	return true;
 }
 
-static bool cfg80211_check_beacon_chans(struct wiphy *wiphy,
-					u32 center_freq, u32 bw)
+bool cfg80211_chandef_usable(struct wiphy *wiphy,
+			     const struct cfg80211_chan_def *chandef,
+			     u32 prohibited_flags)
 {
-	return cfg80211_secondary_chans_ok(wiphy, center_freq, bw,
-					   IEEE80211_CHAN_DISABLED |
-					   IEEE80211_CHAN_PASSIVE_SCAN |
-					   IEEE80211_CHAN_NO_IBSS |
-					   IEEE80211_CHAN_RADAR);
-}
+	struct ieee80211_sta_ht_cap *ht_cap;
+	struct ieee80211_sta_vht_cap *vht_cap;
+	u32 width, control_freq;
 
-bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
-			     struct cfg80211_chan_def *chandef)
-{
-	u32 width;
-	bool res;
+	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
+		return false;
 
-	trace_cfg80211_reg_can_beacon(wiphy, chandef);
+	ht_cap = &wiphy->bands[chandef->chan->band]->ht_cap;
+	vht_cap = &wiphy->bands[chandef->chan->band]->vht_cap;
 
-	if (WARN_ON(!cfg80211_chan_def_valid(chandef))) {
-		trace_cfg80211_return_bool(false);
-		return false;
-	}
+	control_freq = chandef->chan->center_freq;
 
 	switch (chandef->width) {
-	case NL80211_CHAN_WIDTH_20_NOHT:
 	case NL80211_CHAN_WIDTH_20:
+		if (!ht_cap->ht_supported)
+			return false;
+	case NL80211_CHAN_WIDTH_20_NOHT:
 		width = 20;
 		break;
 	case NL80211_CHAN_WIDTH_40:
 		width = 40;
+		if (!ht_cap->ht_supported)
+			return false;
+		if (!(ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) ||
+		    ht_cap->cap & IEEE80211_HT_CAP_40MHZ_INTOLERANT)
+			return false;
+		if (chandef->center_freq1 < control_freq &&
+		    chandef->chan->flags & IEEE80211_CHAN_NO_HT40MINUS)
+			return false;
+		if (chandef->center_freq1 > control_freq &&
+		    chandef->chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
+			return false;
 		break;
-	case NL80211_CHAN_WIDTH_80:
 	case NL80211_CHAN_WIDTH_80P80:
+		if (!(vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ))
+			return false;
+	case NL80211_CHAN_WIDTH_80:
+		if (!vht_cap->vht_supported)
+			return false;
 		width = 80;
 		break;
 	case NL80211_CHAN_WIDTH_160:
+		if (!vht_cap->vht_supported)
+			return false;
+		if (!(vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ))
+			return false;
 		width = 160;
 		break;
 	default:
 		WARN_ON_ONCE(1);
-		trace_cfg80211_return_bool(false);
 		return false;
 	}
 
-	res = cfg80211_check_beacon_chans(wiphy, chandef->center_freq1, width);
+	/* TODO: missing regulatory check on 80/160 bandwidth */
+
+	if (!cfg80211_secondary_chans_ok(wiphy, chandef->center_freq1,
+					 width, prohibited_flags))
+		return false;
+
+	if (!chandef->center_freq2)
+		return true;
+	return cfg80211_secondary_chans_ok(wiphy, chandef->center_freq2,
+					   width, prohibited_flags);
+}
+EXPORT_SYMBOL(cfg80211_chandef_usable);
+
+bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
+			     struct cfg80211_chan_def *chandef)
+{
+	bool res;
+
+	trace_cfg80211_reg_can_beacon(wiphy, chandef);
 
-	if (res && chandef->center_freq2)
-		res = cfg80211_check_beacon_chans(wiphy, chandef->center_freq2,
-						  width);
+	res = cfg80211_chandef_usable(wiphy, chandef,
+				      IEEE80211_CHAN_DISABLED |
+				      IEEE80211_CHAN_PASSIVE_SCAN |
+				      IEEE80211_CHAN_NO_IBSS |
+				      IEEE80211_CHAN_RADAR);
 
 	trace_cfg80211_return_bool(res);
 	return res;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index a0c8dec..6183a0d 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -483,12 +483,6 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 			       enum nl80211_iftype iftype, int num);
 
-bool cfg80211_chan_def_valid(const struct cfg80211_chan_def *chandef);
-
-bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
-				 u32 center_freq, u32 bandwidth,
-				 u32 prohibited_flags);
-
 #define CFG80211_MAX_NUM_DIFFERENT_CHANNELS 10
 
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d038fa4..ced04f2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1420,63 +1420,32 @@ static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 	ht_cap = &rdev->wiphy.bands[chandef->chan->band]->ht_cap;
 	vht_cap = &rdev->wiphy.bands[chandef->chan->band]->vht_cap;
 
-	if (!cfg80211_chan_def_valid(chandef))
+	if (!cfg80211_chandef_valid(chandef))
 		return -EINVAL;
 
 	switch (chandef->width) {
 	case NL80211_CHAN_WIDTH_20:
-		if (!ht_cap->ht_supported)
-			return -EINVAL;
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		width = 20;
 		break;
 	case NL80211_CHAN_WIDTH_40:
 		width = 40;
-		/* quick early regulatory check */
-		if (chandef->center_freq1 < control_freq &&
-		    chandef->chan->flags & IEEE80211_CHAN_NO_HT40MINUS)
-			return -EINVAL;
-		if (chandef->center_freq1 > control_freq &&
-		    chandef->chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
-			return -EINVAL;
-		if (!ht_cap->ht_supported)
-			return -EINVAL;
-		if (!(ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) ||
-		    ht_cap->cap & IEEE80211_HT_CAP_40MHZ_INTOLERANT)
-			return -EINVAL;
 		break;
 	case NL80211_CHAN_WIDTH_80:
 		width = 80;
-		if (!vht_cap->vht_supported)
-			return -EINVAL;
 		break;
 	case NL80211_CHAN_WIDTH_80P80:
 		width = 80;
-		if (!vht_cap->vht_supported)
-			return -EINVAL;
-		if (!(vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ))
-			return -EINVAL;
 		break;
 	case NL80211_CHAN_WIDTH_160:
 		width = 160;
-		if (!vht_cap->vht_supported)
-			return -EINVAL;
-		if (!(vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ))
-			return -EINVAL;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	if (!cfg80211_secondary_chans_ok(&rdev->wiphy, chandef->center_freq1,
-					 width, IEEE80211_CHAN_DISABLED))
+	if (!cfg80211_chandef_usable(&rdev->wiphy, chandef, IEEE80211_CHAN_DISABLED))
 		return -EINVAL;
-	if (chandef->center_freq2 &&
-	    !cfg80211_secondary_chans_ok(&rdev->wiphy, chandef->center_freq2,
-					 width, IEEE80211_CHAN_DISABLED))
-		return -EINVAL;
-
-	/* TODO: missing regulatory check on bandwidth */
 
 	return 0;
 }
@@ -1841,7 +1810,7 @@ static inline u64 wdev_id(struct wireless_dev *wdev)
 static int nl80211_send_chandef(struct sk_buff *msg,
 				 struct cfg80211_chan_def *chandef)
 {
-	WARN_ON(!cfg80211_chan_def_valid(chandef));
+	WARN_ON(!cfg80211_chandef_valid(chandef));
 
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ,
 			chandef->chan->center_freq))
-- 
1.8.0

