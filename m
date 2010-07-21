Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59315 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab0GUReV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 13:34:21 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 00/20] native support for wl1271 on ZOOM
Date: Wed, 21 Jul 2010 20:33:34 +0300
Message-Id: <1279733634-21974-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds native support for wl1271 on ZOOM.

Changes since v1:

- introduce a fixed regulator device to control the power of wl1271
- allow to propagate private board-specific data to SDIO function drivers
- allow SDIO function driver to control the card's power via new API
- make it possible to keep the card's power down (without depending
  on an explicit SDIO function driver power-down request)

Thanks to these changes, we no longer need a separate platform
device (carrying e.g. the external irq information of the device),
and no longer need to emulate virtual card detect events.

The two "board muxing" pathces were already taken by Tony, and
are resent here just to make it easier for people to use/test these pathces.

The changes to the MMC core really needs careful review; there still
might be some pitfalls that haven't been covered. E.g., one thing
we plan to look at next is their bahvior together with SDIO Suspend/Resume.

Special thanks to Roger Quadros and Nicolas Pitre for their extensive
review and helpful suggestions.

The patches are based on 2.6.35-rc5, and were tested on ZOOM3.

Thanks,

Ohad Ben-Cohen (20):
  sdio: add TI + wl1271 ids
  wireless: wl1271: remove SDIO IDs from driver
  mmc: support embedded data field in mmc_host
  omap zoom2: wlan board muxing
  omap zoom3: wlan board muxing
  wireless: wl1271: make wl12xx.h common to both spi and sdio
  wireless: wl1271: support return value for the set power func
  wireless: wl1271: take irq info from private board data
  wireless: wl1271: make ref_clock configurable by board
  omap: zoom: add fixed regulator device for wlan
  omap: hsmmc: support mmc3 regulator power control
  omap: hsmmc: allow board-specific settings of private mmc data
  omap: zoom: add mmc3/wl1271 device support
  mmc: sdio: fully reconfigure oldcard on resume
  mmc: sdio: verify existence of resume handler
  mmc: introduce API to control the card's power
  mmc: sdio: relocate sdio_set_block_size call
  mmc: sdio: enable a default power off mode of the card
  omap: zoom: keep the MMC3 wl1271 device powered off
  wireless: wl1271: call SDIO claim/release power API

 arch/arm/mach-omap2/board-zoom-peripherals.c |   54 +++++++++++++++++++
 arch/arm/mach-omap2/board-zoom2.c            |   13 +++++
 arch/arm/mach-omap2/board-zoom3.c            |   13 +++++
 arch/arm/mach-omap2/hsmmc.c                  |   15 ++++--
 arch/arm/mach-omap2/hsmmc.h                  |    2 +
 arch/arm/plat-omap/include/plat/mmc.h        |    5 ++
 drivers/mmc/core/bus.c                       |    3 +
 drivers/mmc/core/core.c                      |   50 ++++++++++++++++++
 drivers/mmc/core/sdio.c                      |   36 +++++++++++--
 drivers/mmc/core/sdio_bus.c                  |    9 ---
 drivers/mmc/core/sdio_io.c                   |   50 ++++++++++++++++++
 drivers/mmc/host/omap_hsmmc.c                |   72 +++++++++++++++++++++++---
 drivers/net/wireless/wl12xx/wl1251_sdio.c    |    2 +-
 drivers/net/wireless/wl12xx/wl1251_spi.c     |    2 +-
 drivers/net/wireless/wl12xx/wl1271.h         |    3 +-
 drivers/net/wireless/wl12xx/wl1271_boot.c    |    9 ++--
 drivers/net/wireless/wl12xx/wl1271_boot.h    |    1 -
 drivers/net/wireless/wl12xx/wl1271_io.h      |    8 ++-
 drivers/net/wireless/wl12xx/wl1271_main.c    |    4 +-
 drivers/net/wireless/wl12xx/wl1271_sdio.c    |   31 +++++------
 drivers/net/wireless/wl12xx/wl1271_spi.c     |    8 ++-
 include/linux/mmc/card.h                     |    2 +
 include/linux/mmc/host.h                     |   15 +++++
 include/linux/mmc/sdio_func.h                |    3 +
 include/linux/mmc/sdio_ids.h                 |    3 +
 include/linux/spi/wl12xx.h                   |   34 ------------
 include/linux/wl12xx.h                       |   35 ++++++++++++
 27 files changed, 393 insertions(+), 89 deletions(-)
 delete mode 100644 include/linux/spi/wl12xx.h
 create mode 100644 include/linux/wl12xx.h

