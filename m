Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13894 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932715AbZLNWMS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 17:12:18 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/6] iwlwifi fixes for 2.6.33
Date: Mon, 14 Dec 2009 14:12:07 -0800
Message-Id: <1260828733-22726-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

This is an initial effort to (1) reduce confusion in patch submission, and
(2) start working towards separate submissions to wireless-2.6 and
wireless-next-2.6. This series includes fixes targeting 2.6.33 and is based
on wireless-2.6. All of these fixes are needed in 2.6.34 also.

These fixes include two patches that address problems when using the driver
on big-endian systems.

For 3945 we disable power save support since it has been found to trigger
uCode problems and have also been found to drop associations. Also for 3945
we include a fix to a panic that was reported on linux-wireless mailing
list (http://thread.gmane.org/gmane.linux.kernel.wireless.general/43568).

We include a fix where recent power saving work used a spinlock before it
was initialized. We also include a fix to the problem where cards not
supporting 40MHz are unable to associate to APs that do.

All fixes except the spinlock fix is needed in 2.6.32 also. Not all of the
fixes apply there though and should be rebased after they have been merged
into 2.6.33.

These patches are also available from branch wireless-2.6 in
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Please let me know what needs to be changed to help make the submission
process work better for you.

Johannes Berg (2):
  iwlwifi: fix EEPROM/OTP reading endian annotations and a bug
  iwlwifi: fix more eeprom endian bugs

Reinette Chatre (3):
  iwl3945: disable power save
  iwlwifi: initialize spinlock before use
  iwlwifi: fix 40MHz operation setting on cards that do not allow it

Zhu Yi (1):
  iwl3945: fix panic in iwl3945 driver

 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 ++
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h  |   14 +++++++++-----
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |   23 +++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   15 ++++++++++-----
 9 files changed, 44 insertions(+), 29 deletions(-)


Thank you

Reinette

