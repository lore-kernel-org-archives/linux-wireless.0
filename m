Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33189 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab0ECHVU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 03:21:20 -0400
Subject: [PATCH] mac80211_hwsim: fix double-scan detection
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 09:21:14 +0200
Message-ID: <1272871274.3614.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, hwsim will always detect a double scan
after the first one has finished ...

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/mac80211_hwsim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2010-05-03 09:19:54.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2010-05-03 09:20:01.000000000 +0200
@@ -1021,7 +1021,7 @@ static void mac80211_hwsim_sw_scan_compl
 	mutex_lock(&hwsim->mutex);
 
 	printk(KERN_DEBUG "hwsim sw_scan_complete\n");
-	hwsim->scanning = true;
+	hwsim->scanning = false;
 
 	mutex_unlock(&hwsim->mutex);
 }


