Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:26285 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab0BSXrk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 18:47:40 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, stable@kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH v2 0/2] iwlwifi fixes for 2.6.33 and stable
Date: Fri, 19 Feb 2010 15:47:31 -0800
Message-Id: <1266623253-31673-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am excluding "iwlwifi: set HT flags after channel in rxon" from this
resend since it has been merged into wireless-2.6 already.

We address
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2160 where it can be
seen that there are instances where the number of freed tfds are negative,
which is triggered by the receipt of a TX response with incorrect frame
control.
We include two patches to (1) prevent the problem from
occuring, and (2) prevent the problem from propagating when it does occur.

These patches are also available from wireless-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Stanislaw Gruszka (1):
  iwlwifi: sanity check before counting number of tfds can be free

Wey-Yi Guy (1):
  iwlwifi: error checking for number of tfds in queue

 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c |    8 +++-----
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 ++
 drivers/net/wireless/iwlwifi/iwl-tx.c   |   22 ++++++++++++++++++++--
 4 files changed, 26 insertions(+), 8 deletions(-)

