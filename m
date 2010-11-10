Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40709 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab0KJSBE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 13:01:04 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/16] update for 2.6.37
Date: Wed, 10 Nov 2010 09:56:34 -0800
Message-Id: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We make the correction for the latest PCI ID used for multiple NICs
We also fix the low tpt problem cause by mac80211 changes
Number of code clean up to separate new agn devices from legacy devices

Johannes Berg (5):
  iwlagn: fix non-5000+ build
  iwlagn: fix needed chains calculation
  iwlagn: fix RXON issues
  iwlagn: re-enable calibration
  iwlagn: fix RXON HT

Shanyu Zhao (2):
  iwlwifi: seperate disconnected antenna function
  iwlwifi: disable disconnected antenna for advanced bt coex

Wey-Yi Guy (8):
  iwlagn: update PCI ID for 6000g2b series devices
  iwlagn: update PCI ID for 6000g2a series devices
  iwlagn: update PCI ID for 100 series devices
  iwlwifi: Legacy isr only used by legacy devices
  iwlwifi: put all the isr related function under ops
  iwlwifi: legacy tx_cmd_protection function
  iwlwifi: resending QoS command when HT changes
  iwlagn: enabel shadow register

Winkler, Tomas (1):
  iwlwlifi: update rx write pointer w/o request mac access in the CAM
    mode

 drivers/net/wireless/iwlwifi/Makefile        |    6 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c      |    8 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c      |    7 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c      |    6 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c      |   16 ++-
 drivers/net/wireless/iwlwifi/iwl-6000.c      |   19 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |  230 ++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |   22 +--
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |  150 ++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c   |   32 ++++-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   80 +++-------
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    5 +-
 drivers/net/wireless/iwlwifi/iwl-core.c      |   94 -----------
 drivers/net/wireless/iwlwifi/iwl-core.h      |   19 ++-
 drivers/net/wireless/iwlwifi/iwl-csr.h       |    2 +
 drivers/net/wireless/iwlwifi/iwl-legacy.c    |  156 ++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-legacy.h    |    5 +
 drivers/net/wireless/iwlwifi/iwl-rx.c        |   47 +++--
 drivers/net/wireless/iwlwifi/iwl-tx.c        |   49 ++++---
 drivers/net/wireless/iwlwifi/iwl3945-base.c  |    2 +-
 20 files changed, 535 insertions(+), 420 deletions(-)

