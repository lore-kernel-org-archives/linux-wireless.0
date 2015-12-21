Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11099 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbbLUFPD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:15:03 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 00/46] Rebase and resend
Date: Mon, 21 Dec 2015 14:18:04 +0900
Message-ID: <1450675130-17866-1-git-send-email-glen.lee@atmel.com> (sfid-20151221_061508_268033_0D873D78)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As requested, I rebased all of my pending patches on staging-testing branch
and resend what is not applied.

Glen Lee (42):
  staging: wilc1000: remove define COMPLEMENT_BOOT
  staging: wilc1000: remove wilc memory allocation config
  staging: wilc1000: rename index to tcp_pending_ack_idx
  staging: wilc1000: use kernel define byte order macros
  staging: wilc1000: wilc_wlan.c: remove hif_func of wilc_wlan_dev_t
  staging: wilc1000: remove io_type of wilc_wlan_dev_t
  staging: wilc1000: remove unused varialbe tx_buffer_offset
  staging: wilc1000: move all of wilc_wlan_dev_t to struct wilc
  staging: wilc1000: sdio/spi: use device print api instead of custom
    one
  staging: wilc1000: remove wilc_debug_func of hif_init
  staging: wilc1000: remove unused functions
  staging: wilc1000: linux_wlan_sdio.c: fix checkpatch warning line over
    80
  staging: wilc1000: linux_wlan_sdio.c: remove braces
  staging: wilc1000: wilc_sdio_cmd53: return linux error value
  staging: wilc1000: wilc_sdio_cmd52: return linux error value
  staging: wilc1000: linux_wlan_spi.c: remove braces for single
    statement
  staging: wilc1000: linux_wlan_spi.c: add a blank
  staging: wilc1000: linux_wlan_spi.c: fix NULL comparison style
  staging: wilc1000: linux_wlan_spi.c: return linux error value
  staging: wilc1000: linux_sdio_probe: use return value
  staging: wilc1000: linux_wlan_sdio.c: move all the codes to
    wilc_sdio.c
  staging: wilc1000: remove unused files
  staging: wilc1000: rename spi function names
  staging: wilc1000: remove unneeded function
  staging: wilc1000: linux_wlan_spi.c: move all the codes to wilc_spi.c
  staging: wilc1000: remove unused files
  staging: wilc1000: remove unneeded extern variable
  staging: wilc1000: move perInterface_wlan_t to wilc_vif
  staging: wilc1000: change vif to pointer to refence real private data
  staging: wilc1000: remove duplicate netdev
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

Leo Kim (4):
  staging: wilc1000: replace explicit NULL comparisons with !
  staging: wilc1000: fixes potential null dereference 'wid.val'
  staging: wilc1000: wilc_init(): fixes inconsistent returns
  staging: wilc1000: wilc_deinit(): fixes inconsistent returns

 drivers/staging/wilc1000/Kconfig                  |  22 -
 drivers/staging/wilc1000/Makefile                 |  14 +-
 drivers/staging/wilc1000/coreconfigurator.h       |  11 +-
 drivers/staging/wilc1000/host_interface.c         | 803 +++++++++++-----------
 drivers/staging/wilc1000/host_interface.h         | 144 ++--
 drivers/staging/wilc1000/linux_wlan.c             | 342 ++++-----
 drivers/staging/wilc1000/linux_wlan_common.h      |   2 -
 drivers/staging/wilc1000/linux_wlan_sdio.c        | 170 -----
 drivers/staging/wilc1000/linux_wlan_sdio.h        |   8 -
 drivers/staging/wilc1000/linux_wlan_spi.c         | 191 -----
 drivers/staging/wilc1000/linux_wlan_spi.h         |  11 -
 drivers/staging/wilc1000/wilc_sdio.c              | 464 ++++++++-----
 drivers/staging/wilc1000/wilc_spi.c               | 417 +++++++----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 480 +++++++------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  47 +-
 drivers/staging/wilc1000/wilc_wlan.c              | 571 +++++++--------
 drivers/staging/wilc1000/wilc_wlan.h              |  17 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.c          |  25 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.h          |   4 +-
 19 files changed, 1771 insertions(+), 1972 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/linux_wlan_sdio.c
 delete mode 100644 drivers/staging/wilc1000/linux_wlan_sdio.h
 delete mode 100644 drivers/staging/wilc1000/linux_wlan_spi.c
 delete mode 100644 drivers/staging/wilc1000/linux_wlan_spi.h

-- 
1.9.1

