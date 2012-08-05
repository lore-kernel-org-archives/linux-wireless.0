Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49411 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab2HELMU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2012 07:12:20 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/3] MIPS: BCM47xx: use gpiolib
Date: Sun,  5 Aug 2012 13:12:00 +0200
Message-Id: <1344165123-4640-1-git-send-email-hauke@hauke-m.de> (sfid-20120805_131259_306323_A89CF5F6)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The original code implemented the GPIO interface itself and this caused
some problems. With this patch gpiolib is used.

This is based on mips/master.

Hauke Mehrtens (3):
  ssb: add function to return number of gpio lines
  bcma: add GPIO driver for SoCs
  MIPS: BCM47xx: rewrite GPIO handling and use gpiolib

 arch/mips/Kconfig                            |    2 +-
 arch/mips/bcm47xx/gpio.c                     |  208 ++++++++++++++++++++------
 arch/mips/bcm47xx/setup.c                    |    2 +
 arch/mips/bcm47xx/wgt634u.c                  |    7 +
 arch/mips/include/asm/mach-bcm47xx/bcm47xx.h |    2 +
 arch/mips/include/asm/mach-bcm47xx/gpio.h    |  151 +++----------------
 drivers/bcma/Kconfig                         |    5 +
 drivers/bcma/Makefile                        |    1 +
 drivers/bcma/driver_gpio.c                   |   90 +++++++++++
 drivers/bcma/scan.c                          |    4 +
 drivers/ssb/embedded.c                       |   12 ++
 include/linux/bcma/bcma.h                    |    5 +
 include/linux/bcma/bcma_driver_gpio.h        |   21 +++
 include/linux/ssb/ssb_embedded.h             |    4 +
 14 files changed, 339 insertions(+), 175 deletions(-)
 create mode 100644 drivers/bcma/driver_gpio.c
 create mode 100644 include/linux/bcma/bcma_driver_gpio.h

-- 
1.7.9.5

