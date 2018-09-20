Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:40704 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731675AbeITMFe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 08:05:34 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 00/29] staging: wilc1000: avoid static variables and cleanup changes
Date: Thu, 20 Sep 2018 11:53:11 +0530
Message-ID: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180920_082403_034793_9199C13A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains changes to avoid the use of static variables.
Cleanup changes to fix some checkpatch issues and return void for function
if their return value is not used.
Also deleted 'wilc_debugfs.c' file as it's not used

Changes since v1:
   Address Dan's comment for patch#29
    - return the correct error for failure in the second iteration.


Ajay Singh (29):
  staging: wilc1000: change return type to 'void' for
    wilc_frame_register()
  staging: wilc1000: change return type to 'void' for
    wilc_wlan_set_bssid()
  staging: wilc1000: change return type to 'void' for lock init & deinit
    functions
  staging: wilc1000: change return type to 'void' for
    wilc_deinit_host_int()
  staging: wilc1000: change return type to 'void' for
    wilc_wfi_deinit_mon_interface()
  staging: wilc1000: use 'void' return type for
    host_int_get_assoc_res_info()
  staging: wilc1000: use 'void' return for wilc_wlan_txq_add_to_head()
  staging: wilc1000: change return type to 'void' tcp ack filter
    functions
  staging: wilc1000: use 'void' return for
    wilc_wlan_txq_filter_dup_tcp_ack()
  staging: wilc1000: change return type to 'void' for
    wilc_wlan_cfg_indicate_rx()
  staging: wilc1000: refactor wilc_wlan_parse_info_frame() function
  staging: wilc1000: set default value of cfg response type in
    wilc_wlan_cfg_indicate_rx()
  staging: wilc1000: changes 'val' type to u8 in wilc_cfg_byte struct
  staging: wilc1000: remove unused wid type values
  staging: wilc1000: remove unused wid from cfg struct
  staging: wilc1000: refactor code to remove 'mac_status' from
    'wilc_mac_cfg' struct
  staging: wilc1000: refactor code to avoid static variables for config
    parameters
  staging: wilc1000: rename 'wilc_mac_cfg' struct to 'wilc_cfg_str_vals'
  staging: wilc1000: avoid the use of 'hif_driver_comp' completion
    variable
  staging: wilc1000: remove use of unnecessary 'wilc_connected_ssid'
    variable
  staging: wilc1000: avoid use of 'g_sdio' static variable
  staging: wilc1000: avoid use of 'g_spi' static variable
  staging: wilc1000: remove unnecessary memset in sdio_init() &
    wilc_spi_init()
  staging: wilc1000: remove p2p related static variables to wilc_vif
    struct
  staging: wilc1000: remove wilc_debugfs.c file as its not used
  staging: wilc1000: remove unnecessary option used with ccflags-y in
    Makefile
  staging: wilc1000: use usleep_range() in place of udelay()
  staging: wilc1000: avoid spaces preferred around checkpatch issue
  staging: wilc1000: return exact error of register_netdev() from
    wilc_netdev_init()

 drivers/staging/wilc1000/Makefile                 |   5 +-
 drivers/staging/wilc1000/host_interface.c         |  64 ++---
 drivers/staging/wilc1000/host_interface.h         |   6 +-
 drivers/staging/wilc1000/linux_mon.c              |   3 +-
 drivers/staging/wilc1000/linux_wlan.c             |  46 ++--
 drivers/staging/wilc1000/wilc_debugfs.c           | 115 ---------
 drivers/staging/wilc1000/wilc_sdio.c              |  56 +++--
 drivers/staging/wilc1000/wilc_spi.c               |  57 +++--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  90 +++----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |   4 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  14 +-
 drivers/staging/wilc1000/wilc_wlan.c              |  44 ++--
 drivers/staging/wilc1000/wilc_wlan.h              |   3 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.c          | 294 +++++++++-------------
 drivers/staging/wilc1000/wilc_wlan_cfg.h          |  26 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |   4 -
 16 files changed, 331 insertions(+), 500 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/wilc_debugfs.c

-- 
2.7.4
