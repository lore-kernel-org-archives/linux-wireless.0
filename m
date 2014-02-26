Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:53237 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbaBZBJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 20:09:55 -0500
Received: by mail-pb0-f50.google.com with SMTP id md12so216575pbc.37
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 17:09:54 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linux@eikelenboom.it,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 1/3] cfg80211: allow reprocessing of pending requests
Date: Tue, 25 Feb 2014 17:09:40 -0800
Message-Id: <1393376982-28276-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20140226_021006_412249_4631A0AE)
In-Reply-To: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
References: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In certain situations we want to trigger reprocessing
of the last regulatory hint. One situation in which
this makes sense is the case where the cfg80211 was
built-in to the kernel, CFG80211_INTERNAL_REGDB was not
enabled and the CRDA binary is on a partition not availble
during early boot. In such a case we want to be able to
re-process the same request at some other point.

When we are asked to re-process the same request we need
to be careful to not kfree it, addresses that.

Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b95e9cf..f5b120f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -240,19 +240,21 @@ static char user_alpha2[2];
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
1.8.5.3

