Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22722 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab0CYUow (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:44:52 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 00/22] iwlwifi updates for 2.6.35
Date: Thu, 25 Mar 2010 13:44:28 -0700
Message-Id: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains a significant amount of code reorganization. The
recent devices supported by iwlwifi, iwl5000 and up, share a significant
amount of code. Until now this code was in the "iwl5000" namespace, but
managed many more than the name indicates. This patch series reorganizes
code to move shared functionality to the more general "iwlagn" namespace.

In addition to the above we make the following changes.
A newly introduced function iwl_good_ack_health() only applies to iwlagn
and can thus be moved into it. To accomodate this change we revert a
recently merged patch that circumvents the problem and provide a new patch
that places this function in the correct spot.

iwlwifi is still using spin_lock in a few places, which is now modified to
spin_lock_irqsave.

noise reporting has been deprecated in mac80211 and now removed from
iwlwifi.

Add recognition for new 6000 Series 2x2 AGN Gen2 devices.

These patches are also available from wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Jay Sternberg (1):
  iwlwifi: enable '6000 Series 2x2 AGN Gen2' adaptors

Johannes Berg (1):
  iwlwifi: remove noise reporting

Reinette Chatre (1):
  Revert "iwlwifi: fix build error for CONFIG_IWLAGN=n"

Wey-Yi Guy (19):
  iwlwifi: iwl_good_ack_health() only apply to AGN device
  iwlwifi: move ucode loading related code to separated file
  iwlwifi: code cleanup for "load ucode" function
  iwlwifi: move hcmd related code to separate file
  iwlwifi: move tx queue related code to separate file
  iwlwifi: move hw related defines to separate file
  iwlwifi: move ucode alive related code to separate file
  iwlwifi: move agn common code to iwlagn library file
  iwlwifi: each device has its own eeprom tx power version
  iwlwifi: move agn module parameter structure to common place
  iwlwifi: move agn only tx functions from iwlcore to iwlagn
  iwlwifi: move agn only rx functions from iwlcore to iwlagn
  iwlwifi: more clean up to move agn only rx functions from iwlcore to
    iwlagn
  iwlwifi: remove non-exist extern functions and structures
  iwlwifi: add missing email address information
  iwlwifi: Generic approach to measure temperature
  iwlwifi: remove "\n" from module parameter description
  iwlwifi: change spin_lock to spin_lock_irqsave
  iwlwifi: avoid device type checking in generic code

 drivers/net/wireless/iwlwifi/Makefile        |    2 +
 drivers/net/wireless/iwlwifi/iwl-1000.c      |   76 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c      |   36 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c      |   15 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h   |   33 -
 drivers/net/wireless/iwlwifi/iwl-5000.c      | 1368 ++------------------------
 drivers/net/wireless/iwlwifi/iwl-6000.c      |  188 +++--
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c  |  274 +++++
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h    |  102 ++
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c   |   14 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   | 1125 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c    |    2 -
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    | 1314 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |  416 ++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   85 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.h       |   75 ++
 drivers/net/wireless/iwlwifi/iwl-core.c      |  111 +--
 drivers/net/wireless/iwlwifi/iwl-core.h      |   26 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h       |   42 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.c  |    1 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.h    |   17 +-
 drivers/net/wireless/iwlwifi/iwl-led.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c     |    8 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c        |  758 +--------------
 drivers/net/wireless/iwlwifi/iwl-scan.c      |    7 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c       |    1 +
 drivers/net/wireless/iwlwifi/iwl-tx.c        | 1029 -------------------
 27 files changed, 3676 insertions(+), 3451 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-hw.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-lib.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-tx.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c

