Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:35013 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab0A2TyJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 14:54:09 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 00/12] iwlwifi updates for 2.6.34
Date: Fri, 29 Jan 2010 11:53:50 -0800
Message-Id: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this series we update the sensitivity calibration data for newer devices.
The rest of the series consists of cleanup and fixes. We include an optimization
where commands are not sent to device unnecessarily. The rest of the fixes
and cleanup addresses various items that the subject line summarizes.

These patches are also available from wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Daniel Halperin (1):
  iwlwifi: optimize power saving

Johannes Berg (6):
  iwlwifi: fix locking in iwl_mac_add_interface
  iwlwifi: no need to test iw_mode in power saving
  iwlagn: simplify ucode loading
  iwlwifi: remove bg_up work
  iwlwifi: remove unused work structs
  iwlwifi: fix typo in IWL_CCK_RATES_MASK

Reinette Chatre (1):
  iwlwifi: iwl_power_update_mode always hold mutex

Wey-Yi Guy (4):
  iwlwifi: sysassert identifier change
  iwlwifi: update sensitivity calibration data for 6x00 series
  iwlwifi: update sensitivity calibration data for 5x00 series
  iwlwifi: update sensitivity calibration data for 1000 series

 drivers/net/wireless/iwlwifi/iwl-1000.c     |   72 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   67 +++++++++----------------
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   25 ++++------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   15 +++---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    2 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    5 --
 drivers/net/wireless/iwlwifi/iwl-power.c    |    5 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   21 +++-----
 10 files changed, 125 insertions(+), 91 deletions(-)

