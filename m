Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36283 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347AbZHFSqz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 14:46:55 -0400
Message-Id: <20090806184234.476962720@sipsolutions.net>
References: <20090806184131.114246687@sipsolutions.net>
Date: Thu, 06 Aug 2009 20:41:34 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>
Subject: [PATCH 3/3] cfg80211: fix SME association after disassociation
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When an AP disassociates us, we currently go into a weird
state because the SME doesn't handle authenticated but not
associated well unless it's within its own state machine,
it can't recover from that. However, it shouldn't need to,
since we don't do any decisions in it really -- so when we
get disconnected, simply deauthenticate too.

Reported-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/sme.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- wireless-testing.orig/net/wireless/sme.c	2009-08-06 20:40:09.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-08-06 20:40:19.000000000 +0200
@@ -570,10 +570,30 @@ void __cfg80211_disconnected(struct net_
 	wdev->ssid_len = 0;
 
 	if (wdev->conn) {
+		const u8 *bssid;
+		int ret;
+
 		kfree(wdev->conn->ie);
 		wdev->conn->ie = NULL;
 		kfree(wdev->conn);
 		wdev->conn = NULL;
+
+		/*
+		 * If this disconnect was due to a disassoc, we
+		 * we might still have an auth BSS around. For
+		 * the userspace SME that's currently expected,
+		 * but for the kernel SME (nl80211 CONNECT or
+		 * wireless extensions) we want to clear up all
+		 * state.
+		 */
+		for (i = 0; i < MAX_AUTH_BSSES; i++) {
+			if (!wdev->auth_bsses[i])
+				continue;
+			bssid = wdev->auth_bsses[i]->pub.bssid;
+			ret = __cfg80211_mlme_deauth(rdev, dev, bssid, NULL, 0,
+						WLAN_REASON_DEAUTH_LEAVING);
+			WARN(ret, "deauth failed: %d\n", ret);
+		}
 	}
 
 	nl80211_send_disconnected(rdev, dev, reason, ie, ie_len, from_ap);

-- 

