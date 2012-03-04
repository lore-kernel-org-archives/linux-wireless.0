Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55973 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888Ab2CDUm5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:42:57 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 003/101] iwlwifi: reduce sta_lock hold time in TX
Date: Sun,  4 Mar 2012 11:28:17 -0800
Message-Id: <1330889395-533-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214657_811990_A8D76B54)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we TX, we hold the sta_lock for a long
time, a lot of which isn't needed. Reduce
the time we hold the lock. Note that this
doesn't really change anything as the code
is already under the other spinlock, but it
makes the code easier to read.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 81a3b0e..59509d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -341,13 +341,10 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (info->flags & IEEE80211_TX_CTL_AMPDU)
 		is_agg = true;
 
-	/* irqs already disabled/saved above when locking priv->shrd->lock */
-	spin_lock(&priv->shrd->sta_lock);
-
 	dev_cmd = kmem_cache_alloc(priv->tx_cmd_pool, GFP_ATOMIC);
 
 	if (unlikely(!dev_cmd))
-		goto drop_unlock_sta;
+		goto drop_unlock_priv;
 
 	memset(dev_cmd, 0, sizeof(*dev_cmd));
 	tx_cmd = (struct iwl_tx_cmd *) dev_cmd->payload;
@@ -372,6 +369,9 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	info->driver_data[0] = ctx;
 	info->driver_data[1] = dev_cmd;
 
+	/* irqs already disabled/saved above when locking priv->shrd->lock */
+	spin_lock(&priv->shrd->sta_lock);
+
 	if (ieee80211_is_data_qos(fc) && !ieee80211_is_qos_nullfunc(fc)) {
 		u8 *qc = NULL;
 		struct iwl_tid_data *tid_data;
-- 
1.7.0.4

