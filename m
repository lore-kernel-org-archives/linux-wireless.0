Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:47397 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbZHCT60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:58:26 -0400
Date: Mon, 3 Aug 2009 21:58:26 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: nico@cam.org
Subject: [PATCH 1/5] mwl8k: fix NULL pointer dereference on receive out-of-memory
Message-ID: <20090803195826.GH18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we go into out-of-memory and fail to allocate skbuffs to
refill the receive ring with, rxq_process can end up running into
a receive ring entry that is marked as host-owned but doesn't have
an associated skbuff.  If this happens, we must break out of the
rx processing loop instead of trying to process the descriptor.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
Acked-by: Nicolas Pitre <nico@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index a9a9704..f437fab 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1012,6 +1012,8 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 		rmb();
 
 		skb = rxq->rx_skb[rxq->rx_head];
+		if (skb == NULL)
+			break;
 		rxq->rx_skb[rxq->rx_head] = NULL;
 
 		rxq->rx_head = (rxq->rx_head + 1) % MWL8K_RX_DESCS;
-- 
1.5.6.4
