Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59232 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751253AbdFEUmd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:42:33 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Jun 2017 23:41:53 +0300
Message-Id: <20170605204218.30151-1-luca@coelho.fi> (sfid-20170605_224324_816444_864C1984)
Subject: [PATCH 00/25] iwlwifi: updates intended for v4.13 2017-06-05
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

More patches intended for v4.13.  These are the changes:

* More FW API documentation updates;
* More work for the new A000 family;
* Bumped the maximum supported FW API to 31.
* Improve the differentiation between 8000, 9000 and A000 families;
* A bunch of small fixes and cleanups here and there;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a comnined pull-request with the previous bunch later.

Please review.

Cheers,
Luca.


Beni Lev (1):
  iwlwifi: mvm: add TLV for NAN API differentiation

Johannes Berg (12):
  iwlwifi: mvm: document RX structures
  iwlwifi: mvm: check firmware is up in debugfs
  iwlwifi: mvm: use schedule_delayed_work()
  iwlwifi: mvm: add and use iwl_mvm_device_running()
  iwlwifi: mvm: convert ucode_loaded to a status bit
  iwlwifi: mvm: clear firmware running bit earlier
  iwlwifi: fix a kernel-doc tag
  iwlwifi: split firmware API from iwl-trans.h
  iwlwifi: mvm: link queue cmd docs to A000 command structs
  iwlwifi: mvm: document structures used for BEACON_TEMPLATE_CMD
  iwlwifi: mvm: link to TX commands in documentation
  iwlwifi: mvm: remove SCAN_GROUP

Liad Kaufman (3):
  iwlwifi: mvm: support init flow debugging
  iwlwifi: pcie: support dumping FH in a000 hw
  iwlwifi: mvm: disable prph collection in a000 hw

Luca Coelho (2):
  iwlwifi: bump max FW API to 31
  iwlwifi: remove unnecessary code in iwl_trans_alloc_tx_cmd

Mordechai Goodstein (1):
  iwlwifi: fw-api: cleanup cycle includes

Sara Sharon (6):
  iwlwifi: mvm: add AMSDU flag to offload assist
  iwlwifi: pcie: add AMSDU to gen2
  iwlwifi: cleanup references to 8000 family in NVM code
  iwlwifi: remove references to 8000 B-step devices
  iwlwifi: add dbgc_supported to transport configuration
  iwlwifi: add 9000 and A000 device families

 drivers/net/wireless/intel/iwlwifi/iwl-8000.c      |  10 +-
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c      |   8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c      |   8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h       |  12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-fw-api.h    | 205 +++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h   |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  95 +++++-----
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     | 147 +--------------
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  82 +++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h |  81 +++++++-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-scan.h   |   2 -
 .../net/wireless/intel/iwlwifi/mvm/fw-api-tof.h    |   2 -
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |  23 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c    |  46 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/led.c       |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  14 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  21 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |  39 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  31 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tof.c       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |  18 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   3 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  34 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 172 ++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   5 +-
 34 files changed, 766 insertions(+), 353 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-fw-api.h

-- 
2.11.0
