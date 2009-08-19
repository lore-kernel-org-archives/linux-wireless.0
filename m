Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54728 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbZHSRqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 13:46:19 -0400
Subject: [PATCH] mac80211: fix register_hw error path
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 19 Aug 2009 19:45:50 +0200
Message-Id: <1250703950.8073.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"cfg80211: fix alignment problem in scan request"
introduced a bug into the error path, because now
we allocate the entire scan request and not just
the channel list (the channel list is allocated
together with the scan request) -- on errors we
thus also need to free the entire scan request.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/main.c	2009-08-19 19:44:18.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-08-19 19:44:20.000000000 +0200
@@ -930,7 +930,7 @@ int ieee80211_register_hw(struct ieee802
  fail_workqueue:
 	wiphy_unregister(local->hw.wiphy);
  fail_wiphy_register:
-	kfree(local->int_scan_req->channels);
+	kfree(local->int_scan_req);
 	return result;
 }
 EXPORT_SYMBOL(ieee80211_register_hw);


