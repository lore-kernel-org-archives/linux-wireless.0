Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:5534 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756000AbeDYRTW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 13:19:22 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 00/21] staging: wilc1000: remove unused code and reorder functions 
Date: Wed, 25 Apr 2018 22:48:05 +0530
Message-ID: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180425_191932_460216_51B0792D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains fixes to remove the unused code. It also has patches
to reorganize the function and simplify the function logic.

Ajay Singh (21):
  staging: wilc1000: replace crc7_byte() with inline macro CRC7_BYTE
  staging: wilc1000: align the #define in wilc_spi file
  staging: wilc1000: remove unnecessary assingment from 'if' conditions
  staging: wilc1000: remove 'cmd' variable in wilc_spi functions
  staging: wicl1000: removed the unsed variables in
    wilc_parse_network_info()
  staging: wilc1000: remove inner {} in wilc_parse_network_info()
  staging: wilc1000: simplified if conditions in spi_data_write()
  staging: wilc1000: remove unused variable scan_while_connected
  staging: wilc1000: remove unsed typedef wilc_debug_func
  staging: wilc1000: remove used #define HIF_SDIO_GPIO_IRQ
  staging: wilc1000: remove unused #define related to MAC status
  staging: wilc1000: rename mac status macros and moved related #define
    together
  staging: wilc1000: rename WILC_WFI_stats to avoid uppercase
  staging: wilc1000: rename num_reg_frame macro to have uppercase in
    macro name
  staging: wilc1000: rename wlan init and deinit function prefixed with
    wil1000
  staging: wilc1000: remove unused elements in 'wilc_priv' struct
  staging: wilc1000: remove unused enum 'stats_flags'
  staging: wilc1000: rename P2P_LISTEN_STATE variable to use lowercase
  staging: wilc1000: remove inner block '{}' in handle_remain_on_chan()
  staging: wilc1000: change function to static in linux_wlan
  staging: wilc1000: reorder functions to avoid forward declaration in
    linux_wlan

 drivers/staging/wilc1000/coreconfigurator.c       |  84 +++++++--------
 drivers/staging/wilc1000/host_interface.c         |  64 ++++--------
 drivers/staging/wilc1000/linux_wlan.c             | 122 ++++++++++------------
 drivers/staging/wilc1000/wilc_sdio.c              |  12 +--
 drivers/staging/wilc1000/wilc_spi.c               |  70 ++++++-------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |   2 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  23 +---
 drivers/staging/wilc1000/wilc_wlan.h              |   7 --
 drivers/staging/wilc1000/wilc_wlan_if.h           |  11 +-
 9 files changed, 158 insertions(+), 237 deletions(-)

-- 
2.7.4
