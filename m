Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36233 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761464Ab3EAPRe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 11:17:34 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/7] rt2x00: rt61pci: use rt2x00dev->tx->limit
Date: Wed,  1 May 2013 17:17:30 +0200
Message-Id: <1367421455-18463-3-git-send-email-juhosg@openwrt.org> (sfid-20130501_171802_549632_EF8BFE2F)
In-Reply-To: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
References: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TX data queue is initialized already when
the rt61pci_txdone() function is called.

Fetch the number of the queue entries from that
instead of using the entry_num field of the data
queue descriptor.

The two values are the same, and the use of the
rt2x00dev->tx->limit value allows us to get rid
of a superfluous pointer dereference.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 0dc8180..7e1759b 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2175,7 +2175,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 	 * that the TX_STA_FIFO stack has a size of 16. We stick to our
 	 * tx ring size for now.
 	 */
-	for (i = 0; i < rt2x00dev->ops->tx->entry_num; i++) {
+	for (i = 0; i < rt2x00dev->tx->limit; i++) {
 		rt2x00mmio_register_read(rt2x00dev, STA_CSR4, &reg);
 		if (!rt2x00_get_field32(reg, STA_CSR4_VALID))
 			break;
-- 
1.7.10

