Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17575 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091Ab0FFG4l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:41 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 00/23] iwlwifi updates for 2.6.36
Date: Sat,  5 Jun 2010 23:56:15 -0700
Message-Id: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains a variety of updates. The rate scaling code received
some attention and some issues with aggregation has been fixed. The way in
which driver tracked interface MAC address has been cleaned up and fixed.
TX queue management received an optimization (reducing the amount of
memory) as well as a few fixes. It is now possible for a real scan to be
queued in case an internal scan is in progress. The driver now supports the
channel switch offloading that was recently introduced to mac80211. The
rest of the code is cleanup.

These patches are also available from wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Daniel Halperin (2):
  iwlwifi: parse block ack responses correctly
  iwlwifi: fix wrapping when handling aggregated batches

Johannes Berg (13):
  iwlwifi: remove useless node_addr assignments
  iwlwifi: remove unused wlap_bssid_addr assignment
  iwlwifi: remove mac_addr assignment
  iwlwifi: set MAC address in RXON from interface
  iwlwifi: use virtual interface address for scan
  iwlwifi: remove debug frame dumping
  iwlwifi: remove priv->mac_addr
  iwl3945: fix bugs in txq freeing
  iwlagn: fix bug in txq freeing
  iwlwifi: kzalloc txb array
  iwlwifi: reduce memory allocation
  iwlwifi: generic scan TX antenna forcing
  iwlwifi: queue user-initiated scan when doing internal scan

Shanyu Zhao (1):
  iwlwifi: do not clear data after chain noise calib

Wey-Yi Guy (7):
  iwlwifi: remove unused parameter in iwl_priv
  iwlwifi: beacon format related helper function
  iwlwifi: support channel switch offload in driver
  iwlwifi: beacon internal time unit
  iwlwifi: remove inaccurate comment
  iwlwifi: do not use huge command buffer for channel switch
  iwlwifi: remove unused parameter

 drivers/net/wireless/iwlwifi/iwl-1000.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-3945.c     |  182 ++----------------------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   78 ++++++++---
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   58 +++++++--
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   59 +++++++--
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |   22 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |  202 ++++++++-------------------
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |   26 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  125 +++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |  131 +++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-core.h     |   20 ++-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   26 +++-
 drivers/net/wireless/iwlwifi/iwl-helpers.h  |   22 +++
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   40 ++++--
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   70 ++--------
 17 files changed, 562 insertions(+), 505 deletions(-)

