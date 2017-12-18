Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50954 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1759272AbdLRMiW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Dec 2017 07:38:22 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 18 Dec 2017 14:38:04 +0200
Message-Id: <20171218123815.3968-1-luca@coelho.fi> (sfid-20171218_133826_697260_3259B1E4)
Subject: [PATCH 00/11] iwlwifi: updates intended for v4.16 2017-12-18
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the third batch of patches intended for 4.16.  Nothing major,
just continued development, some cleanups and small fixes here and
there.

* Small cleanups in the new rate-scaling code;
* Some improvements in debugging;
* New FW API changes;
* Fix a bug where we got a false-positive warning;
* Fix forced quota debugfs functionality;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Emmanuel Grumbach (2):
  iwlwifi: fw: fix the enums in the rate scaling API
  iwlwifi: define and use if iwl_mvm_has_tlc_offload

Golan Ben Ami (2):
  iwlwifi: support internal debug data collection for new devices
  iwlwifi: avoid duplicate sw reset executions in the code

Mordechay Goodstein (2):
  iwlwifi: runtime: sync FW and host clocks for logs
  iwlwifi: add skb address to tx cmd in trace events data

Sara Sharon (2):
  iwlwifi: mvm: support RX flags API change
  iwlwifi: mvm: don't warn on multiple packets when opening a queue

Shaul Triebitz (3):
  iwlwifi: mvm: force quota update upon NoA setting
  iwlwifi: mvm: adjust to quota offload
  iwlwifi: mvm: send the low latency command

 drivers/net/wireless/intel/iwlwifi/Makefile        |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h  |   4 +-
 .../net/wireless/intel/iwlwifi/fw/api/mac-cfg.h    |  19 ++
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |  34 ++--
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    | 195 +++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h    |  87 +++++++++
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |  33 +++-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |  13 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |  14 +-
 .../wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h  |   7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  99 +++++++++--
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   6 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c     |   4 +
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  30 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   7 -
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  77 +++++---
 27 files changed, 582 insertions(+), 104 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h

-- 
2.15.1
