Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43792 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932761Ab1KJPtf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 10:49:35 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 00/27] update for 3.3
Date: Thu, 10 Nov 2011 06:55:00 -0800
Message-Id: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_164939_289689_56C5B820)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We move all the mac80211 related functions into single file
We also fix number of P2P related issues and add P2P NoA probe responses
We adding more debug hook to improve debugging capabilities


Don Fry (6):
  iwlagn: move ucode_write_complete from priv to trans structure
  iwlagn: remove knowledge of ucode image location from upper layers
  iwlagn: push knowledge of ucode image lower down
  iwlagn: move ucode files out of the iwl_priv structure
  iwlagn: Remove dependence of iwl_priv from eeprom routines.
  iwlagn: move nvm_device_type from iwl_priv to iwl_trans

Emmanuel Grumbach (3):
  iwlwifi: fix unused label in iwl_send_cmd_sync
  iwlwifi: remove the use of the QOS debug flag
  iwlwifi: add debug information on queue stop / wake

Johannes Berg (6):
  iwlagn: add P2P NoA to probe responses
  iwlagn: fix NULL ptr deref when reprogramming sta w/o LQ
  iwlagn: use per-vif AC parameters
  iwlagn: explicitly program P2P QoS parameters
  iwlagn: convert remain-on-channel duration to TU
  iwlagn: don't always split remain-on-channel

Todd Previte (1):
  iwlwifi: Suppress noisy syslog messages when RF_KILL switch engaged

Venkataraman, Meenakshi (1):
  iwlwifi: fix rate-scaling algorithm for BT combo devices

Wey-Yi Guy (10):
  iwlwifi: two more SKUs for 6x05 series
  iwlagn: check for SMPS mode
  iwlwifi: remove un-supported SKUs
  iwlwifi: move all mac80211 related functions to one place
  iwlwifi: move more mac80211 callback function
  iwlwifi: move hw_scan into _mac80211 file
  iwlwifi: move station functions to mac80211
  iwlwifi: Move the core suspend function to iwl-agn-lib
  iwlwifi: set "echo" host command length
  iwlwifi: check status before send command

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git


 drivers/net/wireless/iwlwifi/Makefile             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c           |   20 -
 drivers/net/wireless/iwlwifi/iwl-6000.c           |   10 -
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |  358 +++++
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |   49 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |   13 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c        |   78 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |   16 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c      |  154 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.c            | 1544 +-------------------
 drivers/net/wireless/iwlwifi/iwl-agn.h            |   31 +-
 drivers/net/wireless/iwlwifi/iwl-cfg.h            |    6 -
 drivers/net/wireless/iwlwifi/iwl-core.c           |  307 +----
 drivers/net/wireless/iwlwifi/iwl-core.h           |   14 -
 drivers/net/wireless/iwlwifi/iwl-debug.h          |   19 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |    8 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |   34 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c         |  142 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       | 1632 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-pci.c            |   20 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c           |   47 +-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c        |    7 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |   35 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   52 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   23 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   50 +-
 28 files changed, 2448 insertions(+), 2233 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-mac80211.c

