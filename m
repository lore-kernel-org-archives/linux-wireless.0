Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0083.outbound.protection.outlook.com ([104.47.38.83]:62976
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751161AbeAVMrO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 07:47:14 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: [PATCH 10/11] qtnfmac: do not use bus mutex for events processing
Date: Mon, 22 Jan 2018 15:46:33 +0300
Message-Id: <20180122124634.8430-11-sergey.matyukevich.os@quantenna.com> (sfid-20180122_134719_623326_37896A4F)
In-Reply-To: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
References: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Events processing requires locking of bus mutex, which is also used by
cfg80211 layer before calling several of cfg80211 callbacks. Since all
cfg80211 callbacks in qtnfmac driver also lock bus mutex, this
potentially may lead to a deadlock.

Do not use bus lock for event processing. Use RTNL lock instead to
serialize events and commands processing threads.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/event.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index 8a3d2b1194e4..bcd415f96412 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -541,9 +541,9 @@ static int qtnf_event_process_skb(struct qtnf_bus *bus,
 	if (unlikely(!mac))
 		return -ENXIO;
 
-	qtnf_bus_lock(bus);
+	rtnl_lock();
 	res = qtnf_event_parse(mac, skb);
-	qtnf_bus_unlock(bus);
+	rtnl_unlock();
 
 	return res;
 }
-- 
2.11.0
