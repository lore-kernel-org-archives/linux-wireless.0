Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:50534 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbaAROfV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jan 2014 09:35:21 -0500
Received: by mail-pd0-f176.google.com with SMTP id r10so5116363pdi.21
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jan 2014 06:35:21 -0800 (PST)
From: Chaitanya T K <chaitanya.mgit@gmail.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	mcgrof@do-not-panic.com
Cc: Chaitanya T K <chaitanya.mgit@gmail.com>
Subject: [PATCH V2] cfg80211: Do not call CRDA when using internal regulatory database
Date: Sat, 18 Jan 2014 07:09:26 +0530
Message-Id: <1390009167-4766-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20140118_153626_224493_7FF84FF9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using internal regulatory data base kconfig option,
do not try to call crda. This completely defeats the 
purpose of enabling internal regulatory db.

Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
---
V2: 
   Use Proper Error codes while returning
   Fix the call_crda if condition.
---
 net/wireless/reg.c |   29 +++++++++++++++--------------
 net/wireless/reg.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7d20d84..1f9e67d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -454,16 +454,16 @@ static void reg_regdb_search(struct work_struct *work)
 
 static DECLARE_WORK(reg_regdb_work, reg_regdb_search);
 
-static void reg_regdb_query(const char *alpha2)
+static int reg_regdb_query(const char *alpha2)
 {
 	struct reg_regdb_search_request *request;
 
 	if (!alpha2)
-		return;
+		return -EINVAL;
 
 	request = kzalloc(sizeof(struct reg_regdb_search_request), GFP_KERNEL);
 	if (!request)
-		return;
+		return -ENOMEM;
 
 	memcpy(request->alpha2, alpha2, 2);
 
@@ -472,6 +472,7 @@ static void reg_regdb_query(const char *alpha2)
 	mutex_unlock(&reg_regdb_search_mutex);
 
 	schedule_work(&reg_regdb_work);
+	return 0;
 }
 
 /* Feel free to add any other sanity checks here */
@@ -482,7 +483,15 @@ static void reg_regdb_size_check(void)
 }
 #else
 static inline void reg_regdb_size_check(void) {}
-static inline void reg_regdb_query(const char *alpha2) {}
+static inline int reg_regdb_query(const char *alpha2)
+{
+	if (!is_world_regdom((char *) alpha2))
+		pr_info("Calling CRDA for country: %c%c\n",
+			alpha2[0], alpha2[1]);
+	else
+		pr_info("Calling CRDA to update world regulatory domain\n");
+	return kobject_uevent(&reg_pdev->dev.kobj, KOBJ_CHANGE);
+}
 #endif /* CONFIG_CFG80211_INTERNAL_REGDB */
 
 /*
@@ -492,22 +501,14 @@ static inline void reg_regdb_query(const char *alpha2) {}
  */
 static int call_crda(const char *alpha2)
 {
-	if (!is_world_regdom((char *) alpha2))
-		pr_info("Calling CRDA for country: %c%c\n",
-			alpha2[0], alpha2[1]);
-	else
-		pr_info("Calling CRDA to update world regulatory domain\n");
-
-	/* query internal regulatory database (if it exists) */
-	reg_regdb_query(alpha2);
-
-	return kobject_uevent(&reg_pdev->dev.kobj, KOBJ_CHANGE);
+	/* query internal regulatory database/crda depending on config */
+	return reg_regdb_query(alpha2);
 }
 
 static enum reg_request_treatment
 reg_call_crda(struct regulatory_request *request)
 {
-	if (call_crda(request->alpha2))
+	if (call_crda(request->alpha2) < 0)
 		return REG_REQ_IGNORE;
 	return REG_REQ_OK;
 }
