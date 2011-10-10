Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54032 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab1JJPQZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:25 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/34] update for 3.2
Date: Mon, 10 Oct 2011 07:26:45 -0700
Message-Id: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171628_908764_98F2D502)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We address the performance issue cause by earlier path which disable too many calibration.
We include few more bugs fix and enhancement patches for WoWLAN operations
We continue remove un-needed code and clean up after driver split
We also include new SKUs for both 6005 and 105 series of devices

Don Fry (1):
  iwlagn: eliminate bus pointer from iwl_priv structure

Emmanuel Grumbach (7):
  iwlagn: kill hw_params.max_stations
  iwlagn: fix a race in the unmapping of the TFDs
  iwlagn: warn only once if AGG state is wrong
  iwlagn: move iwl_beacon_time_mask_XXX near to usage
  iwlagn: move iwl_enable_rfkill_int and kill iwl-helpers.h
  iwlagn: remove uneeded include to iwl-dev.h
  iwlagn: add missing include to iwl-agn-rs.h

Johannes Berg (6):
  iwlagn: update beacon smarter
  iwlagn: don't assign seqno to QoS Null frames
  iwlagn: send simple LQ command for WoWLAN
  iwlagn: stop interrupts when suspending
  iwlagn: remove 5000 hw header
  iwlagn: remove 6000 hw header

Wey-Yi Guy (20):
  iwlagn: add cmd queue pointer info when timeout
  iwlagn: add REPLY_ECHO host command
  iwlagn: add WARN if tx cmd complete come back late
  iwlagn: add "echo" test when command queue stuck
  iwlagn: check rf kill in queue stuck
  iwlagn: add "echo test" command to debugfs
  iwlagn: remove un-necessary step
  iwlagn: set rts retry limit
  iwlagn: add "_d" sku to 6005 series of devices
  iwlagn: Add "_d" sku to 105 series of devices
  iwlagn: separate init calib and rt calib
  iwlagn: do nothing when disable agg in wrong state
  iwlagn: use low retry limit for WoWLAN
  iwlwifi: update comments on how to enable debug flag
  iwlagn: more info on warning for shutdown agg queue
  iwlagn: don't stop rts/cts until last aggregation queue close
  iwlagn: add debug for mac80211 callback
  iwlagn: rename all the mac80211 callback functions
  iwlagn: merge station management functions
  iwlagn: rename iwl-rx.c to iwl-agn-rx.c

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

Because the file system problem, all the patches are not push into 
git.kernel.org yet. I will push as soon as the file system issue addressed


 drivers/net/wireless/iwlwifi/Kconfig             |    4 +-
 drivers/net/wireless/iwlwifi/Makefile            |    3 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c          |    3 -
 drivers/net/wireless/iwlwifi/iwl-2000.c          |   10 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h       |   88 --
 drivers/net/wireless/iwlwifi/iwl-5000.c          |   22 +-
 drivers/net/wireless/iwlwifi/iwl-6000-hw.h       |   81 --
 drivers/net/wireless/iwlwifi/iwl-6000.c          |   12 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h        |   15 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |    2 -
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c        |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h        |    4 +
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c        | 1143 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c      |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c       |  861 ++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c        |   32 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn.c           |  126 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.h           |  131 +++-
 drivers/net/wireless/iwlwifi/iwl-cfg.h           |    2 +
 drivers/net/wireless/iwlwifi/iwl-commands.h      |   11 +
 drivers/net/wireless/iwlwifi/iwl-core.c          |   83 ++-
 drivers/net/wireless/iwlwifi/iwl-core.h          |   20 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h         |    8 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |   22 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h           |    3 -
 drivers/net/wireless/iwlwifi/iwl-helpers.h       |   72 --
 drivers/net/wireless/iwlwifi/iwl-led.c           |    3 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c           |    2 +
 drivers/net/wireless/iwlwifi/iwl-power.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c            | 1141 ---------------------
 drivers/net/wireless/iwlwifi/iwl-scan.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    2 -
 drivers/net/wireless/iwlwifi/iwl-sta.c           |  835 ----------------
 drivers/net/wireless/iwlwifi/iwl-sta.h           |  141 ---
 drivers/net/wireless/iwlwifi/iwl-sv-open.c       |    8 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |   23 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |   21 +-
 39 files changed, 2422 insertions(+), 2530 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-5000-hw.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-6000-hw.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-rx.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-helpers.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-rx.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-sta.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-sta.h

