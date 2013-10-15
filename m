Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:57823 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab3JOAmg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 20:42:36 -0400
Received: by mail-pd0-f182.google.com with SMTP id r10so8098427pdi.13
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 17:42:36 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 4/6] ath: add support for proper dynamic regulatory hints
Date: Mon, 14 Oct 2013 17:42:09 -0700
Message-Id: <1381797731-2454-5-git-send-email-mcgrof@do-not-panic.com> (sfid-20131015_024239_143103_03685EAB)
In-Reply-To: <1381797731-2454-1-git-send-email-mcgrof@do-not-panic.com>
References: <1381797731-2454-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This enables support for dynamic user regulatory hints.
This is enabled only when CFG80211_CERTIFICATION_ONUS
is selected. For US and JP this is explicitly disabled
unless the systems are being used for strict controlled
testing.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/Kconfig | 17 ++++++++
 drivers/net/wireless/ath/regd.c  | 84 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+)

diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index ba81d62..c63d115 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -25,6 +25,23 @@ config ATH_DEBUG
 	  Say Y, if you want to debug atheros wireless drivers.
 	  Right now only ath9k makes use of this.
 
+config ATH_REG_DYNAMIC_USER_REG_HINTS
+	bool "Atheros dynamic user regulatory hints"
+	depends on CFG80211_CERTIFICATION_ONUS
+	default n
+	---help---
+	  Say N. This should only be enabled in countries where
+	  this feature is explicitly allowed and only on cards that
+	  specifically have been tested for this.
+
+config ATH_REG_DYNAMIC_USER_CERT_TESTING
+	bool "Atheros dynamic user regulatory testing"
+	depends on ATH_REG_DYNAMIC_USER_REG_HINTS && CFG80211_CERTIFICATION_ONUS
+	default n
+	---help---
+	  Say N. This should only be enabled on systems
+	  undergoing certification testing.
+
 source "drivers/net/wireless/ath/ath5k/Kconfig"
 source "drivers/net/wireless/ath/ath9k/Kconfig"
 source "drivers/net/wireless/ath/carl9170/Kconfig"
diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 7222eeb..c00687e 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -392,6 +392,89 @@ static void ath_reg_dyn_country(struct wiphy *wiphy,
 	       reg_initiator_name(request->initiator));
 }
 
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
+static void ath_reg_dyn_country_user(struct wiphy *wiphy,
+				     struct ath_regulatory *reg,
+				     struct regulatory_request *request)
+{
+	if (!config_enabled(CONFIG_ATH_REG_DYNAMIC_USER_REG_HINTS))
+		return;
+	if (!dynamic_country_user_possible(reg))
+		return;
+	ath_reg_dyn_country(wiphy, reg, request);
+}
+
 void ath_reg_notifier_apply(struct wiphy *wiphy,
 			    struct regulatory_request *request,
 			    struct ath_regulatory *reg)
@@ -424,6 +507,7 @@ void ath_reg_notifier_apply(struct wiphy *wiphy,
 	case NL80211_REGDOM_SET_BY_DRIVER:
 		break;
 	case NL80211_REGDOM_SET_BY_USER:
+		ath_reg_dyn_country_user(wiphy, reg, request);
 		break;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
 		ath_reg_dyn_country(wiphy, reg, request);
-- 
1.8.4.rc3

