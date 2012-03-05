Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7349 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965039Ab2CEUiC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:38:02 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/33] update for 3.4: iwlwifi 2012-03-05
Date: Mon,  5 Mar 2012 11:24:18 -0800
Message-Id: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120305_213921_368037_CE2E843A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First set of major re-factor and clenup works happen in iwlwifi,
we move the code to the proper place and get ready for the next generation
of the devices

We also modify the auth/assoc flow to match the re-design work in mac80211


Johannes Berg (33):
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

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git
