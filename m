Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46399 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbZGMLEq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 07:04:46 -0400
Subject: [PATCH] mac80211_hwsim: fix unregistration
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 13:04:30 +0200
Message-Id: <1247483078.4166.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you rmmod the module while associated, frames might
be transmitted during unregistration -- which will crash
if the hwsim%d interface is unregistered first, so only
do that after all the virtual wiphys are gone.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/mac80211_hwsim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-07-13 13:01:01.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-07-13 13:01:54.000000000 +0200
@@ -1250,8 +1250,8 @@ static void __exit exit_mac80211_hwsim(v
 {
 	printk(KERN_DEBUG "mac80211_hwsim: unregister radios\n");
 
-	unregister_netdev(hwsim_mon);
 	mac80211_hwsim_free();
+	unregister_netdev(hwsim_mon);
 }
 
 


