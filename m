Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38560 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729568AbeG0OKi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 10:10:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 27 Jul 2018 15:48:22 +0300
Message-Id: <20180727124838.25910-1-luca@coelho.fi> (sfid-20180727_144853_587522_18CCD1CC)
Subject: [PATCH 00/16] iwlwifi: updates intended for v4.19 2018-07-27
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's one more set of patches intended for v4.19.  It contains some
bugfixes, cleanups and more work on supporting the 22560 family of
devices.

The changes are:

* New PCI IDs for 22000 and 22560;
* Some fixes and an improvement in debug dumps and recording;
* Remove some old dead code;
* Fix compilation when only IPv6 is not enabled;
* Continued work on 22560 devices;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Emmanuel Grumbach (1):
  iwlwifi: pcie: don't access periphery registers when not available

Golan Ben Ami (4):
  iwlwifi: pcie: support rx structures for 22560 devices
  iwlwifi: support new rx_mpdu_desc api
  iwlwifi: hard code power save mode to CAM for 22560 devices
  iwlwifi: move some msix and rx functions to a common place

Luca Coelho (4):
  iwlwifi: pcie: add a bunch of PCI IDs for 22000 and 22560
  iwlwifi: d3: disable dbg recording before entering D3
  iwlwifi: mvm: remove dead gscan code
  iwlwifi: pcie: include tcp.h implicitly

Sara Sharon (6):
  iwlwifi: pcie: unionize used bd and completion descriptor
  iwlwifi: pcie: move rxb retrieval to a helper function
  iwlwifi: trans: add a new op for getting DMA data
  iwlwifi: mvm: configure multi RX queue
  Revert "iwlwifi: implement fseq version mismatch warning"
  iwlwifi: pcie: split tx to amsdu and non amsdu

Shahar S Matityahu (1):
  iwlwifi: allow masking out memory areas from the fw dump

 drivers/net/wireless/intel/iwlwifi/Makefile   |   1 -
 .../net/wireless/intel/iwlwifi/cfg/22000.c    |   2 +-
 .../net/wireless/intel/iwlwifi/fw/api/alive.h |  18 +-
 .../wireless/intel/iwlwifi/fw/api/commands.h  |   7 -
 .../wireless/intel/iwlwifi/fw/api/datapath.h  |   7 +
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    | 211 ++++++++++---
 .../net/wireless/intel/iwlwifi/fw/common_rx.c |  88 ------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 284 ++++++++++--------
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  40 +--
 drivers/net/wireless/intel/iwlwifi/fw/img.h   |  37 +--
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |   3 -
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  67 +----
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  27 ++
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |   7 +
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  48 ++-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |   7 -
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |  95 ++++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  25 +-
 .../wireless/intel/iwlwifi/pcie/internal.h    |  78 ++++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  | 170 +++++++----
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 174 ++++++-----
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 150 ++++++---
 24 files changed, 936 insertions(+), 638 deletions(-)
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/fw/common_rx.c

-- 
2.18.0
