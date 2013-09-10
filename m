Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:57532 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3IJLOd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 07:14:33 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSW00483PVN7GJ0@mailout1.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 10 Sep 2013 20:14:32 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>
Subject: [PATCH 0/11] wireless: remove unnecessary pci_set_drvdata()
Date: Tue, 10 Sep 2013 20:14:32 +0900
Message-id: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com> (sfid-20130910_131437_003607_1C151639)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound),
the driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

---
 drivers/net/wireless/adm8211.c                |    1 -
 drivers/net/wireless/airo.c                   |    1 -
 drivers/net/wireless/ath/ath10k/pci.c         |    2 --
 drivers/net/wireless/ath/wil6210/pcie_bus.c   |    1 -
 drivers/net/wireless/ipw2x00/ipw2200.c        |    2 --
 drivers/net/wireless/iwlegacy/3945-mac.c      |    2 --
 drivers/net/wireless/iwlegacy/4965-mac.c      |    2 --
 drivers/net/wireless/iwlwifi/pcie/drv.c       |    3 ---
 drivers/net/wireless/mwl8k.c                  |    2 --
 drivers/net/wireless/orinoco/orinoco_nortel.c |    2 --
 drivers/net/wireless/orinoco/orinoco_pci.c    |    2 --
 drivers/net/wireless/orinoco/orinoco_plx.c    |    2 --
 drivers/net/wireless/orinoco/orinoco_tmd.c    |    2 --
 drivers/net/wireless/p54/p54pci.c             |    1 -
 drivers/net/wireless/rtl818x/rtl8180/dev.c    |    1 -
 drivers/net/wireless/rtlwifi/pci.c            |    3 ---
 16 files changed, 29 deletions(-)


