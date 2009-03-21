Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45391 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbZCUT5u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 15:57:50 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Quentin@armitage.org.uk,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 5/5] cfg80211: remove CONFIG_WIRELESS_OLD_REGULATORY
Date: Sat, 21 Mar 2009 15:57:41 -0400
Message-Id: <1237665461-27226-1-git-send-email-lrodriguez@atheros.com> (sfid-20090321_205754_820177_53D5FD1C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Distributions are already shipping with this disabled
and we now have improved world roaming considerably.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This s/wireless roaming/world roaming/
as caught by johill on my v1 patch. No other patch
changes were made.

 Documentation/feature-removal-schedule.txt |   16 ---
 net/wireless/Kconfig                       |   33 -------
 net/wireless/nl80211.c                     |    6 -
 net/wireless/reg.c                         |  144 +--------------------------
 4 files changed, 6 insertions(+), 193 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 020bc66..49dc5c5 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -30,22 +30,6 @@ Who:	Luis R. Rodriguez <lrodriguez@atheros.com>
 
 ---------------------------
 
-What:	old static regulatory information
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
-	set.
-Who:	Luis R. Rodriguez <lrodriguez@atheros.com>
-
----------------------------
-
 What:	dev->power.power_state
 When:	July 2007
 Why:	Broken design for runtime control over driver power states, confusing
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index d1d18f3..defa802 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -10,39 +10,6 @@ config CFG80211_REG_DEBUG
 
 	  If unsure, say N.
 
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
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a81a499..6f95975 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2058,12 +2058,6 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 
 	data = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
 
-#ifdef CONFIG_WIRELESS_OLD_REGULATORY
-	/* We ignore world regdom requests with the old regdom setup */
-	if (is_world_regdom(data))
-		return -EINVAL;
-#endif
-
 	r = regulatory_hint_user(data);
 
 	return r;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6327e16..6e5ff66 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -120,112 +120,10 @@ static const struct ieee80211_regdomain world_regdom = {
 static const struct ieee80211_regdomain *cfg80211_world_regdom =
 	&world_regdom;
 
-#ifdef CONFIG_WIRELESS_OLD_REGULATORY
-static char *ieee80211_regdom = "US";
-#else
 static char *ieee80211_regdom = "00";
-#endif
-
 module_param(ieee80211_regdom, charp, 0444);
 MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
 
-#ifdef CONFIG_WIRELESS_OLD_REGULATORY
-/*
- * We assume 40 MHz bandwidth for the old regulatory work.
- * We make emphasis we are using the exact same frequencies
- * as before
- */
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
-	/*
-	 * This alpha2 is bogus, we leave it here just for stupid
-	 * backward compatibility
-	 */
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
@@ -235,8 +133,6 @@ static void reset_regdomains(void)
 		cfg80211_world_regdom = NULL;
 	if (cfg80211_regdomain == &world_regdom)
 		cfg80211_regdomain = NULL;
-	if (is_old_static_regdom(cfg80211_regdomain))
-		cfg80211_regdomain = NULL;
 
 	kfree(cfg80211_regdomain);
 	kfree(cfg80211_world_regdom);
@@ -1297,8 +1193,6 @@ static int ignore_request(struct wiphy *wiphy,
 		return REG_INTERSECT;
 	case NL80211_REGDOM_SET_BY_DRIVER:
 		if (last_request->initiator == NL80211_REGDOM_SET_BY_CORE) {
-			if (is_old_static_regdom(cfg80211_regdomain))
-				return 0;
 			if (regdom_changes(pending_request->alpha2))
 				return 0;
 			return -EALREADY;
@@ -1335,8 +1229,7 @@ static int ignore_request(struct wiphy *wiphy,
 				return -EAGAIN;
 		}
 
-		if (!is_old_static_regdom(cfg80211_regdomain) &&
-		    !regdom_changes(pending_request->alpha2))
+		if (!regdom_changes(pending_request->alpha2))
 			return -EALREADY;
 
 		return 0;
@@ -1933,19 +1826,12 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		return -EINVAL;
 
 	/*
-	 * Lets only bother proceeding on the same alpha2 if the current
-	 * rd is non static (it means CRDA was present and was used last)
-	 * and the pending request came in from a country IE
+	 * Lets only bother proceeding on the same alpha2 if the
+	 * pending request came in from a country IE
 	 */
-	if (last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE) {
-		/*
-		 * If someone else asked us to change the rd lets only bother
-		 * checking if the alpha2 changes if CRDA was already called
-		 */
-		if (!is_old_static_regdom(cfg80211_regdomain) &&
-		    !regdom_changes(rd->alpha2))
-			return -EINVAL;
-	}
+	if (last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+	    !regdom_changes(rd->alpha2))
+		return -EINVAL;
 
 	/*
 	 * Now lets set the regulatory domain, update all driver channels
@@ -2121,27 +2007,9 @@ int regulatory_init(void)
 	spin_lock_init(&reg_requests_lock);
 	spin_lock_init(&reg_pending_beacons_lock);
 
-#ifdef CONFIG_WIRELESS_OLD_REGULATORY
-	cfg80211_regdomain = static_regdom(ieee80211_regdom);
-
-	printk(KERN_INFO "cfg80211: Using static regulatory domain info\n");
-	print_regdomain_info(cfg80211_regdomain);
-	/*
-	 * The old code still requests for a new regdomain and if
-	 * you have CRDA you get it updated, otherwise you get
-	 * stuck with the static values. Since "EU" is not a valid
-	 * ISO / IEC 3166 alpha2 code we can't expect userpace to
-	 * give us a regulatory domain for it. We need last_request
-	 * iniitalized though so lets just send a request which we
-	 * know will be ignored... this crap will be removed once
-	 * OLD_REG dies.
-	 */
-	err = regulatory_hint_core(ieee80211_regdom);
-#else
 	cfg80211_regdomain = cfg80211_world_regdom;
 
 	err = regulatory_hint_core(ieee80211_regdom);
-#endif
 	if (err) {
 		if (err == -ENOMEM)
 			return err;
-- 
1.6.0.6

