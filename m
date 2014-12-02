Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8921 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271AbaLBH6C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 02:58:02 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: mcgrof@suse.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] cfg80211: don't WARN about two consecutive Country IE hint
Date: Tue,  2 Dec 2014 09:53:25 +0200
Message-Id: <1417506805-20361-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141202_085842_898186_BB549435)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can happen and there is no point in added more
detection code lower in the stack. Catching these in one
single point (cfg80211) is enough. Stop WARNING about this
case.

This fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=89001

Cc: <stable@vger.kernel.org>
Fixes: 2f1c6c572d7b ("cfg80211: process non country IE conflicting first")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/wireless/reg.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 8fe21c0..3e69554 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2047,11 +2047,8 @@ __reg_process_hint_country_ie(struct wiphy *wiphy,
 			return REG_REQ_IGNORE;
 		return REG_REQ_ALREADY_SET;
 	}
-	/*
-	 * Two consecutive Country IE hints on the same wiphy.
-	 * This should be picked up early by the driver/stack
-	 */
-	if (WARN_ON(regdom_changes(country_ie_request->alpha2)))
+
+	if (regdom_changes(country_ie_request->alpha2))
 		return REG_REQ_OK;
 	return REG_REQ_ALREADY_SET;
 }
-- 
1.9.1

