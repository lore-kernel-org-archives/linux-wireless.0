Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44788 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab2D2ATS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:19:18 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, arend@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/4] bcma: add PCI functions from brcmsmac
Date: Sun, 29 Apr 2012 02:18:48 +0200
Message-Id: <1335658732-24351-1-git-send-email-hauke@hauke-m.de> (sfid-20120429_021953_718781_FAE90943)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains the functions regarding the PCIe core from 
brcmsmac for the supported PCIe core revisions.

Some of these functions have to be called on resume after suspend, but 
I do not know which or if all have to be called. I do not have a PCIe 
based device supported by brcmsmac, so I can not test this. Could 
someone which such a device do some tests and create a patch with the 
functions, which have to be called on resume.

The goal of theses patches is to remove the PCIe code from brcmsmac to 
get one step ahead in making brcmsmac support non pcie based devices.

This is based on wireless-testing/master.

Hauke Mehrtens (4):
  bcma: implement setting core clock mode to dynamic
  bcma: add bcma_core_pci_extend_L1timer
  bcma: add bcma_core_pci_fixcfg()
  bcma: add bcma_core_pci_config_fixup()

 drivers/bcma/core.c                  |    2 +-
 drivers/bcma/driver_pci.c            |   53 ++++++++++++++++++++++++++++++++--
 include/linux/bcma/bcma_driver_pci.h |   11 +++++++
 3 files changed, 63 insertions(+), 3 deletions(-)

-- 
1.7.9.5

