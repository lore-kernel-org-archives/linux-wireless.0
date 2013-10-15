Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60073 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab3JOAmZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 20:42:25 -0400
Received: by mail-pa0-f51.google.com with SMTP id kp14so8201991pab.24
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 17:42:25 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 2/6] ath: move common dynamic regulatory domain setting to a helper
Date: Mon, 14 Oct 2013 17:42:07 -0700
Message-Id: <1381797731-2454-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20131015_024228_429158_CB199A0F)
In-Reply-To: <1381797731-2454-1-git-send-email-mcgrof@do-not-panic.com>
References: <1381797731-2454-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This moves the dynamic regulatory domain selection code into
a helper.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/regd.c | 55 +++++++++++++++++++++++++++--------------
 1 file changed, 37 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 7d077c7..8373650 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -356,14 +356,48 @@ static u16 ath_regd_find_country_by_name(char *alpha2)
 	return -1;
 }
 
+static int __ath_reg_dyn_country(struct wiphy *wiphy,
+				 struct ath_regulatory *reg,
+				 struct regulatory_request *request)
+{
+	u16 country_code;
+
+	if (!ath_is_world_regd(reg))
+		return -EINVAL;
+
+	country_code = ath_regd_find_country_by_name(request->alpha2);
+	if (country_code == (u16) -1)
+		return -EINVAL;
+
+	reg->current_rd = COUNTRY_ERD_FLAG;
+	reg->current_rd |= country_code;
+
+	__ath_regd_init(reg);
+
+	ath_reg_apply_world_flags(wiphy, request->initiator, reg);
+
+	return 0;
+}
+
+static void ath_reg_dyn_country(struct wiphy *wiphy,
+				struct ath_regulatory *reg,
+				struct regulatory_request *request)
+{
+	if (__ath_reg_dyn_country(wiphy, reg, request))
+		return;
+
+	printk(KERN_DEBUG "ath: regdomain 0x%0x "
+			  "dynamically updated by %s\n",
+	       reg->current_rd,
+	       reg_initiator_name(request->initiator));
+}
+
 void ath_reg_notifier_apply(struct wiphy *wiphy,
 			    struct regulatory_request *request,
 			    struct ath_regulatory *reg)
 {
 	struct ath_common *common = container_of(reg, struct ath_common,
 						 regulatory);
-	u16 country_code;
-
 	/* We always apply this */
 	ath_reg_apply_radar_flags(wiphy);
 
@@ -391,22 +425,7 @@ void ath_reg_notifier_apply(struct wiphy *wiphy,
 	case NL80211_REGDOM_SET_BY_USER:
 		break;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
-		if (!ath_is_world_regd(reg))
-			break;
-
-		country_code = ath_regd_find_country_by_name(request->alpha2);
-		if (country_code == (u16) -1)
-			break;
-
-		reg->current_rd = COUNTRY_ERD_FLAG;
-		reg->current_rd |= country_code;
-
-		printk(KERN_DEBUG "ath: regdomain 0x%0x updated by CountryIE\n",
-			reg->current_rd);
-		__ath_regd_init(reg);
-
-		ath_reg_apply_world_flags(wiphy, request->initiator, reg);
-
+		ath_reg_dyn_country(wiphy, reg, request);
 		break;
 	}
 }
-- 
1.8.4.rc3

