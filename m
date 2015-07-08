Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:58373 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932771AbbGHMmS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 08:42:18 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 09/10] mac80211: allow drivers to set netdev hw_features
Date: Wed,  8 Jul 2015 15:41:51 +0300
Message-Id: <1436359312-26533-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150708_144233_928743_F6B0321A)
In-Reply-To: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

By allowing drivers to set hw_features and not just features we
gain the ability to turn certain features off with ethtool.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 4 +++-
 net/mac80211/iface.c   | 3 ++-
 net/mac80211/main.c    | 3 ++-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6efb766..4caef55 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2016,6 +2016,8 @@ enum ieee80211_hw_flags {
  * @netdev_features: netdev features to be set in each netdev created
  *	from this HW. Note that not all features are usable with mac80211,
  *	other features will be rejected during HW registration.
+ * @netdev_hw_features: features to advertise as netdev hw_features, which
+ *	impacts the ability of ethtool to modify them
  *
  * @uapsd_queues: This bitmap is included in (re)association frame to indicate
  *	for each access category if it is uAPSD trigger-enabled and delivery-
@@ -2058,7 +2060,7 @@ struct ieee80211_hw {
 	u8 offchannel_tx_hw_queue;
 	u8 radiotap_mcs_details;
 	u16 radiotap_vht_details;
-	netdev_features_t netdev_features;
+	netdev_features_t netdev_features, netdev_hw_features;
 	u8 uapsd_queues;
 	u8 uapsd_max_sp_len;
 	u8 n_cipher_schemes;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 0fba7f9..e3bb35f 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1814,7 +1814,8 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 				sdata->u.mgd.use_4addr = params->use_4addr;
 		}
 
-		ndev->features |= local->hw.netdev_features;
+		ndev->features = local->hw.netdev_features;
+		ndev->hw_features = local->hw.netdev_hw_features;
 
 		netdev_set_default_ethtool_ops(ndev, &ieee80211_ethtool_ops);
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index ee1bc81..6b830c6 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -850,7 +850,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	feature_whitelist = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 			    NETIF_F_HW_CSUM | NETIF_F_SG | NETIF_F_HIGHDMA |
 			    NETIF_F_GSO_SOFTWARE;
-	if (WARN_ON(hw->netdev_features & ~feature_whitelist))
+	if (WARN_ON(hw->netdev_features & ~feature_whitelist ||
+		    hw->netdev_hw_features & ~feature_whitelist))
 		return -EINVAL;
 
 	if (hw->max_report_rates == 0)
-- 
2.1.4

