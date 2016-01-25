Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40662 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbcAYHmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 02:42:09 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 00/26] use unified firmware and add ops in cfg
Date: Mon, 25 Jan 2016 16:35:04 +0900
Message-ID: <1453707330-13526-1-git-send-email-glen.lee@atmel.com> (sfid-20160125_084212_997472_2D75B776)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains                                                      
* support suspend and resume functionality                                      
* use a unified firmware for all mode of operations(station, ap, p2p)           
* support Station/AP concurrency                                                
* increase link speed                                                           
* add a cfg operation for adjusting the tx power                                
* fix bug on p2p, WEP security and chaning virtual interface

Changes in V2: details in each patch files.
 - 0004-staging-wilc1000-add-sdio-resume-suspend.patch
 - 0006-staging-wilc1000-add-ops-resuem-suspend-wakeup-in-cf.patch
 - 0009-staging-wilc1000-use-unified-firmware.patch
 - 0015-staging-wilc1000-wilc_set_wfi_drv_handler-add-mac-in.patch
 - 0021-staging-wilc1000-increase-link-speed.patch
 - 0024-staging-wilc1000-add-ops-tx-power-in-cfg80211.patch

Glen Lee (26):
  staging: wilc1000: fix bug when changing virtual interface
  staging: wilc1000: remove define WILC_OPTIMIZE_SLEEP_INT
  staging: wilc1000: support suspend/resume functionality
  staging: wilc1000: add sdio resume/suspend
  staging: wilc1000: sdio_init: add resume argument
  staging: wilc1000: add ops resuem/suspend/wakeup in cfg80211
  staging: wilc1000: remove sleep and reduce close timeout
  staging: wilc1000: get address from wilc
  staging: wilc1000: use unified firmware
  staging: wilc1000: remove wilc_set_machw_change_vir_if
  staging: wilc1000: set bssid with mode
  staging: wilc1000: set proper bssid address
  staging: wilc1000: change_virtual_intf: change codes for unified
    firmware
  staging: wilc1000: call power save after changing mode
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

 drivers/staging/wilc1000/Makefile                 |   6 +-
 drivers/staging/wilc1000/host_interface.c         | 250 ++++++++--------
 drivers/staging/wilc1000/host_interface.h         |   9 +-
 drivers/staging/wilc1000/linux_wlan.c             |  87 +++---
 drivers/staging/wilc1000/wilc_sdio.c              | 102 ++++++-
 drivers/staging/wilc1000/wilc_spi.c               |   2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 348 +++++++---------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   8 +-
 drivers/staging/wilc1000/wilc_wlan.c              | 202 ++++---------
 drivers/staging/wilc1000/wilc_wlan.h              |  10 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |   3 +-
 11 files changed, 437 insertions(+), 590 deletions(-)

-- 
1.9.1

