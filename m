Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38929 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab0I1KxQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 06:53:16 -0400
Subject: [PATCH] cfg80211: always set IBSS basic rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi <mshajakhan@atheros.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1285670865.3885.8.camel@jlt3.sipsolutions.net>
References: <1285662586-31646-1-git-send-email-mshajakhan@atheros.com>
	 <1285664569.3885.7.camel@jlt3.sipsolutions.net>
	 <4CA1B5F3.5090801@atheros.com>
	 <1285670865.3885.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 12:53:14 +0200
Message-ID: <1285671194.3885.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

IBSS started from wireless extensions is currently
missing basic rate configuration, fix this by moving
the code to generate the default to the common code
that gets invoked for both nl80211 and wext.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/ibss.c    |   19 +++++++++++++++++++
 net/wireless/nl80211.c |   17 -----------------
 2 files changed, 19 insertions(+), 17 deletions(-)

--- wireless-testing.orig/net/wireless/ibss.c	2010-09-28 12:49:14.000000000 +0200
+++ wireless-testing/net/wireless/ibss.c	2010-09-28 12:51:24.000000000 +0200
@@ -88,6 +88,25 @@ int __cfg80211_join_ibss(struct cfg80211
 	if (wdev->ssid_len)
 		return -EALREADY;
 
+	if (!params->basic_rates) {
+		/*
+		* If no rates were explicitly configured,
+		* use the mandatory rate set for 11b or
+		* 11a for maximum compatibility.
+		*/
+		struct ieee80211_supported_band *sband =
+			rdev->wiphy.bands[params->channel->band];
+		int j;
+		u32 flag = params->channel->band == IEEE80211_BAND_5GHZ ?
+			IEEE80211_RATE_MANDATORY_A :
+			IEEE80211_RATE_MANDATORY_B;
+
+		for (j = 0; j < sband->n_bitrates; j++) {
+			if (sband->bitrates[j].flags & flag)
+				params->basic_rates |= BIT(j);
+		}
+	}
+
 	if (WARN_ON(wdev->connect_keys))
 		kfree(wdev->connect_keys);
 	wdev->connect_keys = connkeys;
--- wireless-testing.orig/net/wireless/nl80211.c	2010-09-28 12:49:14.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2010-09-28 12:50:32.000000000 +0200
@@ -4119,23 +4119,6 @@ static int nl80211_join_ibss(struct sk_b
 				goto out;
 			}
 		}
-	} else {
-		/*
-		* If no rates were explicitly configured,
-		* use the mandatory rate set for 11b or
-		* 11a for maximum compatibility.
-		*/
-		struct ieee80211_supported_band *sband =
-			wiphy->bands[ibss.channel->band];
-		int j;
-		u32 flag = ibss.channel->band == IEEE80211_BAND_5GHZ ?
-			IEEE80211_RATE_MANDATORY_A :
-			IEEE80211_RATE_MANDATORY_B;
-
-		for (j = 0; j < sband->n_bitrates; j++) {
-			if (sband->bitrates[j].flags & flag)
-				ibss.basic_rates |= BIT(j);
-		}
 	}
 
 	err = cfg80211_join_ibss(rdev, dev, &ibss, connkeys);


