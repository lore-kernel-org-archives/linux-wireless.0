Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33774 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbZGJWRi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 18:17:38 -0400
Subject: [PATCH] cfg80211: fix more bugs in mlme handling
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 11 Jul 2009 00:17:32 +0200
Message-Id: <1247264252.26071.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The "what-was-I-thinking-if-anything" patch. Clearly,
if cfg80211_send_disassoc() does wdev_lock() and then
calls __cfg80211_send_disassoc(), the latter shouldn't
lock again. And the sme_state test is ... no further
comments.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/mlme.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- wireless-testing.orig/net/wireless/mlme.c	2009-07-11 00:13:50.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2009-07-11 00:14:15.000000000 +0200
@@ -178,12 +178,12 @@ static void __cfg80211_send_disassoc(str
 	bool from_ap;
 	bool done = false;
 
-	wdev_lock(wdev);
+	ASSERT_WDEV_LOCK(wdev);
 
 	nl80211_send_disassoc(rdev, dev, buf, len, GFP_KERNEL);
 
-	if (!wdev->sme_state == CFG80211_SME_CONNECTED)
-		goto out;
+	if (wdev->sme_state != CFG80211_SME_CONNECTED)
+		return;
 
 	if (wdev->current_bss &&
 	    memcmp(wdev->current_bss, bssid, ETH_ALEN) == 0) {
@@ -205,8 +205,6 @@ static void __cfg80211_send_disassoc(str
 
 	from_ap = memcmp(mgmt->da, dev->dev_addr, ETH_ALEN) == 0;
 	__cfg80211_disconnected(dev, NULL, 0, reason_code, from_ap);
- out:
-	wdev_unlock(wdev);
 }
 
 void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len,


