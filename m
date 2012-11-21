Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44843 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab2KUOYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 09:24:44 -0500
Message-ID: <1353507914.10444.28.camel@jlt4.sipsolutions.net> (sfid-20121121_152448_162807_A1B051FD)
Subject: pull-request: iwlwifi-next 2012-11-21
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 21 Nov 2012 15:25:14 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

In his quest to try to understand the current iwlwifi problems (like
stuck queues etc.) Emmanuel has first cleaned up the PCIe code, I'm
including his changes in this pull request. Other than that I only have
a small cleanup from Sachin Kamat to remove a duplicate include and a
bugfix to turn off MFP if software crypto is enabled, but this isn't
really interesting as MFP isn't supported right now anyway.

Please pull.

Thanks,
johannes

The following changes since commit d18aa87fbfe80f33076942d11f19c9d813e835b1:

  iwlwifi: return commands with error on FW error (2012-11-09 20:55:14 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john

for you to fetch changes up to eea54c8ec971d4759c541dba351477dafc39ce54:

  iwlwifi: remove effectless assignment (2012-11-21 11:30:39 +0100)

----------------------------------------------------------------
Emmanuel Grumbach (14):
      iwlwifi: don't warn if transport's allocation failed
      iwlwifi: don't enable interrupt as a W/A when MSI is enabled
      iwlwifi: add comments for the PCIe transport statuses
      iwlwifi: rename functions in transport layer
      iwlwifi: init the replenish work in rx_init
      iwlwifi: continue clean up - pcie/rx.c
      iwlwifi: continue clean up - pcie/trans.c
      iwlwifi: continue clean up - pcie/tx.c
      iwlwifi: merge 2 functions in reclaim flow
      iwlwifi: make iwl_queue_used return bool
      iwlwifi: more cleanup in pcie/rx.c
      iwlwifi: make iwl_pcie_rxq_inc_wr_ptr static
      iwlwifi: update the RB_TIMEOUT to 0x11
      iwlwifi: remove effectless assignment

Johannes Berg (1):
      iwlwifi: disallow MFP with software crypto

Sachin Kamat (1):
      iwlwifi: Remove duplicate inclusion of iwl-trans.h in pcie/drv.c

 drivers/net/wireless/iwlwifi/dvm/mac80211.c  |    9 +-
 drivers/net/wireless/iwlwifi/dvm/main.c      |    2 -
 drivers/net/wireless/iwlwifi/iwl-config.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h        |    2 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c      |    1 -
 drivers/net/wireless/iwlwifi/pcie/internal.h |  104 +--
 drivers/net/wireless/iwlwifi/pcie/rx.c       |  357 ++++++--
 drivers/net/wireless/iwlwifi/pcie/trans.c    | 1018 ++---------------------
 drivers/net/wireless/iwlwifi/pcie/tx.c       | 1146 ++++++++++++++++++++------
 9 files changed, 1299 insertions(+), 1342 deletions(-)


