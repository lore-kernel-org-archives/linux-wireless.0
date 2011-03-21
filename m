Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:48981 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751438Ab1CUPqs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 11:46:48 -0400
Received: by ewy9 with SMTP id 9so1623141ewy.28
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 08:46:46 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Subject: [PATCH] wl12xx: set the skbuff priority for dummy packets
Date: Mon, 21 Mar 2011 17:46:02 +0200
Message-Id: <1300722362-20624-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware requires dummy packets to be sent using TID 7
(WL1271_TID_MGMT).  Instead of hardcoding it in the tx_fill_hdr()
function, set it when creating the packet itself.

This requires Eliad's fix to set the actual TID in the TX descriptor.

Cc: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 ++
 drivers/net/wireless/wl12xx/tx.c   |    3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 72e84a2..59e0f79 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1243,6 +1243,8 @@ int wl1271_tx_dummy_packet(struct wl1271 *wl)
 	memset(skb->data, 0, TX_DUMMY_PACKET_SIZE);
 
 	skb->pkt_type = TX_PKT_TYPE_DUMMY_REQ;
+	/* Dummy packets require the TID to be management */
+	skb->priority = WL1271_TID_MGMT;
 	/* CONF_TX_AC_VO */
 	skb->queue_mapping = 0;
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index f3031cd..db9e47e 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -235,9 +235,6 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 			   TX_HW_ATTR_SESSION_COUNTER;
 
 		tx_attr |= TX_HW_ATTR_TX_DUMMY_REQ;
-
-		/* Dummy packets require the TID to be management */
-		desc->tid = WL1271_TID_MGMT;
 	} else {
 		/* configure the tx attributes */
 		tx_attr =
-- 
1.7.1

