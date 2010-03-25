Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:40732 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab0CYUod (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:44:33 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/3] iwlwifi fixes for 2.6.34 and stable
Date: Thu, 25 Mar 2010 13:44:26 -0700
Message-Id: <1269549869-19162-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We include three fixes. iwlwifi's regulatory information was not handled
correctly due to a regression introduced a long time ago by "cfg80211: convert bools into
flags". A recent patch "iwlwifi: error checking for number of tfds in
queue" that was included as a fix missed some hunks, which are
corrected here. The third patch fixes an issue with high CPU utilization
due to a high number of interrupts per second that are not cleared
properly.

These patches are also available from wireless-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Reinette Chatre (1):
  iwlwifi: fix regulatory

Shanyu Zhao (1):
  iwlwifi: clear unattended interrupts in tasklet

Wey-Yi Guy (1):
  iwlwifi: counting number of tfds can be free for 4965

 drivers/net/wireless/iwlwifi/iwl-4965.c     |    6 ++----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   12 ++++++++++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 3 files changed, 13 insertions(+), 7 deletions(-)

