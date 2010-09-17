Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42101 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034Ab0IQVX3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 17:23:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/10] iwlwifi update for 2.6.37
Date: Fri, 17 Sep 2010 14:24:24 -0700
Message-Id: <1284758674-25297-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We adding more debugfs files to improve debugging capabilities
We also make some minor changes for code cleanup

Jay Sternberg (1):
  iwlwifi: corrections to debug output of ucode statistics

Wey-Yi Guy (9):
  iwlagn: add bt_status_read for 5150
  iwlagn: keep track fail tx reason counter
  iwlagn: keep track of failure tx status
  iwlagn: log aggregation tx command status
  iwlagn: keep track of aggregated tx frames failure counter
  iwlagn: adding aggregated frame failure status to debugfs
  iwlagn: correct naming for failure reply tx status
  iwlagn: minor coex API changes
  iwlagn: initialize both tx/rx prio boost parameters

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-1000.c        |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.c        |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c        |    3 +
 drivers/net/wireless/iwlwifi/iwl-6000.c        |    2 +
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |  503 +++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h |    7 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |  163 ++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h         |    5 +
 drivers/net/wireless/iwlwifi/iwl-commands.h    |   19 +-
 drivers/net/wireless/iwlwifi/iwl-core.h        |    2 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |   14 +
 drivers/net/wireless/iwlwifi/iwl-dev.h         |   47 +++
 drivers/net/wireless/iwlwifi/iwl-tx.c          |    4 +-
 13 files changed, 538 insertions(+), 233 deletions(-)

