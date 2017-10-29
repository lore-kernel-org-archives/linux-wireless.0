Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42264 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750848AbdJ2M22 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 08:28:28 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 29 Oct 2017 14:27:59 +0200
Message-Id: <20171029122816.8802-1-luca@coelho.fi> (sfid-20171029_132848_510531_685397EB)
Subject: [PATCH 00/17] iwlwifi: updates intended for v4.15 2017-10-29
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the fourth set of patches intended for 4.15.  Some fixes, some
cleanups, new PCI IDs... The usual.

These are the changes:

* Some new PCI IDs;
* A bunch of cleanups;
* The timers update by Kees;
* Add more register dump call-sites;
* A fix for a locking issue in the TX flush code;
* Actual implementation of the TX flush code for A000;
* An optimization to drop RX frames during restart to avoid BA issues;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Emmanuel Grumbach (3):
  iwlwifi: mvm: rs: remove the ANT C from the toogle antenna logic
  iwlwifi: remove dead code for internal devices only
  iwlwifi: remove host assisted paging

Ihab Zhaika (3):
  iwlwifi: add new cards for 8260 series
  iwlwifi: add new cards for 8265 series
  iwlwifi: add new cards for a000 series

Kees Cook (1):
  iwlwifi: mvm: Convert timers to use timer_setup()

Kirtika Ruchandani (1):
  iwlwifi: Add more call-sites for pcie reg dumper

Liad Kaufman (1):
  iwlwifi: mvm: reset seq num after restart

Luca Coelho (1):
  iwlwifi: mvm: hold mutex when flushing in iwl_mvm_flush_no_vif()

Sara Sharon (6):
  iwlwifi: mvm: use RS macro instead of duplicating the code
  iwlwifi: mvm: cleanup references to aggregation count limit
  iwlwifi: mvm: improve latency when there is a reorder timeout
  iwlwifi: fix multi queue notification for a000 devices
  iwlwifi: mvm: refactor iwl_mvm_flush_no_vif
  iwlwifi: mvm: add missing implementation of flush for a000 devices

Shahar S Matityahu (1):
  iwlwifi: drop RX frames during hardware restart

 drivers/net/wireless/intel/iwlwifi/cfg/8000.c      |  51 ----------
 drivers/net/wireless/intel/iwlwifi/fw/api/paging.h |  24 -----
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |   8 --
 drivers/net/wireless/intel/iwlwifi/fw/paging.c     | 103 +++------------------
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   3 -
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   2 -
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   6 --
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  42 +++------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  15 ---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  62 +++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   1 -
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  23 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  50 +++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  10 ++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   7 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   1 +
 20 files changed, 127 insertions(+), 300 deletions(-)

-- 
2.14.2
