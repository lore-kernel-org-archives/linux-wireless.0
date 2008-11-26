Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53390 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbYKZVhP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 16:37:15 -0500
Subject: [PATCH v2] cfg80211: handle SIOCGIWNAME
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 22:36:31 +0100
Message-Id: <1227735391.14269.0.camel@johannes.berg> (sfid-20081126_223721_463748_F9D3E1D4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves the SIOCGIWNAME handling from mac80211 to cfg80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |    7 +++++
 net/mac80211/wext.c        |   44 ---------------------------------
 net/wireless/Makefile      |    1 
 net/wireless/wext-compat.c |   60 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 69 insertions(+), 43 deletions(-)

--- everything.orig/net/wireless/Makefile	2008-11-26 21:31:50.000000000 +0100
+++ everything/net/wireless/Makefile	2008-11-26 21:34:29.000000000 +0100
@@ -6,6 +6,7 @@ obj-$(CONFIG_LIB80211_CRYPT_CCMP) += lib
 obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib80211_crypt_tkip.o
 
 cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o
+cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o
 cfg80211-$(CONFIG_NL80211) += nl80211.o
 
 ccflags-y += -D__CHECK_ENDIAN__
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/net/wireless/wext-compat.c	2008-11-26 21:36:55.000000000 +0100
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
+int cfg80211_wext_giwname(struct net_device *dev,
+			  struct iw_request_info *info,
+			  char *name, char *extra)
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
+EXPORT_SYMBOL(cfg80211_wext_giwname);
--- everything.orig/include/net/cfg80211.h	2008-11-26 21:31:50.000000000 +0100
+++ everything/include/net/cfg80211.h	2008-11-26 21:36:39.000000000 +0100
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
+int cfg80211_wext_giwname(struct net_device *dev,
+			  struct iw_request_info *info,
+			  char *name, char *extra);
+
 #endif /* __NET_CFG80211_H */
--- everything.orig/net/mac80211/wext.c	2008-11-26 21:31:51.000000000 +0100
+++ everything/net/mac80211/wext.c	2008-11-26 21:36:39.000000000 +0100
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
+	(iw_handler) cfg80211_wext_giwname,		/* SIOCGIWNAME */
 	(iw_handler) NULL,				/* SIOCSIWNWID */
 	(iw_handler) NULL,				/* SIOCGIWNWID */
 	(iw_handler) ieee80211_ioctl_siwfreq,		/* SIOCSIWFREQ */


