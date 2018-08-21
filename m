Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42816 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726790AbeHUJzx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 05:55:53 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 09:36:42 +0300
Message-Id: <20180821063657.30071-1-luca@coelho.fi> (sfid-20180821_083730_946756_091B1408)
Subject: [PATCH 00/15] iwlwifi: updates intended for v4.20 2018-08-21
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the second set of patches intended for v4.20.  It's the usual
developments, with some small new feauters, cleanups and bugfixes.

The changes are:

* Some improvements in the PCI recovery mechanism;
* Support for a few FW API changes;
* Miscellaneous bugfixes;
* Other clean-ups and small improvements;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

I have a lot of pending patches in our internal tree, so I'll probably
send another patchset before sending the pull-request.

Please review.

Cheers,
Luca.


Avraham Stern (1):
  iwlwifi: mvm: Send LQ command as async when necessary

Ayala Beker (1):
  iwlwifi: mvm: skip EBS in low latency mode while fragmented scan isn't
    supported

Emmanuel Grumbach (1):
  iwlwifi: improve the flow when a NIC is disconnected

Erel Geron (1):
  iwlwifi: mvm: support Coex Schema 2

Golan Ben Ami (3):
  iwlwifi: remove FSF's address from the license notice
  iwlwifi: pcie: store the default rxq number
  iwlwifi: pcie: make gen2 of apm_init non-static

Haim Dreyfuss (1):
  iwlwifi: mvm: support new reduce tx power FW API.

Johannes Berg (2):
  iwlwifi: remove dump_regs() from transport ops
  iwlwifi: don't WARN on trying to dump dead firmware

Matt Chen (1):
  iwlwifi: pcie: avoid unnecessary work if NIC is disconnected

Mordechay Goodstein (1):
  iwlwifi: add 80211 hdr offset to trace data

Sara Sharon (3):
  iwlwifi: mvm: fix BAR seq ctrl reporting
  iwlwifi: mvm: avoid sending too many BARs
  iwlwifi: pcie: set interrupt coalescing also for gen2

 .../net/wireless/intel/iwlwifi/fw/api/coex.h  |  3 ++
 .../wireless/intel/iwlwifi/fw/api/commands.h  |  3 +-
 .../net/wireless/intel/iwlwifi/fw/api/power.h | 30 ++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |  7 ++---
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  7 +++++
 .../intel/iwlwifi/iwl-devtrace-data.h         | 10 ++----
 .../intel/iwlwifi/iwl-devtrace-iwlwifi.h      | 14 +++++----
 .../net/wireless/intel/iwlwifi/iwl-devtrace.h | 22 +++++++------
 .../net/wireless/intel/iwlwifi/iwl-op-mode.h  |  6 ++--
 .../net/wireless/intel/iwlwifi/iwl-trans.h    | 11 -------
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c |  9 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   | 23 +++++++++-----
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 31 +++++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  7 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  6 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c   | 18 +++++------
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h   |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 11 ++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   | 17 +++++++---
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |  7 ++---
 .../wireless/intel/iwlwifi/pcie/internal.h    |  6 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  |  5 ++-
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |  2 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 13 +++++---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  | 10 +++++-
 25 files changed, 186 insertions(+), 94 deletions(-)

-- 
2.18.0
