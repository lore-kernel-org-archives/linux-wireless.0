Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:57870 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbeHNJgK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 05:36:10 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 00/24] staging: wilc1000: avoid use of static and global variable
Date: Tue, 14 Aug 2018 12:19:52 +0530
Message-ID: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180814_085024_985568_2E18F33D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set mainly contains changes to avoid the use of static
and global variables. Also contains few patch to avoid the checkpatch
warning arise due to code refactor.

Ajay Singh (24):
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
  staging: wilc1000: move wilc_multicast_mac_addr_list to 'wilc_vif'
    struct
  staging: wilc1000: move hif specific static variables to 'wilc'
    structure
  staging: wilc1000: move static variable 'terminated_handle' to
    wilc_vif struct
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
  staging: wilc1000: avoid line over 80 chars in tcp_process()
  staging: wilc1000: remove unused code to set and get IP address
  staging: wilc1000: move 'chip_ps_state' static variable as part of
    'wilc' struct
  staging: wilc1000: move 'wilc_connecting' static variable to
    'wilc_vif' struct
  staging: wilc1000: remove unnecessary static variable
    'p2p_listen_state'

 drivers/staging/wilc1000/coreconfigurator.c       |   4 +-
 drivers/staging/wilc1000/host_interface.c         | 227 +++++-----------------
 drivers/staging/wilc1000/host_interface.h         |   9 +-
 drivers/staging/wilc1000/linux_wlan.c             |  29 ++-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 191 +++++++++---------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  47 ++++-
 drivers/staging/wilc1000/wilc_wlan.c              | 167 ++++++++--------
 drivers/staging/wilc1000/wilc_wlan.h              |   3 +-
 8 files changed, 284 insertions(+), 393 deletions(-)

-- 
2.7.4
