Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42578 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726346AbeHUI2g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 04:28:36 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 08:09:35 +0300
Message-Id: <20180821050952.31603-1-luca@coelho.fi> (sfid-20180821_071006_389614_21791CA6)
Subject: [PATCH v2 00/17] iwlwifi: updates intended for v4.20 2018-08-18
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Here's a second version of the first set of patches intended for
v4.20.  I fixed a linkage error when CONFIG_PM is not enabled, as
reported by kbuildbot.  For this, I added a new, separate patch
"iwlwifi: mvm: protect D0i3 code behind CONFIG_PM" that adds checks
for the CONFIG_PM flags in a few places that were missing.

The rest is the same:

It's the usual developments, with some small new feauters,
cleanups and bugfixes.

The changes are:

* One fix for channel-switch handling;
* Some improvements in the HE code;
* New FW API handling;
* Improvements in the debugging code;
* Other clean-ups and small fixes;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

I have a lot of pending patches in our internal tree, so I'll probably
send another patchset before sending the pull-request.

Please review.

Cheers,
Luca.


Avraham Stern (1):
  iwlwifi: set the tid for non-QOS frames to zero

Golan Ben Ami (3):
  iwlwifi: add required include to iwl-fh.h
  iwlwifi: pcie: allow using tx init for other queues but the command
    queue
  iwlwifi: pcie: make non-static hcmd and rx code

Gregory Greenman (1):
  iwlwifi: mvm: add NOA and CSA to a probe response

Liad Kaufman (2):
  iwlwifi: mvm: add bss color to radiotap
  iwlwifi: mvm: add support for RX_AMPDU_EOF bit for HE SU

Luca Coelho (4):
  iwlwifi: remove unused TLC debugging commands
  iwlwifi: mvm: remove duplicate if in iwl_mvm_setup_connection_keep()
  iwlwifi: mvm: protect D0i3 code behind CONFIG_PM
  iwlwifi: mvm: support new WoWLAN status FW API

Mordechay Goodstein (2):
  iwlwifi: turn timestamp marker cmd off by default
  iwlwifi: enable reading the value of delay in timestamp_marker cmd

Naftali Goldstein (1):
  iwlwifi: runtime: avoid calling debugfs read functions more than once

Sara Sharon (2):
  iwlwifi: mvm: move he RX handling to a separate function
  iwlwifi: drop packets with bad status in CD

Shahar S Matityahu (1):
  iwlwifi: add d3 debug data support

 .../net/wireless/intel/iwlwifi/cfg/22000.c    |   4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |   4 +-
 .../net/wireless/intel/iwlwifi/fw/api/d3.h    |  89 ++-
 .../wireless/intel/iwlwifi/fw/api/mac-cfg.h   |  49 ++
 .../net/wireless/intel/iwlwifi/fw/api/rs.h    |  60 --
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    |  63 ++
 .../net/wireless/intel/iwlwifi/fw/api/tx.h    |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |  51 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  10 +
 .../net/wireless/intel/iwlwifi/fw/debugfs.c   | 121 +++-
 .../wireless/intel/iwlwifi/fw/error-dump.h    |   8 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   3 +
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |   1 +
 .../net/wireless/intel/iwlwifi/iwl-config.h   |   4 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h  |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h   |   2 +
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   | 160 +++--
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  61 ++
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |   9 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  19 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  38 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 569 +++++++++---------
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  91 ++-
 .../wireless/intel/iwlwifi/pcie/internal.h    |  71 +--
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  |  12 +-
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |   2 +-
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  33 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |   2 +-
 30 files changed, 1016 insertions(+), 528 deletions(-)

-- 
2.18.0
