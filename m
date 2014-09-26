Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:52600 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030185AbaIZTfu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 15:35:50 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: emmanuel.grumbach@intel.com, michal.kazior@tieto.com,
	linux-wireless@vger.kernel.org
Date: Fri, 26 Sep 2014 22:35:01 +0300
Message-Id: <1411760105-18614-4-git-send-email-luca@coelho.fi> (sfid-20140926_213554_949101_7E2947B3)
In-Reply-To: <1411760105-18614-1-git-send-email-luca@coelho.fi>
References: <1411760105-18614-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 3/7] mac80211: add extended channel switching capability if the driver supports CSA
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The Extended Channel Switching capability bit in the extended
capabilities element must be set if the driver supports CSA on
non-beaconing interfaces.

Since this capability needs to be set during driver registration, the
extended_capabiliities global variable needs to be moved to the local
structure so that it can be modified.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/linux/ieee80211.h  |  5 +++++
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/main.c        | 20 +++++++++++---------
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index b1be39c..5fab17b 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1998,6 +1998,11 @@ enum ieee80211_tdls_actioncode {
 	WLAN_TDLS_DISCOVERY_REQUEST = 10,
 };
 
+/* Extended Channel Switching capability to be set in the 1st byte of
+ * the @WLAN_EID_EXT_CAPABILITY information element
+ */
+#define WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING	BIT(2)
+
 /* Interworking capabilities are set in 7th bit of 4th byte of the
  * @WLAN_EID_EXT_CAPABILITY information element
  */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c2aaec4..a9cc491 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1307,6 +1307,9 @@ struct ieee80211_local {
 	/* virtual monitor interface */
 	struct ieee80211_sub_if_data __rcu *monitor_sdata;
 	struct cfg80211_chan_def monitor_chandef;
+
+	/* extended capabilities provided by mac80211 */
+	u8 ext_capa[8];
 };
 
 static inline struct ieee80211_sub_if_data *
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0de7c93..107d1c8 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -478,11 +478,6 @@ static const struct ieee80211_vht_cap mac80211_vht_capa_mod_mask = {
 	},
 };
 
-static const u8 extended_capabilities[] = {
-	0, 0, 0, 0, 0, 0, 0,
-	WLAN_EXT_CAPA8_OPMODE_NOTIF,
-};
-
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops)
 {
@@ -539,10 +534,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 			WIPHY_FLAG_REPORTS_OBSS |
 			WIPHY_FLAG_OFFCHAN_TX;
 
-	wiphy->extended_capabilities = extended_capabilities;
-	wiphy->extended_capabilities_mask = extended_capabilities;
-	wiphy->extended_capabilities_len = ARRAY_SIZE(extended_capabilities);
-
 	if (ops->remain_on_channel)
 		wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 
@@ -591,6 +582,13 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	wiphy->ht_capa_mod_mask = &mac80211_ht_capa_mod_mask;
 	wiphy->vht_capa_mod_mask = &mac80211_vht_capa_mod_mask;
 
+	local->ext_capa[7] = WLAN_EXT_CAPA8_OPMODE_NOTIF;
+
+	wiphy->extended_capabilities = local->ext_capa;
+	wiphy->extended_capabilities_mask = local->ext_capa;
+	wiphy->extended_capabilities_len =
+		ARRAY_SIZE(local->ext_capa);
+
 	INIT_LIST_HEAD(&local->interfaces);
 
 	__hw_addr_init(&local->mc_list);
@@ -958,6 +956,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (local->hw.wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS)
 		local->hw.wiphy->flags |= WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
 
+	/* mac80211 supports eCSA, if the driver supports STA CSA at all */
+	if (local->hw.flags & IEEE80211_HW_CHANCTX_STA_CSA)
+		local->ext_capa[0] |= WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING;
+
 	local->hw.wiphy->max_num_csa_counters = IEEE80211_MAX_CSA_COUNTERS_NUM;
 
 	result = wiphy_register(local->hw.wiphy);
-- 
2.1.0

