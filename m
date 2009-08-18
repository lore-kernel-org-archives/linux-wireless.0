Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:45759 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880AbZHRDyg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:54:36 -0400
Date: Tue, 18 Aug 2009 05:54:37 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 21/29] mwl8k: get rid of mwl8k_config() workqueue use
Message-ID: <20090818035437.GZ18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   78 +++++++++++------------------------------
 1 files changed, 21 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 6b16542..d03e55b 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2633,79 +2633,43 @@ static void mwl8k_remove_interface(struct ieee80211_hw *hw,
 	priv->vif = NULL;
 }
 
-struct mwl8k_config_worker {
-	struct mwl8k_work_struct header;
-	u32 changed;
-};
-
-static int mwl8k_config_wt(struct work_struct *wt)
+static int mwl8k_config(struct ieee80211_hw *hw, u32 changed)
 {
-	struct mwl8k_config_worker *worker =
-		(struct mwl8k_config_worker *)wt;
-	struct ieee80211_hw *hw = worker->header.hw;
 	struct ieee80211_conf *conf = &hw->conf;
 	struct mwl8k_priv *priv = hw->priv;
-	int rc = 0;
+	int rc;
 
 	if (conf->flags & IEEE80211_CONF_IDLE) {
-		mwl8k_cmd_802_11_radio_disable(hw);
 		priv->current_channel = NULL;
-		rc = 0;
-		goto mwl8k_config_exit;
+		return mwl8k_cmd_802_11_radio_disable(hw);
 	}
 
-	if (mwl8k_cmd_802_11_radio_enable(hw)) {
-		rc = -EINVAL;
-		goto mwl8k_config_exit;
-	}
+	rc = mwl8k_fw_lock(hw);
+	if (rc)
+		return rc;
 
-	priv->current_channel = conf->channel;
+	rc = mwl8k_cmd_802_11_radio_enable(hw);
+	if (rc)
+		goto out;
 
-	if (mwl8k_cmd_set_rf_channel(hw, conf->channel)) {
-		rc = -EINVAL;
-		goto mwl8k_config_exit;
-	}
+	rc = mwl8k_cmd_set_rf_channel(hw, conf->channel);
+	if (rc)
+		goto out;
+
+	priv->current_channel = conf->channel;
 
 	if (conf->power_level > 18)
 		conf->power_level = 18;
-	if (mwl8k_cmd_802_11_rf_tx_power(hw, conf->power_level)) {
-		rc = -EINVAL;
-		goto mwl8k_config_exit;
-	}
-
-	if (mwl8k_cmd_mimo_config(hw, 0x7, 0x7))
-		rc = -EINVAL;
-
-mwl8k_config_exit:
-	return rc;
-}
-
-static int mwl8k_config(struct ieee80211_hw *hw, u32 changed)
-{
-	int rc = 0;
-	struct mwl8k_config_worker *worker;
-
-	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
-	if (worker == NULL)
-		return -ENOMEM;
-
-	worker->header.sleep = 1;
-	worker->changed = changed;
+	rc = mwl8k_cmd_802_11_rf_tx_power(hw, conf->power_level);
+	if (rc)
+		goto out;
 
-	rc = mwl8k_queue_work(hw, &worker->header, mwl8k_config_wt);
-	if (rc == -ETIMEDOUT) {
-		printk(KERN_ERR "%s() timed out.\n", __func__);
-		rc = -EINVAL;
-	}
+	rc = mwl8k_cmd_mimo_config(hw, 0x7, 0x7);
 
-	kfree(worker);
+out:
+	mwl8k_fw_unlock(hw);
 
-	/*
-	 * mac80211 will crash on anything other than -EINVAL on
-	 * error. Looks like wireless extensions which calls mac80211
-	 * may be the actual culprit...
-	 */
-	return rc ? -EINVAL : 0;
+	return rc;
 }
 
 struct mwl8k_bss_info_changed_worker {
-- 
1.5.6.4
