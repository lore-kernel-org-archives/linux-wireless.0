Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:60044 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266AbZFPSqx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 14:46:53 -0400
Received: by ewy6 with SMTP id 6so6271502ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 11:46:55 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH] rt2x00: remove skb->do_not_encrypt usage
Date: Tue, 16 Jun 2009 20:46:45 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200906162046.45728.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

Johannes is trying to get rid of the master netdev and in the process will
remove skb->do_not_encrypt field. This removes the do_not_encrypt
usage from rt2x00 to make the change easier.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00crypto.c b/drivers/net/wireless/rt2x00/rt2x00crypto.c
index 57ab42c..3ef26f5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00crypto.c
+++ b/drivers/net/wireless/rt2x00/rt2x00crypto.c
@@ -53,8 +53,7 @@ void rt2x00crypto_create_tx_descriptor(struct queue_entry *entry,
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
 	struct ieee80211_key_conf *hw_key = tx_info->control.hw_key;
 
-	if (!test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags) ||
-	    !hw_key || entry->skb->do_not_encrypt)
+	if (!test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags) || !hw_key)
 		return;
 
 	__set_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags);
@@ -82,8 +81,7 @@ unsigned int rt2x00crypto_tx_overhead(struct rt2x00_dev *rt2x00dev,
 	struct ieee80211_key_conf *key = tx_info->control.hw_key;
 	unsigned int overhead = 0;
 
-	if (!test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags) ||
-	    !key || skb->do_not_encrypt)
+	if (!test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags) || !key)
 		return overhead;
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index c4c06b4..475a3ed 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -73,7 +73,8 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 	else
 		rts_info->flags &= ~IEEE80211_TX_CTL_NO_ACK;
 
-	skb->do_not_encrypt = 1;
+	/* Disable hardware encryption */
+	rts_info->control.hw_key = NULL;
 
 	/*
 	 * RTS/CTS frame should use the length of the frame plus any
