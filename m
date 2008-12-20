Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:33407 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbYLTBVk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 20:21:40 -0500
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] p54: crypto offload fixes
Date: Sat, 20 Dec 2008 02:21:37 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812200221.38233.chunkeey@web.de> (sfid-20081220_022145_537990_566F0E4A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes two small flaws:
 - restore the original TKIP IV if we altered it.
 - reserve & initialize ICV with zeros.
   This is actually only necessary for some obsolete p54usb firmwares.
   But we don't know yet, if all devices are compatible with the new revisions.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
According to my GiB of USBlogs txhdr->crypt_offset is not used by firmwares.
So we can reallocate it for our purpose, if we have to.
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-12-20 00:26:19.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-12-20 01:06:18.000000000 +0100
@@ -799,6 +799,16 @@ static void p54_rx_frame_sent(struct iee
 			info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
 		info->status.ack_signal = p54_rssi_to_dbm(dev,
 				(int)payload->ack_rssi);
+
+		if (entry_data->key_type == P54_CRYPTO_TKIPMICHAEL) {
+			u8 *iv = (u8 *)(entry_data->align + pad +
+				        entry_data->crypt_offset);
+
+			/* Restore the original TKIP IV. */
+			iv[2] = iv[0];
+			iv[0] = iv[1];
+			iv[1] = (iv[0] | 0x20) & 0x7f;	/* WEPSeed - 8.3.2.2 */
+		}
 		skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
 		ieee80211_tx_status_irqsafe(dev, entry);
 		goto out;
@@ -1384,7 +1394,6 @@ static int p54_tx(struct ieee80211_hw *d
 	hdr->tries = ridx;
 	txhdr->rts_rate_idx = 0;
 	if (info->control.hw_key) {
-		crypt_offset += info->control.hw_key->iv_len;
 		txhdr->key_type = p54_convert_algo(info->control.hw_key->alg);
 		txhdr->key_len = min((u8)16, info->control.hw_key->keylen);
 		memcpy(txhdr->key, info->control.hw_key->key, txhdr->key_len);
@@ -1398,6 +1407,8 @@ static int p54_tx(struct ieee80211_hw *d
 		}
 		/* reserve some space for ICV */
 		len += info->control.hw_key->icv_len;
+		memset(skb_put(skb, info->control.hw_key->icv_len), 0,
+		       info->control.hw_key->icv_len);
 	} else {
 		txhdr->key_type = 0;
 		txhdr->key_len = 0;
