Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18050 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab1HIRWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 13:22:30 -0400
Message-ID: <4E416CCE.6070304@qca.qualcomm.com> (sfid-20110809_192234_298165_4F9ADE24)
Date: Tue, 9 Aug 2011 20:22:22 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Pull request: ath6kl 2011-08-09
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

I created a ath6kl tree for handling all the ath6kl patches:

http://git.kernel.org/?p=linux/kernel/git/kvalo/ath6kl.git;a=summary

The ath6kl-next branch is based on your wireless-next tree and master
branch follows wireless-testing. This is a similar scheme as Luca does
with wl12xx. At least that was my intention, let's see how it ended up :)

All ath6kl developers should work on the master branch so that their
work is based on latest ath6kl patches. I will frequently merge
wireless-testing to the master branch to make sure that we are using the
latest wireless code.

To get patches into ath6kl tree please post them to linux-wireless
mailing list and CC me.

This is now my first pull request from ath6kl tree. It contains the
original version of the code you applied to wireless-testing just as an
omnibus patch with a proper commit log. The patch contains one addition
of including scatterlist.h to avoid a build breakage with latest kernel.
Also there are patches implemented after the inclusion.

John, please consider pulling this. If there are any problems, please
let me know.

The following changes since commit f749b94679c71a9c74ad9509dbbf00d8f3d620ad:

  ath9k: use the new channel noise value for signal strength and survey
info (2011-08-08 16:04:20 -0400)

are available in the git repository at:
  master.kernel.org:/pub/scm/linux/kernel/git/kvalo/ath6kl.git ath6kl-next

Kalle Valo (6):
      Add ath6kl cleaned up driver
      ath6kl: don't force foreground scan when connected
      ath6kl: fix atomicity in ath6kl_cfg80211_scan_node()
      ath6kl: fix crash when interface is closed but scan is ongoing
      ath6kl: remove dependency to wireless extensions
      ath6kl: change aggreation timeout message from an error to a debug
message

Raja Mani (6):
      ath6kl: Print bad trailer data only when htc fails to parse
trailer info
      ath6kl: Rearrange the variable and the value position in IF condition
      ath6kl: Avoid two memset to clear src and desr mac addr variable
memory in ath6kl_wmi_dot11_hdr_remove()
      ath6kl: Use bit field macros to maintain wlan enabled and disabled
status
      ath6kl: Fix crash during the connection process
      ath6kl: Release the memory allocated for the firmware

Vasanthakumar Thiagarajan (33):
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
      ath6kl: Cleanup void *parent_dev in struct wmi
      ath6kl: Move scan table from wmi to ath6kl
      ath6kl: Cleanup parameters for wlan_refresh_inactive_nodes()
      ath6kl: Remove bssid from struct wmi
      ath6kl: Remove ath6kl_wmi_get_current_bssid()
      ath6kl: Cleanup parameters of wlan_node_table_init()
      ath6kl: Move initialization/deinitialization of scan_table to
appropriate functions
      ath6kl: Pass only the needed scan_table to ath6kl_wmi_iterate_nodes()
      ath6kl: Remove ath6kl_wmi_iterate_nodes()
      ath6kl: Use ath6kl_cfg80211_scan_node() directly instead of
function pointer
      ath6kl: Cleanup void * in ath6kl_cfg80211_scan_node()

 drivers/net/wireless/ath/Kconfig           |    1 +
 drivers/net/wireless/ath/Makefile          |    1 +
 drivers/net/wireless/ath/ath6kl/Kconfig    |   15 +
 drivers/net/wireless/ath/ath6kl/Makefile   |   35 +
 drivers/net/wireless/ath/ath6kl/bmi.c      |  692 +++++++
 drivers/net/wireless/ath/ath6kl/bmi.h      |  250 +++
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 1538 ++++++++++++++++
 drivers/net/wireless/ath/ath6kl/cfg80211.h |   39 +
 drivers/net/wireless/ath/ath6kl/common.h   |  180 ++
 drivers/net/wireless/ath/ath6kl/core.h     |  544 ++++++
 drivers/net/wireless/ath/ath6kl/debug.c    |  150 ++
 drivers/net/wireless/ath/ath6kl/debug.h    |  105 ++
 drivers/net/wireless/ath/ath6kl/hif-ops.h  |   72 +
 drivers/net/wireless/ath/ath6kl/hif.h      |  207 +++
 drivers/net/wireless/ath/ath6kl/htc.c      | 2456 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/htc.h      |  604 ++++++
 drivers/net/wireless/ath/ath6kl/htc_hif.c  |  641 +++++++
 drivers/net/wireless/ath/ath6kl/htc_hif.h  |   92 +
 drivers/net/wireless/ath/ath6kl/init.c     | 1303 +++++++++++++
 drivers/net/wireless/ath/ath6kl/main.c     | 1337 ++++++++++++++
 drivers/net/wireless/ath/ath6kl/node.c     |  234 +++
 drivers/net/wireless/ath/ath6kl/sdio.c     |  912 +++++++++
 drivers/net/wireless/ath/ath6kl/target.h   |  331 ++++
 drivers/net/wireless/ath/ath6kl/txrx.c     | 1457 +++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.c      | 2743
++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      | 2018 ++++++++++++++++++++
 26 files changed, 17957 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/Kconfig
 create mode 100644 drivers/net/wireless/ath/ath6kl/Makefile
 create mode 100644 drivers/net/wireless/ath/ath6kl/bmi.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/bmi.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/cfg80211.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/cfg80211.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/common.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/core.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/debug.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/debug.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/hif-ops.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/hif.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc_hif.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc_hif.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/init.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/main.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/node.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/sdio.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/target.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/txrx.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/wmi.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/wmi.h
