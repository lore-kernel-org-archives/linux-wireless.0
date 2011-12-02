Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13138 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757227Ab1LBRqP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 12:46:15 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/16] update for 3.3
Date: Fri,  2 Dec 2011 08:48:24 -0800
Message-Id: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111202_184619_143392_8A81EF22)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add few more commands in testmode operations
We make more codes re-arrangement to prepare for the driver partition works
We also remove some un-necessary stuffs and make the code easier to read.

Don Fry (4):
  iwlwifi: rename iwl-agn-ucode as iwl-ucode
  iwlwifi: replace iwl_priv reference with iwl_trans for ucode.
  iwlwifi: move ucode_type from iwl_priv to iwl_shared
  iwlwifi: move ucode notification from iwl_priv to iwl_shared

Hsu, Kenny (3):
  iwlwifi: add tm commands for sram reading by dumpit
  iwlwifi: add generic chunk size of tm dumpit packet
  iwlwifi: add WOWLAN uCode loading support by testmode

Johannes Berg (5):
  iwlagn: fix HW crypto for TX-only keys
  iwlagn: remove TX_REPLY_LIMIT debug
  iwlagn: remove HC_DUMP debug
  iwlagn: remove MACDUMP debug
  iwlagn: make debug levels more readable

Kenny Hsu (1):
  iwlwifi: add range checking in tm sram read command

Wey-Yi Guy (3):
  iwlwifi: do not re-configure HT40 after associated
  iwlwifi: declare static for iwl_sram_cleanup function
  iwlwifi: Rename file name from iwl-sv-open.c to iwl-testmode.c

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/Makefile            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |   51 --
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c        |   16 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c      |   42 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c       |    5 -
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c     |  688 ----------------
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h           |   22 +-
 drivers/net/wireless/iwlwifi/iwl-core.c          |   15 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h         |   62 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |    7 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h           |   41 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c      |   33 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h        |   76 ++
 drivers/net/wireless/iwlwifi/iwl-sv-open.c       |  779 ------------------
 drivers/net/wireless/iwlwifi/iwl-testmode.c      |  925 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-testmode.h      |   34 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |   10 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h         |    7 -
 drivers/net/wireless/iwlwifi/iwl-ucode.c         |  755 ++++++++++++++++++
 20 files changed, 1888 insertions(+), 1690 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-sv-open.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-testmode.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-ucode.c

