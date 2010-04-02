Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51895 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab0DBUjL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Apr 2010 16:39:11 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/3] iwlwifi fixes for 2.6.34
Date: Fri,  2 Apr 2010 13:39:05 -0700
Message-Id: <1270240748-12865-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We include three fixes. Included is a fix for some DMA issues discovered
while running with CONFIG_DMA_API_DEBUG where some memory was not unmapped
when driver is unloaded. We also include a fix for a potential BUG_ON in
rate scaling. The third fix eliminates the need for the driver to allocate
a large memory area on resume, which has been causing some memory
allocation issues.

These patches are also available from wireless-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Shanyu Zhao (1):
  iwlwifi: use consistent table for tx data collect

Zhu Yi (2):
  iwlwifi: fix DMA allocation warnings
  iwlwifi: avoid Tx queue memory allocation in interface down

 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   55 +++++++--------
 drivers/net/wireless/iwlwifi/iwl-core.c   |   11 ++-
 drivers/net/wireless/iwlwifi/iwl-core.h   |    5 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c     |  107 +++++++++++++++++++++++++----
 4 files changed, 129 insertions(+), 49 deletions(-)

