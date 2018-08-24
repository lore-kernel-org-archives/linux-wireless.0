Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43814 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726330AbeHXOEZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:04:25 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Aug 2018 13:30:02 +0300
Message-Id: <20180824103018.15011-1-luca@coelho.fi> (sfid-20180824_123028_265657_F2FF4C61)
Subject: [PATCH 00/16]  iwlwifi: updates intended for v4.20 2018-08-24
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>


Hi,

Here's the third set of patches intended for v4.20.  It's the usual
development, with some small new feauters, cleanups and bugfixes.

The changes are:

* Enable a new scanning feature;
* Continued work on HE (mostly radiotap);
* Some fixes in the FW rate-scaling implementation;
* General small fixes;
* Other clean-ups and small improvements;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

I have a lot of pending patches in our internal tree, so I'll probably
send another patchset before sending the pull-request.

Please review.

Cheers,
Luca.


Ayala Beker (1):
  iwlwifi: mvm: activate fragmented EBS in case of fragmented scan

Emmanuel Grumbach (1):
  iwlwifi: mvm: send BCAST management frames to the right station

Golan Ben Ami (1):
  iwlwifi: refactor txq_alloc for supporting more command type

Ido Yariv (1):
  iwlwifi: Add missing 11n disable module parameter check

Johannes Berg (7):
  iwlwifi: mvm: implement extended HE-MU sniffer API
  iwlwifi: mvm: put LTF symbol size into HE radiotap
  iwlwifi: mvm: properly decode HE GI duration
  iwlwifi: mvm: report # of LTF symbols for extended range SU PPDUs
  iwlwifi: mvm: remove channel 2 from HE radiotap if not applicable
  iwlwifi: mvm: decode HE TB PPDU data
  Revert "iwlwifi: allow memory debug TLV to specify the memory type"

Naftali Goldstein (3):
  iwlwifi: mvm: always init rs_fw with 20MHz bandwidth rates
  iwlwifi: rs-fw: enable STBC in he correctly
  iwlwifi: rs-fw: support dcm

Shahar S Matityahu (2):
  iwlwifi: change monitor DMA to be coherent
  iwlwifi: avoid code duplication in stopping fw debug data recording

 .../net/wireless/intel/iwlwifi/fw/api/rs.h    |  18 +-
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    | 136 +++++++++---
 .../net/wireless/intel/iwlwifi/fw/api/scan.h  |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |  59 ++---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  10 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  15 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  15 --
 .../wireless/intel/iwlwifi/iwl-eeprom-parse.c |   4 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/rs-fw.c    |  35 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c   |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h   |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 210 ++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c |  12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |  14 +-
 .../wireless/intel/iwlwifi/pcie/internal.h    |  14 +-
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |   5 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  70 ++----
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  91 +++++---
 21 files changed, 455 insertions(+), 269 deletions(-)

-- 
2.18.0
