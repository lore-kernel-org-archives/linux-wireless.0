Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53534 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab1GUP0q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:46 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/25] update for 3.1
Date: Thu, 21 Jul 2011 07:50:03 -0700
Message-Id: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172656_499477_3BEE0ACD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add WoWLAN implementation to iwlwifi
Continue the work on transport layer, also fix an irq bug introduced
by transport layer earlier
Some more work on new 105/135 device support

Emmanuel Grumbach (11):
  iwlagn: add kick_nic API to transport layer
  iwlagn: kill iwlagn_rx_handler_setup
  iwlagn: kill iwlagn_setup_deferred_work
  iwlagn: SCD configuration for AMPDU moves to transport layer
  iwlagn: move more functions from the start flow to the transport
    layer
  iwlagn: move iwl_prepare_card_hw to the transport layer
  iwlagn: transport layer receives struct iwl_trans*
  iwlagn: simplify the bus architecture
  iwlagn: iwl_bus holds drv_data as void * instead of iwl_priv
  iwlagn: add comment to warn about WoWLAN in resume / suspend flows
  iwlagn: probe would crash with DEBUG_SHIRQ

Johannes Berg (6):
  iwlagn: remove keyinfo cache
  iwlagn: remove forgotten debugfs function
  iwlagn: rewrite HW crypto
  iwlagn: implement WoWLAN
  iwlagn: track beacon interval sent to device
  iwlagn: rename iwlagn_set_dynamic_key

Wey-Yi Guy (8):
  iwlagn: set correct calibration flag
  iwlagn: remove legacy calibration command
  iwlagn: define valid init calibration mask
  iwlagn: radio sensor offset in le16 format
  iwlagn: testmode fixed rate available for testmode only
  iwlagn: remove un-necessary "_agn"
  iwlagn: write iq invert register for 105/135 device
  iwlagn: remove "disable otp refresh" W/A

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-1000.c           |    2 -
 drivers/net/wireless/iwlwifi/iwl-2000.c           |   18 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c           |    6 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c           |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c      |   10 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |  243 ++-----
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |   40 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c        |  380 +++++------
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |  232 +------
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c      |   45 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |  789 ++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.h            |   32 +-
 drivers/net/wireless/iwlwifi/iwl-bus.h            |  139 ++++
 drivers/net/wireless/iwlwifi/iwl-commands.h       |  161 ++++-
 drivers/net/wireless/iwlwifi/iwl-core.c           |   28 +-
 drivers/net/wireless/iwlwifi/iwl-core.h           |   13 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h            |    1 +
 drivers/net/wireless/iwlwifi/iwl-debug.h          |   10 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |   87 ++-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |  213 ++----
 drivers/net/wireless/iwlwifi/iwl-io.h             |    7 +-
 drivers/net/wireless/iwlwifi/iwl-led.c            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c            |  101 ++--
 drivers/net/wireless/iwlwifi/iwl-pci.h            |   69 --
 drivers/net/wireless/iwlwifi/iwl-power.c          |    8 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c             |   36 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c           |    8 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c            |    8 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h            |    5 +-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c        |   10 +-
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |   14 +-
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c  |  110 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |  240 ++++++-
 drivers/net/wireless/iwlwifi/iwl-trans.c          |  234 ++++++-
 drivers/net/wireless/iwlwifi/iwl-trans.h          |  143 +++-
 36 files changed, 2082 insertions(+), 1380 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-bus.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-pci.h

