Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35208 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750731AbeCPLvq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 07:51:46 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 16 Mar 2018 13:51:31 +0200
Message-Id: <20180316115136.1234-1-luca@coelho.fi> (sfid-20180316_125151_179995_2669ADB6)
Subject: [PATCH 0/5] iwlwifi: fixes intended for 4.16 2018-03-16
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is my fourth batch of fixes inteded for 4.16.

These are the fixes:

* a couple of fixes for channel-switch;
* a few fixes for the aggregation handling code;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Andrei Otcheretianski (2):
  iwlwifi: mvm: Increase session protection time after CS
  iwlwifi: mvm: Move unused phy's to a default channel

Avraham Stern (3):
  iwlwifi: mvm: clear tx queue id when unreserving aggregation queue
  iwlwifi: mvm: make sure internal station has a valid id
  iwlwifi: mvm: fix array out of bounds reference

 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  3 ++
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  | 21 +++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 53 +++++++++-------------
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    | 15 +++---
 5 files changed, 52 insertions(+), 45 deletions(-)

-- 
2.16.2
