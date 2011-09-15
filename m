Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38702 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934522Ab1IOTcE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:04 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/27] update for 3.2
Date: Thu, 15 Sep 2011 11:46:27 -0700
Message-Id: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213328_352099_EA9DC837)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We adding more documents for the transport layer work
We continue the transport layer work to make it better and cleaner
We also continue doing the cleanup work after driver split

Don Fry (1):
  iwlagn: replace beacon_time_fsf_bits variable with #define

Emmanuel Grumbach (9):
  iwlagn: warn about buggy fw that doesn't set SEQ_RX_FRAME
  iwlagn: unmap cmd queue's tfds as BIDI
  iwlagn: free the Tx cmd when a non empty Tx queue is freed
  iwlagn: move iwl_stop / wake_queue to the upper layer
  iwlagn: use enum iwl_rxon_context_id instead of u8
  iwlagn: document the bus layer API
  iwlagn: add documentation to the transport layer
  iwlagn: beautify the code - remove uneeded line break
  iwlagn: provide data after WARN_ON

Fry, Donald H (2):
  iwlagn: fix modinfo display for 135 ucode.
  iwlagn: simplify chain_noise_num_beacons indirection

Johannes Berg (9):
  iwlagn: move PCI-E transport files
  iwlagn: generically provide iwl_trans_send_cmd_pdu
  iwlagn: Makefile whitespace cleanup
  iwlagn: clean up PM code
  iwlagn: rename iwl-pci.h to iwl-cfg.h
  iwlagn: remove unused function declarations
  iwlagn: move sysfs files to debugfs
  iwlagn: remove drvdata support from bus layer
  iwlagn: do not use interruptible waits

Wey-Yi Guy (6):
  iwlagn: New SKU for 6005 SFF
  iwlagn: merge eeprom access into single file
  iwlagn: add support for v2 of temperature offset calibration
  iwlagn: use iwl_eeprom_calib_hdr structure
  iwlagn: fix stack corruption for temperature offset v2
  iwlagn: signedness bug

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

Because the file system problem, all the patches are not push into 
git.kernel.org yet. I will push as soon as the file system issue addressed

 drivers/net/wireless/iwlwifi/Makefile             |   23 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c           |    5 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c           |   12 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h        |    4 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c           |    7 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c           |    7 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c      |   21 +-
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c     |  299 ---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c      |   55 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |  148 +--
 drivers/net/wireless/iwlwifi/iwl-bus.h            |   72 +-
 drivers/net/wireless/iwlwifi/iwl-cfg.h            |  115 ++
 drivers/net/wireless/iwlwifi/iwl-commands.h       |    8 +
 drivers/net/wireless/iwlwifi/iwl-core.c           |   53 +-
 drivers/net/wireless/iwlwifi/iwl-core.h           |    3 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |   72 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    2 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c         |  239 +++-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h         |   10 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c            |   22 +-
 drivers/net/wireless/iwlwifi/iwl-pci.h            |  116 --
 drivers/net/wireless/iwlwifi/iwl-rx.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h         |  140 +-
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |  454 -----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |  448 +++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  | 1424 +++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  | 1153 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     | 1988 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c  | 1412 ---------------
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  | 1158 ------------
 drivers/net/wireless/iwlwifi/iwl-trans.c          | 1926 +--------------------
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   27 +-
 35 files changed, 5762 insertions(+), 5675 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-cfg.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-pci.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c

