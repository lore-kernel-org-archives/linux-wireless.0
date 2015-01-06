Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59464 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbbAFNA5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 08:00:57 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211-wext: export symbols only when needed
Date: Tue,  6 Jan 2015 14:00:53 +0100
Message-Id: <1420549253-4658-1-git-send-email-johannes@sipsolutions.net> (sfid-20150106_140101_006133_9920E3B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a fully converted cfg80211 driver needs cfg80211-wext for
userspace API purposes, the symbols need not be exported. When
other drivers (orinoco/hermes or ipw2200) are enabled, they do
need the symbols exported as they use them directly.

Make those drivers select a new CFG80211_WEXT_EXPORT Kconfig
symbol (instead of just CFG80211_WEXT) and export the functions
only if requested - this saves about 1/2k due to the size of
EXPORT_SYMBOL() itself.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ipw2x00/Kconfig |  3 ++-
 drivers/net/wireless/orinoco/Kconfig |  2 +-
 net/wireless/Kconfig                 |  8 ++++++++
 net/wireless/scan.c                  |  4 ++--
 net/wireless/wext-compat.c           | 18 +++++++++---------
 net/wireless/wext-compat.h           |  6 ++++++
 6 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/Kconfig b/drivers/net/wireless/ipw2x00/Kconfig
index 91c0cb3c368e..d6ec44d7a391 100644
--- a/drivers/net/wireless/ipw2x00/Kconfig
+++ b/drivers/net/wireless/ipw2x00/Kconfig
@@ -65,7 +65,8 @@ config IPW2100_DEBUG
 
 config IPW2200
 	tristate "Intel PRO/Wireless 2200BG and 2915ABG Network Connection"
-	depends on PCI && CFG80211 && CFG80211_WEXT
+	depends on PCI && CFG80211
+	select CFG80211_WEXT_EXPORT
 	select WIRELESS_EXT
 	select WEXT_SPY
 	select WEXT_PRIV
diff --git a/drivers/net/wireless/orinoco/Kconfig b/drivers/net/wireless/orinoco/Kconfig
index 6d831d4d1b5f..f6fa3f4e294f 100644
--- a/drivers/net/wireless/orinoco/Kconfig
+++ b/drivers/net/wireless/orinoco/Kconfig
@@ -2,7 +2,7 @@ config HERMES
 	tristate "Hermes chipset 802.11b support (Orinoco/Prism2/Symbol)"
 	depends on (PPC_PMAC || PCI || PCMCIA)
 	depends on CFG80211
-	select CFG80211_WEXT
+	select CFG80211_WEXT_EXPORT
 	select WIRELESS_EXT
 	select WEXT_SPY
 	select WEXT_PRIV
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 22ba971741e5..7181fa818cfd 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -178,10 +178,18 @@ config CFG80211_WEXT
 	bool
 	depends on CFG80211
 	select WEXT_CORE
+	default y if CFG80211_WEXT_EXPORT
 	help
 	  Enable this option if you need old userspace for wireless
 	  extensions with cfg80211-based drivers.
 
+config CFG80211_WEXT_EXPORT
+	bool
+	depends on CFG80211
+	help
+	  Drivers should select this option if they require cfg80211's
+	  wext compatibility symbols to be exported.
+
 config LIB80211
 	tristate
 	default n
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index c705c3e2b751..25e1e1fad905 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1237,7 +1237,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	kfree(creq);
 	return err;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwscan);
+EXPORT_WEXT_HANDLER(cfg80211_wext_siwscan);
 
 static void ieee80211_scan_add_ies(struct iw_request_info *info,
 				   const struct cfg80211_bss_ies *ies,
@@ -1545,5 +1545,5 @@ int cfg80211_wext_giwscan(struct net_device *dev,
 
 	return res;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwscan);
+EXPORT_WEXT_HANDLER(cfg80211_wext_giwscan);
 #endif
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 0f47948c572f..2e6a3a74cefa 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -63,7 +63,7 @@ int cfg80211_wext_giwname(struct net_device *dev,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwname);
+EXPORT_WEXT_HANDLER(cfg80211_wext_giwname);
 
 int cfg80211_wext_siwmode(struct net_device *dev, struct iw_request_info *info,
 			  u32 *mode, char *extra)
@@ -99,7 +99,7 @@ int cfg80211_wext_siwmode(struct net_device *dev, struct iw_request_info *info,
 
 	return cfg80211_change_iface(rdev, dev, type, NULL, &vifparams);
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwmode);
+EXPORT_WEXT_HANDLER(cfg80211_wext_siwmode);
 
 int cfg80211_wext_giwmode(struct net_device *dev, struct iw_request_info *info,
 			  u32 *mode, char *extra)
@@ -134,7 +134,7 @@ int cfg80211_wext_giwmode(struct net_device *dev, struct iw_request_info *info,
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwmode);
+EXPORT_WEXT_HANDLER(cfg80211_wext_giwmode);
 
 
 int cfg80211_wext_giwrange(struct net_device *dev,
@@ -248,7 +248,7 @@ int cfg80211_wext_giwrange(struct net_device *dev,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwrange);
+EXPORT_WEXT_HANDLER(cfg80211_wext_giwrange);
 
 
 /**
@@ -303,7 +303,7 @@ int cfg80211_wext_siwrts(struct net_device *dev,
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwrts);
+EXPORT_WEXT_HANDLER(cfg80211_wext_siwrts);
 
 int cfg80211_wext_giwrts(struct net_device *dev,
 			 struct iw_request_info *info,
@@ -317,7 +317,7 @@ int cfg80211_wext_giwrts(struct net_device *dev,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwrts);
+EXPORT_WEXT_HANDLER(cfg80211_wext_giwrts);
 
 int cfg80211_wext_siwfrag(struct net_device *dev,
 			  struct iw_request_info *info,
@@ -343,7 +343,7 @@ int cfg80211_wext_siwfrag(struct net_device *dev,
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwfrag);
+EXPORT_WEXT_HANDLER(cfg80211_wext_siwfrag);
 
 int cfg80211_wext_giwfrag(struct net_device *dev,
 			  struct iw_request_info *info,
@@ -357,7 +357,7 @@ int cfg80211_wext_giwfrag(struct net_device *dev,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwfrag);
+EXPORT_WEXT_HANDLER(cfg80211_wext_giwfrag);
 
 static int cfg80211_wext_siwretry(struct net_device *dev,
 				  struct iw_request_info *info,
@@ -427,7 +427,7 @@ int cfg80211_wext_giwretry(struct net_device *dev,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwretry);
+EXPORT_WEXT_HANDLER(cfg80211_wext_giwretry);
 
 static int __cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 				     struct net_device *dev, bool pairwise,
diff --git a/net/wireless/wext-compat.h b/net/wireless/wext-compat.h
index ebcacca2f731..f9f29e62c7c1 100644
--- a/net/wireless/wext-compat.h
+++ b/net/wireless/wext-compat.h
@@ -4,6 +4,12 @@
 #include <net/iw_handler.h>
 #include <linux/wireless.h>
 
+#ifdef CFG80211_WEXT_EXPORT
+#define EXPORT_WEXT_HANDLER(h) EXPORT_SYMBOL_GPL(h)
+#else
+#define EXPORT_WEXT_HANDLER(h)
+#endif /* CFG80211_WEXT_EXPORT */
+
 int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
 			       struct iw_request_info *info,
 			       struct iw_freq *freq, char *extra);
-- 
2.1.1

