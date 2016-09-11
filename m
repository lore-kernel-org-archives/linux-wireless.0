Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:26917 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751623AbcIKGhH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Sep 2016 02:37:07 -0400
From: Thomas Pedersen <twp@qca.qualcomm.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes.berg@intel.com>, <greearb@candelatech.com>,
        Thomas Pedersen <twp@qca.qualcomm.com>
Subject: [PATCH v2] cfg80211: add bitrate for 20MHz MCS 9
Date: Sat, 10 Sep 2016 23:35:48 -0700
Message-ID: <1473575748-26372-1-git-send-email-twp@qca.qualcomm.com> (sfid-20160911_083724_273897_FA70C5E9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers (ath10k) report MCS 9 @ 20MHz, which
technically isn't defined. To get more meaningful value
than 0 out of this however, just extrapolate a bitrate
from ratio of MCS 7 and 9 in channels where it is allowed.

Signed-off-by: Thomas Pedersen <twp@qca.qualcomm.com>
---
v2: add MCS 9 bitrate instead of capping at MCS 8
---
 net/wireless/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index b7d1592..3e83170 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1157,7 +1157,7 @@ static u32 cfg80211_calculate_bitrate_vht(struct rate_info *rate)
 		   58500000,
 		   65000000,
 		   78000000,
-		   0,
+		   86500000,
 		},
 		{  13500000,
 		   27000000,
-- 
2.1.4
