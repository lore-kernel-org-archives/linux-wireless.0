Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44107 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbbGaHiz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:38:55 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 00/28] removing the compile warnings for 64-bit
Date: Fri, 31 Jul 2015 16:38:08 +0900
Message-ID: <1438328316-30197-1-git-send-email-tony.cho@atmel.com> (sfid-20150731_093858_895684_AFC3CD34)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,
This patch focuses on removing the compile warnings for 64bit incompatability.
Most warnings are due to senseless type castings from driver handler to u32 and
also to void pointers. They are removed by using the same handler with this
series of patch. All warnings disappear.

This patch is the first step to resolve many issues which the driver contains.
Please review and advise me.

Thanks,
Tony.

glen lee (28):
  staging: wilc1000: change type of driver handler in host interface msg
  staging: wilc1000: change void type of argument with WILC_WFIDrvHandle
  staging: wilc1000: move structure WILC_WFIDrvHandle into
    wilc_wlan_if.h
  staging: wilc1000: change type of argument 5 in SendConfigPkt
  staging: wilc1000: remove unnecessary type cast
  staging: wilc1000: chage driver handler variable in SendConfigPkt
  staging: wilc1000: remove unused variables
  staging: wilc1000: change drvHandler type in wlan_cfg_get
  staging: wilc1000: change drvHandler type in wlan_cfg_set
  staging: wilc1000: change driver handle variable
  staging: wilc1000: fix incompatible type in assignment warning
  staging: wilc1000: change type of driver handler in tstrInterfaceInfo
  staging: wilc1000: change type of argument in
    host_int_set_wfi_drv_handler
  staging: wilc1000: remove unnecessary type cast in
    host_int_set_wfi_drv_handler
  staging: wilc1000: fix cast from pointer to integer warning
  staging: wilc1000: change type of variable
  staging: wilc1000: fix comparison between different type warning
  staging: wilc1000: change pstrWFIDrv with drvHandler
  staging: wilc1000: change type of variable in tstrHostIfSetDrvHandler
  staging: wilc1000: remove unnecessary type case
  staging: wilc1000: remove unwanted type cast
  staging: wilc1000: fix passing argument from incompatible type warning
  staging: wilc1000: change type of parameter in wilc_wlan_cfg_commit
  staging: wilc1000: fix cast from pointer to integer warning
  staging: wilc1000: change cast type from pointer to uintptr_t
  staging: wilc1000: remove unused variable
  staging: wilc1000: fix casting build warning
  staging: wilc1000: change data type of variable

 drivers/staging/wilc1000/coreconfigurator.c       |   2 +-
 drivers/staging/wilc1000/coreconfigurator.h       |   2 +-
 drivers/staging/wilc1000/host_interface.c         | 232 ++++++++++------------
 drivers/staging/wilc1000/host_interface.h         |   9 +-
 drivers/staging/wilc1000/linux_wlan.c             |   8 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |   4 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   2 +-
 drivers/staging/wilc1000/wilc_wlan.c              |   8 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |   8 +-
 9 files changed, 130 insertions(+), 145 deletions(-)

-- 
1.9.1

