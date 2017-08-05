Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42452 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751392AbdHETnh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 15:43:37 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 22:43:12 +0300
Message-Id: <20170805194331.17426-1-luca@coelho.fi> (sfid-20170805_214344_232801_2F1F1A31)
Subject: [PATCH 00/19] iwlwifi: updates intended for v4.14 2017-08-05
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's another set of patches for v4.14.  These are the changes:

* Some more code moved to a new directory;
* Fixes in LED handling;
* Some FW API updates;
* General fixes and cleanups here and there.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Bhumika Goyal (1):
  iwlwifi: mvm: add const to thermal_cooling_device_ops structure

Chaya Rachel Ivgi (2):
  iwlwifi: mvm: add debugfs to force CT-kill
  iwlwifi: mvm: set the default cTDP budget

Emmanuel Grumbach (3):
  iwlwifi: pcie: don't init a Tx queue with an SSN > size of the queue
  iwlwifi: pcie: free the TSO page when a Tx queue is unmapped on A000
    devices
  iwlwifi: mvm: fix the coex firmware API

Golan Ben-Ami (2):
  iwlwifi: dump smem configuration when firmware crashes
  iwlwifi: fix nmi triggering from host

Haim Dreyfuss (1):
  iwlwifi: mvm: support new beacon template command

Johannes Berg (2):
  iwlwifi: mvm: remove useless condition in LED code
  iwlwifi: mvm: use firmware LED command where applicable

Liad Kaufman (1):
  iwlwifi: fix a000 RF_ID define

Luca Coelho (2):
  iwlwifi: fix a few instances of misaligned kerneldoc parameters
  iwlwifi: remove references to unsupported HW

Matt Chen (1):
  iwlwifi: mvm: don't send CTDP commands via debugfs if not supported

Sharon Dvir (1):
  iwlwifi: change functions that can only return 0 to void

Shaul Triebitz (2):
  iwlwifi: mvm: move a000 device NVM retrieval to a common place
  iwlwifi: mvm: add station before allocating a queue

Tzipi Peres (1):
  iwlwifi: add support of FPGA fw

 drivers/net/wireless/intel/iwlwifi/Makefile        |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c      |  14 ++
 drivers/net/wireless/intel/iwlwifi/dvm/commands.h  |   8 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/coex.h   |  14 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |   5 +
 drivers/net/wireless/intel/iwlwifi/fw/api/led.h    |  71 +++++++++
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |  19 ++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  38 ++++-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |  30 ++++
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/nvm.c        | 162 +++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |   2 +
 drivers/net/wireless/intel/iwlwifi/fw/smem.c       |   3 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  24 +--
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |  14 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |  13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  24 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/led.c       |  59 ++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  47 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |  91 ------------
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 108 ++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   2 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  20 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  16 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   4 +-
 33 files changed, 588 insertions(+), 242 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/led.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/nvm.c

-- 
2.13.2
