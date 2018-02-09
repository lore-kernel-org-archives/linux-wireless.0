Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:58214 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750942AbeBINMm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Feb 2018 08:12:42 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  9 Feb 2018 15:12:29 +0200
Message-Id: <20180209131234.8504-1-luca@coelho.fi> (sfid-20180209_141255_442908_E61D7EB2)
Subject: [PATCH 0/5] iwlwifi: fixes intended for 4.16 2018-02-09
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is my first batch of fixes inteded for 4.16.

These are the fixes:

* A couple of bugzilla fixes
  - Fix a bogus warning when freeing a TFD;
  - Fix severe throughput problem with 9000 series;
* Fix for a bug that caused queue hangs in certain situations;
* Fix for an issue with IBSS;
* Fix an issue with rate-scalingin AP-mode.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Emmanuel Grumbach (1):
  iwlwifi: pcie: don't warn if we use all the transmit pointers

Naftali Goldstein (1):
  iwlwifi: mvm: always init rs with 20mhz bandwidth rates

Sara Sharon (2):
  iwlwifi: mvm: fix security bug in PN checking
  iwlwifi: mvm: fix IBSS for devices that support station type API

Shaul Triebitz (1):
  iwlwifi: align timestamp cancel with timestamp start

 drivers/net/wireless/intel/iwlwifi/fw/init.c      |  6 ----
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  4 +++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  2 --
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c       | 28 +++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     | 39 ++++++++++++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 24 +++++++-------
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c      |  2 +-
 10 files changed, 61 insertions(+), 50 deletions(-)

-- 
2.15.1
