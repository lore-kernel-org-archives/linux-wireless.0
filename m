Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:46943 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031997AbbKFJhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:37:16 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 00/26] staging: wilc1000: tidy up sdio/spi
Date: Fri, 6 Nov 2015 18:39:57 +0900
Message-ID: <1446802823-22598-1-git-send-email-glen.lee@atmel.com> (sfid-20151106_103724_256660_8734FAC6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wilc1000 sdio has two different files such as wilc_sdio and linux_wlan_sdio.
linux_wlan_sdio is for linux and wilc_sdio is implemented os independently at
the beginning. The drivers is now for LINUX so we will integrate them into one
file like spi.c and sdio.c.
This is first series to tidy up sdio/spi before integrate them.

Glen Lee (26):
  staging: wilc1000: separate hif_sdio and hif_spi into different module
  staging: wilc1000: remove function pointer sdio_cmd52
  staging: wilc1000: remove sdio_cmd52 of wilc_wlan_io_func_t
  staging: wilc1000: remove function pointer sdio_cmd53
  staging: wilc1000: remove sdio_cmd53 of wilc_wlan_io_func_t
  staging: wilc1000: remove function pointer sdio_set_max_speed
  staging: wilc1000: remove sdio_set_max_speed
  staging: wilc1000: remove function pointer sdio_set_default_speed
  staging: wilc1000: remove varialbe sdio_set_default_speed
  staging: wilc1000: call linux_sdio_init instead of io_init
  staging: wilc1000: wilc_spi.c: add prefix wilc in all function name
  staging: wilc1000: remove function pointer spi_tx of wilc_spi_t
  staging: wilc1000: remove function pointer spi_tx of
    wilc_wlan_io_function_t
  staging: wilc1000: remove function pointer spi_rx of wilc_spi_t
  staging: wilc1000: remove function pointer spi_rx of
    wilc_wlan_io_func_t
  staging: wilc1000: remove function pointer spi_trx
  staging: wilc1000: remove spi_trx of wilc_wlan_io_func_t
  staging: wilc1000: remove function pointer spi_max_speed
  staging: wilc1000: remove spi_max_speed of wilc_wlan_io_func_t
  staging: wilc1000: remove function pointer io_init
  staging: wilc1000: remove unused function pointer io_deinit
  staging: wilc1000: linux_sdio_init: remove parameter pv
  staging: wilc1000: linux_spi_init: remove parameter vp
  staging: wilc1000: remove os_context
  staging: wilc1000: change parameter type of hif_init
  staging: wilc1000: remove os_private

 drivers/staging/wilc1000/Makefile          |   6 +-
 drivers/staging/wilc1000/linux_wlan.c      |  16 +--
 drivers/staging/wilc1000/linux_wlan_sdio.c |   2 +-
 drivers/staging/wilc1000/linux_wlan_sdio.h |   2 +-
 drivers/staging/wilc1000/linux_wlan_spi.c  |   2 +-
 drivers/staging/wilc1000/linux_wlan_spi.h  |   2 +-
 drivers/staging/wilc1000/wilc_sdio.c       |  89 +++++++---------
 drivers/staging/wilc1000/wilc_spi.c        | 162 ++++++++++++++---------------
 drivers/staging/wilc1000/wilc_wlan.c       |  40 +++----
 drivers/staging/wilc1000/wilc_wlan.h       |   4 +-
 drivers/staging/wilc1000/wilc_wlan_if.h    |  21 ----
 11 files changed, 146 insertions(+), 200 deletions(-)

-- 
1.9.1

