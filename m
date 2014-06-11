Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:52257 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaFKHXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 03:23:44 -0400
Received: by mail-we0-f178.google.com with SMTP id p10so6321313wes.23
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 00:23:42 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Eliad Peller <eliad@wizery.com>
Subject: [PATCH] regulatory: add NULL to alpha2
Date: Wed, 11 Jun 2014 10:23:35 +0300
Message-Id: <1402471415-22723-1-git-send-email-arik@wizery.com> (sfid-20140611_092347_345196_25D980A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

alpha2 is defined as 2-chars array, but is used in multiple
places as string (e.g. with nla_put_string calls), which
might leak kernel data.

Solve it by simply adding an extra char for the NULL
terminator, making such operations safe.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
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
1.9.1

