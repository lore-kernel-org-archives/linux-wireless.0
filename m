Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59031 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab1F2WMM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 18:12:12 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	linux-mips@linux-mips.org
Cc: mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC v3 00/13] bcma: add support for embedded devices like bcm4716
Date: Thu, 30 Jun 2011 00:11:45 +0200
Message-Id: <1309385518-12097-1-git-send-email-hauke@hauke-m.de> (sfid-20110630_001225_630732_1503C12A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds support for embedded devices like bcm47xx to 
bcma. Bcma is used on bcm4716 and bcm4718 SoCs. With these patches my 
bcm4716 device boots up till it tries to access the flash, because the 
serial flash chip is unsupported for now, this will be my next task. 
This adds support for MIPS cores, interrupt configuration and the 
serial console.

This patch series adds support for embedded devices like bcm47xx to 
bcma. Bcma is used on bcm4716 and bcm4718 SoCs. With these patches my 
bcm4716 device boots up till it tries to access the flash, because the 
serial flash chip is unsupported for now, this will be my next task. 
This adds support for MIPS cores, interrupt configuration and the 
serial console.

The ifdef and switch case statements in the bcm47xx code do not look 
good got me, but I do not know how to do it in an other way. Does 
someone have a idea how to do it in a better way?
Everything in bcma looks good to me and this should be the last RFC 
patch. With the bcm47xx code I have the problem mentioned above, but if 
no one has a better idea this also works.
The pci(e) host code is not implemented, it is just done that far as it
does not do client mode initialization on hostmode devices, which will
break on an controller in host mode.
These patches are not containing all functions needed to get the SoC to 
fully work and support every feature, but it is a good start.
These patches are now integrated in OpenWrt for everyone how wants to
test them.

v3:
 * make bcm47xx built either with bcma, ssb or both and use mips MIPS 74K optimizations if possible
 * add block io support
 * some minor fixes for code and doku
v2:
 * use list and no arry to store cores
 * rename bcma_host_bcma_ to bcma_host_soc_
 * use core->io_addr and core->io_wrap to access cores
 * checkpatch fixes
 * some minor fixes

Hauke Mehrtens (13):
  bcma: move parsing of EEPROM into own function.
  bcma: move initializing of struct bcma_bus to own function.
  bcma: add functions to scan cores needed on SoCs
  bcma: add SOC bus
  bcma: add mips driver
  bcma: add serial console support
  bcma: get CPU clock
  bcma: add pci(e) host mode
  bcma: add check if sprom is available before accessing it.
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
 arch/mips/bcm47xx/wgt634u.c                  |   13 +-
 arch/mips/include/asm/mach-bcm47xx/bcm47xx.h |   26 ++-
 arch/mips/include/asm/mach-bcm47xx/gpio.h    |  108 +++++++--
 arch/mips/pci/pci-bcm47xx.c                  |    6 +
 drivers/bcma/Kconfig                         |   20 ++
 drivers/bcma/Makefile                        |    3 +
 drivers/bcma/bcma_private.h                  |   22 ++
 drivers/bcma/driver_chipcommon.c             |   69 ++++++
 drivers/bcma/driver_chipcommon_pmu.c         |   87 +++++++
 drivers/bcma/driver_mips.c                   |  254 +++++++++++++++++++
 drivers/bcma/driver_pci.c                    |   17 ++-
 drivers/bcma/driver_pci_host.c               |   43 ++++
 drivers/bcma/host_soc.c                      |  178 ++++++++++++++
 drivers/bcma/main.c                          |   69 ++++++-
 drivers/bcma/scan.c                          |  336 +++++++++++++++++---------
 drivers/bcma/sprom.c                         |    3 +
 drivers/watchdog/bcm47xx_wdt.c               |   27 ++-
 include/linux/bcma/bcma.h                    |    7 +
 include/linux/bcma/bcma_driver_chipcommon.h  |   36 +++
 include/linux/bcma/bcma_driver_mips.h        |   61 +++++
 include/linux/bcma/bcma_driver_pci.h         |    1 +
 include/linux/bcma/bcma_soc.h                |   16 ++
 31 files changed, 1538 insertions(+), 181 deletions(-)
 create mode 100644 arch/mips/bcm47xx/Kconfig
 create mode 100644 drivers/bcma/driver_mips.c
 create mode 100644 drivers/bcma/driver_pci_host.c
 create mode 100644 drivers/bcma/host_soc.c
 create mode 100644 include/linux/bcma/bcma_driver_mips.h
 create mode 100644 include/linux/bcma/bcma_soc.h

-- 
1.7.4.1

