Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54780 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821AbZHGMui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 08:50:38 -0400
Subject: [PATCH v2] cfg80211: validate channel settings across interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1249649261.4215.7.camel@johannes.local>
References: <1249649261.4215.7.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 14:50:33 +0200
Message-Id: <1249649433.7194.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, there's a problem that affects regulatory
enforcement and connection stability, in that it is
possible to switch the channel while connected to a
network or joined to an IBSS.

The problem comes from the fact that we only validate
the channel against the current interface's type, not
against any other interface. Thus, you have any type
of interface up, additionally bring up a monitor mode
interface and switch the channel on the monitor. This
will obviously also switch the channel on the other
interface.

The problem now is that if you do that while sending
beacons for IBSS mode, you can switch to a disabled
channel or a channel that doesn't allow beaconing.
Combined with a managed mode interface connected to
an AP instead of an IBSS interface, you can easily
break the connection that way.

To fix this, this patch validates any channel change
with all available interfaces, and disallows such
changes on secondary interfaces if another interface
is connected to an AP or joined to an IBSS.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Oops, sorry, now based on the right tree.

 net/wireless/Makefile      |    3 +
 net/wireless/chan.c        |   88 +++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/core.h        |    6 +++
 net/wireless/ibss.c        |   37 +++++++++++++-----
 net/wireless/nl80211.c     |   49 ++++---------------------
 net/wireless/sme.c         |    5 ++
 net/wireless/wext-compat.c |   55 +++++++++-------------------
 net/wireless/wext-compat.h |    3 -
 net/wireless/wext-sme.c    |   30 ++++++++-------
 9 files changed, 171 insertions(+), 105 deletions(-)

--- wireless-testing.orig/net/wireless/Makefile	2009-08-07 14:47:50.000000000 +0200
+++ wireless-testing/net/wireless/Makefile	2009-08-07 14:47:53.000000000 +0200
@@ -5,7 +5,8 @@ obj-$(CONFIG_LIB80211_CRYPT_WEP) += lib8
 obj-$(CONFIG_LIB80211_CRYPT_CCMP) += lib80211_crypt_ccmp.o
 obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib80211_crypt_tkip.o
 
-cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o mlme.o ibss.o sme.o
+cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o
+cfg80211-y += mlme.o ibss.o sme.o chan.o
 cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
 cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o wext-sme.o
 
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/wireless/chan.c	2009-08-07 14:47:53.000000000 +0200
@@ -0,0 +1,88 @@
+/*
+ * This file contains helper code to handle channel
+ * settings and keeping track of what is possible at
+ * any point in time.
+ *
+ * Copyright 2009	Johannes Berg <johannes@sipsolutions.net>
+ */
+
+#include <net/cfg80211.h>
+#include "core.h"
+
+struct ieee80211_channel *
+rdev_fixed_channel(struct cfg80211_registered_device *rdev,
+		   struct wireless_dev *for_wdev)
+{
+	struct wireless_dev *wdev;
+	struct ieee80211_channel *result = NULL;
+
+	ASSERT_RDEV_LOCK(rdev);
+
+	list_for_each_entry(wdev, &rdev->netdev_list, list) {
+		if (wdev == for_wdev)
+			continue;
+
+		/*
+		 * Lock manually to tell lockdep about allowed
+		 * nesting here if for_wdev->mtx is held already.
+		 * This is ok as it's all under rdev lock and
+		 * as such can only be done once at any given
+		 * time.
+		 */
+		mutex_lock_nested(&wdev->mtx, 1);
+		if (wdev->current_bss)
+			result = wdev->current_bss->pub.channel;
+		wdev_unlock(wdev);
+
+		if (result)
+			break;
+	}
+
+	return result;
+}
+
+int rdev_set_freq(struct cfg80211_registered_device *rdev,
+		  int freq, enum nl80211_channel_type channel_type)
+{
+	struct ieee80211_channel *chan;
+	struct ieee80211_sta_ht_cap *ht_cap;
+	int result;
+
+	if (rdev_fixed_channel(rdev, NULL))
+		return -EINVAL;
+
+	if (!rdev->ops->set_channel)
+		return -EOPNOTSUPP;
+
+	chan = ieee80211_get_channel(&rdev->wiphy, freq);
+
+	/* Primary channel not allowed */
+	if (!chan || chan->flags & IEEE80211_CHAN_DISABLED)
+		return -EINVAL;
+
+	if (channel_type == NL80211_CHAN_HT40MINUS &&
+	    chan->flags & IEEE80211_CHAN_NO_HT40MINUS)
+		return -EINVAL;
+	else if (channel_type == NL80211_CHAN_HT40PLUS &&
+		 chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
+		return -EINVAL;
+
+	ht_cap = &rdev->wiphy.bands[chan->band]->ht_cap;
+
+	if (channel_type != NL80211_CHAN_NO_HT) {
+		if (!ht_cap->ht_supported)
+			return -EINVAL;
+
+		if (!(ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) ||
+		    ht_cap->cap & IEEE80211_HT_CAP_40MHZ_INTOLERANT)
+			return -EINVAL;
+	}
+
+	result = rdev->ops->set_channel(&rdev->wiphy, chan, channel_type);
+	if (result)
+		return result;
+
+	rdev->channel = chan;
+
+	return 0;
+}
--- wireless-testing.orig/net/wireless/core.h	2009-08-07 14:47:52.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-08-07 14:50:05.000000000 +0200
@@ -366,4 +366,10 @@ void cfg80211_sme_disassoc(struct net_de
 void __cfg80211_scan_done(struct work_struct *wk);
 void cfg80211_upload_connect_keys(struct wireless_dev *wdev);
 
+struct ieee80211_channel *
+rdev_fixed_channel(struct cfg80211_registered_device *rdev,
+		   struct wireless_dev *for_wdev);
+int rdev_set_freq(struct cfg80211_registered_device *rdev,
+		  int freq, enum nl80211_channel_type channel_type);
+
 #endif /* __NET_WIRELESS_CORE_H */
--- wireless-testing.orig/net/wireless/nl80211.c	2009-08-07 14:47:50.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-08-07 14:47:53.000000000 +0200
@@ -701,15 +701,8 @@ static int nl80211_set_wiphy(struct sk_b
 
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
 		enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
-		struct ieee80211_channel *chan;
-		struct ieee80211_sta_ht_cap *ht_cap;
 		u32 freq;
 
-		if (!rdev->ops->set_channel) {
-			result = -EOPNOTSUPP;
-			goto bad_res;
-		}
-
 		result = -EINVAL;
 
 		if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
@@ -723,42 +716,10 @@ static int nl80211_set_wiphy(struct sk_b
 		}
 
 		freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
-		chan = ieee80211_get_channel(&rdev->wiphy, freq);
-
-		/* Primary channel not allowed */
-		if (!chan || chan->flags & IEEE80211_CHAN_DISABLED)
-			goto bad_res;
-
-		if (channel_type == NL80211_CHAN_HT40MINUS &&
-		    (chan->flags & IEEE80211_CHAN_NO_HT40MINUS))
-			goto bad_res;
-		else if (channel_type == NL80211_CHAN_HT40PLUS &&
-			 (chan->flags & IEEE80211_CHAN_NO_HT40PLUS))
-			goto bad_res;
-
-		/*
-		 * At this point we know if that if HT40 was requested
-		 * we are allowed to use it and the extension channel
-		 * exists.
-		 */
 
-		ht_cap = &rdev->wiphy.bands[chan->band]->ht_cap;
-
-		/* no HT capabilities or intolerant */
-		if (channel_type != NL80211_CHAN_NO_HT) {
-			if (!ht_cap->ht_supported)
-				goto bad_res;
-			if (!(ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) ||
-			    (ht_cap->cap & IEEE80211_HT_CAP_40MHZ_INTOLERANT))
-				goto bad_res;
-		}
-
-		result = rdev->ops->set_channel(&rdev->wiphy, chan,
-						channel_type);
+		result = rdev_set_freq(rdev, freq, channel_type);
 		if (result)
 			goto bad_res;
-
-		rdev->channel = chan;
 	}
 
 	changed = 0;
@@ -3453,7 +3414,7 @@ static int nl80211_associate(struct sk_b
 	struct cfg80211_registered_device *rdev;
 	struct net_device *dev;
 	struct cfg80211_crypto_settings crypto;
-	struct ieee80211_channel *chan;
+	struct ieee80211_channel *chan, *fixedchan;
 	const u8 *bssid, *ssid, *ie = NULL, *prev_bssid = NULL;
 	int err, ssid_len, ie_len = 0;
 	bool use_mfp = false;
@@ -3496,6 +3457,12 @@ static int nl80211_associate(struct sk_b
 		goto out;
 	}
 
+	fixedchan = rdev_fixed_channel(rdev, NULL);
+	if (fixedchan && chan != fixedchan) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
 	ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
 
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-08-07 14:47:50.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-08-07 14:47:53.000000000 +0200
@@ -267,39 +267,26 @@ EXPORT_SYMBOL_GPL(cfg80211_wext_giwrange
  * @wiphy: the wiphy
  * @freq: the wext freq encoding
  *
- * Returns a channel, %NULL for auto, or an ERR_PTR for errors!
+ * Returns a frequency, or a negative error code, or 0 for auto.
  */
-struct ieee80211_channel *cfg80211_wext_freq(struct wiphy *wiphy,
-					     struct iw_freq *freq)
+int cfg80211_wext_freq(struct wiphy *wiphy, struct iw_freq *freq)
 {
-	struct ieee80211_channel *chan;
-	int f;
-
 	/*
-	 * Parse frequency - return NULL for auto and
+	 * Parse frequency - return 0 for auto and
 	 * -EINVAL for impossible things.
 	 */
 	if (freq->e == 0) {
 		if (freq->m < 0)
-			return NULL;
-		f = ieee80211_channel_to_frequency(freq->m);
+			return 0;
+		return ieee80211_channel_to_frequency(freq->m);
 	} else {
 		int i, div = 1000000;
 		for (i = 0; i < freq->e; i++)
 			div /= 10;
 		if (div <= 0)
-			return ERR_PTR(-EINVAL);
-		f = freq->m / div;
+			return -EINVAL;
+		return freq->m / div;
 	}
-
-	/*
-	 * Look up channel struct and return -EINVAL when
-	 * it cannot be found.
-	 */
-	chan = ieee80211_get_channel(wiphy, f);
-	if (!chan)
-		return ERR_PTR(-EINVAL);
-	return chan;
 }
 
 int cfg80211_wext_siwrts(struct net_device *dev,
@@ -761,33 +748,29 @@ EXPORT_SYMBOL_GPL(cfg80211_wext_giwencod
 
 int cfg80211_wext_siwfreq(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_freq *freq, char *extra)
+			  struct iw_freq *wextfreq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
-	struct ieee80211_channel *chan;
-	int err;
+	int freq, err;
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_STATION:
-		return cfg80211_mgd_wext_siwfreq(dev, info, freq, extra);
+		return cfg80211_mgd_wext_siwfreq(dev, info, wextfreq, extra);
 	case NL80211_IFTYPE_ADHOC:
-		return cfg80211_ibss_wext_siwfreq(dev, info, freq, extra);
+		return cfg80211_ibss_wext_siwfreq(dev, info, wextfreq, extra);
 	default:
-		chan = cfg80211_wext_freq(wdev->wiphy, freq);
-		if (!chan)
+		freq = cfg80211_wext_freq(wdev->wiphy, wextfreq);
+		if (freq < 0)
+			return freq;
+		if (freq == 0)
 			return -EINVAL;
-		if (IS_ERR(chan))
-			return PTR_ERR(chan);
-		err = rdev->ops->set_channel(wdev->wiphy, chan,
-					     NL80211_CHAN_NO_HT);
-		if (err)
-			return err;
-		rdev->channel = chan;
-		return 0;
+		cfg80211_lock_rdev(rdev);
+		err = rdev_set_freq(rdev, freq, NL80211_CHAN_NO_HT);
+		cfg80211_unlock_rdev(rdev);
+		return err;
 	}
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwfreq);
 
 int cfg80211_wext_giwfreq(struct net_device *dev,
 			  struct iw_request_info *info,
--- wireless-testing.orig/net/wireless/wext-compat.h	2009-08-07 14:47:50.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.h	2009-08-07 14:47:53.000000000 +0200
@@ -42,8 +42,7 @@ int cfg80211_mgd_wext_giwessid(struct ne
 			       struct iw_request_info *info,
 			       struct iw_point *data, char *ssid);
 
-struct ieee80211_channel *cfg80211_wext_freq(struct wiphy *wiphy,
-					     struct iw_freq *freq);
+int cfg80211_wext_freq(struct wiphy *wiphy, struct iw_freq *freq);
 
 
 extern const struct iw_handler_def cfg80211_wext_handler;
--- wireless-testing.orig/net/wireless/ibss.c	2009-08-07 14:47:50.000000000 +0200
+++ wireless-testing/net/wireless/ibss.c	2009-08-07 14:47:53.000000000 +0200
@@ -78,10 +78,15 @@ int __cfg80211_join_ibss(struct cfg80211
 			 struct cfg80211_cached_keys *connkeys)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct ieee80211_channel *chan;
 	int err;
 
 	ASSERT_WDEV_LOCK(wdev);
 
+	chan = rdev_fixed_channel(rdev, wdev);
+	if (chan && chan != params->channel)
+		return -EINVAL;
+
 	if (wdev->ssid_len)
 		return -EALREADY;
 
@@ -264,11 +269,11 @@ int cfg80211_ibss_wext_join(struct cfg80
 
 int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
 			       struct iw_request_info *info,
-			       struct iw_freq *freq, char *extra)
+			       struct iw_freq *wextfreq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct ieee80211_channel *chan;
-	int err;
+	struct ieee80211_channel *chan = NULL;
+	int err, freq;
 
 	/* call only for ibss! */
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_ADHOC))
@@ -277,14 +282,18 @@ int cfg80211_ibss_wext_siwfreq(struct ne
 	if (!wiphy_to_dev(wdev->wiphy)->ops->join_ibss)
 		return -EOPNOTSUPP;
 
-	chan = cfg80211_wext_freq(wdev->wiphy, freq);
-	if (chan && IS_ERR(chan))
-		return PTR_ERR(chan);
-
-	if (chan &&
-	    (chan->flags & IEEE80211_CHAN_NO_IBSS ||
-	     chan->flags & IEEE80211_CHAN_DISABLED))
-		return -EINVAL;
+	freq = cfg80211_wext_freq(wdev->wiphy, wextfreq);
+	if (freq < 0)
+		return freq;
+
+	if (freq) {
+		chan = ieee80211_get_channel(wdev->wiphy, freq);
+		if (!chan)
+			return -EINVAL;
+		if (chan->flags & IEEE80211_CHAN_NO_IBSS ||
+		    chan->flags & IEEE80211_CHAN_DISABLED)
+			return -EINVAL;
+	}
 
 	if (wdev->wext.ibss.channel == chan)
 		return 0;
@@ -307,9 +316,11 @@ int cfg80211_ibss_wext_siwfreq(struct ne
 		wdev->wext.ibss.channel_fixed = false;
 	}
 
+	cfg80211_lock_rdev(wiphy_to_dev(wdev->wiphy));
 	wdev_lock(wdev);
 	err = cfg80211_ibss_wext_join(wiphy_to_dev(wdev->wiphy), wdev);
 	wdev_unlock(wdev);
+	cfg80211_unlock_rdev(wiphy_to_dev(wdev->wiphy));
 
 	return err;
 }
@@ -375,9 +386,11 @@ int cfg80211_ibss_wext_siwessid(struct n
 	memcpy(wdev->wext.ibss.ssid, ssid, len);
 	wdev->wext.ibss.ssid_len = len;
 
+	cfg80211_lock_rdev(wiphy_to_dev(wdev->wiphy));
 	wdev_lock(wdev);
 	err = cfg80211_ibss_wext_join(wiphy_to_dev(wdev->wiphy), wdev);
 	wdev_unlock(wdev);
+	cfg80211_unlock_rdev(wiphy_to_dev(wdev->wiphy));
 
 	return err;
 }
@@ -456,9 +469,11 @@ int cfg80211_ibss_wext_siwap(struct net_
 	} else
 		wdev->wext.ibss.bssid = NULL;
 
+	cfg80211_lock_rdev(wiphy_to_dev(wdev->wiphy));
 	wdev_lock(wdev);
 	err = cfg80211_ibss_wext_join(wiphy_to_dev(wdev->wiphy), wdev);
 	wdev_unlock(wdev);
+	cfg80211_unlock_rdev(wiphy_to_dev(wdev->wiphy));
 
 	return err;
 }
--- wireless-testing.orig/net/wireless/wext-sme.c	2009-08-07 14:47:51.000000000 +0200
+++ wireless-testing/net/wireless/wext-sme.c	2009-08-07 14:50:05.000000000 +0200
@@ -52,23 +52,28 @@ int cfg80211_mgd_wext_connect(struct cfg
 
 int cfg80211_mgd_wext_siwfreq(struct net_device *dev,
 			      struct iw_request_info *info,
-			      struct iw_freq *freq, char *extra)
+			      struct iw_freq *wextfreq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
-	struct ieee80211_channel *chan;
-	int err;
+	struct ieee80211_channel *chan = NULL;
+	int err, freq;
 
 	/* call only for station! */
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
 		return -EINVAL;
 
-	chan = cfg80211_wext_freq(wdev->wiphy, freq);
-	if (chan && IS_ERR(chan))
-		return PTR_ERR(chan);
-
-	if (chan && (chan->flags & IEEE80211_CHAN_DISABLED))
-		return -EINVAL;
+	freq = cfg80211_wext_freq(wdev->wiphy, wextfreq);
+	if (freq < 0)
+		return freq;
+
+	if (freq) {
+		chan = ieee80211_get_channel(wdev->wiphy, freq);
+		if (!chan)
+			return -EINVAL;
+		if (chan->flags & IEEE80211_CHAN_DISABLED)
+			return -EINVAL;
+	}
 
 	cfg80211_lock_rdev(rdev);
 	wdev_lock(wdev);
@@ -95,11 +100,8 @@ int cfg80211_mgd_wext_siwfreq(struct net
 	wdev->wext.connect.channel = chan;
 
 	/* SSID is not set, we just want to switch channel */
-	if (wdev->wext.connect.ssid_len && chan) {
-		err = -EOPNOTSUPP;
-		if (rdev->ops->set_channel)
-			err = rdev->ops->set_channel(wdev->wiphy, chan,
-						     NL80211_CHAN_NO_HT);
+	if (chan && !wdev->wext.connect.ssid_len) {
+		err = rdev_set_freq(rdev, freq, NL80211_CHAN_NO_HT);
 		goto out;
 	}
 
--- wireless-testing.orig/net/wireless/sme.c	2009-08-07 14:47:51.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-08-07 14:50:05.000000000 +0200
@@ -644,6 +644,7 @@ int __cfg80211_connect(struct cfg80211_r
 		       struct cfg80211_cached_keys *connkeys)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct ieee80211_channel *chan;
 	int err;
 
 	ASSERT_WDEV_LOCK(wdev);
@@ -651,6 +652,10 @@ int __cfg80211_connect(struct cfg80211_r
 	if (wdev->sme_state != CFG80211_SME_IDLE)
 		return -EALREADY;
 
+	chan = rdev_fixed_channel(rdev, wdev);
+	if (chan && chan != connect->channel)
+		return -EINVAL;
+
 	if (WARN_ON(wdev->connect_keys)) {
 		kfree(wdev->connect_keys);
 		wdev->connect_keys = NULL;


