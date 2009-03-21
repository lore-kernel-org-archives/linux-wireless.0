Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60384 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbZCUDxM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 23:53:12 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Quentin@armitage.org.uk,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/5] cfg80211: make regdom module parameter available oustide of OLD_REG
Date: Fri, 20 Mar 2009 23:53:06 -0400
Message-Id: <1237607588-6316-4-git-send-email-lrodriguez@atheros.com> (sfid-20090321_045323_329200_A71CF87A)
In-Reply-To: <1237607588-6316-1-git-send-email-lrodriguez@atheros.com>
References: <1237607588-6316-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems a few users are using this module parameter although its not
recommended. People are finding it useful despite there being utilities
for setting this in userspace. I'm not aware of any distribution using
this though.

Until userspace and distributions catch up with a default userspace
automatic replacement (GeoClue integration would be nirvana) we copy
the ieee80211_regdom module parameter from OLD_REG to the new reg
code to help these users migrate.

Users who are using the non-valid ISO / IEC 3166 alpha "EU" in their
ieee80211_regdom module parameter and migrate to non-OLD_REG enabled
system will world roam.

This also schedules removal of this same ieee80211_regdom module
parameter circa March 2010. Hope is by then nirvana is reached and
users will abandoned the module parameter completely.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 Documentation/feature-removal-schedule.txt |   30 ++++++++++++++++++++++++---
 net/wireless/reg.c                         |    7 +++++-
 2 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 802c6fd..020bc66 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -6,7 +6,31 @@ be removed from this file.
 
 ---------------------------
 
-What:	old static regulatory information and ieee80211_regdom module parameter
+What:	The ieee80211_regdom module parameter
+When:	March 2010
+
+Why:	This was inherited by the CONFIG_WIRELESS_OLD_REGULATORY code,
+	and currently serves as an option for users to define an
+	ISO / IEC 3166 alpha2 code for the country they are currently
+	present in. Although there are userspace API replacements for this
+	through nl80211 distributions haven't yet caught up with implementing
+	decent alternatives through standard GUIs. Although available as an
+	option through iw or wpa_supplicant its just a matter of time before
+	distributions pick up good GUI options for this. The ideal solution
+	would actually consist of intelligent designs which would do this for
+	the user automatically even when travelling through different countries.
+	Until then we leave this module parameter as a compromise.
+
+	When userspace improves with reasonable widely-available alternatives for
+	this we will no longer need this module parameter. This entry hopes that
+	by the super-futuristically looking date of "March 2010" we will have
+	such replacements widely available.
+
+Who:	Luis R. Rodriguez <lrodriguez@atheros.com>
+
+---------------------------
+
+What:	old static regulatory information
 When:	2.6.29
 Why:	The old regulatory infrastructure has been replaced with a new one
 	which does not require statically defined regulatory domains. We do
@@ -17,9 +41,7 @@ Why:	The old regulatory infrastructure has been replaced with a new one
 		* JP
 		* EU
 	and used by default the US when CONFIG_WIRELESS_OLD_REGULATORY was
-	set. We also kept around the ieee80211_regdom module parameter in case
-	some applications were relying on it. Changing regulatory domains
-	can now be done instead by using nl80211, as is done with iw.
+	set.
 Who:	Luis R. Rodriguez <lrodriguez@atheros.com>
 
 ---------------------------
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9afc916..ac048a1 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -122,9 +122,14 @@ static const struct ieee80211_regdomain *cfg80211_world_regdom =
 
 #ifdef CONFIG_WIRELESS_OLD_REGULATORY
 static char *ieee80211_regdom = "US";
+#else
+static char *ieee80211_regdom = "00";
+#endif
+
 module_param(ieee80211_regdom, charp, 0444);
 MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
 
+#ifdef CONFIG_WIRELESS_OLD_REGULATORY
 /*
  * We assume 40 MHz bandwidth for the old regulatory work.
  * We make emphasis we are using the exact same frequencies
@@ -2152,7 +2157,7 @@ int regulatory_init(void)
 #else
 	cfg80211_regdomain = cfg80211_world_regdom;
 
-	err = regulatory_hint_core("00");
+	err = regulatory_hint_core(ieee80211_regdom);
 #endif
 	if (err) {
 		if (err == -ENOMEM)
-- 
1.6.0.6

