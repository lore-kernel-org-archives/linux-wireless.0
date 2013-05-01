Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36240 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761457Ab3EAPRe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 11:17:34 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 3/7] rt2x00: rt2800pci: use rt2x00dev->tx->limit
Date: Wed,  1 May 2013 17:17:31 +0200
Message-Id: <1367421455-18463-4-git-send-email-juhosg@openwrt.org> (sfid-20130501_171826_599358_51F090D2)
In-Reply-To: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
References: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TX data queue is initialized already when
the rt2800pci_txstatus_interrupt() function is
called.

Fetch the number of the queue entries from that
instead of using the entry_num field of the data
queue descriptor.

The two values are the same, and the use of the
rt2x00dev->tx->limit value allows us to get rid
of a superfluous pointer dereference.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 6f4a861..330f1d2 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1014,7 +1014,7 @@ static void rt2800pci_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
 	 * Since we have only one producer and one consumer we don't
 	 * need to lock the kfifo.
 	 */
-	for (i = 0; i < rt2x00dev->ops->tx->entry_num; i++) {
+	for (i = 0; i < rt2x00dev->tx->limit; i++) {
 		rt2x00mmio_register_read(rt2x00dev, TX_STA_FIFO, &status);
 
 		if (!rt2x00_get_field32(status, TX_STA_FIFO_VALID))
-- 
1.7.10

