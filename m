Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48526 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751934AbdLBQ3E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 11:29:04 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  2 Dec 2017 18:28:43 +0200
Message-Id: <20171202162858.4167-1-luca@coelho.fi> (sfid-20171202_172949_801692_2AF88DF0)
Subject: [PATCH 00/15] iwlwifi: updates intended for v4.16 2017-12-02
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the second batch of patches intended for 4.16.  Nothing major,
just continued development, some cleanups and small fixes here and
there.

* Initial work for rate-scaling offload;
* Support for new FW API version;
* Some couple of fixes here and there;
* Some old patches that had never made it to the mainline;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Avraham Stern (1):
  iwlwifi: mvm: add WFA vendor specific TPC report IE to probe request

David Spinadel (1):
  iwlwifi: mvm: enable RX offloading with TKIP and WEP

Emmanuel Grumbach (1):
  iwlwifi: mvm: remove set but unused variable in iwl_mvm_roc_done_wk

Gregory Greenman (7):
  iwlwifi: mvm: rs: introduce new API for rate scaling
  iwlwifi: mvm: rs: add ops for the new rate scaling in the FW
  iwlwifi: mvm: rs: add basic implementation of the new RS API handlers
  iwlwifi: mvm: rs: new rate scale API - add FW notifications
  iwlwifi: mvm: rs: new rate scale API - add debugfs hooks
  iwlwifi: mvm: rs: add size checks when printing to a buffer
  iwlwifi: mvm: rs: add sanity check when sending LQ command

Johannes Berg (1):
  iwlwifi: mvm: request statistics when reading debugfs

Liad Kaufman (1):
  iwlwifi: mvm: make init_dbg effective only on failure

Luca Coelho (1):
  iwlwifi: bump FW API to 36 for 8000 and up

Sara Sharon (2):
  iwlwifi: mvm: avoid dumping assert log when device is stopped
  iwlwifi: mvm: mark MIC stripped MPDUs

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |   2 +-
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |  15 ++
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     | 262 +++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile    |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  79 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     | 296 +++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        | 230 ++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |  48 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  16 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  35 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  19 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   7 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  14 +-
 24 files changed, 948 insertions(+), 148 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c

-- 
2.15.0
