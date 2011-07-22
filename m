Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44310 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1GVFm1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:42:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/31] *** SUBJECT HERE ***
Date: Fri, 22 Jul 2011 08:41:33 +0300
Message-ID: <1311313324-6766-2-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074230_366557_366AB789)
In-Reply-To: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

*** BLURB HERE ***

Kalle Valo (5):
  ath6kl: don't force foreground scan when connected
  ath6kl: fix atomicity in ath6kl_cfg80211_scan_node()
  ath6kl: fix crash when interface is closed but scan is ongoing
  ath6kl: remove dependency to wireless extensions
  ath6kl: change aggreation timeout message from an error to a debug
    message

Raja Mani (4):
  ath6kl: Print bad trailer data only when htc fails to parse trailer
    info
  ath6kl: Rearrange the variable and the value position in IF condition
  ath6kl: Avoid two memset to clear src and desr mac addr variable
    memory in ath6kl_wmi_dot11_hdr_remove()
  ath6kl: Use bit field macros to maintain wlan enabled and disabled
    status

Vasanthakumar Thiagarajan (22):
  ath6kl: cleanup callbacks for different scatter gather method
  ath6kl: Move ath6kl_sdio_async_rw_scatter() down to other hif_ops
    functions
  ath6kl: Remove struct hif_scatter_req_priv
  ath6kl: Remove useless flags in hif_scatter_req
  ath6kl: Remove endpoint reference from hif_scatter_req
  ath6kl: Refactor refactor ath6kl_sdio_setup_scat_resource()
  ath6kl: Cleanup ath6kl_sdio_enable_scatter()
  ath6kl: Cleanup ath6kl_sdio_cleanup_scatter()
  ath6kl: Move down scatter enable and cleanup functions
  ath6kl: Merge scatter gather setup functions for two method
  ath6kl: Moe virt_scat from hif_dev_scat_sup_info to hif_scatter_req
  ath6kl: Refactor ath6kl_sdio_read_write_sync()
  ath6kl: Merge scatter rw request functions into one
  ath6kl: Remove ath6kldev_setup_msg_bndl()
  ath6kl: Minor cleanup in ath6kldev_submit_scat_req()
  ath6kl: Remove callback msg_pending() and used the function directly
  ath6kl: Move bundle size from ath6kl_device to htc_target
  ath6kl: Move block_sz and block_mask from ath6kl_device to htc_target
  ath6kl: Move scatter information from ath6kl_device to htc_target
  ath6kl: Bypass reading irq status based on chk_irq_status_cnt
  ath6kl: Move chk_irq_status_cnt from ath6kl_device to htc_target
  ath6kl: Remove unused struct ath6kl_async_reg_io_buffer

 drivers/net/wireless/ath/ath6kl/Kconfig    |    2 -
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   52 +++---
 drivers/net/wireless/ath/ath6kl/core.h     |    7 +-
 drivers/net/wireless/ath/ath6kl/debug.h    |    1 +
 drivers/net/wireless/ath/ath6kl/hif-ops.h  |   11 +-
 drivers/net/wireless/ath/ath6kl/hif.h      |   25 +--
 drivers/net/wireless/ath/ath6kl/htc.c      |   72 +++----
 drivers/net/wireless/ath/ath6kl/htc.h      |   16 +-
 drivers/net/wireless/ath/ath6kl/htc_hif.c  |  200 ++----------------
 drivers/net/wireless/ath/ath6kl/htc_hif.h  |   21 --
 drivers/net/wireless/ath/ath6kl/init.c     |    4 +-
 drivers/net/wireless/ath/ath6kl/main.c     |    4 +-
 drivers/net/wireless/ath/ath6kl/sdio.c     |  317 ++++++++++++++++-----------
 drivers/net/wireless/ath/ath6kl/txrx.c     |    7 +-
 drivers/net/wireless/ath/ath6kl/wmi.c      |    3 +-
 15 files changed, 302 insertions(+), 440 deletions(-)

