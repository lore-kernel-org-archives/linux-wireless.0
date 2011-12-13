Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59435 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab1LMNZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 08:25:59 -0500
Received: by vbbfc26 with SMTP id fc26so4636272vbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Dec 2011 05:25:58 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] wl12xx: use ieee80211_free_txskb()
Date: Tue, 13 Dec 2011 15:26:38 +0200
Message-Id: <1323782798-16811-1-git-send-email-eliad@wizery.com> (sfid-20111213_142602_262323_FF827B9D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the newly introduced ieee80211_free_txskb() instead
of dev_kfree_skb() for failed tx packets.

Additionally, if the skb is a dummy packet, re-enqueue
it (as the fw expects it) instead of freeing it.

Reported-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: handle dummy packets (thanks Arik)

 drivers/net/wireless/wl12xx/main.c |    2 +-
 drivers/net/wireless/wl12xx/tx.c   |    9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 2a0fb86..22106a6 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1532,7 +1532,7 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (hlid == WL12XX_INVALID_LINK_ID ||
 	    (wlvif && !test_bit(hlid, wlvif->links_map))) {
 		wl1271_debug(DEBUG_TX, "DROP skb hlid %d q %d", hlid, q);
-		dev_kfree_skb(skb);
+		ieee80211_free_txskb(hw, skb);
 		goto out;
 	}
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index df20e12..431b2f8 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -749,7 +749,14 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 			set_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags);
 			goto out_ack;
 		} else if (ret < 0) {
-			dev_kfree_skb(skb);
+			if (wl12xx_is_dummy_packet(wl, skb))
+				/*
+				 * fw still expects dummy packet,
+				 * so re-enqueue it
+				 */
+				wl1271_skb_queue_head(wl, wlvif, skb);
+			else
+				ieee80211_free_txskb(wl->hw, skb);
 			goto out_ack;
 		}
 		buf_offset += ret;
-- 
1.7.6.401.g6a319

