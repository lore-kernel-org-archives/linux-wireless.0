Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53705 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522AbZCLWI6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 18:08:58 -0400
Subject: [PATCH] cfg80211: drop wext channel list if too long
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 19:24:04 +0100
Message-Id: <1236882244.25931.5.camel@johannes.local> (sfid-20090312_230900_621984_AA494722)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wext limits the number of channels it can list to 32, we obey
that limitation but show a partial list which is confusing.
Thus, when going over the limit, drop the list completely to
make the users aware that something is wrong and hopefully
prompt them to use iw instead. We still let iwlist print out
the total number of available channels.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/wext-compat.c |   49 +++++++++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 12 deletions(-)

--- wireless-testing.orig/net/wireless/wext-compat.c	2009-03-11 19:27:04.000000000 +0100
+++ wireless-testing/net/wireless/wext-compat.c	2009-03-11 20:12:31.000000000 +0100
@@ -146,7 +146,7 @@ int cfg80211_wext_giwrange(struct net_de
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct iw_range *range = (struct iw_range *) extra;
 	enum ieee80211_band band;
-	int c = 0;
+	int nc = 0, nf = 0;
 
 	if (!wdev)
 		return -EOPNOTSUPP;
@@ -209,21 +209,46 @@ int cfg80211_wext_giwrange(struct net_de
 		if (!sband)
 			continue;
 
-		for (i = 0; i < sband->n_channels && c < IW_MAX_FREQUENCIES; i++) {
+		for (i = 0; i < sband->n_channels; i++) {
 			struct ieee80211_channel *chan = &sband->channels[i];
 
-			if (!(chan->flags & IEEE80211_CHAN_DISABLED)) {
-				range->freq[c].i =
-					ieee80211_frequency_to_channel(
-						chan->center_freq);
-				range->freq[c].m = chan->center_freq;
-				range->freq[c].e = 6;
-				c++;
-			}
+			if (chan->flags & IEEE80211_CHAN_DISABLED)
+				continue;
+
+			nc++;
+
+			/*
+			 * reached wext limit for frequencies,
+			 * keep counting the channels in 'nc'.
+			 */
+			if (nf >= IW_MAX_FREQUENCIES)
+				continue;
+
+			range->freq[nf].i =
+			    ieee80211_frequency_to_channel(chan->center_freq);
+			range->freq[nf].m = chan->center_freq;
+			range->freq[nf].e = 6;
+			nf++;
 		}
 	}
-	range->num_channels = c;
-	range->num_frequency = c;
+
+	range->num_channels = nc;
+
+	/*
+	 * wext only supports a limited number of frequencies,
+	 * if that is reached then it helpfully suggests:
+	 *
+	 *	Note : if you have something like 80 frequencies,
+	 *	don't increase this constant and don't fill the
+	 *	frequency list. The user will be able to set by
+	 *	channel anyway...
+	 *
+	 * So in this case let's just leave the list empty.
+	 */
+	if (nc > nf)
+		nf = 0;
+
+	range->num_frequency = nf;
 
 	IW_EVENT_CAPA_SET_KERNEL(range->event_capa);
 	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWAP);


