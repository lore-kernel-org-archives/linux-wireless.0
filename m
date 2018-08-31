Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45616 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727611AbeHaODI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 10:03:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 12:55:58 +0300
Message-Id: <20180831095614.14099-1-luca@coelho.fi> (sfid-20180831_115633_347969_83DAC94A)
Subject: [PATCH 00/16] iwlwifi: updates intended for v4.20 2018-08-
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the fourth set of patches intended for v4.20.  It's the usual
development, with some small new features, cleanups and bugfixes.

The changes are:

* TKIP implementation in new devices;
* Fix for the shared antenna setting in 22000 series;
* Report that we set the RU offset in HE code;
* Fix some register addresses in 22000 series;
* Some debugging and other general fixes;
* A bunch of cleanups;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

I have a lot of pending patches in our internal tree, so I'll probably
send one or two more patchsets before sending the pull-request.

Please review.

Cheers,
Luca.


David Spinadel (1):
  iwlwifi: mvm: Support TKIP on gen2 data path

Dreyfuss, Haim (1):
  iwlwifi: mvm: cleanup dead code on resume flow for non unified image.

Emmanuel Grumbach (2):
  iwlwifi: mvm: fix a comment about the SP length
  iwlwifi: dbg: don't crash if the firmware crashes in the middle of a
    debug dump

Erel Geron (1):
  iwlwifi: fix non_shared_ant for 22000 devices

Johannes Berg (5):
  iwlwifi: RX API: remove unnecessary anonymous struct
  iwlwifi: mvm: report RU offset is known
  iwlwifi: remove ucode error tracepoint
  iwlwifi: api: annotate compressed BA notif array sizes
  iwlwifi: pcie: gen2: pull adding frags to helper routine

Sara Sharon (3):
  iwlwifi: fw: add a restart FW debug function
  iwlwifi: fw: stop and start debugging using host command
  iwlwifi: pcie: read correct prph address for newer devices

Shahar S Matityahu (1):
  iwlwifi: debug flow cleanup

Shaul Triebitz (2):
  iwlwifi: iwlmvm: fix typo when checking for TX Beamforming
  iwlwifi: mvm: enable sending HE_AIR_SNIFFER command via debugfs

 .../net/wireless/intel/iwlwifi/cfg/22000.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c |   2 +-
 .../wireless/intel/iwlwifi/fw/api/datapath.h  |   5 +
 .../net/wireless/intel/iwlwifi/fw/api/debug.h |  32 +++
 .../net/wireless/intel/iwlwifi/fw/api/mac.h   |  14 +
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    |  28 +-
 .../net/wireless/intel/iwlwifi/fw/api/sta.h   |   4 +-
 .../net/wireless/intel/iwlwifi/fw/api/tx.h    |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 251 +++++++++---------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  80 +++++-
 .../intel/iwlwifi/iwl-devtrace-iwlwifi.h      |  55 ----
 .../net/wireless/intel/iwlwifi/iwl-devtrace.c |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |  23 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  |  53 ++++
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |  14 +-
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |   1 -
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |   2 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  85 +++---
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  51 ++--
 20 files changed, 438 insertions(+), 284 deletions(-)

-- 
2.18.0
