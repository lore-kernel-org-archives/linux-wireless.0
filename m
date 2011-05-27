Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26815 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab1E0QH5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 12:07:57 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/10] update for 2.6.41
Date: Fri, 27 May 2011 08:40:23 -0700
Message-Id: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110527_180800_856912_BC71D8DC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add support to advertise the limits on concurrency of virtual interfaces
We also change the log level to better represent the aggregation status
Again, more driver cleanup works for driver split

Daniel Halperin (1):
  iwlwifi: disambiguate invalid DMA index warnings

Emmanuel Grumbach (2):
  iwlagn: solve sparse warning
  iwlagn: free the ICT ISR when the request_irq failed

Johannes Berg (2):
  iwlagn: fix dual-mode RXON
  iwlagn: advertise interface combinations

Wey-Yi Guy (5):
  iwlagn: send tx power command if defer cause by RXON not match
  iwlagn: remove un-necessary tx power ops
  iwlagn: change the logging level for aggregation enable check
  iwlagn: change log to better represent the state of aggregation
    process
  iwlagn: don't advertise interface combinations on device not support
    dualmode

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-1000.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 -
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    2 -
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   57 ++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |   10 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   98 +++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-core.c     |    5 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    6 +-
 12 files changed, 149 insertions(+), 42 deletions(-)

