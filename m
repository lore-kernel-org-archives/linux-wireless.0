Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757332AbXHHHhR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:17 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 05/28] iwlwifi: optimize iwl_queue_{inc|dec}_wrap implementation
Date: Wed,  8 Aug 2007 15:33:22 +0800
Message-Id: <11865584392893-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584363863-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch optimizes implementation of iwl_queue_inc_wrap and
iwl_queue_inc_wrap based on the fact the hardware queue is power-of-two
size. We also add BUG_ON and BUILD_BUG_ON check for queue size against
is_power_of_2 in case future hardwares break this rule.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 4d73b86..becaeea 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -160,14 +160,16 @@ static int iwl_queue_space(const struct iwl_queue *q)
 	return s;
 }
 
+/* XXX: n_bd must be power-of-two size */
 static inline int iwl_queue_inc_wrap(int index, int n_bd)
 {
-	return (++index == n_bd) ? 0 : index;
+	return ++index & (n_bd - 1);
 }
 
+/* XXX: n_bd must be power-of-two size */
 static inline int iwl_queue_dec_wrap(int index, int n_bd)
 {
-	return (index == 0) ? n_bd - 1 : index - 1;
+	return --index & (n_bd - 1);
 }
 
 static inline int x2_queue_used(const struct iwl_queue *q, int i)
@@ -192,6 +194,10 @@ static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 	q->n_window = slots_num;
 	q->id = id;
 
+	/* count must be power-of-two size, otherwise iwl_queue_inc_wrap
+	 * and iwl_queue_dec_wrap are broken. */
+	BUG_ON(!is_power_of_2(count));
+
 	q->low_mark = q->n_window / 4;
 	if (q->low_mark < 4)
 		q->low_mark = 4;
@@ -266,9 +272,13 @@ int iwl_tx_queue_init(struct iwl_priv *priv,
 
 		return -ENOMEM;
 	}
-
 	txq->need_update = 0;
+
+	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
+	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
+	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
 	iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
+
 	iwl_hw_tx_queue_init(priv, txq);
 
 	return 0;
-- 
1.5.2
