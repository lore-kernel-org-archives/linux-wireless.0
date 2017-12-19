Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0052.outbound.protection.outlook.com ([104.47.42.52]:40224
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S937682AbdLSL3T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 06:29:19 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: [PATCH v2 01/10] qtnfmac: check that MAC exists in regulatory notifier
Date: Tue, 19 Dec 2017 14:28:47 +0300
Message-Id: <20171219112856.22463-2-sergey.matyukevich.os@quantenna.com> (sfid-20171219_122925_818560_98841BF5)
In-Reply-To: <20171219112856.22463-1-sergey.matyukevich.os@quantenna.com>
References: <20171219112856.22463-1-sergey.matyukevich.os@quantenna.com>
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
index 6711e7fb6926..63d274c3f2f7 100644
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
