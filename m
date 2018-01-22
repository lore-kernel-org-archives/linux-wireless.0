Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0084.outbound.protection.outlook.com ([104.47.38.84]:56768
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751113AbeAVMrL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 07:47:11 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 08/11] qtnfmac: fix STA disconnect procedure
Date: Mon, 22 Jan 2018 15:46:31 +0300
Message-Id: <20180122124634.8430-9-sergey.matyukevich.os@quantenna.com> (sfid-20180122_134723_676402_328D21F5)
In-Reply-To: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
References: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

STA does not reconnect to the same AP after disconnect. The reason is
that STA is marked as disconnected in cfg80211 disconnect callback.
This is too early since in this case qtnfmac event handler skips
cfg80211_disconnected call when processing disconnect event from
the card. As a result, wdev is left in an inconsistent state.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 91830fd41508..edebf23e8eae 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -679,7 +679,6 @@ qtnf_disconnect(struct wiphy *wiphy, struct net_device *dev,
 		return ret;
 	}
 
-	vif->sta_state = QTNF_STA_DISCONNECTED;
 	return 0;
 }
 
-- 
2.11.0
