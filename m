Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45812 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754289AbdKOQw4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Nov 2017 11:52:56 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 15 Nov 2017 18:52:39 +0200
Message-Id: <20171115165242.21675-1-luca@coelho.fi> (sfid-20171115_175304_204989_F6BFFD8D)
Subject: [PATCH 0/3] iwlwifi: fixes intended for 4.15 2017-11-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is the first batch of fixes intended for 4.15.  This are
important fixes that solve problems with the new -34.ucode firmware
that was published for 8000 series devices and problems with
unrecognized 9000 series devices.  There is also one fix for the
firmware name strings we export to modinfo.

These are the fixes:

* Support new FW API version of scan cmd (used in FW version 34);
* Add a bunch of PCI IDs and fix configuration structs for A000
  devices;
* Fix the exported firmware name strings for 9000 and A000 devices;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.

Luca Coelho (2):
  iwlwifi: mvm: support version 7 of the SCAN_REQ_UMAC FW command
  iwlwifi: fix PCI IDs and configuration mapping for 9000 series

Thomas Backlund (1):
  iwlwifi: fix firmware names for 9000 and A000 series hw

 drivers/net/wireless/intel/iwlwifi/cfg/9000.c    |  73 +++++++++++--
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c    |  10 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h |  59 +++++++---
 drivers/net/wireless/intel/iwlwifi/fw/file.h     |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h     |   6 ++
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c    |  86 +++++++++++----
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c    | 132 ++++++++++++++++++-----
 7 files changed, 291 insertions(+), 76 deletions(-)

-- 
2.15.0
