Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33418 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1424003AbeCBMbU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 07:31:20 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Mar 2018 14:31:08 +0200
Message-Id: <20180302123112.27416-1-luca@coelho.fi> (sfid-20180302_133124_563275_088610C6)
Subject: [PATCH 0/4] iwlwifi: fixes intended for 4.16 2018-03-02
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is my third batch of fixes inteded for 4.16.

These are the fixes:

* Fix an issue with the multicast queue;
* Fix IGTK handling;
* Fix some missing return value checks;
* Add support for a HW workaround for issues on some platforms;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Beni Lev (1):
  iwlwifi: mvm: Correctly set IGTK for AP

Emmanuel Grumbach (1):
  iwlwifi: mvm: set the correct tid when we flush the MCAST sta

Johannes Berg (1):
  iwlwifi: mvm: fix error checking for multi/broadcast sta

Luca Coelho (1):
  iwlwifi: add shared clock PHY config flag for some devices

 drivers/net/wireless/intel/iwlwifi/cfg/9000.c     | 62 +++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/file.h      |  1 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h   |  5 ++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       |  4 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 21 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 10 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c     | 38 +++++++-------
 8 files changed, 109 insertions(+), 36 deletions(-)

-- 
2.16.1
