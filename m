Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48934 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbZBRR15 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 12:27:57 -0500
Subject: [PATCH] cfg80211/mac80211: fill qual.qual value/adjust
	max_qual.qual
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1234896777.4678.7.camel@californication> (sfid-20090217_195251_321967_5E2E0AB8)
References: <1234896777.4678.7.camel@californication>
	 (sfid-20090217_195251_321967_5E2E0AB8)
Content-Type: text/plain
Date: Wed, 18 Feb 2009 18:27:22 +0100
Message-Id: <1234978042.4023.32.camel@johannes.local> (sfid-20090218_182801_452013_E7F46FA4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to various bugs in the software stack we end up having
to fill qual.qual; level should be used, but wpa_supplicant
doesn't properly ignore qual.qual, NM should use qual.level
regardless of that because qual.qual is 0 but doesn't handle
IW_QUAL_DBM right now.

So fill qual.qual with the qual.level value clamped to
-110..-40 dBm or just the regular 'unspecified' signal level.
This requires a mac80211 change to properly announce the
max_qual.qual and avg_qual.qual values.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/wext.c |   18 ++++++++++++++++--
 net/wireless/scan.c |   15 ++++++++++++---
 2 files changed, 28 insertions(+), 5 deletions(-)

--- wireless-testing.orig/net/mac80211/wext.c	2009-02-18 18:13:49.000000000 +0100
+++ wireless-testing/net/mac80211/wext.c	2009-02-18 18:15:08.000000000 +0100
@@ -200,10 +200,24 @@ static int ieee80211_ioctl_giwrange(stru
 	else
 		range->max_qual.noise = 0;
 
-	range->max_qual.qual = 100;
 	range->max_qual.updated = ieee80211_get_wstats_flags(local);
 
-	range->avg_qual.qual = 50;
+	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
+		/*
+		 * cfg80211 assumes -110 to -40 dBm and clamps to that range
+		 * for qual.qual, so tell userspace this is what we give it
+		 * but take into account that we have to start from 0.
+		 */
+		range->max_qual.qual = 70;
+		range->avg_qual.qual = 35;
+	} else {
+		/*
+		 * cfg80211 just uses the level value for qual too, and it
+		 * requires the level value to be 0 .. 100.
+		 */
+		range->max_qual.qual = 100;
+		range->avg_qual.qual = 50;
+	}
 	/* not always true but better than nothing */
 	range->avg_qual.level = range->max_qual.level / 2;
 	range->avg_qual.noise = range->max_qual.noise / 2;
--- wireless-testing.orig/net/wireless/scan.c	2009-02-18 18:08:20.000000000 +0100
+++ wireless-testing/net/wireless/scan.c	2009-02-18 18:13:44.000000000 +0100
@@ -614,7 +614,7 @@ ieee80211_bss(struct iw_request_info *in
 	struct iw_event iwe;
 	u8 *buf, *cfg, *p;
 	u8 *ie = bss->pub.information_elements;
-	int rem = bss->pub.len_information_elements, i;
+	int rem = bss->pub.len_information_elements, i, sig;
 	bool ismesh = false;
 
 	memset(&iwe, 0, sizeof(iwe));
@@ -643,14 +643,23 @@ ieee80211_bss(struct iw_request_info *in
 		iwe.cmd = IWEVQUAL;
 		iwe.u.qual.updated = IW_QUAL_LEVEL_UPDATED |
 				     IW_QUAL_NOISE_INVALID |
-				     IW_QUAL_QUAL_INVALID;
+				     IW_QUAL_QUAL_UPDATED;
 		switch (bss->pub.signal_type) {
 		case CFG80211_SIGNAL_TYPE_MBM:
-			iwe.u.qual.level = bss->pub.signal / 100;
+			sig = bss->pub.signal / 100;
+			iwe.u.qual.level = sig;
 			iwe.u.qual.updated |= IW_QUAL_DBM;
+			if (sig < -110)		/* rather bad */
+				sig = -110;
+			else if (sig > -40)	/* perfect */
+				sig = -40;
+			/* will give a range of 0 .. 70 */
+			iwe.u.qual.qual = sig + 110;
 			break;
 		case CFG80211_SIGNAL_TYPE_UNSPEC:
 			iwe.u.qual.level = bss->pub.signal;
+			/* will give range 0 .. 100 */
+			iwe.u.qual.qual = bss->pub.signal;
 			break;
 		default:
 			/* not reached */


