Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60686 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab1GILGc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 07:06:32 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: ralf@linux-mips.org, linux-wireless@vger.kernel.org,
	zajec5@gmail.com, linux-mips@linux-mips.org
Cc: mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: =?UTF-8?q?=5BPATCH=2000/11=5D=20bcma=3A=20add=20support=20for=20embedded=20devices=20like=20bcm4716?=
Date: Sat,  9 Jul 2011 13:05:52 +0200
Message-Id: <1310209563-6405-1-git-send-email-hauke@hauke-m.de> (sfid-20110709_130636_550148_A8F1E96F)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds support for embedded devices like bcm47xx to 
bcma. Bcma is used on bcm4716 and bcm4718 SoCs as the system bus and
replaced ssb used on older devices. With these patches my bcm4716 
device boots up till it tries to access the flash, because the serial 
flash chip is unsupported for now, this will be my next task. This adds 
support for MIPS cores, interrupt configuration and the serial console.

These patches are not containing all functions needed to get the SoC to 
fully work and support every feature, but it is a good start.
These patches are now integrated in OpenWrt for everyone how wants to
test them.

This was tested with a BCM4704 device (SoC with ssb bus), a BCM4716 
device and a pcie wireless card supported by bcma.


@Rafał: If you are fine with the bcma patches could you please give
your Signed-off on them.

PATCH v1:
 * rebased on mips tree (mips/queue)
 * drop pcie hostmode patch as Rafał sent a better patch to wireless mailing list
 * drop sprom patch because sprom is not supported in bcma version from mips tree,
     I will send a separate patch to wireless mailing list.
 * fix compilation of arch/mips/bcm47xx/wgt634u.c
 * fix texts in arch/mips/bcm47xx/Kconfig
RFC v3:
 * make bcm47xx built either with bcma, ssb or both and use mips MIPS 74K optimizations if possible
 * add block io support
 * some minor fixes for code and doku
RFC v2:
 * use list and no arry to store cores
 * rename bcma_host_bcma_ to bcma_host_soc_
 * use core->io_addr and core->io_wrap to access cores
 * checkpatch fixes
 * some minor fixes


Hauke Mehrtens (11):
  bcma: move parsing of EEPROM into own function.
  bcma: move initializing of struct bcma_bus to own function.
  bcma: add functions to scan cores needed on SoCs
  bcma: add SOC bus
  bcma: add mips driver
  bcma: add serial console support
  bcma: get CPU clock
  bcm47xx: prepare to support different buses
  bcm47xx: make it possible to build bcm47xx without ssb.
  bcm47xx: add support for bcma bus
  bcm47xx: fix irq assignment for new SoCs.

 arch/mips/Kconfig                            |    8 +-
 arch/mips/bcm47xx/Kconfig                    |   31 +++
 arch/mips/bcm47xx/Makefile                   |    3 +-
 arch/mips/bcm47xx/gpio.c                     |   82 +++++--
 arch/mips/bcm47xx/irq.c                      |   12 +
 arch/mips/bcm47xx/nvram.c                    |   29 ++-
 arch/mips/bcm47xx/serial.c                   |   46 ++++-
 arch/mips/bcm47xx/setup.c                    |   90 +++++++-
 arch/mips/bcm47xx/time.c                     |   16 +-
 arch/mips/bcm47xx/wgt634u.c                  |   14 +-
 arch/mips/include/asm/mach-bcm47xx/bcm47xx.h |   26 ++-
 arch/mips/include/asm/mach-bcm47xx/gpio.h    |  108 +++++++--
 arch/mips/pci/pci-bcm47xx.c                  |    6 +
 drivers/bcma/Kconfig                         |   14 +
 drivers/bcma/Makefile                        |    2 +
 drivers/bcma/bcma_private.h                  |   16 ++
 drivers/bcma/driver_chipcommon.c             |   69 ++++++
 drivers/bcma/driver_chipcommon_pmu.c         |   87 +++++++
 drivers/bcma/driver_mips.c                   |  254 +++++++++++++++++++
 drivers/bcma/driver_pci.c                    |    3 +
 drivers/bcma/host_soc.c                      |  178 ++++++++++++++
 drivers/bcma/main.c                          |   65 +++++
 drivers/bcma/scan.c                          |  336 +++++++++++++++++---------
 drivers/watchdog/bcm47xx_wdt.c               |   27 ++-
 include/linux/bcma/bcma.h                    |    8 +
 include/linux/bcma/bcma_driver_chipcommon.h  |   36 +++
 include/linux/bcma/bcma_driver_mips.h        |   61 +++++
 include/linux/bcma/bcma_soc.h                |   16 ++
 28 files changed, 1464 insertions(+), 179 deletions(-)
 create mode 100644 arch/mips/bcm47xx/Kconfig
 create mode 100644 drivers/bcma/driver_mips.c
 create mode 100644 drivers/bcma/host_soc.c
 create mode 100644 include/linux/bcma/bcma_driver_mips.h
 create mode 100644 include/linux/bcma/bcma_soc.h

-- 
1.7.4.1

