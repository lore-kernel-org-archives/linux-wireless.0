Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56140 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbZKGUTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:02 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 21/29] ath5k: remove double cache alignment, ath_rxbuf_alloc() already does it
Date: Sat,  7 Nov 2009 15:18:58 -0500
Message-Id: <1257625146-17971-22-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k is using the (csz - 1) twice as ath_rxbuf_alloc() already allocates
and moves skb->data accordingly. Remove the extra (csz -1).

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 31d556a..c7fc13c 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1185,12 +1185,12 @@ struct sk_buff *ath5k_rx_skb_alloc(struct ath5k_softc *sc, dma_addr_t *skb_addr)
 	 * fake physical layer header at the start.
 	 */
 	skb = ath_rxbuf_alloc(common,
-			      common->rx_bufsize + common->cachelsz - 1,
+			      common->rx_bufsize,
 			      GFP_ATOMIC);
 
 	if (!skb) {
 		ATH5K_ERR(sc, "can't alloc skbuff of size %u\n",
-				common->rx_bufsize + common->cachelsz - 1);
+				common->rx_bufsize);
 		return NULL;
 	}
 
-- 
1.6.5.2.143.g8cc62

