Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:34883 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbcGMLyL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 07:54:11 -0400
From: Yaniv Machani <yanivma@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: Meirav Kama <meiravk@ti.com>, Yaniv Machani <yanivma@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v2] mac80211: rx: frames received out of order
Date: Wed, 13 Jul 2016 14:57:56 +0300
Message-ID: <20160713115758.25395-1-yanivma@ti.com> (sfid-20160713_135419_770394_B76F1024)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meirav Kama <meiravk@ti.com>

Upon forwarding frames from Rx to Tx in mesh, driver clones the skb.
It zeros the tx_info and doesn't set hw_queue correctly. It then enqueues
the frame in queue 0 (VOICE) instead of the correct queue.
Upon re-queue of this frame, driver inserts it to the correct queue (e.g. BE).
After that, driver dequeue frames from 2 different queues and sends them out of order.
To fix this, driver will set the tx_info->hw_queue to the correct queue when cloning the skb.

Signed-off-by: Meirav Kama <meiravk@ti.com>
Signed-off-by: Yaniv Machani <yanivma@ti.com>
---
V2 - Revised comment

 net/mac80211/rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9a1eb70..88dc744 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2392,6 +2392,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 	info->control.vif = &rx->sdata->vif;
 	info->control.jiffies = jiffies;
+	info->hw_queue = q;
 	if (is_multicast_ether_addr(fwd_hdr->addr1)) {
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, fwded_mcast);
 		memcpy(fwd_hdr->addr2, sdata->vif.addr, ETH_ALEN);
-- 
2.9.0

