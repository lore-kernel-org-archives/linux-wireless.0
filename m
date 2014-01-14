Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:30603 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaANNPe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 08:15:34 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH] cfg80211: fix few minor issues in reg_process_hint()
Date: Tue, 14 Jan 2014 15:17:23 +0200
Message-Id: <1389705443-23410-1-git-send-email-ilan.peer@intel.com> (sfid-20140114_141537_791569_4F9CE0C3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the following issues in reg_process_hint():

1. Add verification that wiphy is valid before processing
   NL80211_REGDOMAIN_SET_BY_COUNTRY_IE.
2. Free the request in case of invalid initiator.
3. Remove WARN_ON check on reg_request->alpha2 as it is not a
   pointer.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 net/wireless/reg.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9b897fc..484facf 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1683,17 +1683,9 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	struct wiphy *wiphy = NULL;
 	enum reg_request_treatment treatment;
 
-	if (WARN_ON(!reg_request->alpha2))
-		return;
-
 	if (reg_request->wiphy_idx != WIPHY_IDX_INVALID)
 		wiphy = wiphy_idx_to_wiphy(reg_request->wiphy_idx);
 
-	if (reg_request->initiator == NL80211_REGDOM_SET_BY_DRIVER && !wiphy) {
-		kfree(reg_request);
-		return;
-	}
-
 	switch (reg_request->initiator) {
 	case NL80211_REGDOM_SET_BY_CORE:
 		reg_process_hint_core(reg_request);
@@ -1706,20 +1698,29 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		schedule_delayed_work(&reg_timeout, msecs_to_jiffies(3142));
 		return;
 	case NL80211_REGDOM_SET_BY_DRIVER:
+		if (!wiphy)
+			goto out_free;
 		treatment = reg_process_hint_driver(wiphy, reg_request);
 		break;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
+		if (!wiphy)
+			goto out_free;
 		treatment = reg_process_hint_country_ie(wiphy, reg_request);
 		break;
 	default:
 		WARN(1, "invalid initiator %d\n", reg_request->initiator);
-		return;
+		goto out_free;
 	}
 
 	/* This is required so that the orig_* parameters are saved */
 	if (treatment == REG_REQ_ALREADY_SET && wiphy &&
 	    wiphy->regulatory_flags & REGULATORY_STRICT_REG)
 		wiphy_update_regulatory(wiphy, reg_request->initiator);
+
+	return;
+
+out_free:
+	kfree(reg_request);
 }
 
 /*
-- 
1.7.10.4

