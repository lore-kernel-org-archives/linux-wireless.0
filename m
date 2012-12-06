Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53244 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946023Ab2LFQsT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:48:19 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 20/24] regulatory: fix memory leak
Date: Thu,  6 Dec 2012 17:47:44 +0100
Message-Id: <1354812468-15709-21-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174906_497465_94644E48)
In-Reply-To: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If duplicating here fails, we leak the original.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 011fab9..5a34830 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2120,8 +2120,10 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 			return -EALREADY;
 
 		regd = reg_copy_regd(rd);
-		if (IS_ERR(regd))
+		if (IS_ERR(regd)) {
+			kfree(rd);
 			return PTR_ERR(regd);
+		}
 
 		request_wiphy->regd = regd;
 		reset_regdomains(false);
-- 
1.8.0

