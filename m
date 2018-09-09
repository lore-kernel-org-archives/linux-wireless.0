Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47924 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726609AbeIIO0J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 10:26:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun,  9 Sep 2018 12:36:40 +0300
Message-Id: <20180909093656.10194-1-luca@coelho.fi> (sfid-20180909_113707_645782_9E7DE697)
Subject: [PATCH 00/16] iwlwifi: updates intended for v4.20 2018-09-09
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the fifth set of patches intended for v4.20.  It's the usual
development, with some small new features, cleanups and bugfixes.

The changes are:

* Fix one FW feature TLV that had a conflict with another value;
* A couple of fixes for SoftAP mode;
* Work continues for new 22560 hardware;
* Some fixes in the datapath;
* Some cleanups, small improvements and other general fixes;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Avraham Stern (1):
  iwlwifi: mvm: set wep key for all stations in soft ap mode

Emmanuel Grumbach (1):
  iwlwifi: mvm: remove support for adjacent channel compensation

Erel Geron (1):
  iwlwifi: mvm: TLC support for Coex Schema 2

Golan Ben Ami (2):
  iwlwifi: pcie: fit reclaim msg to MAX_MSG_LEN
  iwlwifi: configure power scheme to balanced for 22560 devices

Ilan Peer (1):
  iwlwifi: mvm: Allow TKIP for AP mode

Johannes Berg (5):
  iwlwifi: pcie: gen2: build A-MSDU only for GSO
  iwlwifi: pcie: tx: unify TFD unmapping
  iwlwifi: pcie: tx: pull tracing out of iwl_fill_data_tbs()
  iwlwifi: pcie: support transmitting SKBs with fraglist
  iwlwifi: fix LED command capability bit

Rajat Jain (1):
  iwlwifi: pcie: Fail fast if HW is inaccessible at probe

Sara Sharon (2):
  iwlwifi: mvm: use correct FIFO length
  iwlwifi: pcie: add infrastructure for multiple debug buffers

Shaul Triebitz (2):
  iwlwifi: mvm: do not override amsdu size user settings
  iwlwifi: pcie: set RB size according to user settings

 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   2 +-
 .../wireless/intel/iwlwifi/iwl-context-info.h |  25 +++-
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  17 +++
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c |   9 ++
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |   4 +
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  31 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  20 +--
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c   |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  |  25 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  47 ++++---
 .../intel/iwlwifi/pcie/ctxt-info-gen3.c       |   4 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info.c   |  28 +++-
 .../wireless/intel/iwlwifi/pcie/internal.h    |  19 ---
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 122 ++++++++++--------
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |   7 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  77 ++++++-----
 17 files changed, 276 insertions(+), 168 deletions(-)

-- 
2.18.0
