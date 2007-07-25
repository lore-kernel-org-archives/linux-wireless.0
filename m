Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:55730 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758924AbXGYUsf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 16:48:35 -0400
Received: by ug-out-1314.google.com with SMTP id j3so420021ugf
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 13:48:34 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/11] rt2x00: rt61pci interrupts are called on MCU CMD done
Date: Wed, 25 Jul 2007 22:50:12 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707252250.13016.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 9b5d818acb77b4211623fee6a9000a4d94f8b1ca Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Tue, 24 Jul 2007 14:21:41 +0200
Subject: [PATCH 05/11] rt2x00: rt61pci interrupts are called on MCU CMD done

There 2 reasons for rt61pci interrupts to be triggered,
the first is because the INT_SOURCE_CSR register is set
(beacondone, txdone, rxdone).
But the second reason is the MCU_INT_SOURCE_SRC register,
this is called for completed MCU commands.

Make sure that the interrupt handler only returns IRQ_NONE
when neither of the 2 registers are set. And correctly
handle the MCU_INT_SOURCE_CSR events.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/mac80211/rt2x00/rt61pci.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index c935a43..ad66cc1 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -1857,19 +1857,20 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
+	u32 reg_mcu;
 	u32 reg;
 
 	/*
 	 * Get the interrupt sources & saved to local variable.
 	 * Write register value back to clear pending interrupts.
 	 */
-	rt2x00pci_register_read(rt2x00dev, MCU_INT_SOURCE_CSR, &reg);
-	rt2x00pci_register_write(rt2x00dev, MCU_INT_SOURCE_CSR, reg);
+	rt2x00pci_register_read(rt2x00dev, MCU_INT_SOURCE_CSR, &reg_mcu);
+	rt2x00pci_register_write(rt2x00dev, MCU_INT_SOURCE_CSR, reg_mcu);
 
 	rt2x00pci_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
 	rt2x00pci_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
 
-	if (!reg)
+	if (!reg && !reg_mcu)
 		return IRQ_NONE;
 
 	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
@@ -1899,6 +1900,13 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TXDONE))
 		rt61pci_txdone(rt2x00dev);
 
+	/*
+	 * 4 - Handle MCU command done.
+	 */
+	if (reg_mcu)
+		rt2x00pci_register_write(rt2x00dev,
+			M2H_CMD_DONE_CSR, 0xffffffff);
+
 	return IRQ_HANDLED;
 }
 
-- 
1.5.2.2

