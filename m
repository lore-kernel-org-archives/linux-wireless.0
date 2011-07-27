Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab1G0MNw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 08:13:52 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	ath9k-devel@venema.h4ckr.net, Adrian Chadd <adrian@freebsd.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-pci@vger.kernel.org,
	Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	e1000-devel@lists.sourceforge.net
Subject: [RFC/RFT v2 00/12] ath9k: ASPM fixes
Date: Wed, 27 Jul 2011 14:14:47 +0200
Message-Id: <1311768899-4559-1-git-send-email-sgruszka@redhat.com> (sfid-20110727_141403_021199_BA0B4574)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series try to fix ath9k ASPM. Some of patches are cleanup
only or do merging common code (with e1000e driver).

With CONFIG_PCIEASPM it's possible to change ASPM settings on runtime
via /sys/module/pcie_aspm/parameters/policy . However most drivers
I looked at assume this setting is constant. I add a callback to pci
driver to inform about the change, and allow driver to do needed hw
related changes. Currently only ath9k implement the callback, but
I think it will be useful for other drivers (i.e. iwlwifi, rtlwifi)
that do some own ASPM handling.

These patches needs wide testing as they may work on some systems
and not work on others, that can depend on PCIe bridges.

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: e1000-devel@lists.sourceforge.net
---
 drivers/net/e1000e/netdev.c                |   31 ----------
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |   12 ---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |   12 ---
 drivers/net/wireless/ath/ath9k/hw-ops.h    |    9 +-
 drivers/net/wireless/ath/ath9k/hw.c        |   17 +++--
 drivers/net/wireless/ath/ath9k/hw.h        |   12 +--
 drivers/net/wireless/ath/ath9k/main.c      |    8 --
 drivers/net/wireless/ath/ath9k/pci.c       |   88 ++++++++++++++++++++++-------
 drivers/pci/pcie/Makefile                  |    3 
 drivers/pci/pcie/aspm.c                    |   46 ++++++++++++++-
 include/linux/pci-aspm.h                   |    2 
 include/linux/pci.h                        |    3 
 12 files changed, 148 insertions(+), 95 deletions(-)
