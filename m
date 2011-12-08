Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31805 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab1LHScA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 13:32:00 -0500
Cc: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH RESEND 2/4] ath: optimize processing of CTLs for country IEs for world roaming cards
Date: Thu, 8 Dec 2011 23:59:24 +0530
Message-ID: <1323368966-10001-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111208_193205_837580_9696994E)
In-Reply-To: <1323368966-10001-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1323368966-10001-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>

When we receive a country IE hint and we have a world roaming card
we can optimize output power further by ensuring that we use the
calibrated data for the country by using that country's own CTL data.
That is -- when world roaming and when we process a country IE we
no longer need to use the lowest output power of all CTLs instead
we use an optimized CTL output power for that specific country.

We accomplish this by copying the regulatory data prior on init
and restoring it when cfg80211 tells us it gets a core hint. Core
hints are only sent on init and when it wants to restore reguulatory
settings. We take advantage of this fact and apply the cached
regulatory data when we get a core hint. When we get a country IE
hint though we process the regulatory data as if programmed for
a specific country.

Tested-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath.h  |    1 +
 drivers/net/wireless/ath/regd.c |   55 ++++++++++++++++++++++++++++++++++++---
 2 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 4596c33..3e4dd2d 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -152,6 +152,7 @@ struct ath_common {
 	struct ath_cycle_counters cc_survey;
 
 	struct ath_regulatory regulatory;
+	struct ath_regulatory reg_world_copy;
 	const struct ath_ops *ops;
 	const struct ath_bus_ops *bus_ops;
 
diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index ed4966f..10dea37 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -21,6 +21,8 @@
 #include "regd.h"
 #include "regd_common.h"
 
+static int __ath_regd_init(struct ath_regulatory *reg);
+
 /*
  * This is a set of common rules used by our world regulatory domains.
  * We have 12 world regulatory domains. To save space we consolidate
@@ -347,10 +349,26 @@ static void ath_reg_apply_world_flags(struct wiphy *wiphy,
 	}
 }
 
+static u16 ath_regd_find_country_by_name(char *alpha2)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(allCountries); i++) {
+		if (!memcmp(allCountries[i].isoName, alpha2, 2))
+			return allCountries[i].countryCode;
+	}
+
+	return -1;
+}
+
 int ath_reg_notifier_apply(struct wiphy *wiphy,
 			   struct regulatory_request *request,
 			   struct ath_regulatory *reg)
 {
+	struct ath_common *common = container_of(reg, struct ath_common,
+						 regulatory);
+	u16 country_code;
+
 	/* We always apply this */
 	ath_reg_apply_radar_flags(wiphy);
 
@@ -363,14 +381,37 @@ int ath_reg_notifier_apply(struct wiphy *wiphy,
 		return 0;
 
 	switch (request->initiator) {
-	case NL80211_REGDOM_SET_BY_DRIVER:
 	case NL80211_REGDOM_SET_BY_CORE:
+		/*
+		 * If common->reg_world_copy is world roaming it means we *were*
+		 * world roaming... so we now have to restore that data.
+		 */
+		if (!ath_is_world_regd(&common->reg_world_copy))
+			break;
+
+		memcpy(reg, &common->reg_world_copy,
+		       sizeof(struct ath_regulatory));
+		break;
+	case NL80211_REGDOM_SET_BY_DRIVER:
 	case NL80211_REGDOM_SET_BY_USER:
 		break;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
-		if (ath_is_world_regd(reg))
-			ath_reg_apply_world_flags(wiphy, request->initiator,
-						  reg);
+		if (!ath_is_world_regd(reg))
+			break;
+
+		country_code = ath_regd_find_country_by_name(request->alpha2);
+		if (country_code == (u16) -1)
+			break;
+
+		reg->current_rd = COUNTRY_ERD_FLAG;
+		reg->current_rd |= country_code;
+
+		printk(KERN_DEBUG "ath: regdomain 0x%0x updated by CountryIE\n",
+			reg->current_rd);
+		__ath_regd_init(reg);
+
+		ath_reg_apply_world_flags(wiphy, request->initiator, reg);
+
 		break;
 	}
 
@@ -588,12 +629,18 @@ ath_regd_init(struct ath_regulatory *reg,
 	      int (*reg_notifier)(struct wiphy *wiphy,
 				  struct regulatory_request *request))
 {
+	struct ath_common *common = container_of(reg, struct ath_common,
+						 regulatory);
 	int r;
 
 	r = __ath_regd_init(reg);
 	if (r)
 		return r;
 
+	if (ath_is_world_regd(reg))
+		memcpy(&common->reg_world_copy, reg,
+		       sizeof(struct ath_regulatory));
+
 	ath_regd_init_wiphy(reg, wiphy, reg_notifier);
 
 	return 0;
-- 
1.7.8

