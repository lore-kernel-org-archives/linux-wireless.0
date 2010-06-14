Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:7575 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab0FNSYk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 14:24:40 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/2] iwlwifi fixes for 2.6.35
Date: Mon, 14 Jun 2010 11:24:30 -0700
Message-Id: <1276539872-12440-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We include two fixes targeting 2.6.35. The station management code received
some rework in 2.6.35 and we since discovered a few race conditions due to
the station management actions not being serialized. This fix is included.
The second fix addresses a potential system hang issue when unexpected
information is received from device.

These patches are also available from wireless-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Reinette Chatre (1):
  iwlwifi: serialize station management actions

Shanyu Zhao (1):
  iwlagn: verify flow id in compressed BA packet

 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    8 ++++++--
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    4 ++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    9 +++++++--
 4 files changed, 22 insertions(+), 4 deletions(-)

