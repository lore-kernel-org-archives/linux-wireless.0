Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0041.outbound.protection.outlook.com ([104.47.37.41]:61440
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754478AbdHYCa5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:30:57 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 12/27] qtnfmac: let wifi card handle channel switch request to the same chan
Date: Thu, 24 Aug 2017 19:30:09 -0700
Message-Id: <20170825023024.10565-13-igor.mitsyanko.os@quantenna.com> (sfid-20170825_043139_652206_AC578D59)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 501ece3..062189b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -760,11 +760,6 @@ static int qtnf_channel_switch(struct wiphy *wiphy, struct net_device *dev,
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
