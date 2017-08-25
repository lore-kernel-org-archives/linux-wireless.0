Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0082.outbound.protection.outlook.com ([104.47.37.82]:41477
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754347AbdHYCaq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:30:46 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 01/27] qtnfmac: qlink: convert channel width from bitfiled to simple enum
Date: Thu, 24 Aug 2017 19:29:58 -0700
Message-Id: <20170825023024.10565-2-igor.mitsyanko.os@quantenna.com> (sfid-20170825_043100_256641_55D61EFC)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/qlink.h      | 16 ++++++++--------
 drivers/net/wireless/quantenna/qtnfmac/qlink_util.c | 16 ++++++++--------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index a8242f6..a69fd470 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -108,14 +108,14 @@ enum qlink_sta_flags {
 };
 
 enum qlink_channel_width {
-	QLINK_CHAN_WIDTH_5		= BIT(0),
-	QLINK_CHAN_WIDTH_10		= BIT(1),
-	QLINK_CHAN_WIDTH_20_NOHT	= BIT(2),
-	QLINK_CHAN_WIDTH_20		= BIT(3),
-	QLINK_CHAN_WIDTH_40		= BIT(4),
-	QLINK_CHAN_WIDTH_80		= BIT(5),
-	QLINK_CHAN_WIDTH_80P80		= BIT(6),
-	QLINK_CHAN_WIDTH_160		= BIT(7),
+	QLINK_CHAN_WIDTH_5 = 0,
+	QLINK_CHAN_WIDTH_10,
+	QLINK_CHAN_WIDTH_20_NOHT,
+	QLINK_CHAN_WIDTH_20,
+	QLINK_CHAN_WIDTH_40,
+	QLINK_CHAN_WIDTH_80,
+	QLINK_CHAN_WIDTH_80P80,
+	QLINK_CHAN_WIDTH_160,
 };
 
 /* QLINK Command messages related definitions
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
index cf024c9..369b77d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
@@ -49,28 +49,28 @@ u8 qlink_chan_width_mask_to_nl(u16 qlink_mask)
 {
 	u8 result = 0;
 
-	if (qlink_mask & QLINK_CHAN_WIDTH_5)
+	if (qlink_mask & BIT(QLINK_CHAN_WIDTH_5))
 		result |= BIT(NL80211_CHAN_WIDTH_5);
 
-	if (qlink_mask & QLINK_CHAN_WIDTH_10)
+	if (qlink_mask & BIT(QLINK_CHAN_WIDTH_10))
 		result |= BIT(NL80211_CHAN_WIDTH_10);
 
-	if (qlink_mask & QLINK_CHAN_WIDTH_20_NOHT)
+	if (qlink_mask & BIT(QLINK_CHAN_WIDTH_20_NOHT))
 		result |= BIT(NL80211_CHAN_WIDTH_20_NOHT);
 
-	if (qlink_mask & QLINK_CHAN_WIDTH_20)
+	if (qlink_mask & BIT(QLINK_CHAN_WIDTH_20))
 		result |= BIT(NL80211_CHAN_WIDTH_20);
 
-	if (qlink_mask & QLINK_CHAN_WIDTH_40)
+	if (qlink_mask & BIT(QLINK_CHAN_WIDTH_40))
 		result |= BIT(NL80211_CHAN_WIDTH_40);
 
-	if (qlink_mask & QLINK_CHAN_WIDTH_80)
+	if (qlink_mask & BIT(QLINK_CHAN_WIDTH_80))
 		result |= BIT(NL80211_CHAN_WIDTH_80);
 
-	if (qlink_mask & QLINK_CHAN_WIDTH_80P80)
+	if (qlink_mask & BIT(QLINK_CHAN_WIDTH_80P80))
 		result |= BIT(NL80211_CHAN_WIDTH_80P80);
 
-	if (qlink_mask & QLINK_CHAN_WIDTH_160)
+	if (qlink_mask & BIT(QLINK_CHAN_WIDTH_160))
 		result |= BIT(NL80211_CHAN_WIDTH_160);
 
 	return result;
-- 
2.9.5
