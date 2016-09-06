Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:42120 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935319AbcIFTBe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 15:01:34 -0400
From: Thomas Pedersen <twp@qca.qualcomm.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
        Thomas Pedersen <twp@qca.qualcomm.com>
Subject: [PATCH] cfg80211: cap 20MHz VHT bitrate at MCS 8
Date: Tue, 6 Sep 2016 12:00:17 -0700
Message-ID: <1473188417-13987-1-git-send-email-twp@qca.qualcomm.com> (sfid-20160906_210455_004286_9495AEAB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers (ath10k) report MCS 9 @ 20MHz, which
technically isn't allowed. To get more meaningful value
than 0 out of this however, just cap the bitrate for 20MHz
to MCS 8.

Signed-off-by: Thomas Pedersen <twp@qca.qualcomm.com>
---
 net/wireless/util.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 0675f51..5fb0249 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1157,7 +1157,9 @@ static u32 cfg80211_calculate_bitrate_vht(struct rate_info *rate)
 		   58500000,
 		   65000000,
 		   78000000,
-		   0,
+		   /* some drivers report MCS 9 for 20MHz anyway. Clip to MCS 8
+		    * bitrate as it's closer than 0 */
+		   78000000,
 		},
 		{  13500000,
 		   27000000,
-- 
2.1.4
