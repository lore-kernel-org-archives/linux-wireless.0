Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25118 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515Ab0GWQNz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 12:13:55 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/10] iwlwifi update for 2.6.36
Date: Fri, 23 Jul 2010 09:15:29 -0700
Message-Id: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add statistics notification support for WiFi/BT combo devices.
We also add the capability to read multiple MAC address from EEPROM and
advertise them to cfg80211.
We also fix the gcc complains about the firmware loading on parsing TLV.

Johannes Berg (4):
  iwlagn: fix firmware loading TLV error path
  iwlwifi: make iwl_mac_beacon_update static
  iwlwifi: reduce beacon fill conditions
  iwlwifi: remove spurious semicolons

Wey-Yi Guy (6):
  iwlagn: add statistic notification structure for WiFi/BT devices
  iwlagn: add .cfg flag to idenfity the need for bt statistics
  iwlagn: Add support for bluetooth statistics notification
  iwlagn: add bluetooth stats to debugfs
  iwlwifi: add TLV to specify the size of phy calibration table
  iwlwifi: read multiple MAC addresses

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-1000.c        |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.c        |    5 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c        |    3 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c        |    7 +
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c   |   64 +++++--
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |  225 +++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h |    7 +
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c      |  167 ++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-agn.c         |  130 +++++++++------
 drivers/net/wireless/iwlwifi/iwl-calib.h       |    6 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h    |   55 ++++++-
 drivers/net/wireless/iwlwifi/iwl-core.c        |   63 ++++----
 drivers/net/wireless/iwlwifi/iwl-core.h        |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |   13 ++
 drivers/net/wireless/iwlwifi/iwl-dev.h         |   16 ++
 drivers/net/wireless/iwlwifi/iwl-eeprom.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c    |    4 +-
 19 files changed, 561 insertions(+), 216 deletions(-)

