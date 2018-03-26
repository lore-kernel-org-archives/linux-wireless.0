Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0060.outbound.protection.outlook.com ([104.47.32.60]:20425
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751374AbeCZNgv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 09:36:51 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>,
        Dmitry Lebed <lebed.dmitry@gmail.com>
Subject: [PATCH 1/3] cfg80211: fix CAC_STARTED event handling
Date: Mon, 26 Mar 2018 16:36:31 +0300
Message-Id: <20180326133633.8771-2-sergey.matyukevich.os@quantenna.com> (sfid-20180326_153656_256809_9984F89C)
In-Reply-To: <20180326133633.8771-1-sergey.matyukevich.os@quantenna.com>
References: <20180326133633.8771-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dmitry Lebed <dlebed@quantenna.com>

Exclude CAC_STARTED event from !wdev->cac_started check,
since cac_started will be set later in the same function.

Signed-off-by: Dmitry Lebed <dlebed@quantenna.com>
---
 net/wireless/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 6b6818dd76bd..12b3edf70a7b 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -872,7 +872,7 @@ void cfg80211_cac_event(struct net_device *netdev,
 
 	trace_cfg80211_cac_event(netdev, event);
 
-	if (WARN_ON(!wdev->cac_started))
+	if (WARN_ON(!wdev->cac_started && event != NL80211_RADAR_CAC_STARTED))
 		return;
 
 	if (WARN_ON(!wdev->chandef.chan))
-- 
2.11.0
