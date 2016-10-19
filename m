Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50186 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S942575AbcJSPSN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:18:13 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Oct 2016 13:07:45 +0300
Message-Id: <20161019100755.23874-1-luca@coelho.fi> (sfid-20161019_171818_168271_030E4178)
Subject: [PATCH 00/10] iwlwifi: updates intended for v4.10 2016-10-19
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's my first series for v4.10.  These are the changes:

* Finalize and enable dynamic queue allocation;
* Use dev_coredumpmsg() to prevent locking the driver;
* Small fix to pass the AID to the FW;
* Use FW PS decisions with multi-queue;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Aviya Erenfeld (1):
  iwlwifi: mvm: use dev_coredumpsg()

Emmanuel Grumbach (1):
  iwlwifi: mvm: tell the firmware about the AID of the peer

Johannes Berg (1):
  iwlwifi: mvm: use firmware station PM notification for AP_LINK_PS

Liad Kaufman (5):
  iwlwifi: mvm: update txq metadata to current owner
  iwlwifi: mvm: fix reserved txq freeing
  iwlwifi: mvm: support MONITOR vif in DQA mode
  iwlwifi: mvm: fix dqa deferred frames marking
  iwlwifi: mvm: operate in dqa mode

Sara Sharon (1):
  iwlwifi: mvm: assign cab queue to the correct station

Sharon Dvir (1):
  iwlwifi: pcie: give a meaningful name to interrupt request

 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h   |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h |  26 ++++++
 .../net/wireless/intel/iwlwifi/mvm/fw-api-sta.h    |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c    | 100 +++++++++++----------
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  24 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  86 +++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  37 ++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  29 +++++-
 12 files changed, 249 insertions(+), 75 deletions(-)

-- 
2.9.3
