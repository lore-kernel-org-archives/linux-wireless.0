Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59242 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751023AbeBQIeC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Feb 2018 03:34:02 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 17 Feb 2018 10:33:45 +0200
Message-Id: <20180217083354.31160-1-luca@coelho.fi> (sfid-20180217_093417_978019_3873EF1F)
Subject: [PATCH 0/9] iwlwifi: fixes intended for 4.16 2018-02-17
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is my second batch of fixes inteded for 4.16.

These are the fixes:

* Fix CSA issues with count 0 and 1;
* Some firmware debugging fixes;
* Removed a wrong error message when removing keys;
* Fix a firmware sysassert most usually triggered in IBSS;
* A couple of fixes on multicast queues;
* A fix with CCMP 256;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.

Andrei Otcheretianski (1):
  iwlwifi: mvm: Fix channel switch for count 0 and 1

Haim Dreyfuss (1):
  iwlwifi: Cancel and set MARKER_CMD timer during suspend-resume

Ilan Peer (2):
  iwlwifi: mvm: Direct multicast frames to the correct station
  iwlwifi: mvm: Correctly set the tid for mcast queue

Sara Sharon (3):
  iwlwifi: mvm: fix TX of CCMP 256
  iwlwifi: mvm: fix assert 0x2B00 on older FWs
  iwlwifi: mvm: fix "failed to remove key" message

Shaul Triebitz (1):
  iwlwifi: avoid collecting firmware dump if not loaded

Ulf Magnusson (1):
  iwlwifi: fix malformed CONFIG_IWLWIFI_PCIE_RTPM default

 drivers/net/wireless/intel/iwlwifi/Kconfig         |  1 -
 .../net/wireless/intel/iwlwifi/fw/api/time-event.h |  4 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 13 ++++++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |  3 ++
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h    | 18 +++++++++
 drivers/net/wireless/intel/iwlwifi/fw/init.c       | 12 ++++++
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |  7 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  8 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  5 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 45 +++++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  8 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  9 +++--
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |  6 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 13 +++++--
 14 files changed, 125 insertions(+), 27 deletions(-)

-- 
2.15.1
