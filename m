Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:54851 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZK1Xym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 18:54:42 -0500
Received: by fxm5 with SMTP id 5so2617333fxm.28
        for <linux-wireless@vger.kernel.org>; Sat, 28 Nov 2009 15:54:48 -0800 (PST)
To: linux-wireless@vger.kernel.org
Subject: [PATCH 4/5] ar9170: small misc changes
Cc: John W Linville <linville@tuxdriver.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 29 Nov 2009 00:59:48 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911290059.48760.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch aggregates a bunch of small random changes 
that won't fit really anywhere else properly.

1. move tid-locating macro into a separate function.

2. remove redundant NULL check.

3. add modulation mask definition

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index d8ecf85..20f04ab 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -194,12 +194,15 @@ static inline u16 ar9170_get_seq(struct sk_buff *skb)
 	return ar9170_get_seq_h((void *) txc->frame_data);
 }
 
+static inline u16 ar9170_get_tid_h(struct ieee80211_hdr *hdr)
+{
+	return (ieee80211_get_qos_ctl(hdr))[0] & IEEE80211_QOS_CTL_TID_MASK;
+}
+
 static inline u16 ar9170_get_tid(struct sk_buff *skb)
 {
 	struct ar9170_tx_control *txc = (void *) skb->data;
-	struct ieee80211_hdr *hdr = (void *) txc->frame_data;
-
-	return (ieee80211_get_qos_ctl(hdr))[0] & IEEE80211_QOS_CTL_TID_MASK;
+	return ar9170_get_tid_h((struct ieee80211_hdr *) txc->frame_data);
 }
 
 #define GET_NEXT_SEQ(seq)	((seq + 1) & 0x0fff)
@@ -1660,8 +1663,7 @@ static bool ar9170_tx_ampdu(struct ar9170 *ar)
 		 * tell the FW/HW that this is the last frame,
 		 * that way it will wait for the immediate block ack.
 		 */
-		if (likely(skb_peek_tail(&agg)))
-			ar9170_tx_indicate_immba(ar, skb_peek_tail(&agg));
+		ar9170_tx_indicate_immba(ar, skb_peek_tail(&agg));
 
 #ifdef AR9170_TXAGG_DEBUG
 		printk(KERN_DEBUG "%s: generated A-MPDU looks like this:\n",
diff --git a/drivers/net/wireless/ath/ar9170/hw.h b/drivers/net/wireless/ath/ar9170/hw.h
index 701ddb7..0a1d4c2 100644
--- a/drivers/net/wireless/ath/ar9170/hw.h
+++ b/drivers/net/wireless/ath/ar9170/hw.h
@@ -276,6 +276,7 @@ struct ar9170_tx_control {
 #define AR9170_TX_MAC_RATE_PROBE		0x8000
 
 /* either-or */
+#define AR9170_TX_PHY_MOD_MASK			0x00000003
 #define AR9170_TX_PHY_MOD_CCK			0x00000000
 #define AR9170_TX_PHY_MOD_OFDM			0x00000001
 #define AR9170_TX_PHY_MOD_HT			0x00000002
