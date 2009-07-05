Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51948 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbZGEVNT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2009 17:13:19 -0400
Subject: [PATCH] cfg80211: fix giwrange
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dave <kilroyd@googlemail.com>
Content-Type: text/plain
Date: Sun, 05 Jul 2009 23:13:19 +0200
Message-Id: <1246828399.4411.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit c4c496e49ddbf022e51adbd25cedd071329280db
Author: David Kilroy <kilroyd@googlemail.com>
Date:   Thu Jun 18 23:21:14 2009 +0100

    cfg80211: Advertise ciphers via WE according to driver capability
    
    Signed-off-by: David Kilroy <kilroyd@googlemail.com>
    Acked-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

unfortunately broke iwrange -- it used the variable c
that needs to be 0 for the channel list.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/wext-compat.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/wireless/wext-compat.c	2009-07-05 23:10:33.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-07-05 23:10:37.000000000 +0200
@@ -154,7 +154,7 @@ int cfg80211_wext_giwrange(struct net_de
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct iw_range *range = (struct iw_range *) extra;
 	enum ieee80211_band band;
-	int c = 0;
+	int i, c = 0;
 
 	if (!wdev)
 		return -EOPNOTSUPP;
@@ -201,7 +201,7 @@ int cfg80211_wext_giwrange(struct net_de
 	range->avg_qual.noise = range->max_qual.noise / 2;
 	range->avg_qual.updated = range->max_qual.updated;
 
-	for (c = 0; c < wdev->wiphy->n_cipher_suites; c++) {
+	for (i = 0; i < wdev->wiphy->n_cipher_suites; i++) {
 		switch (wdev->wiphy->cipher_suites[c]) {
 		case WLAN_CIPHER_SUITE_TKIP:
 			range->enc_capa |= (IW_ENC_CAPA_CIPHER_TKIP |
@@ -226,7 +226,6 @@ int cfg80211_wext_giwrange(struct net_de
 	}
 
 	for (band = 0; band < IEEE80211_NUM_BANDS; band ++) {
-		int i;
 		struct ieee80211_supported_band *sband;
 
 		sband = wdev->wiphy->bands[band];


