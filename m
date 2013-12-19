Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:55719 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab3LSUxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 15:53:30 -0500
Received: by mail-pb0-f47.google.com with SMTP id um1so1651227pbc.34
        for <linux-wireless@vger.kernel.org>; Thu, 19 Dec 2013 12:53:29 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux@eikelenboom.it, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 1/3] cfg80211: allow reprocessing of pending requests
Date: Thu, 19 Dec 2013 12:53:17 -0800
Message-Id: <1387486399-4053-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131219_215332_946246_6C654467)
In-Reply-To: <1387486399-4053-1-git-send-email-mcgrof@do-not-panic.com>
References: <1387486399-4053-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This addresses the RCU component of allowing us to reprocess
the last regulatory request.

Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9b897fc..5be2d7c 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -244,19 +244,21 @@ static char user_alpha2[2];
 module_param(ieee80211_regdom, charp, 0444);
 MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
 
-static void reg_kfree_last_request(void)
+static void reg_kfree_last_request(struct regulatory_request *lr)
 {
-	struct regulatory_request *lr;
-
-	lr = get_last_request();
-
 	if (lr != &core_request_world && lr)
 		kfree_rcu(lr, rcu_head);
 }
 
 static void reg_update_last_request(struct regulatory_request *request)
 {
-	reg_kfree_last_request();
+	struct regulatory_request *lr;
+
+	lr = get_last_request();
+	if (lr == request)
+		return;
+
+	reg_kfree_last_request(lr);
 	rcu_assign_pointer(last_request, request);
 }
 
-- 
1.8.4.3

