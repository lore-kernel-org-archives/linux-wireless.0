Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:14807 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730915AbeHAMyE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 08:54:04 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 0/2] staging: wilc1000: fix endianness issues identified by sparse
Date: Wed, 1 Aug 2018 16:40:58 +0530
Message-ID: <1533121860-20820-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180801_130851_995771_AEC77869)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series has changes to fix the sparse warnings & use correct
byte-order conversion. It also includes changes to use correct datatype for
'wid' in cfg struct.

Ajay Singh (2):
  staging: wilc1000: use 'u16' data type for config id parameter
  staging: wilc1000: fix endianness warnings reported by sparse

 drivers/staging/wilc1000/linux_mon.c              |  1 +
 drivers/staging/wilc1000/wilc_sdio.c              |  4 ++--
 drivers/staging/wilc1000/wilc_spi.c               |  8 ++++----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  6 ++++--
 drivers/staging/wilc1000/wilc_wlan.c              | 12 ++++++------
 drivers/staging/wilc1000/wilc_wlan_cfg.c          | 21 ++++++++++-----------
 drivers/staging/wilc1000/wilc_wlan_cfg.h          |  4 ++--
 7 files changed, 29 insertions(+), 27 deletions(-)

-- 
2.7.4
