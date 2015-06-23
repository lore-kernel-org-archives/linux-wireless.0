Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51883 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbbFWSPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 14:15:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: remove superfluous if statement in regulatory code
Date: Tue, 23 Jun 2015 14:11:06 -0400
Message-Id: <1435083066-6750-1-git-send-email-linville@tuxdriver.com> (sfid-20150623_201531_955987_A8AAC7BB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In reg_process_hint, the test of "treatment == REG_REQ_IGNORE ||
treatment == REG_REQ_ALREADY_SET" is superfluous because the code in the
if-then branch is identical to the code after the if statement.

Coverity CID #1295939

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/wireless/reg.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index d359e0610198..fe6b0c6cca10 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2080,9 +2080,6 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		return;
 	case NL80211_REGDOM_SET_BY_USER:
 		treatment = reg_process_hint_user(reg_request);
-		if (treatment == REG_REQ_IGNORE ||
-		    treatment == REG_REQ_ALREADY_SET)
-			return;
 		return;
 	case NL80211_REGDOM_SET_BY_DRIVER:
 		if (!wiphy)
-- 
2.1.0

