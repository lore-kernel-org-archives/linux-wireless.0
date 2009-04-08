Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59798 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765595AbZDHSdq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:33:46 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/6] iwlcore: fix channel display in debugfs
Date: Wed,  8 Apr 2009 11:39:31 -0700
Message-Id: <1239215972-1795-6-git-send-email-reinette.chatre@intel.com> (sfid-20090408_203406_307086_F3D70897)
In-Reply-To: <1239215972-1795-5-git-send-email-reinette.chatre@intel.com>
References: <1239215972-1795-1-git-send-email-reinette.chatre@intel.com>
 <1239215972-1795-2-git-send-email-reinette.chatre@intel.com>
 <1239215972-1795-3-git-send-email-reinette.chatre@intel.com>
 <1239215972-1795-4-git-send-email-reinette.chatre@intel.com>
 <1239215972-1795-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

Fix displaying of wrong channel information when user query
channel through debugfs

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index af1d121..5b8c839 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -389,7 +389,7 @@ static ssize_t iwl_dbgfs_channels_read(struct file *file, char __user *user_buf,
 				channels[i].max_power,
 				channels[i].flags & IEEE80211_CHAN_RADAR ?
 				" (IEEE 802.11h required)" : "",
-				(!(channels[i].flags & IEEE80211_CHAN_NO_IBSS)
+				((channels[i].flags & IEEE80211_CHAN_NO_IBSS)
 				|| (channels[i].flags &
 				IEEE80211_CHAN_RADAR)) ? "" :
 				", IBSS",
-- 
1.5.6.3

