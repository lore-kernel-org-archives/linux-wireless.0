Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57628 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab0HJROp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 13:14:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ipw2100: avoid warning from pointer cast in call to IPW_DEBUG_TX
Date: Tue, 10 Aug 2010 13:13:58 -0400
Message-Id: <1281460438-3063-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <20100809164346.6e30cf8c.akpm@linux-foundation.org>
References: <20100809164346.6e30cf8c.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/ipw2x00/ipw2100.c: In function 'ipw2100_tx_send_commands':
drivers/net/wireless/ipw2x00/ipw2100.c:3063: warning: cast to pointer from integer of different size

This changes the cast and the conversion to match other usage of the
same value in calls to IPW_DEBUG_TX.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ipw2x00/ipw2100.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index a146240..e4ed479 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -3064,9 +3064,9 @@ static void ipw2100_tx_send_commands(struct ipw2100_priv *priv)
 
 		packet = list_entry(element, struct ipw2100_tx_packet, list);
 
-		IPW_DEBUG_TX("using TBD at virt=%p, phys=%p\n",
+		IPW_DEBUG_TX("using TBD at virt=%p, phys=%04X\n",
 			     &txq->drv[txq->next],
-			     (void *)(txq->nic + txq->next *
+			     (u32) (txq->nic + txq->next *
 				      sizeof(struct ipw2100_bd)));
 
 		packet->index = txq->next;
-- 
1.7.2.1

