Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42366 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab2LJPku (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 10:40:50 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH] ath5k: fix tx path skb leaks
Date: Mon, 10 Dec 2012 16:40:41 +0100
Message-Id: <1355154041-83924-1-git-send-email-nbd@openwrt.org> (sfid-20121210_164053_304480_FD318B70)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_free_txskb() needs to be used instead of dev_kfree_skb_any for
tx packets passed to the driver from mac80211

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/ath/ath5k/base.c         | 4 ++--
 drivers/net/wireless/ath/ath5k/mac80211-ops.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 3a5a61e..4ad40cf 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -849,7 +849,7 @@ ath5k_txbuf_free_skb(struct ath5k_hw *ah, struct ath5k_buf *bf)
 		return;
 	dma_unmap_single(ah->dev, bf->skbaddr, bf->skb->len,
 			DMA_TO_DEVICE);
-	dev_kfree_skb_any(bf->skb);
+	ieee80211_free_txskb(ah->hw, bf->skb);
 	bf->skb = NULL;
 	bf->skbaddr = 0;
 	bf->desc->ds_data = 0;
@@ -1576,7 +1576,7 @@ ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 	return;
 
 drop_packet:
-	dev_kfree_skb_any(skb);
+	ieee80211_free_txskb(hw, skb);
 }
 
 static void
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 1ea8c87..4264341 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -62,7 +62,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	u16 qnum = skb_get_queue_mapping(skb);
 
 	if (WARN_ON(qnum >= ah->ah_capabilities.cap_queues.q_tx_num)) {
-		dev_kfree_skb_any(skb);
+		ieee80211_free_txskb(hw, skb);
 		return;
 	}
 
-- 
1.7.12.2

