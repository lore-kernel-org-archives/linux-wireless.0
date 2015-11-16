Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:57549 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbbKPOF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 09:05:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 00/19 v5] staging/wilc1000 cleanups
Date: Mon, 16 Nov 2015 15:04:51 +0100
Message-Id: <1447682710-2908925-1-git-send-email-arnd@arndb.de> (sfid-20151116_151332_651262_3616A115)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As suggested by Glen Lee, I'm sending the patches once more with the
two one-line fixes in "staging/wilc1000: pass hif operations through
initialization".

I have rebased on top of today's staging-testing, but no other changes
were necessary, so this is otherwise identical to the version that
Glen has successfully tested.

Please disregard the earlier version and apply this one.

	Arnd

Arnd Bergmann (19):
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
 drivers/staging/wilc1000/host_interface.h         | 118 ++---
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
 23 files changed, 1047 insertions(+), 1883 deletions(-)

-- 
2.1.0.rc2

