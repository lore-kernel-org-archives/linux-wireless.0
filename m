Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37507 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbbJOJrD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 05:47:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6/6] cfg80211: reg: rename reg_regdb_query() to reg_query_builtin()
Date: Thu, 15 Oct 2015 11:46:58 +0200
Message-Id: <1444902418-25668-6-git-send-email-johannes@sipsolutions.net> (sfid-20151015_114720_596384_61E00949)
In-Reply-To: <1444902418-25668-1-git-send-email-johannes@sipsolutions.net>
References: <1444902418-25668-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The new name better reflects the functionality.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2d1343a7b60e..156a7d6eaf95 100644
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
@@ -606,7 +606,7 @@ static enum reg_request_treatment
 reg_query_database(struct regulatory_request *request)
 {
 	/* query internal regulatory database (if it exists) */
-	if (reg_regdb_query(request->alpha2) == 0)
+	if (reg_query_builtin(request->alpha2) == 0)
 		return REG_REQ_OK;
 
 	if (call_crda(request->alpha2) == 0)
-- 
2.5.1

