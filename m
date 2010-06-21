Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59381 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab0FUSGo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 14:06:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/9] iwlwifi updates for 2.6.36
Date: Mon, 21 Jun 2010 11:06:31 -0700
Message-Id: <1277143600-32554-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 recently received changes to enable driver's ampdu actions to
sleep. In this series we include changes in driver to make use of this
feature for better data protection and error handling. The key management
calls can also sleep and driver is now modified to utilize this also.
Better error reporting is added to station management also. The rest of
this series consist of code cleanup where, for example, we are moving a
significant amount of code to the appropriate module (agn specific code
to iwlagn module).

These patches are also available from wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Jay Sternberg (1):
  iwlwifi: display ucode SW Error in hex

Johannes Berg (3):
  iwlagn: use mutex for aggregation
  iwlwifi: use sync commands for keys
  iwlwifi: return ucode errors from station management

Wey-Yi Guy (5):
  iwlwifi: move agn specific rx related code to iwl-agn-rx.c
  iwlwifi: move _agn statistics related structure
  iwlwifi: move calibration from iwlcore to iwlagn
  iwlwifi: code cleanup to remove un-necessary "goto"
  iwlwifi: remove non-exist reference

 drivers/net/wireless/iwlwifi/Makefile          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c        |   12 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c   |  910 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |   72 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c      |  278 +++++++
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c      |    5 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   47 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h         |   10 +
 drivers/net/wireless/iwlwifi/iwl-calib.c       |  919 ------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h        |   10 -
 drivers/net/wireless/iwlwifi/iwl-dev.h         |   14 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c          |  238 ------
 drivers/net/wireless/iwlwifi/iwl-sta.c         |   76 ++-
 drivers/net/wireless/iwlwifi/iwl-sta.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c    |    2 +-
 17 files changed, 1333 insertions(+), 1271 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-calib.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-rx.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-calib.c

