Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58028 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944726AbcJaSbT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Oct 2016 14:31:19 -0400
From: Thomas Pedersen <twp@qca.qualcomm.com>
To: Johannes Berg <johannes.berg@intel.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
        Thomas Pedersen <twp@qca.qualcomm.com>
Subject: [PATCH RESEND v2] cfg80211: add bitrate for 20MHz MCS 9
Date: Mon, 31 Oct 2016 11:28:40 -0700
Message-ID: <20161031182840.5984-1-twp@qca.qualcomm.com> (sfid-20161031_193145_758136_3E14680B)
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
index 32060f8..30fc320 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1163,7 +1163,7 @@ static u32 cfg80211_calculate_bitrate_vht(struct rate_info *rate)
 		   58500000,
 		   65000000,
 		   78000000,
-		   0,
+		   86500000,
 		},
 		{  13500000,
 		   27000000,
-- 
2.10.0.297.gf6727b0
