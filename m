Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab1KPM5E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 07:57:04 -0500
Date: Wed, 16 Nov 2011 13:58:42 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] rt2x00: handle spurious pci interrupts
Message-ID: <20111116125841.GB4409@redhat.com> (sfid-20111116_135708_044139_76C0762B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have documented case of very bad performance issue on rt2800pci
device, because it generate spurious interrupt, what cause irq line
is disabled: https://bugzilla.redhat.com/show_bug.cgi?id=658451

We already address that problem in separate patch by returning
IRQ_HANDLED from interrupt handler. We think similar fix is needed for
other rt2x00 PCI devices, because users report performance problems on
these devices too.

Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 3a6b402..676c765 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1380,7 +1380,7 @@ static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
 	rt2x00pci_register_write(rt2x00dev, CSR7, reg);
 
 	if (!reg)
-		return IRQ_NONE;
+		return IRQ_HANDLED;
 
 	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		return IRQ_HANDLED;
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index dcc0e1f..d0b627c 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1512,7 +1512,7 @@ static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
 	rt2x00pci_register_write(rt2x00dev, CSR7, reg);
 
 	if (!reg)
-		return IRQ_NONE;
+		return IRQ_HANDLED;
 
 	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		return IRQ_HANDLED;
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index bf55b4a..9d83e70 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2337,7 +2337,7 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 	rt2x00pci_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
 
 	if (!reg && !reg_mcu)
-		return IRQ_NONE;
+		return IRQ_HANDLED;
 
 	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		return IRQ_HANDLED;
-- 
1.7.1

