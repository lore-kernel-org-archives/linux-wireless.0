Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:46266 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbZCLQPi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 12:15:38 -0400
Subject: [PATCH v2] cfg80211/nl80211: remove usage of CONFIG_NL80211
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1236842210.4175.8.camel@johannes.local>
References: <1236812988-31827-1-git-send-email-reinette.chatre@intel.com>
	 <1236842210.4175.8.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 09:20:40 -0700
Message-Id: <1236874840.13699.2.camel@rc-desk> (sfid-20090312_171542_001254_870BEA0E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

The scan capability added to cfg80211/nl80211 introduced a
dependency on nl80211 by cfg80211. We can thus no longer have
just cfg80211 without nl80211. Specifically, cfg80211_scan_done()
calls nl80211_send_scan_aborted() or nl80211_send_scan_done().

Now we remove the option for user to select nl80211. It will always
be compiled if user selects cfg80211.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
v2: neglected to notice the #else used in nl80211.h. Remove
    inlines previously used when compiling without nl80211.

 net/wireless/Kconfig   |   13 -------------
 net/wireless/Makefile  |    3 +--
 net/wireless/nl80211.h |   22 ----------------------
 3 files changed, 1 insertions(+), 37 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index e28e2b8..8f779a2 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -10,19 +10,6 @@ config CFG80211_REG_DEBUG
 
 	  If unsure, say N.
 
-config NL80211
-	bool "nl80211 new netlink interface support"
-	depends on CFG80211
-	default y
-	---help---
-	  This option turns on the new netlink interface
-	  (nl80211) support in cfg80211.
-
-	  If =n, drivers using mac80211 will be configured via
-	  wireless extension support provided by that subsystem.
-
-	  If unsure, say Y.
-
 config WIRELESS_OLD_REGULATORY
 	bool "Old wireless static regulatory definitions"
 	default y
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index dad43c2..c157b4d 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -5,8 +5,7 @@ obj-$(CONFIG_LIB80211_CRYPT_WEP) += lib80211_crypt_wep.o
 obj-$(CONFIG_LIB80211_CRYPT_CCMP) += lib80211_crypt_ccmp.o
 obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib80211_crypt_tkip.o
 
-cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o
+cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o
 cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o
-cfg80211-$(CONFIG_NL80211) += nl80211.o
 
 ccflags-y += -D__CHECK_ENDIAN__
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 69787b6..11a2e70 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -3,7 +3,6 @@
 
 #include "core.h"
 
-#ifdef CONFIG_NL80211
 extern int nl80211_init(void);
 extern void nl80211_exit(void);
 extern void nl80211_notify_dev_rename(struct cfg80211_registered_device *rdev);
@@ -11,26 +10,5 @@ extern void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
 				   struct net_device *netdev);
 extern void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
 				      struct net_device *netdev);
-#else
-static inline int nl80211_init(void)
-{
-	return 0;
-}
-static inline void nl80211_exit(void)
-{
-}
-static inline void nl80211_notify_dev_rename(
-	struct cfg80211_registered_device *rdev)
-{
-}
-static inline void
-nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
-		       struct net_device *netdev)
-{}
-static inline void nl80211_send_scan_aborted(
-					struct cfg80211_registered_device *rdev,
-					struct net_device *netdev)
-{}
-#endif /* CONFIG_NL80211 */
 
 #endif /* __NET_WIRELESS_NL80211_H */
-- 
1.5.6.3



