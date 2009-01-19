Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:53970 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbZASPIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 10:08:42 -0500
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2 v2] p54: more cryptographic accelerator fixes
Cc: "John W. Linville" <linville@tuxdriver.com>
From: Christian Lamparter <chunkeey@web.de>
Date: Mon, 19 Jan 2009 16:08:48 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901191608.48853.chunkeey@web.de> (sfid-20090119_160850_481981_AE19AE85)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we let the firmware do the data encryption, we have to remove the ICV and
(M)MIC at the end of the frame before we can give it back to mac80211. 
Or, these data frames have a few trailing bytes on cooked monitor interfaces.
   
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
unfortunately v1 included "[PATCH 1/2] p54: add missing break in eeprom parser" changes.
---
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 9b6db82..45c2e7a 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -884,7 +884,7 @@ static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(entry);
 		struct p54_hdr *entry_hdr;
 		struct p54_tx_data *entry_data;
-		int pad = 0;
+		unsigned int pad = 0, frame_len;
 
 		range = (void *)info->rate_driver_data;
 		if (range->start_addr != addr) {
@@ -907,6 +907,7 @@ static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 		__skb_unlink(entry, &priv->tx_queue);
 		spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 
+		frame_len = entry->len;
 		entry_hdr = (struct p54_hdr *) entry->data;
 		entry_data = (struct p54_tx_data *) entry_hdr->data;
 		priv->tx_stats[entry_data->hw_queue].len--;
@@ -960,15 +961,28 @@ static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 		info->status.ack_signal = p54_rssi_to_dbm(dev,
 				(int)payload->ack_rssi);
 
-		if (entry_data->key_type == P54_CRYPTO_TKIPMICHAEL) {
+		/* Undo all changes to the frame. */
+		switch (entry_data->key_type) {
+		case P54_CRYPTO_TKIPMICHAEL: {
 			u8 *iv = (u8 *)(entry_data->align + pad +
-				        entry_data->crypt_offset);
+					entry_data->crypt_offset);
 
 			/* Restore the original TKIP IV. */
 			iv[2] = iv[0];
 			iv[0] = iv[1];
 			iv[1] = (iv[0] | 0x20) & 0x7f;	/* WEPSeed - 8.3.2.2 */
+
+			frame_len -= 12; /* remove TKIP_MMIC + TKIP_ICV */
+			break;
+			}
+		case P54_CRYPTO_AESCCMP:
+			frame_len -= 8; /* remove CCMP_MIC */
+			break;
+		case P54_CRYPTO_WEP:
+			frame_len -= 4; /* remove WEP_ICV */
+			break;
 		}
+		skb_trim(entry, frame_len);
 		skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
 		ieee80211_tx_status_irqsafe(dev, entry);
 		goto out;
