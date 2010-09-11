Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14287 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab0IKQGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 12:06:43 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/10] iwlwifi update for 2.6.37
Date: Sat, 11 Sep 2010 09:08:28 -0700
Message-Id: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We fix few issues introduced by dual-mode.
We also adding support to configure protection mode.
We also setting the correct LQ table for 5.2 band.

Johannes Berg (5):
  iwlwifi: fix PAN parameters while scanning
  iwlwifi: implement beacon interval change
  iwlwifi: avoid sending too many commands
  iwlwifi: improve timing handling with dual-mode
  iwlwifi: fix and describe iwl_adjust_beacon_interval

Tomas Winkler (1):
  iwlwifi: fix default LQ table in 5.2 band

Wey-Yi Guy (4):
  iwlwifi: remember the last uCode sysassert error code
  iwlwifi: allow configure protection mode
  iwlwifi: make sure runtime calibration is enabled after association
  iwlwifi: remove code repetition

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |   18 +++++++-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   60 ++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h   |    9 ----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   11 +++--
 drivers/net/wireless/iwlwifi/iwl-core.c     |   57 ++++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   44 +++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    9 ++++-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   19 ++++-----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 -
 9 files changed, 159 insertions(+), 69 deletions(-)

