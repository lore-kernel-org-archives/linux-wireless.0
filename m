Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46204 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab1AaVxR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 16:53:17 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/11]  update for 2.6.39
Date: Mon, 31 Jan 2011 13:40:36 -0800
Message-Id: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We fix number of issues for 2000 series devices.
We also make max aggregation size more dynamic.

Johannes Berg (4):
  iwlwifi: support RSN IBSS
  iwlwifi: advertise max aggregate size
  iwlwifi: use maximum aggregation size
  iwlwifi: fix beacon notification parsing

Wey-Yi Guy (7):
  iwlwifi: check ucode loading error and restart
  iwlagn: adjust rate table
  iwlagn: add IQ inversion support for 2000 series devices
  iwlwifi: always support idle mode for agn devices
  iwlagn: use 2030 macro for 2030 devices
  iwlagn: remove unsupported BT SCO command
  iiwlagn: remove unused parameter

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-1000.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c      |   16 +++--
 drivers/net/wireless/iwlwifi/iwl-4965.c      |   32 ++++++++---
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    3 -
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |   25 --------
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c    |   29 +++++----
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    8 ---
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   81 +++++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-commands.h  |    8 ++-
 drivers/net/wireless/iwlwifi/iwl-core.h      |    3 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h       |    2 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c   |    7 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c  |   11 +++-
 15 files changed, 130 insertions(+), 101 deletions(-)

