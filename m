Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9497 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759946AbZKFWw7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:52:59 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 00/20] iwlwifi updates 11/6/2009
Date: Fri,  6 Nov 2009 14:52:43 -0800
Message-Id: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben M Cahill (6):
  iwlwifi: Limit size of Event Log dump
  iwlwifi: speed up event log dumps
  iwlwifi: Update comments for struct iwl_ssid_ie
  iwlwifi: Add comments about MAC_ACCESS_REQ
  iwlagn: update write pointers in iwl_irq_tasklet()
  iwlwifi: MAC_ACCESS_REQ cleanup

Johannes Berg (3):
  iwlwifi: don't double-activate queue 4
  iwlwifi: fix FIFO vs. queue confusion
  iwlwifi: add FIFO usage for 5000

Reinette Chatre (1):
  iwlwifi: change debug message to error in failure case

Shanyu Zhao (2):
  iwlwifi: use only one chain for scan in PS
  iwlwifi: use configured valid rx chain for scan

Wey-Yi Guy (7):
  iwlwifi: print rx_on config to help debug
  iwlwifi: no periodic Tx/IQ calibration for 6x00/6x50 series
  iwlwifi: remove un-used parameter
  iwlwifi: fix for channel switch
  iwlwifi: drop non-production PCI-IDs
  iwlwifi: do not base station's sm_ps setting on AP
  iwlwifi: Fix issue on file transfer stalled in HT mode

Zhu Yi (1):
  iwlwifi: allocate 128 bytes linear buffer for rx skb

 drivers/net/wireless/iwlwifi/iwl-1000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   14 ++--
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   16 +++-
 drivers/net/wireless/iwlwifi/iwl-6000.c     |  106 +-------------------------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   79 +++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-commands.h |    7 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |   54 ++++++++------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    5 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   22 ++++--
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-io.h       |   20 +++++
 drivers/net/wireless/iwlwifi/iwl-prph.h     |   19 ++++-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    5 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   18 ++++-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   12 ++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   42 ++++++++--
 17 files changed, 235 insertions(+), 192 deletions(-)

