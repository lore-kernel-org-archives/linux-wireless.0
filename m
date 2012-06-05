Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35843 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab2FEVzW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 17:55:22 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/8] bcma misc updates
Date: Tue,  5 Jun 2012 23:54:59 +0200
Message-Id: <1338933307-13446-1-git-send-email-hauke@hauke-m.de> (sfid-20120605_235526_075312_156F446C)
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

Hauke Mehrtens (8):
  bcma: extend workaround for bcm4331
  bcma: add constants for chip ids
  bcma: Fix for 4329b0 bad LPOM is detection
  bcma: add PCI ID for BCM43224
  bcma: complete workaround for BCMA43224 and BCM4313
  bcma: handle SoCs in pmu initialization
  bcma: add bcma_pmu_spuravoid_pllupdate()
  bcma: add mdelay bcma_pmu_resources_init()

 drivers/bcma/driver_chipcommon_pmu.c        |  355 +++++++++++++++++++++++----
 drivers/bcma/driver_mips.c                  |    8 +-
 drivers/bcma/driver_pci_host.c              |    8 +-
 drivers/bcma/host_pci.c                     |    1 +
 drivers/bcma/sprom.c                        |   18 +-
 include/linux/bcma/bcma.h                   |   30 +++
 include/linux/bcma/bcma_driver_chipcommon.h |   23 ++
 7 files changed, 381 insertions(+), 62 deletions(-)

-- 
1.7.9.5

