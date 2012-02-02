Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22467 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab2BCAQu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:50 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/28] update for 3.4: iwlwifi 2012-02-02
Date: Thu,  2 Feb 2012 15:08:51 -0800
Message-Id: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011654_090202_2893B100)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We doing a lot of preparation works and get ready to split the driver into
two separate layers in order to accommodate the new architecture.

Amit Beka (1):
  iwlwifi: range check to testmode direct reg access

Don Fry (3):
  iwlwifi: clarify comment
  iwlwifi: move bcast_sta_id init to common routine
  iwlwifi: move all ucode routines to iwl-ucode.c

Emmanuel Grumbach (22):
  iwlwifi: add fw_alive to transport layer API, kill tx_start
  iwlwifi: separate the APM from the EEPROM
  iwlwifi: move the shrd memory from priv
  iwlwifi: allocate the transport from the bus layer
  iwlwifi: move the bus configuration to transport
  iwlwifi: the read / write register ops move to transport
  iwlwifi: give trans to all the read / write functions
  iwlwifi: remove the pointer to dev from the bus layer
  iwlwifi: don't use the bus for ucode fw_desc any more
  iwlwifi: rename trans_ops->request_irq to trans_ops->start_hw
  iwlwifi: move prepare_card_hw to start_hw
  iwlwifi: move apm_init to start_hw
  iwlwifi: introduce trans_ops->stop_hw
  iwlwifi: move the RF kill logic from iwl_probe to transport
  iwlwifi: consolidate the start_device flow
  iwlwifi: kill bus_apm_config
  iwlwifi: kill bus_is_pm_supported
  iwlwifi: kill bus_get_hw_id_string
  iwlwifi: kill bus_get_hw_id
  iwlwifi: move hw_rev to transport layer
  iwlwifi: stop_hw replace enable_rfkill_int
  iwlwifi: debug print in tx_queue_set_status is more clear

Gregory Greenman (1):
  iwlwifi: Connect IDI transport to driver.

Johannes Berg (1):
  iwlwifi: release IRQ in error path

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-1000.c           |    6 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c           |    6 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c           |   10 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c         |   14 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |  713 +-------------------
 drivers/net/wireless/iwlwifi/iwl-agn.h            |    3 +-
 drivers/net/wireless/iwlwifi/iwl-bus.h            |   64 --
 drivers/net/wireless/iwlwifi/iwl-core.c           |  128 +----
 drivers/net/wireless/iwlwifi/iwl-core.h           |    6 -
 drivers/net/wireless/iwlwifi/iwl-debug.h          |   16 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |    6 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |  109 ---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c         |   65 +-
 drivers/net/wireless/iwlwifi/iwl-io.c             |  193 +++---
 drivers/net/wireless/iwlwifi/iwl-io.h             |   60 +-
 drivers/net/wireless/iwlwifi/iwl-led.c            |    9 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       |   36 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c            |  229 +------
 drivers/net/wireless/iwlwifi/iwl-power.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    2 -
 drivers/net/wireless/iwlwifi/iwl-testmode.c       |   36 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |   18 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |  103 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   55 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |  661 +++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-trans.h          |  133 +++--
 drivers/net/wireless/iwlwifi/iwl-ucode.c          |  740 ++++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-ucode.h          |  178 +++++
 30 files changed, 1837 insertions(+), 1776 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-ucode.h

