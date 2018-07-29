Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:37895 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbeG2HgR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Jul 2018 03:36:17 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 0/8] staging: wilc1000: changes to address TODO items 
Date: Sun, 29 Jul 2018 11:36:49 +0530
Message-ID: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180729_080707_999654_C1E8F622)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains changes to address below TODO items.
- rework comments and function headers(also coding style)
   All checkpatch reported issues related to coding style are addressed
   except DT compatible string un-documented. Checkpatch warning related to
   DT compatible string warning will be removed once "microchip,wilc1000-sdio"
   & microchip,wilc1000-spi" reference is move to
   ./Documentation/devicetree/bindings/ .

- make spi and sdio components coexist in one build
  Instead of compiling wilc1000.ko module separately compile it along with
  wilc1000-sdio.ko & wilc1000-spi.ko module.


Ajay Singh (8):
  staging: wilc1000: fix TODO to compile spi and sdio components in
    single module
  staging: wilc1000: remove unnecessary comments and comments
    description
  staging: wilc1000: remove unnecessary copyright information in file
  staging: wilc1000: modified debug log messages description
  staging: wilc1000: added comments for 'hif_cs' mutex lock
  staging: wilc1000: rename 'rcvd_ch_cnt' element in 'user_scan_req'
    struct
  staging: wilc1000: replace udelay with usleep_range
  staging: wilc1000: added parentheses in macro to avoid checkpatch
    issue

 drivers/staging/wilc1000/Makefile                 |   3 +-
 drivers/staging/wilc1000/TODO                     |   2 -
 drivers/staging/wilc1000/host_interface.c         | 150 +++++++++++-----------
 drivers/staging/wilc1000/host_interface.h         |   2 +-
 drivers/staging/wilc1000/linux_mon.c              |  15 ++-
 drivers/staging/wilc1000/linux_wlan.c             |   6 +-
 drivers/staging/wilc1000/wilc_debugfs.c           |  28 +---
 drivers/staging/wilc1000/wilc_sdio.c              |  15 +--
 drivers/staging/wilc1000/wilc_spi.c               |   6 -
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  13 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   6 +-
 drivers/staging/wilc1000/wilc_wlan.c              |  17 +--
 drivers/staging/wilc1000/wilc_wlan.h              |   8 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.c          |  13 --
 drivers/staging/wilc1000/wilc_wlan_cfg.h          |   8 --
 drivers/staging/wilc1000/wilc_wlan_if.h           |   2 +
 16 files changed, 109 insertions(+), 185 deletions(-)

-- 
2.7.4
