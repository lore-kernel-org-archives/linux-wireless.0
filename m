Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61394 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbYGKD5I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 23:57:08 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 07/14] iwlwifi: differentiate 4965 and 5000 hw ampdu queues number
Date: Fri, 11 Jul 2008 11:53:35 +0800
Message-Id: <1215748422-12672-8-git-send-email-yi.zhu@intel.com> (sfid-20080711_055713_426208_A38922D3)
In-Reply-To: <1215748422-12672-7-git-send-email-yi.zhu@intel.com>
References: <1215748422-12672-1-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-2-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-3-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-4-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-5-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-6-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-7-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch asks to allocate the correct amount of sw queues according
to hw ampdu queues number.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.c    |   19 +++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c    |   19 +++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-core.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h    |    1 +
 6 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 10f630e..fce950f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -819,6 +819,7 @@ enum {
 #define IWL49_NUM_FIFOS 	7
 #define IWL49_CMD_FIFO_NUM	4
 #define IWL49_NUM_QUEUES	16
+#define IWL49_NUM_AMPDU_QUEUES	8
 
 /**
  * struct iwl_tfd_frame_data
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index e0e43bd..a20adab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -52,6 +52,7 @@ static int iwl4965_hw_get_temperature(const struct iwl_priv *priv);
 /* module parameters */
 static struct iwl_mod_params iwl4965_mod_params = {
 	.num_of_queues = IWL49_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL49_NUM_AMPDU_QUEUES,
 	.enable_qos = 1,
 	.amsdu_size_8K = 1,
 	.restart_fw = 1,
@@ -1943,9 +1944,11 @@ static int iwl4965_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 {
 	int ret = 0;
 
-	if (IWL49_FIRST_AMPDU_QUEUE > txq_id) {
-		IWL_WARNING("queue number too small: %d, must be > %d\n",
-				txq_id, IWL49_FIRST_AMPDU_QUEUE);
+	if ((IWL49_FIRST_AMPDU_QUEUE > txq_id) ||
+	    (IWL49_FIRST_AMPDU_QUEUE + IWL49_NUM_AMPDU_QUEUES <= txq_id)) {
+		IWL_WARNING("queue number out of range: %d, must be %d to %d\n",
+			txq_id, IWL49_FIRST_AMPDU_QUEUE,
+			IWL49_FIRST_AMPDU_QUEUE + IWL49_NUM_AMPDU_QUEUES - 1);
 		return -EINVAL;
 	}
 
@@ -2012,9 +2015,13 @@ static int iwl4965_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	int ret;
 	u16 ra_tid;
 
-	if (IWL49_FIRST_AMPDU_QUEUE > txq_id)
-		IWL_WARNING("queue number too small: %d, must be > %d\n",
-			txq_id, IWL49_FIRST_AMPDU_QUEUE);
+	if ((IWL49_FIRST_AMPDU_QUEUE > txq_id) ||
+	    (IWL49_FIRST_AMPDU_QUEUE + IWL49_NUM_AMPDU_QUEUES <= txq_id)) {
+		IWL_WARNING("queue number out of range: %d, must be %d to %d\n",
+			txq_id, IWL49_FIRST_AMPDU_QUEUE,
+			IWL49_FIRST_AMPDU_QUEUE + IWL49_NUM_AMPDU_QUEUES - 1);
+		return -EINVAL;
+	}
 
 	ra_tid = BUILD_RAxTID(sta_id, tid);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index 4efe0c0..17d4f31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -81,6 +81,7 @@
 #define IWL50_QUEUE_SIZE                 256
 #define IWL50_CMD_FIFO_NUM                 7
 #define IWL50_NUM_QUEUES                  20
+#define IWL50_NUM_AMPDU_QUEUES		  10
 #define IWL50_FIRST_AMPDU_QUEUE		  10
 
 #define IWL_sta_id_POS 12
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index b518792..878d619 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1016,9 +1016,13 @@ static int iwl5000_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	int ret;
 	u16 ra_tid;
 
-	if (IWL50_FIRST_AMPDU_QUEUE > txq_id)
-		IWL_WARNING("queue number too small: %d, must be > %d\n",
-			txq_id, IWL50_FIRST_AMPDU_QUEUE);
+	if ((IWL50_FIRST_AMPDU_QUEUE > txq_id) ||
+	    (IWL50_FIRST_AMPDU_QUEUE + IWL50_NUM_AMPDU_QUEUES <= txq_id)) {
+		IWL_WARNING("queue number out of range: %d, must be %d to %d\n",
+			txq_id, IWL50_FIRST_AMPDU_QUEUE,
+			IWL50_FIRST_AMPDU_QUEUE + IWL50_NUM_AMPDU_QUEUES - 1);
+		return -EINVAL;
+	}
 
 	ra_tid = BUILD_RAxTID(sta_id, tid);
 
@@ -1077,9 +1081,11 @@ static int iwl5000_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 {
 	int ret;
 
-	if (IWL50_FIRST_AMPDU_QUEUE > txq_id) {
-		IWL_WARNING("queue number too small: %d, must be > %d\n",
-				txq_id, IWL50_FIRST_AMPDU_QUEUE);
+	if ((IWL50_FIRST_AMPDU_QUEUE > txq_id) ||
+	    (IWL50_FIRST_AMPDU_QUEUE + IWL50_NUM_AMPDU_QUEUES <= txq_id)) {
+		IWL_WARNING("queue number out of range: %d, must be %d to %d\n",
+			txq_id, IWL50_FIRST_AMPDU_QUEUE,
+			IWL50_FIRST_AMPDU_QUEUE + IWL50_NUM_AMPDU_QUEUES - 1);
 		return -EINVAL;
 	}
 
@@ -1501,6 +1507,7 @@ static struct iwl_ops iwl5000_ops = {
 
 static struct iwl_mod_params iwl50_mod_params = {
 	.num_of_queues = IWL50_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.enable_qos = 1,
 	.amsdu_size_8K = 1,
 	.restart_fw = 1,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index eee220c..a44188b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -825,7 +825,7 @@ int iwl_setup_mac(struct iwl_priv *priv)
 	hw->queues = 4;
 	/* queues to support 11n aggregation */
 	if (priv->cfg->sku & IWL_SKU_N)
-		hw->ampdu_queues = 12;
+		hw->ampdu_queues = priv->cfg->mod_params->num_of_ampdu_queues;
 
 	hw->conf.beacon_int = 100;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 8d18227..0293ae9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -159,6 +159,7 @@ struct iwl_mod_params {
 	int debug;		/* def: 0 = minimal debug log messages */
 	int disable_hw_scan;	/* def: 0 = use h/w scan */
 	int num_of_queues;	/* def: HW dependent */
+	int num_of_ampdu_queues;/* def: HW dependent */
 	int enable_qos;		/* def: 1 = use quality of service */
 	int disable_11n;	/* def: 0 = disable 11n capabilities */
 	int amsdu_size_8K;	/* def: 1 = enable 8K amsdu size */
-- 
1.5.3.6

