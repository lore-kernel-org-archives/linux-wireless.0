Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from forward16.mail.yandex.net ([95.108.253.141]:32958 "EHLO
	forward16.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3JAUkv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 16:40:51 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-wireless@vger.kernel.org
Cc: ivdoorn@gmail.com, gwingerde@gmail.com, helmut.schaa@googlemail.com
Subject: [PATCH] rt2x00_pci: Fix interrupt handler name (visible at /proc/interrupts)
MIME-Version: 1.0
Message-Id: <459361380660046@web2g.yandex.ru> (sfid-20131001_224055_160879_F4B230B2)
Date: Wed, 02 Oct 2013 00:40:46 +0400
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently driver name is wrong. PCI device address is visible at
/proc/interrupts instead of the name:

 43:    124      0      0      0   PCI-MSI-edge    rtsx_pci
 44:    384      0      0      0   PCI-MSI-edge    snd_hda_intel
 45:  25096      0      0      0   PCI-MSI-edge    0000:01:00.0
                                                   ^^^^^^^^^^^^

So, pass the right name. rt2x00_ops->name contains KBUILD_MODNAME
and good for that, so pass it.

Handler names will be "rt2500pci", "rt2500pci" etc.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Ivo van Doorn <IvDoorn@gmail.com>
CC: Gertjan van Wingerde <gwingerde@gmail.com>
CC: Helmut Schaa <helmut.schaa@googlemail.com>
CC: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/rt2x00/rt2x00pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 76d95de..6c5d667 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -121,7 +121,7 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct rt2x00_ops *ops)
 	rt2x00dev->ops = ops;
 	rt2x00dev->hw = hw;
 	rt2x00dev->irq = pci_dev->irq;
-	rt2x00dev->name = pci_name(pci_dev);
+	rt2x00dev->name = ops->name;
 
 	if (pci_is_pcie(pci_dev))
 		rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCIE);
