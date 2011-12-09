Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:23204 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab1LIBY6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 20:24:58 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/15] update for 3.3: iwlwifi 2011-12-08
Date: Thu,  8 Dec 2011 16:26:07 -0800
Message-Id: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111209_022517_518089_1F08176C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We disable P2P by default, P2P feature still under development and it is 
not 100% stable yet. If anyone interest and want to use it, it is always
can be enable through .config
We also include number of enhancements for testmode operation, the testmode
will be used by iwlwifi for validation and debugging
Also more works for the driver partition being added here.

Don Fry (3):
  iwlwifi: move eeprom pointer from iwl_priv to iwl_shared
  iwlwifi: move device_pointers from iwl_priv to iwl_shared
  iwlwifi: move calib_results list from iwl_priv to iwl_trans

Hsu, Kenny (3):
  iwlwifi: add uCode version information support by testmode
  iwlwifi: hide kernel option IWLWIFI_DEVICE_SVTOOL
  iwlwifi: add device ID information support by testmode

Johannes Berg (3):
  iwlagn: fix TID use bug
  iwlagn: use IWL_MAX_TID_COUNT for WoWLAN
  iwlagn: use IWL_MAX_TID_COUNT instead of TID_MAX_LOAD_COUNT

Wey-Yi Guy (6):
  iwlwifi: Display more uCode debug info
  iwlwifi: minor cleanup
  iwlwifi: remove reference to legacy devices
  iwlwifi: rename CONFIG_IWLWIFI_DEVICE_SVTOOL to
    CONFIG_IWLWIFI_DEVICE_TESTMODE
  iwlwifi: P2P is not enabled by default
  iwlwifi: set TX_CMD_FLG_STA_RATE_MSK for BAR frame

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/Kconfig             |   30 ++++++--
 drivers/net/wireless/iwlwifi/Makefile            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c          |    8 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c     |   18 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h     |    5 --
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |   34 +++++-----
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c        |   16 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h        |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c        |    5 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c           |   27 +++++---
 drivers/net/wireless/iwlwifi/iwl-agn.h           |    6 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h      |   84 +++++++--------------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h           |   30 +-------
 drivers/net/wireless/iwlwifi/iwl-eeprom.c        |   60 ++++++++-------
 drivers/net/wireless/iwlwifi/iwl-eeprom.h        |    7 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h        |   15 ++++-
 drivers/net/wireless/iwlwifi/iwl-testmode.c      |   49 ++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-testmode.h      |   18 ++++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |   21 +++++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans.h         |   18 +++++
 drivers/net/wireless/iwlwifi/iwl-ucode.c         |   32 +++++----
 27 files changed, 292 insertions(+), 213 deletions(-)

