Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36922 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752572AbeC1OMF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 10:12:05 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Mar 2018 17:11:43 +0300
Message-Id: <20180328141157.5427-1-luca@coelho.fi> (sfid-20180328_161209_933143_D83A8DDA)
Subject: [PATCH 00/14] iwlwifi: updates intended for v4.17 2018-03-28
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the last batch of patches intended for 4.17.  I'm also
including the 5 patches I sent out last year and were still pending,
since they were rebased and some have changed slightly.

The old series contains these:

* Fix a UBSAN warning;
* Improvement in the net-stack/driver log syncing
* An RCU lock fix in the new rate-scaling code;
* Small cleanups;

The new series of 9 patches contains:

* Support for new PCI IDs for the 9000 family;
* Support for a new API version;
* Initial work for supporting the new ETSI rules;
* Support for advanced dwell in scanning;
* Support for OCE in scanning;
* Some debugging improvements;
* Other small improvements here and there.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Ayala Beker (1):
  iwlwifi: fw api: support the new scan request FW API version

Emmanuel Grumbach (1):
  iwlwifi: bump the max API version for 9000 and 22000 devices

Haim Dreyfuss (1):
  iwlwifi: api: Add geographic profile information to MCC_UPDATE_CMD

Ilan Peer (1):
  iwlwifi: mvm: Allow iwl_mvm_mac_mgd_prepare_tx() when associated

Luca Coelho (2):
  iwlwifi: mvm: check if mac80211_queue is valid in iwl_mvm_disable_txq
  iwlwifi: add a bunch of new 9000 PCI IDs

Mordechay Goodstein (1):
  iwlwifi: set default timstamp marker cmd

Sara Sharon (4):
  iwlwifi: mvm: flip AMSDU addresses only for 9000 family
  iwlwifi: mvm: take RCU lock before dereferencing
  iwlwifi: mvm: move TSO segment to a separate function
  iwlwifi: mvm: save low latency causes in an enum

Shahar S Matityahu (1):
  iwlwifi: wrt: add fw force restart via triggers

Zamir, Roee (2):
  iwlwifi: mvm: add adaptive dwell support
  iwlwifi: mvm: add support for oce

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |   4 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |  20 ++-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |  73 ++++++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  10 ++
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |  24 ++-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h    |   5 +
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |  16 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |   2 +
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  48 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  25 +--
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 199 +++++++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 158 ++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  19 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 157 +++++++++++++++-
 18 files changed, 600 insertions(+), 196 deletions(-)

-- 
2.16.2
