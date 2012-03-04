Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38078 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890Ab2CDUm4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:42:56 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 000/101] update for 3.4: iwlwifi 2012-03-04
Date: Sun,  4 Mar 2012 11:28:14 -0800
Message-Id: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214659_687687_F4FD9B7D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Major re-factor and clenup works happen in iwlwifi, we move the code to the
proper place and get ready for the next generation of the devices

We also modify the auth/assoc flow to match the re-design work in mac80211

Amit Beka (1):
  iwlwifi: fixed testmode notifications length

David Spinadel (1):
  iwlwifi: add option to test MFP

Don Fry (3):
  iwlwifi: separate status to priv and trans
  iwlwifi: more status bit factoring
  iwlwifi: correct status bit refactoring errors

Emmanuel Grumbach (3):
  iwlwifi: add testmode command for rx forwarding
  iwlwifi: log stop / wake queues
  iwlwifi: restore PAN support

Johannes Berg (83):
  iwlwifi: move iwl_clear_driver_stations to user
  iwlwifi: remove an unused argument
  iwlwifi: reduce sta_lock hold time in TX
  iwlwifi: simplify code in iwlagn_key_sta_id
  iwlwifi: build some station commands directly
  iwlwifi: introduce per-queue locks
  iwlwifi: make sta lock private & BH lock
  iwlwifi: introduce statistics lock
  iwlwifi: remove shared lock
  iwlwifi: make EXIT_PENDING depend on mac80211
  iwlwifi: simplify auth/assoc flow
  iwlwifi: remove per-device debug level
  iwlwifi: remove SKU from config
  iwlwifi: use valid TX/RX antenna from hw_params
  iwlwifi: make config const
  iwlwifi: reduce IDI code ifdef
  iwlwifi: clean up (wowlan) suspend flow
  iwlwifi: move wowlan bool into priv
  iwlwifi: use ieee80211_tx_status
  iwlwifi: pass response packet directly
  iwlwifi: don't pass iwl_rx_mem_buffer to upper layers
  iwlwifi: refactor PCI-E RX path
  iwlwifi: transport's tx_agg_alloc must not sleep
  iwlwifi: move queue functions to PCI-E
  iwlwifi: iwl_rx_cmd_buffer belongs to transport API
  iwlwifi: move tid_to_ac to PCI-E
  iwlwifi: move IWL_MASK into file using it
  iwlwifi: move traffic log definitions
  iwlwifi: fix station HT parameters
  iwlwifi: move uCode deallocation to drv
  iwlwifi: move iwl_base_params to shared header
  iwlwifi: move firmware request into drv
  iwlwifi: move firmware completion wait
  iwlwifi: move ucode loading to op_mode
  iwlwifi: split out firmware store
  iwlwifi: remove iwl-wifi.h
  iwlwifi: add wrappers for command sending
  iwlwifi: move RF/CT kill check to command wrapper
  iwlwifi: move lockdep assertion into DVM
  iwlwifi: move mutex out of shared
  iwlwifi: move rfkill status handling out of transport
  iwlwifi: rename ucode.h to fw-file.h
  iwlwifi: remove AMT check from transport
  iwlwifi: remove shadow_reg_enable from hw_params
  iwlwifi: move status check functions out of shared
  iwlwifi: make tracing use device as identifier
  iwlwifi: virtualize command queue full behaviour
  iwlwifi: clean up iwl-core.h inclusions
  iwlwifi: remove num_of_queues module parameter
  iwlwifi: remove max_txq_num from hw_params
  iwlwifi: keep plcp_delta_threshold in priv
  iwlwifi: use watchdog timeout from hw_params
  iwlwifi: put use_rts_for_aggregation into hw_params
  iwlwifi: constify remaining config data
  iwlwifi: fix notification wait bug
  iwlwifi: abstract out notification wait support
  iwlwifi: move ucode_owner to priv
  iwlwifi: move all uCode load variables
  iwlwifi: move irq to PCIe
  iwlwifi: move packet to transport
  iwlwifi: virtualize nic_config
  iwlwifi: remove priv from shared
  iwlwifi: remove PA type configuration
  iwlwifi: don't include iwl-prph.h everywhere
  iwlwifi: clean up iwl-commands.h
  iwlwifi: make iwl_fill_probe_req static
  iwlwifi: remove unused arguments from iwlagn_gain_computation
  iwlwifi: remove unused argument from rs_initialize_lq
  iwlwifi: move iwl_sta_id_or_broadcast to user
  iwlwifi: remove unused argument from iwl_init_hw_rates
  iwlwifi: remove two unused arguments in testmode
  iwlwifi: remove unused argument from iwlagn_suspend
  iwlwifi: redesign PASSIVE_NO_RX workaround
  iwlwifi: transport's tx_agg_disable must be atomic
  iwlwifi: remove BT handlers from lib_ops
  iwlwifi: move BT/HT params to shared
  iwlwifi: make EEPROM enhanced TX power a bool
  iwlwifi: remove unused max_nrg_cck from sensitivity and constify
  iwlwifi: return error if loading uCode failed
  iwlwifi: remove messages from queue wake/stop
  iwlwifi: make iwl_init_context static
  iwlwifi: don't delete AP station directly
  iwlwifi: always monitor for stuck queues

Meenakshi Venkataraman (3):
  iwlwifi: configure transport layer from dvm op mode
  iwlwifi: move setting up fw parameters
  iwlwifi: move command queue number out of the iwl_shared struct

Stanislaw Gruszka (7):
  iwlwifi: dump stack when fail to gain access to the device
  iwlwifi: always check if got h/w access before write
  iwlwifi: cleanup/fix memory barriers
  iwlwifi: use writeb,writel,readl directly
  iwlwifi: print DMA stop timeout error only if it happened
  iwlwifi: reintroduce iwl_enable_rfkill_int
  iwlwifi: make tx_cmd_pool kmem cache global

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/Kconfig              |   11 +-
 drivers/net/wireless/iwlwifi/Makefile             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c           |   31 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c           |   44 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c           |   63 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c           |  103 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c      |   65 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |  101 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |  180 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |   91 +--
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c        |  385 +++++-----
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c         |   47 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |  164 +++--
 drivers/net/wireless/iwlwifi/iwl-agn.c            |  357 ++++++---
 drivers/net/wireless/iwlwifi/iwl-agn.h            |  166 ++--
 drivers/net/wireless/iwlwifi/iwl-cfg.h            |   82 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h       |  106 +---
 drivers/net/wireless/iwlwifi/iwl-core.c           |  111 +--
 drivers/net/wireless/iwlwifi/iwl-core.h           |   78 +--
 drivers/net/wireless/iwlwifi/iwl-debug.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h          |   26 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |  167 ++---
 drivers/net/wireless/iwlwifi/iwl-dev.h            |   37 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h       |  141 ++--
 drivers/net/wireless/iwlwifi/iwl-drv.c            |  684 +++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-drv.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c         |   69 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h        |  160 ++++
 drivers/net/wireless/iwlwifi/iwl-fw.h             |  146 ++++
 drivers/net/wireless/iwlwifi/iwl-io.c             |   69 +-
 drivers/net/wireless/iwlwifi/iwl-io.h             |    8 +-
 drivers/net/wireless/iwlwifi/iwl-led.c            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       |  403 +++++-----
 drivers/net/wireless/iwlwifi/iwl-notif-wait.c     |  157 ++++
 drivers/net/wireless/iwlwifi/iwl-notif-wait.h     |  129 +++
 drivers/net/wireless/iwlwifi/iwl-op-mode.h        |   26 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c            |   13 +-
 drivers/net/wireless/iwlwifi/iwl-power.c          |   14 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h           |    4 -
 drivers/net/wireless/iwlwifi/iwl-scan.c           |  218 +++---
 drivers/net/wireless/iwlwifi/iwl-shared.h         |  331 ++------
 drivers/net/wireless/iwlwifi/iwl-testmode.c       |  103 ++-
 drivers/net/wireless/iwlwifi/iwl-testmode.h       |   13 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |  104 ++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |  313 ++++----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |  164 +++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |  286 +++----
 drivers/net/wireless/iwlwifi/iwl-trans.c          |   77 --
 drivers/net/wireless/iwlwifi/iwl-trans.h          |  191 +++--
 drivers/net/wireless/iwlwifi/iwl-ucode.c          |  911 +++------------------
 drivers/net/wireless/iwlwifi/iwl-ucode.h          |  220 -----
 drivers/net/wireless/iwlwifi/iwl-wifi.h           |  111 ---
 54 files changed, 3718 insertions(+), 3784 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-fw-file.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-fw.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-notif-wait.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-notif-wait.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-trans.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-ucode.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-wifi.h

