Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49409 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab2DJIFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 04:05:08 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Fix possible unaligned memory access in ath6kl_get_rsn_capab()
Date: Tue, 10 Apr 2012 13:35:47 +0530
Message-ID: <1334045147-26773-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120410_100518_039010_C35D71DF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

alignment is not taken care in accessing pairwise cipher and AKM suite
count which are parsed from rsn ie. Fix this alignment issue.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index fb73196..707c299 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2546,14 +2546,14 @@ static int ath6kl_get_rsn_capab(struct cfg80211_beacon_data *beacon,
 	/* skip pairwise cipher suite */
 	if (rsn_ie_len < 2)
 		return -EINVAL;
-	cnt = *((u16 *) rsn_ie);
+	cnt = get_unaligned_le16(rsn_ie);
 	rsn_ie += (2 + cnt * 4);
 	rsn_ie_len -= (2 + cnt * 4);
 
 	/* skip akm suite */
 	if (rsn_ie_len < 2)
 		return -EINVAL;
-	cnt = *((u16 *) rsn_ie);
+	cnt = get_unaligned_le16(rsn_ie);
 	rsn_ie += (2 + cnt * 4);
 	rsn_ie_len -= (2 + cnt * 4);
 
-- 
1.7.0.4

