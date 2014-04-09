Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:48204 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbaDIB2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 21:28:48 -0400
Received: by mail-pa0-f51.google.com with SMTP id kq14so1810030pab.38
        for <linux-wireless@vger.kernel.org>; Tue, 08 Apr 2014 18:28:48 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 1/8] cfg80211: fix possible compile warning in wext-compat.h
Date: Wed,  9 Apr 2014 09:28:06 +0800
Message-Id: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com> (sfid-20140409_032853_081054_476FA7D1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Function cfg80211_wext_freq() is declared in wext-compat.h, but its
parameter struct wiphy's declaration is not included there. Actually
the parameter is not used in this function, so change it to normal
net_device.

The compile warning doesn't show up due to duplicate including, but
it's worth fixing it.

net/wireless/wext-compat.h:53:52: warning: ‘struct wiphy’ declared inside parameter list [enabled by default]
 int cfg80211_wext_freq(struct wiphy *wiphy, struct iw_freq *freq);
                                                    ^
net/wireless/wext-compat.h:53:52: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/wireless/ibss.c        | 2 +-
 net/wireless/scan.c        | 6 +++++-
 net/wireless/wext-compat.c | 8 ++++----
 net/wireless/wext-compat.h | 2 +-
 net/wireless/wext-sme.c    | 2 +-
 5 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 071e99c..407f413 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -322,7 +322,7 @@ int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
 	if (!rdev->ops->join_ibss)
 		return -EOPNOTSUPP;
 
-	freq = cfg80211_wext_freq(wdev->wiphy, wextfreq);
+	freq = cfg80211_wext_freq(dev, wextfreq);
 	if (freq < 0)
 		return freq;
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 7d09a71..d526d65 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1147,7 +1147,11 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 				int k;
 				int wiphy_freq = wiphy->bands[band]->channels[j].center_freq;
 				for (k = 0; k < wreq->num_channels; k++) {
-					int wext_freq = cfg80211_wext_freq(wiphy, &wreq->channel_list[k]);
+					struct iw_freq *freq =
+						&wreq->channel_list[k];
+
+					int wext_freq =
+						cfg80211_wext_freq(dev, freq);
 					if (wext_freq == wiphy_freq)
 						goto wext_freq_found;
 				}
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 5661a54..9984d2f 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -253,12 +253,12 @@ EXPORT_SYMBOL_GPL(cfg80211_wext_giwrange);
 
 /**
  * cfg80211_wext_freq - get wext frequency for non-"auto"
- * @wiphy: the wiphy
+ * @dev: the net device
  * @freq: the wext freq encoding
  *
  * Returns a frequency, or a negative error code, or 0 for auto.
  */
-int cfg80211_wext_freq(struct wiphy *wiphy, struct iw_freq *freq)
+int cfg80211_wext_freq(struct net_device *dev, struct iw_freq *freq)
 {
 	/*
 	 * Parse frequency - return 0 for auto and
@@ -787,7 +787,7 @@ static int cfg80211_wext_siwfreq(struct net_device *dev,
 	case NL80211_IFTYPE_ADHOC:
 		return cfg80211_ibss_wext_siwfreq(dev, info, wextfreq, extra);
 	case NL80211_IFTYPE_MONITOR:
-		freq = cfg80211_wext_freq(wdev->wiphy, wextfreq);
+		freq = cfg80211_wext_freq(dev, wextfreq);
 		if (freq < 0)
 			return freq;
 		if (freq == 0)
@@ -798,7 +798,7 @@ static int cfg80211_wext_siwfreq(struct net_device *dev,
 			return -EINVAL;
 		return cfg80211_set_monitor_channel(rdev, &chandef);
 	case NL80211_IFTYPE_MESH_POINT:
-		freq = cfg80211_wext_freq(wdev->wiphy, wextfreq);
+		freq = cfg80211_wext_freq(dev, wextfreq);
 		if (freq < 0)
 			return freq;
 		if (freq == 0)
diff --git a/net/wireless/wext-compat.h b/net/wireless/wext-compat.h
index 5d766b0..bd6aa81 100644
--- a/net/wireless/wext-compat.h
+++ b/net/wireless/wext-compat.h
@@ -50,7 +50,7 @@ int cfg80211_wext_siwgenie(struct net_device *dev,
 			   struct iw_point *data, char *extra);
 
 
-int cfg80211_wext_freq(struct wiphy *wiphy, struct iw_freq *freq);
+int cfg80211_wext_freq(struct net_device *dev, struct iw_freq *freq);
 
 
 extern const struct iw_handler_def cfg80211_wext_handler;
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index 86c331a..765e37b 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -75,7 +75,7 @@ int cfg80211_mgd_wext_siwfreq(struct net_device *dev,
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
 		return -EINVAL;
 
-	freq = cfg80211_wext_freq(wdev->wiphy, wextfreq);
+	freq = cfg80211_wext_freq(dev, wextfreq);
 	if (freq < 0)
 		return freq;
 
-- 
1.9.0

