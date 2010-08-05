Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42234 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab0HEITF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 04:19:05 -0400
Subject: [PATCH] cfg80211: deauth doesn't always imply disconnect
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 10:20:27 +0200
Message-ID: <1280996427.4058.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When an AP sends a deauth frame, or we send one
to an AP, that only means we lost our connection
if we were actually connected to that AP. Check
this to avoid sending spurious "disconnected"
events and breaking "iw ... link" reporting.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/mlme.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/wireless/mlme.c	2010-08-04 17:33:11.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2010-08-04 23:01:37.000000000 +0200
@@ -149,7 +149,7 @@ void __cfg80211_send_deauth(struct net_d
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
 	const u8 *bssid = mgmt->bssid;
 	int i;
-	bool found = false;
+	bool found = false, was_current = false;
 
 	ASSERT_WDEV_LOCK(wdev);
 
@@ -159,6 +159,7 @@ void __cfg80211_send_deauth(struct net_d
 		cfg80211_put_bss(&wdev->current_bss->pub);
 		wdev->current_bss = NULL;
 		found = true;
+		was_current = true;
 	} else for (i = 0; i < MAX_AUTH_BSSES; i++) {
 		if (wdev->auth_bsses[i] &&
 		    memcmp(wdev->auth_bsses[i]->pub.bssid, bssid, ETH_ALEN) == 0) {
@@ -183,7 +184,7 @@ void __cfg80211_send_deauth(struct net_d
 
 	nl80211_send_deauth(rdev, dev, buf, len, GFP_KERNEL);
 
-	if (wdev->sme_state == CFG80211_SME_CONNECTED) {
+	if (wdev->sme_state == CFG80211_SME_CONNECTED && was_current) {
 		u16 reason_code;
 		bool from_ap;
 


