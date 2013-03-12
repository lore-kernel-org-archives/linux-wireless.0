Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:59621 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468Ab3CLNpu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 09:45:50 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 13/13] wlcore: consider dummy packets when tx queues are empty
Date: Tue, 12 Mar 2013 15:44:24 +0200
Message-ID: <1363095864-24422-14-git-send-email-coelho@ti.com> (sfid-20130312_151303_384996_6B32B9F3)
In-Reply-To: <1363095864-24422-1-git-send-email-coelho@ti.com>
References: <1363095864-24422-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Don't ignore dummy packets when our queues are empty. This causes dummy
packets never to be sent when traffic is not suspended by FW thresholds,
which happens only in high Tx throughput situations. This may hurt Rx
performance.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 85003c0..004d02e 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -644,6 +644,7 @@ next:
 
 	}
 
+out:
 	if (!skb &&
 	    test_and_clear_bit(WL1271_FLAG_DUMMY_PACKET_PENDING, &wl->flags)) {
 		int q;
@@ -657,7 +658,6 @@ next:
 		spin_unlock_irqrestore(&wl->wl_lock, flags);
 	}
 
-out:
 	return skb;
 }
 
-- 
1.7.10.4

