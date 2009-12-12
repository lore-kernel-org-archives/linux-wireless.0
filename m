Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39693 "HELO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754106AbZLMCYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2009 21:24:35 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [RFC 2/2] wireless: remove CONFIG_WIRELESS_OLD_REGULATORY
Date: Sat, 12 Dec 2009 16:42:43 -0500
Message-Id: <1260654163-11214-2-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1260654163-11214-1-git-send-email-linville@tuxdriver.com>
References: <1260654163-11214-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is no longer needed with the availability of
CONFIG_CFG80211_INTERNAL_REGDB.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 Documentation/feature-removal-schedule.txt |   21 -------
 net/wireless/Kconfig                       |   15 -----
 net/wireless/nl80211.c                     |    6 --
 net/wireless/reg.c                         |   89 +---------------------------
 4 files changed, 2 insertions(+), 129 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index bc693ff..0b5a765 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -73,27 +73,6 @@ Who:	Luis R. Rodriguez <lrodriguez@atheros.com>
 
 ---------------------------
 
-What:	CONFIG_WIRELESS_OLD_REGULATORY - old static regulatory information
-When:	March 2010 / desktop catchup
-
-Why:	The old regulatory infrastructure has been replaced with a new one
-	which does not require statically defined regulatory domains. We do
-	not want to keep static regulatory domains in the kernel due to the
-	the dynamic nature of regulatory law and localization. We kept around
-	the old static definitions for the regulatory domains of:
-
-		* US
-		* JP
-		* EU
-
-	and used by default the US when CONFIG_WIRELESS_OLD_REGULATORY was
-	set. We will remove this option once the standard Linux desktop catches
-	up with the new userspace APIs we have implemented.
-
-Who:	Luis R. Rodriguez <lrodriguez@atheros.com>
-
----------------------------
-
 What:	dev->power.power_state
 When:	July 2007
 Why:	Broken design for runtime control over driver power states, confusing
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index b1bd151..cbd2077 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -94,21 +94,6 @@ config CFG80211_DEBUGFS
 
 	  If unsure, say N.
 
-config WIRELESS_OLD_REGULATORY
-	bool "Old wireless static regulatory definitions"
-	default n
-	depends on CFG80211
-	---help---
-	  This option enables the old static regulatory information
-	  and uses it within the new framework. This option is available
-	  for historical reasons and it is advised to leave it off.
-
-	  For details see:
-
-	  http://wireless.kernel.org/en/developers/Regulatory
-
-	  Say N and if you say Y, please tell us why. The default is N.
-
 config CFG80211_INTERNAL_REGDB
 	bool "Statically compiled regulatory rules database"
 	default n
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a602843..931077e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2583,12 +2583,6 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 
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
index 41b2373..5b8f48a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -129,78 +129,6 @@ static char *ieee80211_regdom = "00";
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
-		/* IEEE 802.11a, channel 36..48 */
-		REG_RULE(5180-10, 5240+10, 40, 6, 17, 0),
-		/* IEEE 802.11a, channels 48..64 */
-		REG_RULE(5260-10, 5320+10, 40, 6, 20, NL80211_RRF_DFS),
-		/* IEEE 802.11a, channels 100..124 */
-		REG_RULE(5500-10, 5590+10, 40, 6, 20, NL80211_RRF_DFS),
-		/* IEEE 802.11a, channels 132..144 */
-		REG_RULE(5660-10, 5700+10, 40, 6, 20, NL80211_RRF_DFS),
-		/* IEEE 802.11a, channels 149..165, outdoor */
-		REG_RULE(5745-10, 5825+10, 40, 6, 30, 0),
-	}
-};
-
-static const struct ieee80211_regdomain jp_regdom = {
-	.n_reg_rules = 6,
-	.alpha2 =  "JP",
-	.reg_rules = {
-		/* IEEE 802.11b/g, channels 1..11 */
-		REG_RULE(2412-10, 2462+10, 40, 6, 20, 0),
-		/* IEEE 802.11b/g, channels 12..13 */
-		REG_RULE(2467-10, 2472+10, 20, 6, 20, 0),
-		/* IEEE 802.11b/g, channel 14 */
-		REG_RULE(2484-10, 2484+10, 20, 6, 20, NL80211_RRF_NO_OFDM),
-		/* IEEE 802.11a, channels 36..48 */
-		REG_RULE(5180-10, 5240+10, 40, 6, 20, 0),
-		/* IEEE 802.11a, channels 52..64 */
-		REG_RULE(5260-10, 5320+10, 40, 6, 20, NL80211_RRF_DFS),
-		/* IEEE 802.11a, channels 100..144 */
-		REG_RULE(5500-10, 5700+10, 40, 6, 23, NL80211_RRF_DFS),
-	}
-};
-
-static const struct ieee80211_regdomain *static_regdom(char *alpha2)
-{
-	if (alpha2[0] == 'U' && alpha2[1] == 'S')
-		return &us_regdom;
-	if (alpha2[0] == 'J' && alpha2[1] == 'P')
-		return &jp_regdom;
-	/* Use world roaming rules for "EU", since it was a pseudo
-	   domain anyway... */
-	if (alpha2[0] == 'E' && alpha2[1] == 'U')
-		return &world_regdom;
-	/* Default, world roaming rules */
-	return &world_regdom;
-}
-
-static bool is_old_static_regdom(const struct ieee80211_regdomain *rd)
-{
-	if (rd == &us_regdom || rd == &jp_regdom || rd == &world_regdom)
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
@@ -210,8 +138,6 @@ static void reset_regdomains(void)
 		cfg80211_world_regdom = NULL;
 	if (cfg80211_regdomain == &world_regdom)
 		cfg80211_regdomain = NULL;
-	if (is_old_static_regdom(cfg80211_regdomain))
-		cfg80211_regdomain = NULL;
 
 	kfree(cfg80211_regdomain);
 	kfree(cfg80211_world_regdom);
@@ -1425,8 +1351,6 @@ static int ignore_request(struct wiphy *wiphy,
 		return REG_INTERSECT;
 	case NL80211_REGDOM_SET_BY_DRIVER:
 		if (last_request->initiator == NL80211_REGDOM_SET_BY_CORE) {
-			if (is_old_static_regdom(cfg80211_regdomain))
-				return 0;
 			if (regdom_changes(pending_request->alpha2))
 				return 0;
 			return -EALREADY;
@@ -1463,8 +1387,7 @@ static int ignore_request(struct wiphy *wiphy,
 				return -EAGAIN;
 		}
 
-		if (!is_old_static_regdom(cfg80211_regdomain) &&
-		    !regdom_changes(pending_request->alpha2))
+		if (!regdom_changes(pending_request->alpha2))
 			return -EALREADY;
 
 		return 0;
@@ -2046,8 +1969,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		 * If someone else asked us to change the rd lets only bother
 		 * checking if the alpha2 changes if CRDA was already called
 		 */
-		if (!is_old_static_regdom(cfg80211_regdomain) &&
-		    !regdom_changes(rd->alpha2))
+		if (!regdom_changes(rd->alpha2))
 			return -EINVAL;
 	}
 
@@ -2316,15 +2238,8 @@ int regulatory_init(void)
 	spin_lock_init(&reg_requests_lock);
 	spin_lock_init(&reg_pending_beacons_lock);
 
-#ifdef CONFIG_WIRELESS_OLD_REGULATORY
-	cfg80211_regdomain = static_regdom(ieee80211_regdom);
-
-	printk(KERN_INFO "cfg80211: Using static regulatory domain info\n");
-	print_regdomain_info(cfg80211_regdomain);
-#else
 	cfg80211_regdomain = cfg80211_world_regdom;
 
-#endif
 	/* We always try to get an update for the static regdomain */
 	err = regulatory_hint_core(cfg80211_regdomain->alpha2);
 	if (err) {
-- 
1.6.5.2

