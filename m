Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55335 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbYJ3KMk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 06:12:40 -0400
Subject: [PATCH for 2.6.28] mac80211: fix basic rates
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 18:14:06 +0100
Message-Id: <1225300446.5439.27.camel@johannes.berg> (sfid-20081030_111257_485459_849C81F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the basic rate bitmap calculation in mac80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org [2.6.25, 2.6.26, 2.6.27]
---
Is this appropriate for stable? It's a trivial and obvious fix, and can
throw off the duration calculation, but it's likely nobody will ever
really notice...

 net/mac80211/mlme.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-10-29 18:08:12.000000000 +0100
+++ everything/net/mac80211/mlme.c	2008-10-29 18:08:19.000000000 +0100
@@ -1307,8 +1307,9 @@ static void ieee80211_rx_mgmt_assoc_resp
 			have_higher_than_11mbit = true;
 
 		for (j = 0; j < sband->n_bitrates; j++) {
-			if (sband->bitrates[j].bitrate == rate)
-				rates |= BIT(j);
+			if (sband->bitrates[j].bitrate != rate)
+				continue;
+			rates |= BIT(j);
 			if (elems.supp_rates[i] & 0x80)
 				basic_rates |= BIT(j);
 		}
@@ -1321,8 +1322,9 @@ static void ieee80211_rx_mgmt_assoc_resp
 			have_higher_than_11mbit = true;
 
 		for (j = 0; j < sband->n_bitrates; j++) {
-			if (sband->bitrates[j].bitrate == rate)
-				rates |= BIT(j);
+			if (sband->bitrates[j].bitrate != rate)
+				continue;
+			rates |= BIT(j);
 			if (elems.ext_supp_rates[i] & 0x80)
 				basic_rates |= BIT(j);
 		}


