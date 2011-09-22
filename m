Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7986 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777Ab1IVXBR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 19:01:17 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/12] update for 3.2
Date: Thu, 22 Sep 2011 15:14:48 -0700
Message-Id: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110923_010129_643626_6CB44F41)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We fix some performance issue cause by rate scale and sequence control in
transport layer.
We fix number of scan related issue mainly for P2P
Plus number of small cleanup changes 

Emmanuel Grumbach (3):
  iwlagn: set the sequence control from the transport layer
  iwlagn: update rate scaling with BA notifications
  iwlagn: use kcalloc when possible for array allocation

Johannes Berg (7):
  iwlagn: fix dangling scan request
  iwlagn: fix slot programming
  iwlagn: remove Kelvin support
  iwlagn: make iwl_scan_cancel_timeout void
  iwlagn: refactor scan complete
  iwlagn: move iwl_process_scan_complete up
  iwlagn: fix scan complete processing

Wey-Yi Guy (2):
  MAINTAINERS: update iwlwifi
  iwlagn: add debugging to show probe related info in scan notification

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

Because the file system problem, all the patches are not push into 
git.kernel.org yet. I will push as soon as the file system issue addressed

 MAINTAINERS                                   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c     |   18 +--
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c     |   16 ++-
 drivers/net/wireless/iwlwifi/iwl-core.c       |    6 +-
 drivers/net/wireless/iwlwifi/iwl-core.h       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c     |    5 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c       |  179 +++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-shared.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   15 ++-
 11 files changed, 142 insertions(+), 108 deletions(-)

