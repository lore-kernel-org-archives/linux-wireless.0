Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38902 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753259AbdBGUky (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 15:40:54 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Tue,  7 Feb 2017 22:40:44 +0200
Message-Id: <20170207204044.1950-1-luca@coelho.fi> (sfid-20170207_214057_501756_95B1D39C)
Subject: [PATCH] nl80211: add HT/VHT capabilities to AP parameters
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For the benefit of drivers that rebuild IEs in firmware, parse the
IEs for HT/VHT capabilities and the respective membership selector
in the (extended) supported rates. This avoids duplicating the same
code into all drivers that need this information.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h |  3 ++-
 include/net/cfg80211.h    |  8 ++++++++
 net/wireless/nl80211.c    | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 02768de209d6..0dd9498c694f 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1043,8 +1043,9 @@ struct ieee80211_mgmt {
 	} u;
 } __packed __aligned(2);
 
-/* Supported Rates value encodings in 802.11n-2009 7.3.2.2 */
+/* Supported rates membership selectors */
 #define BSS_MEMBERSHIP_SELECTOR_HT_PHY	127
+#define BSS_MEMBERSHIP_SELECTOR_VHT_PHY	126
 
 /* mgmt header + 1 byte category code */
 #define IEEE80211_MIN_ACTION_SIZE offsetof(struct ieee80211_mgmt, u.action.u)
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 870549480e9b..5cfd2806a078 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -748,6 +748,10 @@ struct cfg80211_bitrate_mask {
  * @pbss: If set, start as a PCP instead of AP. Relevant for DMG
  *	networks.
  * @beacon_rate: bitrate to be used for beacons
+ * @ht_cap: HT capabilities (or %NULL if HT isn't enabled)
+ * @vht_cap: VHT capabilities (or %NULL if VHT isn't enabled)
+ * @ht_required: stations must support HT
+ * @vht_required: stations must support VHT
  */
 struct cfg80211_ap_settings {
 	struct cfg80211_chan_def chandef;
@@ -768,6 +772,10 @@ struct cfg80211_ap_settings {
 	const struct cfg80211_acl_data *acl;
 	bool pbss;
 	struct cfg80211_bitrate_mask beacon_rate;
+
+	const struct ieee80211_ht_cap *ht_cap;
+	const struct ieee80211_vht_cap *vht_cap;
+	bool ht_required, vht_required;
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 63dfa60a29ef..e023b55477ec 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3,7 +3,7 @@
  *
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright 2015-2016	Intel Deutschland GmbH
+ * Copyright 2015-2017	Intel Deutschland GmbH
  */
 
 #include <linux/if.h>
@@ -3743,6 +3743,49 @@ static int nl80211_parse_beacon(struct nlattr *attrs[],
 	return 0;
 }
 
+static void nl80211_check_ap_rate_selectors(struct cfg80211_ap_settings *params,
+					    const u8 *rates)
+{
+	int i;
+
+	if (!rates)
+		return;
+
+	for (i = 0; i < rates[1]; i++) {
+		if (rates[2 + i] == BSS_MEMBERSHIP_SELECTOR_HT_PHY)
+			params->ht_required = true;
+		if (rates[2 + i] == BSS_MEMBERSHIP_SELECTOR_VHT_PHY)
+			params->vht_required = true;
+	}
+}
+
+/*
+ * Since the nl80211 API didn't include, from the beginning, attributes about
+ * HT/VHT requirements/capabilities, we parse them out of the IEs for the
+ * benefit of drivers that rebuild IEs in the firmware.
+ */
+static void nl80211_calculate_ap_params(struct cfg80211_ap_settings *params)
+{
+	const struct cfg80211_beacon_data *bcn = &params->beacon;
+	size_t ies_len = bcn->beacon_ies_len;
+	const u8 *ies = bcn->beacon_ies;
+	const u8 *rates;
+	const u8 *cap;
+
+	rates = cfg80211_find_ie(WLAN_EID_SUPP_RATES, ies, ies_len);
+	nl80211_check_ap_rate_selectors(params, rates);
+
+	rates = cfg80211_find_ie(WLAN_EID_EXT_SUPP_RATES, ies, ies_len);
+	nl80211_check_ap_rate_selectors(params, rates);
+
+	cap = cfg80211_find_ie(WLAN_EID_HT_CAPABILITY, ies, ies_len);
+	if (cap && cap[1] >= sizeof(*params->ht_cap))
+		params->ht_cap = (void *)(cap + 2);
+	cap = cfg80211_find_ie(WLAN_EID_VHT_CAPABILITY, ies, ies_len);
+	if (cap && cap[1] >= sizeof(*params->vht_cap))
+		params->vht_cap = (void *)(cap + 2);
+}
+
 static bool nl80211_get_ap_channel(struct cfg80211_registered_device *rdev,
 				   struct cfg80211_ap_settings *params)
 {
@@ -3971,6 +4014,8 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 			return PTR_ERR(params.acl);
 	}
 
+	nl80211_calculate_ap_params(&params);
+
 	wdev_lock(wdev);
 	err = rdev_start_ap(rdev, dev, &params);
 	if (!err) {
-- 
2.11.0
