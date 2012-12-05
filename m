Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47288 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab2LERqw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 12:46:52 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, wim@iguana.be
Cc: linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org,
	castet.matthieu@free.fr, biblbroks@sezampro.rs, m@bues.ch,
	zajec5@gmail.com, linux-mips@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v3 00/11] watchdog/bcm47xx/bcma/ssb: add support for SoCs with PMU
Date: Wed,  5 Dec 2012 18:45:57 +0100
Message-Id: <1354729568-19993-1-git-send-email-hauke@hauke-m.de> (sfid-20121205_184656_246832_8F9C1880)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patch series improves the functions for setting the watchdog 
driver in ssb amd bcma. It also makes ssb and bcma register a platform 
device which could be used by a watchdog driver to better set the times 
where the system should restart. The patches for the watchdog driver
will be send later and were removed in v3.

This code is currently based on the wireless-testing/master tree by 
John Linville.

v3:
 * Remove changes done to the watchdog driver so John could pull this 
   into wireless-testing, this sill works with the old watchdog driver. 
   The patches changing the watchdog driver will be send later.
   This was done to get this into 3.8 because Wim Van Sebroeck is 
   neither giving an Ack or a Nack on these patches and we want to do 
   more changes to bcma/ssb on top of these.

v2:
 * reword some commit messages
 * rebase on current wireless-testing/master with 
      "ssb: extif: fix compile errors" applied on top of it.
 * do not change value of WDT_SOFTTIMER_MAX
 * moved some small changes in the bcm47xx_wdt.c patches

Hauke Mehrtens (11):
  ssb/bcma: add common header for watchdog
  bcma: add bcma_chipco_alp_clock
  bcma: set the pmu watchdog if available
  bcma: add methods for watchdog driver
  bcma: register watchdog driver
  ssb: get alp clock from devices with PMU
  ssb: set the PMU watchdog if available
  ssb: add methods for watchdog driver
  ssb: extif: add check for max value before setting watchdog register
  ssb: extif: add methods for watchdog driver
  ssb: register watchdog driver

 drivers/bcma/bcma_private.h                 |    2 +
 drivers/bcma/driver_chipcommon.c            |  114 +++++++++++++++++++++++++--
 drivers/bcma/main.c                         |    8 ++
 drivers/ssb/driver_chipcommon.c             |  100 ++++++++++++++++++++---
 drivers/ssb/driver_chipcommon_pmu.c         |   27 +++++++
 drivers/ssb/driver_extif.c                  |   24 +++++-
 drivers/ssb/embedded.c                      |   35 ++++++++
 drivers/ssb/main.c                          |    8 ++
 drivers/ssb/ssb_private.h                   |   31 ++++++++
 include/linux/bcm47xx_wdt.h                 |   19 +++++
 include/linux/bcma/bcma_driver_chipcommon.h |    7 +-
 include/linux/ssb/ssb.h                     |    2 +
 include/linux/ssb/ssb_driver_chipcommon.h   |    5 +-
 include/linux/ssb/ssb_driver_extif.h        |   10 ++-
 14 files changed, 368 insertions(+), 24 deletions(-)
 create mode 100644 include/linux/bcm47xx_wdt.h

-- 
1.7.10.4

