Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53515 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab1EMTim (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 15:38:42 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/13] update for 2.6.40
Date: Fri, 13 May 2011 12:13:17 -0700
Message-Id: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110513_213846_051793_FFF2AFCE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add support for multi-TB commands
We also change the default beacon interval for PAN conext
We also make sure uCode is in disassocate state before associate 

Johannes Berg (6):
  iwlagn: prepare for multi-TB commands
  iwlagn: clean up TXQ indirection
  iwlagn: remove unused pad argument
  iwlagn: support multiple TBs per command
  iwlagn: remove set but unused vars
  iwlagn: change default beacon interval

Wey-Yi Guy (7):
  iwlagn: more ucode error log info
  iwlagn: add testmode trace command
  iwlagn: add eeprom command to testmode
  iwlagn: add testmode set fixed rate command
  iwlagn: clear STATUS_HCMD_ACTIVE bit if fail enqueue
  iwlagn: always send RXON with disassociate flag before associate
  iwlagn: remove unused old_assoc parameter

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.gi


 drivers/net/wireless/iwlwifi/iwl-1000.c      |    4 -
 drivers/net/wireless/iwlwifi/iwl-2000.c      |    8 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c      |   12 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c      |   12 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |   14 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |   14 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c    |   86 ++++---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |    9 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |   16 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |  250 ++++--------------
 drivers/net/wireless/iwlwifi/iwl-agn.h       |   13 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h  |    5 +-
 drivers/net/wireless/iwlwifi/iwl-core.h      |   10 -
 drivers/net/wireless/iwlwifi/iwl-dev.h       |   66 ++++--
 drivers/net/wireless/iwlwifi/iwl-devtrace.h  |   58 ++++-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c    |    7 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c      |    9 +-
 drivers/net/wireless/iwlwifi/iwl-led.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c       |   12 +-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c   |  177 +++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-testmode.h  |   34 +++
 drivers/net/wireless/iwlwifi/iwl-tx.c        |  359 +++++++++++++++++++-------
 24 files changed, 716 insertions(+), 473 deletions(-)

