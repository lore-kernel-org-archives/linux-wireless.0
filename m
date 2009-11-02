Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59259 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbZKBMcF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 07:32:05 -0500
Subject: [PATCH] cfg80211: validate scan channels
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Nov 2009 13:32:03 +0100
Message-ID: <1257165123.3555.185.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently it is possible to request a scan on only
disabled channels, which could be problematic for
some drivers. Reject such scans, and also ignore
disabled channels that are given. This resuls in
the scan begin/end event only including channels
that are actually used.

This makes the mac80211 check for disabled channels
superfluous. At the same time, remove the no-IBSS
check from mac80211 -- nothing says that we should
not find any networks on channels that cannot be
used for an IBSS, even when operating in IBSS mode.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/scan.c    |   13 ++-----------
 net/wireless/nl80211.c |   34 +++++++++++++++++++++++++++-------
 net/wireless/scan.c    |    6 ++++++
 3 files changed, 35 insertions(+), 18 deletions(-)

--- wireless-testing.orig/net/mac80211/scan.c	2009-11-02 12:30:02.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2009-11-02 13:28:06.000000000 +0100
@@ -614,23 +614,14 @@ static void ieee80211_scan_state_set_cha
 {
 	int skip;
 	struct ieee80211_channel *chan;
-	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
 
 	skip = 0;
 	chan = local->scan_req->channels[local->scan_channel_idx];
 
-	if (chan->flags & IEEE80211_CHAN_DISABLED ||
-	    (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
-	     chan->flags & IEEE80211_CHAN_NO_IBSS))
+	local->scan_channel = chan;
+	if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
 		skip = 1;
 
-	if (!skip) {
-		local->scan_channel = chan;
-		if (ieee80211_hw_config(local,
-					IEEE80211_CONF_CHANGE_CHANNEL))
-			skip = 1;
-	}
-
 	/* advance state machine to next channel/band */
 	local->scan_channel_idx++;
 
--- wireless-testing.orig/net/wireless/nl80211.c	2009-11-02 12:48:31.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2009-11-02 13:27:11.000000000 +0100
@@ -2988,7 +2988,6 @@ static int nl80211_trigger_scan(struct s
 		goto out;
 	}
 
-	request->n_channels = n_channels;
 	if (n_ssids)
 		request->ssids = (void *)&request->channels[n_channels];
 	request->n_ssids = n_ssids;
@@ -2999,32 +2998,53 @@ static int nl80211_trigger_scan(struct s
 			request->ie = (void *)(request->channels + n_channels);
 	}
 
+	i = 0;
 	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
 		/* user specified, bail out if channel not found */
-		request->n_channels = n_channels;
-		i = 0;
 		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_FREQUENCIES], tmp) {
-			request->channels[i] = ieee80211_get_channel(wiphy, nla_get_u32(attr));
-			if (!request->channels[i]) {
+			struct ieee80211_channel *chan;
+
+			chan = ieee80211_get_channel(wiphy, nla_get_u32(attr));
+
+			if (!chan) {
 				err = -EINVAL;
 				goto out_free;
 			}
+
+			/* ignore disabled channels */
+			if (chan->flags & IEEE80211_CHAN_DISABLED)
+				continue;
+
+			request->channels[i] = chan;
 			i++;
 		}
 	} else {
 		/* all channels */
-		i = 0;
 		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 			int j;
 			if (!wiphy->bands[band])
 				continue;
 			for (j = 0; j < wiphy->bands[band]->n_channels; j++) {
-				request->channels[i] = &wiphy->bands[band]->channels[j];
+				struct ieee80211_channel *chan;
+
+				chan = &wiphy->bands[band]->channels[j];
+
+				if (chan->flags & IEEE80211_CHAN_DISABLED)
+					continue;
+
+				request->channels[i] = chan;
 				i++;
 			}
 		}
 	}
 
+	if (!i) {
+		err = -EINVAL;
+		goto out_free;
+	}
+
+	request->n_channels = i;
+
 	i = 0;
 	if (info->attrs[NL80211_ATTR_SCAN_SSIDS]) {
 		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp) {
--- wireless-testing.orig/net/wireless/scan.c	2009-11-02 12:52:02.000000000 +0100
+++ wireless-testing/net/wireless/scan.c	2009-11-02 13:15:46.000000000 +0100
@@ -650,9 +650,15 @@ int cfg80211_wext_siwscan(struct net_dev
 	i = 0;
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		int j;
+
 		if (!wiphy->bands[band])
 			continue;
+
 		for (j = 0; j < wiphy->bands[band]->n_channels; j++) {
+			/* ignore disabled channels */
+			if (wiphy->bands[band]->channels[j].flags &
+						IEEE80211_CHAN_DISABLED)
+				continue;
 
 			/* If we have a wireless request structure and the
 			 * wireless request specifies frequencies, then search


