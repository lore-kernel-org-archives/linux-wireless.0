Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58986 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752240AbdEHJcP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 May 2017 05:32:15 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: correctly validate MU-MIMO groups
Date: Mon,  8 May 2017 11:32:11 +0200
Message-Id: <20170508093211.9611-1-johannes@sipsolutions.net> (sfid-20170508_113218_435247_46183D39)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since groups 0 and 63 are invalid, we should check for those bits.
Note that the 802.11 spec specifies the *bit* order, but the CPU
doesn't care about bit order since it can't address bits, so it's
always treating BIT(0) as the lowest bit within a byte.

Reported-by: Jan Fuchs <jan.fuchs@lancom.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 570fc95dc507..c3bc9da30cff 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2764,8 +2764,8 @@ static int nl80211_parse_mon_options(struct cfg80211_registered_device *rdev,
 			nla_data(info->attrs[NL80211_ATTR_MU_MIMO_GROUP_DATA]);
 
 		/* bits 0 and 63 are reserved and must be zero */
-		if ((mumimo_groups[0] & BIT(7)) ||
-		    (mumimo_groups[VHT_MUMIMO_GROUPS_DATA_LEN - 1] & BIT(0)))
+		if ((mumimo_groups[0] & BIT(0)) ||
+		    (mumimo_groups[VHT_MUMIMO_GROUPS_DATA_LEN - 1] & BIT(7)))
 			return -EINVAL;
 
 		params->vht_mumimo_groups = mumimo_groups;
-- 
2.11.0
