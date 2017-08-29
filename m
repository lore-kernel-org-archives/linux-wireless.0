Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0068.outbound.protection.outlook.com ([104.47.41.68]:41312
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753323AbdH2MRM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 08:17:12 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 4/5] qtnfmac: fix free_xfer_buffer cleanup
Date: Tue, 29 Aug 2017 15:16:22 +0300
Message-Id: <20170829121623.24761-5-sergey.matyukevich.os@quantenna.com> (sfid-20170829_141718_099473_1317E01F)
In-Reply-To: <20170829121623.24761-1-sergey.matyukevich.os@quantenna.com>
References: <20170829121623.24761-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check if skb tracking arrays has been already allocated. This additional
check handles the case when init partially failed.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index bfbcd0bf75bf..2921d8069bf2 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -483,7 +483,7 @@ static void free_xfer_buffers(void *data)
 
 	/* free rx buffers */
 	for (i = 0; i < priv->rx_bd_num; i++) {
-		if (priv->rx_skb[i]) {
+		if (priv->rx_skb && priv->rx_skb[i]) {
 			rxbd = &priv->rx_bd_vbase[i];
 			paddr = QTN_HOST_ADDR(le32_to_cpu(rxbd->addr_h),
 					      le32_to_cpu(rxbd->addr));
@@ -496,7 +496,7 @@ static void free_xfer_buffers(void *data)
 
 	/* free tx buffers */
 	for (i = 0; i < priv->tx_bd_num; i++) {
-		if (priv->tx_skb[i]) {
+		if (priv->tx_skb && priv->tx_skb[i]) {
 			dev_kfree_skb_any(priv->tx_skb[i]);
 			priv->tx_skb[i] = NULL;
 		}
-- 
2.11.0
