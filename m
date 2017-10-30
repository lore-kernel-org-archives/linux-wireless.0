Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0063.outbound.protection.outlook.com ([104.47.38.63]:27360
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932549AbdJ3KON (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 06:14:13 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 2/5] qtnfmac: enable registration of more mgmt frames
Date: Mon, 30 Oct 2017 13:13:47 +0300
Message-Id: <20171030101350.21251-3-sergey.matyukevich.os@quantenna.com> (sfid-20171030_111417_783674_7F8EC3A7)
In-Reply-To: <20171030101350.21251-1-sergey.matyukevich.os@quantenna.com>
References: <20171030101350.21251-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support registration for more mgmt frame types
for debug and monitoring purposes.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 63a540d1216e..64db4082c9d2 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -73,7 +73,10 @@ qtnf_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 	[NL80211_IFTYPE_AP] = {
 		.tx = BIT(IEEE80211_STYPE_ACTION >> 4),
 		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
-		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4),
+		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
+		      BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
+		      BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
+		      BIT(IEEE80211_STYPE_AUTH >> 4),
 	},
 };
 
@@ -353,6 +356,13 @@ qtnf_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 		return;
 
 	switch (frame_type & IEEE80211_FCTL_STYPE) {
+	case IEEE80211_STYPE_REASSOC_REQ:
+	case IEEE80211_STYPE_ASSOC_REQ:
+		qlink_frame_type = QLINK_MGMT_FRAME_ASSOC_REQ;
+		break;
+	case IEEE80211_STYPE_AUTH:
+		qlink_frame_type = QLINK_MGMT_FRAME_AUTH;
+		break;
 	case IEEE80211_STYPE_PROBE_REQ:
 		qlink_frame_type = QLINK_MGMT_FRAME_PROBE_REQ;
 		break;
-- 
2.11.0
