Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0052.outbound.protection.outlook.com ([104.47.40.52]:13344
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750941AbdIBBo7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 21:44:59 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V2 1/9] qtnfmac: qlink: convert channel width from bitfiled to simple enum
Date: Fri,  1 Sep 2017 18:44:43 -0700
Message-Id: <20170902014451.17766-2-igor.mitsyanko.os@quantenna.com> (sfid-20170902_034506_101462_999A6781)
In-Reply-To: <20170902014451.17766-1-igor.mitsyanko.os@quantenna.com>
References: <20170902014451.17766-1-igor.mitsyanko.os@quantenna.com>
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
