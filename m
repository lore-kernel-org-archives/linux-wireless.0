Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38691 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbbJON61 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 09:58:27 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 01/12] cfg80211: reg: remove useless non-NULL check
Date: Thu, 15 Oct 2015 15:58:12 +0200
Message-Id: <1444917503-19118-1-git-send-email-johannes@sipsolutions.net> (sfid-20151015_155831_362542_AE6EDF46)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no way that the alpha2 pointer can be NULL, so
no point in checking that it isn't.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7258246b7458..3acb51462cc6 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -501,9 +501,6 @@ static void reg_regdb_query(const char *alpha2)
 {
 	struct reg_regdb_search_request *request;
 
-	if (!alpha2)
-		return;
-
 	request = kzalloc(sizeof(struct reg_regdb_search_request), GFP_KERNEL);
 	if (!request)
 		return;
-- 
2.5.1

