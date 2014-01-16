Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:57594 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaAPWDT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 17:03:19 -0500
Received: by mail-pa0-f51.google.com with SMTP id ld10so932788pab.10
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 14:03:19 -0800 (PST)
From: Chaitanya T K <chaitanya.mgit@gmail.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: Chaitanya T K <chaitanya.mgit@gmail.com>
Subject: [PATCH] cfg80211: Do not call CRDA when using internal regulatory database
Date: Fri, 17 Jan 2014 03:32:38 +0530
Message-Id: <1389909758-6807-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20140116_230323_363112_855E03F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using internal regulatory data base kconfig option
do not try to call crda, this complely defeats the 
purposes of enabling internal regulatory db.

Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>

---
 net/wireless/reg.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7d20d84..1cb0f99 100644
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
+		return -1;
 
 	request = kzalloc(sizeof(struct reg_regdb_search_request), GFP_KERNEL);
 	if (!request)
-		return;
+		return -1;
 
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
@@ -492,16 +501,8 @@ static inline void reg_regdb_query(const char *alpha2) {}
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
