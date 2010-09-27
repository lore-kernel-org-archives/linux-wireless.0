Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17152 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab0I0Ijq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:39:46 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8deIl026986
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 03:39:45 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 17/25] wl1271: Fix tid-configuration of TX frames
Date: Mon, 27 Sep 2010 11:37:41 +0300
Message-Id: <1285576669-8070-18-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Incorrect TID was configured for TX frames. This resulted in incorrect
queues to be used for classes in transmission.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_tx.c |    4 ++--
 drivers/net/wireless/wl12xx/wl1271_tx.h |   17 -----------------
 2 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 0f99eff..1b8295c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -110,9 +110,9 @@ static int wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	/* configure the tx attributes */
 	tx_attr = wl->session_counter << TX_HW_ATTR_OFST_SESSION_COUNTER;
 
-	/* queue */
+	/* queue (we use same identifiers for tid's and ac's */
 	ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
-	desc->tid = wl1271_tx_ac_to_tid(ac);
+	desc->tid = ac;
 
 	desc->aid = TX_HW_DEFAULT_AID;
 	desc->reserved = 0;
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.h b/drivers/net/wireless/wl12xx/wl1271_tx.h
index 48bf926..d12a129 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.h
@@ -139,23 +139,6 @@ static inline int wl1271_tx_get_queue(int queue)
 	}
 }
 
-/* wl1271 tx descriptor needs the tid and we need to convert it from ac */
-static inline int wl1271_tx_ac_to_tid(int ac)
-{
-	switch (ac) {
-	case 0:
-		return 0;
-	case 1:
-		return 2;
-	case 2:
-		return 4;
-	case 3:
-		return 6;
-	default:
-		return 0;
-	}
-}
-
 void wl1271_tx_work(struct work_struct *work);
 void wl1271_tx_complete(struct wl1271 *wl);
 void wl1271_tx_reset(struct wl1271 *wl);
-- 
1.6.3.3

