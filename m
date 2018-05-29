Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0088.outbound.protection.outlook.com ([104.47.42.88]:23410
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933651AbeE2MAp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 08:00:45 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>
Subject: [PATCH 8/9] qtnfmac: cancel scan on disconnect
Date: Tue, 29 May 2018 15:00:04 +0300
Message-Id: <20180529120005.21498-9-sergey.matyukevich.os@quantenna.com> (sfid-20180529_140055_939300_D9B2DBB9)
In-Reply-To: <20180529120005.21498-1-sergey.matyukevich.os@quantenna.com>
References: <20180529120005.21498-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrey Shevchenko <ashevchenko@quantenna.com>

Cancel scan operation on STA disconnect.

Signed-off-by: Andrey Shevchenko <ashevchenko@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 2089cb095283..1fcd94bf7c59 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -660,6 +660,8 @@ qtnf_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	if (vif->wdev.iftype != NL80211_IFTYPE_STATION)
 		return -EOPNOTSUPP;
 
+	qtnf_scan_done(mac, true);
+
 	if (vif->sta_state == QTNF_STA_DISCONNECTED)
 		return 0;
 
-- 
2.11.0
