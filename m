Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58808 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474AbZKFXRG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 18:17:06 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>, stable@kernel.org
Subject: [PATCH 0/2 v2.6.32] iwlwifi: fix HT connection stalling
Date: Fri,  6 Nov 2009 15:17:03 -0800
Message-Id: <1257549425-13591-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The details of the problem as encountered on 1000 series can be found in
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2103

The problem is that when HT is used in a noisy environment then connections
can stall and station be deauthenticated from the AP. The solution is to
enforce that RTS/CTS protection be used when in HT mode.

These patches are also targeting stable but do not apply there in its
current form. They will be backported and submitted there once they make it
into linux-2.6. The cc to stable@kernel.org is just informational.

cc: stable@kernel.org

Wey-Yi Guy (2):
  iwlwifi: Use RTS/CTS as the preferred protection mechanism for 6000 series
  iwlwifi: Fix issue on file transfer stalled in HT mode

 drivers/net/wireless/iwlwifi/iwl-1000.c   |    1 +
 drivers/net/wireless/iwlwifi/iwl-6000.c   |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   10 +++++++---
 drivers/net/wireless/iwlwifi/iwl-core.h   |    2 ++
 5 files changed, 24 insertions(+), 3 deletions(-)

