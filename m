Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50641 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932566Ab0DPVwk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:40 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 00/21] iwlwifi updates for 2.6.35
Date: Fri, 16 Apr 2010 14:52:17 -0700
Message-Id: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We include a variety of changes. For statistics display in debugfs we add
some generic functions that will help us add similar functions for all
devices soon. Included are a few cleanups to the scanning code, removing
unnecessary code and making code synchronous when it can sleep. We include
some preparation work for the support of new hardware. The rest is small
stand alone cleanups.

These patches are also available from wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Abhijeet Kolekar (1):
  iwlwifi: add debugfs ops to iwlwifi

Johannes Berg (11):
  iwlwifi: remove scan_bands logic
  iwlwifi: correct atomic bitops usage
  iwlwifi: remove next_scan_jiffies
  iwlwifi: remove scan_pass_start
  iwlwifi: rename priv->scan to priv->scan_cmd
  iwlwifi: trigger scan synchronously
  iwlwifi: make BT coex config a virtual method
  iwlwifi: rename TX_CMD_FLG_BT_DIS_MSK
  iwlwifi: don't check monitor for scanning
  iwlwifi: remove monitor check
  iwlwifi: make scan antenna forcing more generic

Shanyu Zhao (2):
  iwlwifi: bring up 6000 Series 2x2 AGN Gen2 adapters
  iwlwifi: remove redundant iwl_dump_lq_cmd()

Wey-Yi Guy (7):
  iwlwifi: set correct single/dual stream mask
  iwlwifi: more generic eeprom defines
  iwlwifi: remove duplicated debug functions
  iwlwifi: add hw revision for 6000g2 NIC
  iwlwifi: PA type for 6000g2 series
  iwlwifi: sanity check for turn on aggregation tid
  iwlwifi: more code clean up for agn devices

 drivers/net/wireless/iwlwifi/Makefile          |    1 +
 drivers/net/wireless/iwlwifi/iwl-1000.c        |    6 +
 drivers/net/wireless/iwlwifi/iwl-3945.c        |    2 +
 drivers/net/wireless/iwlwifi/iwl-3945.h        |    3 +
 drivers/net/wireless/iwlwifi/iwl-4965.c        |   15 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c        |   11 +
 drivers/net/wireless/iwlwifi/iwl-6000.c        |   33 +-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |  834 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h |   56 ++
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c    |    2 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |  403 +++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c      |   47 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c      |   42 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c   |   36 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   50 +--
 drivers/net/wireless/iwlwifi/iwl-agn.h         |    3 +
 drivers/net/wireless/iwlwifi/iwl-commands.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c        |   42 +--
 drivers/net/wireless/iwlwifi/iwl-core.h        |   18 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h         |    1 +
 drivers/net/wireless/iwlwifi/iwl-debug.h       |    2 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |  775 +---------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h         |    9 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h      |   32 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h        |   80 ++--
 drivers/net/wireless/iwlwifi/iwl-scan.c        |  500 +--------------
 drivers/net/wireless/iwlwifi/iwl-sta.c         |   13 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c    |   87 +--
 28 files changed, 1599 insertions(+), 1506 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h

