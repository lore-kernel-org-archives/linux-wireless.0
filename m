Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38703 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbbJON63 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 09:58:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 07/12] cfg80211: reg: rename reg_regdb_query() to reg_query_builtin()
Date: Thu, 15 Oct 2015 15:58:18 +0200
Message-Id: <1444917503-19118-7-git-send-email-johannes@sipsolutions.net> (sfid-20151015_155837_975304_526F2FA5)
In-Reply-To: <1444917503-19118-1-git-send-email-johannes@sipsolutions.net>
References: <1444917503-19118-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The new name better reflects the functionality.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 408cae3574bb..5532ecc080e5 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -478,7 +478,7 @@ static void reg_regdb_apply(struct work_struct *work)
 
 static DECLARE_WORK(reg_regdb_work, reg_regdb_apply);
 
-static int reg_regdb_query(const char *alpha2)
+static int reg_query_builtin(const char *alpha2)
 {
 	const struct ieee80211_regdomain *regdom = NULL;
 	struct reg_regdb_apply_request *request;
@@ -521,7 +521,7 @@ static void reg_regdb_size_check(void)
 }
 #else
 static inline void reg_regdb_size_check(void) {}
-static inline int reg_regdb_query(const char *alpha2)
+static inline int reg_query_builtin(const char *alpha2)
 {
 	return -ENODATA;
 }
@@ -605,7 +605,7 @@ static inline int call_crda(const char *alpha2)
 static bool reg_query_database(struct regulatory_request *request)
 {
 	/* query internal regulatory database (if it exists) */
-	if (reg_regdb_query(request->alpha2) == 0)
+	if (reg_query_builtin(request->alpha2) == 0)
 		return true;
 
 	if (call_crda(request->alpha2) == 0)
-- 
2.5.1

