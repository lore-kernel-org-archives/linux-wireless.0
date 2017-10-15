Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0050.outbound.protection.outlook.com ([104.47.33.50]:19456
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751394AbdJOUxt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Oct 2017 16:53:49 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 2/5] qtnfmac: enable registration of more mgmt frames
Date: Sun, 15 Oct 2017 23:53:24 +0300
Message-Id: <20171015205327.9966-3-sergey.matyukevich.os@quantenna.com> (sfid-20171015_225419_714548_4CFBC6A4)
In-Reply-To: <20171015205327.9966-1-sergey.matyukevich.os@quantenna.com>
References: <20171015205327.9966-1-sergey.matyukevich.os@quantenna.com>
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
index 028bed1acd82..b4c2fa7934fd 100644
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
 
@@ -349,6 +352,13 @@ qtnf_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
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
