Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35394 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbZFXMJ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 08:09:59 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1MJRId-000309-Ud
	for linux-wireless@vger.kernel.org; Wed, 24 Jun 2009 14:10:01 +0200
Message-Id: <20090624120809.815624423@sipsolutions.net>
References: <20090624120745.239294066@sipsolutions.net>
Date: Wed, 24 Jun 2009 14:07:53 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 08/11] cfg80211: combine iwfreq implementations
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Until now we implemented iwfreq for managed mode, we
needed to keep the implementations separate, but now
that we have all versions implemented we can combine
them and export just one handler.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |   20 +++--------
 net/mac80211/wext.c        |   76 +--------------------------------------------
 net/wireless/core.h        |    3 +
 net/wireless/ibss.c        |    5 --
 net/wireless/nl80211.c     |    2 +
 net/wireless/wext-compat.c |   54 +++++++++++++++++++++++++++++++
 net/wireless/wext-compat.h |   21 ++++++++++++
 net/wireless/wext-sme.c    |    5 --
 8 files changed, 89 insertions(+), 97 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-06-24 13:54:09.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-06-24 13:54:09.000000000 +0200
@@ -1524,12 +1524,6 @@ int cfg80211_wext_siwmlme(struct net_dev
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
@@ -1543,12 +1537,6 @@ int cfg80211_ibss_wext_giwap(struct net_
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
@@ -1571,8 +1559,12 @@ int cfg80211_wext_giwauth(struct net_dev
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
--- wireless-testing.orig/net/mac80211/wext.c	2009-06-24 13:54:09.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-06-24 13:54:09.000000000 +0200
@@ -27,78 +27,6 @@
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
-		if (freq->m < 0) {
-			if (sdata->vif.type == NL80211_IFTYPE_STATION)
-				sdata->u.mgd.flags |=
-					IEEE80211_STA_AUTO_CHANNEL_SEL;
-			return 0;
-		} else
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
@@ -176,8 +104,8 @@ static const iw_handler ieee80211_handle
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
--- wireless-testing.orig/net/wireless/ibss.c	2009-06-24 13:54:05.000000000 +0200
+++ wireless-testing/net/wireless/ibss.c	2009-06-24 13:54:09.000000000 +0200
@@ -7,6 +7,7 @@
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 #include <net/cfg80211.h>
+#include "wext-compat.h"
 #include "nl80211.h"
 
 
@@ -197,8 +198,6 @@ int cfg80211_ibss_wext_siwfreq(struct ne
 
 	return cfg80211_ibss_wext_join(wiphy_to_dev(wdev->wiphy), wdev);
 }
-/* temporary symbol - mark GPL - in the future the handler won't be */
-EXPORT_SYMBOL_GPL(cfg80211_ibss_wext_siwfreq);
 
 int cfg80211_ibss_wext_giwfreq(struct net_device *dev,
 			       struct iw_request_info *info,
@@ -225,8 +224,6 @@ int cfg80211_ibss_wext_giwfreq(struct ne
 	/* no channel if not joining */
 	return -EINVAL;
 }
-/* temporary symbol - mark GPL - in the future the handler won't be */
-EXPORT_SYMBOL_GPL(cfg80211_ibss_wext_giwfreq);
 
 int cfg80211_ibss_wext_siwessid(struct net_device *dev,
 				struct iw_request_info *info,
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/wireless/wext-compat.h	2009-06-24 13:54:09.000000000 +0200
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
--- wireless-testing.orig/net/wireless/wext-sme.c	2009-06-24 13:54:06.000000000 +0200
+++ wireless-testing/net/wireless/wext-sme.c	2009-06-24 13:54:09.000000000 +0200
@@ -8,6 +8,7 @@
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 #include <net/cfg80211.h>
+#include "wext-compat.h"
 #include "nl80211.h"
 
 static int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
@@ -78,8 +79,6 @@ int cfg80211_mgd_wext_siwfreq(struct net
 
 	return cfg80211_mgd_wext_connect(wiphy_to_dev(wdev->wiphy), wdev);
 }
-/* temporary symbol - mark GPL - in the future the handler won't be */
-EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_siwfreq);
 
 int cfg80211_mgd_wext_giwfreq(struct net_device *dev,
 			      struct iw_request_info *info,
@@ -106,8 +105,6 @@ int cfg80211_mgd_wext_giwfreq(struct net
 	/* no channel if not joining */
 	return -EINVAL;
 }
-/* temporary symbol - mark GPL - in the future the handler won't be */
-EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_giwfreq);
 
 int cfg80211_mgd_wext_siwessid(struct net_device *dev,
 			       struct iw_request_info *info,
--- wireless-testing.orig/net/wireless/core.h	2009-06-24 13:54:06.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-06-24 13:54:09.000000000 +0200
@@ -60,6 +60,9 @@ struct cfg80211_registered_device {
 
 	struct work_struct conn_work;
 
+	/* current channel */
+	struct ieee80211_channel *channel;
+
 #ifdef CONFIG_CFG80211_DEBUGFS
 	/* Debugfs entries */
 	struct wiphy_debugfsdentries {
--- wireless-testing.orig/net/wireless/nl80211.c	2009-06-24 13:54:06.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-06-24 13:54:09.000000000 +0200
@@ -559,6 +559,8 @@ static int nl80211_set_wiphy(struct sk_b
 						channel_type);
 		if (result)
 			goto bad_res;
+
+		rdev->channel = chan;
 	}
 
 	changed = 0;
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-06-24 13:54:09.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-06-24 13:54:09.000000000 +0200
@@ -14,6 +14,7 @@
 #include <linux/etherdevice.h>
 #include <net/iw_handler.h>
 #include <net/cfg80211.h>
+#include "wext-compat.h"
 #include "core.h"
 
 int cfg80211_wext_giwname(struct net_device *dev,
@@ -301,7 +302,6 @@ struct ieee80211_channel *cfg80211_wext_
 		return ERR_PTR(-EINVAL);
 	return chan;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_freq);
 
 int cfg80211_wext_siwrts(struct net_device *dev,
 			 struct iw_request_info *info,
@@ -720,6 +720,58 @@ int cfg80211_wext_giwencode(struct net_d
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

-- 

