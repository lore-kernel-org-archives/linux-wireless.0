Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:29646 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab0DBUi5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Apr 2010 16:38:57 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/7] iwlwifi updates for 2.6.35
Date: Fri,  2 Apr 2010 13:38:47 -0700
Message-Id: <1270240734-12825-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series consists mostly of code cleanup. We are planning to remove some
module parameters and now mark them as deprecated. Their removal is also
noted in the feature removal schedule. We also plan to remove the iwl4965
module alias and indicate this too in the feature removal schedule.

We include a patch here that is also included in the wireless-2.6 series.
This is because this patch needs some modification to apply due to the
recent code cleanups. This patch ("iwlwifi: avoid Tx queue memory allocation
in interface down") is included in this email submission but will not be
found on our wireless-next-2.6 branch, only on the wireless-2.6 branch.
Please let me know if there is a better way to deal with cases like this.

These patches (except the ones mentioned not to be) are also available from
wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Frans Pop (1):
  iwlwifi: remove trailing space in messages

Wey-Yi Guy (4):
  iwlwifi: merge module parameters into single place
  iwlwifi: remove irrelevant comments
  iwlwifi: deprecate "iwl4965" alias support
  iwlwifi: code cleanup for generic defines

Zhu Yi (2):
  iwlwifi: clear rxq->queue in queue reset
  iwlwifi: avoid Tx queue memory allocation in interface down

 Documentation/feature-removal-schedule.txt  |   23 +++++++++++++
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    5 ---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |   24 --------------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   43 ++++--------------------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   13 -------
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h   |   16 +++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   23 +++++++++----
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |   47 +++++++++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   45 +++++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    3 +-
 drivers/net/wireless/iwlwifi/iwl-calib.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |   11 +++---
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-io.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   12 +++---
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   22 ++++++++++++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 ++--
 25 files changed, 183 insertions(+), 137 deletions(-)

