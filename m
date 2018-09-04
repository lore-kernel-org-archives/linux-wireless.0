Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:26094 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbeIDLDa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 07:03:30 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 00/26] staging: wilc1000: avoid use of static and global variable
Date: Tue, 4 Sep 2018 12:09:16 +0530
Message-ID: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180904_083951_979709_199E99F3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set mainly contains changes to avoid the use of static
and global variables. Also contains few patch to avoid the checkpatch
warning arise due to code refactor.

Changes since v1:
 1. rework on patch#10, use dynamically allocating memory to maintain
    multicast mac address filter list.
 2. rework on patch#11, only move hif_workqueue to 'wilc' struct.
 3. dropped patch#12 of previous patchset version.
 4. modified patch#18 & #19 as per the review comments.
 5. patch#22, change 'int' to 'bool' type for 'connecting' variable.
 6. added 3 new patches #24,25 &26 in this series.


Ajay Singh (26):
  staging: wilc1000: move 'wilc_enable_ps' global variable into 'wilc'
    struct
  staging: wilc1000: move 'aging_timer' static variable to wilc_priv
    struct
  staging: wilc1000: fix to use correct index to free scanned info in
    clear_shadow_scan()
  staging: wilc1000: remove unnecessary NULL check in
    clear_shadow_scan()
  staging: wilc1000: moved last_scanned_shadow & last_scanned_cnt to
    wilc_priv struct
  staging: wilc1000: move during_ip_timer & wilc_optaining_ip to
    'wilc_vif' struct
  staging: wilc1000: remove unused variable 'op_ifcs'
  staging: wilc1000: avoid use of extra 'if' condition in wilc_init()
  staging: wilc1000: move static variable clients_count to 'wilc'
    structure
  staging: wilc1000: refactor code to avoid use of
    wilc_set_multicast_list global
  staging: wilc1000: move hif_workqueue static variables to 'wilc'
    structure
  staging: wilc1000: move 'periodic_rssi' as part of 'wilc_vif' struct
  staging: wilc1000: rename 'dummy_statistics' variable to
    'periodic_stat'
  staging: wilc1000: move 'rcv_assoc_resp' as part of hif_drv
  staging: wilc1000: refactor tcp_process() to avoid extra leading tabs
  staging: wilc1000: use lowercase for get_BSSID() and HIL variable
  staging: wilc1000: move tcp_ack_filter algo related variables to
    'wilc_vif' struct
  staging: wilc1000: avoid line over 80 chars in
    wilc_wlan_txq_filter_dup_tcp_ack()
  staging: wilc1000: use short names to fix over 80 issue in
    tcp_process()
  staging: wilc1000: remove unused code to set and get IP address
  staging: wilc1000: move 'chip_ps_state' static variable as part of
    'wilc' struct
  staging: wilc1000: move 'wilc_connecting' static variable to
    'wilc_vif' struct
  staging: wilc1000: remove unnecessary static variable
    'p2p_listen_state'
  staging: wilc1000: refactor code to move initilization in
    wilc_netdev_init()
  staging: wilc1000: refactor wilc_netdev_init() to handle memory free
    in error path
  staging: wilc1000: remove handle_hif_exit_work() function

 drivers/staging/wilc1000/coreconfigurator.c       |   4 +-
 drivers/staging/wilc1000/host_interface.c         | 215 ++++------------------
 drivers/staging/wilc1000/host_interface.h         |  13 +-
 drivers/staging/wilc1000/linux_wlan.c             |  79 +++++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 197 ++++++++++----------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  41 ++++-
 drivers/staging/wilc1000/wilc_wlan.c              | 174 ++++++++---------
 drivers/staging/wilc1000/wilc_wlan.h              |   5 +-
 8 files changed, 307 insertions(+), 421 deletions(-)

-- 
2.7.4
