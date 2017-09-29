Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36134 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751899AbdI2Qoc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 12:44:32 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 29 Sep 2017 19:44:05 +0300
Message-Id: <20170929164423.23666-1-luca@coelho.fi> (sfid-20170929_200756_068273_D51C41D7)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 00/18] iwlwifi: updates intended for v4.15 2017-09-29
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the second set of patches intended for 4.15.  Nothing major,
mostly just cleanups.

These are the changes:

* ACPI code refactoring;
* Some coding-style fixes;
* Avoid redundant command to the firmware;
* Add a struct with the format of one FW command;
* Change an error log to a warning when the FW API is not aligned with
  the driver (important during development);
* Change a WARN_ON to WARN_ONCE to make it more descriptive and less
  noisy (i.e. no repeated warnings on a firmware triggered error);
* Dump PCI registers when an error occurs, to make it easier to debug;

Since I have not sent a pull-req for the previous batch yet, I'll send
them all together next week.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Christoph Böhmwalder (1):
  iwlwifi: fix minor code style issues

Emmanuel Grumbach (1):
  iwlwifi: mvm: don't send identical PHY_CTXT_CMD

Johannes Berg (3):
  iwlwifi: fw: api: remove excess enum value documentation
  iwlwifi: fix indentation in a000 family configuration
  iwlwifi: mvm: warn on invalid statistics size

Luca Coelho (10):
  iwlwifi: acpi: add common code to read from ACPI
  iwlwifi: acpi: move ACPI method definitions to acpi.h
  iwlwifi: acpi: move ACPI-related definitions to acpi.h
  iwlwifi: acpi: generalize iwl_mvm_sar_find_wifi_pkg()
  iwlwifi: acpi: use iwl_acpi_get_wifi_pkg when reading reading SPLC
  iwlwifi: acpi: make iwl_get_bios_mcc() use the common acpi functions
  iwlwifi: acpi: remove a couple of unnecessary ifdefs
  iwlwifi: acpi: move function to get mcc into acpi code
  iwlwifi: acpi: move code that reads SPLC to acpi
  iwlwifi: remove dflt_pwr_limit from the transport

Mordechay Goodstein (1):
  iwlwifi: mvm: add marker cmd response struct.

Rajat Jain (1):
  iwlwifi: pcie: dump registers when HW becomes inaccessible

Sara Sharon (1):
  iwlwifi: mvm: change warning to warn_once()

 drivers/net/wireless/intel/iwlwifi/Makefile        |   1 +
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c      | 100 +++++-----
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       | 210 +++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       | 138 ++++++++++++++
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h  |   9 +
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |   3 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h    |   4 -
 drivers/net/wireless/intel/iwlwifi/iwl-debug.h     |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  91 +--------
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h |  17 --
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   2 -
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 207 ++++----------------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  14 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  17 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  97 +---------
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  88 +++++++++
 24 files changed, 590 insertions(+), 452 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/acpi.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/acpi.h

-- 
2.14.1
