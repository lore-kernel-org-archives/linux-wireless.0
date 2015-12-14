Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13577 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbbLNFnR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 00:43:17 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 00/12] Use index of interface to communicate with wilc device
Date: Mon, 14 Dec 2015 14:46:51 +0900
Message-ID: <1450072023-13013-1-git-send-email-glen.lee@atmel.com> (sfid-20151214_064349_950465_A12147A6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wilc device now use index of wfidrv_list which is list of host_if_drv pointers.
Each host_if_drv correspond with each wilc_vif interface, so we can use index
of vif. Therefore, so no need to make another list, wfidrv_list, to lookup
which interface the device is communicating.

Here are brief steps,
Firstly, Pass wilc_vif, currently being used, as msg argument to host interface
thread to use index of vif.
Secondly, Remove argument hif_drv since wilc_vif has it in it's member.
Thirdly, use index of vif to communicate with wilc device.
Lastly, remove unused structure and functions related with wfidrv_list
because it is not used anymore.

Last patch is bug fix which was found during patching this.

Glen Lee (12):
  staging: wilc1000: pass vif to hostIFthread
  staging: wilc1000: remove argument hif_drv
  staging: wilc1000: take vif instead of drv in hostIFthread
  staging: wilc1000: pass struct wilc
  staging: wilc1000: use vif index to communicate with wilc device
  staging: wilc1000: wilc_set_wfi_drv_handler: pass vif index
  staging: wilc1000: change join_req_drv type and it's name
  staging: wilc1000: remove used functions
  staging: wilc1000: remove drv of struct host_if_msg
  staging: wilc1000: remove wilc of struct host_if_drv
  staging: wilc1000: set hif_drv before it is used
  staging: wilc1000: bug fix on memory free

 drivers/staging/wilc1000/coreconfigurator.h       |  11 +-
 drivers/staging/wilc1000/host_interface.c         | 790 +++++++++++-----------
 drivers/staging/wilc1000/host_interface.h         | 144 ++--
 drivers/staging/wilc1000/linux_wlan.c             |  23 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 265 ++++----
 drivers/staging/wilc1000/wilc_wlan.c              |   3 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.c          |   9 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.h          |   4 +-
 8 files changed, 643 insertions(+), 606 deletions(-)

-- 
1.9.1

