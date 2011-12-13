Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51781 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab1LML0p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 06:26:45 -0500
Received: by qcqz2 with SMTP id z2so4323362qcq.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Dec 2011 03:26:44 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: use ieee80211_free_txskb()
Date: Tue, 13 Dec 2011 13:27:23 +0200
Message-Id: <1323775643-6018-1-git-send-email-eliad@wizery.com> (sfid-20111213_122648_976408_94DB1C9B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the newly introduced ieee80211_free_txskb() instead
of dev_kfree_skb() for failed tx packets.

Reported-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 +-
 drivers/net/wireless/wl12xx/tx.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 2f7bfa8..333bc29 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1448,7 +1448,7 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (hlid == WL12XX_INVALID_LINK_ID ||
 	    (wlvif && !test_bit(hlid, wlvif->links_map))) {
 		wl1271_debug(DEBUG_TX, "DROP skb hlid %d q %d", hlid, q);
-		dev_kfree_skb(skb);
+		ieee80211_free_txskb(hw, skb);
 		goto out;
 	}
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 36eb0d6..fe62f21 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -740,7 +740,7 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 			set_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags);
 			goto out_ack;
 		} else if (ret < 0) {
-			dev_kfree_skb(skb);
+			ieee80211_free_txskb(wl->hw, skb);
 			goto out_ack;
 		}
 		buf_offset += ret;
-- 
1.7.6.401.g6a319

