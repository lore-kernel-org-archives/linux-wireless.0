Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:38896 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751160AbdJZJ2D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Oct 2017 05:28:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: initialize regulatory keys/database later
Date: Thu, 26 Oct 2017 11:28:00 +0200
Message-Id: <20171026092800.11598-1-johannes@sipsolutions.net> (sfid-20171026_112806_807624_A729D9C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When cfg80211 is built as a module, everything is fine, and we
can keep the code as is; in fact, we have to, because there can
only be a single module_init().

When cfg80211 is built-in, however, it needs to initialize
before drivers (device_initcall/module_init), and thus used to
be at subsys_initcall(). I'd moved it to fs_initcall() earlier,
where it can remain. However, this is still too early because at
that point the key infrastructure hasn't been initialized yet,
so X.509 certificates can't be parsed yet.

To work around this problem, load the regdb keys only later in
a late_initcall(), at which point the necessary infrastructure
has been initialized.

Fixes: 90a53e4432b1 ("cfg80211: implement regdb signature checking")
Reported-by: Xiaolong Ye <xiaolong.ye@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3871998059de..78e71b0390be 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3644,27 +3644,14 @@ void regulatory_propagate_dfs_state(struct wiphy *wiphy,
 	}
 }
 
-int __init regulatory_init(void)
+static int __init regulatory_init_db(void)
 {
-	int err = 0;
+	int err;
 
 	err = load_builtin_regdb_keys();
 	if (err)
 		return err;
 
-	reg_pdev = platform_device_register_simple("regulatory", 0, NULL, 0);
-	if (IS_ERR(reg_pdev))
-		return PTR_ERR(reg_pdev);
-
-	spin_lock_init(&reg_requests_lock);
-	spin_lock_init(&reg_pending_beacons_lock);
-	spin_lock_init(&reg_indoor_lock);
-
-	rcu_assign_pointer(cfg80211_regdomain, cfg80211_world_regdom);
-
-	user_alpha2[0] = '9';
-	user_alpha2[1] = '7';
-
 	/* We always try to get an update for the static regdomain */
 	err = regulatory_hint_core(cfg80211_world_regdom->alpha2);
 	if (err) {
@@ -3692,6 +3679,31 @@ int __init regulatory_init(void)
 
 	return 0;
 }
+#ifndef MODULE
+late_initcall(regulatory_init_db);
+#endif
+
+int __init regulatory_init(void)
+{
+	reg_pdev = platform_device_register_simple("regulatory", 0, NULL, 0);
+	if (IS_ERR(reg_pdev))
+		return PTR_ERR(reg_pdev);
+
+	spin_lock_init(&reg_requests_lock);
+	spin_lock_init(&reg_pending_beacons_lock);
+	spin_lock_init(&reg_indoor_lock);
+
+	rcu_assign_pointer(cfg80211_regdomain, cfg80211_world_regdom);
+
+	user_alpha2[0] = '9';
+	user_alpha2[1] = '7';
+
+#ifdef MODULE
+	return regulatory_init_db();
+#else
+	return 0;
+#endif
+}
 
 void regulatory_exit(void)
 {
-- 
2.14.2
