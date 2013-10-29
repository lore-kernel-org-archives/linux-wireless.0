Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36960 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3J2WjO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 18:39:14 -0400
Received: by mail-wi0-f170.google.com with SMTP id ex4so3338557wid.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 15:39:13 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 2/3] ath: dynamic user allow check helper to the top
Date: Tue, 29 Oct 2013 23:39:05 +0100
Message-Id: <1383086346-2096-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20131029_233917_976860_1B29AA7F)
In-Reply-To: <1383086346-2096-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383086346-2096-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be used later.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/regd.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index e27027c..5790aa2 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -185,6 +185,15 @@ static bool dynamic_country_user_possible(struct ath_regulatory *reg)
 	return true;
 }
 
+static bool ath_reg_dyn_country_user_allow(struct ath_regulatory *reg)
+{
+	if (!config_enabled(CONFIG_ATH_REG_DYNAMIC_USER_REG_HINTS))
+		return false;
+	if (!dynamic_country_user_possible(reg))
+		return false;
+	return true;
+}
+
 static inline bool is_wwr_sku(u16 regd)
 {
 	return ((regd & COUNTRY_ERD_FLAG) != COUNTRY_ERD_FLAG) &&
@@ -466,17 +475,6 @@ static void ath_reg_dyn_country(struct wiphy *wiphy,
 	       reg_initiator_name(request->initiator));
 }
 
-static void ath_reg_dyn_country_user(struct wiphy *wiphy,
-				     struct ath_regulatory *reg,
-				     struct regulatory_request *request)
-{
-	if (!config_enabled(CONFIG_ATH_REG_DYNAMIC_USER_REG_HINTS))
-		return;
-	if (!dynamic_country_user_possible(reg))
-		return;
-	ath_reg_dyn_country(wiphy, reg, request);
-}
-
 void ath_reg_notifier_apply(struct wiphy *wiphy,
 			    struct regulatory_request *request,
 			    struct ath_regulatory *reg)
@@ -509,7 +507,8 @@ void ath_reg_notifier_apply(struct wiphy *wiphy,
 	case NL80211_REGDOM_SET_BY_DRIVER:
 		break;
 	case NL80211_REGDOM_SET_BY_USER:
-		ath_reg_dyn_country_user(wiphy, reg, request);
+		if (ath_reg_dyn_country_user_allow(reg))
+			ath_reg_dyn_country(wiphy, reg, request);
 		break;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
 		ath_reg_dyn_country(wiphy, reg, request);
-- 
1.8.4.rc3

