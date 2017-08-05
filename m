Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42406 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752581AbdHESrw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 14:47:52 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 21:47:40 +0300
Message-Id: <20170805184743.23650-1-luca@coelho.fi> (sfid-20170805_205039_834191_6EA92B75)
Subject: [PATCH 0/3] iwlwifi: fixes intended for 4.13 2017-08-05
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is the third set of fixes for 4.13.

The issues solved here are:

* Fix a memory leak in the SAR code;
* Fix a stuck queue case in AP mode;
* Convert a WARN to a simple debug in a legitimate race case (from
  which we can recover);

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Avraham Stern (1):
  iwlwifi: mvm: start mac queues when deferred tx frames are purged

Christophe Jaillet (1):
  iwlwifi: mvm: Fix a memory leak in an error handling path in
    'iwl_mvm_sar_get_wgds_table()'

Emmanuel Grumbach (1):
  iwlwifi: mvm: don't WARN when a legit race happens in A-MPDU

 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       |  6 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 12 +++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     | 10 ++++++----
 3 files changed, 21 insertions(+), 7 deletions(-)

-- 
2.13.2
