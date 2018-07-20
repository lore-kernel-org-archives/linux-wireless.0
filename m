Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:5049 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbeGTMuM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jul 2018 08:50:12 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <linus.walleij@linaro.org>, Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 0/4] staging: wilc1000: make use of descriptor-based interface for GPIO
Date: Fri, 20 Jul 2018 17:31:34 +0530
Message-ID: <1532088098-8483-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180720_140221_231133_E90F1E6E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains changes mainly related to make use of
descriptor-based interface instead of integer-based interface for GPIO.
Modified the compatible string to use 'microchip' instead of 'atmel' prefix.
Also added the DT binding reference file.

This patch is created on top of [1] patch series.

[1]. https://www.spinics.net/lists/linux-wireless/msg175360.html

Ajay Singh (4):
  staging: wilc1000: remove gpio parameter from wilc_netdev_init()
  staging: wilc1000: rename variable from 'gpio' to 'gpio_irq'
  staging: wilc1000: change compatible string from atmel to microchip
  staging: wilc1000: use descriptor-based interface for GPIO

 drivers/staging/wilc1000/TODO                      |  4 ---
 drivers/staging/wilc1000/linux_wlan.c              | 42 +++++++++-------------
 .../staging/wilc1000/microchip,wilc1000,sdio.txt   | 32 +++++++++++++++++
 .../staging/wilc1000/microchip,wilc1000,spi.txt    | 26 ++++++++++++++
 drivers/staging/wilc1000/wilc_sdio.c               | 38 ++++++++++++++------
 drivers/staging/wilc1000/wilc_spi.c                | 40 +++++++++++++--------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h      |  5 +--
 7 files changed, 130 insertions(+), 57 deletions(-)
 create mode 100644 drivers/staging/wilc1000/microchip,wilc1000,sdio.txt
 create mode 100644 drivers/staging/wilc1000/microchip,wilc1000,spi.txt

-- 
2.7.4
