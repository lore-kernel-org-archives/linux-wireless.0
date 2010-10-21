Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:35231 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376Ab0JUNrg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 09:47:36 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 06:47:26 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Easwar Krishnan <easwar.krishnan@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH v2 4/7] cfg80211: add debug prints for when we ignore regulatory hints
Date: Thu, 21 Oct 2010 19:17:03 +0530
Message-ID: <1287668824-3096-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <lrodriguez@atheros.com>

This can help with debugging issues. You will only see
these with CONFIG_CFG80211_REG_DEBUG enabled.

Cc: Easwar Krishnan <easwar.krishnan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
v2 -- brought in reg_initiator_name under reg debug to get rid of a
warning  message.

 net/wireless/reg.c |   42 +++++++++++++++++++++++++++++++++++++++---
 1 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 8ab65f2..7bff1c1 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -711,6 +711,25 @@ int freq_reg_info(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(freq_reg_info);

+#ifdef CONFIG_CFG80211_REG_DEBUG
+static const char *reg_initiator_name(enum nl80211_reg_initiator initiator)
+{
+	switch (initiator) {
+	case NL80211_REGDOM_SET_BY_CORE:
+		return "Set by core";
+	case NL80211_REGDOM_SET_BY_USER:
+		return "Set by user";
+	case NL80211_REGDOM_SET_BY_DRIVER:
+		return "Set by driver";
+	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
+		return "Set by country IE";
+	default:
+		WARN_ON(1);
+		return "Set by bug";
+	}
+}
+#endif
+
 /*
  * Note that right now we assume the desired channel bandwidth
  * is always 20 MHz for each individual channel (HT40 uses 20 MHz
@@ -821,19 +840,36 @@ static void handle_band(struct wiphy *wiphy,
 static bool ignore_reg_update(struct wiphy *wiphy,
 			      enum nl80211_reg_initiator initiator)
 {
-	if (!last_request)
+	if (!last_request) {
+		REG_DBG_PRINT("cfg80211: Ignoring regulatory request %s since "
+			      "last_request is not set\n",
+			      reg_initiator_name(initiator));
 		return true;
+	}
+
 	if (initiator == NL80211_REGDOM_SET_BY_CORE &&
-	    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY)
+	    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY) {
+		REG_DBG_PRINT("cfg80211: Ignoring regulatory request %s "
+			      "since the driver uses its own custom "
+			      "regulatory domain ",
+			      reg_initiator_name(initiator));
 		return true;
+	}
+
 	/*
 	 * wiphy->regd will be set once the device has its own
 	 * desired regulatory domain set
 	 */
 	if (wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY && !wiphy->regd &&
 	    initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-	    !is_world_regdom(last_request->alpha2))
+	    !is_world_regdom(last_request->alpha2)) {
+		REG_DBG_PRINT("cfg80211: Ignoring regulatory request %s "
+			      "since the driver requires its own regulaotry "
+			      "domain to be set first",
+			      reg_initiator_name(initiator));
 		return true;
+	}
+
 	return false;
 }

--
1.7.2.1

