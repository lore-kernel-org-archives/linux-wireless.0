Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35605 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758699Ab1CCStI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 13:49:08 -0500
Received: by mail-wy0-f174.google.com with SMTP id 36so1356532wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 10:49:08 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 14/19] rt2x00: Revise irqmask locking for PCI devices
Date: Thu, 3 Mar 2011 19:45:16 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103031938.56423.IvDoorn@gmail.com> <201103031944.33950.IvDoorn@gmail.com> <201103031944.54527.IvDoorn@gmail.com>
In-Reply-To: <201103031944.54527.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103031945.17614.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

The PCI device irqmask is locked by a spin_lock. Currently
spin_lock_irqsave is used everywhere. To reduce the locking overhead
replace spin_lock_irqsave in hard irq context with spin_lock and in
soft irq context with spin_lock_irq.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |   15 ++++++---------
 drivers/net/wireless/rt2x00/rt2500pci.c |   15 ++++++---------
 drivers/net/wireless/rt2x00/rt2800pci.c |   10 ++++------
 drivers/net/wireless/rt2x00/rt61pci.c   |   15 ++++++---------
 4 files changed, 22 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 9016c00..80f4988 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1317,27 +1317,25 @@ static void rt2400pci_txdone(struct rt2x00_dev *rt2x00dev,
 static void rt2400pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
 				       struct rt2x00_field32 irq_field)
 {
-	unsigned long flags;
 	u32 reg;
 
 	/*
 	 * Enable a single interrupt. The interrupt mask register
 	 * access needs locking.
 	 */
-	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
+	spin_lock_irq(&rt2x00dev->irqmask_lock);
 
 	rt2x00pci_register_read(rt2x00dev, CSR8, &reg);
 	rt2x00_set_field32(&reg, irq_field, 0);
 	rt2x00pci_register_write(rt2x00dev, CSR8, reg);
 
-	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+	spin_unlock_irq(&rt2x00dev->irqmask_lock);
 }
 
 static void rt2400pci_txstatus_tasklet(unsigned long data)
 {
 	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
 	u32 reg;
-	unsigned long flags;
 
 	/*
 	 * Handle all tx queues.
@@ -1349,7 +1347,7 @@ static void rt2400pci_txstatus_tasklet(unsigned long data)
 	/*
 	 * Enable all TXDONE interrupts again.
 	 */
-	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
+	spin_lock_irq(&rt2x00dev->irqmask_lock);
 
 	rt2x00pci_register_read(rt2x00dev, CSR8, &reg);
 	rt2x00_set_field32(&reg, CSR8_TXDONE_TXRING, 0);
@@ -1357,7 +1355,7 @@ static void rt2400pci_txstatus_tasklet(unsigned long data)
 	rt2x00_set_field32(&reg, CSR8_TXDONE_PRIORING, 0);
 	rt2x00pci_register_write(rt2x00dev, CSR8, reg);
 
-	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+	spin_unlock_irq(&rt2x00dev->irqmask_lock);
 }
 
 static void rt2400pci_tbtt_tasklet(unsigned long data)
@@ -1378,7 +1376,6 @@ static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
 	u32 reg, mask;
-	unsigned long flags;
 
 	/*
 	 * Get the interrupt sources & saved to local variable.
@@ -1420,13 +1417,13 @@ static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
 	 * Disable all interrupts for which a tasklet was scheduled right now,
 	 * the tasklet will reenable the appropriate interrupts.
 	 */
-	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
+	spin_lock(&rt2x00dev->irqmask_lock);
 
 	rt2x00pci_register_read(rt2x00dev, CSR8, &reg);
 	reg |= mask;
 	rt2x00pci_register_write(rt2x00dev, CSR8, reg);
 
-	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+	spin_unlock(&rt2x00dev->irqmask_lock);
 
 
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 0fbc18c..635f804 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1449,27 +1449,25 @@ static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev,
 static void rt2500pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
 				       struct rt2x00_field32 irq_field)
 {
-	unsigned long flags;
 	u32 reg;
 
 	/*
 	 * Enable a single interrupt. The interrupt mask register
 	 * access needs locking.
 	 */
-	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
+	spin_lock_irq(&rt2x00dev->irqmask_lock);
 
 	rt2x00pci_register_read(rt2x00dev, CSR8, &reg);
 	rt2x00_set_field32(&reg, irq_field, 0);
 	rt2x00pci_register_write(rt2x00dev, CSR8, reg);
 
-	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+	spin_unlock_irq(&rt2x00dev->irqmask_lock);
 }
 
 static void rt2500pci_txstatus_tasklet(unsigned long data)
 {
 	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
 	u32 reg;
-	unsigned long flags;
 
 	/*
 	 * Handle all tx queues.
@@ -1481,7 +1479,7 @@ static void rt2500pci_txstatus_tasklet(unsigned long data)
 	/*
 	 * Enable all TXDONE interrupts again.
 	 */
-	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
+	spin_lock_irq(&rt2x00dev->irqmask_lock);
 
 	rt2x00pci_register_read(rt2x00dev, CSR8, &reg);
 	rt2x00_set_field32(&reg, CSR8_TXDONE_TXRING, 0);
@@ -1489,7 +1487,7 @@ static void rt2500pci_txstatus_tasklet(unsigned long data)
 	rt2x00_set_field32(&reg, CSR8_TXDONE_PRIORING, 0);
 	rt2x00pci_register_write(rt2x00dev, CSR8, reg);
 
-	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+	spin_unlock_irq(&rt2x00dev->irqmask_lock);
 }
 
 static void rt2500pci_tbtt_tasklet(unsigned long data)
@@ -1510,7 +1508,6 @@ static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
 	u32 reg, mask;
-	unsigned long flags;
 
 	/*
 	 * Get the interrupt sources & saved to local variable.
@@ -1552,13 +1549,13 @@ static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
 	 * Disable all interrupts for which a tasklet was scheduled right now,
 	 * the tasklet will reenable the appropriate interrupts.
 	 */
-	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
+	spin_lock(&rt2x00dev->irqmask_lock);
 
 	rt2x00pci_register_read(rt2x00dev, CSR8, &reg);
 	reg |= mask;
 	rt2x00pci_register_write(rt2x00dev, CSR8, reg);
 
-	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+	spin_unlock(&rt2x00dev->irqmask_lock);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 1b5753b..7e610f6 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -765,18 +765,17 @@ static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 static void rt2800pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
 				       struct rt2x00_field32 irq_field)
 {
-	unsigned long flags;
 	u32 reg;
 
 	/*
 	 * Enable a single interrupt. The interrupt mask register
 	 * access needs locking.
 	 */
-	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
+	spin_lock_irq(&rt2x00dev->irqmask_lock);
 	rt2800_register_read(rt2x00dev, INT_MASK_CSR, &reg);
 	rt2x00_set_field32(&reg, irq_field, 1);
 	rt2800_register_write(rt2x00dev, INT_MASK_CSR, reg);
-	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+	spin_unlock_irq(&rt2x00dev->irqmask_lock);
 }
 
 static void rt2800pci_txstatus_tasklet(unsigned long data)
@@ -862,7 +861,6 @@ static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
 	u32 reg, mask;
-	unsigned long flags;
 
 	/* Read status and ACK all interrupts */
 	rt2800_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
@@ -905,11 +903,11 @@ static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
 	 * Disable all interrupts for which a tasklet was scheduled right now,
 	 * the tasklet will reenable the appropriate interrupts.
 	 */
-	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
+	spin_lock(&rt2x00dev->irqmask_lock);
 	rt2800_register_read(rt2x00dev, INT_MASK_CSR, &reg);
 	reg &= mask;
 	rt2800_register_write(rt2x00dev, INT_MASK_CSR, reg);
-	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+	spin_unlock(&rt2x00dev->irqmask_lock);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 1eb59ee..86eba7f 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2255,39 +2255,37 @@ static void rt61pci_wakeup(struct rt2x00_dev *rt2x00dev)
 static void rt61pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
 				     struct rt2x00_field32 irq_field)
 {
-	unsigned long flags;
 	u32 reg;
 
 	/*
 	 * Enable a single interrupt. The interrupt mask register
 	 * access needs locking.
 	 */
-	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
+	spin_lock_irq(&rt2x00dev->irqmask_lock);
 
 	rt2x00pci_register_read(rt2x00dev, INT_MASK_CSR, &reg);
 	rt2x00_set_field32(&reg, irq_field, 0);
 	rt2x00pci_register_write(rt2x00dev, INT_MASK_CSR, reg);
 
-	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+	spin_unlock_irq(&rt2x00dev->irqmask_lock);
 }
 
 static void rt61pci_enable_mcu_interrupt(struct rt2x00_dev *rt2x00dev,
 					 struct rt2x00_field32 irq_field)
 {
-	unsigned long flags;
 	u32 reg;
 
 	/*
 	 * Enable a single MCU interrupt. The interrupt mask register
 	 * access needs locking.
 	 */
-	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
+	spin_lock_irq(&rt2x00dev->irqmask_lock);
 
 	rt2x00pci_register_read(rt2x00dev, MCU_INT_MASK_CSR, &reg);
 	rt2x00_set_field32(&reg, irq_field, 0);
 	rt2x00pci_register_write(rt2x00dev, MCU_INT_MASK_CSR, reg);
 
-	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+	spin_unlock_irq(&rt2x00dev->irqmask_lock);
 }
 
 static void rt61pci_txstatus_tasklet(unsigned long data)
@@ -2325,7 +2323,6 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 	struct rt2x00_dev *rt2x00dev = dev_instance;
 	u32 reg_mcu, mask_mcu;
 	u32 reg, mask;
-	unsigned long flags;
 
 	/*
 	 * Get the interrupt sources & saved to local variable.
@@ -2370,7 +2367,7 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 	 * Disable all interrupts for which a tasklet was scheduled right now,
 	 * the tasklet will reenable the appropriate interrupts.
 	 */
-	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
+	spin_lock(&rt2x00dev->irqmask_lock);
 
 	rt2x00pci_register_read(rt2x00dev, INT_MASK_CSR, &reg);
 	reg |= mask;
@@ -2380,7 +2377,7 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 	reg |= mask_mcu;
 	rt2x00pci_register_write(rt2x00dev, MCU_INT_MASK_CSR, reg);
 
-	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+	spin_unlock(&rt2x00dev->irqmask_lock);
 
 	return IRQ_HANDLED;
 }
-- 
1.7.2.3

