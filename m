Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61469 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab1CPVEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 17:04:04 -0400
Received: by fxm17 with SMTP id 17so2106861fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 14:04:03 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: set the actual tid instead of the ac
Date: Wed, 16 Mar 2011 23:03:54 +0200
Message-Id: <1300309434-15491-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When passing a tx frame, the driver incorrectly set desc->tid
with the ac instead of the actual tid.

It has some serious implications when using 802.11n + QoS,
as the fw starts a BlockAck with the wrong tid (which finally
cause beacon loss and disconnection / some fw crash)

Fix it by using the actual tid stored in skb->priority.

Reported-by: Shahar Levi <shahar_levi@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/tx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 5e9ef7d..4bb3d99 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -205,9 +205,9 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	/* configure the tx attributes */
 	tx_attr = wl->session_counter << TX_HW_ATTR_OFST_SESSION_COUNTER;
 
-	/* queue (we use same identifiers for tid's and ac's */
+	/* queue */
 	ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
-	desc->tid = ac;
+	desc->tid = skb->priority;
 
 	if (wl->bss_type != BSS_TYPE_AP_BSS) {
 		desc->aid = hlid;
-- 
1.7.0.4

