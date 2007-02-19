Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54727 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932617AbXBSWjR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 17:39:17 -0500
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070219233919.221549000.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/12] d80211: fix authentication issues
Message-Id: <20070219223946.760B2484A4@silver.suse.cz>
Date: Mon, 19 Feb 2007 23:39:46 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This patch prevents the MLME in d80211 from getting stuck when there is no
reply to authentication frames. It also allows the bssid to be correctly
set during IEEE80211_AUTHENTICATE.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/d80211/ieee80211_sta.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

d02de628f917dadffc36cbb04f25a9e0bd3cb070
diff --git a/net/d80211/ieee80211_sta.c b/net/d80211/ieee80211_sta.c
index 433a11b..0e45a65 100644
--- a/net/d80211/ieee80211_sta.c
+++ b/net/d80211/ieee80211_sta.c
@@ -456,6 +456,7 @@ static void ieee80211_authenticate(struc
 		printk(KERN_DEBUG "%s: authentication with AP " MAC_FMT
 		       " timed out\n",
 		       dev->name, MAC_ARG(ifsta->bssid));
+		ifsta->state = IEEE80211_DISABLED;
 		return;
 	}
 
@@ -677,6 +678,7 @@ static void ieee80211_associate(struct n
 		printk(KERN_DEBUG "%s: association with AP " MAC_FMT
 		       " timed out\n",
 		       dev->name, MAC_ARG(ifsta->bssid));
+		ifsta->state = IEEE80211_DISABLED;
 		return;
 	}
 
@@ -686,6 +688,7 @@ static void ieee80211_associate(struct n
 	if (ieee80211_privacy_mismatch(dev, ifsta)) {
 		printk(KERN_DEBUG "%s: mismatch in privacy configuration and "
 		       "mixed-cell disabled - abort association\n", dev->name);
+		ifsta->state = IEEE80211_DISABLED;
 		return;
 	}
 
@@ -2366,7 +2369,7 @@ int ieee80211_sta_set_bssid(struct net_d
 		ifsta->bssid_set = 0;
 	else
 		ifsta->bssid_set = 1;
-	if (ifsta->ssid_set && ifsta->state != IEEE80211_AUTHENTICATE)
+	if (ifsta->ssid_set)
 		ieee80211_sta_new_auth(dev, ifsta);
 
 	return 0;
-- 
1.3.0

