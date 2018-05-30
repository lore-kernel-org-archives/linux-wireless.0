Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46896 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752800AbeE3HUM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 03:20:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 30 May 2018 10:19:55 +0300
Message-Id: <20180530072005.633-1-luca@coelho.fi> (sfid-20180530_092018_591051_783A73BF)
Subject: [PATCH 00/10] iwlwifi: updates intended for v4.18 2018-05-30
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the last batch of patches intended for 4.18.  Focused on
bugfixes, especially (but not exclusively) regressions introduced in
4.18.  The patches include these changes:

* Some bugzilla fixes;
* Some kernel warning fixes;
* Fix for an (ETSI) WMM limits bug;
* Fix for a Bluetooth coexistence problem on 9000 devices;
* Fix for an interoperability bug related to block-ack sessions; 

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Aviya Erenfeld (1):
  iwlmvm: tdls: Check TDLS channel switch support

Colin Ian King (1):
  iwlwifi: mvm: remove division by size of sizeof(struct
    ieee80211_wmm_rule)

Emmanuel Grumbach (2):
  iwlwifi: mvm: fix TSO with highly fragmented SKBs
  iwlwifi: mvm: honor the max_amsdu_subframes limit

Erel Geron (1):
  iwlwifi: fix non_shared_ant for 9000 devices

Golan Ben Ami (1):
  iwlwifi: add csr configuration for 6300 devices

Gregory Greenman (1):
  iwlwifi: mvm: open BA session only when sta is authorized

Johannes Berg (1):
  iwlwifi: mvm: fix race in queue notification wait

Sara Sharon (1):
  iwlwifi: mvm: drop UNKNOWN security type frames

Shaul Triebitz (1):
  iwlwifi: pcie: fix race in Rx buffer allocator

 drivers/net/wireless/intel/iwlwifi/cfg/6000.c |  1 +
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |  2 +-
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    |  1 +
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |  3 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  8 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c   | 38 +++++++++----------
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h   |  7 +---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 36 ++++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h  | 10 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c | 16 +++++---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   | 16 +++++---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  3 ++
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  |  2 +
 14 files changed, 83 insertions(+), 62 deletions(-)

-- 
2.17.0
