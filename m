Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:62508 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3J2WjM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 18:39:12 -0400
Received: by mail-wg0-f51.google.com with SMTP id l18so529486wgh.30
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 15:39:11 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 1/3] ath: move dynamic_country_user_possible() to the top
Date: Tue, 29 Oct 2013 23:39:04 +0100
Message-Id: <1383086346-2096-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131029_233915_634300_FB3328D8)
In-Reply-To: <1383086346-2096-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383086346-2096-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be used later.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/regd.c | 144 ++++++++++++++++++++--------------------
 1 file changed, 72 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index bc9ba78..e27027c 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -113,6 +113,78 @@ static const struct ieee80211_regdomain ath_world_regdom_67_68_6A_6C = {
 	}
 };
 
+static bool dynamic_country_user_possible(struct ath_regulatory *reg)
+{
+	if (config_enabled(CONFIG_ATH_REG_DYNAMIC_USER_CERT_TESTING))
+		return true;
+
+	switch (reg->country_code) {
+	case CTRY_UNITED_STATES:
+	case CTRY_JAPAN1:
+	case CTRY_JAPAN2:
+	case CTRY_JAPAN3:
+	case CTRY_JAPAN4:
+	case CTRY_JAPAN5:
+	case CTRY_JAPAN6:
+	case CTRY_JAPAN7:
+	case CTRY_JAPAN8:
+	case CTRY_JAPAN9:
+	case CTRY_JAPAN10:
+	case CTRY_JAPAN11:
+	case CTRY_JAPAN12:
+	case CTRY_JAPAN13:
+	case CTRY_JAPAN14:
+	case CTRY_JAPAN15:
+	case CTRY_JAPAN16:
+	case CTRY_JAPAN17:
+	case CTRY_JAPAN18:
+	case CTRY_JAPAN19:
+	case CTRY_JAPAN20:
+	case CTRY_JAPAN21:
+	case CTRY_JAPAN22:
+	case CTRY_JAPAN23:
+	case CTRY_JAPAN24:
+	case CTRY_JAPAN25:
+	case CTRY_JAPAN26:
+	case CTRY_JAPAN27:
+	case CTRY_JAPAN28:
+	case CTRY_JAPAN29:
+	case CTRY_JAPAN30:
+	case CTRY_JAPAN31:
+	case CTRY_JAPAN32:
+	case CTRY_JAPAN33:
+	case CTRY_JAPAN34:
+	case CTRY_JAPAN35:
+	case CTRY_JAPAN36:
+	case CTRY_JAPAN37:
+	case CTRY_JAPAN38:
+	case CTRY_JAPAN39:
+	case CTRY_JAPAN40:
+	case CTRY_JAPAN41:
+	case CTRY_JAPAN42:
+	case CTRY_JAPAN43:
+	case CTRY_JAPAN44:
+	case CTRY_JAPAN45:
+	case CTRY_JAPAN46:
+	case CTRY_JAPAN47:
+	case CTRY_JAPAN48:
+	case CTRY_JAPAN49:
+	case CTRY_JAPAN50:
+	case CTRY_JAPAN51:
+	case CTRY_JAPAN52:
+	case CTRY_JAPAN53:
+	case CTRY_JAPAN54:
+	case CTRY_JAPAN55:
+	case CTRY_JAPAN56:
+	case CTRY_JAPAN57:
+	case CTRY_JAPAN58:
+	case CTRY_JAPAN59:
+		return false;
+	}
+
+	return true;
+}
+
 static inline bool is_wwr_sku(u16 regd)
 {
 	return ((regd & COUNTRY_ERD_FLAG) != COUNTRY_ERD_FLAG) &&
@@ -394,78 +466,6 @@ static void ath_reg_dyn_country(struct wiphy *wiphy,
 	       reg_initiator_name(request->initiator));
 }
 
-static bool dynamic_country_user_possible(struct ath_regulatory *reg)
-{
-	if (config_enabled(CONFIG_ATH_REG_DYNAMIC_USER_CERT_TESTING))
-		return true;
-
-	switch (reg->country_code) {
-	case CTRY_UNITED_STATES:
-	case CTRY_JAPAN1:
-	case CTRY_JAPAN2:
-	case CTRY_JAPAN3:
-	case CTRY_JAPAN4:
-	case CTRY_JAPAN5:
-	case CTRY_JAPAN6:
-	case CTRY_JAPAN7:
-	case CTRY_JAPAN8:
-	case CTRY_JAPAN9:
-	case CTRY_JAPAN10:
-	case CTRY_JAPAN11:
-	case CTRY_JAPAN12:
-	case CTRY_JAPAN13:
-	case CTRY_JAPAN14:
-	case CTRY_JAPAN15:
-	case CTRY_JAPAN16:
-	case CTRY_JAPAN17:
-	case CTRY_JAPAN18:
-	case CTRY_JAPAN19:
-	case CTRY_JAPAN20:
-	case CTRY_JAPAN21:
-	case CTRY_JAPAN22:
-	case CTRY_JAPAN23:
-	case CTRY_JAPAN24:
-	case CTRY_JAPAN25:
-	case CTRY_JAPAN26:
-	case CTRY_JAPAN27:
-	case CTRY_JAPAN28:
-	case CTRY_JAPAN29:
-	case CTRY_JAPAN30:
-	case CTRY_JAPAN31:
-	case CTRY_JAPAN32:
-	case CTRY_JAPAN33:
-	case CTRY_JAPAN34:
-	case CTRY_JAPAN35:
-	case CTRY_JAPAN36:
-	case CTRY_JAPAN37:
-	case CTRY_JAPAN38:
-	case CTRY_JAPAN39:
-	case CTRY_JAPAN40:
-	case CTRY_JAPAN41:
-	case CTRY_JAPAN42:
-	case CTRY_JAPAN43:
-	case CTRY_JAPAN44:
-	case CTRY_JAPAN45:
-	case CTRY_JAPAN46:
-	case CTRY_JAPAN47:
-	case CTRY_JAPAN48:
-	case CTRY_JAPAN49:
-	case CTRY_JAPAN50:
-	case CTRY_JAPAN51:
-	case CTRY_JAPAN52:
-	case CTRY_JAPAN53:
-	case CTRY_JAPAN54:
-	case CTRY_JAPAN55:
-	case CTRY_JAPAN56:
-	case CTRY_JAPAN57:
-	case CTRY_JAPAN58:
-	case CTRY_JAPAN59:
-		return false;
-	}
-
-	return true;
-}
-
 static void ath_reg_dyn_country_user(struct wiphy *wiphy,
 				     struct ath_regulatory *reg,
 				     struct regulatory_request *request)
-- 
1.8.4.rc3

