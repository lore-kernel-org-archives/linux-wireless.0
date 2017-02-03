Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37826 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752721AbdBCOiZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:38:25 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:37:47 +0200
Message-Id: <20170203143812.7525-1-luca@coelho.fi> (sfid-20170203_153828_914227_CC0AEC7C)
Subject: [PATCH 00/25] iwlwifi: updates intended for v4.11 2017-02-03
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's my second series for v4.11.  These are the changes:

  * A bunch of bugfixes for the DQA code;
  * Work on support for new A000 devices continues;
  * Some clean-ups and general improvements;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Beni Lev (1):
  iwlwifi: mvm: Use aux queue for offchannel frames in dqa

Emmanuel Grumbach (1):
  iwlwifi: mvm: fix PS-Poll enablement

Golan Ben-Ami (1):
  iwlwifi: mvm: support v2 of mfuart load notification

Johannes Berg (7):
  iwlwifi: mvm: reduce usage of IEEE80211_SKB_CB()
  iwlwifi: mvm: fix D3 replay counter value
  iwlwifi: mvm: set AID to firmware only for associated stations
  iwlwifi: mvm: overwrite skb info later
  iwlwifi: mvm/pcie: adjust A-MSDU tx_cmd length in PCIe
  iwlwifi: mvm: align copy-break SKB payload for MQ RX
  iwlwifi: pcie: fix another RF-kill race

Liad Kaufman (1):
  iwlwifi: mvm: release static queues on bcast release

Luca Coelho (2):
  iwlwifi: remove unnecessary argument to iwl_drv_start()
  iwlwifi: remove unnecessary cfg element in iwl_drv

Sara Sharon (12):
  iwlwifi: mvm: support unification of INIT and RT images
  iwlwifi: mvm: cleanup incorrect and redundant define
  iwlwifi: mvm: support new statistics APIs
  iwlwifi: mvm: support new scan API
  iwlwifi: mvm: always free inactive queue when moving ownership
  iwlwifi: mvm: support new alive notification
  iwlwifi: mvm: synchronize firmware DMA paging memory
  iwlwifi: pcie: fix the set of DMA memory mask
  iwlwifi: mvm: fix pending frame counter calculation
  iwlwifi: mvm: cleanup iwl_mvm_tx_mpdu a bit
  iwlwifi: support two phys for a000 devices
  iwlwifi: mvm: support new beacon template command

 drivers/net/wireless/intel/iwlwifi/iwl-a000.c      |  30 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  25 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h       |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   4 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-mac.h    |   7 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-scan.h   | 106 ++++--
 .../net/wireless/intel/iwlwifi/mvm/fw-api-stats.h  |  29 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h |  29 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |  90 ++----
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c    |   4 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 354 +++++++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  | 105 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  24 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  18 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  24 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |  44 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  70 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 230 +++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 227 +++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 112 +++----
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  16 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  17 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   2 +
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  23 +-
 30 files changed, 1035 insertions(+), 587 deletions(-)

-- 
2.11.0
