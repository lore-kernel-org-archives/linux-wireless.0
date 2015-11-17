Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57835 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbbKQPpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 10:45:49 -0500
Received: from potku.com (a88-115-185-251.elisa-laajakaista.fi [88.115.185.251])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: kvalo@smtp.codeaurora.org)
	by smtp.codeaurora.org (Postfix) with ESMTPSA id 647FE1419A5
	for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2015 15:45:47 +0000 (UTC)
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/5] wireless drivers vendor directories
Date: Tue, 17 Nov 2015 17:45:31 +0200
Message-Id: <1447775136-21173-1-git-send-email-kvalo@codeaurora.org> (sfid-20151117_164624_237042_2E6CA4D4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I started to look how to implement the vendor directories for wireless
drivers, similarly like ethernet has. Here's my first proposal where I
experimented with five different drivers. There's also a git branch
which I keep up-to-date:

https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.git/log/?h=wd-reorg

Please review and send comments.

Kalle Valo (5):
  admtek: create new wireless vendor directory
  cisco: create new wireless vendor directory
  atmel: create new wireless vendor directory
  b43: move under broadcom vendor directory
  b43legacy: move under broadcom vendor directory

 MAINTAINERS                                        |    8 +-
 drivers/net/wireless/Kconfig                       |  119 +-------------------
 drivers/net/wireless/Makefile                      |   18 +--
 drivers/net/wireless/admtek/Kconfig                |   41 +++++++
 drivers/net/wireless/admtek/Makefile               |    1 +
 drivers/net/wireless/{ => admtek}/adm8211.c        |    0
 drivers/net/wireless/{ => admtek}/adm8211.h        |    0
 drivers/net/wireless/atmel/Kconfig                 |   57 ++++++++++
 drivers/net/wireless/atmel/Makefile                |    5 +
 drivers/net/wireless/{ => atmel}/at76c50x-usb.c    |    0
 drivers/net/wireless/{ => atmel}/at76c50x-usb.h    |    0
 drivers/net/wireless/{ => atmel}/atmel.c           |    0
 drivers/net/wireless/{ => atmel}/atmel.h           |    0
 drivers/net/wireless/{ => atmel}/atmel_cs.c        |    0
 drivers/net/wireless/{ => atmel}/atmel_pci.c       |    0
 drivers/net/wireless/broadcom/Kconfig              |   17 +++
 drivers/net/wireless/broadcom/Makefile             |    2 +
 drivers/net/wireless/{ => broadcom}/b43/Kconfig    |    0
 drivers/net/wireless/{ => broadcom}/b43/Makefile   |    0
 drivers/net/wireless/{ => broadcom}/b43/b43.h      |    0
 drivers/net/wireless/{ => broadcom}/b43/bus.c      |    0
 drivers/net/wireless/{ => broadcom}/b43/bus.h      |    0
 drivers/net/wireless/{ => broadcom}/b43/debugfs.c  |    0
 drivers/net/wireless/{ => broadcom}/b43/debugfs.h  |    0
 drivers/net/wireless/{ => broadcom}/b43/dma.c      |    0
 drivers/net/wireless/{ => broadcom}/b43/dma.h      |    0
 drivers/net/wireless/{ => broadcom}/b43/leds.c     |    0
 drivers/net/wireless/{ => broadcom}/b43/leds.h     |    0
 drivers/net/wireless/{ => broadcom}/b43/lo.c       |    0
 drivers/net/wireless/{ => broadcom}/b43/lo.h       |    0
 drivers/net/wireless/{ => broadcom}/b43/main.c     |    0
 drivers/net/wireless/{ => broadcom}/b43/main.h     |    0
 drivers/net/wireless/{ => broadcom}/b43/phy_a.c    |    0
 drivers/net/wireless/{ => broadcom}/b43/phy_a.h    |    0
 drivers/net/wireless/{ => broadcom}/b43/phy_ac.c   |    0
 drivers/net/wireless/{ => broadcom}/b43/phy_ac.h   |    0
 .../net/wireless/{ => broadcom}/b43/phy_common.c   |    0
 .../net/wireless/{ => broadcom}/b43/phy_common.h   |    0
 drivers/net/wireless/{ => broadcom}/b43/phy_g.c    |    0
 drivers/net/wireless/{ => broadcom}/b43/phy_g.h    |    0
 drivers/net/wireless/{ => broadcom}/b43/phy_ht.c   |    0
 drivers/net/wireless/{ => broadcom}/b43/phy_ht.h   |    0
 drivers/net/wireless/{ => broadcom}/b43/phy_lcn.c  |    0
 drivers/net/wireless/{ => broadcom}/b43/phy_lcn.h  |    0
 drivers/net/wireless/{ => broadcom}/b43/phy_lp.c   |    0
 drivers/net/wireless/{ => broadcom}/b43/phy_lp.h   |    0
 drivers/net/wireless/{ => broadcom}/b43/phy_n.c    |    0
 drivers/net/wireless/{ => broadcom}/b43/phy_n.h    |    0
 drivers/net/wireless/{ => broadcom}/b43/pio.c      |    0
 drivers/net/wireless/{ => broadcom}/b43/pio.h      |    0
 drivers/net/wireless/{ => broadcom}/b43/ppr.c      |    0
 drivers/net/wireless/{ => broadcom}/b43/ppr.h      |    0
 .../net/wireless/{ => broadcom}/b43/radio_2055.c   |    0
 .../net/wireless/{ => broadcom}/b43/radio_2055.h   |    0
 .../net/wireless/{ => broadcom}/b43/radio_2056.c   |    0
 .../net/wireless/{ => broadcom}/b43/radio_2056.h   |    0
 .../net/wireless/{ => broadcom}/b43/radio_2057.c   |    0
 .../net/wireless/{ => broadcom}/b43/radio_2057.h   |    0
 .../net/wireless/{ => broadcom}/b43/radio_2059.c   |    0
 .../net/wireless/{ => broadcom}/b43/radio_2059.h   |    0
 drivers/net/wireless/{ => broadcom}/b43/rfkill.c   |    0
 drivers/net/wireless/{ => broadcom}/b43/rfkill.h   |    0
 drivers/net/wireless/{ => broadcom}/b43/sdio.c     |    0
 drivers/net/wireless/{ => broadcom}/b43/sdio.h     |    0
 drivers/net/wireless/{ => broadcom}/b43/sysfs.c    |    0
 drivers/net/wireless/{ => broadcom}/b43/sysfs.h    |    0
 drivers/net/wireless/{ => broadcom}/b43/tables.c   |    0
 drivers/net/wireless/{ => broadcom}/b43/tables.h   |    0
 .../net/wireless/{ => broadcom}/b43/tables_lpphy.c |    0
 .../net/wireless/{ => broadcom}/b43/tables_lpphy.h |    0
 .../net/wireless/{ => broadcom}/b43/tables_nphy.c  |    0
 .../net/wireless/{ => broadcom}/b43/tables_nphy.h  |    0
 .../wireless/{ => broadcom}/b43/tables_phy_ht.c    |    0
 .../wireless/{ => broadcom}/b43/tables_phy_ht.h    |    0
 .../wireless/{ => broadcom}/b43/tables_phy_lcn.c   |    0
 .../wireless/{ => broadcom}/b43/tables_phy_lcn.h   |    0
 drivers/net/wireless/{ => broadcom}/b43/wa.c       |    0
 drivers/net/wireless/{ => broadcom}/b43/wa.h       |    0
 drivers/net/wireless/{ => broadcom}/b43/xmit.c     |    0
 drivers/net/wireless/{ => broadcom}/b43/xmit.h     |    0
 .../net/wireless/{ => broadcom}/b43legacy/Kconfig  |    0
 .../net/wireless/{ => broadcom}/b43legacy/Makefile |    0
 .../wireless/{ => broadcom}/b43legacy/b43legacy.h  |    0
 .../wireless/{ => broadcom}/b43legacy/debugfs.c    |    0
 .../wireless/{ => broadcom}/b43legacy/debugfs.h    |    0
 .../net/wireless/{ => broadcom}/b43legacy/dma.c    |    0
 .../net/wireless/{ => broadcom}/b43legacy/dma.h    |    0
 .../net/wireless/{ => broadcom}/b43legacy/ilt.c    |    0
 .../net/wireless/{ => broadcom}/b43legacy/ilt.h    |    0
 .../net/wireless/{ => broadcom}/b43legacy/leds.c   |    0
 .../net/wireless/{ => broadcom}/b43legacy/leds.h   |    0
 .../net/wireless/{ => broadcom}/b43legacy/main.c   |    0
 .../net/wireless/{ => broadcom}/b43legacy/main.h   |    0
 .../net/wireless/{ => broadcom}/b43legacy/phy.c    |    0
 .../net/wireless/{ => broadcom}/b43legacy/phy.h    |    0
 .../net/wireless/{ => broadcom}/b43legacy/pio.c    |    0
 .../net/wireless/{ => broadcom}/b43legacy/pio.h    |    0
 .../net/wireless/{ => broadcom}/b43legacy/radio.c  |    0
 .../net/wireless/{ => broadcom}/b43legacy/radio.h  |    0
 .../net/wireless/{ => broadcom}/b43legacy/rfkill.c |    0
 .../net/wireless/{ => broadcom}/b43legacy/rfkill.h |    0
 .../net/wireless/{ => broadcom}/b43legacy/sysfs.c  |    0
 .../net/wireless/{ => broadcom}/b43legacy/sysfs.h  |    0
 .../net/wireless/{ => broadcom}/b43legacy/xmit.c   |    0
 .../net/wireless/{ => broadcom}/b43legacy/xmit.h   |    0
 drivers/net/wireless/cisco/Kconfig                 |   56 +++++++++
 drivers/net/wireless/cisco/Makefile                |    2 +
 drivers/net/wireless/{ => cisco}/airo.c            |    0
 drivers/net/wireless/{ => cisco}/airo.h            |    0
 drivers/net/wireless/{ => cisco}/airo_cs.c         |    0
 110 files changed, 195 insertions(+), 131 deletions(-)
 create mode 100644 drivers/net/wireless/admtek/Kconfig
 create mode 100644 drivers/net/wireless/admtek/Makefile
 rename drivers/net/wireless/{ => admtek}/adm8211.c (100%)
 rename drivers/net/wireless/{ => admtek}/adm8211.h (100%)
 create mode 100644 drivers/net/wireless/atmel/Kconfig
 create mode 100644 drivers/net/wireless/atmel/Makefile
 rename drivers/net/wireless/{ => atmel}/at76c50x-usb.c (100%)
 rename drivers/net/wireless/{ => atmel}/at76c50x-usb.h (100%)
 rename drivers/net/wireless/{ => atmel}/atmel.c (100%)
 rename drivers/net/wireless/{ => atmel}/atmel.h (100%)
 rename drivers/net/wireless/{ => atmel}/atmel_cs.c (100%)
 rename drivers/net/wireless/{ => atmel}/atmel_pci.c (100%)
 create mode 100644 drivers/net/wireless/broadcom/Kconfig
 create mode 100644 drivers/net/wireless/broadcom/Makefile
 rename drivers/net/wireless/{ => broadcom}/b43/Kconfig (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/Makefile (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/b43.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/bus.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/bus.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/debugfs.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/debugfs.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/dma.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/dma.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/leds.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/leds.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/lo.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/lo.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/main.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/main.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/phy_a.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/phy_a.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/phy_ac.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/phy_ac.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/phy_common.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/phy_common.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/phy_g.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/phy_g.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/phy_ht.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/phy_ht.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/phy_lcn.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/phy_lcn.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/phy_lp.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/phy_lp.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/phy_n.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/phy_n.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/pio.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/pio.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/ppr.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/ppr.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/radio_2055.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/radio_2055.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/radio_2056.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/radio_2056.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/radio_2057.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/radio_2057.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/radio_2059.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/radio_2059.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/rfkill.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/rfkill.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/sdio.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/sdio.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/sysfs.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/sysfs.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/tables.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/tables.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/tables_lpphy.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/tables_lpphy.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/tables_nphy.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/tables_nphy.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/tables_phy_ht.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/tables_phy_ht.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/tables_phy_lcn.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/tables_phy_lcn.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/wa.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/wa.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/xmit.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43/xmit.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/Kconfig (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/Makefile (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/b43legacy.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/debugfs.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/debugfs.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/dma.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/dma.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/ilt.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/ilt.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/leds.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/leds.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/main.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/main.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/phy.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/phy.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/pio.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/pio.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/radio.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/radio.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/rfkill.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/rfkill.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/sysfs.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/sysfs.h (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/xmit.c (100%)
 rename drivers/net/wireless/{ => broadcom}/b43legacy/xmit.h (100%)
 create mode 100644 drivers/net/wireless/cisco/Kconfig
 create mode 100644 drivers/net/wireless/cisco/Makefile
 rename drivers/net/wireless/{ => cisco}/airo.c (100%)
 rename drivers/net/wireless/{ => cisco}/airo.h (100%)
 rename drivers/net/wireless/{ => cisco}/airo_cs.c (100%)

-- 
1.7.9.5

