Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49188 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784Ab2IFPJU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 11:09:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: move module_init/exit
Date: Thu,  6 Sep 2012 17:09:57 +0200
Message-Id: <1346944197-13140-1-git-send-email-johannes@sipsolutions.net> (sfid-20120906_170924_292556_5DAAC6EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These should be with the functions so move
the module_init/exit statements.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 72b0456..e603adb 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2056,7 +2056,7 @@ failed:
 	mac80211_hwsim_free();
 	return err;
 }
-
+module_init(init_mac80211_hwsim);
 
 static void __exit exit_mac80211_hwsim(void)
 {
@@ -2067,7 +2067,4 @@ static void __exit exit_mac80211_hwsim(void)
 	mac80211_hwsim_free();
 	unregister_netdev(hwsim_mon);
 }
-
-
-module_init(init_mac80211_hwsim);
 module_exit(exit_mac80211_hwsim);
-- 
1.7.10.4

