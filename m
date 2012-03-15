Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37228 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161254Ab2COU16 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:27:58 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/26] update for 3.4: iwlwifi 2012-03-15
Date: Thu, 15 Mar 2012 13:26:40 -0700
Message-Id: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212802_528558_5D7664F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anoth batch of re-factor works to prepare the next-gen device. We need to
separate the op-mode layer and device control layer in order to have the
single driver supports different core architecture.

David Spinadel (1):
  iwlwifi: phy_db structure

Don Fry (2):
  iwlwifi: move FW_ERROR to priv
  iwlwifi: split POWER_PMI status bit

Johannes Berg (11):
  iwlwifi: process multiple frames per RXB
  iwlwifi: extend notification wait
  iwlwifi: simplify calibration collection
  iwlwifi: add trailing newline to various messages
  iwlwifi: clarify config struct comments
  iwlwifi: remove support_wimax_coexist
  iwlwifi: remove iq_invert config param
  iwlwifi: remove scan_rx_antennas
  iwlwifi: use scan while idle
  iwlwifi: move queue mapping out of transport
  iwlwifi: move valid_contexts to priv

Meenakshi Venkataraman (11):
  iwlwifi: use iwlagn_fw_error instead of iwl_nic_error
  iwlwifi: make iwl_nic_error static
  iwlwifi: move ucode error log reporting to op_mode
  iwlwifi: move ucode_type from shared to op_mode
  iwlwifi: move iwl_init_geos to iwl-agn.c
  iwlwifi: Move iwl_send_rxon_timing and make it static
  iwlwifi: move iwl_set_rxon_hwcrypto and mark it static
  iwlwifi: move iwl_check_rxon_cmd and mark it static
  iwlwifi: move iwl_full_rxon_required and mark it static
  iwlwifi: move iwl_get_single_channel_number and mark it static
  iwlwifi: remove firmware info from iwl_shared

Wey-Yi Guy (1):
  iwlwifi: remove un-needed parameter

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/Kconfig              |    8 +
 drivers/net/wireless/iwlwifi/Makefile             |    2 +
 drivers/net/wireless/iwlwifi/iwl-1000.c           |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c           |   19 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c           |    1 -
 drivers/net/wireless/iwlwifi/iwl-6000.c           |    3 -
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h         |    3 -
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |   24 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |    7 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |  261 +++++++-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |  140 +++-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |  783 ++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn.h            |   23 +-
 drivers/net/wireless/iwlwifi/iwl-core.c           |  484 +-------------
 drivers/net/wireless/iwlwifi/iwl-core.h           |   15 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |   58 ++-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |   24 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       |   11 +-
 drivers/net/wireless/iwlwifi/iwl-notif-wait.c     |   44 +-
 drivers/net/wireless/iwlwifi/iwl-notif-wait.h     |   21 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h        |   17 +-
 drivers/net/wireless/iwlwifi/iwl-phy-db.c         |  273 +++++++
 drivers/net/wireless/iwlwifi/iwl-phy-db.h         |  123 ++++
 drivers/net/wireless/iwlwifi/iwl-power.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c           |   53 ++-
 drivers/net/wireless/iwlwifi/iwl-shared.h         |   32 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.c       |    9 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |  148 +----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |  514 ++------------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |  218 +-----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |  270 ++------
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   95 ++--
 drivers/net/wireless/iwlwifi/iwl-ucode.c          |  133 ++---
 34 files changed, 2044 insertions(+), 1779 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-phy-db.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-phy-db.h

