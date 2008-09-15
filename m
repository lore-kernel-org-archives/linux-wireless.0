Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbYIOJLC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 05:11:02 -0400
Subject: [PATCH] cfg80211: fix regulatory code const
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 11:10:52 +0200
Message-Id: <1221469852.3700.36.camel@johannes.berg> (sfid-20080915_111109_701709_69C2E0FF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few pointers and structures in the regulatory code are const,
but because it wasn't done properly a whole bunch of bogus
casts were needed to compile without warning. Mark everything
const properly to avoid that kind of junk code.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/reg.c |   58 +++++++++++++++++++++++++----------------------------
 net/wireless/reg.h |    6 ++---
 2 files changed, 31 insertions(+), 33 deletions(-)

--- everything.orig/net/wireless/reg.c	2008-09-15 10:54:22.000000000 +0200
+++ everything/net/wireless/reg.c	2008-09-15 11:08:39.000000000 +0200
@@ -68,7 +68,7 @@ static struct list_head regulatory_reque
 /* Central wireless core regulatory domains, we only need two,
  * the current one and a world regulatory domain in case we have no
  * information to give us an alpha2 */
-static struct ieee80211_regdomain *cfg80211_regdomain;
+static const struct ieee80211_regdomain *cfg80211_regdomain;
 
 /* We keep a static world regulatory domain in case of the absence of CRDA */
 static const struct ieee80211_regdomain world_regdom = {
@@ -81,8 +81,8 @@ static const struct ieee80211_regdomain 
 	}
 };
 
-static struct ieee80211_regdomain *cfg80211_world_regdom =
-	(struct ieee80211_regdomain *) &world_regdom;
+static const struct ieee80211_regdomain *cfg80211_world_regdom =
+	&world_regdom;
 
 #ifdef CONFIG_WIRELESS_OLD_REGULATORY
 static char *ieee80211_regdom = "US";
@@ -168,7 +168,7 @@ static const struct ieee80211_regdomain 
 	return &us_regdom;
 }
 
-static bool is_old_static_regdom(struct ieee80211_regdomain *rd)
+static bool is_old_static_regdom(const struct ieee80211_regdomain *rd)
 {
 	if (rd == &us_regdom || rd == &jp_regdom || rd == &eu_regdom)
 		return true;
@@ -201,13 +201,13 @@ static void reset_regdomains(void)
 	} else if (cfg80211_regdomain && cfg80211_regdomain != &world_regdom)
 		kfree(cfg80211_regdomain);
 
-	cfg80211_world_regdom = (struct ieee80211_regdomain *) &world_regdom;
+	cfg80211_world_regdom = &world_regdom;
 	cfg80211_regdomain = NULL;
 }
 
 /* Dynamic world regulatory domain requested by the wireless
  * core upon initialization */
-static void update_world_regdomain(struct ieee80211_regdomain *rd)
+static void update_world_regdomain(const struct ieee80211_regdomain *rd)
 {
 	BUG_ON(list_empty(&regulatory_requests));
 
@@ -218,7 +218,7 @@ static void update_world_regdomain(struc
 }
 #endif
 
-bool is_world_regdom(char *alpha2)
+bool is_world_regdom(const char *alpha2)
 {
 	if (!alpha2)
 		return false;
@@ -227,7 +227,7 @@ bool is_world_regdom(char *alpha2)
 	return false;
 }
 
-static bool is_alpha2_set(char *alpha2)
+static bool is_alpha2_set(const char *alpha2)
 {
 	if (!alpha2)
 		return false;
@@ -244,7 +244,7 @@ static bool is_alpha_upper(char letter)
 	return false;
 }
 
-static bool is_unknown_alpha2(char *alpha2)
+static bool is_unknown_alpha2(const char *alpha2)
 {
 	if (!alpha2)
 		return false;
@@ -255,7 +255,7 @@ static bool is_unknown_alpha2(char *alph
 	return false;
 }
 
-static bool is_an_alpha2(char *alpha2)
+static bool is_an_alpha2(const char *alpha2)
 {
 	if (!alpha2)
 		return false;
@@ -264,7 +264,7 @@ static bool is_an_alpha2(char *alpha2)
 	return false;
 }
 
-static bool alpha2_equal(char *alpha2_x, char *alpha2_y)
+static bool alpha2_equal(const char *alpha2_x, const char *alpha2_y)
 {
 	if (!alpha2_x || !alpha2_y)
 		return false;
@@ -274,7 +274,7 @@ static bool alpha2_equal(char *alpha2_x,
 	return false;
 }
 
-static bool regdom_changed(char *alpha2)
+static bool regdom_changed(const char *alpha2)
 {
 	if (!cfg80211_regdomain)
 		return true;
@@ -405,7 +405,7 @@ static int ignore_request(struct wiphy *
 	}
 }
 
-static bool __reg_is_valid_request(char *alpha2,
+static bool __reg_is_valid_request(const char *alpha2,
 	struct regulatory_request **request)
 {
 	struct regulatory_request *req;
@@ -421,16 +421,16 @@ static bool __reg_is_valid_request(char 
 }
 
 /* Used by nl80211 before kmalloc'ing our regulatory domain */
-bool reg_is_valid_request(char *alpha2)
+bool reg_is_valid_request(const char *alpha2)
 {
 	struct regulatory_request *request = NULL;
 	return  __reg_is_valid_request(alpha2, &request);
 }
 
 /* Sanity check on a regulatory rule */
-static bool is_valid_reg_rule(struct ieee80211_reg_rule *rule)
+static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 {
-	struct ieee80211_freq_range *freq_range = &rule->freq_range;
+	const struct ieee80211_freq_range *freq_range = &rule->freq_range;
 	u32 freq_diff;
 
 	if (freq_range->start_freq_khz == 0 || freq_range->end_freq_khz == 0)
@@ -447,9 +447,9 @@ static bool is_valid_reg_rule(struct iee
 	return true;
 }
 
-static bool is_valid_rd(struct ieee80211_regdomain *rd)
+static bool is_valid_rd(const struct ieee80211_regdomain *rd)
 {
-	struct ieee80211_reg_rule *reg_rule = NULL;
+	const struct ieee80211_reg_rule *reg_rule = NULL;
 	unsigned int i;
 
 	if (!rd->n_reg_rules)
@@ -661,12 +661,12 @@ unlock_and_exit:
 EXPORT_SYMBOL(regulatory_hint);
 
 
-static void print_rd_rules(struct ieee80211_regdomain *rd)
+static void print_rd_rules(const struct ieee80211_regdomain *rd)
 {
 	unsigned int i;
-	struct ieee80211_reg_rule *reg_rule = NULL;
-	struct ieee80211_freq_range *freq_range = NULL;
-	struct ieee80211_power_rule *power_rule = NULL;
+	const struct ieee80211_reg_rule *reg_rule = NULL;
+	const struct ieee80211_freq_range *freq_range = NULL;
+	const struct ieee80211_power_rule *power_rule = NULL;
 
 	printk(KERN_INFO "\t(start_freq - end_freq @ bandwidth), "
 		"(max_antenna_gain, max_eirp)\n");
@@ -696,7 +696,7 @@ static void print_rd_rules(struct ieee80
 	}
 }
 
-static void print_regdomain(struct ieee80211_regdomain *rd)
+static void print_regdomain(const struct ieee80211_regdomain *rd)
 {
 
 	if (is_world_regdom(rd->alpha2))
@@ -715,14 +715,14 @@ static void print_regdomain(struct ieee8
 	print_rd_rules(rd);
 }
 
-void print_regdomain_info(struct ieee80211_regdomain *rd)
+void print_regdomain_info(const struct ieee80211_regdomain *rd)
 {
 	printk(KERN_INFO "cfg80211: Regulatory domain: %c%c\n",
 		rd->alpha2[0], rd->alpha2[1]);
 	print_rd_rules(rd);
 }
 
-static int __set_regdom(struct ieee80211_regdomain *rd)
+static int __set_regdom(const struct ieee80211_regdomain *rd)
 {
 	struct regulatory_request *request = NULL;
 
@@ -804,7 +804,7 @@ static int __set_regdom(struct ieee80211
  * multiple drivers can be ironed out later. Caller must've already
  * kmalloc'd the rd structure. If this calls fails you should kfree()
  * the passed rd. Caller must hold cfg80211_drv_mutex */
-int set_regdom(struct ieee80211_regdomain *rd)
+int set_regdom(const struct ieee80211_regdomain *rd)
 {
 	struct regulatory_request *this_request = NULL, *prev_request = NULL;
 	int r;
@@ -857,8 +857,7 @@ int regulatory_init(void)
 		return PTR_ERR(reg_pdev);
 
 #ifdef CONFIG_WIRELESS_OLD_REGULATORY
-	cfg80211_regdomain =
-		(struct ieee80211_regdomain *) static_regdom(ieee80211_regdom);
+	cfg80211_regdomain = static_regdom(ieee80211_regdom);
 	/* Used during reset_regdomains_static() */
 	cfg80211_world_regdom = cfg80211_regdomain;
 
@@ -872,8 +871,7 @@ int regulatory_init(void)
 		err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE,
 					ieee80211_regdom, NULL);
 #else
-	cfg80211_regdomain =
-		(struct ieee80211_regdomain *) cfg80211_world_regdom;
+	cfg80211_regdomain = cfg80211_world_regdom;
 
 	err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE, "00", NULL);
 	if (err)
--- everything.orig/net/wireless/reg.h	2008-09-15 11:02:23.000000000 +0200
+++ everything/net/wireless/reg.h	2008-09-15 11:05:42.000000000 +0200
@@ -2,12 +2,12 @@
 #define __NET_WIRELESS_REG_H
 
 extern struct mutex cfg80211_reg_mutex;
-bool is_world_regdom(char *alpha2);
-bool reg_is_valid_request(char *alpha2);
+bool is_world_regdom(const char *alpha2);
+bool reg_is_valid_request(const char *alpha2);
 
 int regulatory_init(void);
 void regulatory_exit(void);
 
-int set_regdom(struct ieee80211_regdomain *rd);
+int set_regdom(const struct ieee80211_regdomain *rd);
 
 #endif  /* __NET_WIRELESS_REG_H */


