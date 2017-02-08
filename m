Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39166 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752511AbdBHL20 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 06:28:26 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  8 Feb 2017 13:23:05 +0200
Message-Id: <20170208112322.29413-1-luca@coelho.fi> (sfid-20170208_122900_516443_A7263FFB)
Subject: [PATCH 00/17] iwlwifi: updates intended for v4.11 2017-02-08
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is the third and final pull-request before 4.11's merge window.
This time I concentrated in bugfixes:

* Fix 802.11w, which was failing to due an IGTK bug;
* A few more bugzilla bug fixes;
* A channel-switch race condition fix;
* Some fixes related to suspend/resume with new HW;
* The RF-kill saga continues;
* And some other fixes here and there...

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Avraham Stern (1):
  iwlwifi: mvm: Fix CSA received immediately after association

Emmanuel Grumbach (5):
  iwlwifi: mvm: use the PROBE_RESP_QUEUE to send deauth to unknown
    station
  iwlwifi: pcie: don't increment / decrement a bool
  iwlwifi: make RTPM depend on EXPERT
  iwlwifi: dvm: don't call << operator with a negative value
  iwlwifi: mvm: don't call << operator with a negative value

Golan Ben Ami (2):
  iwlwifi: pcie: Re-configure IVAR table after stop device
  iwlwifi: pcie: set STATUS_RFKILL immediately after interrupt

Golan Ben-Ami (1):
  iwlwifi: mvm: avoid exceeding the allowed print length

Goodstein, Mordechay (1):
  iwlwifi: mvm: avoid race condition in ADD_STA.

Gregory Greenman (1):
  iwlwifi: mvm: fix a print of NSS for HT rate

Haim Dreyfuss (3):
  iwlwifi: pcie: move msix conf functions above other functions
  iwlwifi: pcie: separate between SW and HW MSIX configuration
  iwlwifi: pcie: re-configure IVAR table after suspend-resume

Ilan Peer (1):
  iwlwifi: mvm: Fix removal of IGTK

Sara Sharon (2):
  iwlwifi: mvm: fix references to first_agg_queue in DQA mode
  iwlwifi: mvm: fix reorder timer re-arming

 drivers/net/wireless/intel/iwlwifi/Kconfig         |   7 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  17 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 243 ++++++++++++---------
 11 files changed, 188 insertions(+), 145 deletions(-)

-- 
2.11.0
