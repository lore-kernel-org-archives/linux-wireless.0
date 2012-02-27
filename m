Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4551 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044Ab2B0XTB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:01 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/24] update for 3.4: iwlwifi 2012-02-27
Date: Mon, 27 Feb 2012 14:07:24 -0800
Message-Id: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_001907_282490_F5C4FCF2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We start the re-factor works and get ready for our next generation of driver
architecture, a lot of code being move around and make the driver more flexible
and can be virtualize.
We also adding new SKU supports to 6005 and 6x35 series devices

Emmanuel Grumbach (21):
  iwlwifi: parse_tlv functions set the fw_version string
  iwlwifi: move content of iwl_probe to post fetch_fw
  iwlwifi: introducing the drv object's flows
  iwlwifi: drv object can release its own memory
  iwlwifi: rename iwl_remove to iwl_op_mode_dvm_stop
  iwlwifi: virtualize the op_mode
  iwlwifi: use sparse compliant __aligned__ attribute
  iwlwifi: virtualize op_mode's free skb
  iwlwifi: virtualize op_mode's rx
  iwlwifi: virtualize op_mode's stop/start queue
  iwlwifi: virtualize op_mode's set_hw_rf_kill
  iwlwifi: virtualize op_mode's fw_error
  iwlwifi: remove a few dereferences to iwl_priv from the tansport
  iwlwifi: move eeprom defines to iwl-eeprom.c
  iwlwifi: eeprom gets transport and not bus
  iwlwifi: kill iwl_bus.h
  iwlwifi: remove iwl_print_rx_config_cmd from shared
  iwlwifi: remove iwl_reset_traffic_log from shared
  iwlwifi: document the operational mode
  iwlwifi: iwl-trans.h doesn't need all these includes
  iwlwifi: fix IDI compilation

Johannes Berg (1):
  iwlwifi: move uCode flags handling to op_mode

Wey-Yi Guy (2):
  iwlwifi: one more sku added to 6x35 series
  iwlwifi: update pci subsystem id

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/Makefile             |    1 +
 drivers/net/wireless/iwlwifi/iwl-6000.c           |   11 ++
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |   16 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   95 +++++++++--
 drivers/net/wireless/iwlwifi/iwl-agn.h            |   19 ++
 drivers/net/wireless/iwlwifi/iwl-bus.h            |  145 ---------------
 drivers/net/wireless/iwlwifi/iwl-cfg.h            |    2 +
 drivers/net/wireless/iwlwifi/iwl-core.c           |   30 +++-
 drivers/net/wireless/iwlwifi/iwl-core.h           |    2 +
 drivers/net/wireless/iwlwifi/iwl-debug.h          |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h            |   12 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c            |  103 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-drv.h            |  123 +++++++++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom.c         |  156 +++++++++--------
 drivers/net/wireless/iwlwifi/iwl-eeprom.h         |    3 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       |   63 ++++---
 drivers/net/wireless/iwlwifi/iwl-op-mode.h        |  198 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-pci.c            |   86 ++++------
 drivers/net/wireless/iwlwifi/iwl-shared.h         |   32 +----
 drivers/net/wireless/iwlwifi/iwl-testmode.c       |   21 +--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    5 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |   18 +--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |    7 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |    7 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   31 ++--
 drivers/net/wireless/iwlwifi/iwl-ucode.c          |  129 +++++---------
 drivers/net/wireless/iwlwifi/iwl-ucode.h          |    5 +-
 drivers/net/wireless/iwlwifi/iwl-wifi.h           |    4 +
 31 files changed, 842 insertions(+), 492 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-bus.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-drv.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-drv.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-op-mode.h

