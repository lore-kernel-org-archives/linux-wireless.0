Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40115 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbZGBQ0S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 12:26:18 -0400
Subject: [PATCH] cfg80211: refuse authenticating to same BSSID twice
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 18:26:18 +0200
Message-Id: <1246551978.16770.47.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is possible that there are different BSS structs with
the same BSSID, but we cannot authenticate with multiple
of them them because we need the BSSID to be unique for
deauthenticating/disassociating.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/mlme.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- wireless-testing.orig/net/wireless/mlme.c	2009-07-02 18:18:51.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2009-07-02 18:24:03.000000000 +0200
@@ -278,6 +278,21 @@ int cfg80211_mlme_auth(struct cfg80211_r
 	struct cfg80211_internal_bss *bss;
 	int i, err, slot = -1, nfree = 0;
 
+	if (wdev->current_bss &&
+	    memcmp(bssid, wdev->current_bss->pub.bssid, ETH_ALEN) == 0)
+		return -EALREADY;
+
+	for (i = 0; i < MAX_AUTH_BSSES; i++) {
+		if (wdev->authtry_bsses[i] &&
+		    memcmp(bssid, wdev->authtry_bsses[i]->pub.bssid,
+		    				ETH_ALEN) == 0)
+			return -EALREADY;
+		if (wdev->auth_bsses[i] &&
+		    memcmp(bssid, wdev->auth_bsses[i]->pub.bssid,
+		    				ETH_ALEN) == 0)
+			return -EALREADY;
+	}
+
 	memset(&req, 0, sizeof(req));
 
 	req.ie = ie;
@@ -291,13 +306,6 @@ int cfg80211_mlme_auth(struct cfg80211_r
 	bss = bss_from_pub(req.bss);
 
 	for (i = 0; i < MAX_AUTH_BSSES; i++) {
-		if (bss == wdev->auth_bsses[i]) {
-			err = -EALREADY;
-			goto out;
-		}
-	}
-
-	for (i = 0; i < MAX_AUTH_BSSES; i++) {
 		if (!wdev->auth_bsses[i] && !wdev->authtry_bsses[i]) {
 			slot = i;
 			nfree++;


