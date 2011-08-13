Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35412 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1HMQ55 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 12:57:57 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/13] iwlagn: reserve queue 10 for TX during scan dwell
Date: Sat, 13 Aug 2011 09:17:56 -0700
Message-Id: <1313252287-22858-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_185810_246782_F269F226)
In-Reply-To: <1313252287-22858-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313252287-22858-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

New uCode images will use queue 10 for TX
during scan (for P2P offchannel operation
scan). We'll bump the API version of those,
but before we need to reserve queue 10 and
stop using it for aggregation.

To simplify the code, always reserve it,
we could continue using it on older uCode
images but that'd be rather complicated.
Also, we'll set it up to map to the right
FIFO as needed later, but as we don't use
the queue now that doesn't hurt.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h    |   19 +++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-trans.c  |   10 +++++++---
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
index 0e5b842..47c4304 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
@@ -92,8 +92,8 @@
 
 #define IWLAGN_CMD_FIFO_NUM		7
 #define IWLAGN_NUM_QUEUES		20
-#define IWLAGN_NUM_AMPDU_QUEUES		10
-#define IWLAGN_FIRST_AMPDU_QUEUE	10
+#define IWLAGN_NUM_AMPDU_QUEUES		9
+#define IWLAGN_FIRST_AMPDU_QUEUE	11
 
 /* Fixed (non-configurable) rx data from phy */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8da38be..287f478 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -229,12 +229,23 @@ struct iwl_channel_info {
 #define IWL_TX_FIFO_BE_IPAN	4
 #define IWL_TX_FIFO_VI_IPAN	IWL_TX_FIFO_VI
 #define IWL_TX_FIFO_VO_IPAN	5
+/* re-uses the VO FIFO, uCode will properly flush/schedule */
+#define IWL_TX_FIFO_AUX		5
 #define IWL_TX_FIFO_UNUSED	-1
 
-/* Minimum number of queues. MAX_NUM is defined in hw specific files.
- * Set the minimum to accommodate the 4 standard TX queues, 1 command
- * queue, 2 (unused) HCCA queues, and 4 HT queues (one for each AC) */
-#define IWL_MIN_NUM_QUEUES	10
+/* AUX (TX during scan dwell) queue */
+#define IWL_AUX_QUEUE		10
+
+/*
+ * Minimum number of queues. MAX_NUM is defined in hw specific files.
+ * Set the minimum to accommodate
+ *  - 4 standard TX queues
+ *  - the command queue
+ *  - 4 PAN TX queues
+ *  - the PAN multicast queue, and
+ *  - the AUX (TX during scan dwell) queue.
+ */
+#define IWL_MIN_NUM_QUEUES	11
 
 /*
  * Command queue depends on iPAN support.
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 41f0de9..3001bfb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -750,6 +750,7 @@ static const struct queue_to_fifo_ac iwlagn_default_queue_to_tx_fifo[] = {
 	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
 	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
 	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
 };
 
 static const struct queue_to_fifo_ac iwlagn_ipan_queue_to_tx_fifo[] = {
@@ -763,6 +764,7 @@ static const struct queue_to_fifo_ac iwlagn_ipan_queue_to_tx_fifo[] = {
 	{ IWL_TX_FIFO_VO_IPAN, IEEE80211_AC_VO, },
 	{ IWL_TX_FIFO_BE_IPAN, 2, },
 	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_AUX, IWL_AC_UNSET, },
 };
 static void iwl_trans_tx_start(struct iwl_priv *priv)
 {
@@ -848,10 +850,12 @@ static void iwl_trans_tx_start(struct iwl_priv *priv)
 	/* reset to 0 to enable all the queue first */
 	priv->txq_ctx_active_msk = 0;
 
-	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo) != 10);
-	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_ipan_queue_to_tx_fifo) != 10);
+	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo) !=
+						IWLAGN_FIRST_AMPDU_QUEUE);
+	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_ipan_queue_to_tx_fifo) !=
+						IWLAGN_FIRST_AMPDU_QUEUE);
 
-	for (i = 0; i < 10; i++) {
+	for (i = 0; i < IWLAGN_FIRST_AMPDU_QUEUE; i++) {
 		int fifo = queue_to_fifo[i].fifo;
 		int ac = queue_to_fifo[i].ac;
 
-- 
1.7.0.4

