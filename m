Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:6278 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753668AbeDRLkY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 07:40:24 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 00/22] staging: wilc1000: cleanup patches to follow linux coding style
Date: Wed, 18 Apr 2018 17:09:02 +0530
Message-ID: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180418_134027_753687_8A7ED488)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series is based on top of
"[PATCH 00/11] staging: wilc1000: fix for checkpatch and handled
malloc memory properly" and its not applied yet.[1]

In this series contains fixes to avoid the checkpatch reported issue.
Also remove the multiple #define for same macros and changes to
follow linux coding style.

[1] https://www.mail-archive.com/linux-wireless@vger.kernel.org/msg43998.html

Ajay Singh (22):
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

 drivers/staging/wilc1000/coreconfigurator.h       |  17 --
 drivers/staging/wilc1000/host_interface.c         |  25 +--
 drivers/staging/wilc1000/host_interface.h         |   3 +-
 drivers/staging/wilc1000/linux_wlan.c             | 118 +++++-----
 drivers/staging/wilc1000/wilc_sdio.c              |  84 ++++----
 drivers/staging/wilc1000/wilc_spi.c               |  21 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 250 +++++++++++-----------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   8 +-
 drivers/staging/wilc1000/wilc_wlan.c              |  16 +-
 drivers/staging/wilc1000/wilc_wlan.h              |  26 +--
 drivers/staging/wilc1000/wilc_wlan_if.h           |   4 +-
 11 files changed, 268 insertions(+), 304 deletions(-)

-- 
2.7.4
