Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34619 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbZG0KD0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 06:03:26 -0400
Message-Id: <20090727100243.678577241@sipsolutions.net>
References: <20090727100149.839649874@sipsolutions.net>
Date: Mon, 27 Jul 2009 12:01:50 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] cfg80211: combine iwfreq implementations
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Until now we implemented iwfreq for managed mode, we
needed to keep the implementations separate, but now
that we have all versions implemented we can combine
them and export just one handler.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwmc3200wifi/wext.c |   34 --------------
 include/net/cfg80211.h                   |   20 ++------
 net/mac80211/wext.c                      |   73 -------------------------------
 net/wireless/core.h                      |    3 +
 net/wireless/ibss.c                      |    5 --
 net/wireless/nl80211.c                   |    2 
 net/wireless/wext-compat.c               |   54 ++++++++++++++++++++++
 net/wireless/wext-compat.h               |   21 ++++++++
 net/wireless/wext-sme.c                  |    5 --
 9 files changed, 91 insertions(+), 126 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-07-25 10:40:04.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-07-25 10:44:27.000000000 +0200
@@ -1595,12 +1595,6 @@ int cfg80211_wext_siwmlme(struct net_dev
 int cfg80211_wext_giwrange(struct net_device *dev,
 			   struct iw_request_info *info,
 			   struct iw_point *data, char *extra);
-int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
-			       struct iw_request_info *info,
-			       struct iw_freq *freq, char *extra);
-int cfg80211_ibss_wext_giwfreq(struct net_device *dev,
-			       struct iw_request_info *info,
-			       struct iw_freq *freq, char *extra);
 int cfg80211_ibss_wext_siwessid(struct net_device *dev,
 				struct iw_request_info *info,
 				struct iw_point *data, char *ssid);
@@ -1614,12 +1608,6 @@ int cfg80211_ibss_wext_giwap(struct net_
 			     struct iw_request_info *info,
 			     struct sockaddr *ap_addr, char *extra);
 
-int cfg80211_mgd_wext_siwfreq(struct net_device *dev,
-			      struct iw_request_info *info,
-			      struct iw_freq *freq, char *extra);
-int cfg80211_mgd_wext_giwfreq(struct net_device *dev,
-			      struct iw_request_info *info,
-			      struct iw_freq *freq, char *extra);
 int cfg80211_mgd_wext_siwessid(struct net_device *dev,
 			       struct iw_request_info *info,
 			       struct iw_point *data, char *ssid);
@@ -1642,8 +1630,12 @@ int cfg80211_wext_giwauth(struct net_dev
 			  struct iw_request_info *info,
 			  struct iw_param *data, char *extra);
 
-struct ieee80211_channel *cfg80211_wext_freq(struct wiphy *wiphy,
-					     struct iw_freq *freq);
+int cfg80211_wext_siwfreq(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_freq *freq, char *extra);
+int cfg80211_wext_giwfreq(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_freq *freq, char *extra);
 
 int cfg80211_wext_siwrate(struct net_device *dev,
 			  struct iw_request_info *info,
--- wireless-testing.orig/net/mac80211/wext.c	2009-07-24 13:21:08.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-07-25 10:44:27.000000000 +0200
@@ -27,75 +27,6 @@
 #include "aes_ccm.h"
 
 
-static int ieee80211_ioctl_siwfreq(struct net_device *dev,
-				   struct iw_request_info *info,
-				   struct iw_freq *freq, char *extra)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_channel *chan;
-
-	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
-		return cfg80211_ibss_wext_siwfreq(dev, info, freq, extra);
-	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		return cfg80211_mgd_wext_siwfreq(dev, info, freq, extra);
-
-	/* freq->e == 0: freq->m = channel; otherwise freq = m * 10^e */
-	if (freq->e == 0) {
-		if (freq->m < 0)
-			return -EINVAL;
-		else
-			chan = ieee80211_get_channel(local->hw.wiphy,
-				ieee80211_channel_to_frequency(freq->m));
-	} else {
-		int i, div = 1000000;
-		for (i = 0; i < freq->e; i++)
-			div /= 10;
-		if (div <= 0)
-			return -EINVAL;
-		chan = ieee80211_get_channel(local->hw.wiphy, freq->m / div);
-	}
-
-	if (!chan)
-		return -EINVAL;
-
-	if (chan->flags & IEEE80211_CHAN_DISABLED)
-		return -EINVAL;
-
-	/*
-	 * no change except maybe auto -> fixed, ignore the HT
-	 * setting so you can fix a channel you're on already
-	 */
-	if (local->oper_channel == chan)
-		return 0;
-
-	local->oper_channel = chan;
-	local->oper_channel_type = NL80211_CHAN_NO_HT;
-	ieee80211_hw_config(local, 0);
-
-	return 0;
-}
-
-
-static int ieee80211_ioctl_giwfreq(struct net_device *dev,
-				   struct iw_request_info *info,
-				   struct iw_freq *freq, char *extra)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
-		return cfg80211_ibss_wext_giwfreq(dev, info, freq, extra);
-	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		return cfg80211_mgd_wext_giwfreq(dev, info, freq, extra);
-
-	freq->m = local->oper_channel->center_freq;
-	freq->e = 6;
-
-	return 0;
-}
-
-
 static int ieee80211_ioctl_siwessid(struct net_device *dev,
 				    struct iw_request_info *info,
 				    struct iw_point *data, char *ssid)
@@ -173,8 +104,8 @@ static const iw_handler ieee80211_handle
 	(iw_handler) cfg80211_wext_giwname,		/* SIOCGIWNAME */
 	(iw_handler) NULL,				/* SIOCSIWNWID */
 	(iw_handler) NULL,				/* SIOCGIWNWID */
-	(iw_handler) ieee80211_ioctl_siwfreq,		/* SIOCSIWFREQ */
-	(iw_handler) ieee80211_ioctl_giwfreq,		/* SIOCGIWFREQ */
+	(iw_handler) cfg80211_wext_siwfreq,		/* SIOCSIWFREQ */
+	(iw_handler) cfg80211_wext_giwfreq,		/* SIOCGIWFREQ */
 	(iw_handler) cfg80211_wext_siwmode,		/* SIOCSIWMODE */
 	(iw_handler) cfg80211_wext_giwmode,		/* SIOCGIWMODE */
 	(iw_handler) NULL,				/* SIOCSIWSENS */
--- wireless-testing.orig/net/wireless/ibss.c	2009-07-24 13:21:08.000000000 +0200
+++ wireless-testing/net/wireless/ibss.c	2009-07-25 10:44:27.000000000 +0200
@@ -7,6 +7,7 @@
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 #include <net/cfg80211.h>
+#include "wext-compat.h"
 #include "nl80211.h"
 
 
@@ -312,8 +313,6 @@ int cfg80211_ibss_wext_siwfreq(struct ne
 
 	return err;
 }
-/* temporary symbol - mark GPL - in the future the handler won't be */
-EXPORT_SYMBOL_GPL(cfg80211_ibss_wext_siwfreq);
 
 int cfg80211_ibss_wext_giwfreq(struct net_device *dev,
 			       struct iw_request_info *info,
@@ -342,8 +341,6 @@ int cfg80211_ibss_wext_giwfreq(struct ne
 	/* no channel if not joining */
 	return -EINVAL;
 }
-/* temporary symbol - mark GPL - in the future the handler won't be */
-EXPORT_SYMBOL_GPL(cfg80211_ibss_wext_giwfreq);
 
 int cfg80211_ibss_wext_siwessid(struct net_device *dev,
 				struct iw_request_info *info,
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/wireless/wext-compat.h	2009-07-25 10:44:27.000000000 +0200
@@ -0,0 +1,21 @@
+#ifndef __WEXT_COMPAT
+#define __WEXT_COMPAT
+
+int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_freq *freq, char *extra);
+int cfg80211_ibss_wext_giwfreq(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_freq *freq, char *extra);
+
+int cfg80211_mgd_wext_siwfreq(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_freq *freq, char *extra);
+int cfg80211_mgd_wext_giwfreq(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_freq *freq, char *extra);
+
+struct ieee80211_channel *cfg80211_wext_freq(struct wiphy *wiphy,
+					     struct iw_freq *freq);
+
+#endif /* __WEXT_COMPAT */
--- wireless-testing.orig/net/wireless/wext-sme.c	2009-07-24 13:21:08.000000000 +0200
+++ wireless-testing/net/wireless/wext-sme.c	2009-07-25 10:44:27.000000000 +0200
@@ -8,6 +8,7 @@
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 #include <net/cfg80211.h>
+#include "wext-compat.h"
 #include "nl80211.h"
 
 int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
@@ -108,8 +109,6 @@ int cfg80211_mgd_wext_siwfreq(struct net
 	cfg80211_unlock_rdev(rdev);
 	return err;
 }
-/* temporary symbol - mark GPL - in the future the handler won't be */
-EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_siwfreq);
 
 int cfg80211_mgd_wext_giwfreq(struct net_device *dev,
 			      struct iw_request_info *info,
@@ -138,8 +137,6 @@ int cfg80211_mgd_wext_giwfreq(struct net
 	/* no channel if not joining */
 	return -EINVAL;
 }
-/* temporary symbol - mark GPL - in the future the handler won't be */
-EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_giwfreq);
 
 int cfg80211_mgd_wext_siwessid(struct net_device *dev,
 			       struct iw_request_info *info,
--- wireless-testing.orig/net/wireless/core.h	2009-07-25 10:40:04.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-07-25 10:44:27.000000000 +0200
@@ -66,6 +66,9 @@ struct cfg80211_registered_device {
 	struct work_struct conn_work;
 	struct work_struct event_work;
 
+	/* current channel */
+	struct ieee80211_channel *channel;
+
 #ifdef CONFIG_CFG80211_DEBUGFS
 	/* Debugfs entries */
 	struct wiphy_debugfsdentries {
--- wireless-testing.orig/net/wireless/nl80211.c	2009-07-25 10:40:04.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-07-25 10:44:27.000000000 +0200
@@ -757,6 +757,8 @@ static int nl80211_set_wiphy(struct sk_b
 						channel_type);
 		if (result)
 			goto bad_res;
+
+		rdev->channel = chan;
 	}
 
 	changed = 0;
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-07-25 10:40:04.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-07-25 10:44:27.000000000 +0200
@@ -14,6 +14,7 @@
 #include <linux/etherdevice.h>
 #include <net/iw_handler.h>
 #include <net/cfg80211.h>
+#include "wext-compat.h"
 #include "core.h"
 
 int cfg80211_wext_giwname(struct net_device *dev,
@@ -300,7 +301,6 @@ struct ieee80211_channel *cfg80211_wext_
 		return ERR_PTR(-EINVAL);
 	return chan;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_freq);
 
 int cfg80211_wext_siwrts(struct net_device *dev,
 			 struct iw_request_info *info,
@@ -759,6 +759,58 @@ int cfg80211_wext_giwencode(struct net_d
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_giwencode);
 
+int cfg80211_wext_siwfreq(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_freq *freq, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct ieee80211_channel *chan;
+	int err;
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_STATION:
+		return cfg80211_mgd_wext_siwfreq(dev, info, freq, extra);
+	case NL80211_IFTYPE_ADHOC:
+		return cfg80211_ibss_wext_siwfreq(dev, info, freq, extra);
+	default:
+		chan = cfg80211_wext_freq(wdev->wiphy, freq);
+		if (!chan)
+			return -EINVAL;
+		if (IS_ERR(chan))
+			return PTR_ERR(chan);
+		err = rdev->ops->set_channel(wdev->wiphy, chan,
+					     NL80211_CHAN_NO_HT);
+		if (err)
+			return err;
+		rdev->channel = chan;
+		return 0;
+	}
+}
+EXPORT_SYMBOL_GPL(cfg80211_wext_siwfreq);
+
+int cfg80211_wext_giwfreq(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_freq *freq, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_STATION:
+		return cfg80211_mgd_wext_giwfreq(dev, info, freq, extra);
+	case NL80211_IFTYPE_ADHOC:
+		return cfg80211_ibss_wext_giwfreq(dev, info, freq, extra);
+	default:
+		if (!rdev->channel)
+			return -EINVAL;
+		freq->m = rdev->channel->center_freq;
+		freq->e = 6;
+		return 0;
+	}
+}
+EXPORT_SYMBOL_GPL(cfg80211_wext_giwfreq);
+
 int cfg80211_wext_siwtxpower(struct net_device *dev,
 			     struct iw_request_info *info,
 			     union iwreq_data *data, char *extra)
--- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/wext.c	2009-07-24 13:21:08.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwmc3200wifi/wext.c	2009-07-25 10:44:27.000000000 +0200
@@ -27,36 +27,6 @@
 #include "iwm.h"
 #include "commands.h"
 
-static int iwm_wext_siwfreq(struct net_device *dev,
-			    struct iw_request_info *info,
-			    struct iw_freq *freq, char *extra)
-{
-	struct iwm_priv *iwm = ndev_to_iwm(dev);
-
-	switch (iwm->conf.mode) {
-	case UMAC_MODE_IBSS:
-		return cfg80211_ibss_wext_siwfreq(dev, info, freq, extra);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-static int iwm_wext_giwfreq(struct net_device *dev,
-			    struct iw_request_info *info,
-			    struct iw_freq *freq, char *extra)
-{
-	struct iwm_priv *iwm = ndev_to_iwm(dev);
-
-	switch (iwm->conf.mode) {
-	case UMAC_MODE_IBSS:
-		return cfg80211_ibss_wext_giwfreq(dev, info, freq, extra);
-	case UMAC_MODE_BSS:
-		return cfg80211_mgd_wext_giwfreq(dev, info, freq, extra);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int iwm_wext_siwap(struct net_device *dev, struct iw_request_info *info,
 			  struct sockaddr *ap_addr, char *extra)
 {
@@ -125,8 +95,8 @@ static const iw_handler iwm_handlers[] =
 	(iw_handler) cfg80211_wext_giwname,		/* SIOCGIWNAME */
 	(iw_handler) NULL,				/* SIOCSIWNWID */
 	(iw_handler) NULL,				/* SIOCGIWNWID */
-	(iw_handler) iwm_wext_siwfreq,			/* SIOCSIWFREQ */
-	(iw_handler) iwm_wext_giwfreq,			/* SIOCGIWFREQ */
+	(iw_handler) cfg80211_wext_siwfreq,		/* SIOCSIWFREQ */
+	(iw_handler) cfg80211_wext_giwfreq,		/* SIOCGIWFREQ */
 	(iw_handler) cfg80211_wext_siwmode,		/* SIOCSIWMODE */
 	(iw_handler) cfg80211_wext_giwmode,		/* SIOCGIWMODE */
 	(iw_handler) NULL,				/* SIOCSIWSENS */

-- 

