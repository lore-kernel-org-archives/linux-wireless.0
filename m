Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44430 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751007AbdHRPtb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 11:49:31 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 Aug 2017 18:48:58 +0300
Message-Id: <20170818154922.2904-1-luca@coelho.fi> (sfid-20170818_174938_364688_506B04F4)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 00/24] iwlwifi: updates intended for v4.14 2017-08-18
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's one more set of patches for v4.14.  These are the changes:

* Work for the upcoming A000 device family continues;
* Improvements in debugging;
* A couple of improvements in block-ack sessions;
* Some fixes for channel switch;
* A workaround for a HW data bug;
* Some FW API updates;
* General fixes and cleanups here and there.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.

Avraham Stern (1):
  iwlwifi: mvm: remove session protection to allow channel switch

Emmanuel Grumbach (7):
  iwlwifi: mvm: remove the corunning support
  iwlwifi: mvm: support new Coex firmware API
  iwlwifi: pcie: support short Tx queues for A000 device family
  iwlwifi: mvm: add command name for FRAME_RELEASE
  iwlwifi: mvm: include more debug data when we get an unexpected baid
  iwlwifi: mvm: update the firmware API in TX
  iwlwifi: mvm: don't send BAR on flushed frames

Gregory Greenman (1):
  iwlwifi: mvm: change open and close criteria of a BA session

Ilan Peer (1):
  iwlwifi: mvm: Fix channel switch in case of count <= 1

João Paulo Rechi Vita (1):
  iwlwifi: Demote messages about fw flags size to info

Luca Coelho (12):
  iwlwifi: mvm: consider RFKILL during INIT as success
  iwlwifi: call iwl_remove_notification from iwl_wait_notification
  iwlwifi: mvm: group all dummy SAR function declarations together
  iwlwifi: mvm: use mvmsta consistently in rs.c
  iwlwifi: move BT_MBOX_PRINT macro to common header
  iwlwifi: pci: add new PCI ID for 7265D
  iwlwifi: update channel flags parser
  iwlwifi: add workaround to disable wide channels in 5GHz
  iwlwifi: fw: fix lar_enabled endian problem in iwl_fw_get_nvm
  iwlwifi: mvm: remove useless argument in iwl_nvm_init()
  iwlwifi: mvm: remove useless check for mvm->cfg in
    iwl_parse_nvm_section()
  iwlwifi: use big-endian for the hw section of the nvm

Tzipi Peres (1):
  iwlwifi: distinguish different RF modules in A000 devices

 drivers/net/wireless/intel/iwlwifi/cfg/a000.c      |  34 ++-
 drivers/net/wireless/intel/iwlwifi/fw/api/coex.h   |  50 +++-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |  12 -
 drivers/net/wireless/intel/iwlwifi/fw/api/config.h |   8 -
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |   9 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   3 +
 drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c |  25 +-
 drivers/net/wireless/intel/iwlwifi/fw/nvm.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 118 +++++---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      | 301 ++-------------------
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  30 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  54 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  16 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  31 +--
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       | 106 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        | 143 +++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   7 +
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |  34 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   9 +-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  24 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  13 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  41 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  13 +-
 33 files changed, 511 insertions(+), 624 deletions(-)

-- 
2.14.1
