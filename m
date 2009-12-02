Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55880 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbZLBLsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 06:48:13 -0500
Message-Id: <20091202114646.607546955@sipsolutions.net>
Date: Wed, 02 Dec 2009 12:43:42 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/6] cfg80211: avoid sending spurious deauth to userspace
References: <20091202114341.088046714@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before
  commit ca9034592823e8179511e48a78731f95bfdd766c
  Author: Holger Schurig <hs4233@mail.mn-solutions.de>
  Date:   Tue Oct 13 13:45:28 2009 +0200

      cfg80211: remove warning in deauth case

we assumed that drivers never give us spurious deauth
frames because they filter them out based on the auth
state they keep track of. This turned out to be racy,
because userspace might deauth while the AP is also
sending a deauth frame, so the warning was removed.

However, in that case we should not tell userspace
about the AP's frame if it requested deauth "first",
where "first" means it came to cfg80211 first.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/mlme.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/wireless/mlme.c	2009-12-01 18:26:53.000000000 +0100
+++ wireless-testing/net/wireless/mlme.c	2009-12-01 18:26:59.000000000 +0100
@@ -137,22 +137,23 @@ void __cfg80211_send_deauth(struct net_d
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
 	const u8 *bssid = mgmt->bssid;
 	int i;
+	bool found = false;
 
 	ASSERT_WDEV_LOCK(wdev);
 
-	nl80211_send_deauth(rdev, dev, buf, len, GFP_KERNEL);
-
 	if (wdev->current_bss &&
 	    memcmp(wdev->current_bss->pub.bssid, bssid, ETH_ALEN) == 0) {
 		cfg80211_unhold_bss(wdev->current_bss);
 		cfg80211_put_bss(&wdev->current_bss->pub);
 		wdev->current_bss = NULL;
+		found = true;
 	} else for (i = 0; i < MAX_AUTH_BSSES; i++) {
 		if (wdev->auth_bsses[i] &&
 		    memcmp(wdev->auth_bsses[i]->pub.bssid, bssid, ETH_ALEN) == 0) {
 			cfg80211_unhold_bss(wdev->auth_bsses[i]);
 			cfg80211_put_bss(&wdev->auth_bsses[i]->pub);
 			wdev->auth_bsses[i] = NULL;
+			found = true;
 			break;
 		}
 		if (wdev->authtry_bsses[i] &&
@@ -160,10 +161,16 @@ void __cfg80211_send_deauth(struct net_d
 			cfg80211_unhold_bss(wdev->authtry_bsses[i]);
 			cfg80211_put_bss(&wdev->authtry_bsses[i]->pub);
 			wdev->authtry_bsses[i] = NULL;
+			found = true;
 			break;
 		}
 	}
 
+	if (!found)
+		return;
+
+	nl80211_send_deauth(rdev, dev, buf, len, GFP_KERNEL);
+
 	if (wdev->sme_state == CFG80211_SME_CONNECTED) {
 		u16 reason_code;
 		bool from_ap;


