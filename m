Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45464 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757846Ab1FKOzh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 10:55:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/18]  update for 3.1
Date: Sat, 11 Jun 2011 07:25:34 -0700
Message-Id: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110611_165546_827426_08226C95)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is another batch of cleanup works for iwlagn driver
We also add testmode dumpit support in iwlagn

Johannes Berg (1):
  iwlagn: don't check ucode subtype

Wey-Yi Guy (17):
  iwlagn: usersapce application decide the size of trace buffer
  iwlagn: add dumpit support for testmode trace function
  iwlagn: move bt_coex_active as part of iwlagn_mod_params
  iwlagn: move led_mode as part of iwlagn_mod_params
  iwlagn: move no_sleep_autoadjust as part of iwlagn_mod_params
  iwlagn: Band capabilities in EEPROM
  iwlagn: use sku capabilities information from EEPROM
  iwlagn: add coex debug flag
  iwlagn: add debug message for coex related activities
  iwlagn: use IWL_DEBUG_TEMP for temperature related debug
  iwlagn: use IWL_DEBUG_FW for firmware related debug msg
  iwlagn: remove unused debug flag
  iwlagn: generic temperature location in EEPROM
  iwlagn: group similar defines together
  iwlagn: merge duplicated code into single place
  iwlagn: Sanity check for 11n capability
  iwlagn: Sanity check for valid context

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-5000-hw.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |   14 +--
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c   |   12 +--
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c    |   40 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c     |   38 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c  |   45 +++------
 drivers/net/wireless/iwlwifi/iwl-agn.c        |  112 ++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn.h        |   20 ++++-
 drivers/net/wireless/iwlwifi/iwl-commands.h   |   12 --
 drivers/net/wireless/iwlwifi/iwl-core.c       |   31 +-----
 drivers/net/wireless/iwlwifi/iwl-core.h       |   10 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h      |   10 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h        |   12 ++-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h     |   22 ++--
 drivers/net/wireless/iwlwifi/iwl-led.c        |    9 +--
 drivers/net/wireless/iwlwifi/iwl-power.c      |   13 +--
 drivers/net/wireless/iwlwifi/iwl-sv-open.c    |  135 +++++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-testmode.h   |    9 +-
 19 files changed, 313 insertions(+), 235 deletions(-)

