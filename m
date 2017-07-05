Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37296 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750885AbdGEGFs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2017 02:05:48 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  5 Jul 2017 09:05:32 +0300
Message-Id: <20170705060539.20737-1-luca@coelho.fi> (sfid-20170705_080552_352922_C771960C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 0/7] iwlwifi: some fixes intended for 4.13
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

As promised, I'll start sending things out as soon as possible, so I'm
already sending fixes intended for the 4.13 rc series, even before
it's out. :)

Some of the issues solved are:

* A few NULL pointer dereferences in the recovery flow;
* A small but important fix for IBSS;
* A one-liner fix for tracing, which was including too much data;
* Some of these are bugzilla bug fixes;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Dan Carpenter (1):
  iwlwifi: missing error code in iwl_trans_pcie_alloc()

Emmanuel Grumbach (3):
  iwlwifi: dvm: prevent an out of bounds access
  iwlwifi: mvm: fix a NULL pointer dereference of error in recovery
  iwlwifi: fix tracing when tx only is enabled

Johannes Berg (1):
  iwlwifi: mvm: defer setting IWL_MVM_STATUS_IN_HW_RESTART

Luca Coelho (1):
  iwlwifi: mvm: handle IBSS probe_queue in a few missing places

Mordechai Goodstein (1):
  iwlwifi: pcie: fix unused txq NULL pointer dereference

 drivers/net/wireless/intel/iwlwifi/dvm/tx.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h |  4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  8 +++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  6 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 15 ++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c   |  3 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c      |  3 +++
 8 files changed, 34 insertions(+), 9 deletions(-)

-- 
2.11.0
