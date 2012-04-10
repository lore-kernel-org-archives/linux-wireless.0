Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63195 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114Ab2DJAuV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 20:50:21 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/11]  update for 3.5: iwlwifi 2012-04-09
Date: Mon,  9 Apr 2012 17:46:50 -0700
Message-Id: <1334018821-30416-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120410_025038_797788_F3AC4CA6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup and refactor work to prepare our up-coming new architecture.
More cleanup work will come soon

Johannes Berg (11):
  iwlwifi: move rx_page_order into transport
  iwlwifi: remove watchdog debugfs file
  iwlwifi: remove unneeded struct declarations
  iwlwifi: move queue watchdog into transport
  iwlwifi: move hw_params into priv
  iwlwifi: remove ack_check module parameter
  iwlwifi: split force_reset debugfs file
  iwlwifi: move eeprom into priv
  iwlwifi: create device configuration header file
  iwlwifi: introduce device family enum
  iwlwifi: dynamically determine lib_ops

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/Makefile             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c           |  117 +---------
 drivers/net/wireless/iwlwifi/iwl-2000.c           |  120 +---------
 drivers/net/wireless/iwlwifi/iwl-5000.c           |  274 +--------------------
 drivers/net/wireless/iwlwifi/iwl-6000.c           |  229 +-----------------
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c      |   22 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |   66 +-----
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |   56 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |   75 +------
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c        |   12 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |  128 +++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.h            |   15 +-
 drivers/net/wireless/iwlwifi/iwl-config.h         |  227 +++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c           |  139 ++---------
 drivers/net/wireless/iwlwifi/iwl-core.h           |   18 --
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |  107 +++------
 drivers/net/wireless/iwlwifi/iwl-dev.h            |   71 +++++-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c         |  220 +++++++++++------
 drivers/net/wireless/iwlwifi/iwl-eeprom.h         |   14 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       |   10 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c           |    8 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h         |  189 +--------------
 drivers/net/wireless/iwlwifi/iwl-testmode.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |   23 ++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |   16 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   29 ++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |  106 +++++---
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   18 +-
 drivers/net/wireless/iwlwifi/iwl-ucode.c          |   12 +-
 31 files changed, 781 insertions(+), 1554 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-config.h

