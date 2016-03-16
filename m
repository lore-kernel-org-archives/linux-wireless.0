Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55904 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933804AbcCPNbg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 09:31:36 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wext: unregister_pernet_subsys() on notifier registration failure
Date: Wed, 16 Mar 2016 14:31:26 +0100
Message-Id: <1458135086-30021-1-git-send-email-johannes@sipsolutions.net> (sfid-20160316_143139_590037_8785D7E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If register_netdevice_notifier() fails (which in practice it can't
right now), we should call unregister_pernet_subsys(). Do that.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/wext-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index b50ee5d622e1..6250b1cfcde5 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -399,7 +399,10 @@ static int __init wireless_nlevent_init(void)
 	if (err)
 		return err;
 
-	return register_netdevice_notifier(&wext_netdev_notifier);
+	err = register_netdevice_notifier(&wext_netdev_notifier);
+	if (err)
+		unregister_pernet_subsys(&wext_pernet_ops);
+	return err;
 }
 
 subsys_initcall(wireless_nlevent_init);
-- 
2.7.0

