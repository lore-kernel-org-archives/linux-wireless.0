Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52780 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762166Ab0J2Xfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 19:35:41 -0400
Received: by bwz11 with SMTP id 11so3037818bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Oct 2010 16:35:40 -0700 (PDT)
Message-Id: <575d9ba986bd3ae5c8f2bbc5dd64fdbb38fcbaff.1288393804.git.chunkeey@googlemail.com>
In-Reply-To: <cover.1288393804.git.chunkeey@googlemail.com>
References: <cover.1288393804.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 30 Oct 2010 00:36:53 +0200
Subject: [PATCH 6/6] carl9170: configurable beacon rates
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, the beacon rate was fixed to either:
 * 1Mb/s [2.4GHz band]
 * 6Mb/s [5GHz band]

This limitation has been addressed and now the
beacon rate is selected by ieee80211_tx_info's
rate control info, almost like any ordinary
data frame.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/mac.c |   52 +++++++++++++++++++------------
 1 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/mac.c b/drivers/net/wireless/ath/carl9170/mac.c
index c34eeee..385cf50 100644
--- a/drivers/net/wireless/ath/carl9170/mac.c
+++ b/drivers/net/wireless/ath/carl9170/mac.c
@@ -457,8 +457,9 @@ int carl9170_set_beacon_timers(struct ar9170 *ar)
 
 int carl9170_update_beacon(struct ar9170 *ar, const bool submit)
 {
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
 	struct carl9170_vif_info *cvif;
+	struct ieee80211_tx_info *txinfo;
 	__le32 *data, *old = NULL;
 	u32 word, off, addr, len;
 	int i = 0, err = 0;
@@ -487,7 +488,13 @@ found:
 
 	if (!skb) {
 		err = -ENOMEM;
-		goto out_unlock;
+		goto err_free;
+	}
+
+	txinfo = IEEE80211_SKB_CB(skb);
+	if (txinfo->control.rates[0].flags & IEEE80211_TX_RC_MCS) {
+		err = -EINVAL;
+		goto err_free;
 	}
 
 	spin_lock_bh(&ar->beacon_lock);
@@ -504,11 +511,8 @@ found:
 			wiphy_err(ar->hw->wiphy, "beacon does not "
 				  "fit into device memory!\n");
 		}
-
-		spin_unlock_bh(&ar->beacon_lock);
-		dev_kfree_skb_any(skb);
 		err = -EINVAL;
-		goto out_unlock;
+		goto err_unlock;
 	}
 
 	if (len > AR9170_MAC_BCN_LENGTH_MAX) {
@@ -518,22 +522,22 @@ found:
 				 AR9170_MAC_BCN_LENGTH_MAX, len);
 		}
 
-		spin_unlock_bh(&ar->beacon_lock);
-		dev_kfree_skb_any(skb);
 		err = -EMSGSIZE;
-		goto out_unlock;
+		goto err_unlock;
 	}
 
-	carl9170_async_regwrite_begin(ar);
+	i = txinfo->control.rates[0].idx;
+	if (txinfo->band != IEEE80211_BAND_2GHZ)
+		i += 4;
 
-	/* XXX: use skb->cb info */
-	if (ar->hw->conf.channel->band == IEEE80211_BAND_2GHZ) {
-		carl9170_async_regwrite(AR9170_MAC_REG_BCN_PLCP,
-				((skb->len + FCS_LEN) << (3 + 16)) + 0x0400);
-	} else {
-		carl9170_async_regwrite(AR9170_MAC_REG_BCN_PLCP,
-				((skb->len + FCS_LEN) << 16) + 0x001b);
-	}
+	word = __carl9170_ratetable[i].hw_value & 0xf;
+	if (i < 4)
+		word |= ((skb->len + FCS_LEN) << (3 + 16)) + 0x0400;
+	else
+		word |= ((skb->len + FCS_LEN) << 16) + 0x0010;
+
+	carl9170_async_regwrite_begin(ar);
+	carl9170_async_regwrite(AR9170_MAC_REG_BCN_PLCP, word);
 
 	for (i = 0; i < DIV_ROUND_UP(skb->len, 4); i++) {
 		/*
@@ -557,7 +561,7 @@ found:
 		cvif->beacon = skb;
 	spin_unlock_bh(&ar->beacon_lock);
 	if (err)
-		goto out_unlock;
+		goto err_free;
 
 	if (submit) {
 		err = carl9170_bcn_ctrl(ar, cvif->id,
@@ -565,10 +569,18 @@ found:
 					addr, skb->len + FCS_LEN);
 
 		if (err)
-			goto out_unlock;
+			goto err_free;
 	}
 out_unlock:
 	rcu_read_unlock();
+	return 0;
+
+err_unlock:
+	spin_unlock_bh(&ar->beacon_lock);
+
+err_free:
+	rcu_read_unlock();
+	dev_kfree_skb_any(skb);
 	return err;
 }
 
-- 
1.7.2.3

