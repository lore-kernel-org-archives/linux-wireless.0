Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:62414 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab1D3Qko (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 12:40:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/14]  update for 2.6.40
Date: Sat, 30 Apr 2011 09:17:26 -0700
Message-Id: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110430_184047_427637_26ECDEFB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We refactor the firmware reload procedure 
We continue to clean up the _agn driver after driver split

Don Fry (2):
  iwlagn: mod param cleanup
  iwlagn: semaphore and calib cleanup

Johannes Berg (7):
  iwlagn: avoid hangs when restarting device
  iwlagn: introduce silent grabbing of NIC access
  iwlagn: refactor restart
  iwlagn: use proper good CRC threshold behaviour
  iwlagn: remove spectrum measurement header
  iwlagn: improve RXON checking
  iwlagn: prefer BSS context

Wey-Yi Guy (5):
  iwlagn: make rxon_assoc static function
  iwlagn: remove 5000 from rxon_assoc structure
  iwlagn: connect and disconnect sequence for RXON
  iwlagn: new 105 series device
  iwlagn: remove un-necessary debugfs callback

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/Makefile          |    1 -
 drivers/net/wireless/iwlwifi/iwl-1000.c        |   19 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c        |   79 +--
 drivers/net/wireless/iwlwifi/iwl-5000.c        |   36 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c        |   37 +-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c | 1025 ------------------------
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h |   70 --
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c  |   41 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c    |   50 --
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |   35 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c    |  246 ++++--
 drivers/net/wireless/iwlwifi/iwl-agn.c         |  107 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.h         |   12 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c        |   63 +-
 drivers/net/wireless/iwlwifi/iwl-core.h        |   23 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     | 1006 ++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h         |    7 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c      |   43 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h      |    3 -
 drivers/net/wireless/iwlwifi/iwl-io.c          |   18 +-
 drivers/net/wireless/iwlwifi/iwl-io.h          |    1 +
 drivers/net/wireless/iwlwifi/iwl-rx.c          |    7 +-
 drivers/net/wireless/iwlwifi/iwl-spectrum.h    |   92 ---
 24 files changed, 1380 insertions(+), 1643 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-spectrum.h

