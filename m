Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53085 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab2L1L0b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2012 06:26:31 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wireless: use __aligned
Date: Fri, 28 Dec 2012 12:26:52 +0100
Message-Id: <1356694012-25695-1-git-send-email-johannes@sipsolutions.net> (sfid-20121228_122635_360904_AEB4C87D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use __aligned(...) instead of __attribute__((aligned(...)))
in mac80211 and cfg80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 4 ++--
 include/net/mac80211.h | 6 +++---
 net/wireless/core.h    | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b6942a6..48a0bb4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1268,7 +1268,7 @@ struct cfg80211_bss {
 
 	u8 bssid[ETH_ALEN];
 
-	u8 priv[0] __attribute__((__aligned__(sizeof(void *))));
+	u8 priv[0] __aligned(sizeof(void *));
 };
 
 /**
@@ -2404,7 +2404,7 @@ struct wiphy {
 	const struct iw_handler_def *wext;
 #endif
 
-	char priv[0] __attribute__((__aligned__(NETDEV_ALIGN)));
+	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
 static inline struct net *wiphy_net(struct wiphy *wiphy)
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6ee0650..9107d49 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -173,7 +173,7 @@ struct ieee80211_chanctx_conf {
 
 	u8 rx_chains_static, rx_chains_dynamic;
 
-	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
+	u8 drv_priv[0] __aligned(sizeof(void *));
 };
 
 /**
@@ -1059,7 +1059,7 @@ struct ieee80211_vif {
 	u32 driver_flags;
 
 	/* must be last */
-	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
+	u8 drv_priv[0] __aligned(sizeof(void *));
 };
 
 static inline bool ieee80211_vif_is_mesh(struct ieee80211_vif *vif)
@@ -1214,7 +1214,7 @@ struct ieee80211_sta {
 	u8 rx_nss;
 
 	/* must be last */
-	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
+	u8 drv_priv[0] __aligned(sizeof(void *));
 };
 
 /**
diff --git a/net/wireless/core.h b/net/wireless/core.h
index b8f4630..f342267 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -89,7 +89,7 @@ struct cfg80211_registered_device {
 
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
-	struct wiphy wiphy __attribute__((__aligned__(NETDEV_ALIGN)));
+	struct wiphy wiphy __aligned(NETDEV_ALIGN);
 };
 
 static inline
-- 
1.8.0

