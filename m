Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35882 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750715AbdI2MDP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 08:03:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 29 Sep 2017 15:03:00 +0300
Message-Id: <20170929120305.20551-1-luca@coelho.fi> (sfid-20170929_140319_204411_23DD99C5)
Subject: [PATCH 0/5] iwlwifi: fixes intended for 4.14 2017-09-29
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Another batch of fixes intended for 4.14.  This one is a bit smaller
than the previous one.

These are the fixes:

* Fix support for 3168 device series;
* Fix a potential crash when using FW debugging recording;
* Improve channel flags parsing to avoid warnings on too long traces;
* Return -ENODATA when the temperature is not available, since the
  -EIO we were returning was causing fatal errors in userspace;
* Avoid printing too many messages in dmesg when using monitor mode,
  since this can become very noisy and completely flood the logs;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Chaya Rachel Ivgi (1):
  iwlwifi: nvm: set the correct offsets to 3168 series

Golan Ben Ami (1):
  iwlwifi: stop dbgc recording before stopping DMA

Johannes Berg (1):
  iwlwifi: nvm-parse: unify channel flags printing

Luca Coelho (1):
  iwlwifi: mvm: return -ENODATA when reading the temperature with the FW
    down

Shaul Triebitz (1):
  iwlwifi: mvm: do not print security error in monitor mode

 drivers/net/wireless/intel/iwlwifi/cfg/7000.c      |   1 +
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c      |   2 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |   2 +
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   7 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |  15 +++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  16 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 137 ++++++++++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   7 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |  21 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |   2 +-
 15 files changed, 132 insertions(+), 95 deletions(-)

-- 
2.14.1
