Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ye0-f171.google.com ([209.85.213.171]:64221 "EHLO
	mail-ye0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3ISQSW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Sep 2013 12:18:22 -0400
Received: by mail-ye0-f171.google.com with SMTP id q3so3571285yen.30
        for <linux-wireless@vger.kernel.org>; Thu, 19 Sep 2013 09:18:21 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 1/4] cfg80211: export reg_initiator_name()
Date: Thu, 19 Sep 2013 11:18:07 -0500
Message-Id: <1379607490-18972-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20130919_181825_353097_F725FC3A)
In-Reply-To: <1379607490-18972-1-git-send-email-mcgrof@do-not-panic.com>
References: <1379607490-18972-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Drivers can now use this to parse the regulatory request and
be more verbose when needed.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/net/cfg80211.h |    9 +++++++++
 net/wireless/reg.c     |   27 +++++++++++++++++----------
 2 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d530c54..afb2323 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3474,6 +3474,15 @@ extern void wiphy_apply_custom_regulatory(
 const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
 					       u32 center_freq);
 
+/**
+ * reg_initiator_name - map regulatory request initiator enum to name
+ * @initiator: the regulatory request initiator
+ *
+ * You can use this to map the regulatory request initiator enum to a
+ * proper string representation.
+ */
+const char *reg_initiator_name(enum nl80211_reg_initiator initiator);
+
 /*
  * callbacks for asynchronous cfg80211 methods, notification
  * functions and BSS handling helpers
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index de06d5d..5164716 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -758,23 +758,25 @@ const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(freq_reg_info);
 
-#ifdef CONFIG_CFG80211_REG_DEBUG
-static const char *reg_initiator_name(enum nl80211_reg_initiator initiator)
+const char *reg_initiator_name(enum nl80211_reg_initiator initiator)
 {
 	switch (initiator) {
 	case NL80211_REGDOM_SET_BY_CORE:
-		return "Set by core";
+		return "core";
 	case NL80211_REGDOM_SET_BY_USER:
-		return "Set by user";
+		return "user";
 	case NL80211_REGDOM_SET_BY_DRIVER:
-		return "Set by driver";
+		return "driver";
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
-		return "Set by country IE";
+		return "country IE";
 	default:
 		WARN_ON(1);
-		return "Set by bug";
+		return "bug";
 	}
 }
+EXPORT_SYMBOL(reg_initiator_name);
+
+#ifdef CONFIG_CFG80211_REG_DEBUG
 
 static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
 				    const struct ieee80211_reg_rule *reg_rule)
@@ -969,14 +971,17 @@ static bool ignore_reg_update(struct wiphy *wiphy,
 	struct regulatory_request *lr = get_last_request();
 
 	if (!lr) {
-		REG_DBG_PRINT("Ignoring regulatory request %s since last_request is not set\n",
+		REG_DBG_PRINT("Ignoring regulatory request set by %s "
+			      "since last_request is not set\n",
 			      reg_initiator_name(initiator));
 		return true;
 	}
 
 	if (initiator == NL80211_REGDOM_SET_BY_CORE &&
 	    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY) {
-		REG_DBG_PRINT("Ignoring regulatory request %s since the driver uses its own custom regulatory domain\n",
+		REG_DBG_PRINT("Ignoring regulatory request set by %s "
+			      "since the driver uses its own custom "
+			      "regulatory domain\n",
 			      reg_initiator_name(initiator));
 		return true;
 	}
@@ -988,7 +993,9 @@ static bool ignore_reg_update(struct wiphy *wiphy,
 	if (wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY && !wiphy->regd &&
 	    initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
 	    !is_world_regdom(lr->alpha2)) {
-		REG_DBG_PRINT("Ignoring regulatory request %s since the driver requires its own regulatory domain to be set first\n",
+		REG_DBG_PRINT("Ignoring regulatory request set by %s "
+			      "since the driver requires its own regulatory "
+			      "domain to be set first\n",
 			      reg_initiator_name(initiator));
 		return true;
 	}
-- 
1.7.10.4

