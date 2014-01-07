Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48605 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbaAGXPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 18:15:21 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 01/12] mac80211_hwsim: clean up netlink exit code
Date: Wed,  8 Jan 2014 00:15:06 +0100
Message-Id: <1389136517-21216-2-git-send-email-johannes@sipsolutions.net> (sfid-20140108_001525_491129_2C55A377)
In-Reply-To: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net>
References: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to print a message, and genl_unregister_family()
can't really fail so remove the error message there as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 59c65c3..03d7b1d 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2180,20 +2180,14 @@ failure:
 
 static void hwsim_exit_netlink(void)
 {
-	int ret;
-
 	/* userspace test API hasn't been adjusted for multi-channel */
 	if (channels > 1)
 		return;
 
-	printk(KERN_INFO "mac80211_hwsim: closing netlink\n");
 	/* unregister the notifier */
 	netlink_unregister_notifier(&hwsim_netlink_notifier);
 	/* unregister the family */
-	ret = genl_unregister_family(&hwsim_genl_family);
-	if (ret)
-		printk(KERN_DEBUG "mac80211_hwsim: "
-		       "unregister family %i\n", ret);
+	genl_unregister_family(&hwsim_genl_family);
 }
 
 static const struct ieee80211_iface_limit hwsim_if_limits[] = {
-- 
1.8.5.1

