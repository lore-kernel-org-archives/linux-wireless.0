Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:4672 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab0HRQSb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:18:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/16] iwlwifi update for 2.6.37
Date: Wed, 18 Aug 2010 09:22:35 -0700
Message-Id: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We enable the capabilities to use experimental uCode for debugging.
We also do some code cleanup and refactor works in iwlwifi driver
There is a possibility of race condition while performing roaming,
not sure it is the case, but to avoid the possibility is a much
better approach.

Jay Sternberg (2):
  iwlwifi: enable experimental ucode support
  iwlwifi: move debug options into submenu

Johannes Berg (1):
  iwlwifi: refactor iwl_setup_rxon_timing

Shanyu Zhao (3):
  iwlwifi: do not call ieee80211_frequency_to_channel
  iwlwifi: avoid race condition in channel change
  iwlwifi: cleanup iwl_set_rxon_channel()

Wey-Yi Guy (10):
  iwlwifi: remove unused define
  iwlwifi: additional comments in iwl_cfg
  iwlwifi: max/min aggregation time limit
  iwlwifi: make aggregation time limit configurable
  iwlagn: adjust starting action for rate scale
  iwlagn: continue perform rate scale when error detected
  iwlwifi: additional parameter in REPLY_RX_PHY_CMD
  iwlwifi: more generic name for rssi calc in iwlagn
  iwlwifi: configurable ampdu factor and density
  iwlwifi: remove unused iwl_send_card_state function

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/Kconfig        |   10 ++++
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |   21 +++++---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |   42 +++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   56 ++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-commands.h |   45 +++++++++--------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   71 +++++++++------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |   12 +++-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    6 +--
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   14 +++++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   11 +---
 14 files changed, 168 insertions(+), 128 deletions(-)

