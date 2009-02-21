Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56068 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZBUFEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 00:04:42 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v6 05/15] cfg80211: add regulatory_hint_core() to separate the core reg hint
Date: Sat, 21 Feb 2009 00:04:23 -0500
Message-Id: <1235192673-6314-6-git-send-email-lrodriguez@atheros.com> (sfid-20090221_060451_401619_4AE4680D)
In-Reply-To: <1235192673-6314-1-git-send-email-lrodriguez@atheros.com>
References: <1235192673-6314-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the core hint path more readable and allows for us to
later make it obvious under what circumstances we need locking or not.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   34 +++++++++++++++++++++++++---------
 1 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ba82312..6373a78 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1050,11 +1050,7 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 	case REGDOM_SET_BY_INIT:
 		return -EINVAL;
 	case REGDOM_SET_BY_CORE:
-		/*
-		 * Always respect new wireless core hints, should only happen
-		 * when updating the world regulatory domain at init.
-		 */
-		return 0;
+		return -EINVAL;
 	case REGDOM_SET_BY_COUNTRY_IE:
 		if (unlikely(!is_an_alpha2(alpha2)))
 			return -EINVAL;
@@ -1183,6 +1179,26 @@ new_request:
 	return call_crda(alpha2);
 }
 
+static int regulatory_hint_core(const char *alpha2)
+{
+	struct regulatory_request *request;
+
+	BUG_ON(last_request);
+
+	request = kzalloc(sizeof(struct regulatory_request),
+			  GFP_KERNEL);
+	if (!request)
+		return -ENOMEM;
+
+	request->alpha2[0] = alpha2[0];
+	request->alpha2[1] = alpha2[1];
+	request->initiator = REGDOM_SET_BY_CORE;
+
+	last_request = request;
+
+	return call_crda(alpha2);
+}
+
 void regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 {
 	int r;
@@ -1616,16 +1632,16 @@ int regulatory_init(void)
 	 * stuck with the static values. We ignore "EU" code as
 	 * that is not a valid ISO / IEC 3166 alpha2 */
 	if (ieee80211_regdom[0] != 'E' || ieee80211_regdom[1] != 'U')
-		err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE,
-					ieee80211_regdom, 0, ENVIRON_ANY);
+		err = regulatory_hint_core(ieee80211_regdom);
 #else
 	cfg80211_regdomain = cfg80211_world_regdom;
 
-	err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE, "00", 0, ENVIRON_ANY);
-	if (err)
+	err = regulatory_hint_core("00");
+	if (err) {
 		printk(KERN_ERR "cfg80211: calling CRDA failed - "
 		       "unable to update world regulatory domain, "
 		       "using static definition\n");
+	}
 #endif
 
 	return 0;
-- 
1.6.0.3

