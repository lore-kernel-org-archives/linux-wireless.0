Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:22845 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbbJTF1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 01:27:18 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 00/12] WILC1000 V2 for the g_linux_wlan
Date: Tue, 20 Oct 2015 14:26:44 +0900
Message-ID: <1445318816-21686-1-git-send-email-tony.cho@atmel.com> (sfid-20151020_072721_673210_CEC3A9EB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The series of V2 restore the global variable, wl to g_linux_wlan which is its
original name becasue it will be replaced with local structure and deleted.

Tony Cho (12):
  staging: wilc1000: change the type of wilc1000_initialized
  staging: wilc1000: rename u8NoIfcs in the struct wilc
  staging: wilc1000: rename strInterfaceInfo in the sturct wilc
  staging: wilc1000: rename aSrcAddress in the struct wilc_vif
  staging: wilc1000: rename aBSSID in the sturct wilc_vif
  staging: wilc1000: rename drvHandler in the struct wilc_vif
  staging: wilc1000: rename wilc_netdev in the struct wilc_vif
  staging: wilc1000: move clean up codes into wl_wlan_cleanup function
  staging: wilc1000: rename wilc_firmware in the struct wilc
  staging: wilc1000: remove COMPLEMENT_BOOT
  staging: wilc1000: introduce struct wilc_sdio for sdio data
  staging: wilc1000: assign pointer of g_linux_wlan to sdio device data

 drivers/staging/wilc1000/linux_wlan.c             | 331 +++++++---------------
 drivers/staging/wilc1000/linux_wlan_sdio.c        |  33 ++-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  87 +++---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  19 +-
 drivers/staging/wilc1000/wilc_wlan.c              |  18 --
 5 files changed, 169 insertions(+), 319 deletions(-)

-- 
1.9.1

