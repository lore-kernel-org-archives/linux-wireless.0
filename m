Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47426 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751277AbdKYQeu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Nov 2017 11:34:50 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 25 Nov 2017 18:34:33 +0200
Message-Id: <20171125163444.24258-1-luca@coelho.fi> (sfid-20171125_173456_206266_DCE31622)
Subject: [PATCH 00/11]  iwlwifi: updates intended for v4.16 2017-11-25
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the first batch of patches intended for 4.16.  Nothing major,
just continued development, some cleanups and small fixes here and
there.

* Rename the temporary name A000 to 22000;
* Change in the way we print the firmware version;
* Remove some unused code;
* Other small improvements;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Adiel Aloni (1):
  iwlwifi: mvm: Add debugfs support for FTM initiator fields

Emmanuel Grumbach (4):
  iwlwifi: mvm: rs: don't override the rate history in the search cycle
  iwlwifi: mvm: revert support new Coex firmware API
  iwlwifi: print the version number of the firmware in hex
  iwlwifi: fix the ALIVE notification layout

Johannes Berg (2):
  iwlwifi: mvm: remove TCP wakeup support
  iwlwifi: mvm: remove superfluous flush_work()

Liad Kaufman (2):
  iwlwifi: mvm: support MGMT frames in compressed BA
  iwlwifi: dbg: allow wrt collection before ALIVE

Luca Coelho (1):
  iwlwifi: rename the temporary name of A000 to the official 22000

Sara Sharon (1):
  iwlwifi: mvm: check for short GI only for OFDM

 drivers/net/wireless/intel/iwlwifi/Makefile        |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     | 216 +++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c      | 216 -------------------
 drivers/net/wireless/intel/iwlwifi/fw/api/alive.h  |   4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/coex.h   |  30 ---
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |   4 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  15 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   3 -
 drivers/net/wireless/intel/iwlwifi/fw/smem.c       |   8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  20 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  11 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |  12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |  33 +--
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        | 232 +--------------------
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |  22 ++
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  30 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  10 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   6 -
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  12 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  36 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   4 +-
 29 files changed, 345 insertions(+), 622 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/cfg/22000.c
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/cfg/a000.c

-- 
2.15.0
