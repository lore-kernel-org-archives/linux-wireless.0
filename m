Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:39511 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756827Ab0FYWnI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 18:43:08 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/8] iwlwifi: add a mechanism to disable plcp error checking
Date: Fri, 25 Jun 2010 15:42:56 -0700
Message-Id: <1277505781-25268-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1277505781-25268-1-git-send-email-reinette.chatre@intel.com>
References: <1277505781-25268-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For some devices, especially the upcoming new devices, the plcp error
rate is different. Before the correct error rate can be determine, also
for the debugging purpose; add the mechanism to disable plcp error checking
which cause radio reset happen.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c    |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c  |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    3 ++-
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 93d513e..a07310f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -406,6 +406,11 @@ static bool iwl3945_good_plcp_health(struct iwl_priv *priv,
 	unsigned int plcp_msec;
 	unsigned long plcp_received_jiffies;
 
+	if (priv->cfg->plcp_delta_threshold ==
+	    IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE) {
+		IWL_DEBUG_RADIO(priv, "plcp_err check disabled\n");
+		return rc;
+	}
 	memcpy(&current_stat, pkt->u.raw, sizeof(struct
 			iwl3945_notif_statistics));
 	/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index ad2bead..d54edc3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -166,6 +166,12 @@ bool iwl_good_plcp_health(struct iwl_priv *priv,
 	unsigned int plcp_msec;
 	unsigned long plcp_received_jiffies;
 
+	if (priv->cfg->plcp_delta_threshold ==
+	    IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE) {
+		IWL_DEBUG_RADIO(priv, "plcp_err check disabled\n");
+		return rc;
+	}
+
 	/*
 	 * check for plcp_err and trigger radio reset if it exceeds
 	 * the plcp error threshold plcp_delta.
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index cee3d12..7d9ffc1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1430,10 +1430,10 @@ static ssize_t iwl_dbgfs_plcp_delta_write(struct file *file,
 		return -EFAULT;
 	if (sscanf(buf, "%d", &plcp) != 1)
 		return -EINVAL;
-	if ((plcp <= IWL_MAX_PLCP_ERR_THRESHOLD_MIN) ||
+	if ((plcp < IWL_MAX_PLCP_ERR_THRESHOLD_MIN) ||
 		(plcp > IWL_MAX_PLCP_ERR_THRESHOLD_MAX))
 		priv->cfg->plcp_delta_threshold =
-			IWL_MAX_PLCP_ERR_THRESHOLD_DEF;
+			IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE;
 	else
 		priv->cfg->plcp_delta_threshold = plcp;
 	return count;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 1af845c..df07a14 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1036,11 +1036,12 @@ struct iwl_event_log {
  * This is the threshold value of plcp error rate per 100mSecs.  It is
  * used to set and check for the validity of plcp_delta.
  */
-#define IWL_MAX_PLCP_ERR_THRESHOLD_MIN	(0)
+#define IWL_MAX_PLCP_ERR_THRESHOLD_MIN	(1)
 #define IWL_MAX_PLCP_ERR_THRESHOLD_DEF	(50)
 #define IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF	(100)
 #define IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF	(200)
 #define IWL_MAX_PLCP_ERR_THRESHOLD_MAX	(255)
+#define IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE	(0)
 
 #define IWL_DELAY_NEXT_FORCE_RF_RESET  (HZ*3)
 #define IWL_DELAY_NEXT_FORCE_FW_RELOAD (HZ*5)
-- 
1.7.0.4

