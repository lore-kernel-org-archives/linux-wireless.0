Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f54.google.com ([209.85.213.54]:34861 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3ISQS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Sep 2013 12:18:26 -0400
Received: by mail-yh0-f54.google.com with SMTP id z20so4231805yhz.27
        for <linux-wireless@vger.kernel.org>; Thu, 19 Sep 2013 09:18:26 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 2/4] ath: move common dynamic regulatory domain setting to a helper
Date: Thu, 19 Sep 2013 11:18:08 -0500
Message-Id: <1379607490-18972-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20130919_181829_250802_2D19E380)
In-Reply-To: <1379607490-18972-1-git-send-email-mcgrof@do-not-panic.com>
References: <1379607490-18972-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This moves the dynamic regulatory domain selection code into
a helper.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/regd.c |   55 ++++++++++++++++++++++++++-------------
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
1.7.10.4

