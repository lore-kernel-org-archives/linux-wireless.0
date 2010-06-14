Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13214 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab0FNSYz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 14:24:55 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/6] iwlwifi updates for 2.6.36
Date: Mon, 14 Jun 2010 11:24:46 -0700
Message-Id: <1276539892-12471-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this series we address a potential null pointer access in the debugfs
code. Some variable renaming is included to make code easier to follow.
Tracing received one fix in its reporting. If an antenna is disconnected
user will now see a warning. We include a safety to cancel some work that
may be running when exiting.

These patches are also available from wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Dor Shaish (1):
  iwlwifi: Fix null pointer referencing in iwl_dbgfs_rx_queue_read.

Emmanuel Grumbach (2):
  iwlwifi: rename rxq->dma_addr
  iwlwifi: rename iwl4965_rx_mpdu_res_start

Johannes Berg (2):
  iwlwifi: trace full RX
  iwlwifi: print warning about disconnected antennas

Wey-Yi Guy (1):
  iwlwifi: cancel run time calibration work when going down

 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    8 ++++++--
 drivers/net/wireless/iwlwifi/iwl-calib.c    |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    7 ++++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    9 ++++++---
 9 files changed, 35 insertions(+), 16 deletions(-)

