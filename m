Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18869 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756505AbZAHSSY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 13:18:24 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 04/11] iwl3945: kill iwl3945_x2_queue_used
Date: Thu,  8 Jan 2009 10:19:55 -0800
Message-Id: <1231438802-10991-5-git-send-email-reinette.chatre@intel.com> (sfid-20090108_191839_870293_7514AE9A)
In-Reply-To: <1231438802-10991-4-git-send-email-reinette.chatre@intel.com>
References: <>
 <1231438802-10991-1-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-2-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-3-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch replaces iwl3945_x2_queue_used with iwl_queue_used.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 --
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    9 +--------
 3 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 6f27f18..fc34a42 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -344,7 +344,7 @@ static void iwl3945_rx_reply_tx(struct iwl_priv *priv,
 	int rate_idx;
 	int fail;
 
-	if ((index >= txq->q.n_bd) || (iwl3945_x2_queue_used(&txq->q, index) == 0)) {
+	if ((index >= txq->q.n_bd) || (iwl_queue_used(&txq->q, index) == 0)) {
 		IWL_ERR(priv, "Read index for DMA queue txq_id (%d) index %d "
 			  "is out of range [0-%d] %d %d\n", txq_id,
 			  index, txq->q.n_bd, txq->q.write_ptr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 3041616..be30134 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -106,8 +106,6 @@ enum iwl3945_antenna {
 #define	DEFAULT_SHORT_RETRY_LIMIT 7U
 #define	DEFAULT_LONG_RETRY_LIMIT  4U
 
-int iwl3945_x2_queue_used(const struct iwl_queue *q, int i);
-
 #include "iwl-agn-rs.h"
 
 #define IWL_TX_FIFO_AC0	0
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 611c35e..f72ec15 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -120,13 +120,6 @@ struct iwl_mod_params iwl3945_mod_params = {
  * (#0-3) for data tx via EDCA.  An additional 2 HCCA queues are unused.
  ***************************************************/
 
-int iwl3945_x2_queue_used(const struct iwl_queue *q, int i)
-{
-	return q->write_ptr > q->read_ptr ?
-		(i >= q->read_ptr && i < q->write_ptr) :
-		!(i < q->read_ptr && i >= q->write_ptr);
-}
-
 /**
  * iwl3945_queue_init - Initialize queue's high/low-water and read/write indexes
  */
@@ -3085,7 +3078,7 @@ static void iwl3945_cmd_queue_reclaim(struct iwl_priv *priv,
 	struct iwl_queue *q = &txq->q;
 	int nfreed = 0;
 
-	if ((index >= q->n_bd) || (iwl3945_x2_queue_used(q, index) == 0)) {
+	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
 		IWL_ERR(priv, "Read index for DMA queue txq id (%d), index %d, "
 			  "is out of range [0-%d] %d %d.\n", txq_id,
 			  index, q->n_bd, q->write_ptr, q->read_ptr);
-- 
1.5.4.3

