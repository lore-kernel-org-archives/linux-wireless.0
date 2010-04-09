Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17566 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626Ab0DIUJf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 16:09:35 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 00/12] iwlwifi features for 2.6.35
Date: Fri,  9 Apr 2010 13:09:17 -0700
Message-Id: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We include a variety of changes in this set. WEP received some attention
and the key checking is now done better. WEP key restoring is also made
explicit and done at the right spot. Several compiler warnings are fixed.
Driver also now understands more TX command responses to help with
understanding driver behavior.

We include one patch that was also included in last week's series.
"iwlwifi: avoid Tx queue memory allocation in interface down" was sent as a
fix for 2.6.34 and can already be found in wireless-2.6. It has also been
merged into wireless-next-2.6 and wireless-testing, but something went
wrong during these merges and even though the patch appears to be in the
branches it is not. This is a very troublesome problem since it is not
clear how this situation occured and we thus do not know how to prevent it
from happening again.

These patches are also available from wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Johannes Berg (5):
  iwlwifi: make WEP key restoring explicit
  iwlwifi: remove wrong key use check
  iwlagn: simplify WEP key check
  iwlwifi: remove pointless sta_id invalid check
  iwlwifi: clean up last_phy_res

Reinette Chatre (1):
  iwlwifi: fix compile warnings when compiling without debug

Wey-Yi Guy (5):
  iwlwifi: default max event log size
  iwlwifi: add more debug info in error event dump
  iwlwifi: update tx command response status
  iwlwifi: small changes in comments
  iwlwifi: fix compiler warning

Zhu Yi (1):
  iwlwifi: avoid Tx queue memory allocation in interface down

 drivers/net/wireless/iwlwifi/iwl-1000.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   10 ++-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    7 ++
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    7 ++
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   32 +++++---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |   39 +++++++---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   59 +++++++--------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |   27 +++++++-
 drivers/net/wireless/iwlwifi/iwl-commands.h |  108 ++++++++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    5 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   35 ++++-----
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   61 +++++++++++----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   15 ++--
 18 files changed, 274 insertions(+), 144 deletions(-)

