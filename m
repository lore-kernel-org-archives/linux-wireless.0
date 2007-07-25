Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62567 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbXGYI77 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 04:59:59 -0400
Date: Wed, 25 Jul 2007 16:57:54 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Please pull patch-bomb for iwlwifi
Message-ID: <20070725085754.GA670@mail.intel.com>
Reply-To: yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

This patch series catches wireless-dev up to the stand-alone
iwlwifi tree version 0.1.3.

There are totally 117 patches so I won't post them one by one on
the list. Please find the commit series for the changes in the
patch bomb:

    iwlwifi-efe55d8fa702a23724bf44fdd54059f8c4480941.tgz
at
    http://intellinuxwireless.org/iwlwifi/patches/

This is based on wireless-dev commit:

    3382ada69e6796da1675b0c5d064a472e9db2822

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/mac80211/iwlwifi/Makefile     |    2 +-
 drivers/net/wireless/mac80211/iwlwifi/base.c       | 2832 +++++++++++++------
 .../net/wireless/mac80211/iwlwifi/iwl-3945-rs.c    |   22 +-
 drivers/net/wireless/mac80211/iwlwifi/iwl-3945.c   |  488 ++---
 drivers/net/wireless/mac80211/iwlwifi/iwl-3945.h   |    7 +
 .../net/wireless/mac80211/iwlwifi/iwl-4965-hw.h    |  184 +-
 .../net/wireless/mac80211/iwlwifi/iwl-4965-rs.c    |  518 +++--
 .../net/wireless/mac80211/iwlwifi/iwl-4965-rs.h    |   11 +-
 drivers/net/wireless/mac80211/iwlwifi/iwl-4965.c   | 2917 +++++++++++---------
 drivers/net/wireless/mac80211/iwlwifi/iwl-4965.h   |  160 +-
 .../net/wireless/mac80211/iwlwifi/iwl-channel.h    |    8 +-
 .../net/wireless/mac80211/iwlwifi/iwl-commands.h   |   30 +-
 drivers/net/wireless/mac80211/iwlwifi/iwl-debug.h  |    9 +
 .../net/wireless/mac80211/iwlwifi/iwl-helpers.h    |  125 +-
 drivers/net/wireless/mac80211/iwlwifi/iwl-hw.h     |  188 +-
 drivers/net/wireless/mac80211/iwlwifi/iwl-io.h     |    4 +-
 drivers/net/wireless/mac80211/iwlwifi/iwl-priv.h   |   51 +-
 drivers/net/wireless/mac80211/iwlwifi/iwlwifi.h    |  158 +-
 18 files changed, 4650 insertions(+), 3064 deletions(-)

Adel Gadllah (12):
      iwlwifi: remove unneded locking in iwl_nic_start
      iwlwifi: add iwl_ prefix to module param variables
      iwlwifi: move include to top of the file in iwl-helpers.h
      iwlwifi: use pci_iomap rather than ioremap_nocache
      iwlwifi: use mask instead of % in iwl-4965.c
      iwlwifi: replace ieee80211_is_* macros with inline functions
      iwlwifi: remove braces for single line of code
      iwlwifi: replace todoG with TODO
      iwlwifi: add iwl_hw prefix to reg_* functions
      iwlwifi: replace with GLOBAL_ARRAY_SIZE with ARRAY_SIZE
      iwlwifi: many coding style cleanups
      iwlwifi: replace d_ prefix with iwl_mac_ for mac80211 callbacks

Ben M Cahill (14):
      iwlwifi: Stabilize and streamline interrupts
      iwlwifi: Clean up interrupt support for 3945
      iwlwifi: Fix IRQ handle bit checking issue
      iwlwifi: Unify and streamline 3945 and 4965 uCode load and launch
      iwlwifi: Enable full ssi/noise/signal quality reporting to mac80211
      iwlwifi: Refactor sensitivity algorithms
      iwlwifi: Compact debug output for false alarms
      iwlwifi: Don't use sensitivity data for SNR during SCAN
      iwlwifi: Fix bug in iwl4965_sens_energy_cck(), improves performance
      iwlwifi: Fix 4965 A-band scans showing incorrect channels
      iwlwifi: Move iwl_get_antenna_flags() to 3945-specific function
      iwlwifi: Temporary workaround to fix Rx stop issue
      iwlwifi: Restore full operation of the chain_noise algorithm
      iwlwifi: fix driver unusable when loading with HW RFKILL on

Bob Beers (1):
      iwlwifi: Fix iwl4965_kw_init coding style

Charles Gales (1):
      iwlwifi: Fixed some issues while porting to a PowerPC Platform

Christian Hesse (1):
      iwlwifi: Fix compile problem if CONFIG_IWLWIFI_DEBUG is unset

Hong Liu (9):
      iwlwifi: Fix suspend/resume problem
      iwlwifi: rs_rate_scale_perform cleanup
      iwlwifi: add channel switch cmd handling for iwl4965
      iwlwifi: add void channel switch handling function in iwl3945
      iwlwifi: fix firmware error after txpower off->on
      iwlwifi: fix cannot ping AP after rfkill on->off
      iwlwifi: fix firmware error after switch txpower in A band
      iwlwifi: fix iwl_hw_nic_reset in iwl3945
      iwlwifi: fix iwl3945 not usable when loading with hw rfkill on

Ian Schram (4):
      iwlwifi: add 8086:4230 pci id for iwl4965
      iwlwifi: remove grabs restricted access from iwl_verify_bsm
      iwlwifi: remove warning message when loading the module
      iwlwifi: remove useless call for iwl_rx_queue_space

James Ketrenos (2):
      iwlwifi: Fix problem with limited Tx power for iwl3945
      iwlwifi: Fix possible sign/endian problem with voltage compensation

Mohamed Abbas (26):
      iwlwifi: Fix association problem
      iwlwifi: enable/disable sensitivity with CONFIG_IWLWIFI_SENSITIVITY
      iwlwifi: Fix a driver stability issue
      iwlwifi: Fix rate index for 11B
      iwlwifi: Fix compilation when HT is enabled
      iwlwifi: sensitivity calibration from STATISTICS_NOTIFICATION only
      iwlwifi: fix 11n rate scaling and more sinsitivity fixes
      iwlwifi: Fix power management
      iwlwifi: Fix 60M rate problem
      iwlwifi: add 11n modes checkups
      iwlwifi: Fix firmware assert when switch from 11n AP to none
      iwlwifi: switch between antenna's when transmitting management frames
      iwlwifi: Fix beacon interval difference between 3945 and 4965
      iwlwifi: fix sinsitivity error
      iwlwifi: fix rate scaling issues
      iwlwifi: fix scaning while calling config_interface
      iwlwifi: Fix iwl4965 stability issue
      iwlwifi: fix post assoc on 4965
      iwlwifi: fix assert after switching to 2.4 from 5.2 fat channel
      iwlwifi: fix scan problems
      iwlwifi: set ready flag after post assoc
      iwlwifi: QoS support
      iwlwifi: fix add station error on scanning
      iwlwifi: Tx/Rx aggregation support for IEEE 802.11n
      iwlwifi: fix a kernel panic bug during module unload
      iwlwifi: Set RX queue size for 4965 to 256

Ron Rindjunsky (2):
      iwlwifi: fix legacy counter
      iwlwifi: clean fill link quall cmd

Tomas Winkler (31):
      iwlwifi: iwl_full_rxon_required assocation
      iwlwifi: Fix iwl4965 default values for device id 0x4230
      iwlwifi: uCode load endinanity fix
      iwlwifi: Fix endianity issue in loading BSM image
      iwlwifi: Removed todoG comment
      iwlwifi: Endianity fix: skb buffer pointer was swtiched twice
      iwlwifi: Fix edianity tagging for rx bd
      iwlwifi: Fixing iwl4965_tx_queue_set_status endianity issues and collaterals
      iwlwifi: Endianity fix removed iwl4965_sched_queue2ratid
      iwlwifi: Endianity cleaning up iwl4965_tx_queue_agg_enable
      iwlwifi: Fixing aggregation enable locking
      iwlwifi: introducing IWL_DEBUG_LIMIT (net_ratelimit) macro
      iwlwifi: ratio2dB make it static
      iwlwifi: preventing unnecessary SGI to LGI switches
      iwlwifi: Rate scaling debug fixes
      iwlwifi: set HT retry number to 3
      iwlwifi: Enianity fix for Alive command conversion
      iwlwifi: fix no 6/9Mbps rates in TX
      iwlwifi: Rate scaling typo fix
      iwlwifi: Allocate scan buffer only for host command queue
      iwlwifi: Rate scaling peer rates mask checking (legacy rates)
      iwlwifi: iwl4965 kill rate setting in sta host command
      iwlwifi: fixing addsta host command endinianity
      iwlwifi: tx_skb QoS control endianity fix
      iwlwifi: pass BAR to mac80211
      iwlwifi: fix power save for AP mode
      iwlwifi: iwl4965_rx_reply_rx endianity fix
      iwlwifi: fix incorrect debug message
      iwlwifi: fix iwl_mac_ht_tx_agg_stop
      iwlwifi: Fix aggregation disable locking issue
      iwlwifi: rate scaling enabling SGI in MIMO

Yi Zhu (1):
      iwlwifi: remove module param `mode'

Zhu Yi (7):
      iwlwifi: switch to use G mode by default
      iwlwifi: protect rxb->list by spinlock
      iwlwifi: fix gcc warning for printf resource_size_t
      iwlwifi: switch channel only if IEEE80211_CONF_CHANNEL_SWITCH is defined
      iwlwifi: workaround firmware STATISTICS_NOTIFICATION cmd bug
      iwlwifi: remove unused function iwl_hw_tx_queue_alloc
      iwlwifi: update driver version to 0.1.3

mabbas (6):
      iwlwifi: Read FAT channel information from eeprom
      iwlwifi: fix sensitivity calibration
      iwlwifi: initialize post assoction data
      iwlwifi: fix post association for 4965
      iwlwifi: fix post association for 3945
      iwlwifi: IBSS connection fix
