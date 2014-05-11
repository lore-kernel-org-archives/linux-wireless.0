Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57928 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758003AbaEKIxu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 04:53:50 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 7/7] regulatory: add NULL to alpha2
Date: Sun, 11 May 2014 11:50:50 +0300
Message-Id: <1399798250-20987-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140511_105354_713074_3983F9B4)
In-Reply-To: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

alpha2 is defined as 2-chars array, but is used in multiple
places as string (e.g. with nla_put_string calls), which
might leak kernel data.

Solve it by simply adding an extra char for the NULL
terminator, making such operations safe.

Change-Id: Ib31639dc65deab62953923cab3cdf169cb1d0d32
Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/regulatory.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index 2599924..dad7ab2 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -167,7 +167,7 @@ struct ieee80211_reg_rule {
 struct ieee80211_regdomain {
 	struct rcu_head rcu_head;
 	u32 n_reg_rules;
-	char alpha2[2];
+	char alpha2[3];
 	enum nl80211_dfs_regions dfs_region;
 	struct ieee80211_reg_rule reg_rules[];
 };
-- 
1.8.3.2

