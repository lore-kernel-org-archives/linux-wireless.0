Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45412 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934350AbcIVUwT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 16:52:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 22 Sep 2016 23:52:00 +0300
Message-Id: <20160922205210.1778-1-luca@coelho.fi> (sfid-20160922_225244_334573_55AC9A3F)
Subject: [PATCH 00/10] iwlwifi: updates for 2016-09-22 
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's a series of patches that were pending in our internal tree.

I'm changing the process a bit.  From now on I'll send the patches out
first for review and only later apply them on iwlwifi-next/master and
send a pull request.  This will make reviews easier and will also
allow kbuild bot to run tests before I actually apply the patches and
send a pull request.

Please review and let me know if there are any problems.

Cheers,
Luca.


Emmanuel Grumbach (2):
  iwlwifi: mvm: fix typo in TC_CMD_SEC_KEY_FROM_TABLE
  iwlwifi: mvm: initialise ADD_STA before sending it to the firmware

Johannes Berg (2):
  iwlwifi: pcie: avoid variable shadowing in TFD helpers
  iwlwifi: mvm: correct rate_idx bounds-check

Luca Coelho (2):
  iwlwifi: mvm: bail out if CTDP start operation fails
  iwlwifi: remove support for fw older than -17 and -22

Oren Givon (1):
  iwlwifi: add two new 9560 series PCI IDs

Sara Sharon (3):
  iwlwifi: mvm: cleanup redundant no_power_up_nic_in_init config
  iwlwifi: mvm: cleanup usage of init_dbg parameter
  iwlwifi: allow error table address new range

 drivers/net/wireless/intel/iwlwifi/iwl-7000.c      |  6 +--
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c      |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c      |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  1 -
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h   | 24 +---------
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |  3 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-power.h  | 21 +++------
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h |  6 +--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 43 ++++++++----------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 24 ++++------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  2 -
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       | 52 +++++++---------------
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     | 15 +++----
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 27 ++---------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        | 10 +----
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  2 +
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h | 19 ++++----
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 47 ++++++++++---------
 21 files changed, 110 insertions(+), 204 deletions(-)

-- 
2.9.3
