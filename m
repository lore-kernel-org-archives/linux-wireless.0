Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14459 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab2DROpq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 10:45:46 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/15] update for 3.5: iwlwifi 2012-04-18
Date: Wed, 18 Apr 2012 07:41:02 -0700
Message-Id: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120418_164550_102209_3B264ACF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another batch of the cleanup and refactor work to prepare our up-coming
new architecture. Two more batch set to come.

David Spinadel (3):
  iwlwifi: Change disable calibration bit-set to enum
  iwlwifi: Added foreward declaration for iwl_cfg in op_mode
  iwlwifi: Remove inconsistent and redundant declaration

Emmanuel Grumbach (11):
  iwlwifi: kill shrd->drv, driver points to transport
  iwlwifi: op_mode holds its pointer to the transport
  iwlwifi: op_mode holds its pointer to the config
  iwlwifi: driver holds its pointer to the config
  iwlwifi: transport holds its pointer to the config
  iwlwifi: driver holds its pointer to the transport
  iwlwifi: don't use shared for the logger any more
  iwlwifi: remove the shared area
  iwlwifi: remove unneeded includes
  iwlwifi: split between AGG_ON and AGG_STARTING
  iwlwifi: move iwl_rxon_context_id to user

Johannes Berg (1):
  iwlwifi: improve TX cache footprint

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-agn-calib.c      |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-devices.c    |   24 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |   25 ++---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |   13 +--
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |    5 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c         |   16 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |   44 ++++++---
 drivers/net/wireless/iwlwifi/iwl-agn.c            |  112 ++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-agn.h            |   11 +-
 drivers/net/wireless/iwlwifi/iwl-core.c           |    3 -
 drivers/net/wireless/iwlwifi/iwl-debug.h          |   12 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |   16 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h            |   27 ++++--
 drivers/net/wireless/iwlwifi/iwl-drv.c            |   61 ++++++------
 drivers/net/wireless/iwlwifi/iwl-drv.h            |   20 ++--
 drivers/net/wireless/iwlwifi/iwl-eeprom.c         |   62 ++++++------
 drivers/net/wireless/iwlwifi/iwl-io.h             |    1 -
 drivers/net/wireless/iwlwifi/iwl-led.c            |   17 ++--
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       |   41 ++++----
 drivers/net/wireless/iwlwifi/iwl-op-mode.h        |    2 +
 drivers/net/wireless/iwlwifi/iwl-pci.c            |   58 +++++------
 drivers/net/wireless/iwlwifi/iwl-phy-db.c         |    5 +-
 drivers/net/wireless/iwlwifi/iwl-phy-db.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-power.c          |   11 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c           |   12 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h         |   55 ----------
 drivers/net/wireless/iwlwifi/iwl-testmode.c       |   26 +++---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |   32 ++++---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |    8 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   33 +++---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |  107 +++++++-------------
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   19 ++--
 drivers/net/wireless/iwlwifi/iwl-ucode.c          |   24 ++--
 34 files changed, 424 insertions(+), 498 deletions(-)

