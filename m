Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9497 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760009AbZKFWxB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:53:01 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/20] iwlwifi: fix FIFO vs. queue confusion
Date: Fri,  6 Nov 2009 14:52:51 -0800
Message-Id: <1257547983-12590-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
References: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

When I added that code setting the swq_id, I evidently
did not understand the distinction between FIFO and TX
queue yet and added code to compare a queue ID and a
FIFO number, which is bogus.

However, the code there need not be this specific, it
can just set all queues to the identity mapping which
will be overwritten by the aggregation queue code. As
a bit of defensive coding, don't assign an swq_id to
the command queue so that if we ever use it for frames
we notice quickly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-tx.c  |    9 +++++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index cb2642c..b4e8145 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -324,8 +324,9 @@ struct iwl_channel_info {
 #define IWL_MIN_NUM_QUEUES	10
 
 /*
- * uCode queue management definitions ...
- * Queue #4 is the command queue for 3945/4965/5x00/1000/6x00.
+ * Queue #4 is the command queue for 3945/4965/5x00/1000/6x00,
+ * the driver maps it into the appropriate device FIFO for the
+ * uCode.
  */
 #define IWL_CMD_QUEUE_NUM	4
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index b1a2de8..d2b606e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -365,8 +365,13 @@ int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 
 	txq->need_update = 0;
 
-	/* aggregation TX queues will get their ID when aggregation begins */
-	if (txq_id <= IWL_TX_FIFO_AC3)
+	/*
+	 * Aggregation TX queues will get their ID when aggregation begins;
+	 * they overwrite the setting done here. The command FIFO doesn't
+	 * need an swq_id so don't set one to catch errors, all others can
+	 * be set up to the identity mapping.
+	 */
+	if (txq_id != IWL_CMD_QUEUE_NUM)
 		txq->swq_id = txq_id;
 
 	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
-- 
1.5.6.3

