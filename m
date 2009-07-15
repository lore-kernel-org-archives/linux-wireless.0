Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52650 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800AbZGOAXT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:23:19 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] cfg80211: treat ieee80211_regdom hints as user hints
Date: Tue, 14 Jul 2009 20:23:15 -0400
Message-Id: <1247617395-20617-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were treating ieee80211_regdom module parameter hints
as core hints, this means we were not letting the user help
compliance further when using the module parameter. It also
meant that users with a device with a custom regulatory
domain set (wiphy->custom_regulatory) using this module
parameter were being stuck to the original default core
static regualtory domain. We fix this by using the static
cfg80211_regdomain alpha2 as the core hint and treating the
module parameter separately.

All iwlwifi and ath5k/ath9k/ar9170 devices which world roam
set the wiphy->custom_regulatory. This change allows users
using this module parameter to have it trated as a a proper
user hint and not have it ignored.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   25 +++++++++----------------
 1 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2b4a6c6..fb40428 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -113,11 +113,7 @@ static const struct ieee80211_regdomain world_regdom = {
 static const struct ieee80211_regdomain *cfg80211_world_regdom =
 	&world_regdom;
 
-#ifdef CONFIG_WIRELESS_OLD_REGULATORY
-static char *ieee80211_regdom = "US";
-#else
 static char *ieee80211_regdom = "00";
-#endif
 
 module_param(ieee80211_regdom, charp, 0444);
 MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
@@ -2287,22 +2283,12 @@ int regulatory_init(void)
 
 	printk(KERN_INFO "cfg80211: Using static regulatory domain info\n");
 	print_regdomain_info(cfg80211_regdomain);
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
 #else
 	cfg80211_regdomain = cfg80211_world_regdom;
 
-	err = regulatory_hint_core(ieee80211_regdom);
 #endif
+	/* We always try to get an update for the static regdomain */
+	err = regulatory_hint_core(cfg80211_regdomain->alpha2);
 	if (err) {
 		if (err == -ENOMEM)
 			return err;
@@ -2321,6 +2307,13 @@ int regulatory_init(void)
 #endif
 	}
 
+	/*
+	 * Finally, if the user set the module parameter treat it
+	 * as a user hint.
+	 */
+	if (!is_world_regdom(ieee80211_regdom))
+		regulatory_hint_user(ieee80211_regdom);
+
 	return 0;
 }
 
-- 
1.6.0.6

