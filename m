Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:35013 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab0A2TyL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 14:54:11 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/12] iwlwifi: remove unused work structs
Date: Fri, 29 Jan 2010 11:54:00 -0800
Message-Id: <1264794842-8046-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
References: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

auth_work, calibrated_work, update_link_led
and report_work are never used, so remove them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 1cd565a..55dc5a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1265,13 +1265,9 @@ struct iwl_priv {
 	struct workqueue_struct *workqueue;
 
 	struct work_struct restart;
-	struct work_struct calibrated_work;
 	struct work_struct scan_completed;
 	struct work_struct rx_replenish;
 	struct work_struct abort_scan;
-	struct work_struct update_link_led;
-	struct work_struct auth_work;
-	struct work_struct report_work;
 	struct work_struct request_scan;
 	struct work_struct beacon_update;
 	struct work_struct tt_work;
-- 
1.6.3.3

