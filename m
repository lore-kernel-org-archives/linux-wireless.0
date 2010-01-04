Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:52794 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab0ADUy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 15:54:27 -0500
Date: Mon, 4 Jan 2010 21:54:25 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 03/14] mwl8k: make the tx ring drain status messages somewhat more friendly
Message-ID: <20100104205423.GC1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Old:
> phy0: timeout waiting for tx rings to drain (9 -> 5 pkts), retrying
> phy0: timeout waiting for tx rings to drain (5 -> 2 pkts), retrying
> phy0: tx rings drained

New:
> phy0: waiting for tx rings to drain (9 -> 5 pkts)
> phy0: waiting for tx rings to drain (5 -> 2 pkts)
> phy0: tx rings drained

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 418880e..eb9e71d 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1269,8 +1269,8 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 		}
 
 		if (priv->pending_tx_pkts < oldcount) {
-			printk(KERN_NOTICE "%s: timeout waiting for tx "
-			       "rings to drain (%d -> %d pkts), retrying\n",
+			printk(KERN_NOTICE "%s: waiting for tx rings "
+			       "to drain (%d -> %d pkts)\n",
 			       wiphy_name(hw->wiphy), oldcount,
 			       priv->pending_tx_pkts);
 			retry = 1;
-- 
1.5.6.4
