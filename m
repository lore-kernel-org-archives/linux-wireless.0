Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:46112 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751296AbeBVT6K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Feb 2018 14:58:10 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Kees Cook <keescook@google.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] regulatory: add NUL to request alpha2
Date: Thu, 22 Feb 2018 20:58:07 +0100
Message-Id: <20180222195807.23458-1-johannes@sipsolutions.net> (sfid-20180222_205813_765024_F9480099)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Similar to the ancient commit a5fe8e7695dc ("regulatory: add NUL
to alpha2"), add another byte to alpha2 in the request struct so
that when we use nla_put_string(), we don't overrun anything.

Fixes: 73d54c9e74c4 ("cfg80211: add regulatory netlink multicast group")
Reported-by: Kees Cook <keescook@google.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/regulatory.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index ebc5a2ed8631..f83cacce3308 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -78,7 +78,7 @@ struct regulatory_request {
 	int wiphy_idx;
 	enum nl80211_reg_initiator initiator;
 	enum nl80211_user_reg_hint_type user_reg_hint_type;
-	char alpha2[2];
+	char alpha2[3];
 	enum nl80211_dfs_regions dfs_region;
 	bool intersect;
 	bool processed;
-- 
2.15.1
