Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:9117 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793AbcBDJWu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:22:50 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 00/70] staging: wilc1000: rebase and resend
Date: Thu, 4 Feb 2016 18:15:17 +0900
Message-ID: <1454577387-509-1-git-send-email-glen.lee@atmel.com> (sfid-20160204_102258_734421_2570F219)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I rebased all the pending patches which are not accepted yet and resend them.

Chris Park (13):
  staging: wilc1000: fix warnings for line over 80 characters
  staging: wilc1000: remove useless log message
  staging: wilc1000: remove useless function
  staging: wilc1000: remove unnecessary braces
  staging: wilc1000: remove warnings missing a blank line after
    declarations
  staging: wilc1000: Optimize code of wilc_get_chipid function
  staging: wilc1000: remove unused log message using the CORECONFIG_DBG
    tag
  staging: wilc1000: remove unused log message using the HOSTINF_DBG tag
  staging: wilc1000: remove unused log message using the TX_DBG tag
  staging: wilc1000: remove unnecessary wilc_rx_complete function
  staging: wilc1000: remove unused log message using the RX_DBG tag
  staging: wilc1000: remove unused debug tag
  staging: wilc1000: remove unnecessary log message using GENERIC_DBG
    tag

Glen Lee (14):
  staging: wilc1000: wilc_set_wfi_drv_handler: add mac index
  staging: wilc1000: remove unused functions
  staging: wilc1000: ignore power save
  staging: wilc1000: handle connecting error
  staging: wilc1000: tcp_process: fix a build warning
  staging: wilc1000: remove define TCP_ACK_FILTER
  staging: wilc1000: increase link speed
  staging: wilc1000: disable power save when AP mode
  staging: wilc1000: fix bug on p2p connection
  staging: wilc1000: add ops tx power in cfg80211
  staging: wilc1000: fix WEP security bug
  staging: wilc1000: get mac address after setting drv handler
  staging: wilc1000: move wilc_send_config_pkt to wilc_wlan.c
  staging: wilc1000: pass vif to wilc_send_config_pkt

Leo Kim (43):
  staging: wilc1000: rename hWILCWFIDrv of wilc_priv structure
  staging: wilc1000: fixes missing a blank line after declarations
  staging: wilc1000: rename pBssid of tx_complete_data structure
  staging: wilc1000: remove warnings line over 80 characters
  staging: wilc1000: removes unnecessary debug logs
  staging: wilc1000: replaces PRINT_XXX with netdev_xxx
  staging: wilc1000: removes void function return
  staging: wilc1000: renames u8IfIdx of wilc_vif structure
  staging: wilc1000: fixes variable dereferenced before check
  staging: wilc1000: wilc_parse_network_info(): renames function
    variables
  staging: wilc1000: wilc_parse_network_info(): renames local variables
  staging: wilc1000: wilc_parse_network_info(): renames local inner
    variables
  staging: wilc1000: rename variable s32Error
  staging: wilc1000: wilc_parse_assoc_resp_info(): renames function
    variables
  staging: wilc1000: wilc_parse_assoc_resp_info(): renames local
    variables
  staging: wilc1000: wilc_dealloc_assoc_resp_info(): renames function
    variables
  staging: wilc1000: wilc_dealloc_network_info(): renames function
    variables
  staging: wilc1000: wilc_wfi_cfgoperations.c: replaces PRINT_ER with
    netdev_err
  staging: wilc1000: wilc_msgqueue.c: removes debug print log
  staging: wilc1000: wilc_wlan.c: replaces PRINT_ER with netdev_err
  staging: wilc1000: linux_mon.c: replaces PRINT_ER with netdev_err
  staging: wilc1000: removes function 'wilc_dealloc_network_info()'
  staging: wilc1000: removes function 'wilc_dealloc_assoc_resp_info()'
  staging: wilc1000: remove typedef from tstrConnectRespInfo
  staging: wilc1000: renames struct connect_resp_info variables
  staging: wilc1000: remove typedef from pstrNetworkInfo
  staging: wilc1000: renames s8rssi of connect_resp_info structure
  staging: wilc1000: renames u16CapInfo of connect_resp_info structure
  staging: wilc1000: renames au8ssid of connect_resp_info structure
  staging: wilc1000: renames u8SsidLen of connect_resp_info structure
  staging: wilc1000: renames au8bssid of connect_resp_info structure
  staging: wilc1000: renames u16BeaconPeriod of connect_resp_info
    structure
  staging: wilc1000: renames u8DtimPeriod of connect_resp_info structure
  staging: wilc1000: renames u8channel of connect_resp_info structure
  staging: wilc1000: renames struct connect_resp_info variables
  staging: wilc1000: renames bNewNetwork of connect_resp_info structure
  staging: wilc1000: renames u8Found of connect_resp_info structure
  staging: wilc1000: renames u32Tsf of connect_resp_info structure
  staging: wilc1000: renames struct connect_resp_info variables
  staging: wilc1000: renames pJoinParams of connect_resp_info structure
  staging: wilc1000: renames strRssi of connect_resp_info structure
  staging: wilc1000: renames u64Tsf of connect_resp_info structure
  staging: wilc1000: remove warnings line over 80 characters

 drivers/staging/wilc1000/Makefile                 |   1 -
 drivers/staging/wilc1000/coreconfigurator.c       | 251 +++------
 drivers/staging/wilc1000/coreconfigurator.h       |  73 ++-
 drivers/staging/wilc1000/host_interface.c         | 633 +++++++---------------
 drivers/staging/wilc1000/host_interface.h         |  13 +-
 drivers/staging/wilc1000/linux_mon.c              |  30 +-
 drivers/staging/wilc1000/linux_wlan.c             | 424 ++++++---------
 drivers/staging/wilc1000/linux_wlan_common.h      |  27 +-
 drivers/staging/wilc1000/wilc_debugfs.c           |   7 +-
 drivers/staging/wilc1000/wilc_msgqueue.c          |  18 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 481 ++++++++--------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   8 +-
 drivers/staging/wilc1000/wilc_wlan.c              | 355 +++++-------
 drivers/staging/wilc1000/wilc_wlan.h              |  10 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.c          |  16 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |  14 +-
 16 files changed, 883 insertions(+), 1478 deletions(-)

-- 
1.9.1

