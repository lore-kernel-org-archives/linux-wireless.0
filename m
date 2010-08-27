Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:54400 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab0H0Q4m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:42 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/27] iwlwifi update for 2.6.37
Date: Fri, 27 Aug 2010 09:59:28 -0700
Message-Id: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add support for multiple interfaces.
In order to support multiple interfaces, move
a lot of data into per-context structures so we can
use the contexts the device offers.

Johannes Berg (27):
  iwlwifi: initial contextification
  iwlwifi: prepare for PAN queue/fifo assignment
  iwlwifi: define PAN queues/FIFOs
  iwlwifi: contextify broadcast station
  iwlwifi: contextify-stations-completely
  iwlwifi: contextify command sending
  iwlwifi: move QoS into context
  iwlwifi: add context into tx descriptor
  iwlwifi: move virtual interface pointer into context
  iwlwifi: clamp scanning dwell time to all contexts
  iwlwifi: move AP sta ID to context
  iwlwifi: make hw crypto context aware
  iwlwifi: store default station flags in context
  iwlwifi: add context pointer to station
  iwlwifi: move HT configuration data into context
  iwlwifi: introduce beacon context
  iwlwifi: add PAN API
  iwlagn: detect PAN capability
  iwlagn: remove iw_mode check for beacon
  iwlagn: queue frames according to context
  iwlagn: send RXON timing before associating
  iwlagn: send beacon before committing associated RXON
  iwlwifi: send PAN parameters
  iwlwifi: pass context to iwl_send_rxon_timing
  iwlagn: always send RXON timing
  iwlwifi: follow main beacon interval
  iwlwifi: allow using multiple contexts

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-1000.c      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c   |    7 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c      |   86 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c      |   57 ++-
 drivers/net/wireless/iwlwifi/iwl-5000.c      |   25 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c      |   23 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |   12 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c  |  104 ++++-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |   32 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c    |   66 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c    |   26 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |   81 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   31 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |  423 ++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    3 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h  |  110 +++++-
 drivers/net/wireless/iwlwifi/iwl-core.c      |  676 +++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-core.h      |   55 ++-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c   |   31 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h       |  142 +++++--
 drivers/net/wireless/iwlwifi/iwl-hcmd.c      |   10 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h      |    9 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c        |    9 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c      |   35 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c       |  183 +++++---
 drivers/net/wireless/iwlwifi/iwl-sta.h       |   64 ++-
 drivers/net/wireless/iwlwifi/iwl-tx.c        |   34 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c  |  168 ++++---
 29 files changed, 1658 insertions(+), 849 deletions(-)

