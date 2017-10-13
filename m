Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53148 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758036AbdJMNZP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 09:25:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Oct 2017 16:24:53 +0300
Message-Id: <20171013132502.10473-1-luca@coelho.fi> (sfid-20171013_152605_019145_55443064)
Subject: [PATCH 0/9] ] iwlwifi: updates intended for v4.15 2017-10-13
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the third set of patches intended for 4.15.  A few small fixes,
but mostly just code cleanups.

These are the changes:

* Allocate reorder buffer dynamically to save memory;
* Fix a FW dump problem in the A000 family;
* Fix for a statistics gathering issue;
* Sort the list of 9000 devices to make it easier to find entries;
* A couple of cleanups in the FW dump code;
* Remove some unnecessary variables and fields and calculations;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Beni Lev (1):
  iwlwifi: mvm: allow reading UMAC error data from SMEM in A000 devices

Johannes Berg (3):
  iwlwifi: mvm: allocate reorder buffer according to need
  iwlwifi: mvm: pass baid_data to iwl_mvm_release_frames()
  iwlwifi: pcie: remove set but not used variable tcph

Liad Kaufman (1):
  iwlwifi: mvm: add missing lq_color

Luca Coelho (3):
  iwlwifi: mvm: move umac_error_event_table validity check to where it's
    set
  iwlwifi: define minimum valid address for umac_error_event_table in
    cfg
  iwlwifi: pcie: sort IDs for the 9000 series for easier comparisons

Sara Sharon (1):
  iwlwifi: mvm: remove duplicated fields in mvm reorder buffer

 drivers/net/wireless/intel/iwlwifi/cfg/8000.c     |  3 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c     |  3 +-
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c     |  3 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h    |  4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h   |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       | 20 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 43 +++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     | 49 ++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 44 +++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c    | 17 ++---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c     | 84 +++++++++++------------
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  5 +-
 13 files changed, 176 insertions(+), 103 deletions(-)

-- 
2.14.2
