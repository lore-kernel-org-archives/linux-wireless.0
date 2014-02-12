Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24441 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbaBLHeW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 02:34:22 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Inbal Hacohen <Inbal.Hacohen@intel.com>
Subject: [PATCH] cfg80211: bugfix in regulatory user hint process
Date: Wed, 12 Feb 2014 09:32:27 +0200
Message-Id: <1392190347-5570-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140212_083426_105700_9728A791)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Inbal Hacohen <Inbal.Hacohen@intel.com>

After processing hint_user, we would want to schedule the
timeout work only if we are actually waiting to CRDA. This happens
when the status is not "IGNORE" nor "ALREADY_SET".

Signed-off-by: Inbal Hacohen <Inbal.Hacohen@intel.com>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index fa149ea..1301ada 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1700,7 +1700,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		return;
 	case NL80211_REGDOM_SET_BY_USER:
 		treatment = reg_process_hint_user(reg_request);
-		if (treatment == REG_REQ_OK ||
+		if (treatment == REG_REQ_IGNORE ||
 		    treatment == REG_REQ_ALREADY_SET)
 			return;
 		schedule_delayed_work(&reg_timeout, msecs_to_jiffies(3142));
-- 
1.8.3.2

