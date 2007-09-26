Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38543 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbXIZNYk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 09:24:40 -0400
Message-Id: <20070926132134.866954000@sipsolutions.net>
References: <20070926131938.575572000@sipsolutions.net>
Date: Wed, 26 Sep 2007 15:19:46 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: [patch 08/12] cfg80211: fix initialisation if built-in
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When cfg80211 is built into the kernel it needs to init earlier
so that device registrations are run after it has initialised.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/wireless/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-dev.orig/net/wireless/core.c	2007-09-25 23:28:20.871571505 +0200
+++ wireless-dev/net/wireless/core.c	2007-09-25 23:29:38.641571994 +0200
@@ -360,7 +360,7 @@ out_fail_notifier:
 out_fail_sysfs:
 	return err;
 }
-module_init(cfg80211_init);
+subsys_initcall(cfg80211_init);
 
 static void cfg80211_exit(void)
 {

-- 

