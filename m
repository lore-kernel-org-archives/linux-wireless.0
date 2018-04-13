Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39324 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754147AbeDMMnE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 08:43:04 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Apr 2018 15:42:31 +0300
Message-Id: <20180413124256.21769-1-luca@coelho.fi> (sfid-20180413_144308_813701_E7871892)
Subject: [PATCH 00/25] iwlwifi: updates intended for v4.18 2018-04-13
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the first batch of patches intended for 4.18.  The biggest
change is the inclusion of TCM (Traffic Condition Monitor), which has
been in our internal tree for ages, but just now we decided to send it
upstream.  The rest is normal development work.

* implement Traffic Condition Monitor;
* use TCM for scan and BT coex;
* use TCM to detect when the AP doesn't support UAPSD properly;
* some more work for the 22000 family of devices;
* introduce AMSDU rate control offload;
* a couple of clean-ups and bugfixes.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Emmanuel Grumbach (3):
  iwlwifi: mvm: BT Coex - make the primary / secondary pick traffic
    aware
  iwlwifi: pcie: implement the overlow queue for Gen2 devices
  iwlwifi: mvm: set the MFP flag for keys that are used by MFP stations

Gregory Greenman (1):
  iwlwifi: mvm: support offload of AMSDU rate control

Haim Dreyfuss (1):
  iwlwifi: move timestamp functions from debugfs.h to dbg.h

Johannes Berg (2):
  iwlwifi: mvm: detect U-APSD breaking aggregation
  iwlwifi: mvm: clean up scan capability checks

Liad Kaufman (2):
  iwlwifi: support api ver2 of NVM_GET_INFO resp
  iwlwifi: mvm: support 22000 HW opening agg before traffic

Luca Coelho (5):
  iwlwifi: mvm: add traffic condition monitoring (TCM)
  iwlwifi: mvm: use TCM data to decide scan priority
  iwlwifi: mvm: fix OOC priority in scans
  iwlwifi: use flags to denote modifiers for the channel maps
  iwlwifi: remove upper case letters in sku_capa_band_*_enable

Naftali Goldstein (1):
  iwlwifi: mvm: update rs-fw API

Sara Sharon (7):
  iwlwifi: mvm: detect low latency and traffic load per band
  iwlwifi: pcie: allocate shorter TX queues for 22000 devices
  iwlwifi: Revert "iwlwifi: pcie: dynamic Tx command queue size"
  iwlwifi: add TX queue size parameter to TX queue allocation
  iwlwifi: pcie: use the queue size as sent by opmode
  iwlwifi: mvm: use shorter queues for mgmt and auxilary queues
  iwlwifi: mvm: use the new get_tid function

Shaul Triebitz (3):
  iwlwifi: move all NVM parsing code to the common files
  iwlwifi: pcie: gen2: fix race in cmd fifo write ptr
  iwlwifi: get rid of fw/nvm.c

 drivers/net/wireless/intel/iwlwifi/Makefile        |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   1 -
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |   8 +-
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |   5 -
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |  42 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     | 156 +++-----
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h    |   2 +
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |  36 ++
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h    |  31 --
 drivers/net/wireless/intel/iwlwifi/fw/nvm.c        | 162 --------
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |   1 -
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   5 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.c  |   4 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.h  |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 354 +++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h |  56 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |  37 ++
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |   7 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   7 +
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  25 ++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  33 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       | 102 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       | 208 +---------
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     | 117 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        | 103 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 194 ++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  28 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  57 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     | 437 ++++++++++++++++++++-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   5 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  55 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  28 +-
 42 files changed, 1613 insertions(+), 776 deletions(-)
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/fw/nvm.c

-- 
2.16.3
