Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47634 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S935408AbdCXPh2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Mar 2017 11:37:28 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Mar 2017 17:37:11 +0200
Message-Id: <20170324153714.8880-1-luca@coelho.fi> (sfid-20170324_163804_974057_DC3BBAF4)
Subject: [PATCH 0/3] iwlwifi patches intended for 4.11
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here are three patches intended for 4.11.  The first one is an RCU fix
by Sari.  The second one is a fix for a potential out-of-bounds access
crash by Dan.  And finally, the third and bigger one, is a fix for
IBSS, which has been broken since DQA was enabled in the driver.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Dan Carpenter (1):
  iwlwifi: mvm: writing zero bytes to debugfs causes a crash

Liad Kaufman (1):
  iwlwifi: mvm: support ibss in dqa mode

Sara Sharon (1):
  iwlwifi: mvm: fix accessing fw_id_to_mac_id

 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c  | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 9 ++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 7 +++++--
 5 files changed, 16 insertions(+), 7 deletions(-)

-- 
2.11.0
