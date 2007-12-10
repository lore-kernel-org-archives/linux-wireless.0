Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55300 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239AbXLJPqU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:46:20 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 42/48] libertas: free successfully transmitted skbs again
Message-Id: <E1J1kpm-0006nV-AV@shinybook.infradead.org> (sfid-20071210_154641_569859_A41F6152)
Date: Mon, 10 Dec 2007 10:46:18 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sun, 9 Dec 2007 22:02:46 -0500

I was so busy cleaning up the failure modes that I accidentally forgot
to make sure we still free them in the success case. Oops.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/tx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index c2881a9..300aa05 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -161,7 +161,9 @@ int lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 			/* Keep the skb around for when we get feedback */
 			priv->currenttxskb = skb;
-		}
+		} else
+			dev_kfree_skb_any(skb);
+		
 	}
 	
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
-- 
1.5.3.4

