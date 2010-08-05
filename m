Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54250 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab0HES34 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 14:29:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: upcase alpha2 values in queue_regulatory_request
Date: Thu,  5 Aug 2010 14:28:52 -0400
Message-Id: <1281032932-7271-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This provides a little more flexibility for human users, and it allows
us to use isalpha rather than the custom is_alpha_upper.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/wireless/reg.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f180db0..b0d9a08 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -36,6 +36,7 @@
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/random.h>
+#include <linux/ctype.h>
 #include <linux/nl80211.h>
 #include <linux/platform_device.h>
 #include <net/cfg80211.h>
@@ -181,14 +182,6 @@ static bool is_alpha2_set(const char *alpha2)
 	return false;
 }
 
-static bool is_alpha_upper(char letter)
-{
-	/* ASCII A - Z */
-	if (letter >= 65 && letter <= 90)
-		return true;
-	return false;
-}
-
 static bool is_unknown_alpha2(const char *alpha2)
 {
 	if (!alpha2)
@@ -220,7 +213,7 @@ static bool is_an_alpha2(const char *alpha2)
 {
 	if (!alpha2)
 		return false;
-	if (is_alpha_upper(alpha2[0]) && is_alpha_upper(alpha2[1]))
+	if (isalpha(alpha2[0]) && isalpha(alpha2[1]))
 		return true;
 	return false;
 }
@@ -1399,6 +1392,11 @@ static DECLARE_WORK(reg_work, reg_todo);
 
 static void queue_regulatory_request(struct regulatory_request *request)
 {
+	if (isalpha(request->alpha2[0]))
+		request->alpha2[0] = toupper(request->alpha2[0]);
+	if (isalpha(request->alpha2[1]))
+		request->alpha2[1] = toupper(request->alpha2[1]);
+
 	spin_lock(&reg_requests_lock);
 	list_add_tail(&request->list, &reg_requests_list);
 	spin_unlock(&reg_requests_lock);
-- 
1.7.2

