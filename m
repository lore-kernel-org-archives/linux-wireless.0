Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:47154 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756160Ab2F0PgW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 11:36:22 -0400
Received: by eaae12 with SMTP id e12so532162eaa.26
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 08:36:20 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 3/8] wlcore: don't stop tx queue via watermark if already stopped
Date: Wed, 27 Jun 2012 18:35:57 +0300
Message-Id: <1340811362-30441-4-git-send-email-coelho@ti.com> (sfid-20120627_173626_234115_B310E48D)
In-Reply-To: <1340811362-30441-1-git-send-email-coelho@ti.com>
References: <1340811362-30441-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

If a Tx queue is currently stopped because of our Tx watermark flow
control, don't stop it again. This causes a warning to appear.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 2240cca..1d404fa 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1211,7 +1211,9 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * The workqueue is slow to process the tx_queue and we need stop
 	 * the queue here, otherwise the queue will get too long.
 	 */
-	if (wl->tx_queue_count[q] >= WL1271_TX_QUEUE_HIGH_WATERMARK) {
+	if (wl->tx_queue_count[q] >= WL1271_TX_QUEUE_HIGH_WATERMARK &&
+	    !wlcore_is_queue_stopped_by_reason(wl, q,
+					WLCORE_QUEUE_STOP_REASON_WATERMARK)) {
 		wl1271_debug(DEBUG_TX, "op_tx: stopping queues for q %d", q);
 		wlcore_stop_queue_locked(wl, q,
 					 WLCORE_QUEUE_STOP_REASON_WATERMARK);
-- 
1.7.10

