Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:50644 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbeHLHYv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Aug 2018 03:24:51 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 0/5] staging: wilc1000: compilation error fixes & cleanup changes
Date: Sun, 12 Aug 2018 10:17:40 +0530
Message-ID: <1534049265-5600-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180812_064820_329001_1A03FBC1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains the changes to avoid below compilation error.

 "drivers/staging/wilc1000/wilc_debugfs.o:(.data+0x10): undefined
 reference to `__this_module'"

Split the changes into multiple patches, as discussed in [1].

[1]. https://www.spinics.net/lists/linux-wireless/msg176009.html

Ajay Singh (5):
  staging: wilc1000: avoid arrray of 'wilc_debugfs_info_t' type
  staging: wilc1000: fixes for undefined reference to `__this_module'
    error
  staging: wilc1000: remove the use of 'wilc_debugfs_info_t' struct
  staging: wilc1000: change permission to 0600 in debugfs_create_file()
    call
  staging: wilc1000: use void return for wilc_debugfs_init()

 drivers/staging/wilc1000/linux_wlan.c   |  1 -
 drivers/staging/wilc1000/wilc_debugfs.c | 48 +++++----------------------------
 drivers/staging/wilc1000/wilc_sdio.c    |  7 +++++
 drivers/staging/wilc1000/wilc_spi.c     |  7 +++++
 drivers/staging/wilc1000/wilc_wlan_if.h |  7 ++++-
 5 files changed, 26 insertions(+), 44 deletions(-)

-- 
2.7.4
