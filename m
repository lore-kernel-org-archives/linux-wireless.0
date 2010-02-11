Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50477 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756828Ab0BKSmP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2010 13:42:15 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Trieu 'Andrew' Nguyen <trieux.t.nguyen@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/12] iwlwifi: Adjusting PLCP error threshold for 1000 NIC
Date: Thu, 11 Feb 2010 10:42:02 -0800
Message-Id: <1265913725-4279-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com>
References: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Trieu 'Andrew' Nguyen <trieux.t.nguyen@intel.com>

While testing the station with the NIC 1000 family, it is found that
the plcp error can easily exceed 50 value in 100mSecs.  This creates
unneccessary radio reset/tuning.  This patch raises the PLCP error
threshold of the NIC 1000 from 50 to 200 error count.

Signed-off-by: Trieu 'Andrew' Nguyen <trieux.t.nguyen@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 694ceef..3bf2e6e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -246,7 +246,7 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
 };
 
@@ -274,7 +274,7 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9f1d302..71cf155 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1033,6 +1033,7 @@ struct iwl_event_log {
 #define IWL_MAX_PLCP_ERR_THRESHOLD_MIN	(0)
 #define IWL_MAX_PLCP_ERR_THRESHOLD_DEF	(50)
 #define IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF	(100)
+#define IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF	(200)
 #define IWL_MAX_PLCP_ERR_THRESHOLD_MAX	(255)
 
 enum iwl_reset {
-- 
1.6.3.3

