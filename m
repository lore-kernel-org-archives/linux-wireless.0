Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:42929 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758495AbZACP1U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 10:27:20 -0500
Received: by ewy10 with SMTP id 10so7156645ewy.13
        for <linux-wireless@vger.kernel.org>; Sat, 03 Jan 2009 07:27:17 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Fix rt2500usb HW crypto: WEP 128 & AES
Date: Sat, 3 Jan 2009 16:27:14 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901031627.14939.IvDoorn@gmail.com> (sfid-20090103_162724_907277_B69D64E3)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TXD_W0_CIPHER field is a 1-bit field. It only acts as boolean value
to indicate if the frame must be encrypted or not.

The way rt2x00_set_field32() worked it would grab the least signifcant bit
from txdesc->cipher and use that as value. Because of that WEP 64 and TKIP
worked since they had odd-numbered values, while WEP 128 and AES were
even numbers and didn't work.

Correctly booleanize the txdecs->cipher value to allow the hardware to
encrypt the outgoing data. After this we can enable HW crypto by default again.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 32435ba..2bc4e46 100644
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
 
@@ -1222,7 +1222,7 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			   test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skb->len);
-	rt2x00_set_field32(&word, TXD_W0_CIPHER, txdesc->cipher);
+	rt2x00_set_field32(&word, TXD_W0_CIPHER, !!txdesc->cipher);
 	rt2x00_set_field32(&word, TXD_W0_KEY_ID, txdesc->key_idx);
 	rt2x00_desc_write(txd, 0, word);
 }
