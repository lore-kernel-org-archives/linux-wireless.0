Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36448 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbbFXPpV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2015 11:45:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] wireless: remove superfluous if statement in regulatory code
Date: Wed, 24 Jun 2015 11:42:25 -0400
Message-Id: <1435160545-30729-1-git-send-email-linville@tuxdriver.com> (sfid-20150624_174531_432234_89FCC66F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit eeca9fce1d71 ('cfg80211: Schedule timeout for all CRDA calls')
left behind a superfluous check after it removed some earlier code.

In reg_process_hint, the test of "treatment == REG_REQ_IGNORE ||
treatment == REG_REQ_ALREADY_SET" is superfluous because the code in the
if-then branch is identical to the code after the if statement.

Coverity CID #1295939

I also removed the unnecessary assignment of treatment in this case,
and added a comment reminding any future patch authors to ensure that
treatment is properly assigned before it is used after the switch.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
v2 - address comments from Jouni Malinen

 net/wireless/reg.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index d359e0610198..62d8ea42dbfb 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2079,10 +2079,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		reg_process_hint_core(reg_request);
 		return;
 	case NL80211_REGDOM_SET_BY_USER:
-		treatment = reg_process_hint_user(reg_request);
-		if (treatment == REG_REQ_IGNORE ||
-		    treatment == REG_REQ_ALREADY_SET)
-			return;
+		reg_process_hint_user(reg_request);
 		return;
 	case NL80211_REGDOM_SET_BY_DRIVER:
 		if (!wiphy)
@@ -2099,7 +2096,9 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		goto out_free;
 	}
 
-	/* This is required so that the orig_* parameters are saved */
+	/* This is required so that the orig_* parameters are saved.
+	 * NOTE: treatment must be set for any case that reaches here!
+	 */
 	if (treatment == REG_REQ_ALREADY_SET && wiphy &&
 	    wiphy->regulatory_flags & REGULATORY_STRICT_REG) {
 		wiphy_update_regulatory(wiphy, reg_request->initiator);
-- 
2.1.0

