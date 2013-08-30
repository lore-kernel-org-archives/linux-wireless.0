Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38810 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab3H3It1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Aug 2013 04:49:27 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>
Subject: [PATCH 3/3] mac80211: allow configuring smps_mode_in_ps
Date: Fri, 30 Aug 2013 10:49:21 +0200
Message-Id: <1377852561-16754-3-git-send-email-johannes@sipsolutions.net> (sfid-20130830_104935_274969_0AC9B6AF)
In-Reply-To: <1377852561-16754-1-git-send-email-johannes@sipsolutions.net>
References: <1377852561-16754-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

When in automatic smps mode (default for station mode),
mac80211 configures dynamic smps when the station enters
powersave.

However, drivers might prefer using different modes in this
case (e.g. due to major throughput degradation).

Add a new hw->smps_mode_in_ps field that can be configured
by the driver in order to override the default smps dynamic mode.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h        |  5 +++++
 net/mac80211/cfg.c            |  2 +-
 net/mac80211/debugfs_netdev.c | 11 +++++++----
 net/mac80211/main.c           |  1 +
 net/mac80211/mlme.c           |  7 ++++++-
 5 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3ecf635..637b797 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1615,6 +1615,10 @@ enum ieee80211_hw_flags {
  * @uapsd_max_sp_len: maximum number of total buffered frames the WMM AP may
  *	deliver to a WMM STA during any Service Period triggered by the WMM STA.
  *	Use IEEE80211_WMM_IE_STA_QOSINFO_SP_* for correct values.
+ *
+ * @smps_mode_in_ps: smps mode to use when automatic smps mode is configured.
+ *	The default is _DYNAMIC.
+ *	Use the %IEEE80211_SMPS_* values.
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -1642,6 +1646,7 @@ struct ieee80211_hw {
 	netdev_features_t netdev_features;
 	u8 uapsd_queues;
 	u8 uapsd_max_sp_len;
+	enum ieee80211_smps_mode smps_mode_in_ps;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7aa38ce..1932126 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2364,7 +2364,7 @@ int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
 
 	if (smps_mode == IEEE80211_SMPS_AUTOMATIC) {
 		if (sdata->u.mgd.powersave)
-			smps_mode = IEEE80211_SMPS_DYNAMIC;
+			smps_mode = sdata->local->hw.smps_mode_in_ps;
 		else
 			smps_mode = IEEE80211_SMPS_OFF;
 	}
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index cafe614..66dff46 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -212,16 +212,19 @@ static int ieee80211_set_smps(struct ieee80211_sub_if_data *sdata,
 			      enum ieee80211_smps_mode smps_mode)
 {
 	struct ieee80211_local *local = sdata->local;
+	enum ieee80211_smps_mode target_mode = smps_mode;
 	int err;
 
+	/* in case of auto, hw.smps_mode_in_ps will be configured when in psm */
+	if (smps_mode == IEEE80211_SMPS_AUTOMATIC)
+		target_mode = local->hw.smps_mode_in_ps;
+
 	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_STATIC_SMPS) &&
-	    smps_mode == IEEE80211_SMPS_STATIC)
+	    target_mode == IEEE80211_SMPS_STATIC)
 		return -EINVAL;
 
-	/* auto should be dynamic if in PS mode */
 	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS) &&
-	    (smps_mode == IEEE80211_SMPS_DYNAMIC ||
-	     smps_mode == IEEE80211_SMPS_AUTOMATIC))
+	    target_mode == IEEE80211_SMPS_DYNAMIC)
 		return -EINVAL;
 
 	/* supported only on managed interfaces for now */
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 21d5d44..885c8e3 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -585,6 +585,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					 IEEE80211_RADIOTAP_VHT_KNOWN_BANDWIDTH;
 	local->hw.uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
 	local->hw.uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
+	local->hw.smps_mode_in_ps = IEEE80211_SMPS_DYNAMIC;
 	local->user_power_level = IEEE80211_UNSET_POWER_LEVEL;
 	wiphy->ht_capa_mod_mask = &mac80211_ht_capa_mod_mask;
 	wiphy->vht_capa_mod_mask = &mac80211_vht_capa_mod_mask;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 45a87ee..007cc4d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3700,7 +3700,12 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 	ifmgd->uapsd_max_sp_len = sdata->local->hw.uapsd_max_sp_len;
 	ifmgd->p2p_noa_index = -1;
 
-	if (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS)
+	/* set automatic smps by default, if hw.smps_mode_in_ps is supported */
+	if (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS &&
+	    sdata->local->hw.smps_mode_in_ps == IEEE80211_SMPS_DYNAMIC)
+		ifmgd->req_smps = IEEE80211_SMPS_AUTOMATIC;
+	else if (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_STATIC_SMPS &&
+		 sdata->local->hw.smps_mode_in_ps == IEEE80211_SMPS_STATIC)
 		ifmgd->req_smps = IEEE80211_SMPS_AUTOMATIC;
 	else
 		ifmgd->req_smps = IEEE80211_SMPS_OFF;
-- 
1.8.4.rc3

