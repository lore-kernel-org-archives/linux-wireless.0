Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34461 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab1GRQKW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 12:10:22 -0400
Message-Id: <20110718160949.338355119@sipsolutions.net> (sfid-20110718_181025_491495_47D86BA0)
Date: Mon, 18 Jul 2011 18:08:35 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] cfg80211: allow userspace to control supported rates
 in scan
References: <20110718160834.876776560@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some P2P scans are not allowed to advertise
11b rates, but that is a rather special case
so instead of having that, allow userspace
to request the rate sets (per band) that are
advertised in scan probe request frames.

Since it's needed in two places now, factor
out some common code parsing a rate array.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |    7 ++++++
 include/net/cfg80211.h  |    3 ++
 net/wireless/core.h     |    4 +++
 net/wireless/nl80211.c  |   50 +++++++++++++++++++++++++++++-------------------
 net/wireless/scan.c     |    3 ++
 net/wireless/util.c     |   35 +++++++++++++++++++++++++++++++++
 6 files changed, 83 insertions(+), 19 deletions(-)

--- a/include/linux/nl80211.h	2011-07-18 14:05:02.000000000 +0200
+++ b/include/linux/nl80211.h	2011-07-18 15:18:13.000000000 +0200
@@ -1014,6 +1014,11 @@ enum nl80211_commands {
  * @%NL80211_ATTR_REKEY_DATA: nested attribute containing the information
  *	necessary for GTK rekeying in the device, see &enum nl80211_rekey_data.
  *
+ * @NL80211_ATTR_SCAN_SUPP_RATES: rates per to be advertised as supported in scan,
+ *	nested array attribute containing an entry for each band, with the entry
+ *	being a list of supported rates as defined by IEEE 802.11 7.3.2.2 but
+ *	without the length restriction (at most %NL80211_MAX_SUPP_RATES).
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1217,6 +1222,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_MAX_NUM_SCHED_SCAN_SSIDS,
 	NL80211_ATTR_MAX_SCHED_SCAN_IE_LEN,
 
+	NL80211_ATTR_SCAN_SUPP_RATES,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- a/include/net/cfg80211.h	2011-07-18 14:13:47.000000000 +0200
+++ b/include/net/cfg80211.h	2011-07-18 14:15:16.000000000 +0200
@@ -772,6 +772,7 @@ struct cfg80211_ssid {
  * @n_channels: total number of channels to scan
  * @ie: optional information element(s) to add into Probe Request or %NULL
  * @ie_len: length of ie in octets
+ * @rates: bitmap of rates to advertise for each band
  * @wiphy: the wiphy this was for
  * @dev: the interface
  * @aborted: (internal) scan request was notified as aborted
@@ -783,6 +784,8 @@ struct cfg80211_scan_request {
 	const u8 *ie;
 	size_t ie_len;
 
+	u32 rates[IEEE80211_NUM_BANDS];
+
 	/* internal */
 	struct wiphy *wiphy;
 	struct net_device *dev;
--- a/net/wireless/nl80211.c	2011-07-18 14:15:48.000000000 +0200
+++ b/net/wireless/nl80211.c	2011-07-18 15:31:38.000000000 +0200
@@ -177,6 +177,7 @@ static const struct nla_policy nl80211_p
 	[NL80211_ATTR_STA_PLINK_STATE] = { .type = NLA_U8 },
 	[NL80211_ATTR_SCHED_SCAN_INTERVAL] = { .type = NLA_U32 },
 	[NL80211_ATTR_REKEY_DATA] = { .type = NLA_NESTED },
+	[NL80211_ATTR_SCAN_SUPP_RATES] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -3324,7 +3325,6 @@ static int nl80211_trigger_scan(struct s
 	struct nlattr *attr;
 	struct wiphy *wiphy;
 	int err, tmp, n_ssids = 0, n_channels, i;
-	enum ieee80211_band band;
 	size_t ie_len;
 
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
@@ -3344,6 +3344,7 @@ static int nl80211_trigger_scan(struct s
 		if (!n_channels)
 			return -EINVAL;
 	} else {
+		enum ieee80211_band band;
 		n_channels = 0;
 
 		for (band = 0; band < IEEE80211_NUM_BANDS; band++)
@@ -3404,6 +3405,8 @@ static int nl80211_trigger_scan(struct s
 			i++;
 		}
 	} else {
+		enum ieee80211_band band;
+
 		/* all channels */
 		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 			int j;
@@ -3450,6 +3453,28 @@ static int nl80211_trigger_scan(struct s
 		       request->ie_len);
 	}
 
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
+		request->rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;
+
+	if (info->attrs[NL80211_ATTR_SCAN_SUPP_RATES]) {
+		nla_for_each_nested(attr,
+				    info->attrs[NL80211_ATTR_SCAN_SUPP_RATES],
+				    tmp) {
+			enum ieee80211_band band = nla_type(attr);
+
+			if (band < 0 || band > IEEE80211_NUM_BANDS) {
+				err = -EINVAL;
+				goto out_free;
+			}
+			err = ieee80211_get_ratemask(wiphy->bands[band],
+						     nla_data(attr),
+						     nla_len(attr),
+						     &request->rates[band]);
+			if (err)
+				goto out_free;
+		}
+	}
+
 	request->dev = dev;
 	request->wiphy = &rdev->wiphy;
 
@@ -4336,25 +4361,12 @@ static int nl80211_join_ibss(struct sk_b
 			nla_len(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
 		struct ieee80211_supported_band *sband =
 			wiphy->bands[ibss.channel->band];
-		int i, j;
-
-		if (n_rates == 0)
-			return -EINVAL;
+		int err;
 
-		for (i = 0; i < n_rates; i++) {
-			int rate = (rates[i] & 0x7f) * 5;
-			bool found = false;
-
-			for (j = 0; j < sband->n_bitrates; j++) {
-				if (sband->bitrates[j].bitrate == rate) {
-					found = true;
-					ibss.basic_rates |= BIT(j);
-					break;
-				}
-			}
-			if (!found)
-				return -EINVAL;
-		}
+		err = ieee80211_get_ratemask(sband, rates, n_rates,
+					     &ibss.basic_rates);
+		if (err)
+			return err;
 	}
 
 	if (info->attrs[NL80211_ATTR_MCAST_RATE] &&
--- a/net/wireless/core.h	2011-07-18 15:15:23.000000000 +0200
+++ b/net/wireless/core.h	2011-07-18 15:15:31.000000000 +0200
@@ -447,6 +447,10 @@ int cfg80211_set_freq(struct cfg80211_re
 
 u16 cfg80211_calculate_bitrate(struct rate_info *rate);
 
+int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
+			   const u8 *rates, unsigned int n_rates,
+			   u32 *mask);
+
 int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 				 u32 beacon_int);
 
--- a/net/wireless/util.c	2011-07-18 15:13:31.000000000 +0200
+++ b/net/wireless/util.c	2011-07-18 15:37:10.000000000 +0200
@@ -1006,3 +1006,38 @@ int cfg80211_can_change_interface(struct
 
 	return -EBUSY;
 }
+
+int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
+			   const u8 *rates, unsigned int n_rates,
+			   u32 *mask)
+{
+	int i, j;
+
+	if (n_rates == 0 || n_rates > NL80211_MAX_SUPP_RATES)
+		return -EINVAL;
+
+	*mask = 0;
+
+	for (i = 0; i < n_rates; i++) {
+		int rate = (rates[i] & 0x7f) * 5;
+		bool found = false;
+
+		for (j = 0; j < sband->n_bitrates; j++) {
+			if (sband->bitrates[j].bitrate == rate) {
+				found = true;
+				*mask |= BIT(j);
+				break;
+			}
+		}
+		if (!found)
+			return -EINVAL;
+	}
+
+	/*
+	 * mask must have at least one bit set here since we
+	 * didn't accept a 0-length rates array nor allowed
+	 * entries in the array that didn't exist
+	 */
+
+	return 0;
+}
--- a/net/wireless/scan.c	2011-07-18 14:16:06.000000000 +0200
+++ b/net/wireless/scan.c	2011-07-18 15:28:54.000000000 +0200
@@ -863,6 +863,9 @@ int cfg80211_wext_siwscan(struct net_dev
 			creq->n_ssids = 0;
 	}
 
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
+		creq->rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;
+
 	rdev->scan_req = creq;
 	err = rdev->ops->scan(wiphy, dev, creq);
 	if (err) {


