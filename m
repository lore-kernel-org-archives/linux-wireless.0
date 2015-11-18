Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20436 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbbKRGIT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 01:08:19 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 00/16] tidy up sdio/spi module and remove wilc_dev
Date: Wed, 18 Nov 2015 15:11:21 +0900
Message-ID: <1447827097-9436-1-git-send-email-glen.lee@atmel.com> (sfid-20151118_070826_837677_DC08C337)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series removes global variable wilc_dev and tidy up sdio/spi
modules. I sync with arnd's latest patch series because this work depends
on his patches.

Glen Lee (16):
  staging: wilc1000: remove sdio speed control codes
  staging: wilc1000: remove spi speed control codes
  staging: wilc1000: remove paltform define PLAT_WMS8304
  staging: wilc1000: pass struct wilc to the functions which use
    hif_func
  staging: wilc1000: pass wilc to all function pointers of wilc_hif_func
  staging: wilc1000: wilc_sdio_cmd52: pass struct wilc
  staging: wilc1000: wilc_sdio_cmd53: pass struct wilc
  staging: wilc1000: wilc_spi_write: pass struct wilc
  staging: wilc1000: wilc_spi_read: pass struct wilc
  staging: wilc1000: wilc_spi_write_read: pass struct wilc
  staging: wilc1000: add struct wilc to host_if_drv
  staging: wilc1000: wilc_send_config_pkt: pass struct wilc
  staging: wilc1000: wilc_wlan_cfg_set: pass struct wilc
  staging: wilc1000: wilc_wlan_cfg_get: pass struct wilc
  staging: wilc1000: wilc_dbg: remove wilc
  staging: wilc1000: use wilc instead of wilc_dev and remove wilc_dev

 drivers/staging/wilc1000/coreconfigurator.c   |   7 +-
 drivers/staging/wilc1000/coreconfigurator.h   |   3 +-
 drivers/staging/wilc1000/host_interface.c     | 133 +++++++-------
 drivers/staging/wilc1000/host_interface.h     |   2 +
 drivers/staging/wilc1000/linux_wlan.c         | 123 ++++++-------
 drivers/staging/wilc1000/linux_wlan_sdio.c    |  60 +------
 drivers/staging/wilc1000/linux_wlan_sdio.h    |   7 +-
 drivers/staging/wilc1000/linux_wlan_spi.c     | 215 +----------------------
 drivers/staging/wilc1000/linux_wlan_spi.h     |   9 +-
 drivers/staging/wilc1000/wilc_sdio.c          | 150 ++++++++--------
 drivers/staging/wilc1000/wilc_spi.c           | 142 +++++++--------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |   3 +-
 drivers/staging/wilc1000/wilc_wlan.c          | 244 +++++++++++++-------------
 drivers/staging/wilc1000/wilc_wlan.h          |  37 ++--
 drivers/staging/wilc1000/wilc_wlan_if.h       |   3 +-
 15 files changed, 447 insertions(+), 691 deletions(-)

-- 
1.9.1

