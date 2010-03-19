Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55370 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660Ab0CSVOO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 17:14:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/9] iwlwifi updates for 2.6.35
Date: Fri, 19 Mar 2010 14:14:02 -0700
Message-Id: <1269033251-17545-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We include two new features in this series. The driver is now better able
to deal with problems on the device and in the environment. We are now able
to detect if a queue (TX or command) is stuck and will restart the firmware
when this occurs. Also, we now keep track of ACK count ratios and BA
timeout retries ... if this information indicates an issue the firmware
will be reset. The third trigger we use for stability checking, PLCP
counts, remains as an RF reset will be performed if an issue arises here.

The driver now supports the mac80211 station addition and removal
callbacks.

These patches are also available from wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Ben M Cahill (1):
  iwlagn: Add Flow-handler (FH) register dump for 4965.

Johannes Berg (1):
  iwlwifi: sta_id cannot be invalid in rs_initialize_lq

Reinette Chatre (2):
  iwlwifi: only add broadcast station once
  iwlwifi: implement new mac80211 station add/remove calls

Shanyu Zhao (1):
  iwlwifi: clean up driver names for 1000/5000/6000

Wey-Yi Guy (4):
  iwlwifi: Recover TX flow stall due to stuck queue
  iwlwifi: move plcp check to separated function
  iwlwifi: Recover TX flow failure
  iwlwifi: code cleanup for connectivity recovery

 drivers/net/wireless/iwlwifi/iwl-1000.c     |    9 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |   83 +++--
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   22 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    5 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   28 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   24 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |  124 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h   |    7 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  154 ++++---
 drivers/net/wireless/iwlwifi/iwl-core.c     |  102 +++++-
 drivers/net/wireless/iwlwifi/iwl-core.h     |   19 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   23 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |  153 ++++++--
 drivers/net/wireless/iwlwifi/iwl-sta.c      |  630 ++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-sta.h      |   20 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    2 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   72 +++-
 18 files changed, 985 insertions(+), 493 deletions(-)

