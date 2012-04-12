Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63195 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966032Ab2DLV6G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:06 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/24] update for 3.5: iwlwifi 2012-04-12
Date: Thu, 12 Apr 2012 14:53:57 -0700
Message-Id: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235810_624753_13B43EC2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another batch of the cleanup and refactor work to prepare our up-coming
new architecture. Still a lot more to come.

Johannes Berg (2):
  iwlwifi: make iwl_sta_fill_lq static
  iwlwifi: calculate active legacy rates per station

Meenakshi Venkataraman (20):
  iwlwifi: move iwlagn_hw_valid_rtc_data_addr prototype
  iwlwifi: move channel switch related functions
  iwlwifi: move iwl_free_skb and mark it static
  iwlwifi: move iwl_set_hw_rfkill_state and mark it static
  iwlwifi: move iwl_is_ht40_tx_allowed out of iwl-core.c
  iwlwifi: move iwl_set_rxon_ht to iwl-agn-rxon.c
  iwlwifi: move iwl_set_rxon_channel to iwl-agn-rxon.c
  iwlwifi: move iwl_set_flags_for_band to iwl-agn-rxon.c
  iwlwifi: move iwl_connection_init_rx_config to iwl-agn-rxon.c
  iwlwifi: move iwl_set_rate to iwl-agn-rxon.c
  iwlwifi: move iwl_chswitch_done to iwl-mac80211.c
  iwlwifi: move iwlagn_fw_error to iwl-agn.c
  iwlwifi: move iwl_set_tx_power and make it static
  iwlwifi: move iwl_send_bt_config and mark it static
  iwlwifi: move iwl_print_rx_config_cmd to iwl-agn-rxon.c
  iwlwifi: move iwl_send_statistics_request to iwl-agn.c
  iwlwifi: move iwl_force_rf_reset to iwl-agn-rx.c
  iwlwifi: move iwl_bcast_addr to iwl-agn-sta.c
  iwlwifi: move utility functions out of iwl-core.h
  iwlwifi: move scan related declarations out of iwl-core.h

Wey-Yi Guy (2):
  iwlwifi: more generic name for bluetooth command
  iwlwifi: change the default P2P support to "Yes"

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/Kconfig           |   29 +-
 drivers/net/wireless/iwlwifi/iwl-agn-devices.c |   74 +++
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |   30 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c      |   12 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c      |   39 ++
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c    |  309 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c     |  146 ++++--
 drivers/net/wireless/iwlwifi/iwl-agn.c         |  126 +++++-
 drivers/net/wireless/iwlwifi/iwl-agn.h         |   59 +++-
 drivers/net/wireless/iwlwifi/iwl-commands.h    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-core.c        |  604 ------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h        |   68 ---
 drivers/net/wireless/iwlwifi/iwl-dev.h         |    2 -
 drivers/net/wireless/iwlwifi/iwl-mac80211.c    |   15 +
 drivers/net/wireless/iwlwifi/iwl-shared.h      |    1 -
 15 files changed, 755 insertions(+), 763 deletions(-)

