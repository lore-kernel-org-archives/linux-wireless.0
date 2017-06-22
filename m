Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34210 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753802AbdFVVVR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:21:17 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:20:36 +0300
Message-Id: <20170622212101.16422-1-luca@coelho.fi> (sfid-20170622_232122_120083_E59C616E)
Subject: [PATCH 00/25] iwlwifi: updates intended for v4.13 2017-06-23
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Morjens,

More patches intended for 4.13.  These are the changes:

* Johannes' documentation work continues;
* Some changes in suspend/resume handling to support new FWs;
* A bunch of RF-kill related fixes;
* Continued work towards the A000 family;
* Some small improvements, fixes and cleanups;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a comnined pull-request with the previous bunch later.

Please review.

Cheers,
Luca.


David Spinadel (1):
  iwlwifi: mvm: Enable security on new TX API

Emmanuel Grumbach (1):
  iwlwifi: mvm: avoid unnecessary cache trashing in Tx path

Gregory Greenman (1):
  iwlwifi: mvm: rs: add logs for the wrong antenna case

Johannes Berg (16):
  iwlwifi: remove resp_pkt NULL checks
  iwlwifi: mvm: remove pointless num_stored condition
  iwlwifi: pcie: fix TVQM queue ID range check
  iwlwifi: mvm: avoid variable shadowing
  iwlwifi: mvm: use scnprintf() instead of snprintf()
  iwlwifi: use bitfield.h for some registers
  iwlwifi: mvm: track and report IBSS manager status to mac80211
  iwlwifi: mvm: make iwl_mvm_update_mcc() easier to follow
  iwlwifi: pcie: pull out common rfkill IRQ handling code
  iwlwifi: pcie: add fake RF-kill to debugfs
  iwlwifi: mvm: don't warn in queue sync on RF-kill
  iwlwifi: pcie: don't report RF-kill enabled while shutting down
  iwlwifi: pcie: remove pointless debugfs parsing for csr file
  iwlwifi: mvm: document status bits
  iwlwifi: pcie: use kstrtou32_from_user()
  iwlwifi: mvm: better link scan notification results length

Liad Kaufman (3):
  iwlwifi: mvm: remove txq EMPTYING_DELBA state for DQA
  iwlwifi: mvm: disable dbg data collect when fw isn't alive
  iwlwifi: mvm: support aggregations on A000 HW

Luca Coelho (2):
  iwlwifi: mvm: make D0I3_END_CMD sync during system resume
  iwlwifi: mvm: support D0I3_END_CMD at the start of resume

Mordechai Goodstein (1):
  iwlwifi: mvm: change the firmware name loading

 drivers/net/wireless/intel/iwlwifi/iwl-a000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |  10 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h   |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |  17 +--
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  39 +++---
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |  22 ++--
 .../net/wireless/intel/iwlwifi/mvm/fw-api-scan.h   |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c    |   4 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  31 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  17 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |  33 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  19 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 144 ++++++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  24 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   7 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  12 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  14 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       | 106 +++++++--------
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |  28 +---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 145 ++++++++++++++-------
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |   6 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  10 +-
 29 files changed, 434 insertions(+), 288 deletions(-)

-- 
2.11.0
