Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42667 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbYIOIpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 04:45:33 -0400
Subject: [PATCH] cfg80211: clean up regulatory mess
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 10:45:26 +0200
Message-Id: <1221468326.3700.29.camel@johannes.berg> (sfid-20080915_104537_374315_FE9CA10C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The recent code from Luis is an #ifdef hell and contains lots of
code that's stuffed into the wrong file making a whole bunch of
things needlessly non-static, and besides, what is it doing in
core.c??

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c |  144 ------------------------------
 net/wireless/reg.c  |  248 ++++++++++++++++++++++++++++++++++++++++------------
 net/wireless/reg.h  |   35 -------
 3 files changed, 197 insertions(+), 230 deletions(-)

--- everything.orig/net/wireless/core.c	2008-09-15 10:30:50.000000000 +0200
+++ everything/net/wireless/core.c	2008-09-15 10:37:21.000000000 +0200
@@ -29,107 +29,6 @@ MODULE_AUTHOR("Johannes Berg");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("wireless configuration support");
 
-struct list_head regulatory_requests;
-
-/* Central wireless core regulatory domains, we only need two,
- * the current one and a world regulatory domain in case we have no
- * information to give us an alpha2 */
-struct ieee80211_regdomain *cfg80211_regdomain;
-
-/* We keep a static world regulatory domain in case of the absence of CRDA */
-const struct ieee80211_regdomain world_regdom = {
-	.n_reg_rules = 1,
-	.alpha2 =  "00",
-	.reg_rules = {
-		REG_RULE(2412-10, 2462+10, 40, 6, 20,
-			NL80211_RRF_PASSIVE_SCAN |
-			NL80211_RRF_NO_IBSS),
-	}
-};
-
-#ifdef CONFIG_WIRELESS_OLD_REGULATORY
-/* All this fucking static junk will be removed soon, so
- * don't fucking count on it !@#$ */
-
-static char *ieee80211_regdom = "US";
-module_param(ieee80211_regdom, charp, 0444);
-MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
-
-/* We assume 40 MHz bandwidth for the old regulatory work.
- * We make emphasis we are using the exact same frequencies
- * as before */
-
-const struct ieee80211_regdomain us_regdom = {
-	.n_reg_rules = 6,
-	.alpha2 =  "US",
-	.reg_rules = {
-		/* IEEE 802.11b/g, channels 1..11 */
-		REG_RULE(2412-10, 2462+10, 40, 6, 27, 0),
-		/* IEEE 802.11a, channel 36 */
-		REG_RULE(5180-10, 5180+10, 40, 6, 23, 0),
-		/* IEEE 802.11a, channel 40 */
-		REG_RULE(5200-10, 5200+10, 40, 6, 23, 0),
-		/* IEEE 802.11a, channel 44 */
-		REG_RULE(5220-10, 5220+10, 40, 6, 23, 0),
-		/* IEEE 802.11a, channels 48..64 */
-		REG_RULE(5240-10, 5320+10, 40, 6, 23, 0),
-		/* IEEE 802.11a, channels 149..165, outdoor */
-		REG_RULE(5745-10, 5825+10, 40, 6, 30, 0),
-	}
-};
-
-const struct ieee80211_regdomain jp_regdom = {
-	.n_reg_rules = 3,
-	.alpha2 =  "JP",
-	.reg_rules = {
-		/* IEEE 802.11b/g, channels 1..14 */
-		REG_RULE(2412-10, 2484+10, 40, 6, 20, 0),
-		/* IEEE 802.11a, channels 34..48 */
-		REG_RULE(5170-10, 5240+10, 40, 6, 20,
-			NL80211_RRF_PASSIVE_SCAN),
-		/* IEEE 802.11a, channels 52..64 */
-		REG_RULE(5260-10, 5320+10, 40, 6, 20,
-			NL80211_RRF_NO_IBSS |
-			NL80211_RRF_DFS),
-	}
-};
-
-const struct ieee80211_regdomain eu_regdom = {
-	.n_reg_rules = 6,
-	/* This alpha2 is bogus, we leave it here just for stupid
-	 * backward compatibility */
-	.alpha2 =  "EU",
-	.reg_rules = {
-		/* IEEE 802.11b/g, channels 1..13 */
-		REG_RULE(2412-10, 2472+10, 40, 6, 20, 0),
-		/* IEEE 802.11a, channel 36 */
-		REG_RULE(5180-10, 5180+10, 40, 6, 23,
-			NL80211_RRF_PASSIVE_SCAN),
-		/* IEEE 802.11a, channel 40 */
-		REG_RULE(5200-10, 5200+10, 40, 6, 23,
-			NL80211_RRF_PASSIVE_SCAN),
-		/* IEEE 802.11a, channel 44 */
-		REG_RULE(5220-10, 5220+10, 40, 6, 23,
-			NL80211_RRF_PASSIVE_SCAN),
-		/* IEEE 802.11a, channels 48..64 */
-		REG_RULE(5240-10, 5320+10, 40, 6, 20,
-			NL80211_RRF_NO_IBSS |
-			NL80211_RRF_DFS),
-		/* IEEE 802.11a, channels 100..140 */
-		REG_RULE(5500-10, 5700+10, 40, 6, 30,
-			NL80211_RRF_NO_IBSS |
-			NL80211_RRF_DFS),
-	}
-};
-
-#endif
-
-struct ieee80211_regdomain *cfg80211_world_regdom =
-	(struct ieee80211_regdomain *) &world_regdom;
-
-LIST_HEAD(regulatory_requests);
-DEFINE_MUTEX(cfg80211_reg_mutex);
-
 /* RCU might be appropriate here since we usually
  * only read the list, and that can happen quite
  * often because we need to do it for each command */
@@ -514,34 +413,10 @@ static struct notifier_block cfg80211_ne
 	.notifier_call = cfg80211_netdev_notifier_call,
 };
 
-#ifdef CONFIG_WIRELESS_OLD_REGULATORY
-const struct ieee80211_regdomain *static_regdom(char *alpha2)
-{
-	if (alpha2[0] == 'U' && alpha2[1] == 'S')
-		return &us_regdom;
-	if (alpha2[0] == 'J' && alpha2[1] == 'P')
-		return &jp_regdom;
-	if (alpha2[0] == 'E' && alpha2[1] == 'U')
-		return &eu_regdom;
-	/* Default, as per the old rules */
-	return &us_regdom;
-}
-#endif
-
 static int cfg80211_init(void)
 {
 	int err;
 
-#ifdef CONFIG_WIRELESS_OLD_REGULATORY
-	cfg80211_regdomain =
-		(struct ieee80211_regdomain *) static_regdom(ieee80211_regdom);
-	/* Used during reset_regdomains_static() */
-	cfg80211_world_regdom = cfg80211_regdomain;
-#else
-	cfg80211_regdomain =
-		(struct ieee80211_regdomain *) cfg80211_world_regdom;
-#endif
-
 	err = wiphy_sysfs_init();
 	if (err)
 		goto out_fail_sysfs;
@@ -560,25 +435,6 @@ static int cfg80211_init(void)
 	if (err)
 		goto out_fail_reg;
 
-#ifdef CONFIG_WIRELESS_OLD_REGULATORY
-	printk(KERN_INFO "cfg80211: Using old static regulatory domain:\n");
-	print_regdomain_info(cfg80211_regdomain);
-	/* The old code still requests for a new regdomain and if
-	 * you have CRDA you get it updated, otherwise you get
-	 * stuck with the static values. We ignore "EU" code as
-	 * that is not a valid ISO / IEC 3166 alpha2 */
-	if (ieee80211_regdom[0] != 'E' &&
-			ieee80211_regdom[1] != 'U')
-		err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE,
-			ieee80211_regdom, NULL);
-#else
-	err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE, "00", NULL);
-	if (err)
-		printk(KERN_ERR "cfg80211: calling CRDA failed - "
-			"unable to update world regulatory domain, "
-			"using static definition\n");
-#endif
-
 	return 0;
 
 out_fail_reg:
--- everything.orig/net/wireless/reg.c	2008-09-15 10:30:50.000000000 +0200
+++ everything/net/wireless/reg.c	2008-09-15 10:42:57.000000000 +0200
@@ -42,6 +42,18 @@
 #include "core.h"
 #include "reg.h"
 
+/* wiphy is set if this request's initiator is REGDOM_SET_BY_DRIVER */
+struct regulatory_request {
+	struct list_head list;
+	struct wiphy *wiphy;
+	int granted;
+	enum reg_set_by initiator;
+	char alpha2[2];
+};
+
+static LIST_HEAD(regulatory_requests);
+DEFINE_MUTEX(cfg80211_reg_mutex);
+
 /* To trigger userspace events */
 static struct platform_device *reg_pdev;
 
@@ -51,6 +63,161 @@ static u32 supported_bandwidths[] = {
 	MHZ_TO_KHZ(20),
 };
 
+static struct list_head regulatory_requests;
+
+/* Central wireless core regulatory domains, we only need two,
+ * the current one and a world regulatory domain in case we have no
+ * information to give us an alpha2 */
+static struct ieee80211_regdomain *cfg80211_regdomain;
+
+/* We keep a static world regulatory domain in case of the absence of CRDA */
+static const struct ieee80211_regdomain world_regdom = {
+	.n_reg_rules = 1,
+	.alpha2 =  "00",
+	.reg_rules = {
+		REG_RULE(2412-10, 2462+10, 40, 6, 20,
+			NL80211_RRF_PASSIVE_SCAN |
+			NL80211_RRF_NO_IBSS),
+	}
+};
+
+static struct ieee80211_regdomain *cfg80211_world_regdom =
+	(struct ieee80211_regdomain *) &world_regdom;
+
+#ifdef CONFIG_WIRELESS_OLD_REGULATORY
+static char *ieee80211_regdom = "US";
+module_param(ieee80211_regdom, charp, 0444);
+MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
+
+/* We assume 40 MHz bandwidth for the old regulatory work.
+ * We make emphasis we are using the exact same frequencies
+ * as before */
+
+static const struct ieee80211_regdomain us_regdom = {
+	.n_reg_rules = 6,
+	.alpha2 =  "US",
+	.reg_rules = {
+		/* IEEE 802.11b/g, channels 1..11 */
+		REG_RULE(2412-10, 2462+10, 40, 6, 27, 0),
+		/* IEEE 802.11a, channel 36 */
+		REG_RULE(5180-10, 5180+10, 40, 6, 23, 0),
+		/* IEEE 802.11a, channel 40 */
+		REG_RULE(5200-10, 5200+10, 40, 6, 23, 0),
+		/* IEEE 802.11a, channel 44 */
+		REG_RULE(5220-10, 5220+10, 40, 6, 23, 0),
+		/* IEEE 802.11a, channels 48..64 */
+		REG_RULE(5240-10, 5320+10, 40, 6, 23, 0),
+		/* IEEE 802.11a, channels 149..165, outdoor */
+		REG_RULE(5745-10, 5825+10, 40, 6, 30, 0),
+	}
+};
+
+static const struct ieee80211_regdomain jp_regdom = {
+	.n_reg_rules = 3,
+	.alpha2 =  "JP",
+	.reg_rules = {
+		/* IEEE 802.11b/g, channels 1..14 */
+		REG_RULE(2412-10, 2484+10, 40, 6, 20, 0),
+		/* IEEE 802.11a, channels 34..48 */
+		REG_RULE(5170-10, 5240+10, 40, 6, 20,
+			NL80211_RRF_PASSIVE_SCAN),
+		/* IEEE 802.11a, channels 52..64 */
+		REG_RULE(5260-10, 5320+10, 40, 6, 20,
+			NL80211_RRF_NO_IBSS |
+			NL80211_RRF_DFS),
+	}
+};
+
+static const struct ieee80211_regdomain eu_regdom = {
+	.n_reg_rules = 6,
+	/* This alpha2 is bogus, we leave it here just for stupid
+	 * backward compatibility */
+	.alpha2 =  "EU",
+	.reg_rules = {
+		/* IEEE 802.11b/g, channels 1..13 */
+		REG_RULE(2412-10, 2472+10, 40, 6, 20, 0),
+		/* IEEE 802.11a, channel 36 */
+		REG_RULE(5180-10, 5180+10, 40, 6, 23,
+			NL80211_RRF_PASSIVE_SCAN),
+		/* IEEE 802.11a, channel 40 */
+		REG_RULE(5200-10, 5200+10, 40, 6, 23,
+			NL80211_RRF_PASSIVE_SCAN),
+		/* IEEE 802.11a, channel 44 */
+		REG_RULE(5220-10, 5220+10, 40, 6, 23,
+			NL80211_RRF_PASSIVE_SCAN),
+		/* IEEE 802.11a, channels 48..64 */
+		REG_RULE(5240-10, 5320+10, 40, 6, 20,
+			NL80211_RRF_NO_IBSS |
+			NL80211_RRF_DFS),
+		/* IEEE 802.11a, channels 100..140 */
+		REG_RULE(5500-10, 5700+10, 40, 6, 30,
+			NL80211_RRF_NO_IBSS |
+			NL80211_RRF_DFS),
+	}
+};
+
+static const struct ieee80211_regdomain *static_regdom(char *alpha2)
+{
+	if (alpha2[0] == 'U' && alpha2[1] == 'S')
+		return &us_regdom;
+	if (alpha2[0] == 'J' && alpha2[1] == 'P')
+		return &jp_regdom;
+	if (alpha2[0] == 'E' && alpha2[1] == 'U')
+		return &eu_regdom;
+	/* Default, as per the old rules */
+	return &us_regdom;
+}
+
+static bool is_old_static_regdom(struct ieee80211_regdomain *rd)
+{
+	if (rd == &us_regdom || rd == &jp_regdom || rd == &eu_regdom)
+		return true;
+	return false;
+}
+
+/* The old crap never deals with a world regulatory domain, it only
+ * deals with the static regulatory domain passed and if possible
+ * an updated "US" or "JP" regulatory domain. We do however store the
+ * old static regulatory domain in cfg80211_world_regdom for convenience
+ * of use here */
+static void reset_regdomains_static(void)
+{
+	if (!is_old_static_regdom(cfg80211_regdomain))
+		kfree(cfg80211_regdomain);
+	/* This is setting the regdom to the old static regdom */
+	cfg80211_regdomain =
+		(struct ieee80211_regdomain *) cfg80211_world_regdom;
+}
+#else
+static void reset_regdomains(void)
+{
+	if (cfg80211_world_regdom && cfg80211_world_regdom != &world_regdom) {
+		if (cfg80211_world_regdom == cfg80211_regdomain) {
+			kfree(cfg80211_regdomain);
+		} else {
+			kfree(cfg80211_world_regdom);
+			kfree(cfg80211_regdomain);
+		}
+	} else if (cfg80211_regdomain && cfg80211_regdomain != &world_regdom)
+		kfree(cfg80211_regdomain);
+
+	cfg80211_world_regdom = (struct ieee80211_regdomain *) &world_regdom;
+	cfg80211_regdomain = NULL;
+}
+
+/* Dynamic world regulatory domain requested by the wireless
+ * core upon initialization */
+static void update_world_regdomain(struct ieee80211_regdomain *rd)
+{
+	BUG_ON(list_empty(&regulatory_requests));
+
+	reset_regdomains();
+
+	cfg80211_world_regdom = rd;
+	cfg80211_regdomain = rd;
+}
+#endif
+
 bool is_world_regdom(char *alpha2)
 {
 	if (!alpha2)
@@ -555,58 +722,6 @@ void print_regdomain_info(struct ieee802
 	print_rd_rules(rd);
 }
 
-#ifdef CONFIG_WIRELESS_OLD_REGULATORY
-
-static bool is_old_static_regdom(struct ieee80211_regdomain *rd)
-{
-	if (rd == &us_regdom || rd == &jp_regdom || rd == &eu_regdom)
-		return true;
-	return false;
-}
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
-#else
-static void reset_regdomains(void)
-{
-	if (cfg80211_world_regdom && cfg80211_world_regdom != &world_regdom) {
-		if (cfg80211_world_regdom == cfg80211_regdomain) {
-			kfree(cfg80211_regdomain);
-		} else {
-			kfree(cfg80211_world_regdom);
-			kfree(cfg80211_regdomain);
-		}
-	} else if (cfg80211_regdomain && cfg80211_regdomain != &world_regdom)
-		kfree(cfg80211_regdomain);
-
-	cfg80211_world_regdom = (struct ieee80211_regdomain *) &world_regdom;
-	cfg80211_regdomain = NULL;
-}
-
-/* Dynamic world regulatory domain requested by the wireless
- * core upon initialization */
-static void update_world_regdomain(struct ieee80211_regdomain *rd)
-{
-	BUG_ON(list_empty(&regulatory_requests));
-
-	reset_regdomains();
-
-	cfg80211_world_regdom = rd;
-	cfg80211_regdomain = rd;
-}
-#endif
-
 static int __set_regdom(struct ieee80211_regdomain *rd)
 {
 	struct regulatory_request *request = NULL;
@@ -615,7 +730,7 @@ static int __set_regdom(struct ieee80211
 
 #ifdef CONFIG_WIRELESS_OLD_REGULATORY
 	/* We ignore the world regdom with the old static regdomains setup
-	 * as there is no point to it with satic regulatory definitions :(
+	 * as there is no point to it with static regulatory definitions :(
 	 * Don't worry this shit will be removed soon... */
 	if (is_world_regdom(rd->alpha2))
 		return -EINVAL;
@@ -744,12 +859,39 @@ int regulatory_init(void)
 void regulatory_exit(void)
 {
 	struct regulatory_request *req, *req_tmp;
+	int err;
+
 	mutex_lock(&cfg80211_drv_mutex);
+
 #ifdef CONFIG_WIRELESS_OLD_REGULATORY
+	cfg80211_regdomain =
+		(struct ieee80211_regdomain *) static_regdom(ieee80211_regdom);
+	/* Used during reset_regdomains_static() */
+	cfg80211_world_regdom = cfg80211_regdomain;
 	reset_regdomains_static();
+
+	printk(KERN_INFO "cfg80211: Using static regulatory domain\n");
+	print_regdomain_info(cfg80211_regdomain);
+	/* The old code still requests for a new regdomain and if
+	 * you have CRDA you get it updated, otherwise you get
+	 * stuck with the static values. We ignore "EU" code as
+	 * that is not a valid ISO / IEC 3166 alpha2 */
+	if (ieee80211_regdom[0] != 'E' &&
+			ieee80211_regdom[1] != 'U')
+		err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE,
+			ieee80211_regdom, NULL);
 #else
+	cfg80211_regdomain =
+		(struct ieee80211_regdomain *) cfg80211_world_regdom;
 	reset_regdomains();
+
+	err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE, "00", NULL);
+	if (err)
+		printk(KERN_ERR "cfg80211: calling CRDA failed - "
+			"unable to update world regulatory domain, "
+			"using static definition\n");
 #endif
+
 	list_for_each_entry_safe(req, req_tmp, &regulatory_requests, list) {
 		list_del(&req->list);
 		kfree(req);
--- everything.orig/net/wireless/reg.h	2008-09-15 10:32:20.000000000 +0200
+++ everything/net/wireless/reg.h	2008-09-15 10:43:51.000000000 +0200
@@ -1,44 +1,13 @@
 #ifndef __NET_WIRELESS_REG_H
 #define __NET_WIRELESS_REG_H
 
-extern const struct ieee80211_regdomain world_regdom;
-#ifdef CONFIG_WIRELESS_OLD_REGULATORY
-extern const struct ieee80211_regdomain us_regdom;
-extern const struct ieee80211_regdomain jp_regdom;
-extern const struct ieee80211_regdomain eu_regdom;
-#endif
-
-extern struct ieee80211_regdomain *cfg80211_regdomain;
-extern struct ieee80211_regdomain *cfg80211_world_regdom;
-extern struct list_head regulatory_requests;
-
-struct regdom_last_setby {
-	struct wiphy *wiphy;
-	u8 initiator;
-};
-
-/* wiphy is set if this request's initiator is REGDOM_SET_BY_DRIVER */
-struct regulatory_request {
-	struct list_head list;
-	struct wiphy *wiphy;
-	int granted;
-	enum reg_set_by initiator;
-	char alpha2[2];
-};
-
+extern struct mutex cfg80211_reg_mutex;
 bool is_world_regdom(char *alpha2);
 bool reg_is_valid_request(char *alpha2);
 
-int set_regdom(struct ieee80211_regdomain *rd);
-int __regulatory_hint_alpha2(struct wiphy *wiphy, enum reg_set_by set_by,
-		      const char *alpha2);
-
 int regulatory_init(void);
 void regulatory_exit(void);
 
-void print_regdomain_info(struct ieee80211_regdomain *);
-
-/* If a char is A-Z */
-#define IS_ALPHA(letter) (letter >= 65 && letter <= 90)
+int set_regdom(struct ieee80211_regdomain *rd);
 
 #endif  /* __NET_WIRELESS_REG_H */


