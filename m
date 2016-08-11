Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28440 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbcHKJob (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 05:44:31 -0400
From: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <jouni@qca.qualcomm.com>,
	<usdutt@qti.qualcomm.com>, <mkalikot@qca.qualcomm.com>,
	<amarnath@qca.qualcomm.com>, <djindal@qti.qualcomm.com>,
	<pkushwah@qti.qualcomm.com>
Subject: [PATCH] cfg80211: validate beacon interval for MESH/IBSS
Date: Thu, 11 Aug 2016 15:14:02 +0530
Message-ID: <1470908642-13535-1-git-send-email-pkushwah@qti.qualcomm.com> (sfid-20160811_114434_695335_BB56F215)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Beacon interval validation was missing for MESH / IBSS join.
This commit addresses the same.

Signed-off-by: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
---
 net/wireless/nl80211.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f02653a..ddb1469 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7780,6 +7780,10 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
+	err = cfg80211_validate_beacon_int(rdev, ibss.beacon_interval);
+	if (err)
+		return err;
+
 	if (!rdev->ops->join_ibss)
 		return -EOPNOTSUPP;
 
@@ -9255,6 +9259,10 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 		if (setup.beacon_interval < 10 ||
 		    setup.beacon_interval > 10000)
 			return -EINVAL;
+
+		err = cfg80211_validate_beacon_int(rdev, setup.beacon_interval);
+		if (err)
+			return err;
 	}
 
 	if (info->attrs[NL80211_ATTR_DTIM_PERIOD]) {
-- 
1.9.1

