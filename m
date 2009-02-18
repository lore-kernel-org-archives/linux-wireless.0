Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49284 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbZBRScl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 13:32:41 -0500
Subject: [PATCH] mac80211/cfg80211: move iwrange handler to cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 19:32:08 +0100
Message-Id: <1234981928.4023.42.camel@johannes.local> (sfid-20090218_193254_186343_BECB185A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The previous patch made cfg80211 generally aware of the signal
type a given hardware will give, so now it can implement
SIOCGIWRANGE itself, removing more wext stuff from mac80211.
Might need to be a little more parametrized once we have
more hardware using cfg80211 and new hardware capabilities.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |    3 +
 net/mac80211/wext.c        |  135 +++++----------------------------------------
 net/wireless/wext-compat.c |   97 ++++++++++++++++++++++++++++++++
 3 files changed, 116 insertions(+), 119 deletions(-)

--- wireless-testing.orig/net/mac80211/wext.c	2009-02-18 18:46:48.000000000 +0100
+++ wireless-testing/net/mac80211/wext.c	2009-02-18 18:47:56.000000000 +0100
@@ -144,124 +144,6 @@ static int ieee80211_ioctl_siwgenie(stru
 	return -EOPNOTSUPP;
 }
 
-static u8 ieee80211_get_wstats_flags(struct ieee80211_local *local)
-{
-	u8 wstats_flags = 0;
-
-	wstats_flags |= local->hw.flags & (IEEE80211_HW_SIGNAL_UNSPEC |
-					   IEEE80211_HW_SIGNAL_DBM) ?
-				IW_QUAL_QUAL_UPDATED : IW_QUAL_QUAL_INVALID;
-	wstats_flags |= local->hw.flags & IEEE80211_HW_NOISE_DBM ?
-				IW_QUAL_NOISE_UPDATED : IW_QUAL_NOISE_INVALID;
-	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
-		wstats_flags |= IW_QUAL_DBM;
-
-	return wstats_flags;
-}
-
-static int ieee80211_ioctl_giwrange(struct net_device *dev,
-				 struct iw_request_info *info,
-				 struct iw_point *data, char *extra)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct iw_range *range = (struct iw_range *) extra;
-	enum ieee80211_band band;
-	int c = 0;
-
-	data->length = sizeof(struct iw_range);
-	memset(range, 0, sizeof(struct iw_range));
-
-	range->we_version_compiled = WIRELESS_EXT;
-	range->we_version_source = 21;
-	range->retry_capa = IW_RETRY_LIMIT;
-	range->retry_flags = IW_RETRY_LIMIT;
-	range->min_retry = 0;
-	range->max_retry = 255;
-	range->min_rts = 0;
-	range->max_rts = 2347;
-	range->min_frag = 256;
-	range->max_frag = 2346;
-
-	range->encoding_size[0] = 5;
-	range->encoding_size[1] = 13;
-	range->num_encoding_sizes = 2;
-	range->max_encoding_tokens = NUM_DEFAULT_KEYS;
-
-	/* cfg80211 requires this, and enforces 0..100 */
-	if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
-		range->max_qual.level = 100;
-	else if  (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
-		range->max_qual.level = -110;
-	else
-		range->max_qual.level = 0;
-
-	if (local->hw.flags & IEEE80211_HW_NOISE_DBM)
-		range->max_qual.noise = -110;
-	else
-		range->max_qual.noise = 0;
-
-	range->max_qual.updated = ieee80211_get_wstats_flags(local);
-
-	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
-		/*
-		 * cfg80211 assumes -110 to -40 dBm and clamps to that range
-		 * for qual.qual, so tell userspace this is what we give it
-		 * but take into account that we have to start from 0.
-		 */
-		range->max_qual.qual = 70;
-		range->avg_qual.qual = 35;
-	} else {
-		/*
-		 * cfg80211 just uses the level value for qual too, and it
-		 * requires the level value to be 0 .. 100.
-		 */
-		range->max_qual.qual = 100;
-		range->avg_qual.qual = 50;
-	}
-	/* not always true but better than nothing */
-	range->avg_qual.level = range->max_qual.level / 2;
-	range->avg_qual.noise = range->max_qual.noise / 2;
-	range->avg_qual.updated = ieee80211_get_wstats_flags(local);
-
-	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
-			  IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
-
-
-	for (band = 0; band < IEEE80211_NUM_BANDS; band ++) {
-		int i;
-		struct ieee80211_supported_band *sband;
-
-		sband = local->hw.wiphy->bands[band];
-
-		if (!sband)
-			continue;
-
-		for (i = 0; i < sband->n_channels && c < IW_MAX_FREQUENCIES; i++) {
-			struct ieee80211_channel *chan = &sband->channels[i];
-
-			if (!(chan->flags & IEEE80211_CHAN_DISABLED)) {
-				range->freq[c].i =
-					ieee80211_frequency_to_channel(
-						chan->center_freq);
-				range->freq[c].m = chan->center_freq;
-				range->freq[c].e = 6;
-				c++;
-			}
-		}
-	}
-	range->num_channels = c;
-	range->num_frequency = c;
-
-	IW_EVENT_CAPA_SET_KERNEL(range->event_capa);
-	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWAP);
-	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWSCAN);
-
-	range->scan_capa |= IW_SCAN_CAPA_ESSID;
-
-	return 0;
-}
-
-
 static int ieee80211_ioctl_siwfreq(struct net_device *dev,
 				   struct iw_request_info *info,
 				   struct iw_freq *freq, char *extra)
@@ -1004,6 +886,21 @@ static int ieee80211_ioctl_siwauth(struc
 	return ret;
 }
 
+static u8 ieee80211_get_wstats_flags(struct ieee80211_local *local)
+{
+	u8 wstats_flags = 0;
+
+	wstats_flags |= local->hw.flags & (IEEE80211_HW_SIGNAL_UNSPEC |
+					   IEEE80211_HW_SIGNAL_DBM) ?
+				IW_QUAL_QUAL_UPDATED : IW_QUAL_QUAL_INVALID;
+	wstats_flags |= local->hw.flags & IEEE80211_HW_NOISE_DBM ?
+				IW_QUAL_NOISE_UPDATED : IW_QUAL_NOISE_INVALID;
+	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
+		wstats_flags |= IW_QUAL_DBM;
+
+	return wstats_flags;
+}
+
 /* Get wireless statistics.  Called by /proc/net/wireless and by SIOCGIWSTATS */
 static struct iw_statistics *ieee80211_get_wireless_stats(struct net_device *dev)
 {
@@ -1149,7 +1046,7 @@ static const iw_handler ieee80211_handle
 	(iw_handler) NULL,				/* SIOCSIWSENS */
 	(iw_handler) NULL,				/* SIOCGIWSENS */
 	(iw_handler) NULL /* not used */,		/* SIOCSIWRANGE */
-	(iw_handler) ieee80211_ioctl_giwrange,		/* SIOCGIWRANGE */
+	(iw_handler) cfg80211_wext_giwrange,		/* SIOCGIWRANGE */
 	(iw_handler) NULL /* not used */,		/* SIOCSIWPRIV */
 	(iw_handler) NULL /* kernel code */,		/* SIOCGIWPRIV */
 	(iw_handler) NULL /* not used */,		/* SIOCSIWSTATS */
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-02-18 18:47:40.000000000 +0100
+++ wireless-testing/net/wireless/wext-compat.c	2009-02-18 19:00:16.000000000 +0100
@@ -137,3 +137,100 @@ int cfg80211_wext_giwmode(struct net_dev
 	return 0;
 }
 EXPORT_SYMBOL(cfg80211_wext_giwmode);
+
+
+int cfg80211_wext_giwrange(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_point *data, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct iw_range *range = (struct iw_range *) extra;
+	enum ieee80211_band band;
+	int c = 0;
+
+	if (!wdev)
+		return -EOPNOTSUPP;
+
+	data->length = sizeof(struct iw_range);
+	memset(range, 0, sizeof(struct iw_range));
+
+	range->we_version_compiled = WIRELESS_EXT;
+	range->we_version_source = 21;
+	range->retry_capa = IW_RETRY_LIMIT;
+	range->retry_flags = IW_RETRY_LIMIT;
+	range->min_retry = 0;
+	range->max_retry = 255;
+	range->min_rts = 0;
+	range->max_rts = 2347;
+	range->min_frag = 256;
+	range->max_frag = 2346;
+
+	range->encoding_size[0] = 5;
+	range->encoding_size[1] = 13;
+	range->num_encoding_sizes = 2;
+	range->max_encoding_tokens = 4;
+
+	range->max_qual.updated = IW_QUAL_NOISE_INVALID;
+
+	switch (wdev->wiphy->signal_type) {
+	case CFG80211_SIGNAL_TYPE_NONE:
+		break;
+	case CFG80211_SIGNAL_TYPE_MBM:
+		range->max_qual.level = -110;
+		range->max_qual.qual = 70;
+		range->avg_qual.qual = 35;
+		range->max_qual.updated |= IW_QUAL_DBM;
+		range->max_qual.updated |= IW_QUAL_QUAL_UPDATED;
+		range->max_qual.updated |= IW_QUAL_LEVEL_UPDATED;
+		break;
+	case CFG80211_SIGNAL_TYPE_UNSPEC:
+		range->max_qual.level = 100;
+		range->max_qual.qual = 100;
+		range->avg_qual.qual = 50;
+		range->max_qual.updated |= IW_QUAL_QUAL_UPDATED;
+		range->max_qual.updated |= IW_QUAL_LEVEL_UPDATED;
+		break;
+	}
+
+	range->avg_qual.level = range->max_qual.level / 2;
+	range->avg_qual.noise = range->max_qual.noise / 2;
+	range->avg_qual.updated = range->max_qual.updated;
+
+	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
+			  IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
+
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band ++) {
+		int i;
+		struct ieee80211_supported_band *sband;
+
+		sband = wdev->wiphy->bands[band];
+
+		if (!sband)
+			continue;
+
+		for (i = 0; i < sband->n_channels && c < IW_MAX_FREQUENCIES; i++) {
+			struct ieee80211_channel *chan = &sband->channels[i];
+
+			if (!(chan->flags & IEEE80211_CHAN_DISABLED)) {
+				range->freq[c].i =
+					ieee80211_frequency_to_channel(
+						chan->center_freq);
+				range->freq[c].m = chan->center_freq;
+				range->freq[c].e = 6;
+				c++;
+			}
+		}
+	}
+	range->num_channels = c;
+	range->num_frequency = c;
+
+	IW_EVENT_CAPA_SET_KERNEL(range->event_capa);
+	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWAP);
+	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWSCAN);
+
+	range->scan_capa |= IW_SCAN_CAPA_ESSID;
+
+	return 0;
+}
+EXPORT_SYMBOL(cfg80211_wext_giwrange);
--- wireless-testing.orig/include/net/cfg80211.h	2009-02-18 18:56:43.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2009-02-18 18:57:07.000000000 +0100
@@ -765,6 +765,9 @@ int cfg80211_wext_siwscan(struct net_dev
 int cfg80211_wext_giwscan(struct net_device *dev,
 			  struct iw_request_info *info,
 			  struct iw_point *data, char *extra);
+int cfg80211_wext_giwrange(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_point *data, char *extra);
 
 /**
  * cfg80211_scan_done - notify that scan finished


