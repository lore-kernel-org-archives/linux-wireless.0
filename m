Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0085.outbound.protection.outlook.com ([104.47.32.85]:59533
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751484AbdKMK2a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 05:28:30 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: [PATCH 01/10] qtnfmac: check that MAC exists in regulatory notifier
Date: Mon, 13 Nov 2017 13:28:06 +0300
Message-Id: <20171113102815.11254-2-sergey.matyukevich.os@quantenna.com> (sfid-20171113_112926_954615_EC63B482)
In-Reply-To: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
References: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

It is possible that regulatory notifier is called before MAC data
was allocated. We need to verify that MAC data exists before trying
to send a regulatory change event.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 7d6dc76c930a..eeffc7689455 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -802,6 +802,9 @@ static void qtnf_cfg80211_reg_notifier(struct wiphy *wiphy_in,
 			continue;
 
 		mac = bus->mac[mac_idx];
+		if (!mac)
+			continue;
+
 		wiphy = priv_to_wiphy(mac);
 
 		for (band = 0; band < NUM_NL80211_BANDS; ++band) {
-- 
2.11.0
