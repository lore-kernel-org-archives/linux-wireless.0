Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10956 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab2BQUXr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:47 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/26] update for 3.4: iwlwifi 2012-02-17
Date: Fri, 17 Feb 2012 11:13:28 -0800
Message-Id: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212351_792910_6CD3B8F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We continue the refactor works on the driver architecture, there are a lot of
codes being move around, but it is very important works to support the next generation of our WiFi devices
We make few improvements on both driver debugging and testmode operations
We also fix an issue on 5.2 band association with the newer firmware

Amit Beka (4):
  iwlwifi: testmode new indirect RW API
  iwlwifi: added reply data to testmode HCMD send
  iwlwifi: fixes to testmode indirect access
  iwlwifi: send testmode hcmd reply with rx header

Don Fry (10):
  iwlwifi: create iwl_nic structure
  iwlwifi: move ucode_ver to iwl_nic
  iwlwifi: move fw_index from iwl_priv to iwl_nic
  iwlwifi: move firmware_name to iwl_nic
  iwlwifi: move firmware_loading_complete to iwl_nic
  iwlwifi: Move ucode pointers to iwl_fw
  iwlwifi: change args to ucode routines
  iwlwifi: move event and err pointers to iwl_nic
  iwlwifi: changes args to iwl_nic for firmware operations
  iwlwifi: save ucode capabilities in iwl_fw

Emmanuel Grumbach (6):
  iwlwifi: kill iwl_down and s/__iwl_down/iwl_down
  iwlwifi: iwl_set_hw_params returns always 0
  iwlwifi: use enhance_sensitivity from iwl_fw
  iwlwifi: document the transport layer
  iwlwifi: the transport knows its state
  iwlwifi: SRAM size moves from hw_params to cfg

Johannes Berg (3):
  iwlwifi: trace debug messages
  iwlwifi: move workqueue to priv
  iwlwifi: give PCIe its own lock

Meenakshi Venkataraman (1):
  iwlwifi: enable receiving beacons when not associated

Wey-Yi Guy (2):
  iwlwifi: log as error when error detected
  iwlwifi: remove un-necessary return

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/Makefile             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c           |   10 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c           |   14 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c           |   18 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c           |   17 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c      |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |   16 +
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c         |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   53 +--
 drivers/net/wireless/iwlwifi/iwl-agn.h            |   10 +-
 drivers/net/wireless/iwlwifi/iwl-core.c           |    7 +-
 drivers/net/wireless/iwlwifi/iwl-core.h           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debug.c          |  127 +++++++
 drivers/net/wireless/iwlwifi/iwl-debug.h          |   83 +++--
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |   11 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |   21 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h       |   65 ++++
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       |   20 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c            |   18 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c           |   10 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h         |   13 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.c       |  411 ++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-testmode.h       |   64 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |   70 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   39 ++-
 drivers/net/wireless/iwlwifi/iwl-trans.h          |  190 ++++++++--
 drivers/net/wireless/iwlwifi/iwl-ucode.c          |  321 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-ucode.h          |   47 +++-
 drivers/net/wireless/iwlwifi/iwl-wifi.h           |   33 ++
 35 files changed, 1112 insertions(+), 611 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-debug.c

