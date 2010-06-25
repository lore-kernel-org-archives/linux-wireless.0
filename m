Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:29064 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab0FYWnW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 18:43:22 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/2] iwlwifi fixes for 2.6.35
Date: Fri, 25 Jun 2010 15:43:17 -0700
Message-Id: <1277505799-25306-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We include a much anticipated fix for an issue introduced that
broke multicast. This was particularly severe in 3945.
Some references about this issue:
https://bugzilla.kernel.org/show_bug.cgi?id=16235
http://marc.info/?l=linux-kernel&m=127653628301300&w=2
http://thread.gmane.org/gmane.linux.kernel.wireless.general/51614

The second fix is a required change to make all of our current RTS/CTS
settings take effect. Previously we would only modify the RXON setting, but
this setting would only be viewed by firmware if the TX flags have the
TX_CMD_FLAG_PROT_REQUIRE_MSK bit set, which we have not done until now.


These patches are also available from wireless-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Johannes Berg (1):
  iwlwifi: fix multicast

Wey-Yi Guy (1):
  iwlwifi: set TX_CMD_FLAG_PROT_REQUIRE_MSK in tx_flag

 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    6 +-----
 drivers/net/wireless/iwlwifi/iwl-core.c     |    7 ++++++-
 2 files changed, 7 insertions(+), 6 deletions(-)

