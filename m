Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54102 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1954128AbdDYUXB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:23:01 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:18 +0300
Message-Id: <20170425202243.7844-1-luca@coelho.fi> (sfid-20170425_222321_598521_82C55050)
Subject: [PATCH 00/25] iwlwifi: updates intended for v4.12 2017-04-25
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

One more patch set intended for v4.12.  These are the changes:

 * The firmware for 7265D and 3168 NICs is frozen at version 29;
 * Sari continues working heavily on support for A000 series;
 * A bunch of fixes;
 * Some cleanups here and there;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Dor Shaish (1):
  iwlwifi: mvm: freeze 7265D and 3168 on API version 29

Haim Dreyfuss (1):
  iwlwifi: mvm: Ignore wifi mcc update in the driver while associated

Johannes Berg (6):
  iwlwifi: mvm: make iwl_run_unified_mvm_ucode() static
  iwlwifi: mvm: avoid variable shadowing
  iwlwifi: pcie: remove superfluous trans->dev assignment
  iwlwifi: don't leak memory on allocation failure
  iwlwifi: remove module loading failure message
  iwlwifi: pcie: apply no-reclaim logic only to group 0

Liad Kaufman (2):
  iwlwifi: pcie: support debug applying on a000 hw
  iwlwifi: gen2: support nmi triggering from host

Mordechai Goodstein (1):
  iwlwifi: mvm: scan: avoid "big" prints

Sara Sharon (12):
  iwlwifi: mvm: support new rate flags
  iwlwifi: mvm: don't reserve queue in TVQM mode
  iwlwifi: mvm: map cab_queue to different txq_id
  iwlwifi: mvm: move internally to use bigger INVALID_TXQ
  iwlwifi: mvm: remove color definition
  iwlwifi: mvm: use defines instead of variables for shared dwell times
  iwlwifi: mvm: remove references to queue_info in new TX path
  iwlwifi: mvm: support station type API
  iwlwifi: move to 512 queues
  iwlwifi: rename wait_for_tx_queues_empty
  iwlwifi: mvm: memset binding before setting values
  iwlwifi: adjust NVM parsing APIs for new a000 method

Sharon Dvir (2):
  iwlwifi: mvm: check if returned value is NULL
  iwlwifi: mvm: handle possible BIOS bug

 drivers/net/wireless/intel/iwlwifi/dvm/lib.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  15 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h   |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |   3 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  32 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h |  16 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c   |   4 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-mac.h    |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h |  28 ++-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-sta.h    |  38 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 161 ++++++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  37 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  86 +++-----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 229 ++++++++++++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  96 ++++++---
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |   4 +
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   7 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   5 +-
 34 files changed, 521 insertions(+), 350 deletions(-)

-- 
2.11.0
