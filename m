Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36335 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308Ab2KXWYv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 17:24:51 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wim@iguana.be,
	linux-watchdog@vger.kernel.org, castet.matthieu@free.fr,
	biblbroks@sezampro.rs, m@bues.ch, zajec5@gmail.com,
	linux-mips@linux-mips.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 00/15] watchdog/bcm47xx/bcma/ssb: add support for SoCs with PMU
Date: Sat, 24 Nov 2012 23:24:00 +0100
Message-Id: <1353795855-22236-1-git-send-email-hauke@hauke-m.de> (sfid-20121124_232504_615502_DCD06D14)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series improves the watchdog driver used on the Broadcom 
bcm47xx SoCs.
The watchdog driver does not access the functions directly any more, 
but it registers as a platform device driver and ssb and bcma are 
registering a device for this watchdog driver.
This also adds support for SoCs with a power management unit (PMU), 
which have different clock rates.

This code is currently based on the wireless-testing/master tree by 
John Linville, because there are some changes in ssb and bcma in that 
tree queued for 3.8 which will conflict with these changes, if this 
would be based on an other tree. I have no problem with rebasing this 
onto any other tree.

Hauke Mehrtens (15):
  watchdog: bcm47xx_wdt.c: convert to watchdog core api
  watchdog: bcm47xx_wdt.c: use platform device
  watchdog: bcm47xx_wdt.c: rename ops methods
  watchdog: bcm47xx_wdt.c: rename wdt_timeout to timeout
  watchdog: bcm47xx_wdt.c: add hard timer
  bcma: add bcma_chipco_alp_clock
  bcma: set the pmu watchdog if available
  bcma: add methods for watchdog driver
  bcma: register watchdog driver
  ssb: get alp clock from devices with PMU
  ssb: set the pmu watchdog if available
  ssb: add methods for watchdog driver
  ssb: extif: add check for max value in watchdog
  ssb: extif: add methods for watchdog driver
  ssb: register watchdog driver

 drivers/bcma/bcma_private.h                 |    2 +
 drivers/bcma/driver_chipcommon.c            |  114 ++++++++-
 drivers/bcma/main.c                         |    8 +
 drivers/ssb/driver_chipcommon.c             |   99 +++++++-
 drivers/ssb/driver_chipcommon_pmu.c         |   27 +++
 drivers/ssb/driver_extif.c                  |   24 +-
 drivers/ssb/embedded.c                      |   35 +++
 drivers/ssb/main.c                          |    8 +
 drivers/ssb/ssb_private.h                   |   31 +++
 drivers/watchdog/Kconfig                    |    1 +
 drivers/watchdog/bcm47xx_wdt.c              |  339 ++++++++++++---------------
 include/linux/bcm47xx_wdt.h                 |   28 +++
 include/linux/bcma/bcma_driver_chipcommon.h |    7 +-
 include/linux/ssb/ssb.h                     |    2 +
 include/linux/ssb/ssb_driver_chipcommon.h   |    5 +-
 include/linux/ssb/ssb_driver_extif.h        |   10 +-
 16 files changed, 522 insertions(+), 218 deletions(-)
 create mode 100644 include/linux/bcm47xx_wdt.h

-- 
1.7.10.4

