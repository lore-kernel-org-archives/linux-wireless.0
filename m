Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51402 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab2KSW6b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 17:58:31 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: john@phrozen.org, ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	florian@openwrt.org, zajec5@gmail.com, m@bues.ch,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/8] bcma/ssb/BCM47XX: add GPIO driver to ssb/bcma
Date: Mon, 19 Nov 2012 23:57:49 +0100
Message-Id: <1353365877-11131-1-git-send-email-hauke@hauke-m.de> (sfid-20121119_235834_624857_1863C729)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a complete rewrote of the original patch "MIPS: BCM47xx: use 
gpiolib"
Instead of providing the GPIO driver in the arch code it is now moved 
into ssb and bcma and could also be used by other systems. The GPIO 
functions in drivers/ssb/embedded.c are still used by arch/mips/bcm47xx
/wgt634u.c, but I am planing to write some code for baord detection and 
a driver for LED and the buttons, after that wgt634u.c could be removed.

This is based on mips/master tree.

Hauke Mehrtens (8):
  bcma: add locking around GPIO register accesses
  bcma: add bcma_chipco_gpio_pull{up,down}
  bcma: add comment to bcma_chipco_gpio_control
  bcma: add GPIO driver
  ssb: add ssb_chipco_gpio_pull{up,down}
  ssb: add locking around gpio register accesses
  ssb: add GPIO driver
  MIPS: BCM47XX: remove GPIO driver

 arch/mips/Kconfig                           |    2 +-
 arch/mips/bcm47xx/Kconfig                   |    2 +
 arch/mips/bcm47xx/Makefile                  |    2 +-
 arch/mips/bcm47xx/gpio.c                    |  102 ----------------
 arch/mips/include/asm/mach-bcm47xx/gpio.h   |  154 ++----------------------
 drivers/bcma/Kconfig                        |    9 ++
 drivers/bcma/Makefile                       |    1 +
 drivers/bcma/bcma_private.h                 |   10 ++
 drivers/bcma/driver_chipcommon.c            |   90 +++++++++++++-
 drivers/bcma/driver_gpio.c                  |   95 +++++++++++++++
 drivers/bcma/main.c                         |    3 +
 drivers/ssb/Kconfig                         |    9 ++
 drivers/ssb/Makefile                        |    1 +
 drivers/ssb/driver_chipcommon.c             |   87 +++++++++++++-
 drivers/ssb/driver_extif.c                  |   52 +++++++-
 drivers/ssb/driver_gpio.c                   |  170 +++++++++++++++++++++++++++
 drivers/ssb/main.c                          |    2 +
 drivers/ssb/ssb_private.h                   |   17 +++
 include/linux/bcma/bcma_driver_chipcommon.h |   10 ++
 include/linux/ssb/ssb.h                     |    4 +
 include/linux/ssb/ssb_driver_chipcommon.h   |    3 +
 include/linux/ssb/ssb_driver_extif.h        |    1 +
 22 files changed, 559 insertions(+), 267 deletions(-)
 delete mode 100644 arch/mips/bcm47xx/gpio.c
 create mode 100644 drivers/bcma/driver_gpio.c
 create mode 100644 drivers/ssb/driver_gpio.c

-- 
1.7.10.4

