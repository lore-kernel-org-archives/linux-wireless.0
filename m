Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35412 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab1HMQ54 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 12:57:56 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/11]  update for 3.2
Date: Sat, 13 Aug 2011 09:17:55 -0700
Message-Id: <1313252287-22858-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_185805_747806_8D470C04)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We enable new P2P implementation with GO powersave
We bump firmware API version for number of new devices
We also adjust the sensitivity value for number of devices


Johannes Berg (7):
  iwlagn: reserve queue 10 for TX during scan dwell
  iwlagn: handle GO powersave
  iwlagn: separate firmware version warning
  iwlagn: bump firmware API for some devices
  iwlagn: move context init after firmware loading
  iwlagn: support new P2P implementation
  mac80211: remove offchannel_tx API

Wey-Yi Guy (4):
  iwlagn: default smps mode for 1000 series device
  iwlagn: Remove ht40 support from 5.2GHz for _bgn devices
  iwlagn: change default sensitivity value for 5000 and 6000 series
  iwlagn: support v2 of enhanced sensitivity table

 drivers/net/wireless/iwlwifi/Kconfig         |   17 -
 drivers/net/wireless/iwlwifi/iwl-1000.c      |   15 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c      |   23 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c      |   12 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c      |   19 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |   69 +++--
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |   47 +--
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |   28 +--
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |   30 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |  455 ++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    1 +
 drivers/net/wireless/iwlwifi/iwl-commands.h  |   34 ++-
 drivers/net/wireless/iwlwifi/iwl-core.c      |    5 +
 drivers/net/wireless/iwlwifi/iwl-core.h      |    5 +
 drivers/net/wireless/iwlwifi/iwl-dev.h       |   32 ++-
 drivers/net/wireless/iwlwifi/iwl-scan.c      |   19 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c     |   10 +-
 include/net/mac80211.h                       |   10 -
 net/mac80211/cfg.c                           |   39 ---
 net/mac80211/driver-ops.h                    |   31 --
 net/mac80211/ieee80211_i.h                   |    1 -
 net/mac80211/status.c                        |    3 -
 23 files changed, 449 insertions(+), 460 deletions(-)

