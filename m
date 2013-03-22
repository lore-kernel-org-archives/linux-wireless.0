Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49631 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3CVMTN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 08:19:13 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH] mac80211: allow drivers to set default uAPSD parameters
Date: Fri, 22 Mar 2013 13:19:07 +0100
Message-Id: <1363954747-29314-1-git-send-email-johannes@sipsolutions.net> (sfid-20130322_131916_578516_B55AA7C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

mac80211 currently sets uAPSD parameters to have VO AC trigger-
and delivery-enabled, with maximum service period length.

Allow drivers to change these default settings since different
uAPSD client implementations may handle errors differently and
be able to recover from some errors.

Note: some APs may not function correctly if one or all ACs are
trigger- and delivery-enabled, see
http://thread.gmane.org/gmane.linux.kernel.wireless.general/93577.
We retested with this AP and later firmware doesn't have this
bug any more.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 13 +++++++++++++
 net/mac80211/main.c    |  2 ++
 net/mac80211/mlme.c    |  4 ++--
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7292607..1b7a9e9 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1535,6 +1535,17 @@ enum ieee80211_hw_flags {
  * @netdev_features: netdev features to be set in each netdev created
  *	from this HW. Note only HW checksum features are currently
  *	compatible with mac80211. Other feature bits will be rejected.
+ *
+ * @uapsd_queues: This bitmap is included in (re)association frame to indicate
+ *	for each access category if it is uAPSD trigger-enabled and delivery-
+ *	enabled. Use IEEE80211_WMM_IE_STA_QOSINFO_AC_* to set this bitmap.
+ *	Each bit corresponds to different AC. Value '1' in specific bit means
+ *	that corresponding AC is both trigger- and delivery-enabled. '0' means
+ *	neither enabled.
+ *
+ * @uapsd_max_sp_len: maximum number of total buffered frames the WMM AP may
+ *	deliver to a WMM STA during any Service Period triggered by the WMM STA.
+ *	Use IEEE80211_WMM_IE_STA_QOSINFO_SP_* for correct values.
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -1560,6 +1571,8 @@ struct ieee80211_hw {
 	u8 radiotap_mcs_details;
 	u16 radiotap_vht_details;
 	netdev_features_t netdev_features;
+	u8 uapsd_queues;
+	u8 uapsd_max_sp_len;
 };
 
 /**
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c6f81ec..b0d2868 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -587,6 +587,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					 IEEE80211_RADIOTAP_MCS_HAVE_BW;
 	local->hw.radiotap_vht_details = IEEE80211_RADIOTAP_VHT_KNOWN_GI |
 					 IEEE80211_RADIOTAP_VHT_KNOWN_BANDWIDTH;
+	local->hw.uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
+	local->hw.uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
 	local->user_power_level = IEEE80211_UNSET_POWER_LEVEL;
 	wiphy->ht_capa_mod_mask = &mac80211_ht_capa_mod_mask;
 	wiphy->vht_capa_mod_mask = &mac80211_vht_capa_mod_mask;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ec04543..8a4ed7a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3551,8 +3551,8 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 
 	ifmgd->flags = 0;
 	ifmgd->powersave = sdata->wdev.ps;
-	ifmgd->uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
-	ifmgd->uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
+	ifmgd->uapsd_queues = sdata->local->hw.uapsd_queues;
+	ifmgd->uapsd_max_sp_len = sdata->local->hw.uapsd_max_sp_len;
 	ifmgd->p2p_noa_index = -1;
 
 	mutex_init(&ifmgd->mtx);
-- 
1.8.0

