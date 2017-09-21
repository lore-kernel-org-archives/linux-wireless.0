Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0088.outbound.protection.outlook.com ([104.47.37.88]:14256
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751801AbdIUVfD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 17:35:03 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V3 5/9] qtnfmac: let wifi card handle channel switch request to the same chan
Date: Thu, 21 Sep 2017 14:34:33 -0700
Message-Id: <20170921213437.27457-6-igor.mitsyanko.os@quantenna.com> (sfid-20170921_233506_878288_201B8E53)
In-Reply-To: <20170921213437.27457-1-igor.mitsyanko.os@quantenna.com>
References: <20170921213437.27457-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

No reason to verify channel switch request in driver, it can simply be
forwarded to wireless device. Device can perform required checks and
return appropriate error code, and driver may not even have information
on current operational channel.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 17b323e..4590f30 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -846,11 +846,6 @@ static int qtnf_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		return -EINVAL;
 	}
 
-	if (cfg80211_chandef_identical(&params->chandef, &mac->chandef)) {
-		pr_err("%s: switch request to the same channel\n", dev->name);
-		return -EALREADY;
-	}
-
 	ret = qtnf_cmd_send_chan_switch(mac, params);
 	if (ret)
 		pr_warn("%s: failed to switch to channel (%u)\n",
-- 
2.9.5
