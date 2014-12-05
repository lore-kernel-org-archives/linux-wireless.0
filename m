Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:1769 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaLERRm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2014 12:17:42 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath10k: unregister and remove frag_threshold callback
Date: Fri, 5 Dec 2014 09:16:26 -0800
Message-ID: <1417799786-11391-1-git-send-email-poh@qca.qualcomm.com> (sfid-20141205_181745_324066_C893FFBB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setting fragmentation threshold has not been supported by
any of firmware versions, hence unregister the callback and
remove the function.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c400567..604a4bc 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3989,29 +3989,6 @@ static int ath10k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 	return ret;
 }
 
-static int ath10k_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
-{
-	struct ath10k *ar = hw->priv;
-	struct ath10k_vif *arvif;
-	int ret = 0;
-
-	mutex_lock(&ar->conf_mutex);
-	list_for_each_entry(arvif, &ar->arvifs, list) {
-		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %d fragmentation threshold %d\n",
-			   arvif->vdev_id, value);
-
-		ret = ath10k_mac_set_frag(arvif, value);
-		if (ret) {
-			ath10k_warn(ar, "failed to set fragmentation threshold for vdev %d: %d\n",
-				    arvif->vdev_id, ret);
-			break;
-		}
-	}
-	mutex_unlock(&ar->conf_mutex);
-
-	return ret;
-}
-
 static void ath10k_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			 u32 queues, bool drop)
 {
@@ -4655,7 +4632,6 @@ static const struct ieee80211_ops ath10k_ops = {
 	.remain_on_channel		= ath10k_remain_on_channel,
 	.cancel_remain_on_channel	= ath10k_cancel_remain_on_channel,
 	.set_rts_threshold		= ath10k_set_rts_threshold,
-	.set_frag_threshold		= ath10k_set_frag_threshold,
 	.flush				= ath10k_flush,
 	.tx_last_beacon			= ath10k_tx_last_beacon,
 	.set_antenna			= ath10k_set_antenna,
-- 
1.9.1

