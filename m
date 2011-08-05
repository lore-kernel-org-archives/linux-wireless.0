Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab1HELLM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 07:11:12 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	ath9k-devel@venema.h4ckr.net, Adrian Chadd <adrian@freebsd.org>,
	<lrodriguez@atheros.com>
Subject: [PATCH -next 0/8] ath9k: ASPM fixes
Date: Fri,  5 Aug 2011 13:10:31 +0200
Message-Id: <1312542639-4274-1-git-send-email-sgruszka@redhat.com> (sfid-20110805_131116_709072_A52CACA3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series try to fix ath9k ASPM. Some of patches are cleanup
only or do merging common code (with e1000e driver).

With CONFIG_PCIEASPM it's possible to change ASPM settings on runtime
via /sys/module/pcie_aspm/parameters/policy . However most drivers
I looked at assume this setting is constant. I add a callback to pci
driver to inform about the change, and allow driver to do needed hw
related changes. Currently only ath9k implement the callback, but
I think it will be useful for other drivers i.e. iwlwifi, rtlwifi
that do some own ASPM handling.

Would be nice to get some testing on patches on different
platforms with ath9k devices on kernel compiled with CONFIG_PCIEASPM
(default) and mixing up commands:

echo powersave > /sys/module/pcie_aspm/parameters/policy  
echo performance > /sys/module/pcie_aspm/parameters/policy  
ifconfig wlan0 down
ifconfig wlan0 up
pm-suspend

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
