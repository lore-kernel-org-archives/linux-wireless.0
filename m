Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38069 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbXLJR3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:29:42 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 09/48] libertas: Don't claim to have checksummed incoming packets.
Message-Id: <E1J1kpD-0006kq-Hw@shinybook.infradead.org> (sfid-20071210_172951_155817_869C9C39)
Date: Mon, 10 Dec 2007 10:45:43 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Thu, 6 Dec 2007 10:36:08 +0000

This explains why we never noticed the corruption of checksums on
outgoing packets... we weren't actually checking them either.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
index fa467df..a252a8f 100644
--- a/drivers/net/wireless/libertas/rx.c
+++ b/drivers/net/wireless/libertas/rx.c
@@ -147,7 +147,7 @@ void lbs_upload_rx_packet(struct lbs_private *priv, struct sk_buff *skb)
 		else
 			skb->protocol = eth_type_trans(skb, priv->dev);
 	}
-	skb->ip_summed = CHECKSUM_UNNECESSARY;
+	skb->ip_summed = CHECKSUM_NONE;
 	netif_rx(skb);
 }
 
-- 
1.5.3.4

