Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36200 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751941AbdF2Sag (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 14:30:36 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 29 Jun 2017 21:30:12 +0300
Message-Id: <20170629183027.15408-1-luca@coelho.fi> (sfid-20170629_203045_193262_C5E13298)
Subject: [PATCH 00/15] iwlwifi: updates intended for v4.13 2017-06-29
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is the final patchset that I'd like to get in for v4.13.  In this
one, I concentrated on the changes needed to support version 33 of our
firmware API, which is the version we are going to release for a new
hardware family (the so called 9000 series).  Without this, we won't
be able to support this soon-to-be-made-available HW family in v4.13.

I also included a few important fixes for previous hardware families.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a comnined pull-request with the previous bunch later.

It would be really awesome if we could still include this in v4.13.

Please review.

Cheers,
Luca.


Emmanuel Grumbach (4):
  iwlwifi: mvm: don't send fetch the TID from a non-QoS packet in TSO
  iwlwifi: mvm: don't mess the SNAP header in TSO for non-QoS packets
  iwlwifi: pcie: propagate iwl_pcie_apm_init's status
  iwlwifi: pcie: wait longer after device reset

Johannes Berg (9):
  iwlwifi: mvm: quietly accept non-sta assoc response frames
  iwlwifi: pcie: add MSI-X interrupt tracing
  iwlwifi: mvm: properly enable IP header checksumming
  iwlwifi: mvm: fix mac80211 queue tracking
  iwlwifi: mvm: map cab_queue to real one earlier
  iwlwifi: mvm: fix mac80211's hw_queue in DQA mode
  iwlwifi: pcie: reconfigure MSI-X HW on resume
  iwlwifi: mvm: remove DQA non-STA client mode special case
  iwlwifi: mvm: quietly accept non-sta disassoc frames

Liad Kaufman (1):
  iwlwifi: mvm: update rx statistics cmd api

Luca Coelho (1):
  iwlwifi: bump MAX API for 8000/9000/A000 to 33

 drivers/net/wireless/intel/iwlwifi/cfg/8000.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   4 +
 .../net/wireless/intel/iwlwifi/iwl-devtrace-io.h   |  26 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   | 235 +++++++++++++--------
 .../net/wireless/intel/iwlwifi/mvm/fw-api-stats.h  | 167 +++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  32 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  83 +++++---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  73 ++++---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  10 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   3 +
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   7 +
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   4 +
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  44 ++--
 19 files changed, 512 insertions(+), 221 deletions(-)

-- 
2.11.0
