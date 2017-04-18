Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52680 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753002AbdDRWRm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:17:42 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:04 +0300
Message-Id: <20170418221729.28372-1-luca@coelho.fi> (sfid-20170419_001752_417976_55F57962)
Subject: [PATCH 00/25] iwlwifi: updates intended for v4.12 2017-04-19
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is the third patch set intended for v4.12.  These are the changes:

 * Heavy work for the A000 device series;
 * Some cleanup patches;
 * A couple of fixes;
 * Start supporting FW API version 31;
 * Geographical SAR support;
 * Support a few new PCI device IDs;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.

David Spinadel (1):
  iwlwifi: mvm: change TX_CMD_SEC_KEY_FROM_TABLE value

Emmanuel Grumbach (3):
  iwlwifi: mvm: provide the actual number of frames for the SP len
  iwlwifi: split the handler and the wake parts of the notification
    infra
  iwlwifi: bump API to 31

Haim Dreyfuss (1):
  iwlwifi: mvm: add GEO_TX_POWER_LIMIT cmd for geographic tx power table

Liad Kaufman (2):
  iwlwifi: mvm: remove unneeded reg write in iwl_mvm_up()
  iwlwifi: a000: fix memory offsets and lengths

Luca Coelho (2):
  iwlwifi: mvm: remove unnecessary label in
    iwl_mvm_handle_rx_statistics()
  iwlwifi: pcie: remove RSA race workaround

Sara Sharon (15):
  iwlwifi: mvm: fix accessing fw_id_to_mac_id
  iwlwifi: pcie: get rid of txq id assignment
  iwlwifi: mvm: support new TX response for TVQM
  iwlwifi: move to TVQM mode
  iwlwifi: mvm: do not turn on RX_FLAG_AMSDU_MORE
  iwlwifi: mvm: work around HW issue with AMSDU de-aggregation
  iwlwifi: mvm: ignore BAID for SN smaller than SSN
  iwlwifi: mvm: support change to a000 smem API
  iwlwifi: support a000 CDB product
  iwlwifi: mvm: support init extended command
  iwlwifi: mvm: disable RX queue notification for a000 devices
  iwlwifi: mvm: dump frames early on invalid rate
  iwlwifi: mvm: flip address 4 of AMSDU frames
  iwlwifi: mvm: support changing band for phy context
  iwlwifi: mvm: allow block ack response without data

Tzipi Peres (1):
  iwlwifi: add four new 8265 and 8275 series PCI IDs

 drivers/net/wireless/intel/iwlwifi/iwl-8000.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c      |  28 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   5 +-
 .../net/wireless/intel/iwlwifi/iwl-notif-wait.c    |  10 +-
 .../net/wireless/intel/iwlwifi/iwl-notif-wait.h    |  25 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  38 +--
 .../net/wireless/intel/iwlwifi/mvm/fw-api-power.h  |  43 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h |  44 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |  67 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c    | 287 ++++++++++++---------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 184 +++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  31 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |  21 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  26 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  65 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 127 ++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  40 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  63 +++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  11 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  46 ----
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 118 +++++----
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  33 ++-
 28 files changed, 908 insertions(+), 432 deletions(-)

-- 
2.11.0
