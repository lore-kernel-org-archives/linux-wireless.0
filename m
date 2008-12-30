Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.178]:53848 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbYL3TzW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 14:55:22 -0500
Received: by ik-out-1112.google.com with SMTP id c29so1128729ika.5
        for <linux-wireless@vger.kernel.org>; Tue, 30 Dec 2008 11:55:20 -0800 (PST)
To: rt2400-devel@lists.sourceforge.net
Subject: HW CRYPTO: rt2500usb
Date: Tue, 30 Dec 2008 20:55:17 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812302055.18017.IvDoorn@gmail.com> (sfid-20081230_205527_955646_280FAB96)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Currently HW crypto support has been implemented for rt2500usb,
but has been disabled by default since it only works for TKIP.
I am currently investigating why WEP and AES are failing, I am currently
hitting a deadend so I hope somebody else has some suggestions.

With the current implementation which works for TKIP I noticed that WEP128
and AES will neither transmit any data after the succesfull association. Upon
investigation I discovered that below patch was required to make the transmitting
of frames possible, _but_ none of the frames receive a proper reply from the AP.

The strange part is that the data length of the frame must be increased by a number
of bytes depending on the crypto algorithm. From what I gather, the value most likely
represents the icv_len value from the ieee80211_key structure. The weird part is that
TKIP apparently does not require this additional length.

So far I haven't found the legacy driver adding these extra bytes to the length either,
which sounds a bit suspicious as well.

Frames caught using wireshark from a second computer look a bit suspicious,
a ping command from my PC will be received as broadcast frames on wireshark
with a size of 32 bytes. (I have changed the size of the ping request, but the received
frames don't change in size)

I'll try to do some more research later this week, but hopefully somebody has some
suggestions on where to look for me. :)

Thanks,

Ivo

---
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 32435ba..283a597 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -38,7 +38,7 @@
 /*
  * Allow hardware encryption to be disabled.
  */
-static int modparam_nohwcrypt = 1;
+static int modparam_nohwcrypt = 0;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
@@ -1185,6 +1185,7 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
 	__le32 *txd = skbdesc->desc;
 	u32 word;
+	unsigned int overhead = 0;
 
 	/*
 	 * Start writing the descriptor words.
@@ -1206,6 +1207,11 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	if (test_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags)) {
 		_rt2x00_desc_write(txd, 3, skbdesc->iv[0]);
 		_rt2x00_desc_write(txd, 4, skbdesc->iv[1]);
+
+		if (txdesc->cipher == CIPHER_WEP64 || txdesc->cipher == CIPHER_WEP128)
+			overhead += 4;
+		else if (txdesc->cipher == CIPHER_AES)
+			overhead += 8;
 	}
 
 	rt2x00_desc_read(txd, 0, &word);
@@ -1221,7 +1227,7 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_NEW_SEQ,
 			   test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
-	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skb->len);
+	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skb->len + overhead);
 	rt2x00_set_field32(&word, TXD_W0_CIPHER, txdesc->cipher);
 	rt2x00_set_field32(&word, TXD_W0_KEY_ID, txdesc->key_idx);
 	rt2x00_desc_write(txd, 0, word);
