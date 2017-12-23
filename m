Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51802 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751482AbdLWJWH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Dec 2017 04:22:07 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 23 Dec 2017 11:21:55 +0200
Message-Id: <20171223092200.30270-1-luca@coelho.fi> (sfid-20171223_102215_055866_30EBB210)
Subject: [PATCH 0/5] iwlwifi: updates intended for v4.16 2017-12-23
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the fourth and probably last batch of patches intended for
4.16.  Nothing major, just continued development, some cleanups and
small fixes here and there.

* Fix a UBSAN warning;
* Improvement in the net-stack/driver log syncing
* An RCU lock fix in the new rate-scaling code;
* Small cleanups;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

FYI, I'll be on holidays/vacations for the next few weeks, so there
will probably not be much activity in the iwlwifi driver code.

Please review.

Cheers,
Luca.


Luca Coelho (1):
  iwlwifi: mvm: check if mac80211_queue is valid in iwl_mvm_disable_txq

Mordechay Goodstein (1):
  iwlwifi: set default timstamp marker cmd

Sara Sharon (3):
  iwlwifi: mvm: flip AMSDU addresses only for 9000 family
  iwlwifi: mvm: take RCU lock before dereferencing
  iwlwifi: mvm: move TSO segment to a separate function

 drivers/net/wireless/intel/iwlwifi/fw/dbg.c     |   4 +
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c |  24 ++--
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c  |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c   |  25 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c     | 158 +++++++++++++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c  |  11 +-
 7 files changed, 136 insertions(+), 97 deletions(-)

-- 
2.15.1
