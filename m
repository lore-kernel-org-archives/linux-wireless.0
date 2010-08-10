Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62839 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574Ab0HJWNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 18:13:24 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v3 0/9] native support for wl1271 on ZOOM
Date: Wed, 11 Aug 2010 01:12:19 +0300
Message-Id: <1281478348-24833-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds native support for wl1271 on ZOOM.

Changes since v2:
- mmc/sdio power manipulation is removed, and will be
  posted separately in the shape of mmc/sdio runtime pm.
- the platform device is back, used to deliver board-specific
  platform data (i.e. irq and ref clock)

Patches are based on linux-next (as of Aug 7th), and tested
on ZOOM2.

Please note that I am going to have a very limited email access
in the next three weeks, so I might not respond right away.

Thanks,

Ohad Ben-Cohen (9):
  wireless: wl1271: make wl12xx.h common to both spi and sdio
  wireless: wl1271: support return value for the set power func
  wireless: wl1271: add platform driver to get board data
  wireless: wl1271: take irq info from private board data
  wireless: wl1271: make ref_clock configurable by board
  omap: hsmmc: remove unused variable
  omap: zoom: add fixed regulator device for wlan
  omap: hsmmc: support mmc3 regulator power control
  omap: zoom: add mmc3/wl1271 device support

 arch/arm/mach-omap2/board-zoom-peripherals.c |   69 +++++++++++++++
 arch/arm/mach-omap2/hsmmc.c                  |   10 ++-
 drivers/mmc/host/omap_hsmmc.c                |   68 +++++++++++++--
 drivers/net/wireless/wl12xx/wl1251_sdio.c    |    2 +-
 drivers/net/wireless/wl12xx/wl1251_spi.c     |    2 +-
 drivers/net/wireless/wl12xx/wl1271.h         |   15 +++-
 drivers/net/wireless/wl12xx/wl1271_boot.c    |    9 +-
 drivers/net/wireless/wl12xx/wl1271_boot.h    |    1 -
 drivers/net/wireless/wl12xx/wl1271_io.h      |    8 +-
 drivers/net/wireless/wl12xx/wl1271_main.c    |    4 +-
 drivers/net/wireless/wl12xx/wl1271_sdio.c    |  120 +++++++++++++++++++++++---
 drivers/net/wireless/wl12xx/wl1271_spi.c     |    8 ++-
 include/linux/spi/wl12xx.h                   |   34 -------
 include/linux/wl12xx.h                       |   35 ++++++++
 14 files changed, 311 insertions(+), 74 deletions(-)
 delete mode 100644 include/linux/spi/wl12xx.h
 create mode 100644 include/linux/wl12xx.h

