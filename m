Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:62574 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351Ab3HMMZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 08:25:54 -0400
Cc: Kirshenbaum Erez <erezk@wilocity.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	<wil6210@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH] wil6210: let IP stack re-check HW TCP/UDP csum errors
Date: Tue, 13 Aug 2013 15:25:32 +0300
Message-ID: <1376396732-26632-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130813_142556_981908_40AB5FB9)
In-Reply-To: <1376396732-26632-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1376396732-26632-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix for TCP iperf from Windows to Linux stall after about 1sec

Hardware reports false errors in some situations:

Microsoft IP stack, in violation of RFC 1624, set TCP checksum that should be 0x0
as 0xffff. hardware report Rx csum error. If HW csum absolutely trusted,
this frame can be never received, as re-transmitted one will have same csum problem.
In addition, it mess up block ack reorder buffer, as if packet dropped, it is not score boarded
there.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index ea1abeb..d505b26 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -416,13 +416,13 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	 */
 	if (d->dma.status & RX_DMA_STATUS_L4_IDENT) {
 		/* L4 protocol identified, csum calculated */
-		if ((d->dma.error & RX_DMA_ERROR_L4_ERR) == 0) {
+		if ((d->dma.error & RX_DMA_ERROR_L4_ERR) == 0)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
-		} else {
-			wil_err(wil, "Incorrect checksum reported\n");
-			kfree_skb(skb);
-			return NULL;
-		}
+		/* If HW reports bad checksum, let IP stack re-check it
+		 * For example, HW don't understand Microsoft IP stack that
+		 * mis-calculates TCP checksum - if it should be 0x0,
+		 * it writes 0xffff in violation of RFC 1624
+		 */
 	}
 
 	ds_bits = wil_rxdesc_ds_bits(d);
-- 
1.8.1.2

