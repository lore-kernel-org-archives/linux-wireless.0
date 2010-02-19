Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab0BSGBp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 01:01:45 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, stable@kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/3] fixes for 2.6.33 and stable
Date: Thu, 18 Feb 2010 22:01:38 -0800
Message-Id: <1266559301-19581-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We include three fixes for 2.6.33, all of which target stable also.

The first is a fix to a recently submitted patch "iwlwifi: Fix to set correct ht
configuration"

With the second two patches we start to address
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2160 where it can be
seen that there are instances where the number of freed tfds are negative.
We include two patches to (1) prevent the problem from
occuring, and (2) prevent the problem from propagating when it does occur.
Unfortunately "iwlwifi: sanity check before counting number of tfds can be free" is not
the only fix needed for this situation to occur, hence "iwlwifi: error checking
for number of tfds in queue"  is needed while this problem is being
investigated further.

These patches are also available from wireless-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git


Dan Halperin (1):
  iwlwifi: set HT flags after channel in rxon

Wey-Yi Guy (2):
  iwlwifi: sanity check before counting number of tfds can be free
  iwlwifi: error checking for number of tfds in queue

 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 ++
 drivers/net/wireless/iwlwifi/iwl-tx.c   |   25 +++++++++++++++++++++++--
 5 files changed, 28 insertions(+), 5 deletions(-)

