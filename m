Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36123 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab0IHS6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 14:58:15 -0400
Received: by mail-ew0-f46.google.com with SMTP id 23so343042ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 11:58:14 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/06] rt2x00: Mask out unused interrupts in rt2800pci
Date: Wed, 8 Sep 2010 20:56:52 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201009082055.38033.IvDoorn@gmail.com> <201009082056.05708.IvDoorn@gmail.com> <201009082056.33182.IvDoorn@gmail.com>
In-Reply-To: <201009082056.33182.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009082056.53759.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

We don't use all available interrupts in rt2800pci. Mask out all unused
interrupts to avoid waking up without having anything to do.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 2bcb150..005ee15 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -342,24 +342,24 @@ static void rt2800pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	}
 
 	rt2800_register_read(rt2x00dev, INT_MASK_CSR, &reg);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_RXDELAYINT, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_TXDELAYINT, mask);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_RXDELAYINT, 0);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_TXDELAYINT, 0);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_RX_DONE, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_AC0_DMA_DONE, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_AC1_DMA_DONE, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_AC2_DMA_DONE, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_AC3_DMA_DONE, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_HCCA_DMA_DONE, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_MGMT_DMA_DONE, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_MCU_COMMAND, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_RXTX_COHERENT, mask);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_AC0_DMA_DONE, 0);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_AC1_DMA_DONE, 0);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_AC2_DMA_DONE, 0);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_AC3_DMA_DONE, 0);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_HCCA_DMA_DONE, 0);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_MGMT_DMA_DONE, 0);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_MCU_COMMAND, 0);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_RXTX_COHERENT, 0);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_TBTT, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_PRE_TBTT, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_TX_FIFO_STATUS, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_AUTO_WAKEUP, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_GPTIMER, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_RX_COHERENT, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_TX_COHERENT, mask);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_GPTIMER, 0);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_RX_COHERENT, 0);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_TX_COHERENT, 0);
 	rt2800_register_write(rt2x00dev, INT_MASK_CSR, reg);
 }
 
-- 
1.7.2.2

