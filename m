Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2830 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab2CJU7Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 15:59:25 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/10] update for 3.4: iwlwifi 2012-03-10
Date: Sat, 10 Mar 2012 13:00:05 -0800
Message-Id: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120310_215956_566516_DCC11AEA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We adding 16.0 uCode support which has different TLV layout.
We are continue the driver re-factor works to separate the driver into
upper(op-mode) and lower layers.

David Spinadel (6):
  iwlwifi: avoid some operations if no uCode loaded
  iwlwifi: explicitly track whether INIT uCode was run
  iwlwifi: more modularity in fw images and sections
  iwlwifi: Add TLVs and fields for 16.0 uCode
  iwlwifi: change struct iwl_fw
  iwlwifi: Add bool mvm_ucode to iwl_fw

Johannes Berg (3):
  iwlwifi: remove TX hex debug
  iwlwifi: abstract out missing SEQ_RX_FRAME workaround
  iwlwifi: convert bad state message into warning

Meenakshi Venkataraman (1):
  iwlwifi: move wait_command_queue from shared to trans

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   14 +-
 drivers/net/wireless/iwlwifi/iwl-core.c           |    5 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |   14 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    2 +
 drivers/net/wireless/iwlwifi/iwl-drv.c            |  430 ++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-fw-file.h        |    5 +
 drivers/net/wireless/iwlwifi/iwl-fw.h             |   49 ++-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       |   15 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h         |   20 -
 drivers/net/wireless/iwlwifi/iwl-testmode.c       |   27 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    2 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |   31 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   44 ++-
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   40 ++-
 drivers/net/wireless/iwlwifi/iwl-ucode.c          |   39 +-
 18 files changed, 511 insertions(+), 233 deletions(-)

