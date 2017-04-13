Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51250 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754357AbdDMPZT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 11:25:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 13 Apr 2017 18:24:41 +0300
Message-Id: <20170413152507.9648-1-luca@coelho.fi> (sfid-20170413_172530_497882_E0250AA2)
Subject: [PATCH 00/26] iwlwifi: updates intended for v4.12 2017-04-13
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is the second patch set intended for v4.12.  These are the changes:

 * A large amount of work on the A000 device series;
 * A couple of cleanup patches;
 * Dynamic SAR support;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Emmanuel Grumbach (1):
  iwlwifi: mvm: tell the firmware about the U-APSD parameters

Goodstein, Mordechay (1):
  iwlwifi: mvm: move new API code to the end

Haim Dreyfuss (1):
  iwlwifi: mvm: refactor SAR init to prepare for dynamic SAR

Luca Coelho (3):
  iwlwifi: mvm: spin off SAR profile selection function
  iwlwifi: mvm: add support for EWRD (Dynamic SAR) ACPI table
  iwlwifi: mvm: remove unnecessary debugging from UMAC scan

Sara Sharon (20):
  iwlwifi: mvm: read new secure boot registers
  iwlwifi: mvm: add queues after adding station
  iwlwifi: cleanup unused function
  iwlwifi: mvm: prepare for station count change
  iwlwifi: mvm: use same scan API for all a000 devices
  iwlwifi: mvm: disable multi-queue for a000 devices
  iwlwifi: mvm: support new TX API
  iwlwifi: pcie: introduce a000 TX queues management
  iwlwifi: mvm: support a000 SCD queue configuration
  iwlwifi: mvm: support moving to mgmt tid
  iwlwifi: pcie: copy TX functions to new transport
  iwlwifi: pcie: cleanup old transport code from gen2
  iwlwifi: pcie: support new TX command
  iwlwifi: pcie: rewrite TFD creation
  iwlwifi: pcie: support host commands in new transport
  iwlwifi: pcie: support new write pointer width
  iwlwifi: pcie: remove block and freeze operations from new transport
  iwlwifi: pcie: prepare for dynamic queue allocation
  iwlwifi: pcie: introduce new stop_device
  iwlwifi: pcie: alloc queues dynamically

 drivers/net/wireless/intel/iwlwifi/Makefile        |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  10 -
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  71 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-mac.h    |   4 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-scan.h   |  14 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-sta.h    |  16 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h |  42 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 298 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  16 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  17 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  71 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  85 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c        |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 192 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      |  22 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tof.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  84 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  45 +-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  42 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   9 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   | 147 +++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  48 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 996 +++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 207 ++---
 34 files changed, 1996 insertions(+), 484 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c

-- 
2.11.0
