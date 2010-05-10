Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442Ab0EJW2V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:21 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 00/47] iwlwifi updates for 2.6.35
Date: Mon, 10 May 2010 15:27:31 -0700
Message-Id: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First off, I apologize for the size of this submission. We do our best to
avoid large submissions such as this, unfortunately a few things worked
against us during this round. Actually, in addition to this, we had something
working for us too in the form of a very active developer.

As our previous submission I again merged wireless-2.6 into
wireless-next-2.6. This is because our single wireless-2.6 patch will cause
merge conflict when it is applied to wireless-next-2.6 and there is a
particular way we prefer this conflict be handled.

In this series we add support for plcp error checking to 3945. This
introduced the usage of RF reset to 3945 and thus requires the scan races
to be fixed for it also. The station management code keeps receiving
updates and fixes after it has been converted to use the mac80211
callbacks. We introduce support for a new firmware file format that
utilizes TLVs. More changes are made to driver where it was doing something
unnecessarily due to mac80211 already doing it or using information from
mac80211 more effectively. We continue to add recognition and support for a
new series of hardware "6000 series Gen2". A significant portion of this
series include code cleanup, which, for example, reduce the times decisions
are made based on hardcoded device type instead relying on a generic
configuration.

These patches are also available from wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Abhijeet Kolekar (2):
  iwl3945: fix scan races
  iwl3945: add plcp error checking

Johannes Berg (31):
  iwlwifi: use vif iwl_bss_info_changed
  iwl3945: use iwl3945_add_bcast_station
  iwlwifi: pass address to iwl_remove_station
  iwlwifi: manage IBSS station properly
  iwlagn: show and store firmware build number
  iwl3945: remove ucode access indirection
  iwlwifi: remove ucode virtual functions
  iwlwifi: move eeprom version printout to eeprom init
  iwlagn: prepare for new firmware file format
  iwlagn: implement loading a new firmware file type
  iwlwifi: remove rts_threshold
  iwlagn: move iwl_get_ra_sta_id to 4965
  iwlagn: use vif->type to check station
  iwlwifi: apply filter flags directly
  iwlwifi: push virtual interface through
  iwlagn: use virtual interface in TX aggregation handling
  iwlwifi: remove useless priv->vif check
  iwlwifi: use vif in iwl_ht_conf
  iwlwifi: note that priv->bssid is used only by 3945
  iwlwifi: fix iwl_sta_init_lq station ID
  iwlwifi: split allocation/sending local station LQ
  iwlwifi: rework broadcast station management
  iwlwifi: track station IDs
  iwlwifi: add iwl_sta_id()
  iwlwifi: use iwl_find_station less
  iwlagn: use iwl_sta_id() for aggregation
  iwlwifi: use iwl_sta_id() for TKIP key update
  iwlwifi: move iwl_find_station() to 4965
  iwlwifi: rename iwl_add_local_station
  iwlwifi: remove pointless HT check
  iwlwifi: clear driver stations when going down

Reinette Chatre (2):
  iwlwifi: make bcast LQ command available for later restore actions
  iwlagn: work around rate scaling reset delay

Shanyu Zhao (2):
  iwlwifi: rename 6000 series Gen2 devices to Gen2a
  iwlwifi: dump firmware build info in error case

Wey-Yi Guy (10):
  iwlwifi: remove powersave debugfs if it is not supported
  iwlwifi: rename "tx_power" to "chain_tx_power"
  iwlwifi: remove device type checking for tx power in debugfs
  iwlwifi: use .cfg to enable/disable continuous ucode trace
  iwlwifi: use cfg to configure calibration operation
  iwlwifi: give correct return information for tx power debugfs
  iwlwifi: wimax co-exist code clean up
  iwlwifi: checking for all the possible failure cases
  iwlwifi: "tx power per chain" are part of ucode_tx_stats
  iwlwifi: provide more comments for cfg structure

 drivers/net/wireless/iwlwifi/iwl-1000.c        |    9 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c        |  147 +++++--
 drivers/net/wireless/iwlwifi/iwl-3945.h        |   22 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c        |  100 +++--
 drivers/net/wireless/iwlwifi/iwl-5000.c        |   27 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c        |   51 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |   16 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |   31 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c      |   29 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c   |  109 +++---
 drivers/net/wireless/iwlwifi/iwl-agn.c         |  550 ++++++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-agn.h         |   14 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h    |    6 +-
 drivers/net/wireless/iwlwifi/iwl-core.c        |  199 +++------
 drivers/net/wireless/iwlwifi/iwl-core.h        |   60 ++--
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |   66 +---
 drivers/net/wireless/iwlwifi/iwl-dev.h         |   87 ++++-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c      |    7 +
 drivers/net/wireless/iwlwifi/iwl-power.c       |    5 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c          |    9 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c        |   16 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c         |  456 +++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-sta.h         |   60 ++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c    |  163 ++++---
 24 files changed, 1300 insertions(+), 939 deletions(-)

