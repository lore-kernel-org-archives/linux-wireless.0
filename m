Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47354 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751277AbdKYPfa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Nov 2017 10:35:30 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 25 Nov 2017 17:35:04 +0200
Message-Id: <20171125153510.25359-1-luca@coelho.fi> (sfid-20171125_163545_329638_1C4D6308)
Subject: [PATCH 0/6] iwlwifi: fixes intended for 4.15 2017-11-25
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is the second batch of fixes intended for 4.15.

These are the fixes:

* One fix in rate-scaling;
* One fix for the TX queue hang detection for AP/GO modes;
* Fix the TX queue hang timeout used in monitor interfaces;
* Fix packet injection;
* Remove a wrong error message when dumping PCI registers;
* Fix race condition with RF-kill;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.

Emmanuel Grumbach (3):
  iwlwifi: mvm: don't use transmit queue hang detection when it is not
    possible
  iwlwifi: mvm: fix the TX queue hang timeout for MONITOR vif type
  iwlwifi: mvm: fix packet injection

Sara Sharon (2):
  iwlwifi: pcie: fix erroneous "Read failed message"
  iwlwifi: fix access to prph when transport is stopped

Shaul Triebitz (1):
  iwlwifi: mvm: set correct chains in Rx status

 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h    |  4 ++
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |  2 -
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 53 ++++++++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     | 13 +++++-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |  6 +++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 10 ++++
 11 files changed, 80 insertions(+), 19 deletions(-)

-- 
2.15.0
