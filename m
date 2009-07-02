Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59995 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbZGBNql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 09:46:41 -0400
Subject: [PATCH 2.6.31] cfg80211: fix refcount leak
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 15:46:41 +0200
Message-Id: <1246542402.16770.39.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code in cfg80211's cfg80211_bss_update erroneously
grabs a reference to the BSS, which means that it will
never be freed.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org [2.6.29, 2.6.30]
---
 net/wireless/scan.c |    1 -
 1 file changed, 1 deletion(-)

--- wireless-testing.orig/net/wireless/scan.c	2009-07-02 15:32:12.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2009-07-02 15:39:23.000000000 +0200
@@ -376,7 +376,6 @@ cfg80211_bss_update(struct cfg80211_regi
 	found = rb_find_bss(dev, res);
 
 	if (found) {
-		kref_get(&found->ref);
 		found->pub.beacon_interval = res->pub.beacon_interval;
 		found->pub.tsf = res->pub.tsf;
 		found->pub.signal = res->pub.signal;


