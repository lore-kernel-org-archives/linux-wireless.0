Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52072 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750965AbeF3NXi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Jun 2018 09:23:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 30 Jun 2018 16:23:15 +0300
Message-Id: <20180630132330.14928-1-luca@coelho.fi> (sfid-20180630_152342_637004_F2E168E3)
Subject: [PATCH 00/15] wlwifi: updates intended for v4.19 2018-06-30
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's another set of patches intended for v4.19.  These are based on
the previous patchset I sent.  This series is mostly adding changes
necessary for a new device family, namely 22560.  There are some
changes in other places, but they are there to support the new device
features.

The changes are:

* Changes in the base code to support the new 22560 devices;
* Support for the new 22560 device family;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Golan Ben Ami (13):
  iwlwifi: allow different csr flags for different device families
  iwlwifi: introduce device family 22560
  iwlwifi: pcie: allocate and free rx cr's and tr's tails
  iwlwifi: pcie: support context information for 22560 devices
  iwlwifi: pcie: update bytes in the byte count table
  iwlwifi: pcie: start early debug for 22560 devices
  iwlwifi: update gen3 interrupts - sw error and image response
  iwlwifi: cancel the injective function between hw pointers to tfd
    entry index
  iwlwifi: support multiple tfd queue max sizes for different devices
  iwlwifi: support new tx api
  iwlwifi: introduce new rx structures used by 22560 RFH
  iwlwifi: update registers changed for 22560 devices
  iwlwifi: pcie: support 2k rx buffers

Johannes Berg (1):
  iwlwifi: 22000 devices: restrict to HT A-MPDU size

Luca Coelho (1):
  iwlwifi: add support for 22560 devices

 drivers/net/wireless/intel/iwlwifi/Makefile   |   3 +-
 drivers/net/wireless/intel/iwlwifi/cfg/2000.c |   2 +
 .../net/wireless/intel/iwlwifi/cfg/22000.c    | 161 ++++++----
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c |   1 +
 drivers/net/wireless/intel/iwlwifi/cfg/6000.c |   3 +
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c |   1 +
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c |   1 +
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |   1 +
 .../wireless/intel/iwlwifi/fw/api/commands.h  |   3 +-
 .../net/wireless/intel/iwlwifi/fw/api/tx.h    |  25 ++
 drivers/net/wireless/intel/iwlwifi/fw/smem.c  |   4 +-
 .../net/wireless/intel/iwlwifi/iwl-config.h   |   7 +-
 .../intel/iwlwifi/iwl-context-info-gen3.h     | 286 ++++++++++++++++++
 .../wireless/intel/iwlwifi/iwl-context-info.h |   5 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h  |   5 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |   3 +-
 .../wireless/intel/iwlwifi/iwl-eeprom-parse.c |   8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h   |  28 +-
 .../wireless/intel/iwlwifi/iwl-modparams.h    |   8 +-
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |   7 +
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |   4 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  48 ++-
 .../intel/iwlwifi/pcie/ctxt-info-gen3.c       | 207 +++++++++++++
 .../wireless/intel/iwlwifi/pcie/ctxt-info.c   |  62 +---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |   2 -
 .../wireless/intel/iwlwifi/pcie/internal.h    | 220 +++++++++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  | 232 ++++++++------
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |  11 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  61 +++-
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  58 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  92 +++---
 34 files changed, 1255 insertions(+), 316 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-context-info-gen3.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c

-- 
2.18.0
