Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:47049 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbYLUWTW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 17:19:22 -0500
Received: by ewy10 with SMTP id 10so1937514ewy.13
        for <linux-wireless@vger.kernel.org>; Sun, 21 Dec 2008 14:19:20 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] Fix rt2500usb HW crypto: TKIP
Date: Sun, 21 Dec 2008 23:19:17 +0100
Cc: rt2400-devel@lists.sourceforge.net,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812212319.17794.IvDoorn@gmail.com> (sfid-20081221_231928_424210_751685D8)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2500usb doesn't strip the IV/ICV data from received frames,
so we don't need to set the RX_FLAG_IV_STRIPPED flag.
We do need to set the RX_FLAG_MMIC_STRIPPED flag for all
encryption types since the MMIC has been removed from the frame.

After this patch TKIP Hardware crypto works for rt2500usb.
WEP and AES are still failing.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 81400ea..32435ba 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -388,11 +388,11 @@ static int rt2500usb_config_key(struct rt2x00_dev *rt2x00dev,
 
 		/*
 		 * The driver does not support the IV/EIV generation
-		 * in hardware. However it doesn't support the IV/EIV
-		 * inside the ieee80211 frame either, but requires it
-		 * to be provided seperately for the descriptor.
-		 * rt2x00lib will cut the IV/EIV data out of all frames
-		 * given to us by mac80211, but we must tell mac80211
+		 * in hardware. However it demands the data to be provided
+		 * both seperately as well as inside the frame.
+		 * We already provided the CONFIG_CRYPTO_COPY_IV to rt2x00lib
+		 * to ensure rt2x00lib will not strip the data from the
+		 * frame after the copy, now we must tell mac80211
 		 * to generate the IV/EIV data.
 		 */
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
@@ -1375,14 +1375,7 @@ static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 
 		/* ICV is located at the end of frame */
 
-		/*
-		 * Hardware has stripped IV/EIV data from 802.11 frame during
-		 * decryption. It has provided the data seperately but rt2x00lib
-		 * should decide if it should be reinserted.
-		 */
-		rxdesc->flags |= RX_FLAG_IV_STRIPPED;
-		if (rxdesc->cipher != CIPHER_TKIP)
-			rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;
+		rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;
 		if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS)
 			rxdesc->flags |= RX_FLAG_DECRYPTED;
 		else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
	
