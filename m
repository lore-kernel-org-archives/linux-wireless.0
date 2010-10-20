Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33447 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab0JTRTI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 13:19:08 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 20 Oct 2010 10:18:58 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <easwar.krishnan@atheros.com>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 4/7] cfg80211: add debug prints for when we ignore regulatory hints
Date: Wed, 20 Oct 2010 10:18:56 -0700
Message-ID: <1287595139-10761-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1287595139-10761-1-git-send-email-lrodriguez@atheros.com>
References: <1287595139-10761-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can help with debugging issues. You will only see
these with CONFIG_CFG80211_REG_DEBUG enabled.

Cc: Easwar Krishnan <easwar.krishnan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   40 +++++++++++++++++++++++++++++++++++++---
 1 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 8ab65f2..950f689 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -711,6 +711,23 @@ int freq_reg_info(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(freq_reg_info);
 
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
+
 /*
  * Note that right now we assume the desired channel bandwidth
  * is always 20 MHz for each individual channel (HT40 uses 20 MHz
@@ -821,19 +838,36 @@ static void handle_band(struct wiphy *wiphy,
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
1.7.0.4

