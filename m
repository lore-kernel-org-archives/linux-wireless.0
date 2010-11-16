Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56013 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390Ab0KPQGk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:06:40 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/18]  update for 2.6.38
Date: Tue, 16 Nov 2010 08:01:33 -0800
Message-Id: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add more changes to prepare P2P supports
We also add few features/changes to WiFi/BT coex,
such as dynamic aggregation.
For newer devices, we change the default LED mode to On/Off

Johannes Berg (9):
  iwlagn: fix some naming regarding FIFOs
  iwlagn: remove unused variable swq_id
  iwlagn: remove a bogus AGG_OFF check
  iwlwifi: pass txq to wake/stop queue
  iwlwifi: always build swq_id as virtual queue ID
  iwlagn: fix PAN queues
  iwlagn: avoid crash if vif is not assigned
  iwlagn: reprogram AP STA after assoc
  iwlagn: fix PAN slot timing wrt. DTIM

Shanyu Zhao (2):
  iwlagn: update QoS before commit associated RXON
  iwlagn: check change before commit RXON cmd

Wey-Yi Guy (7):
  iwlagn: used frame count info in compressed ba packet
  iwlagn: set dynamic aggregation threshold for BT
  iwlagn: support dynamic aggregation for BT coex
  iwlagn: change default ACK/CTS MASK setting for WiFi/BT coex
  iwlwifi: change default led mode for different devices
  iwlagn: use SKU information in the EEPROM
  iwlwifi: set STATUS_READY before commit_rxon

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-1000.c       |    8 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c       |   13 +--
 drivers/net/wireless/iwlwifi/iwl-5000.c       |   14 ++--
 drivers/net/wireless/iwlwifi/iwl-6000.c       |   37 +++++-----
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |   21 +++++
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c   |    5 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c    |   17 +---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c     |   32 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c   |  103 ++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c     |   77 ++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c  |   65 +++++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn.c        |   11 ++-
 drivers/net/wireless/iwlwifi/iwl-commands.h   |   13 ++-
 drivers/net/wireless/iwlwifi/iwl-core.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h       |    7 ++-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c    |    9 +--
 drivers/net/wireless/iwlwifi/iwl-dev.h        |    3 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h     |   12 +++-
 drivers/net/wireless/iwlwifi/iwl-helpers.h    |   36 ++++-----
 drivers/net/wireless/iwlwifi/iwl-led.c        |   10 ++-
 drivers/net/wireless/iwlwifi/iwl-led.h        |    6 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c        |   51 +++++++++++-
 drivers/net/wireless/iwlwifi/iwl-sta.h        |    1 +
 drivers/net/wireless/iwlwifi/iwl-tx.c         |   11 +--
 drivers/net/wireless/iwlwifi/iwl3945-base.c   |    2 +-
 26 files changed, 345 insertions(+), 225 deletions(-)

