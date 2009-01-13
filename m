Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19419 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591AbZAMT6w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 14:58:52 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 11:58:52 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 12/12] cfg80211: Remove CONFIG_WIRELESS_OLD_REGULATORY
Date: Tue, 13 Jan 2009 11:57:55 -0800
Message-ID: <1231876675-20518-13-git-send-email-lrodriguez@atheros.com> (sfid-20090113_210904_958325_4665C028)
In-Reply-To: <1231876675-20518-12-git-send-email-lrodriguez@atheros.com>
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-2-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-3-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-4-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-5-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-6-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-7-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-8-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-9-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-10-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-11-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-12-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removal was scheduled for 2.6.29 but we decided to
keep it around a bit longer. Now that we are on road to
2.6.30 lets remove it.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 Documentation/feature-removal-schedule.txt |   18 ---
 net/wireless/Kconfig                       |   46 +++------
 net/wireless/reg.c                         |  161 +++-------------------------
 3 files changed, 26 insertions(+), 199 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index ac98851..f178d8b 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -6,24 +6,6 @@ be removed from this file.
 
 ---------------------------
 
-What:	old static regulatory information and ieee80211_regdom module parameter
-When:	2.6.29
-Why:	The old regulatory infrastructure has been replaced with a new one
-	which does not require statically defined regulatory domains. We do
-	not want to keep static regulatory domains in the kernel due to the
-	the dynamic nature of regulatory law and localization. We kept around
-	the old static definitions for the regulatory domains of:
-		* US
-		* JP
-		* EU
-	and used by default the US when CONFIG_WIRELESS_OLD_REGULATORY was
-	set. We also kept around the ieee80211_regdom module parameter in case
-	some applications were relying on it. Changing regulatory domains
-	can now be done instead by using nl80211, as is done with iw.
-Who:	Luis R. Rodriguez <lrodriguez@atheros.com>
-
----------------------------
-
 What:	dev->power.power_state
 When:	July 2007
 Why:	Broken design for runtime control over driver power states, confusing
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index e28e2b8..bc00782 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -1,5 +1,18 @@
 config CFG80211
         tristate "Improved wireless configuration API"
+	---help---
+	  cfg80211 is the new wireless driver framework. If you have a
+	  modern wireless card you want to enable this option.
+
+	  cfg80211's regulatory framework requires a userspace application
+	  which has the database of regulatory information (CRDA). Setting
+	  of regulatory domains can be done by drivers, or the wireless core
+	  based on country information elements. Users can also use userspace
+	  applications like iw or wpa_supplicant to help compliance further.
+
+	  For more information see:
+
+	  http://wireless.kernel.org/en/developers/Regulatory/
 
 config CFG80211_REG_DEBUG
 	bool "cfg80211 regulatory debugging"
@@ -23,39 +36,6 @@ config NL80211
 
 	  If unsure, say Y.
 
-config WIRELESS_OLD_REGULATORY
-	bool "Old wireless static regulatory definitions"
-	default y
-	---help---
-	  This option enables the old static regulatory information
-	  and uses it within the new framework. This is available
-	  temporarily as an option to help prevent immediate issues
-	  due to the switch to the new regulatory framework which
-	  does require a new userspace application which has the
-	  database of regulatory information (CRDA) and another for
-	  setting regulatory domains (iw).
-
-	  For more information see:
-
-	  http://wireless.kernel.org/en/developers/Regulatory/CRDA
-	  http://wireless.kernel.org/en/users/Documentation/iw
-
-	  It is important to note though that if you *do* have CRDA present
-	  and if this option is enabled CRDA *will* be called to update the
-	  regulatory domain (for US and JP only). Support for letting the user
-	  set the regulatory domain through iw is also supported. This option
-	  mainly exists to leave around for a kernel release some old static
-	  regulatory domains that were defined and to keep around the old
-	  ieee80211_regdom module parameter. This is being phased out and you
-	  should stop using them ASAP.
-
-	  Note: You will need CRDA if you want 802.11d support
-
-	  Say Y unless you have installed a new userspace application.
-	  Also say Y if have one currently depending on the ieee80211_regdom
-	  module parameter and cannot port it to use the new userspace
-	  interfaces.
-
 config WIRELESS_EXT
 	bool "Wireless extensions"
 	default n
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 460411d..1133a38 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -111,103 +111,6 @@ static const struct ieee80211_regdomain world_regdom = {
 static const struct ieee80211_regdomain *cfg80211_world_regdom =
 	&world_regdom;
 
-#ifdef CONFIG_WIRELESS_OLD_REGULATORY
-static char *ieee80211_regdom = "US";
-module_param(ieee80211_regdom, charp, 0444);
-MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
-
-/* We assume 40 MHz bandwidth for the old regulatory work.
- * We make emphasis we are using the exact same frequencies
- * as before */
-
-static const struct ieee80211_regdomain us_regdom = {
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
-static const struct ieee80211_regdomain jp_regdom = {
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
-static const struct ieee80211_regdomain eu_regdom = {
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
-static const struct ieee80211_regdomain *static_regdom(char *alpha2)
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
-
-static bool is_old_static_regdom(const struct ieee80211_regdomain *rd)
-{
-	if (rd == &us_regdom || rd == &jp_regdom || rd == &eu_regdom)
-		return true;
-	return false;
-}
-#else
-static inline bool is_old_static_regdom(const struct ieee80211_regdomain *rd)
-{
-	return false;
-}
-#endif
-
 static void reset_regdomains(void)
 {
 	/* avoid freeing static information or freeing something twice */
@@ -217,8 +120,6 @@ static void reset_regdomains(void)
 		cfg80211_world_regdom = NULL;
 	if (cfg80211_regdomain == &world_regdom)
 		cfg80211_regdomain = NULL;
-	if (is_old_static_regdom(cfg80211_regdomain))
-		cfg80211_regdomain = NULL;
 
 	kfree(cfg80211_regdomain);
 	kfree(cfg80211_world_regdom);
@@ -1152,16 +1053,6 @@ new_request:
 	if (r < 0)
 		return r;
 
-	/*
-	 * Note: When CONFIG_WIRELESS_OLD_REGULATORY is enabled
-	 * AND if CRDA is NOT present nothing will happen, if someone
-	 * wants to bother with 11d with OLD_REG you can add a timer.
-	 * If after x amount of time nothing happens you can call:
-	 *
-	 * return set_regdom(country_ie_regdomain);
-	 *
-	 * to intersect with the static rd
-	 */
 	return call_crda(alpha2);
 }
 
@@ -1416,16 +1307,11 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	if (!last_request)
 		return -EINVAL;
 
-	/* Lets only bother proceeding on the same alpha2 if the current
-	 * rd is non static (it means CRDA was present and was used last)
-	 * and the pending request came in from a country IE */
-	if (last_request->initiator != REGDOM_SET_BY_COUNTRY_IE) {
-		/* If someone else asked us to change the rd lets only bother
-		 * checking if the alpha2 changes if CRDA was already called */
-		if (!is_old_static_regdom(cfg80211_regdomain) &&
-		    !regdom_changed(rd->alpha2))
-			return -EINVAL;
-	}
+	/* Lets only bother proceeding on the same alpha2 if the
+	 * pending request came in from a country IE */
+	if (last_request->initiator != REGDOM_SET_BY_COUNTRY_IE &&
+	    !regdom_changed(rd->alpha2))
+		return -EINVAL;
 
 	wiphy = last_request->wiphy;
 
@@ -1497,24 +1383,18 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	 */
 
 	BUG_ON(!country_ie_regdomain);
+	BUG_ON(rd == country_ie_regdomain);
 
-	if (rd != country_ie_regdomain) {
-		/* Intersect what CRDA returned and our what we
-		 * had built from the Country IE received */
+	/* Intersect what CRDA returned and our what we
+	 * had built from the Country IE received */
 
-		intersected_rd = regdom_intersect(rd, country_ie_regdomain);
+	intersected_rd = regdom_intersect(rd, country_ie_regdomain);
 
-		reg_country_ie_process_debug(rd, country_ie_regdomain,
-			intersected_rd);
+	reg_country_ie_process_debug(rd, country_ie_regdomain,
+		intersected_rd);
 
-		kfree(country_ie_regdomain);
-		country_ie_regdomain = NULL;
-	} else {
-		/* This would happen when CRDA was not present and
-		 * OLD_REGULATORY was enabled. We intersect our Country
-		 * IE rd and what was set on cfg80211 originally */
-		intersected_rd = regdom_intersect(rd, cfg80211_regdomain);
-	}
+	kfree(country_ie_regdomain);
+	country_ie_regdomain = NULL;
 
 	if (!intersected_rd)
 		return -EINVAL;
@@ -1583,19 +1463,6 @@ int regulatory_init(void)
 	if (IS_ERR(reg_pdev))
 		return PTR_ERR(reg_pdev);
 
-#ifdef CONFIG_WIRELESS_OLD_REGULATORY
-	cfg80211_regdomain = static_regdom(ieee80211_regdom);
-
-	printk(KERN_INFO "cfg80211: Using static regulatory domain info\n");
-	print_regdomain_info(cfg80211_regdomain);
-	/* The old code still requests for a new regdomain and if
-	 * you have CRDA you get it updated, otherwise you get
-	 * stuck with the static values. We ignore "EU" code as
-	 * that is not a valid ISO / IEC 3166 alpha2 */
-	if (ieee80211_regdom[0] != 'E' || ieee80211_regdom[1] != 'U')
-		err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE,
-					ieee80211_regdom, 0, ENVIRON_ANY);
-#else
 	cfg80211_regdomain = cfg80211_world_regdom;
 
 	err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE, "00", 0, ENVIRON_ANY);
@@ -1603,8 +1470,6 @@ int regulatory_init(void)
 		printk(KERN_ERR "cfg80211: calling CRDA failed - "
 		       "unable to update world regulatory domain, "
 		       "using static definition\n");
-#endif
-
 	return 0;
 }
 
-- 
1.6.1.rc3.51.g5832d

