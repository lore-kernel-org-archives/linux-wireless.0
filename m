Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:2854 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754788AbeDWQeu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 12:34:50 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [RESEND 00/33] staging: wilc1000: code cleanup and checkpatch fixes
Date: Mon, 23 Apr 2018 22:03:02 +0530
Message-ID: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180423_183454_301358_B98C8828)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This resend patch series contains patches from [1] & [2] clubbed together.

[1] https://www.mail-archive.com/linux-wireless@vger.kernel.org/msg43998.html
[2] https://www.mail-archive.com/linux-wireless@vger.kernel.org/msg45006.html

Ajay Singh (33):
  staging: wilc1000: refactor scan() to free kmalloc memory on failure
    cases
  staging: wilc1000: removed unused static variables for gtk and ptk
    information
  staging: wilc1000: remove line over 80 char warnings in
    set_wiphy_params()
  staging: wilc1000: refactor WILC_WFI_p2p_rx() to avoid line over 80
    char
  staging: wilc1000: rename WILC_WFI_p2p_rx & s32Freq to avoid camelCase
  staging: wilc1000: refactor mgmt_tx to fix line over 80 chars
  staging: wilc1000: rename hAgingTimer to avoid camelCase issue
  staging: wilc1000: fix line over 80 char issue in clear_shadow_scan()
  staging: wilc1000: remove line over 80 char in cfg_connect_result()
  staging: wilc1000: remove unused 'struct add_key_params'
  staging: wilc1000: remove line over 80 char warning in few functions
  staging: wilc1000: rename WILC_WFI_wep_key & WILC_WFI_wep_key_len
  staging: wilc1000: rename variable using datatype in their name in
    add_key()
  staging: wilc1000: split add_key() to avoid line over 80 chars
  staging: wilc1000: remove inner block {} and resetting of mode
    variable
  staging: wilc1000: refactor add_key() to avoid duplicated code
  staging: wilc1000: handle error condition in add_key() and remove
    auth_type variable
  staging: wilc1000: use sizeof(variable) for memory allocated to store
    key info
  staging: wilc1000: fix line over 80 chars in change_station()
  staging: wilc1000: rename WID_LOGTerminal_Switch to avoid camelCase
  staging: wilc1000: added identifiers name in function definations
  staging: wilc1000: remove unused macros in wilc module
  staging: wilc1000: remove multiple define used for MAX_SSID_LEN
  staging: wilc1000: remove multiple define for mac connect and
    disconnect
  staging: wilc1000: remove the use of goto label in spi_cmd_complete()
  staging: wilc1000: remove the use of goto label in
    wilc_spi_read_size()
  staging: wilc1000: remove the use of goto label in wilc_spi_read_int()
  staging: wilc1000: remove goto label '_done_' in
    handle_listen_state_expired()
  staging: wilc1000: remove the use of goto label in wilc_init()
  staging: wilc1000: rename goto label '_fail_' linux naming convension
  staging: wilc1000: rename goto labels starting with '_' in
    wilc1000_wlan_init()
  staging: wilc1000: remove the use of goto label in
    wilc_spi_clear_int_ext()
  staging: wilc1000: rename pu32InactiveTime to avoid camelCase issue

 drivers/staging/wilc1000/coreconfigurator.h       |  17 -
 drivers/staging/wilc1000/host_interface.c         |  25 +-
 drivers/staging/wilc1000/host_interface.h         |   3 +-
 drivers/staging/wilc1000/linux_wlan.c             | 120 ++--
 drivers/staging/wilc1000/wilc_sdio.c              |  84 +--
 drivers/staging/wilc1000/wilc_spi.c               |  21 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 824 +++++++++++-----------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   8 +-
 drivers/staging/wilc1000/wilc_wlan.c              |  16 +-
 drivers/staging/wilc1000/wilc_wlan.h              |  28 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |   4 +-
 11 files changed, 562 insertions(+), 588 deletions(-)

-- 
2.7.4
