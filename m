Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:45385 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbYJNV6I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 17:58:08 -0400
Message-ID: <48F515D7.9030002@openwrt.org> (sfid-20081014_235812_152196_CD307AEA)
Date: Tue, 14 Oct 2008 23:57:43 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Stephen Blackheath <tramp.enshrine.stephen@blacksapphire.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ben Martel <benm@symmetric.co.nz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211 fix regression introduced by "mac80211: free up
 2 bytes in skb->cb"
References: <48F416A3.3060205@blacksapphire.com> <1223990364.10113.28.camel@johannes.berg>
In-Reply-To: <1223990364.10113.28.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hw_key pointer is used (and obviously NULL) after skb->cb is
memset to 0. This patch grabs the iv_len before the memset call.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Stephen Blackheath <tramp.enshrine.stephen@blacksapphire.com>

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 1676ac4..451d410 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -374,7 +374,7 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
 	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
 	struct txentry_desc txdesc;
 	struct skb_frame_desc *skbdesc;
-	unsigned int iv_len;
+	unsigned int iv_len = 0;
 
 	if (unlikely(rt2x00queue_full(queue)))
 		return -EINVAL;
@@ -395,6 +395,9 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
 	entry->skb = skb;
 	rt2x00queue_create_tx_descriptor(entry, &txdesc);
 
+	if (IEEE80211_SKB_CB(skb)->control.hw_key != NULL)
+		iv_len = IEEE80211_SKB_CB(skb)->control.hw_key->iv_len;
+
 	/*
 	 * All information is retreived from the skb->cb array,
 	 * now we should claim ownership of the driver part of that
@@ -410,9 +413,7 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
 	 * the frame so we can provide it to the driver seperately.
 	 */
 	if (test_bit(ENTRY_TXD_ENCRYPT, &txdesc.flags) &&
-	    !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc.flags) &&
-		(IEEE80211_SKB_CB(skb)->control.hw_key != NULL)) {
-		iv_len = IEEE80211_SKB_CB(skb)->control.hw_key->iv_len;
+	    !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc.flags)) {
 		rt2x00crypto_tx_remove_iv(skb, iv_len);
 	}
 
