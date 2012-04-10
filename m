Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52073 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab2DJI5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 04:57:08 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Configure 0 as rsn cap when it is not there in rsn ie
Date: Tue, 10 Apr 2012 14:27:47 +0530
Message-ID: <1334048267-27256-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120410_105714_206252_DEE0744D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently rsn capability is not set when it is not available in
rsn IE. Set it to 0 in firmware when it is not there in the ie to
make sure host and target are consistent.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 707c299..892ece7 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2537,28 +2537,34 @@ static int ath6kl_get_rsn_capab(struct cfg80211_beacon_data *beacon,
 	/* skip element id and length */
 	rsn_ie += 2;
 
-	/* skip version, group cipher */
-	if (rsn_ie_len < 6)
+	/* skip version */
+	if (rsn_ie_len < 2)
 		return -EINVAL;
-	rsn_ie +=  6;
-	rsn_ie_len -= 6;
+	rsn_ie +=  2;
+	rsn_ie_len -= 2;
+
+	/* skip group cipher suite */
+	if (rsn_ie_len < 4)
+		return 0;
+	rsn_ie +=  4;
+	rsn_ie_len -= 4;
 
 	/* skip pairwise cipher suite */
 	if (rsn_ie_len < 2)
-		return -EINVAL;
+		return 0;
 	cnt = get_unaligned_le16(rsn_ie);
 	rsn_ie += (2 + cnt * 4);
 	rsn_ie_len -= (2 + cnt * 4);
 
 	/* skip akm suite */
 	if (rsn_ie_len < 2)
-		return -EINVAL;
+		return 0;
 	cnt = get_unaligned_le16(rsn_ie);
 	rsn_ie += (2 + cnt * 4);
 	rsn_ie_len -= (2 + cnt * 4);
 
 	if (rsn_ie_len < 2)
-		return -EINVAL;
+		return 0;
 
 	memcpy(rsn_capab, rsn_ie, 2);
 
-- 
1.7.0.4

