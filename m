Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50765 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246Ab2IKPPY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 11:15:24 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: ralf@linux-mips.org, john@phrozen.org
Cc: linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	florian@openwrt.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v4 0/3] MIPS: BCM47xx: use gpiolib
Date: Tue, 11 Sep 2012 17:15:07 +0200
Message-Id: <1347376511-20953-1-git-send-email-hauke@hauke-m.de> (sfid-20120911_171535_574109_4B3E531F)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The original code implemented the GPIO interface itself and this caused
some problems. With this patch gpiolib is used.

This is based on mips/master.

This should go through linux-mips, John W. Linville approved that 
for the bcma and ssb changes normally maintained in wireless-testing.

v4:
 - remove extra BCMA_DRIVER_GPIO option and inline the spinlocks in
   bcma/driver_chipcommon.c.

v3:
 - add missing break after setting bcm47xx_gpio_count in bcm47xx_gpio_init()

v2:
 - use use gpio_chip.to_irq() instead of directly declare gpio_to_irq

Hauke Mehrtens (3):
  ssb: add function to return number of gpio lines
  bcma: add GPIO driver for SoCs
  MIPS: BCM47xx: rewrite GPIO handling and use gpiolib

 arch/mips/Kconfig                            |    2 +-
 arch/mips/bcm47xx/gpio.c                     |  212 ++++++++++++++++++++------
 arch/mips/bcm47xx/setup.c                    |    2 +
 arch/mips/bcm47xx/wgt634u.c                  |    7 +
 arch/mips/include/asm/mach-bcm47xx/bcm47xx.h |    2 +
 arch/mips/include/asm/mach-bcm47xx/gpio.h    |  148 +++---------------
 drivers/bcma/driver_chipcommon.c             |   61 +++++++-
 drivers/ssb/embedded.c                       |   12 ++
 include/linux/bcma/bcma_driver_chipcommon.h  |   24 ++-
 include/linux/ssb/ssb_embedded.h             |    4 +
 10 files changed, 287 insertions(+), 187 deletions(-)

-- 
1.7.9.5

