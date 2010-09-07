Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49491 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab0IGL3e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Sep 2010 07:29:34 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Gao Yunpeng <yunpeng.gao@intel.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v1 0/8] SDIO Runtime PM Support
Date: Tue,  7 Sep 2010 14:29:01 +0300
Message-Id: <1283858949-11073-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset introduces runtime PM support to SDIO cards.

What have been achieved:

1. Power to SDIO cards is kept low until one of its functions is bound
   (i.e. a matching driver is successfully probed)

2. If the matching driver supports runtime PM, power to the card is
   dropped soon after probe() returns. It is then up to the driver
   to request power to its function, using runtime PM API (the get/put
   variants). Last patch in this series demonstrates this with the
   wl1271 driver which couples the card power with the state of the wlan
   interface (interface up -> power is up, interface down -> power is down)

4. If a matching driver does not support Runtime PM, power to the card
   is kept high during the whole lifetime of the driver

5. When the driver is removed, power to the card is immediately dropped

6. If there are multiple drivers for the same card (several SDIO functions),
   power will be pulled high before the first driver probes, and dropped
   down after the last driver is removed. In between, power will be
   maintained accrording to the accumulated usage count of the complete
   drivers group

Patches were tested on ZOOM3, 2.6.36-rc3.

Dependencies (in case you want to test this):
- The SDIO/MMC part depends on http://www.spinics.net/lists/linux-pm/msg21663.html (patch was already accepted by PM maintainer)
- The WLAN part depends on http://www.mail-archive.com/linux-omap@vger.kernel.org/msg34148.html

Maturity level is much better than the previous RFC patches, and also testing that have been conducted are more intense. We still plan to stress this even further, but it's certainly ready for wide review.

Next thing I plan on doing is testing this with SDIO suspend/resume (with and without MMC_PM_KEEP_POWER). I'll update as soon as I have results (setup issues and a business trip will keep me away for several days).

Thanks,

Ohad Ben-Cohen (8):
  mmc: sdio: fully reconfigure oldcard on resume
  mmc: let power save/restore ops return a value
  sdio: add power_restore support
  mmc: add general Runtime PM support
  sdio: add general runtime PM support
  sdio: enable Runtime PM for SDIO cards
  sdio: enable Runtime PM for SDIO functions
  wireless: wl1271_sdio: enable Runtime PM

 drivers/mmc/core/bus.c                    |   37 +++++++++++++++++++++
 drivers/mmc/core/core.c                   |   20 ++++++++---
 drivers/mmc/core/core.h                   |    4 +-
 drivers/mmc/core/mmc.c                    |    8 +++-
 drivers/mmc/core/sd.c                     |    8 +++-
 drivers/mmc/core/sdio.c                   |   42 +++++++++++++++++++-----
 drivers/mmc/core/sdio_bus.c               |   50 +++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/wl1271_sdio.c |   14 +++++++-
 include/linux/mmc/host.h                  |    4 +-
 9 files changed, 161 insertions(+), 26 deletions(-)

