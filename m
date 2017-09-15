Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54334 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751323AbdIOMrL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 08:47:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 15 Sep 2017 15:46:54 +0300
Message-Id: <20170915124704.9032-1-luca@coelho.fi> (sfid-20170915_144721_326915_03AAFCFB)
Subject: [PATCH 00/10] iwlwifi: updates intended for v4.15 2017-09-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's my first set of patches intended for 4.15.  Nothing major here,
these are the changes:

* Cleanups: - remove an unused value that we read from the NVM;
  	    - remove link quality measurement code that was never used;
* One FW command API update;
* A fix and an addition for PCI devices for the A000 family;
* Tiny refactor of ref/unref code used by runtime-PM;
* Some debugging improvements;
* Implementation of a more flexible way to define command queue sizes;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Chaya Rachel Ivgi (1):
  iwlwifi: remove redundant reading from NVM file

David Spinadel (1):
  iwlwifi: mvm: Add new quota command API

Emmanuel Grumbach (2):
  iwlwifi: mvm: remove support for Link Quality Measurements
  iwlwifi: mvm: support firmware debug trigger on frame reorder timeout

Ilan Peer (1):
  iwlwifi: Add few debug prints to the WRT dump flow

Liad Kaufman (1):
  iwlwifi: mvm: add dbgfs entry for fw info

Luca Coelho (1):
  iwlwifi: trans: move ref/unref code to the common part of the
    transport

Oren Givon (2):
  iwlwifi: fix wrong struct for a000 device
  iwlwifi: add a new a000 device

Shahar S Matityahu (1):
  iwlwifi: pcie: dynamic Tx command queue size

 drivers/net/wireless/intel/iwlwifi/cfg/a000.c      |  3 +-
 .../net/wireless/intel/iwlwifi/fw/api/binding.h    | 41 ++++++++-
 .../net/wireless/intel/iwlwifi/fw/api/mac-cfg.h    | 67 ---------------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 15 ++++
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |  3 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  3 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  7 --
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     | 16 ++++
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     | 14 +---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        | 16 ++--
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   | 76 -----------------
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   | 32 ++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 38 +--------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       | 45 +++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  2 -
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c     | 59 +++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  5 ++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     | 96 ++++++----------------
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  3 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 23 +++++-
 24 files changed, 255 insertions(+), 323 deletions(-)

-- 
2.14.1
