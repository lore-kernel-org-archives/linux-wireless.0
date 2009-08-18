Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:45766 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbZHRDy7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:54:59 -0400
Date: Tue, 18 Aug 2009 05:55:00 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 24/29] mwl8k: get rid of mwl8k_conf_tx() workqueue use
Message-ID: <20090818035500.GC18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   58 ++++++++++-------------------------------
 1 files changed, 14 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index c8e65c6..d16ba1b 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2821,57 +2821,27 @@ static int mwl8k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 	return mwl8k_rts_threshold(hw, MWL8K_CMD_SET, value);
 }
 
-struct mwl8k_conf_tx_worker {
-	struct mwl8k_work_struct header;
-	u16 queue;
-	const struct ieee80211_tx_queue_params *params;
-};
-
-static int mwl8k_conf_tx_wt(struct work_struct *wt)
-{
-	struct mwl8k_conf_tx_worker *worker =
-	(struct mwl8k_conf_tx_worker *)wt;
-
-	struct ieee80211_hw *hw = worker->header.hw;
-	u16 queue = worker->queue;
-	const struct ieee80211_tx_queue_params *params = worker->params;
-
-	struct mwl8k_priv *priv = hw->priv;
-	int rc = 0;
-
-	if (!priv->wmm_enabled) {
-		if (mwl8k_set_wmm(hw, 1)) {
-			rc = -EINVAL;
-			goto mwl8k_conf_tx_exit;
-		}
-	}
-
-	if (mwl8k_set_edca_params(hw, GET_TXQ(queue), params->cw_min,
-		params->cw_max, params->aifs, params->txop))
-			rc = -EINVAL;
-mwl8k_conf_tx_exit:
-	return rc;
-}
-
 static int mwl8k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			 const struct ieee80211_tx_queue_params *params)
 {
+	struct mwl8k_priv *priv = hw->priv;
 	int rc;
-	struct mwl8k_conf_tx_worker *worker;
 
-	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
-	if (worker == NULL)
-		return -ENOMEM;
+	rc = mwl8k_fw_lock(hw);
+	if (!rc) {
+		if (!priv->wmm_enabled)
+			rc = mwl8k_set_wmm(hw, 1);
 
-	worker->header.sleep = 1;
-	worker->queue = queue;
-	worker->params = params;
-	rc = mwl8k_queue_work(hw, &worker->header, mwl8k_conf_tx_wt);
-	kfree(worker);
-	if (rc == -ETIMEDOUT) {
-		printk(KERN_ERR "%s() timed out\n", __func__);
-		rc = -EINVAL;
+		if (!rc)
+			rc = mwl8k_set_edca_params(hw, queue,
+						   params->cw_min,
+						   params->cw_max,
+						   params->aifs,
+						   params->txop);
+
+		mwl8k_fw_unlock(hw);
 	}
+
 	return rc;
 }
 
-- 
1.5.6.4
