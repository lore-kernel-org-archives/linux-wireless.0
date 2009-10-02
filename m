Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60314 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbZJBIi2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 04:38:28 -0400
Subject: [PATCH] cfg80211: fix a wrong ifdef
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Oct 2009 10:38:28 +0200
Message-Id: <1254472708.3959.74.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wext refactoring replaced all
	#ifdef CONFIG_WIRELESS_EXT
in cfg80211 with
	#ifdef CONFIG_CFG80211_WEXT
but one -- that one needs fixing now.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Might be worth rolling it into the refactor patch.

 net/wireless/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/wireless/core.c	2009-10-02 10:34:13.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-10-02 10:34:24.000000000 +0200
@@ -669,7 +669,7 @@ static int cfg80211_netdev_notifier_call
 		wdev->netdev = dev;
 		wdev->sme_state = CFG80211_SME_IDLE;
 		mutex_unlock(&rdev->devlist_mtx);
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 		wdev->wext.default_key = -1;
 		wdev->wext.default_mgmt_key = -1;
 		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;


