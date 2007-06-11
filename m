Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49984 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbXFKIQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 04:16:56 -0400
Subject: [PATCH] fix oversight in "mac80211: Set low initial rate in  rc80211_simple"
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 08:10:41 +0200
Message-Id: <1181542241.3566.23.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a logic oversight in the patch "mac80211: Set low initial
rate in rc80211_simple".

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

--- wireless-dev.orig/net/mac80211/rc80211_simple.c	2007-06-11 08:08:55.301879260 +0200
+++ wireless-dev/net/mac80211/rc80211_simple.c	2007-06-11 08:09:06.791879260 +0200
@@ -289,9 +289,10 @@ static void rate_control_simple_rate_ini
 	 * as a workaround, */
 	for (i = 0; i < mode->num_rates; i++) {
 		if ((sta->supp_rates & BIT(i)) &&
-		    (mode->rates[i].flags & IEEE80211_RATE_SUPPORTED))
+		    (mode->rates[i].flags & IEEE80211_RATE_SUPPORTED)) {
 			sta->txrate = i;
 			break;
+		}
 	}
 }
 


