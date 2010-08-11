Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43673 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab0HKSV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 14:21:58 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: Ido Yariv <ido@wizery.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
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
Subject: [PATCH v4 0/8] native support for wl1271 on ZOOM
Date: Wed, 11 Aug 2010 21:21:45 +0300
Message-Id: <1281550913-17633-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds native support for wl1271 on ZOOM.

Changes since v3:
- slot is marked nonremovable
- no explicit slot ocr mask
- dont split hsmmc mmc23 power control

Patches are based on linux-next (as of Aug 7th), and tested
on ZOOM2.

Please note that I am going to have a very limited email access
in the next three weeks, so I might not respond right away.

Thanks,

Ohad Ben-Cohen (8):
  wireless: wl1271: make wl12xx.h common to both spi and sdio
  wireless: wl1271: support return value for the set power func
  wireless: wl1271: add platform driver to get board data
  wireless: wl1271: take irq info from private board data
  wireless: wl1271: make ref_clock configurable by board
  omap: hsmmc: remove unused variable
  omap: zoom: add fixed regulator device for wlan
  omap: zoom: add mmc3/wl1271 device support

 arch/arm/mach-omap2/board-zoom-peripherals.c |   69 +++++++++++++++
 drivers/mmc/host/omap_hsmmc.c                |    1 -
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
 13 files changed, 245 insertions(+), 63 deletions(-)
 delete mode 100644 include/linux/spi/wl12xx.h
 create mode 100644 include/linux/wl12xx.h

