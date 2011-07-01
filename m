Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62949 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab1GAPxC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 11:53:02 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/11] update for 3.1
Date: Fri,  1 Jul 2011 08:19:54 -0700
Message-Id: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110701_175309_111414_BAE925A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We start the work on separate out transport layer into it own file(s)
We also fix the mistake in uCode naming for 135 series, and continuous
code cleanup work

Emmanuel Grumbach (4):
  iwlagn: introduce transport layer and implement rx_init
  iwlagn: add rx_free to transport layer
  iwlagn: move the tx allocation funcs to the transport layer
  iwlagn: remove the indirection for the rx write pointer

Johannes Berg (1):
  iwlagn: verify mutex held for sync commands

Wey-Yi Guy (6):
  iwlagn: re-define the testmode cmd and attr enum
  iwlagn: add correct firmware name for 135 series
  iwlagn: add module parameter to disable stuck queue watchdog timer
  iwlagn: scd memory boundary
  iwlagn: call bt_coex directlly
  iwlagn: remove hcmd ops

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/Makefile        |    1 +
 drivers/net/wireless/iwlwifi/iwl-1000.c      |    2 -
 drivers/net/wireless/iwlwifi/iwl-2000.c      |   21 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c      |    4 -
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    5 -
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c  |   16 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |   88 +-----
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |   19 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |   90 ------
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   54 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    5 +-
 drivers/net/wireless/iwlwifi/iwl-core.c      |   22 +--
 drivers/net/wireless/iwlwifi/iwl-core.h      |   18 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h       |   22 ++-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c      |   13 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c       |    1 +
 drivers/net/wireless/iwlwifi/iwl-prph.h      |   19 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c        |   47 +---
 drivers/net/wireless/iwlwifi/iwl-testmode.h  |  236 ++++++++-------
 drivers/net/wireless/iwlwifi/iwl-trans.c     |  423 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.h     |   64 ++++
 drivers/net/wireless/iwlwifi/iwl-tx.c        |  139 +---------
 23 files changed, 725 insertions(+), 592 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans.h

