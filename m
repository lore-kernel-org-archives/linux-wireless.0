Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:53844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbYCIVv3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:51:29 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1676623fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:51:28 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 22/24] rt2x00: Fix RX DMA ring initialization
Date: Sun, 9 Mar 2008 22:48:46 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092248.46660.IvDoorn@gmail.com> (sfid-20080309_215518_537632_FF1D11C5)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to a terrible typo the RX DMA base address
was initialized to the beacon base address.
Obviously bad things happen with bugs like that....

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index e2bb634..a92626b 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -669,7 +669,7 @@ static int rt2400pci_init_queues(struct rt2x00_dev *rt2x00dev)
 
 	priv_rx = rt2x00dev->rx->entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, RXCSR2, &reg);
-	rt2x00_set_field32(&reg, RXCSR2_RX_RING_REGISTER, priv_tx->desc_dma);
+	rt2x00_set_field32(&reg, RXCSR2_RX_RING_REGISTER, priv_rx->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, RXCSR2, reg);
 
 	return 0;
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 4e312cb..4ae09b4 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -751,7 +751,7 @@ static int rt2500pci_init_queues(struct rt2x00_dev *rt2x00dev)
 
 	priv_rx = rt2x00dev->rx->entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, RXCSR2, &reg);
-	rt2x00_set_field32(&reg, RXCSR2_RX_RING_REGISTER, priv_tx->desc_dma);
+	rt2x00_set_field32(&reg, RXCSR2_RX_RING_REGISTER, priv_rx->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, RXCSR2, reg);
 
 	return 0;
-- 
1.5.4.3

