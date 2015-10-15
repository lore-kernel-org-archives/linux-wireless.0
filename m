Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38706 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbbJON63 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 09:58:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 08/12] cfg80211: reg: clarify 'treatment' handling in reg_process_hint()
Date: Thu, 15 Oct 2015 15:58:19 +0200
Message-Id: <1444917503-19118-8-git-send-email-johannes@sipsolutions.net> (sfid-20151015_155836_677202_6951A520)
In-Reply-To: <1444917503-19118-1-git-send-email-johannes@sipsolutions.net>
References: <1444917503-19118-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This function can only deal with treatment values OK and ALREADY_SET
so make the callees not return anything else and warn if they do.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5532ecc080e5..6118c1e664be 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2026,14 +2026,13 @@ reg_process_hint_driver(struct wiphy *wiphy,
 		break;
 	case REG_REQ_IGNORE:
 		reg_free_request(driver_request);
-		return treatment;
+		return REG_REQ_OK;
 	case REG_REQ_INTERSECT:
-		/* fall through */
 	case REG_REQ_ALREADY_SET:
 		regd = reg_copy_regd(get_cfg80211_regdom());
 		if (IS_ERR(regd)) {
 			reg_free_request(driver_request);
-			return REG_REQ_IGNORE;
+			return REG_REQ_OK;
 		}
 
 		tmp = get_wiphy_regdom(wiphy);
@@ -2054,7 +2053,7 @@ reg_process_hint_driver(struct wiphy *wiphy,
 		nl80211_send_reg_change_event(driver_request);
 		reg_update_last_request(driver_request);
 		reg_set_request_processed();
-		return treatment;
+		return REG_REQ_ALREADY_SET;
 	}
 
 	if (reg_query_database(driver_request))
@@ -2128,10 +2127,10 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
 	case REG_REQ_OK:
 		break;
 	case REG_REQ_IGNORE:
-		/* fall through */
+		return REG_REQ_OK;
 	case REG_REQ_ALREADY_SET:
 		reg_free_request(country_ie_request);
-		return treatment;
+		return REG_REQ_ALREADY_SET;
 	case REG_REQ_INTERSECT:
 		reg_free_request(country_ie_request);
 		/*
@@ -2139,7 +2138,7 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
 		 * ever want to support it for this case.
 		 */
 		WARN_ONCE(1, "Unexpected intersection for country IEs");
-		return REG_REQ_IGNORE;
+		return REG_REQ_OK;
 	}
 
 	country_ie_request->intersect = false;
@@ -2184,6 +2183,9 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		goto out_free;
 	}
 
+	WARN(treatment != REG_REQ_OK && treatment != REG_REQ_ALREADY_SET,
+	     "unexpected treatment value %d\n", treatment);
+
 	/* This is required so that the orig_* parameters are saved.
 	 * NOTE: treatment must be set for any case that reaches here!
 	 */
-- 
2.5.1

