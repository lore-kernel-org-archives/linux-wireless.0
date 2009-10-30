Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757398AbZJ3VgN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 17:36:13 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 00/15] iwlwifi updates 10/30/2009
Date: Fri, 30 Oct 2009 14:36:03 -0700
Message-Id: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben M Cahill (5):
  iwlwifi: remove unneeded locks from apm_stop() and stop_master()
  iwlwifi: remove power-wasting calls to apm_ops.init()
  iwlagn: invoke L0S workaround for 6000/1000 series
  iwlagn: Clarify FH_TX interrupt
  iwlagn: update write pointers for all tx queues after wakeup

Reinette Chatre (7):
  iwlwifi: provide firmware version
  iwlwifi: unmap memory before use
  iwlwifi: move iwl_[un]init_drv to iwlagn
  iwlwifi: split adding broadcast station from others
  iwl3945: store station rate scale information in mac80211 station structure
  iwlagn: move rate scale initialization to init function
  iwlwifi: print warning when sending host command fails

Wey-Yi Guy (3):
  iwlwifi: coex API data structure
  iwlwifi: add SM PS support for 6x50 series
  iwlwifi: add wimax/wifi coexist support for 6x50 series

 drivers/net/wireless/iwlwifi/iwl-1000.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |   99 +++---------
 drivers/net/wireless/iwlwifi/iwl-3945.h     |   35 ++++-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   12 +--
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   25 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |   13 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  143 ++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-calib.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-commands.h |  161 ++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-core.c     |  234 +++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    7 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |   11 ++
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   67 ++++++++
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   13 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   15 +-
 19 files changed, 580 insertions(+), 265 deletions(-)

