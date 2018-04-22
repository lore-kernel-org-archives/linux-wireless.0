Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40804 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750814AbeDVI15 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Apr 2018 04:27:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 22 Apr 2018 11:27:33 +0300
Message-Id: <20180422082745.9743-1-luca@coelho.fi> (sfid-20180422_102805_927353_72CA872E)
Subject: [PATCH 00/12] iwlwifi: updates intended for v4.18 2018-04-22
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the second batch of patches intended for 4.18.  Normal
development work this time.  The patches include these changes:

* Some preparations for new hardware;
* A workaround to rescan the bus for the rare situation when older
  devices become irresponsive,
* Hardening of the firmware loading code to avoid issues with
  corrupted files;
* A few clean-ups and bugfixes.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Eliad Peller (2):
  iwlwifi: pcie: allow sending pre-built A-MSDUs
  iwlwifi: mvm: set wakeup filters for wowlan "any" configuration

Golan Ben Ami (2):
  iwlwifi: allow different csr flags for different device families
  iwlwifi: support new csr addresses for hw address

Golan Ben-Ami (1):
  iwlwifi: introduce Image Loader (IML) - new firmware image

Johannes Berg (1):
  iwlwifi: mvm: move skb padding reservation earlier

Luca Coelho (5):
  iwlwifi: cfg: remove unnecessary cfg data in non-dvm devices
  iwlwifi: fw: harden page loading code
  iwlwifi: fw: combine loading of last page block into main copy loop
  iwlwifi: pcie: remove non-responsive device
  iwlwifi: make bitfield a u32 instead of u16

Sara Sharon (1):
  iwlwifi: mvm: remove check for non low latency TIDs

 drivers/net/wireless/intel/iwlwifi/cfg/1000.c |   8 +-
 drivers/net/wireless/intel/iwlwifi/cfg/2000.c |  13 +-
 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  10 +-
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c |   8 +-
 drivers/net/wireless/intel/iwlwifi/cfg/6000.c |  19 ++-
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c |  12 +-
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c |  10 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   3 +
 drivers/net/wireless/intel/iwlwifi/fw/img.h   |   6 +
 .../net/wireless/intel/iwlwifi/fw/paging.c    |  78 ++++++----
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  87 ++++++++++-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h  |  28 +---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  14 ++
 .../wireless/intel/iwlwifi/iwl-eeprom-read.c  |   8 +-
 .../wireless/intel/iwlwifi/iwl-modparams.h    |   2 +
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |  14 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |  20 +--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |   1 -
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |   8 +-
 .../wireless/intel/iwlwifi/pcie/internal.h    |   5 +
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  |   3 +-
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |  15 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 139 ++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  24 ++-
 28 files changed, 400 insertions(+), 164 deletions(-)

-- 
2.17.0
