Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38908 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754414AbdBGU7z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 15:59:55 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  7 Feb 2017 22:13:56 +0200
Message-Id: <20170207201356.4752-1-luca@coelho.fi> (sfid-20170207_215959_005838_536383AC)
Subject: [PATCH] cfg80211: make rdev assignment clearer in nl80211_testmode_dump()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Avoid assigning rdev to NULL when we already have it and getting it
again from the wiphy index, by moving this code to relevant if block.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/nl80211.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 63dfa60a29ef..a7b4318f735d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8585,6 +8585,12 @@ static int nl80211_testmode_dump(struct sk_buff *skb,
 		 * so we need to offset by 1.
 		 */
 		phy_idx = cb->args[0] - 1;
+
+		rdev = cfg80211_rdev_by_wiphy_idx(phy_idx);
+		if (!rdev) {
+			err = -ENOENT;
+			goto out_err;
+		}
 	} else {
 		struct nlattr **attrbuf = genl_family_attrbuf(&nl80211_fam);
 
@@ -8599,7 +8605,6 @@ static int nl80211_testmode_dump(struct sk_buff *skb,
 			goto out_err;
 		}
 		phy_idx = rdev->wiphy_idx;
-		rdev = NULL;
 
 		if (attrbuf[NL80211_ATTR_TESTDATA])
 			cb->args[1] = (long)attrbuf[NL80211_ATTR_TESTDATA];
@@ -8610,12 +8615,6 @@ static int nl80211_testmode_dump(struct sk_buff *skb,
 		data_len = nla_len((void *)cb->args[1]);
 	}
 
-	rdev = cfg80211_rdev_by_wiphy_idx(phy_idx);
-	if (!rdev) {
-		err = -ENOENT;
-		goto out_err;
-	}
-
 	if (!rdev->ops->testmode_dump) {
 		err = -EOPNOTSUPP;
 		goto out_err;
-- 
2.11.0
