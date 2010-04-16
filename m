Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31382 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420Ab0DPVuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:50:22 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/2] iwlwifi fixes for 2.6.34
Date: Fri, 16 Apr 2010 14:50:12 -0700
Message-Id: <1271454614-14272-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We include two fixes for 2.6.34. A scan race resulting in system crashes is
fixed with "iwlwifi: fix scan races" - this issue is tracked in
https://bugzilla.kernel.org/show_bug.cgi?id=15667 . The second fixes how
regulatory information is read from the 6000 series EEPROM. Channels that
were previously wrongly identified as not supporting IBSS are now correctly
identified as now supporting IBSS.

These patches are also available from wireless-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Johannes Berg (1):
  iwlwifi: fix scan races

Shanyu Zhao (1):
  iwlwifi: correct 6000 EEPROM regulatory address

 drivers/net/wireless/iwlwifi/iwl-6000.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c   |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.h   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    4 +++
 drivers/net/wireless/iwlwifi/iwl-scan.c   |   31 ++++++++++++++++++----------
 7 files changed, 29 insertions(+), 15 deletions(-)

