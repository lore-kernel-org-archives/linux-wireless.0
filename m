Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36112 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751269AbdAWWED (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:04:03 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com
Date: Tue, 24 Jan 2017 00:03:25 +0200
Message-Id: <20170123220350.25305-1-luca@coelho.fi> (sfid-20170123_230414_132169_93D9210C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 00/25] iwlwifi: updates intended for v4.11 2017-01-23
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's my first series for v4.11.  These are the changes:

* A bunch of cleanups here and there;
* A few simple bugfixes;
* Some more work in preparation for A000 family support;
* Add support for radiotap timestamps;
* Some work on our firmware debugging capabilities;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.

Johannes Berg (5):
  iwlwifi: mvm: expose device timestamp in radiotap
  iwlwifi: mvm: accept arbitrary memory dump TLVs
  iwlwifi: mvm: make iwl_dump_prph() void
  iwlwifi: allow memory debug TLV to specify the memory type
  iwlwifi: mvm: properly check for transport data in dump

Jürg Billeter (1):
  iwlwifi: fix MODULE_FIRMWARE for 6030

Kirtika Ruchandani (3):
  iwlwifi: mvm: rs: Remove unused 'mvmvif'/'mvmsta' variables
  iwlwifi: mvm: rs: Remove unused 'mcs' variable
  iwlwifi: pcie: trans: Remove unused 'shift_param'

Luca Coelho (7):
  iwlwifi: mvm: don't restart HW if suspend fails with unified image
  iwlwifi: mvm: bump max API to 28
  iwlwifi: mvm: remove unused variable in iwl_mvm_handle_statistics()
  iwlwifi: dvm: make rs_tl_get_load() return void
  iwlwifi: mvm: remove unused sta_id variable in
    iwl_mvm_change_queue_owner()
  iwlwifi: dvm: remove unused variable compiler warning in debugfs.c
  iwlwifi: mvm: mark ret as maybe_unused in iwl_dbgfs_fw_restart_write()

Sara Sharon (9):
  iwlwifi: mvm: simplify paging allocation code
  iwlwifi: mvm: replace the number of blocks calculation
  iwlwifi: enlarge number of ucode sections
  iwlwifi: mvm: change iwl_mvm_tx_csum to return value
  iwlwifi: mvm: separate rate calculation to a new function
  iwlwifi: mvm: support version 2 of stored beacon notification
  iwlwifi: pcie: cleanup rfkill checks
  iwlwifi: mvm: use mvm_disable_queue instead of sharing logic
  iwlwifi: mvm: cleanup redundant assignment

 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c       |  11 +-
 drivers/net/wireless/intel/iwlwifi/dvm/ucode.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-6000.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c     |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c     |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c      |  98 +++++++++--------
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h  |  24 ++---
 drivers/net/wireless/intel/iwlwifi/iwl-fw.h       |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c       |  13 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h   |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c   | 123 ++++++++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       |  69 ++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c       |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c       |   2 -
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      |  24 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 107 ++++++++++---------
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c    |  14 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c   |  51 ++++-----
 26 files changed, 299 insertions(+), 297 deletions(-)

-- 
2.11.0
