Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14717 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757183AbaJ1GPx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 02:15:53 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: stable@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.16 0/7] Backort firmware monitor to 3.16
Date: Tue, 28 Oct 2014 08:11:19 +0200
Message-Id: <1414476686-3407-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141028_071609_837503_D845563C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series allows to use the firmware debugging features
of iwlwifi on 3.16. These features are already in 3.17.

I know that this patch series is not compliant with Greg's
rules for stable patches. It is unlikely that these patches
will be applied on vanilla 3.16 - I know that.
I send them here so that distros can apply them if they want
to.
I know there are distros shipping 3.16, and having these
patches in can greatly help our ability to debug nasty
issues.

Emmanuel Grumbach (7):
  iwlwifi: add device / firmware to fw-error-dump file
  iwlwifi: rename iwl_mvm_fw_error_next_data
  iwlwifi: pcie: add firmware monitor capabilities
  iwlwifi: remove wrong comment about alignment in iwl-fw-error-dump.h
  iwlwifi: mvm: don't collect logs in the interrupt thread
  iwlwifi: mvm: kill iwl_mvm_fw_error_rxf_dump
  iwlwifi: mvm: update layout of firmware error dump

 drivers/net/wireless/iwlwifi/iwl-drv.c           |   6 ++
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |  50 ++++++++-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h       |   5 +-
 drivers/net/wireless/iwlwifi/iwl-fw.h            |   3 +
 drivers/net/wireless/iwlwifi/iwl-modparams.h     |   2 +
 drivers/net/wireless/iwlwifi/iwl-prph.h          |   6 ++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      | 100 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h           |   9 --
 drivers/net/wireless/iwlwifi/mvm/ops.c           |  72 -------------
 drivers/net/wireless/iwlwifi/mvm/utils.c         |  65 ------------
 drivers/net/wireless/iwlwifi/pcie/internal.h     |   7 ++
 drivers/net/wireless/iwlwifi/pcie/trans.c        | 125 ++++++++++++++++++++++-
 12 files changed, 294 insertions(+), 156 deletions(-)

-- 
1.9.1

