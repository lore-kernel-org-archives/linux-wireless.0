Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:46659 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbaKAPzF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2014 11:55:05 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: zajec5@gmail.com, arnd@arndb.de, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v7 0/2] bcma: get IRQs also from device tree
Date: Sat,  1 Nov 2014 16:54:54 +0100
Message-Id: <1414857296-1287-1-git-send-email-hauke@hauke-m.de> (sfid-20141101_165516_538654_628FB42C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches make it possible to get the IRQ from device tree.
The second patch was already posted on the mailing list some time ago, 
but did not made it into 3.18. I removed the stuff a little bit. Now a 
driver can use bcma_core_irq() to get a specific IRQ from bcma by 
proving an index.

Hauke Mehrtens (2):
  bcma: make it possible to specify a IRQ num in bcma_core_irq()
  bcma: get IRQ numbers from dt

 Documentation/devicetree/bindings/bus/bcma.txt | 21 ++++++++
 drivers/bcma/driver_chipcommon.c               |  2 +-
 drivers/bcma/driver_gpio.c                     |  4 +-
 drivers/bcma/driver_mips.c                     | 11 +---
 drivers/bcma/driver_pci_host.c                 |  4 +-
 drivers/bcma/main.c                            | 72 ++++++++++++++++++++++++++
 include/linux/bcma/bcma.h                      |  2 +
 include/linux/bcma/bcma_driver_mips.h          |  4 +-
 8 files changed, 104 insertions(+), 16 deletions(-)

-- 
1.9.1

