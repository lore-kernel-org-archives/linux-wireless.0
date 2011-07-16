Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16181 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755380Ab1GPPcA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 11:32:00 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/18] update for 3.1
Date: Sat, 16 Jul 2011 07:56:20 -0700
Message-Id: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110716_173214_222959_3B8C24B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are moving both tx and rx to transport layer. The work will continue
until the pci-e transport layer is fully separated.
We still adding more changes to make the code better after driver split

Emmanuel Grumbach (10):
  iwlagn: move Tx datapath to transport layer
  iwlagn: move the tasklet / irq to the transport layer
  iwlagn: move sync_irq to transport layer
  iwlagn: move the Rx dispatching to the upper layer
  iwlagn: add comment to tx and get_tx_cmd in iwl_trans_ops
  iwlagn: move rx transport functions to iwl-trans-rx-pcie.c
  iwlagn: move tx transport functions to iwl-trans-tx-pcie.c
  iwlagn: move iwlagn_stop_device to transport layer
  iwlagn: move all the ICT related functions to iwl-trans-rx-pcie.c
  iwlagn: add tx start API to transport layer

Fry, Donald H (1):
  iwlagn: remove indirection for iwlagn_hw_valid_rtc_data_addr

Hsu, Kenny (1):
  iwlagn: set default of uCode ownership to driver

Johannes Berg (1):
  iwlagn: simplify TX flags assignments

Wey-Yi Guy (5):
  iwlagn: remove un-necessary file
  iwlagn: remove dual-indirect call to simply the code
  iwlagn: another double indirect removed
  iwlagn: comments for iwl_cfg
  iwlagn: calibration bitmap

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/Makefile             |    8 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c           |    9 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c           |   28 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c           |   16 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c           |   50 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c      |   59 ++
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c       |  210 -----
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c        |  306 -------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |  269 +------
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |   93 ++
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |  227 +----
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c      |  138 +---
 drivers/net/wireless/iwlwifi/iwl-agn.c            |  469 +---------
 drivers/net/wireless/iwlwifi/iwl-agn.h            |   41 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h       |   19 +-
 drivers/net/wireless/iwlwifi/iwl-core.h           |   51 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |   26 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c         |   10 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c           |  271 ------
 drivers/net/wireless/iwlwifi/iwl-prph.h           |   82 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c             |  188 +---
 drivers/net/wireless/iwlwifi/iwl-sv-open.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |   72 ++
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c  |  979 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |  808 +++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.c          |  451 ++++++++++-
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   43 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c             |  576 ------------
 28 files changed, 2756 insertions(+), 2745 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-ict.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-hcmd.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-tx.c

