Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:42486 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752357AbeEKINv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 04:13:51 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 00/30] staging: wilc1000: checkpatch fixes and code cleanup
Date: Fri, 11 May 2018 13:43:01 +0530
Message-ID: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180511_101357_420436_E85AE4FA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains modification to remove checkpatch related issues,
mainly related to 'line over 80 chars'.

Also code cleanup related change to follow as per linux coding style are
included in this patch series.

changes from v1:
- Dropped patch#5 and add a new patch #30 to address its review comments.
- Included changes for patch# 13, 15, 28 & 30 based on review comments
	please refer patch# 12, 14, 27 & 29 in current updates series because
	one patch is dropped in between.
- Corrected commit summary and description for patch#8 & #26 in updates series.

Ajay Singh (30):
  staging: wilc1000: added complete() call for error scenario in
    handle_key()
  staging: wilc1000: remove 'ret' variable in handle_key()
  staging: wilc1000: fix line over 80 chars in handle_key()
  staging: wilc1000: fix line over 80 characters issue in
    handle_connect()
  staging: wilc1000: fix line over 80 chars issue in
    host_int_handle_disconnect()
  staging: wilc1000: fix line over 80 characters in
    host_int_parse_join_bss_param()
  staging: wilc1000: fix line over 80 chars in
    host_int_parse_assoc_resp_info()
  staging: wilc1000: replace kmalloc with kmemdup() in
    handle_connect_timeout()
  staging: wilc1000: fix line over 80 chars in linux_mon
  staging: wilc1000: use sizeof(*wdev) to allocate memory in
    wilc_wfi_cfg_alloc()
  staging: wilc1000: use kmalloc(sizeof(*mgmt_tx)...) in mgmt_tx()
  staging: wilc1000: rename clear_duringIP() to avoid camelCase issue
  staging: wilc1000: fix line over 80 chars in add_network_to_shadow()
  staging: wilc1000: use kmemdup instead of kmalloc in
    add_network_to_shadow()
  staging: wilc1000: fix line over 80 charas in
    wilc_wfi_remain_on_channel_expired()
  staging: wilc1000: fix line over 80 chars in
    wilc_wfi_cfg_tx_vendor_spec()
  staging: wilc1000: fix line over 80 chars in get_station()
  staging: wilc1000: fix line over 80 chars in wilc_create_wiphy()
    declaration
  staging: wilc1000: fix line over 80 characters in add_key()
  staging: wilc1000: fix line over 80 chars in scan()
  staging: wilc1000: fix line over 80 chars issue in connect()
  staging: wilc1000: rename u8security to avoid datatype in variable
    name
  staging: wilc1000: refactor del_station() to avoid parenthesis
    misalignment
  staging: wilc1000: fix line over 80 chars in wilc_sdio struct
  staging: wilc1000: added #define for setting radiotap header
  staging: wilc1000: remove 'flag' argument from wilc_mac_indicate()
  staging: wilc1000: added comments for mutex and spinlock_t
  staging: wilc1000: remove unused 'lock' varible in 'wilc_priv'
    structure
  staging: wilc1000: remove s8idxarray to avoid datatype in variable
    name
  staging: wilc1000: refactor host_int_parse_assoc_resp_info() to remove
    unused code

 drivers/staging/wilc1000/coreconfigurator.c       |  51 +--
 drivers/staging/wilc1000/coreconfigurator.h       |  10 +-
 drivers/staging/wilc1000/host_interface.c         | 398 +++++++++++-----------
 drivers/staging/wilc1000/host_interface.h         |   2 +-
 drivers/staging/wilc1000/linux_mon.c              |  25 +-
 drivers/staging/wilc1000/linux_wlan.c             |  17 +-
 drivers/staging/wilc1000/wilc_sdio.c              |   3 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 190 ++++++-----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |   3 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   8 +-
 drivers/staging/wilc1000/wilc_wlan.c              |   7 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |   3 -
 12 files changed, 341 insertions(+), 376 deletions(-)

-- 
2.7.4
