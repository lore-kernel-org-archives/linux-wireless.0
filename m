Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52669 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbZGJApk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 20:45:40 -0400
Subject: [PATCH] cfg80211: fix a locking bug
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 02:45:38 +0200
Message-Id: <1247186738.1905.15.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The cfg80211_sme_disassoc() function is already holding
a lock here that cfg80211_mlme_deauth() would take, so
it needs to use __cfg80211_mlme_deauth() instead.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/sme.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/wireless/sme.c	2009-07-10 02:43:53.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-07-10 02:43:59.000000000 +0200
@@ -826,8 +826,8 @@ void cfg80211_sme_disassoc(struct net_de
 		return;
 
 	memcpy(bssid, wdev->auth_bsses[idx]->pub.bssid, ETH_ALEN);
-	if (cfg80211_mlme_deauth(rdev, dev, bssid,
-				 NULL, 0, WLAN_REASON_DEAUTH_LEAVING)) {
+	if (__cfg80211_mlme_deauth(rdev, dev, bssid,
+				   NULL, 0, WLAN_REASON_DEAUTH_LEAVING)) {
 		/* whatever -- assume gone anyway */
 		cfg80211_unhold_bss(wdev->auth_bsses[idx]);
 		cfg80211_put_bss(&wdev->auth_bsses[idx]->pub);


