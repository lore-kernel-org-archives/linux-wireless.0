Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53388 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab1GVXUc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 19:20:32 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-mips@linux-mips.org
Cc: jonas.gorski@gmail.com, ralf@linux-mips.org, zajec5@gmail.com,
	mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v3 00/11] bcma: add support for embedded devices like bcm4716
Date: Sat, 23 Jul 2011 01:20:04 +0200
Message-Id: <1311376815-15755-1-git-send-email-hauke@hauke-m.de> (sfid-20110723_012036_496003_E773FCC9)
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

@John could you please merge this into wireless-testing. I hope Ralf is 
fine with it when some MIPS bits will go through wireless. This will 
make it much easier for Linus to merge wireless-testing and the mips 
tree together as there are many other changes for bcma in wireless-
testing.

PATCH v3:
 * rebase on wireless-testing master-2011-07-22-2
 * remove BCMA_HOSTTYPE_NONE
 * add Acked-by Rafał
 * rename bcm47xx_active_bus_type to bcm47xx_bus_type
 * set core->dev.dma_mask and core->dma_dev for SoC
 * fix comment

PATCH v2:
 * define inline function bcma_core_mips_init() if mips driver is not build
 * iounmap core->io_wrap and core->io_addr after it was used.
 * update bcma based on new braodcom driver code
   * add workaround for 5357b0
 * move flash informations into own struct and store it in chipcommon.
   When adding serial flash support it will be in chipcommon and then all flash structs should be there.
 * some changes to bcma_chipco_serial_init()
  * some changes are done after looking into a more recent version of broadcom driver.
  * changes suggested by Jonas
  * serial struct is in chipcommon as it is accessed through chipcommon.
  * use bcma_pmu_alp_clock() to get the clock.
 * cpu clock: add detection support for some newer SoCs.

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
 arch/mips/bcm47xx/setup.c                    |   90 ++++++-
 arch/mips/bcm47xx/time.c                     |   16 +-
 arch/mips/bcm47xx/wgt634u.c                  |   14 +-
 arch/mips/include/asm/mach-bcm47xx/bcm47xx.h |   26 ++-
 arch/mips/include/asm/mach-bcm47xx/gpio.h    |  108 +++++++--
 arch/mips/pci/pci-bcm47xx.c                  |    6 +
 drivers/bcma/Kconfig                         |   13 +
 drivers/bcma/Makefile                        |    2 +
 drivers/bcma/bcma_private.h                  |   16 ++
 drivers/bcma/core.c                          |    2 +
 drivers/bcma/driver_chipcommon.c             |   53 ++++
 drivers/bcma/driver_chipcommon_pmu.c         |  133 ++++++++++
 drivers/bcma/driver_mips.c                   |  256 +++++++++++++++++++
 drivers/bcma/driver_pci.c                    |   14 +-
 drivers/bcma/host_soc.c                      |  183 ++++++++++++++
 drivers/bcma/main.c                          |   70 +++++-
 drivers/bcma/scan.c                          |  348 ++++++++++++++++++--------
 drivers/watchdog/bcm47xx_wdt.c               |   27 ++-
 include/linux/bcma/bcma.h                    |    9 +-
 include/linux/bcma/bcma_driver_chipcommon.h  |   67 +++++
 include/linux/bcma/bcma_driver_mips.h        |   51 ++++
 include/linux/bcma/bcma_soc.h                |   16 ++
 29 files changed, 1549 insertions(+), 182 deletions(-)
 create mode 100644 arch/mips/bcm47xx/Kconfig
 create mode 100644 drivers/bcma/driver_mips.c
 create mode 100644 drivers/bcma/host_soc.c
 create mode 100644 include/linux/bcma/bcma_driver_mips.h
 create mode 100644 include/linux/bcma/bcma_soc.h

-- 
1.7.4.1

