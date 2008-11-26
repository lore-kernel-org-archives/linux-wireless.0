Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60275 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbYKZSWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 13:22:38 -0500
Subject: [PATCH] cfg80211: handle SIOCGIWNAME
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 19:21:59 +0100
Message-Id: <1227723719.4613.125.camel@johannes.berg> (sfid-20081126_192242_947337_29E27CC7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves the SIOCGIWNAME handling from mac80211 to cfg80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |    7 +++++
 net/mac80211/wext.c        |   44 ---------------------------------
 net/wireless/Makefile      |    2 -
 net/wireless/wext-compat.c |   60 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 69 insertions(+), 44 deletions(-)

--- everything.orig/net/wireless/Makefile	2008-11-26 18:53:41.000000000 +0100
+++ everything/net/wireless/Makefile	2008-11-26 18:53:47.000000000 +0100
@@ -5,7 +5,7 @@ obj-$(CONFIG_LIB80211_CRYPT_WEP) += lib8
 obj-$(CONFIG_LIB80211_CRYPT_CCMP) += lib80211_crypt_ccmp.o
 obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib80211_crypt_tkip.o
 
-cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o
+cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o wext-compat.o
 cfg80211-$(CONFIG_NL80211) += nl80211.o
 
 ccflags-y += -D__CHECK_ENDIAN__
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/net/wireless/wext-compat.c	2008-11-26 19:18:29.000000000 +0100
@@ -0,0 +1,60 @@
+/*
+ * cfg80211 - wext compat code
+ *
+ * This is temporary code until all wireless functionality is migrated
+ * into cfg80211, when that happens all the exports here go away and
+ * we directly assign the wireless handlers of wireless interfaces.
+ *
+ * Copyright 2008	Johannes Berg <johannes@sipsolutions.net>
+ */
+
+#include <linux/wireless.h>
+#include <linux/nl80211.h>
+#include <net/iw_handler.h>
+#include <net/wireless.h>
+#include <net/cfg80211.h>
+#include "core.h"
+
+int cfg80211_giwname(struct net_device *dev,
+		     struct iw_request_info *info,
+		     char *name, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct ieee80211_supported_band *sband;
+	bool is_ht = false, is_a = false, is_b = false, is_g = false;
+
+	if (!wdev)
+		return -EOPNOTSUPP;
+
+	sband = wdev->wiphy->bands[IEEE80211_BAND_5GHZ];
+	if (sband) {
+		is_a = true;
+		is_ht |= sband->ht_cap.ht_supported;
+	}
+
+	sband = wdev->wiphy->bands[IEEE80211_BAND_2GHZ];
+	if (sband) {
+		int i;
+		/* Check for mandatory rates */
+		for (i = 0; i < sband->n_bitrates; i++) {
+			if (sband->bitrates[i].bitrate == 10)
+				is_b = true;
+			if (sband->bitrates[i].bitrate == 60)
+				is_g = true;
+		}
+		is_ht |= sband->ht_cap.ht_supported;
+	}
+
+	strcpy(name, "IEEE 802.11");
+	if (is_a)
+		strcat(name, "a");
+	if (is_b)
+		strcat(name, "b");
+	if (is_g)
+		strcat(name, "g");
+	if (is_ht)
+		strcat(name, "n");
+
+	return 0;
+}
+EXPORT_SYMBOL(cfg80211_giwname);
--- everything.orig/include/net/cfg80211.h	2008-11-26 19:18:46.000000000 +0100
+++ everything/include/net/cfg80211.h	2008-11-26 19:19:40.000000000 +0100
@@ -5,6 +5,8 @@
 #include <linux/skbuff.h>
 #include <linux/nl80211.h>
 #include <net/genetlink.h>
+/* remove once we remove the wext stuff */
+#include <net/iw_handler.h>
 
 /*
  * 802.11 configuration in-kernel interface
@@ -515,4 +517,9 @@ struct cfg80211_ops {
 				  struct ieee80211_txq_params *params);
 };
 
+/* temporary wext handlers */
+int cfg80211_giwname(struct net_device *dev,
+		     struct iw_request_info *info,
+		     char *name, char *extra);
+
 #endif /* __NET_CFG80211_H */
--- everything.orig/net/mac80211/wext.c	2008-11-26 19:17:40.000000000 +0100
+++ everything/net/mac80211/wext.c	2008-11-26 19:17:53.000000000 +0100
@@ -135,48 +135,6 @@ static int ieee80211_ioctl_siwgenie(stru
 	return -EOPNOTSUPP;
 }
 
-static int ieee80211_ioctl_giwname(struct net_device *dev,
-				   struct iw_request_info *info,
-				   char *name, char *extra)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_supported_band *sband;
-	u8 is_ht = 0, is_a = 0, is_b = 0, is_g = 0;
-
-
-	sband = local->hw.wiphy->bands[IEEE80211_BAND_5GHZ];
-	if (sband) {
-		is_a = 1;
-		is_ht |= sband->ht_cap.ht_supported;
-	}
-
-	sband = local->hw.wiphy->bands[IEEE80211_BAND_2GHZ];
-	if (sband) {
-		int i;
-		/* Check for mandatory rates */
-		for (i = 0; i < sband->n_bitrates; i++) {
-			if (sband->bitrates[i].bitrate == 10)
-				is_b = 1;
-			if (sband->bitrates[i].bitrate == 60)
-				is_g = 1;
-		}
-		is_ht |= sband->ht_cap.ht_supported;
-	}
-
-	strcpy(name, "IEEE 802.11");
-	if (is_a)
-		strcat(name, "a");
-	if (is_b)
-		strcat(name, "b");
-	if (is_g)
-		strcat(name, "g");
-	if (is_ht)
-		strcat(name, "n");
-
-	return 0;
-}
-
-
 static int ieee80211_ioctl_giwrange(struct net_device *dev,
 				 struct iw_request_info *info,
 				 struct iw_point *data, char *extra)
@@ -1138,7 +1096,7 @@ static int ieee80211_ioctl_siwencodeext(
 static const iw_handler ieee80211_handler[] =
 {
 	(iw_handler) NULL,				/* SIOCSIWCOMMIT */
-	(iw_handler) ieee80211_ioctl_giwname,		/* SIOCGIWNAME */
+	(iw_handler) cfg80211_giwname,			/* SIOCGIWNAME */
 	(iw_handler) NULL,				/* SIOCSIWNWID */
 	(iw_handler) NULL,				/* SIOCGIWNWID */
 	(iw_handler) ieee80211_ioctl_siwfreq,		/* SIOCSIWFREQ */


