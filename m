Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50508 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751876AbdDKMhx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:37:53 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:17 +0300
Message-Id: <20170411123742.12214-1-luca@coelho.fi> (sfid-20170411_143759_356153_3A7EB0C2)
Subject: [PATCH 00/25] iwlwifi: updates intended for v4.12 2017-04-11
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is my first patch set intended for v4.12.  These are the changes:

 * Some small fixes here and there;
 * The usual cleanups and small improvements;
 * Work to support A000 devices continues;
 * New FW API version;
 * Some debugging improvements;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Emmanuel Grumbach (2):
  iwlwifi: mvm: add DQA_ENABLE_CMD to the command list
  iwlwifi: pcie: print less data upon firmware crash

Golan Ben-Ami (1):
  iwlwifi: mvm: support MFUART dump in case of MFUART assert

Johannes Berg (3):
  iwlwifi: mvm: fix RX SKB header size and align it properly
  iwlwifi: use upper_32_bits/lower_32_bits where appropriate
  iwlwifi: pcie: use iwl_get_dma_hi_addr()

Liad Kaufman (1):
  iwlwifi: add support for 9000 HW B-step NICs

Luca Coelho (4):
  iwlwifi: be more verbose about needed firmware
  iwlwifi: remove support for deprecated RF
  iwlwifi: mvm: bump max API to 30
  iwlwifi: remove unnecessary dev_cmd_headroom parameter

Sara Sharon (14):
  iwlwifi: mvm: support new binding API
  iwlwifi: mvm: adjust new API of compressed BA
  iwlwifi: mvm: cleanup pending frames in DQA mode
  iwlwifi: mvm: add multicast station
  iwlwifi: mvm: support new ADD_MODIFY_STA_KEY command
  iwlwifi: mvm: optimize reorder timeout frame releasing
  iwlwifi: mvm: don't assume static queue numbers
  Revert "iwlwifi: introduce trans API to get byte count table"
  iwlwifi: pcie: remove the active field in struct iwl_txq
  iwlwifi: pcie: use WFPM_GP for debugging D3 flows
  iwlwifi: pcie: introduce split point to a000 devices
  iwlwifi: pcie: add context information support
  iwlwifi: mvm: remove call for paging in new init flow
  iwlwifi: mvm: separate queue mapping from queue enablement

 drivers/net/wireless/intel/iwlwifi/Makefile        |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c      |  46 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c      |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  12 +-
 .../net/wireless/intel/iwlwifi/iwl-context-info.h  | 203 +++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   1 -
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  34 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |   6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h   |   5 +
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |   7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  28 +--
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c   |  17 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  20 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-sta.h    |  34 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |  40 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  32 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  34 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  25 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  12 +
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  18 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 241 ++++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  49 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  34 ++-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    | 274 +++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  17 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  53 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  48 +++-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   | 226 +++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 218 ++++++++--------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  99 +++++---
 38 files changed, 1462 insertions(+), 422 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-context-info.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c

-- 
2.11.0
