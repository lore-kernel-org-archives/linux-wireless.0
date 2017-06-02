Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60560 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751142AbdFBJfd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 05:35:33 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 12:35:06 +0300
Message-Id: <20170602093516.16369-1-luca@coelho.fi> (sfid-20170602_113544_787717_0A8F2437)
Subject: [PATCH 00/10] iwlwifi: some fixes intended for 4.12
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here some patches that I intend to send in a pull-request for 4.12.
Some of the issues solved are:

* Some memory leaks;
* IBSS support;
* Some bugzilla bugs;
* Some runtime PM fixes;
* Rate-scaling issues;
* Some locking problems;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Emmanuel Grumbach (1):
  iwlwifi: mvm: fix firmware debug restart recording

Gregory Greenman (1):
  iwlwifi: mvm: rs: start using LQ command color

Haim Dreyfuss (1):
  iwlwifi: mvm: Fix command queue number on d0i3 flow

Johannes Berg (2):
  iwlwifi: tt: move ucode_loaded check under mutex
  iwlwifi: mvm: clear new beacon command template struct

Liad Kaufman (1):
  iwlwifi: mvm: support ibss in dqa mode

Luca Coelho (3):
  iwlwifi: pcie: only use d0i3 in suspend/resume if system_pm is set to
    d0i3
  iwlwifi: mvm: don't fail when removing a key from an inexisting sta
  iwlwifi: fix min API version for 7265D, 3168, 8000 and 8265

Shahar S Matityahu (1):
  iwlwifi: fix host command memory leaks

 drivers/net/wireless/intel/iwlwifi/iwl-7000.c      |  4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c      |  4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h |  5 +++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h |  3 ++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c    | 12 +-----
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  6 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       | 32 +++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        | 46 ++++++----------------
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        | 15 +++++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 26 +++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |  8 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 12 +++++-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  6 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  9 +++--
 17 files changed, 115 insertions(+), 78 deletions(-)

-- 
2.11.0
