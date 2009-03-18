Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57755 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZCREqz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 00:46:55 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/13] iwlcore: Fix scan problem, resource busy
Date: Tue, 17 Mar 2009 21:51:46 -0700
Message-Id: <1237351913-19202-7-git-send-email-reinette.chatre@intel.com> (sfid-20090318_054708_018702_A5ED521D)
In-Reply-To: <1237351913-19202-6-git-send-email-reinette.chatre@intel.com>
References: <1237351913-19202-1-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-2-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-3-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-4-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-5-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

when mac80211 issues scan request to lower driver, it always expect
a scan_complete notification from the driver, this driver make sure
we call scan_completed on all exit path in iwl_mac_hw_scan.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 23644cf..f557f38 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -462,8 +462,9 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 	spin_lock_irqsave(&priv->lock, flags);
 
 	if (!iwl_is_ready_rf(priv)) {
-		ret = -EIO;
+		ret = 0;
 		IWL_DEBUG_MAC80211(priv, "leave - not ready or exit pending\n");
+		queue_work(priv->workqueue, &priv->scan_completed);
 		goto out_unlock;
 	}
 
-- 
1.5.6.3

