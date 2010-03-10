Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57656 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab0CJFWA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:00 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 00/24] iwlwifi updates for 2.6.35
Date: Tue,  9 Mar 2010 21:21:28 -0800
Message-Id: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bulk of this work consists of code cleanup and reorganization. We received a significant
contribution from Johannes when he (among other cleanups) cleaned up actions
taken by driver which are not necessary based on what mac80211 does and/or provides.

Two other mentionable changes are the addition of short scan
support which enables iwl3945 to now also perform RF reset, and modifying WEP key
protection to use a mutex that enable code using this to sleep.

This series is rather large since we have been holding back patches waiting
for 2.6.34-rc1 to be released so that we can base patches on
wireless-next-2.6. Please do let me know if there is some better system you
would like me to follow.

These patches are also available from wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Abhijeet Kolekar (1):
  iwl3945: check ucode load error code

Johannes Berg (18):
  iwlagn: move ICT code into separate file
  iwlwifi: move 3945 specific data into union
  iwlwifi: move ICT data to agn part of union
  iwlagn: remove write-only variables
  iwlwifi: remove superfluous channel check
  iwlwifi: remove dead code from iwl_mac_reset_tsf
  iwlwifi: remove frame dropping
  iwlwifi: remove never-changing priv->rates_mask variable
  iwlwifi: remove priv->active_rate_basic
  iwlwifi: remove IBSS channel sanity check
  iwlwifi: remove sanity check
  iwlwifi: clear up AC/FIFO debug output
  iwlwifi: move 3945 clip groups to 3945 data
  iwlwifi: remove alive start adhoc restart
  iwlwifi: remove STATUS_MODE_PENDING
  iwlagn: move sysfs flags and filter_flags files to debugfs
  iwlwifi: change WEP key protection to use mutex
  iwlwifi: clean up queue/fifo handling

Reinette Chatre (1):
  iwlwifi: remove needlessly exported symbols

Wey-Yi Guy (4):
  iwlwifi: remove un-necessary parameters
  iwlwifi: remove duplicate function
  iwlwifi: remove unnecessary parameter in scan function
  iwlwifi: add internal short scan support for 3945

 drivers/net/wireless/iwlwifi/Makefile       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    2 +
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |    6 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   42 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   20 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   40 ++--
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c  |  305 +++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |   13 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h   |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  110 +-------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |   74 +++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |  418 ++------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    8 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   82 +++---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   90 +++---
 drivers/net/wireless/iwlwifi/iwl-helpers.h  |    3 +
 drivers/net/wireless/iwlwifi/iwl-prph.h     |   14 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   24 --
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    9 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   18 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |  115 +++++---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   78 ++---
 24 files changed, 687 insertions(+), 789 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-ict.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn.h

