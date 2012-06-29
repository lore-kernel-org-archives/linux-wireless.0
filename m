Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52465 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab2F2Xpt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 19:45:49 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 0/9] bcma misc updates
Date: Sat, 30 Jun 2012 01:44:36 +0200
Message-Id: <1341013486-2520-1-git-send-email-hauke@hauke-m.de> (sfid-20120630_014553_266657_E565383B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are some updates for bcma. Some are extending or completing some 
workarounds for PCIe based wireless cards. A patch adds 
bcma_pmu_spuravoid_pllupdate, used by brcmsmac and an other patch adds 
constants for the chip ids. This code is mostly based on code from 
brcmsmac and the Broadcom SDK for BCM47XX SoCs.

This was tested on a BCM4718 SoC with a BCM43224 PCIe and a BCM5357.
The Wifi part of the BCM4718 and BCM43224 is more or less working with 
brcmsmac, which need some more patches for that, but it has low speed 
and some times or with some access points I still get errors. The wifi 
of the BCM5357 does not work.

These patches are based on current wireless-testing.

Hauke Mehrtens (9):
  bcma: extend workaround for bcm4331
  bcma: add constants for chip ids
  bcma: remove fix for 4329b0 bad LPOM is detection
  bcma: add PCI ID for BCM43224
  bcma: complete workaround for BCMA43224 and BCM4313
  bcma: remove bcma_pmu_{pll,swreg}_init()
  bcma: remove chip ids doing nothing from PMU initialization.
  bcma: add bcma_pmu_spuravoid_pllupdate()
  bcma: add mdelay bcma_pmu_resources_init()
  
v2:
  - remove start of workaround for BCM4329b0
  - remove bcma_pmu_pll_init() and bcma_pmu_swreg_init()
  - do not add all the SOCs to the switch case statements in 
    bcma_pmu_workarounds() and bcma_pmu_resources_init(), but make the 
    message displayed a debug message.
  - remove code for BCM6362, this chip uses a slightly different bus 
    from bcma and ssb.

 drivers/bcma/driver_chipcommon_pmu.c        |  317 ++++++++++++++++++++-------
 drivers/bcma/driver_mips.c                  |    8 +-
 drivers/bcma/driver_pci_host.c              |    8 +-
 drivers/bcma/host_pci.c                     |    1 +
 drivers/bcma/sprom.c                        |   18 +-
 include/linux/bcma/bcma.h                   |   30 +++
 include/linux/bcma/bcma_driver_chipcommon.h |   23 ++
 7 files changed, 310 insertions(+), 95 deletions(-)

-- 
1.7.9.5

