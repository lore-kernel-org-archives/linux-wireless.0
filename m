Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41496 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751012AbdHAJkq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 05:40:46 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  1 Aug 2017 12:40:31 +0300
Message-Id: <20170801094039.22349-1-luca@coelho.fi> (sfid-20170801_114105_524672_A9A4B778)
Subject: [PATCH 0/8] iwlwifi: more fixes intended for 4.13 2017-08-01
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is my second batch of fixes for 4.13.

The issues solved here are:

* Some simple PCI HW ID fix-ups and additions for family 9000;
* A couple of bugzilla fixes:
  - Remove a bogus warning message with new FWs (196915)
  - Don't allow illegal channel options to be used (195299)
* A fix for checksum offload in family 9000;
* A fix serious throughput degradation in 11ac with multiple streams;
* An old bug in SMPS where the firmware was not aware of SMPS changes;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Emmanuel Grumbach (3):
  iwlwifi: mvm: fix TCP CSUM offload with WEP and A000 series
  iwlwifi: add TLV for MLME offload firmware capability
  iwlwifi: split the regulatory rules when the bandwidth flags require
    it

Gregory Greenman (2):
  iwlwifi: mvm: set A-MPDU bit upon empty BA notification from FW
  iwlwifi: mvm: rs: fix TLC statistics collection

Haim Dreyfuss (1):
  iwlwifi: fix fw_pre_next_step to apply also for C step

Naftali Goldstein (1):
  iwlwifi: mvm: set the RTS_MIMO_PROT bit in flag mask when sending sta
    to fw

Tzipi Peres (1):
  iwlwifi: add the new 9000 series PCI IDs

 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      | 14 +++++++-------
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |  2 ++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  8 ++++----
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  5 +++--
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 19 +++++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  8 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 12 ++++++++++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 20 ++++++++++++++++++++
 9 files changed, 63 insertions(+), 28 deletions(-)

-- 
2.13.2
