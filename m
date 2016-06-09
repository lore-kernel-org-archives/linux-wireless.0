Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58300 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180AbcFIIl4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 04:41:56 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
	Eduardo Abinader <eabinader@ocedo.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: clarify nl80211_set_reg() success path
Date: Thu,  9 Jun 2016 10:41:52 +0200
Message-Id: <1465461712-10283-1-git-send-email-johannes@sipsolutions.net> (sfid-20160609_104159_945501_7BED65E1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Setting rd to NULL to avoid freeing it, just to be able to return
from the function in a single place, doesn't make much sense.

Return the set_regdom() return value directly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0d7db10c782f..c503e96bfd5a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5836,10 +5836,8 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	r = set_regdom(rd, REGD_SOURCE_CRDA);
-	/* set_regdom took ownership */
-	rd = NULL;
-
+	/* set_regdom takes ownership of rd */
+	return set_regdom(rd, REGD_SOURCE_CRDA);
  bad_reg:
 	kfree(rd);
 	return r;
-- 
2.8.0.rc3

