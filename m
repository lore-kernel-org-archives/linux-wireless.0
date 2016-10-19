Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50150 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S943067AbcJSOzT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 10:55:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Oct 2016 10:27:19 +0300
Message-Id: <20161019072726.22018-1-luca@coelho.fi> (sfid-20161019_165530_382362_99145C59)
Subject: [PATCH 0/7] iwlwifi: updates intended for v4.9 2016-10-19
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here are a few fixes that I'm planning to send for v4.9.  Nothing
major, here's what they are about:

* some fixes for suspend/resume with unified FW images;
* a fix for a false-positive lockdep report;
* a fix for multi-queue that caused an unnecessary 1 second latency;
* a fix for an ACPI parsing bug that caused a misleading error
  message;

I'll leave this in my pending branch for a while to get kbuild bot
reports and then I'll send a pull-request.

Please review.

Cheers,
Luca.


Haim Dreyfuss (1):
  iwlwifi: mvm: comply with fw_restart mod param on suspend

Johannes Berg (1):
  iwlwifi: pcie: mark command queue lock with separate lockdep class

Luca Coelho (4):
  iwlwifi: mvm: use ssize_t for len in iwl_debugfs_mem_read()
  iwlwifi: mvm: fix d3_test with unified D0/D3 images
  iwlwifi: pcie: fix SPLC structure parsing
  iwlwifi: mvm: fix netdetect starting/stopping for unified images

Sara Sharon (1):
  iwlwifi: mvm: wake the wait queue when the RX sync counter is zero

 drivers/net/wireless/intel/iwlwifi/mvm/d3.c       | 49 ++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c  |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c     | 33 ++++++++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c     | 79 ++++++++++++++---------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c      |  8 +++
 9 files changed, 128 insertions(+), 53 deletions(-)

-- 
2.9.3
