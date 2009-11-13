Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31482 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223AbZKMT4d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 14:56:33 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 00/16] iwlwifi updates 11/13/2009
Date: Fri, 13 Nov 2009 11:56:22 -0800
Message-Id: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Ben M Cahill (2):
  iwl3945: Reset saved POWER_TABLE_CMD in "up"
  iwlwifi: Add comments about CSR registers

Daniel C Halperin (2):
  iwlwifi: fix bugs in beacon configuration
  iwlwifi: make iwlwifi send beacons

Johannes Berg (3):
  iwlwifi: report PS filtered status
  iwlwifi: add sleep_tx_count ucode station API
  iwlwifi: handle unicast PS buffering

Reinette Chatre (1):
  iwlagn: power up device before initializing EEPROM

Wey-Yi Guy (8):
  iwlwifi: validate enhanced tx power entry
  iwlwifi: disable coex until implementation ready for 6x50
  iwlwifi: remove unused parameter from iwl_channel_info
  iwlwifi: drop non-production PCI-IDs for 6x50 series
  iwlwifi: remove external reference for non-exist data structure
  iwlwifi: update reply_statistics_cmd with 'clear' parameter
  iwlwifi: eliminate the possible 1/2 dBm tx power loss in 6x00 & 6x50 series
  iwlwifi: align tx/rx statistics debugfs format

 drivers/net/wireless/iwlwifi/iwl-4965.c     |    7 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   22 +++-
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   34 -----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  139 +++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-calib.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |   38 ++++++-
 drivers/net/wireless/iwlwifi/iwl-core.c     |   30 ++++--
 drivers/net/wireless/iwlwifi/iwl-core.h     |    5 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h      |  177 +++++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   54 ++++++---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   18 +--
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |   75 ++++++++----
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |    6 +-
 drivers/net/wireless/iwlwifi/iwl-power.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   35 +++---
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   29 ++---
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    3 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   51 ++++++++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 +-
 20 files changed, 532 insertions(+), 200 deletions(-)

