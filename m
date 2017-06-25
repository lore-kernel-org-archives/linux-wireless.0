Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34832 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751066AbdFYLMH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:12:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:32 +0300
Message-Id: <20170625111158.1792-1-luca@coelho.fi> (sfid-20170625_131234_196634_0B3AC2AA)
Subject: [PATCH 00/26] iwlwifi: updates intended for v4.13 2017-06-25
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

More patches intended for 4.13.  These are the changes:

* Support for a new version of the TX flush FW API;
* Some fixes in monitor interfaces;
* A few fixes in the recovery flows;
* Documentation fixes and FW API struct cleanups;
* Remove some noise from the kernel logs;
* Clean-ups and small fixes here and there.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a comnined pull-request with the previous bunch later.

Please review.

Cheers,
Luca.

Avraham Stern (1):
  iwlwifi: mvm: set assoc_beacon_arrive_time

Chaya Rachel Ivgi (1):
  iwlwifi: mvm: fix typo in CTDP_CMD_OPERATION_REPORT description

Emmanuel Grumbach (5):
  iwlwifi: mvm: fix the recovery flow while connecting
  iwlwifi: mvm: don't mark TIDs that are not idle wrt BA as inactive
  iwlwifi: add a W/A for a scheduler hardware bug
  iwlwifi: mvm: reset the fw_dump_desc pointer after ASSERT
  iwlwifi: pcie: delete the Tx queue timer earlier upon firmware crash

Johannes Berg (9):
  iwlwifi: simplify data tracepoint
  iwlwifi: fix TX tracing for non-linear SKBs
  iwlwifi: pcie: fix command completion name debug
  iwlwifi: mvm: docs: fix enum link, provide TX response link
  iwlwifi: mvm: disentangle union in TX status struct
  iwlwifi: mvm: add documentation for enum iwl_debug_cmds
  iwlwifi: document transmit buffer bits better
  iwlwifi: pcie: make iwl_pcie_apm_stop_master() return void
  iwlwifi: pcie: work around suspend/resume issue

Liad Kaufman (2):
  iwlwifi: mvm: fix fw monitor 7000 HW recollecting
  iwlwifi: mvm: support TX on MONITOR iface

Luca Coelho (7):
  iwlwifi: remove useless iwl_free_nvm_data() function
  iwlwifi: mvm: fix nvm_data leak
  iwlwifi: pcie: don't disable bh when handling FW errors
  iwlwifi: mvm: reset the HW before dumping if HW error is detected
  iwlwifi: mvm: document assoc_beacon_arrive_time
  iwlwifi: mvm: print base HW address during init
  iwlwifi: pcie: reduce unwanted noise in the logs

Mordechai Goodstein (1):
  iwlwifi: mvm: support new flush API

 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |  4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |  4 +
 .../net/wireless/intel/iwlwifi/iwl-devtrace-data.h | 11 +--
 .../wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h  | 19 +++--
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.h  |  9 ---
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        | 18 ++++-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  2 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     | 13 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   | 19 ++++-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-mac.h    |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h | 89 ++++++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    | 23 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c    |  6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 32 ++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       | 13 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       | 10 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       | 20 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 68 ++++++++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 50 +++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     | 86 +++++++++++++++------
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       | 10 +--
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 23 ++++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 33 ++++++--
 26 files changed, 413 insertions(+), 164 deletions(-)

-- 
2.11.0
