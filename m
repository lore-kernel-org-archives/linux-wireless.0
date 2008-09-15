Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38845 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbYIOJ0y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 05:26:54 -0400
Subject: [PATCH] cfg80211: clean up static regdomain mess
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 11:26:47 +0200
Message-Id: <1221470807.3700.39.camel@johannes.berg> (sfid-20080915_112658_109747_1957F692)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The statically defined regdomains are used in a very convoluted
way, use them instead to prime the information we have and then
continue operating normally.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
More #ifdef mess removal, now I think I'm mostly happy though I think
the static regdom thing should use the same hint function that drivers
can use to hint an existing regulatory structure instead.

 net/wireless/reg.c |   75 ++++++++++++++---------------------------------------
 1 file changed, 21 insertions(+), 54 deletions(-)

--- everything.orig/net/wireless/reg.c	2008-09-15 11:11:33.000000000 +0200
+++ everything/net/wireless/reg.c	2008-09-15 11:20:34.000000000 +0200
@@ -174,32 +174,27 @@ static bool is_old_static_regdom(const s
 		return true;
 	return false;
 }
-
-/* The old crap never deals with a world regulatory domain, it only
- * deals with the static regulatory domain passed and if possible
- * an updated "US" or "JP" regulatory domain. We do however store the
- * old static regulatory domain in cfg80211_world_regdom for convenience
- * of use here */
-static void reset_regdomains_static(void)
-{
-	if (!is_old_static_regdom(cfg80211_regdomain))
-		kfree(cfg80211_regdomain);
-	/* This is setting the regdom to the old static regdom */
-	cfg80211_regdomain =
-		(struct ieee80211_regdomain *) cfg80211_world_regdom;
-}
 #else
+static inline bool is_old_static_regdom(const struct ieee80211_regdomain *rd)
+{
+	return false;
+}
+#endif
+
 static void reset_regdomains(void)
 {
-	if (cfg80211_world_regdom && cfg80211_world_regdom != &world_regdom) {
-		if (cfg80211_world_regdom == cfg80211_regdomain) {
-			kfree(cfg80211_regdomain);
-		} else {
-			kfree(cfg80211_world_regdom);
-			kfree(cfg80211_regdomain);
-		}
-	} else if (cfg80211_regdomain && cfg80211_regdomain != &world_regdom)
-		kfree(cfg80211_regdomain);
+	/* avoid freeing static information or freeing something twice */
+	if (cfg80211_regdomain == cfg80211_world_regdom)
+		cfg80211_regdomain = NULL;
+	if (cfg80211_world_regdom == &world_regdom)
+		cfg80211_world_regdom = NULL;
+	if (cfg80211_regdomain == &world_regdom)
+		cfg80211_regdomain = NULL;
+	if (is_old_static_regdom(cfg80211_regdomain))
+		cfg80211_regdomain = NULL;
+
+	kfree(cfg80211_regdomain);
+	kfree(cfg80211_world_regdom);
 
 	cfg80211_world_regdom = &world_regdom;
 	cfg80211_regdomain = NULL;
@@ -216,7 +211,6 @@ static void update_world_regdomain(const
 	cfg80211_world_regdom = rd;
 	cfg80211_regdomain = rd;
 }
-#endif
 
 bool is_world_regdom(const char *alpha2)
 {
@@ -297,12 +291,8 @@ static int call_crda(const char *alpha2)
 		printk(KERN_INFO "cfg80211: Calling CRDA for country: %c%c\n",
 			alpha2[0], alpha2[1]);
 	else
-#ifdef CONFIG_WIRELESS_OLD_REGULATORY
-		return -EINVAL;
-#else
 		printk(KERN_INFO "cfg80211: Calling CRDA to update world "
 			"regulatory domain\n");
-#endif
 
 	country_env[8] = alpha2[0];
 	country_env[9] = alpha2[1];
@@ -728,20 +718,12 @@ static int __set_regdom(const struct iee
 
 	/* Some basic sanity checks first */
 
-#ifdef CONFIG_WIRELESS_OLD_REGULATORY
-	/* We ignore the world regdom with the old static regdomains setup
-	 * as there is no point to it with static regulatory definitions :(
-	 * Don't worry this shit will be removed soon... */
-	if (is_world_regdom(rd->alpha2))
-		return -EINVAL;
-#else
 	if (is_world_regdom(rd->alpha2)) {
 		if (WARN_ON(!__reg_is_valid_request(rd->alpha2, &request)))
 			return -EINVAL;
 		update_world_regdomain(rd);
 		return 0;
 	}
-#endif
 
 	if (!is_alpha2_set(rd->alpha2) && !is_an_alpha2(rd->alpha2) &&
 			!is_unknown_alpha2(rd->alpha2))
@@ -750,15 +732,10 @@ static int __set_regdom(const struct iee
 	if (list_empty(&regulatory_requests))
 		return -EINVAL;
 
-#ifdef CONFIG_WIRELESS_OLD_REGULATORY
-	/* Static "US" and "JP" will be overridden, but just once */
+	/* allow overriding the static definitions if CRDA is present */
 	if (!is_old_static_regdom(cfg80211_regdomain) &&
-			!regdom_changed(rd->alpha2))
-		return -EINVAL;
-#else
-	if (!regdom_changed(rd->alpha2))
+	    !regdom_changed(rd->alpha2))
 		return -EINVAL;
-#endif
 
 	/* Now lets set the regulatory domain, update all driver channels
 	 * and finally inform them of what we have done, in case they want
@@ -768,11 +745,7 @@ static int __set_regdom(const struct iee
 	if (WARN_ON(!__reg_is_valid_request(rd->alpha2, &request)))
 		return -EINVAL;
 
-#ifdef CONFIG_WIRELESS_OLD_REGULATORY
-	reset_regdomains_static();
-#else
 	reset_regdomains();
-#endif
 
 	/* Country IE parsing coming soon */
 	switch (request->initiator) {
@@ -858,10 +831,8 @@ int regulatory_init(void)
 
 #ifdef CONFIG_WIRELESS_OLD_REGULATORY
 	cfg80211_regdomain = static_regdom(ieee80211_regdom);
-	/* Used during reset_regdomains_static() */
-	cfg80211_world_regdom = cfg80211_regdomain;
 
-	printk(KERN_INFO "cfg80211: Using old static regulatory domain:\n");
+	printk(KERN_INFO "cfg80211: Using static regulatory domain info\n");
 	print_regdomain_info(cfg80211_regdomain);
 	/* The old code still requests for a new regdomain and if
 	 * you have CRDA you get it updated, otherwise you get
@@ -889,11 +860,7 @@ void regulatory_exit(void)
 
 	mutex_lock(&cfg80211_drv_mutex);
 
-#ifdef CONFIG_WIRELESS_OLD_REGULATORY
-	reset_regdomains_static();
-#else
 	reset_regdomains();
-#endif
 
 	list_for_each_entry_safe(req, req_tmp, &regulatory_requests, list) {
 		list_del(&req->list);


