Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57928 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757966AbaEKIxh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 04:53:37 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/7] cfg80211: don't set reg timeout for user-handled hint
Date: Sun, 11 May 2014 11:50:44 +0300
Message-Id: <1399798250-20987-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140511_105345_577377_B7B88670)
In-Reply-To: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Otherwise every "indoor" setting by usermode will cause a regdomain reset.

Change-Id: I3225325d9fb956174458d386d4dd0f4e069deb58
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/wireless/reg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e78f532..558b0e3 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1876,7 +1876,8 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	case NL80211_REGDOM_SET_BY_USER:
 		treatment = reg_process_hint_user(reg_request);
 		if (treatment == REG_REQ_IGNORE ||
-		    treatment == REG_REQ_ALREADY_SET)
+		    treatment == REG_REQ_ALREADY_SET ||
+		    treatment == REG_REQ_USER_HINT_HANDLED)
 			return;
 		queue_delayed_work(system_power_efficient_wq,
 				   &reg_timeout, msecs_to_jiffies(3142));
-- 
1.8.3.2

