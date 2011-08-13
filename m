Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16165 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab1HMSS1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/60] update for 3.2
Date: Sat, 13 Aug 2011 10:37:36 -0700
Message-Id: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201832_437329_B6884252)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We make a lot of changes to separate out the transport layer and bus layer
We also add a special SKU for 2000 series

Daniel Halperin (1):
  iwlagn: fix compile warnings when CONFIG_PM_SLEEP is not set

Emmanuel Grumbach (52):
  iwlagn: use iwl_get_debug_level instead of iwl_debug_level
  iwlagn: introduce iwl-shared.h
  iwlagn: introduce struct iwl-shared - known by all layers
  iwlagn: debug_level moves to struct iwl_shared
  iwlagn: hw_params moves to iwl_shared
  iwlagn: cmd_queue moves to iwl_shared
  iwlagn: workqueue moves to iwl_shared
  iwlagn: priv->lock moves to iwl_shared
  iwlagn: modify the debug macro to be usable by all the layers
  iwlagn: add IWL_DEBUG_FW_ERRORS
  iwlagn: priv->sta_lock moves to iwl_shared
  iwlagn: bus layer chooses its transport layer
  iwlagn: add comments to iwl_bus / iwl_trans
  iwlagn: transport handler can register debugfs entries
  iwlagn: iwl_rx_queue moves to the iwl_trans_pcie
  iwlagn: move iwl_suspend / iwl_resume to the transport layer
  iwlagn: move ISR related data to transport layer
  iwlagn: move the NIC error flow to the transport layer
  iwlagn: move isr_statistics to transport layer
  iwlagn: reclaim the packets in transport layer
  iwlagn: move reclaim related functions
  iwlagn: move scd_bc_tbls and scd_base_addr to iwl_trans_pcie
  iwlagn: fix the check of IWLAGN_FIRST_AMPDU_QUEUE
  iwlagn: move all iwl_is_XXX helpers to iwl-shared.h
  iwlagn: move iwl_free_pages to iwl-shared.h
  iwlagn: transport layer should receive iwl_trans
  iwlagn: move hcmd_lock to transport layer
  iwlagn: move dump_csr and dump_fh to transport layer
  iwlagn: remove references to priv from the transport layer
  iwlagn: remove unused parameters from hw_params
  iwlagn: iwl-dev.h doesn't include iwl-fh.h any more
  iwlagn: move Keep Warm to transport layer
  iwlagn: add missing includes
  iwlagn: iwl-pci doesn't include iwl-dev any more
  iwlagn: iwl_tid_data moves to iwl-shared
  iwlagn: stop the device before freeing it
  iwlagn: upper layer stores iwl_rxon_context in skb's CB
  iwlagn: set tx_fifo for ampdu in transport layer
  iwlagn: upper layer uses slabs to allocate tx cmds
  iwlagn: move the mapping ac to queue / fifo to transport
  iwlagn: allocate resources for TX BA session in transport
  iwlagn: move the check_empty logic to the transport layer
  iwlagn: move the disable agg logic to transport layer
  iwlagn: cosmetics in iwl-trans.h
  iwlagn: move wait_for_tx_queue_empty to transport layer
  iwlagn: move check_stuck_queue to transport layer
  iwlagn: move the stop / wake queue logic to transport layer
  iwlagn: move tx queues to transport layer
  iwlagn: priv->status moves to iwl_shared
  iwlagn: priv->mutex moves to iwl_shared
  iwlagn: all function iwl-io.c receive iwl_bus
  iwlagn: remove dereferences of priv from transport

Wey-Yi Guy (7):
  iwlagn: Rename iwlcore prefix
  iwlagn: remove out-dated comments
  iwlagn: enable 11n aggregation without checking traffic load
  iwlagn: support small form factor SKU of 6205
  iwlagn: more comments for bt channel inhibition
  iwlagn: add comments to module parameters
  iwlagn: adding special "D" SKU for 2000 series


these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-1000.c           |   42 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c           |   51 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c           |   72 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c           |   60 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c      |   43 +-
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c     |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h         |   13 -
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |  676 +--------
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |   92 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |   60 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c        |   84 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c         |   68 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |  914 ++++++------
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c      |   52 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |  873 ++++--------
 drivers/net/wireless/iwlwifi/iwl-agn.h            |   63 +-
 drivers/net/wireless/iwlwifi/iwl-bus.h            |   34 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h       |    6 +-
 drivers/net/wireless/iwlwifi/iwl-core.c           |  283 ++---
 drivers/net/wireless/iwlwifi/iwl-core.h           |  118 +--
 drivers/net/wireless/iwlwifi/iwl-debug.h          |   40 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |  412 +-----
 drivers/net/wireless/iwlwifi/iwl-dev.h            |  326 +----
 drivers/net/wireless/iwlwifi/iwl-devtrace.h       |    2 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c         |   62 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h         |    1 -
 drivers/net/wireless/iwlwifi/iwl-fh.h             |   20 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h        |   91 +--
 drivers/net/wireless/iwlwifi/iwl-io.c             |  192 ++--
 drivers/net/wireless/iwlwifi/iwl-io.h             |   61 +-
 drivers/net/wireless/iwlwifi/iwl-led.c            |   11 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c            |   41 +-
 drivers/net/wireless/iwlwifi/iwl-pci.h            |  116 ++
 drivers/net/wireless/iwlwifi/iwl-power.c          |   19 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c             |   42 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c           |   97 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h         |  430 ++++++
 drivers/net/wireless/iwlwifi/iwl-sta.c            |  106 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c        |   21 +-
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |  314 ++++-
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c  |  862 +++++++++---
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |  507 +++++--
 drivers/net/wireless/iwlwifi/iwl-trans.c          | 1615 ++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-trans.h          |  216 ++-
 46 files changed, 4910 insertions(+), 4312 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-pci.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-shared.h

