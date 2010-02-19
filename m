Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:65133 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab0BSGDL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 01:03:11 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/6] iwlwifi updates for 2.6.34
Date: Thu, 18 Feb 2010 22:03:01 -0800
Message-Id: <1266559387-19637-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We include more enabling for new 6050 series. The new "force reset" is
strengthened with the addition of per component state so that a reset of
one will not affect the reset of the other, this as well as more
accounting can be monitored with debugfs. We also now allow
serialization of synchronous commands. The rest is cleanup.

These patches are also available from wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Abhijeet Kolekar (1):
  iwlwifi: indicate calib version for 6050 series

Reinette Chatre (3):
  iwl3945: remove STATUS macros from header
  iwlwifi: enable iwl_send_static_wepkey_cmd to sleep
  iwlwifi: enable serialization of synchronous commands

Wey-Yi Guy (2):
  iwlwifi: separated time check for different type of force reset
  iwlwifi: add debugfs to monitor force reset parameters

 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |   18 ------
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   79 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    7 +++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   25 +++++----
 drivers/net/wireless/iwlwifi/iwl-core.h     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   36 +++++++++++--
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   15 +++++-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |   14 +++---
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    2 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 +-
 13 files changed, 160 insertions(+), 48 deletions(-)

