Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49371 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab0ADQuM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 11:50:12 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] cfg80211: add a regulatory debug print
Date: Mon,  4 Jan 2010 11:50:11 -0500
Message-Id: <1262623811-25393-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of sprinkling code with ifdef's define REG_DBG_PRINT() instead.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 80930bb..89c3e68 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -43,6 +43,15 @@
 #include "regdb.h"
 #include "nl80211.h"
 
+#ifdef CONFIG_CFG80211_REG_DEBUG
+#define REG_DBG_PRINT(args...) \
+	do { \
+		printk(KERN_DEBUG args); \
+	} while (0)
+#else
+#define REG_DBG_PRINT(args)
+#endif
+
 /* Receipt of information from last regulatory request */
 static struct regulatory_request *last_request;
 
@@ -972,25 +981,21 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 		if (r == -ERANGE &&
 		    last_request->initiator ==
 		    NL80211_REGDOM_SET_BY_COUNTRY_IE) {
-#ifdef CONFIG_CFG80211_REG_DEBUG
-			printk(KERN_DEBUG "cfg80211: Leaving channel %d MHz "
+			REG_DBG_PRINT("cfg80211: Leaving channel %d MHz "
 				"intact on %s - no rule found in band on "
 				"Country IE\n",
-				chan->center_freq, wiphy_name(wiphy));
-#endif
+			chan->center_freq, wiphy_name(wiphy));
 		} else {
 		/*
 		 * In this case we know the country IE has at least one reg rule
 		 * for the band so we respect its band definitions
 		 */
-#ifdef CONFIG_CFG80211_REG_DEBUG
 			if (last_request->initiator ==
 			    NL80211_REGDOM_SET_BY_COUNTRY_IE)
-				printk(KERN_DEBUG "cfg80211: Disabling "
+				REG_DBG_PRINT("cfg80211: Disabling "
 					"channel %d MHz on %s due to "
 					"Country IE\n",
 					chan->center_freq, wiphy_name(wiphy));
-#endif
 			flags |= IEEE80211_CHAN_DISABLED;
 			chan->flags = flags;
 		}
@@ -1870,13 +1875,12 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
 	if (!reg_beacon)
 		return -ENOMEM;
 
-#ifdef CONFIG_CFG80211_REG_DEBUG
-	printk(KERN_DEBUG "cfg80211: Found new beacon on "
-		"frequency: %d MHz (Ch %d) on %s\n",
-		beacon_chan->center_freq,
-		ieee80211_frequency_to_channel(beacon_chan->center_freq),
-		wiphy_name(wiphy));
-#endif
+	REG_DBG_PRINT("cfg80211: Found new beacon on "
+		      "frequency: %d MHz (Ch %d) on %s\n",
+		      beacon_chan->center_freq,
+		      ieee80211_frequency_to_channel(beacon_chan->center_freq),
+		      wiphy_name(wiphy));
+
 	memcpy(&reg_beacon->chan, beacon_chan,
 		sizeof(struct ieee80211_channel));
 
-- 
1.6.3.3

