Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45546 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727207AbeHaNCU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 09:02:20 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 11:31:14 +0300
Message-Id: <20180831083130.15525-13-luca@coelho.fi> (sfid-20180831_105558_739876_7BB84AB1)
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
Subject: [PATCH 12/28] cfg80211: add he_capabilities (ext) IE to AP settings
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shaul Triebitz <shaul.triebitz@intel.com>

Same as for HT and VHT.
This helps the lower level to know whether the AP supports HE.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h | 2 ++
 net/wireless/nl80211.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 46c4cbf54903..0bdf293061fb 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -849,6 +849,7 @@ struct cfg80211_bitrate_mask {
  * @beacon_rate: bitrate to be used for beacons
  * @ht_cap: HT capabilities (or %NULL if HT isn't enabled)
  * @vht_cap: VHT capabilities (or %NULL if VHT isn't enabled)
+ * @he_cap: HE capabilities (or %NULL if HE isn't enabled)
  * @ht_required: stations must support HT
  * @vht_required: stations must support VHT
  */
@@ -874,6 +875,7 @@ struct cfg80211_ap_settings {
 
 	const struct ieee80211_ht_cap *ht_cap;
 	const struct ieee80211_vht_cap *vht_cap;
+	const struct ieee80211_he_cap_elem *he_cap;
 	bool ht_required, vht_required;
 };
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f9e8efd534f3..dc108266b5f9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4095,6 +4095,9 @@ static void nl80211_calculate_ap_params(struct cfg80211_ap_settings *params)
 	cap = cfg80211_find_ie(WLAN_EID_VHT_CAPABILITY, ies, ies_len);
 	if (cap && cap[1] >= sizeof(*params->vht_cap))
 		params->vht_cap = (void *)(cap + 2);
+	cap = cfg80211_find_ext_ie(WLAN_EID_EXT_HE_CAPABILITY, ies, ies_len);
+	if (cap && cap[1] >= sizeof(*params->he_cap) + 1)
+		params->he_cap = (void *)(cap + 3);
 }
 
 static bool nl80211_get_ap_channel(struct cfg80211_registered_device *rdev,
-- 
2.18.0
