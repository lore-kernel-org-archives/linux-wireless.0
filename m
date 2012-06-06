Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46907 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab2FFN1v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:27:51 -0400
Message-ID: <1338989268.26346.7.camel@jlt3.sipsolutions.net> (sfid-20120606_152755_189002_11E6AA00)
Subject: [PATCH 00/29] iwlwifi updates for 3.6
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 06 Jun 2012 15:27:48 +0200
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152231_979720_A2082B64)
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120606_152231_979720_A2082B64)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

The following changes since commit fdbfff73408f99799724f583cbc2a0ce3263c6a7:

  net/wireless: ipw2200: introduce ipw_read_eeprom function (2012-06-05 17:15:49 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john

for you to fetch changes up to b1abedada3fd0aa100723aa9b60b7e31c17945cb:

  iwlwifi: remove extern opmode ops declarations (2012-06-06 13:26:00 +0200)



Unfortunately, conflict resolution between this and wireless.git is
tricky -- not the conflicts, but what doesn't conflict:
	.eeprom_params = &iwl6000_eeprom_params,
needs to be added to IWL_DEVICE_6035 in pcie/6000.c. How do you want to
handle that?

I could re-request the pull after merging in wireless, but then you'd
have to merge wireless into wireless-next first too.

johannes


----------------------------------------------------------------
Emmanuel Grumbach (9):
      iwlwifi: SCD_INT_MSK is obsolete - don't update it
      iwlwifi: first config the SCD queues, then activate them
      iwlwifi: use iwl_trans_set_wr_ptrs to init the queues
      iwlwifi: s/txq_agg_disable/txq_disable
      iwlwifi: s/txq_setup/txq_enable
      iwlwifi: update mask value for SCD queue config
      iwlwifi: allocate Tx cmd pool per device
      iwlwifi: fix rf configuration
      iwlwifi: configure the SKU in the HW

Ilan Peer (3):
      iwlwifi: Check BSS ctx active before call mac80211
      iwlwifi: handle race condition in ROC flow
      iwlwifi: clear STATUS_SCAN_HW when PAN_PARAMS fails

Johannes Berg (16):
      iwlwifi: make a lot of functions static
      iwlwifi: use mac80211 channel in connection init
      iwlwifi: trust mac80211 channel setting
      iwlwifi: use mac80211 channels for reset scan
      iwlwifi: use mac80211 channel for radar check
      iwlwifi: give HT format to mac80211/radiotap
      iwlwifi: move PCIe into subdirectory
      iwlwifi: trust mac80211 HT40 setting
      iwlwifi: move DVM code into subdirectory
      iwlwifi: unify tx_chains_num setting
      iwlwifi: move ht40 bitmap into config
      iwlwifi: add iwl_set_bits_mask
      iwlwifi: refactor EEPROM reading/parsing
      iwlwifi: configure PHY version for 1000 series
      iwlwifi: move RF config into NIC config
      iwlwifi: remove extern opmode ops declarations

Paul Bolle (1):
      iwlwifi: fix typo 'IWL_WATCHHDOG_DISABLED'

 drivers/net/wireless/iwlwifi/Makefile              |   26 +-
 drivers/net/wireless/iwlwifi/dvm/Makefile          |   13 +
 .../net/wireless/iwlwifi/{iwl-agn.h => dvm/agn.h}  |   94 +-
 .../iwlwifi/{iwl-agn-calib.c => dvm/calib.c}       |   24 +-
 .../iwlwifi/{iwl-agn-calib.h => dvm/calib.h}       |    4 +-
 .../iwlwifi/{iwl-commands.h => dvm/commands.h}     |    4 +-
 .../iwlwifi/{iwl-debugfs.c => dvm/debugfs.c}       |   31 +-
 .../net/wireless/iwlwifi/{iwl-dev.h => dvm/dev.h}  |  148 +--
 .../iwlwifi/{iwl-agn-devices.c => dvm/devices.c}   |  178 +--
 .../net/wireless/iwlwifi/{iwl-led.c => dvm/led.c}  |    5 +-
 .../net/wireless/iwlwifi/{iwl-led.h => dvm/led.h}  |    0
 .../wireless/iwlwifi/{iwl-agn-lib.c => dvm/lib.c}  |   18 +-
 .../iwlwifi/{iwl-mac80211.c => dvm/mac80211.c}     |  133 ++-
 .../net/wireless/iwlwifi/{iwl-agn.c => dvm/main.c} |  408 +++----
 .../wireless/iwlwifi/{iwl-power.c => dvm/power.c}  |   11 +-
 .../wireless/iwlwifi/{iwl-power.h => dvm/power.h}  |    2 +-
 .../wireless/iwlwifi/{iwl-agn-rs.c => dvm/rs.c}    |   50 +-
 .../wireless/iwlwifi/{iwl-agn-rs.h => dvm/rs.h}    |    3 +-
 .../wireless/iwlwifi/{iwl-agn-rx.c => dvm/rx.c}    |   10 +-
 .../iwlwifi/{iwl-agn-rxon.c => dvm/rxon.c}         |   52 +-
 .../wireless/iwlwifi/{iwl-scan.c => dvm/scan.c}    |  111 +-
 .../wireless/iwlwifi/{iwl-agn-sta.c => dvm/sta.c}  |   59 +-
 .../iwlwifi/{iwl-testmode.c => dvm/testmode.c}     |   21 +-
 .../iwlwifi/{iwl-testmode.h => dvm/testmode.h}     |    0
 .../wireless/iwlwifi/{iwl-agn-tt.c => dvm/tt.c}    |   13 +-
 .../wireless/iwlwifi/{iwl-agn-tt.h => dvm/tt.h}    |    2 +-
 .../wireless/iwlwifi/{iwl-agn-tx.c => dvm/tx.c}    |   58 +-
 .../wireless/iwlwifi/{iwl-ucode.c => dvm/ucode.c}  |   34 +-
 drivers/net/wireless/iwlwifi/iwl-config.h          |   26 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h             |   28 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h           |    5 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h        |    1 +
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c    |  900 +++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h    |  138 +++
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.c     |  463 ++++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.h     |   70 ++
 drivers/net/wireless/iwlwifi/iwl-eeprom.c          | 1148 --------------------
 drivers/net/wireless/iwlwifi/iwl-eeprom.h          |  269 -----
 drivers/net/wireless/iwlwifi/iwl-io.c              |   18 +
 drivers/net/wireless/iwlwifi/iwl-io.h              |    2 +
 drivers/net/wireless/iwlwifi/iwl-op-mode.h         |    5 -
 drivers/net/wireless/iwlwifi/iwl-prph.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h           |   51 +-
 .../wireless/iwlwifi/{iwl-1000.c => pcie/1000.c}   |   19 +-
 .../wireless/iwlwifi/{iwl-2000.c => pcie/2000.c}   |   22 +-
 .../wireless/iwlwifi/{iwl-5000.c => pcie/5000.c}   |   20 +-
 .../wireless/iwlwifi/{iwl-6000.c => pcie/6000.c}   |   24 +-
 .../net/wireless/iwlwifi/{iwl-cfg.h => pcie/cfg.h} |    0
 .../net/wireless/iwlwifi/{iwl-pci.c => pcie/drv.c} |    5 +-
 .../{iwl-trans-pcie-int.h => pcie/internal.h}      |    9 +-
 .../iwlwifi/{iwl-trans-pcie-rx.c => pcie/rx.c}     |    2 +-
 .../iwlwifi/{iwl-trans-pcie.c => pcie/trans.c}     |   89 +-
 .../iwlwifi/{iwl-trans-pcie-tx.c => pcie/tx.c}     |   54 +-
 53 files changed, 2329 insertions(+), 2553 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/dvm/Makefile
 rename drivers/net/wireless/iwlwifi/{iwl-agn.h => dvm/agn.h} (81%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-calib.c => dvm/calib.c} (98%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-calib.h => dvm/calib.h} (98%)
 rename drivers/net/wireless/iwlwifi/{iwl-commands.h => dvm/commands.h} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-debugfs.c => dvm/debugfs.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-dev.h => dvm/dev.h} (84%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-devices.c => dvm/devices.c} (78%)
 rename drivers/net/wireless/iwlwifi/{iwl-led.c => dvm/led.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-led.h => dvm/led.h} (100%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-lib.c => dvm/lib.c} (98%)
 rename drivers/net/wireless/iwlwifi/{iwl-mac80211.c => dvm/mac80211.c} (93%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn.c => dvm/main.c} (87%)
 rename drivers/net/wireless/iwlwifi/{iwl-power.c => dvm/power.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-power.h => dvm/power.h} (98%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-rs.c => dvm/rs.c} (98%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-rs.h => dvm/rs.h} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-rx.c => dvm/rx.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-rxon.c => dvm/rxon.c} (97%)
 rename drivers/net/wireless/iwlwifi/{iwl-scan.c => dvm/scan.c} (94%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-sta.c => dvm/sta.c} (97%)
 rename drivers/net/wireless/iwlwifi/{iwl-testmode.c => dvm/testmode.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-testmode.h => dvm/testmode.h} (100%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-tt.c => dvm/tt.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-tt.h => dvm/tt.h} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-tx.c => dvm/tx.c} (96%)
 rename drivers/net/wireless/iwlwifi/{iwl-ucode.c => dvm/ucode.c} (93%)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-eeprom-read.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-eeprom-read.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-eeprom.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-eeprom.h
 rename drivers/net/wireless/iwlwifi/{iwl-1000.c => pcie/1000.c} (89%)
 rename drivers/net/wireless/iwlwifi/{iwl-2000.c => pcie/2000.c} (92%)
 rename drivers/net/wireless/iwlwifi/{iwl-5000.c => pcie/5000.c} (90%)
 rename drivers/net/wireless/iwlwifi/{iwl-6000.c => pcie/6000.c} (93%)
 rename drivers/net/wireless/iwlwifi/{iwl-cfg.h => pcie/cfg.h} (100%)
 rename drivers/net/wireless/iwlwifi/{iwl-pci.c => pcie/drv.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-trans-pcie-int.h => pcie/internal.h} (97%)
 rename drivers/net/wireless/iwlwifi/{iwl-trans-pcie-rx.c => pcie/rx.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-trans-pcie.c => pcie/trans.c} (97%)
 rename drivers/net/wireless/iwlwifi/{iwl-trans-pcie-tx.c => pcie/tx.c} (95%)


