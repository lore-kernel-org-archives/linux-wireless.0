Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35744 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751501AbdF1UNt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:13:49 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:12:59 +0300
Message-Id: <20170628201330.9432-1-luca@coelho.fi> (sfid-20170628_221353_616831_70945C41)
Subject: [PATCH 00/31] iwlwifi: updates intended for v4.13 2017-06-28
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi Kalle,

Here is one more batch that I'd like to get into v4.13, hopefully it's
not too late.  I'm also going to send some more tomorrow.  The changes
are:

* Some important fixes for 9000 HW;
* FW API changes for the upcoming -30 ucode release;
* A few new PCI IDs for 9000 series;
* Reorganization of common files;
* Some more fixes and improvements here and there

Thanks!

Cheers,
Luca.


Emmanuel Grumbach (1):
  iwlwifi: mvm: change when the BT_COEX is sent

Haim Dreyfuss (2):
  iwlwifi: mvm: refactor geo init
  iwlwifi: mvm: Add debugfs entry to retrieve SAR geographic profile

Johannes Berg (22):
  iwlwifi: mvm: remove some CamelCase from firmware API
  iwlwifi: mvm: fix various "Excess ... description" kernel-doc warnings
  iwlwifi: mvm: remove various unused command IDs/structs
  iwlwifi: mvm: use __le16 even for reserved fields
  iwlwifi: mvm: add documentation for all command IDs
  iwlwifi: mvm: fix a bunch of kernel-doc warnings
  iwlwifi: dvm: use macros for format strings
  iwlwifi: pcie: only apply retention workaround on 9000-series A-step
  iwlwifi: pcie: fix 9000-series RF-kill interrupt propagation
  iwlwifi: mvm: use proper CDB check in PHY context modify
  iwlwifi: pcie: improve "invalid queue" warning
  iwlwifi: pcie: improve debug in iwl_pcie_rx_handle_rb()
  iwlwifi: unify external & internal modparam names
  iwlwifi: pcie: make ctxt-info free idempotent
  iwlwifi: pcie: warn if paging is already initialized during init
  iwlwifi: mvm: unconditionally stop device after init
  iwlwifi: mvm: fix deduplication start logic
  iwlwifi: mvm: rename iwl_shared_mem_cfg_v1 to the correct _v2
  iwlwifi: create new subdirectory for FW interaction
  iwlwifi: move notification wait into fw/
  iwlwifi: move configuration into sub-directory
  iwlwifi: mvm: remove version 2 of paging command

Liad Kaufman (2):
  iwlwifi: mvm: support aggs of 64 frames in A000 family
  iwlwifi: mvm: support multi tid ba notif

Luca Coelho (1):
  iwlwifi: mvm: simplify CHECK_MLME_TRIGGER macro

Sharon Dvir (1):
  iwlwifi: mvm: change sta_id to u8

Tzipi Peres (2):
  iwlwifi: add the new a000_2ax series
  iwlwifi: add twelve new 9560 series PCI IDs

 drivers/net/wireless/intel/iwlwifi/Makefile        |   6 +-
 .../intel/iwlwifi/{iwl-1000.c => cfg/1000.c}       |   0
 .../intel/iwlwifi/{iwl-2000.c => cfg/2000.c}       |   0
 .../intel/iwlwifi/{iwl-5000.c => cfg/5000.c}       |   0
 .../intel/iwlwifi/{iwl-6000.c => cfg/6000.c}       |   0
 .../intel/iwlwifi/{iwl-7000.c => cfg/7000.c}       |   0
 .../intel/iwlwifi/{iwl-8000.c => cfg/8000.c}       |   0
 .../intel/iwlwifi/{iwl-9000.c => cfg/9000.c}       |   0
 .../intel/iwlwifi/{iwl-a000.c => cfg/a000.c}       |  10 +
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c   |  15 +-
 drivers/net/wireless/intel/iwlwifi/dvm/dev.h       |   4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c  |   8 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rxon.c      |   2 +-
 .../intel/iwlwifi/{iwl-fw-api.h => fw/api.h}       |  24 ++
 .../{iwl-fw-error-dump.h => fw/error-dump.h}       |   0
 .../intel/iwlwifi/{iwl-fw-file.h => fw/file.h}     |   0
 .../wireless/intel/iwlwifi/{iwl-fw.h => fw/img.h}  |  10 +-
 .../iwlwifi/{iwl-notif-wait.c => fw/notif-wait.c}  |   2 +-
 .../iwlwifi/{iwl-notif-wait.h => fw/notif-wait.h}  |   0
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  14 +-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h |  16 +-
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c    |  18 -
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  58 +++-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-coex.h   |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h |  11 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-mac.h    |   5 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-power.h  |   9 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h |  37 +--
 .../net/wireless/intel/iwlwifi/mvm/fw-api-scan.h   |  36 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-sta.h    |  63 +++-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-tof.h    |  14 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    | 370 ++++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h    |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 123 ++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  32 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  25 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  32 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  28 +-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |   7 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  22 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  10 +
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  37 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   2 +-
 59 files changed, 787 insertions(+), 350 deletions(-)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-1000.c => cfg/1000.c} (100%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-2000.c => cfg/2000.c} (100%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-5000.c => cfg/5000.c} (100%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-6000.c => cfg/6000.c} (100%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-7000.c => cfg/7000.c} (100%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-8000.c => cfg/8000.c} (100%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-9000.c => cfg/9000.c} (100%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-a000.c => cfg/a000.c} (94%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-fw-api.h => fw/api.h} (93%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-fw-error-dump.h => fw/error-dump.h} (100%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-fw-file.h => fw/file.h} (100%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-fw.h => fw/img.h} (98%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-notif-wait.c => fw/notif-wait.c} (99%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-notif-wait.h => fw/notif-wait.h} (100%)

-- 
2.11.0
