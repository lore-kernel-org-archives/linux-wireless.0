Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27087 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759620Ab1LPQhj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:39 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/24] update for 3.3: iwlwifi 2011-12-16
Date: Fri, 16 Dec 2011 07:37:05 -0800
Message-Id: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173743_669268_1CACD986)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We move all the tid related logic to upper layer for better separation of
layers, we also move iwl_cfg to iwl_shared for the same reason.

We add the offical names for the new devices (2000 and 1x5 series)

Don Fry (4):
  iwlwifi: move iwl_cfg from iwl_priv to iwl_shared
  iwlwifi: Add official names for new devices
  iwlwifi: create iwl_mac80211 unregister routine
  iwlwifi: remove most of the iwl_priv references from iwl-ucode.c

Emmanuel Grumbach (17):
  iwlwifi: fix endianity issue in debug prints
  iwlwifi: don't count the tfds in HW queue any more
  iwlwifi: we can wake SW queues even when draining HW queues
  iwlwifi: don't rely on the wr / rd pointers in DELBA flow
  iwlwifi: tid_data logic move to upper layer - tx AGG stop
  iwlwifi: tid_data logic move to upper layer - tx AGG alloc
  iwlwifi: tid_data logic move to upper layer - tx AGG setup
  iwlwifi: tid_data logic move to upper layer - check_empty
  iwlwifi: tid_data logic move to upper layer - txqid
  iwlwifi: tid_data logic move to upper layer - seq_number
  iwlwifi: transport layer shouldn't access the AGG SM
  iwlwifi: tid_data moves to iwl_priv
  iwlwifi: reset the tid_data when a station is removed
  iwlwifi: add debug in Tx path in AGG flow
  iwlwifi: kill iwl_{start,stop}_tx_ba_trans_ready
  iwlwifi: don't accept Tx packets when draining HW queues
  iwlwifi: add missing documentation for iwl_shared

Hsu, Kenny (1):
  iwlwifi: add IO function for continuous write of target memory

Johannes Berg (2):
  iwlwifi: remove unused AMPDU factor/density configuration
  iwlagn: remove iwlagn_build_addsta_hcmd

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-1000.c           |   14 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c           |   28 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c           |   24 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c           |   22 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c      |   12 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |   27 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |   13 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |   10 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c        |   20 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |  336 ++++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   68 ++---
 drivers/net/wireless/iwlwifi/iwl-agn.h            |    9 +-
 drivers/net/wireless/iwlwifi/iwl-core.c           |   57 +---
 drivers/net/wireless/iwlwifi/iwl-core.h           |   79 +-----
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |   34 +--
 drivers/net/wireless/iwlwifi/iwl-dev.h            |   75 ++++-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c         |   58 ++--
 drivers/net/wireless/iwlwifi/iwl-io.c             |   19 +-
 drivers/net/wireless/iwlwifi/iwl-io.h             |    5 +-
 drivers/net/wireless/iwlwifi/iwl-led.c            |    8 +-
 drivers/net/wireless/iwlwifi/iwl-led.h            |   14 -
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       |   82 ++----
 drivers/net/wireless/iwlwifi/iwl-power.c          |    8 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c           |   16 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h         |  169 +++++++----
 drivers/net/wireless/iwlwifi/iwl-testmode.c       |   22 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |   11 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |  146 +++-------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |  151 +++-------
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   33 +--
 drivers/net/wireless/iwlwifi/iwl-ucode.c          |  105 ++++----
 drivers/net/wireless/iwlwifi/iwl-wifi.h           |   74 +++++
 35 files changed, 925 insertions(+), 836 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-wifi.h

