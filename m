Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64061 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757535Ab0D3XAg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 19:00:36 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/8] iwlwifi: set correct AC to swq_id for aggregation
Date: Fri, 30 Apr 2010 16:00:21 -0700
Message-Id: <1272668425-3753-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1272668425-3753-1-git-send-email-reinette.chatre@intel.com>
References: <1272668425-3753-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

When starting an aggregation session, the swq_id is generated in function
iwl_virtual_agg_queue_num() where the first parameter is supposed to be
the Access Class, but it used the tx fifo ID instead. This means the AC
value stored in swq_id is incorrect. To test this, look at the tx_queue
file in debugfs while transmitting Best Effort flow (ac=2), it shows:
hwq 10: read=0 write=0 stop=0 swq_id=0xa9 (ac 1/hwq 10)
After this fix, it will show:
hwq 10: read=0 write=0 stop=0 swq_id=0xaa (ac 2/hwq 10)

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 11661fa..95e263f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -83,6 +83,15 @@ static inline int get_fifo_from_ac(u8 ac)
 	return ac_to_fifo[ac];
 }
 
+static inline int get_ac_from_tid(u16 tid)
+{
+	if (likely(tid < ARRAY_SIZE(tid_to_ac)))
+		return tid_to_ac[tid];
+
+	/* no support for TIDs 8-15 yet */
+	return -EINVAL;
+}
+
 static inline int get_fifo_from_tid(u16 tid)
 {
 	if (likely(tid < ARRAY_SIZE(tid_to_ac)))
@@ -991,7 +1000,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn)
 	tid_data = &priv->stations[sta_id].tid[tid];
 	*ssn = SEQ_TO_SN(tid_data->seq_number);
 	tid_data->agg.txq_id = txq_id;
-	priv->txq[txq_id].swq_id = iwl_virtual_agg_queue_num(tx_fifo, txq_id);
+	priv->txq[txq_id].swq_id = iwl_virtual_agg_queue_num(get_ac_from_tid(tid), txq_id);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	ret = priv->cfg->ops->lib->txq_agg_enable(priv, txq_id, tx_fifo,
-- 
1.6.3.3

