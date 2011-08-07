Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1175 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab1HHARG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Aug 2011 20:17:06 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, lrodriguez@atheros.com,
	Bob Copeland <me@bobcopeland.com>, stable@kernel.org
Subject: [PATCH] ath5k: fix error handling in ath5k_beacon_send
Date: Sun,  7 Aug 2011 19:36:07 -0400
Message-Id: <1312760167-3338-1-git-send-email-me@bobcopeland.com> (sfid-20110808_021849_898725_B1A29635)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This cleans up error handling for the beacon in case of dma mapping
failure.  We need to free the skb when dma mapping fails instead of
nulling and leaking the pointer, and we should bail out to avoid
giving the hardware the bad descriptor.

Finally, we need to perform the null check after trying to update
the beacon, or else beacons will never be sent after a single
mapping failure.

Cc: stable@kernel.org
Signed-off-by: Bob Copeland <me@bobcopeland.com>

---
Tested this by artificially failing 10% of the dma mappings.

 drivers/net/wireless/ath/ath5k/base.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a74d286..e9a6e34 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1734,6 +1734,8 @@ ath5k_beacon_setup(struct ath5k_hw *ah, struct ath5k_buf *bf)
 
 	if (dma_mapping_error(ah->dev, bf->skbaddr)) {
 		ATH5K_ERR(ah, "beacon DMA mapping failed\n");
+		dev_kfree_skb_any(skb);
+		bf->skb = NULL;
 		return -EIO;
 	}
 
@@ -1818,8 +1820,6 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	ath5k_txbuf_free_skb(ah, avf->bbuf);
 	avf->bbuf->skb = skb;
 	ret = ath5k_beacon_setup(ah, avf->bbuf);
-	if (ret)
-		avf->bbuf->skb = NULL;
 out:
 	return ret;
 }
@@ -1839,6 +1839,7 @@ ath5k_beacon_send(struct ath5k_hw *ah)
 	struct ath5k_vif *avf;
 	struct ath5k_buf *bf;
 	struct sk_buff *skb;
+	int err;
 
 	ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_BEACON, "in beacon_send\n");
 
@@ -1887,11 +1888,6 @@ ath5k_beacon_send(struct ath5k_hw *ah)
 
 	avf = (void *)vif->drv_priv;
 	bf = avf->bbuf;
-	if (unlikely(bf->skb == NULL || ah->opmode == NL80211_IFTYPE_STATION ||
-		     ah->opmode == NL80211_IFTYPE_MONITOR)) {
-		ATH5K_WARN(ah, "bf=%p bf_skb=%p\n", bf, bf ? bf->skb : NULL);
-		return;
-	}
 
 	/*
 	 * Stop any current dma and put the new frame on the queue.
@@ -1905,8 +1901,17 @@ ath5k_beacon_send(struct ath5k_hw *ah)
 
 	/* refresh the beacon for AP or MESH mode */
 	if (ah->opmode == NL80211_IFTYPE_AP ||
-	    ah->opmode == NL80211_IFTYPE_MESH_POINT)
-		ath5k_beacon_update(ah->hw, vif);
+	    ah->opmode == NL80211_IFTYPE_MESH_POINT) {
+		err = ath5k_beacon_update(ah->hw, vif);
+		if (err)
+			return;
+	}
+
+	if (unlikely(bf->skb == NULL || ah->opmode == NL80211_IFTYPE_STATION ||
+		     ah->opmode == NL80211_IFTYPE_MONITOR)) {
+		ATH5K_WARN(ah, "bf=%p bf_skb=%p\n", bf, bf->skb);
+		return;
+	}
 
 	trace_ath5k_tx(ah, bf->skb, &ah->txqs[ah->bhalq]);
 
-- 
1.7.2.5


