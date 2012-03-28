Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38565 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab2C1TCt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 15:02:49 -0400
Message-ID: <1332961366.3479.41.camel@jlt3.sipsolutions.net> (sfid-20120328_210252_512142_06F6B25D)
Subject: [PATCH 3.4] mac80211: fix association beacon wait timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 28 Mar 2012 21:02:46 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The TU_TO_EXP_TIME() macro already includes the
"jiffies +" piece of the calculation, so don't
add jiffies again.

Reported-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/mac80211/mlme.c	2012-03-28 20:55:35.000000000 +0200
+++ b/net/mac80211/mlme.c	2012-03-28 20:56:14.000000000 +0200
@@ -3387,8 +3387,7 @@ int ieee80211_mgd_assoc(struct ieee80211
 		 */
 		printk(KERN_DEBUG "%s: waiting for beacon from %pM\n",
 		       sdata->name, ifmgd->bssid);
-		assoc_data->timeout = jiffies +
-				TU_TO_EXP_TIME(req->bss->beacon_interval);
+		assoc_data->timeout = TU_TO_EXP_TIME(req->bss->beacon_interval);
 	} else {
 		assoc_data->have_beacon = true;
 		assoc_data->sent_assoc = false;


