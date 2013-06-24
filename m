Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36139 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3FXNqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 09:46:18 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] regulatory: add missing rtnl locking
Date: Mon, 24 Jun 2013 15:46:12 +0200
Message-Id: <1372081572-31380-1-git-send-email-johannes@sipsolutions.net> (sfid-20130624_154621_882109_DB278854)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

restore_regulatory_settings() requires the RTNL to be held,
add the missing locking in reg_timeout_work().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5a24c98..5a950f3 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2279,7 +2279,9 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
 static void reg_timeout_work(struct work_struct *work)
 {
 	REG_DBG_PRINT("Timeout while waiting for CRDA to reply, restoring regulatory settings\n");
+	rtnl_lock();
 	restore_regulatory_settings(true);
+	rtnl_unlock();
 }
 
 int __init regulatory_init(void)
-- 
1.8.0

