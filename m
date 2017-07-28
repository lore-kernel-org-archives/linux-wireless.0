Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40814 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751725AbdG1OX5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:23:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 28 Jul 2017 17:23:13 +0300
Message-Id: <20170728142337.19183-1-luca@coelho.fi> (sfid-20170728_162400_279373_6A4BA8C6)
Subject: [PATCH 00/24] iwlwifi: updates intended for v4.13 2017-07-28
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's my first set of patches for v4.14.  These are the changes:

* Reorganization of the code into separate directories continues;
* A couple of new minor features;
* Fixes and cleanups here and there.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Emmanuel Grumbach (4):
  iwlwifi: mvm: fix the FIFO numbers in A000 devices
  iwlwifi: pcie: fix A-MSDU on gen2 devices
  iwlwifi: mvm: fix TCP CSUM offload with WEP and A000 series
  iwlwifi: mvm: don't retake the pointer to skb's CB

Johannes Berg (13):
  iwlwifi: refactor out paging code
  iwlwifi: refactor shared mem parsing
  iwlwifi: track current firmware image in common code
  iwlwifi: refactor firmware debug code
  iwlwifi: reorganize firmware API
  iwlwifi: fw api: fix various kernel-doc warnings
  iwlwifi: mvm: add and use iwl_mvm_has_unified_ucode()
  iwlwifi: mvm: check family instead of new TX API for workarounds
  iwlwifi: mvm: byte-swap constant instead of variable
  iwlwifi: pcie: rename iwl_trans_check_hw_rf_kill() to pcie
  iwlwifi: mvm: require AP_LINK_PS for TVQM
  iwlwifi: mvm: simplify bufferable MMPDU check
  iwlwifi: mvm: remove non-DQA mode

Liad Kaufman (1):
  iwlwifi: mvm: support fw reading empty OTP

Luca Coelho (2):
  iwlwifi: mvm: refactor beacon template command code
  iwlwifi: mvm: rename p2p-specific sta functions to include p2p in the
    names

Mordechai Goodstein (1):
  iwlwifi: implement fseq version mismatch warning

Seraphime Kirkovski (1):
  iwlwifi: dvm: remove unused defines

Sharon Dvir (1):
  iwlwifi: mvm: fix uninitialized var while waiting for queues to empty

Zamir, Roee (1):
  iwlwifi: mvm: add compile-time option to disable EBS

 drivers/net/wireless/intel/iwlwifi/Makefile        |    2 +
 drivers/net/wireless/intel/iwlwifi/dvm/commands.h  |   16 -
 drivers/net/wireless/intel/iwlwifi/fw/api/alive.h  |  206 ++
 .../net/wireless/intel/iwlwifi/fw/api/binding.h    |  144 +
 .../intel/iwlwifi/fw/{api.h => api/cmdhdr.h}       |   78 +-
 .../iwlwifi/{mvm/fw-api-coex.h => fw/api/coex.h}   |   11 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |  664 +++++
 drivers/net/wireless/intel/iwlwifi/fw/api/config.h |  192 ++
 .../net/wireless/intel/iwlwifi/fw/api/context.h    |   94 +
 .../intel/iwlwifi/{mvm/fw-api-d3.h => fw/api/d3.h} |   11 +-
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |  127 +
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h  |  345 +++
 drivers/net/wireless/intel/iwlwifi/fw/api/filter.h |  183 ++
 .../net/wireless/intel/iwlwifi/fw/api/mac-cfg.h    |  152 ++
 .../iwlwifi/{mvm/fw-api-mac.h => fw/api/mac.h}     |   33 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |  386 +++
 .../net/wireless/intel/iwlwifi/fw/api/offload.h    |  101 +
 drivers/net/wireless/intel/iwlwifi/fw/api/paging.h |  108 +
 .../net/wireless/intel/iwlwifi/fw/api/phy-ctxt.h   |  164 ++
 drivers/net/wireless/intel/iwlwifi/fw/api/phy.h    |  258 ++
 .../iwlwifi/{mvm/fw-api-power.h => fw/api/power.h} |   13 +-
 .../intel/iwlwifi/{mvm/fw-api-rs.h => fw/api/rs.h} |   13 +-
 .../intel/iwlwifi/{mvm/fw-api-rx.h => fw/api/rx.h} |   31 +-
 .../iwlwifi/{mvm/fw-api-scan.h => fw/api/scan.h}   |   11 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/sf.h     |  138 +
 .../iwlwifi/{mvm/fw-api-sta.h => fw/api/sta.h}     |   15 +-
 .../iwlwifi/{mvm/fw-api-stats.h => fw/api/stats.h} |   13 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h   |  208 ++
 .../net/wireless/intel/iwlwifi/fw/api/time-event.h |  386 +++
 .../iwlwifi/{mvm/fw-api-tof.h => fw/api/tof.h}     |    9 +-
 .../intel/iwlwifi/{mvm/fw-api-tx.h => fw/api/tx.h} |   42 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h    |  163 ++
 drivers/net/wireless/intel/iwlwifi/fw/common_rx.c  |   88 +
 .../intel/iwlwifi/{mvm/fw-dbg.c => fw/dbg.c}       |  438 +--
 .../intel/iwlwifi/{mvm/fw-dbg.h => fw/dbg.h}       |  125 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |   75 +
 drivers/net/wireless/intel/iwlwifi/fw/paging.c     |  414 +++
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |  156 ++
 drivers/net/wireless/intel/iwlwifi/fw/smem.c       |  152 ++
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |    3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile    |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |    2 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   21 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    | 2845 +-------------------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  482 +---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  382 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  194 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  121 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |    7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  152 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |   25 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |    9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  452 +---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   18 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tof.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tof.h       |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  165 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   18 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |    4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |    2 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |    4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |    8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |    8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |    5 +-
 71 files changed, 5944 insertions(+), 4801 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/alive.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/binding.h
 rename drivers/net/wireless/intel/iwlwifi/fw/{api.h => api/cmdhdr.h} (82%)
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-coex.h => fw/api/coex.h} (96%)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/config.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/context.h
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-d3.h => fw/api/d3.h} (98%)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/filter.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-mac.h => fw/api/mac.h} (93%)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/offload.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/paging.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/phy-ctxt.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/phy.h
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-power.h => fw/api/power.h} (98%)
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-rs.h => fw/api/rs.h} (97%)
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-rx.h => fw/api/rx.h} (95%)
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-scan.h => fw/api/scan.h} (98%)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/sf.h
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-sta.h => fw/api/sta.h} (98%)
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-stats.h => fw/api/stats.h} (97%)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/time-event.h
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-tof.h => fw/api/tof.h} (98%)
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-api-tx.h => fw/api/tx.h} (98%)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/common_rx.c
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-dbg.c => fw/dbg.c} (69%)
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-dbg.h => fw/dbg.h} (59%)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/init.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/paging.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/runtime.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/smem.c

-- 
2.13.2
