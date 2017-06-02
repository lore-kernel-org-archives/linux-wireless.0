Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60690 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751125AbdFBL0F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 07:26:05 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 14:25:28 +0300
Message-Id: <20170602112553.2466-1-luca@coelho.fi> (sfid-20170602_132609_470506_CE17DAAD)
Subject: [PATCH 00/25] iwlwifi: updates intended for v4.13 2017-06-02
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's my first set of patches for v4.13.  These are the changes:

* A bunch of FW API documentation updates;
* Continued work for the new A000 family;
* Some small fixes and cleanups here and there.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Haim Dreyfuss (1):
  iwlwifi: Add fw_name_pre_rf_next_step to support different rf steps

Johannes Berg (16):
  iwlwifi: mvm: fix endianness in lq_cmd declaration
  iwlwifi: mvm: document which group enums are used with which group ID
  iwlwifi: mvm: use proper sta_addr in firmware API
  iwlwifi: mvm: fix MCC endianness bug
  iwlwifi: mvm: use u8 for reserved fields
  iwlwifi: mvm: disentangle paging command structs
  iwlwifi: mvm: add documentation to some WoWLAN commands
  iwlwifi: mvm: fix some kernel-doc
  iwlwifi: mvm: add documentation links to various fields
  iwlwifi: mvm: disentangle binding command versions
  iwlwifi: mvm: create/name various enums
  iwlwifi: mvm: document structures used by commands
  iwlwifi: mvm: remove unused TX_CMD_NEXT_FRAME_*
  iwlwifi: kernel-doc: make proper links
  iwlwifi: mvm: remove unused REPLY_MAX
  iwlwifi: mvm: fix many kernel-doc warnings

Liad Kaufman (2):
  iwlwifi: mvm: remove wrt support of page dumps in gen2
  iwlwifi: pcie: support page dumping in wrt in gen2

Sara Sharon (6):
  iwlwifi: mvm: flush per station for DQA mode
  iwlwifi: mvm: support getting nvm data from firmware
  iwlwifi: mvm: support old method of NVM parsing
  iwlwifi: mvm: wait for the flushed queue only
  iwlwifi: update device ID for a000 family
  iwlwifi: add wait for tx queue empty

 drivers/net/wireless/intel/iwlwifi/iwl-9000.c      |   6 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   3 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   4 +
 .../net/wireless/intel/iwlwifi/iwl-fw-error-dump.h |   8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h   |  14 +-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |   1 +
 .../net/wireless/intel/iwlwifi/mvm/fw-api-coex.h   |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h |  29 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-mac.h    |  10 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-power.h  |  45 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h |   7 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-scan.h   |  32 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-sta.h    |  46 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-stats.h  |  29 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-tof.h    |  16 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h |  67 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    | 536 +++++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c    |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  54 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  28 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   4 +
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |  94 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  48 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   2 +
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  19 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  12 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 101 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |   9 +-
 36 files changed, 989 insertions(+), 294 deletions(-)

-- 
2.11.0
