Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758436AbXHHHhT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:19 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 06/28] iwlwifi: use mask operation to replace '%' for index calculation
Date: Wed,  8 Aug 2007 15:33:23 +0800
Message-Id: <11865584413292-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584392893-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces index calculation with '%' to mask operation. Note,
this is only applicable for power-of-two size.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965.c |    2 +-
 drivers/net/wireless/iwl-base.c |   18 +++++++++++-------
 drivers/net/wireless/iwl-hw.h   |    1 +
 drivers/net/wireless/iwlwifi.h  |    2 +-
 4 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index 58ea2a1..c93c607 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -2048,7 +2048,7 @@ static struct iwl_txpower_comp_entry {
 static s32 get_min_power_index(s32 rate_power_index, u32 band)
 {
 	if (!band) {
-		if ((rate_power_index % 8) <= 4)
+		if ((rate_power_index & 7) <= 4)
 			return MIN_TX_GAIN_INDEX_52GHZ_EXT;
 	}
 	return MIN_TX_GAIN_INDEX;
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index becaeea..18c4a23 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -184,7 +184,7 @@ static inline u8 get_next_cmd_index(struct iwl_queue *q, u32 index, int is_huge)
 	if (is_huge)
 		return q->n_window;
 
-	return (u8) (index % q->n_window);
+	return index & (q->n_window - 1);
 }
 
 static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
@@ -198,6 +198,10 @@ static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 	 * and iwl_queue_dec_wrap are broken. */
 	BUG_ON(!is_power_of_2(count));
 
+	/* slots_num must be power-of-two size, otherwise
+	 * get_next_cmd_index is broken. */
+	BUG_ON(!is_power_of_2(slots_num));
+
 	q->low_mark = q->n_window / 4;
 	if (q->low_mark < 4)
 		q->low_mark = 4;
@@ -3247,7 +3251,7 @@ int is_duplicate_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
 		struct list_head *p;
 		struct iwl_ibss_seq *entry = NULL;
 		u8 *mac = header->addr2;
-		int index = mac[5] % IWL_IBSS_MAC_HASH_SIZE;
+		int index = mac[5] & (IWL_IBSS_MAC_HASH_SIZE - 1);
 
 		__list_for_each(p, &priv->ibss_mac_hash[index]) {
 			entry =
@@ -3325,8 +3329,8 @@ static u32 iwl_usecs_to_beacons(u32 usec, u32 beacon_interval)
 	if (!interval || !usec)
 		return 0;
 
-	quot = (usec / interval) % 0x100;
-	rem = (usec % interval) % BEACON_TIME_MASK_LOW;
+	quot = (usec / interval) & (BEACON_TIME_MASK_HIGH >> 24);
+	rem = (usec % interval) & BEACON_TIME_MASK_LOW;
 
 	return (quot << 24) + rem;
 }
@@ -4344,7 +4348,7 @@ int iwl_rx_queue_restock(struct iwl_priv *priv)
 		rxq->bd[rxq->write] =
 		    iwl_dma_addr2rbd_ptr(priv, rxb->dma_addr);
 		rxq->queue[rxq->write] = rxb;
-		rxq->write = (rxq->write + 1) % RX_QUEUE_SIZE;
+		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
 		rxq->free_count--;
 	}
 	spin_unlock_irqrestore(&rxq->lock, flags);
@@ -4647,7 +4651,7 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 		spin_lock_irqsave(&rxq->lock, flags);
 		list_add_tail(&rxb->list, &priv->rxq.rx_used);
 		spin_unlock_irqrestore(&rxq->lock, flags);
-		i = (i + 1) % RX_QUEUE_SIZE;
+		i = (i + 1) & RX_QUEUE_MASK;
 	}
 
 	/* Backtrack one entry */
@@ -8562,7 +8566,7 @@ static ssize_t show_rate(struct device *d,
 
 	return sprintf(buf, "%d%s\n",
 		       (iwl_rates[i].ieee >> 1),
-		       (iwl_rates[i].ieee % 2) ? ".5" : "");
+		       (iwl_rates[i].ieee & 0x1) ? ".5" : "");
 }
 
 static DEVICE_ATTR(rate, S_IRUSR, show_rate, NULL);
diff --git a/drivers/net/wireless/iwl-hw.h b/drivers/net/wireless/iwl-hw.h
index 933a367..e01f29c 100644
--- a/drivers/net/wireless/iwl-hw.h
+++ b/drivers/net/wireless/iwl-hw.h
@@ -1076,6 +1076,7 @@ struct statistics {
 #define NUM_TFD_CHUNKS                        4
 
 #define RX_QUEUE_SIZE                         256
+#define RX_QUEUE_MASK                         255
 #define RX_QUEUE_SIZE_LOG                     8
 
 /*
diff --git a/drivers/net/wireless/iwlwifi.h b/drivers/net/wireless/iwlwifi.h
index 002f8e8..be94217 100644
--- a/drivers/net/wireless/iwlwifi.h
+++ b/drivers/net/wireless/iwlwifi.h
@@ -528,7 +528,7 @@ struct iwl_ucode {
 	u8 data[0];		/* data in same order as "size" elements */
 };
 
-#define IWL_IBSS_MAC_HASH_SIZE 31
+#define IWL_IBSS_MAC_HASH_SIZE 32
 
 struct iwl_ibss_seq {
 	u8 mac[ETH_ALEN];
-- 
1.5.2
