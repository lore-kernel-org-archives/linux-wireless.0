Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31569 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431Ab0EMVtu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 17:49:50 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/2] iwlwifi fixes for 2.6.34
Date: Thu, 13 May 2010 14:49:43 -0700
Message-Id: <1273787385-9248-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We include two late fixes hoping to make it into 2.6.34.

"iwlwifi: fix internal scan race" fixes a kernel crash caused by
accessing a NULL pointer. More can be read in
https://bugzilla.kernel.org/show_bug.cgi?id=15824

"iwlagn: work around rate scaling reset delay" is already in
wireless-next-2.6 but has since been shown to be an issue in 2.6.34 also.
This fixes spurious firmware restarts that has been documented in
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2173 , but it is the
community report tracked in
https://bugzilla.kernel.org/show_bug.cgi?id=15782 that prompted us sending
this fix to wireless-2.6 also.

These patches are also available from wireless-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Reinette Chatre (2):
  iwlwifi: fix internal scan race
  iwlagn: work around rate scaling reset delay

 drivers/net/wireless/iwlwifi/iwl-scan.c |   21 +++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-sta.c  |   37 ++++++++++++++++++++++++++++++-
 2 files changed, 54 insertions(+), 4 deletions(-)

