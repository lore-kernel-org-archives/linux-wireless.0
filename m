Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab2DWVwx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:53 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/29] update for 3.5: iwlwifi 2012-04-23
Date: Mon, 23 Apr 2012 14:47:11 -0700
Message-Id: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235257_643836_51964223)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most of the re-factor work are done with this patch set for prepare our
up-coming new architecture. We might have few more cleanup patches, but nothing
major.

David Spinadel (1):
  iwlwifi: Added debugfs calib disabled write

Don Fry (1):
  iwlwifi: revert workaround to restore 1000 rx throughput

Emmanuel Grumbach (5):
  iwlwifi: make a static inline to read the RF kill register
  iwlwifi: first enable RF kill interrupt, then check register
  iwlwifi: enable RF kill interrupt in start_hw
  iwlwifi: check RF kill register when interrupts have been disabled
  iwlwifi: provide proper API to disable all interrupts

Johannes Berg (21):
  iwlwifi: properly set basic rates
  iwlwifi: remove debugfs logspam
  iwlwifi: move debugfs registration function declarations
  iwlwifi: move iwl_have_debug_level
  iwlwifi: clean up iwl-shared.h includes
  iwlwifi: remove bt_siso_mode declaration
  iwlwifi: move TIME_UNIT
  iwlwifi: move iwl_cmd_echo_test
  iwlwifi: remove traffic log
  iwlwifi: remove TX/RX frame statistics
  iwlwifi: remove duplicate iwlagn_mod_params declaration
  iwlwifi: move driver defines to iwl-drv.h
  iwlwifi: move PLCP defines to config
  iwlwifi: move watchdog definitions to config
  iwlwifi: move eeprom versions to HW files
  iwlwifi: move antenna definitions to config
  iwlwifi: move OTP defines
  iwlwifi: clean up some hw file includes
  iwlwifi: use direct calls for transport free
  iwlwifi: clean up module parameters
  iwlwifi: use new mac80211 queue scheme

Wey-Yi Guy (1):
  iwlwifi: include net/mac80211.h to avoid compiler error

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/Makefile             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c           |    8 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c           |    8 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c           |    9 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c           |   17 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-devices.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h         |   11 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |   17 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h         |   36 +---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |    9 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |  123 +++++++--
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c        |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |   17 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |  198 ++++-----------
 drivers/net/wireless/iwlwifi/iwl-agn.h            |   16 +-
 drivers/net/wireless/iwlwifi/iwl-config.h         |   28 ++
 drivers/net/wireless/iwlwifi/iwl-core.c           |  294 --------------------
 drivers/net/wireless/iwlwifi/iwl-core.h           |  133 ---------
 drivers/net/wireless/iwlwifi/iwl-debug.c          |    1 +
 drivers/net/wireless/iwlwifi/iwl-debug.h          |   22 +--
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |  295 ++++-----------------
 drivers/net/wireless/iwlwifi/iwl-dev.h            |   72 +-----
 drivers/net/wireless/iwlwifi/iwl-drv.c            |   90 +++++++
 drivers/net/wireless/iwlwifi/iwl-drv.h            |    7 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c         |    2 -
 drivers/net/wireless/iwlwifi/iwl-eeprom.h         |   53 ----
 drivers/net/wireless/iwlwifi/iwl-fw.h             |    1 +
 drivers/net/wireless/iwlwifi/iwl-led.c            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       |   49 +++--
 drivers/net/wireless/iwlwifi/iwl-modparams.h      |  124 +++++++++
 drivers/net/wireless/iwlwifi/iwl-pci.c            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-power.c          |    8 +-
 drivers/net/wireless/iwlwifi/iwl-power.h          |    9 -
 drivers/net/wireless/iwlwifi/iwl-scan.c           |    1 -
 drivers/net/wireless/iwlwifi/iwl-shared.h         |  129 ---------
 drivers/net/wireless/iwlwifi/iwl-testmode.c       |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |   11 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |    3 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |    2 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   77 ++++--
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   42 +---
 drivers/net/wireless/iwlwifi/iwl-ucode.c          |    1 -
 46 files changed, 655 insertions(+), 1289 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-core.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-core.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-modparams.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-shared.h

