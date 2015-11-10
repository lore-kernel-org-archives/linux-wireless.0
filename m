Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:50859 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbbKJXm5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 18:42:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 00/20] staging/wilc1000: cleanups once again
Date: Wed, 11 Nov 2015 00:42:20 +0100
Message-Id: <1447198960-2760143-1-git-send-email-arnd@arndb.de> (sfid-20151111_004708_067429_4F740D95)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have rebased the patches once more on top of a lot of renames,
and would prefer not to rebase them again. This is the series of
fixups that I've posted before, now for today's staging-testing
branch.

Please apply.

Arnd Bergmann (20):
  staging/wilc1000: add struct net_device declaration
  staging/wilc1000: remove unused functions
  staging/wilc1000: make symbols static if possible
  staging/wilc1000: use proper naming for global symbols
  staging/wilc1000: move extern declarations to headers
  staging/wilc1000: use NO_SECURITY instead of NO_ENCRYPT
  staging/wilc1000: avoid static definitions in header
  staging/wilc1000: remove linux_wlan_{device_power,device_detection}
  staging/wilc1000: move wilc_wlan_inp_t into struct wilc
  staging/wilc1000: move init/exit functions to driver files
  staging/wilc1000: unify device pointer
  staging/wilc1000: pass io_type to wilc_netdev_init
  staging/wilc1000: use device pointer for phy creation
  staging/wilc1000: get rid of WILC_SDIO_IRQ_GPIO
  staging/wilc1000: pass hif operations through initialization
  staging/wilc1000: turn enable_irq/disable_irq into callbacks
  staging/wilc1000: remove WILC_SDIO/WILC_SPI macros
  staging/wilc1000: split out bus specific modules
  staging/wilc1000: use more regular probing
  staging/wilc1000: pass struct wilc to most linux_wlan.c functions

 drivers/staging/wilc1000/Kconfig                  |  66 +--
 drivers/staging/wilc1000/Makefile                 |  14 +-
 drivers/staging/wilc1000/coreconfigurator.c       |  14 +-
 drivers/staging/wilc1000/coreconfigurator.h       |  16 +-
 drivers/staging/wilc1000/host_interface.c         | 591 ++++++----------------
 drivers/staging/wilc1000/host_interface.h         | 119 ++---
 drivers/staging/wilc1000/linux_mon.c              |  11 +-
 drivers/staging/wilc1000/linux_wlan.c             | 374 +++++---------
 drivers/staging/wilc1000/linux_wlan_common.h      |  22 +-
 drivers/staging/wilc1000/linux_wlan_sdio.c        | 122 ++---
 drivers/staging/wilc1000/linux_wlan_sdio.h        |  19 +-
 drivers/staging/wilc1000/linux_wlan_spi.c         | 117 ++---
 drivers/staging/wilc1000/linux_wlan_spi.h         |  14 +-
 drivers/staging/wilc1000/wilc_debugfs.c           |  26 +-
 drivers/staging/wilc1000/wilc_sdio.c              | 254 ++++------
 drivers/staging/wilc1000/wilc_spi.c               | 293 ++---------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 443 ++++++++--------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |  87 +---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  40 +-
 drivers/staging/wilc1000/wilc_wlan.c              | 232 ++++-----
 drivers/staging/wilc1000/wilc_wlan.h              |  40 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.c          |   6 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |  11 +-
 23 files changed, 1048 insertions(+), 1883 deletions(-)

-- 
2.1.0.rc2

