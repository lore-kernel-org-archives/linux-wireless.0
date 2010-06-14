Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:49407 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab0FNUP2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 16:15:28 -0400
Received: by mail-ww0-f46.google.com with SMTP id 18so4215976wwb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 13:15:28 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 14/14] rt2x00: Synchronize WCID initialization with legacy driver
Date: Mon, 14 Jun 2010 22:14:19 +0200
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006142208.31736.IvDoorn@gmail.com> <201006142213.38654.IvDoorn@gmail.com> <201006142213.57748.IvDoorn@gmail.com>
In-Reply-To: <201006142213.57748.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006142214.20934.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

Legacy rt2870 driver handles WCID differently then we expected,
the BSSID and Cipher value are 3 bit values, while the 4th bit
should be set elsewhere in an extended field.

After this, rt2800usb reports frames have been decrypted
successfully, indicating that the Hardware decryption now is
working correctly.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    4 ++++
 drivers/net/wireless/rt2x00/rt2800lib.c |   31 ++++++++++++++++++++++---------
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index b308421..3ed87ba 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1436,6 +1436,10 @@ struct mac_iveiv_entry {
 #define MAC_WCID_ATTRIBUTE_CIPHER	FIELD32(0x0000000e)
 #define MAC_WCID_ATTRIBUTE_BSS_IDX	FIELD32(0x00000070)
 #define MAC_WCID_ATTRIBUTE_RX_WIUDF	FIELD32(0x00000380)
+#define MAC_WCID_ATTRIBUTE_CIPHER_EXT	FIELD32(0x00000400)
+#define MAC_WCID_ATTRIBUTE_BSS_IDX_EXT	FIELD32(0x00000800)
+#define MAC_WCID_ATTRIBUTE_WAPI_MCBC	FIELD32(0x00008000)
+#define MAC_WCID_ATTRIBUTE_WAPI_KEY_IDX	FIELD32(0xff000000)
 
 /*
  * SHARED_KEY_MODE:
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index a83477a..636bfd6 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -554,15 +554,28 @@ static void rt2800_config_wcid_attr(struct rt2x00_dev *rt2x00dev,
 
 	offset = MAC_WCID_ATTR_ENTRY(key->hw_key_idx);
 
-	rt2800_register_read(rt2x00dev, offset, &reg);
-	rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_KEYTAB,
-			   !!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE));
-	rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_CIPHER,
-			   (crypto->cmd == SET_KEY) * crypto->cipher);
-	rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_BSS_IDX,
-			   (crypto->cmd == SET_KEY) * crypto->bssidx);
-	rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_RX_WIUDF, crypto->cipher);
-	rt2800_register_write(rt2x00dev, offset, reg);
+	if (crypto->cmd == SET_KEY) {
+		rt2800_register_read(rt2x00dev, offset, &reg);
+		rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_KEYTAB,
+				   !!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE));
+		/*
+		 * Both the cipher as the BSS Idx numbers are split in a main
+		 * value of 3 bits, and a extended field for adding one additional
+		 * bit to the value.
+		 */
+		rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_CIPHER,
+				   (crypto->cipher & 0x7));
+		rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_CIPHER_EXT,
+				   (crypto->cipher & 0x8) >> 3);
+		rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_BSS_IDX,
+				   (crypto->bssidx & 0x7));
+		rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_BSS_IDX_EXT,
+				   (crypto->bssidx & 0x8) >> 3);
+		rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_RX_WIUDF, crypto->cipher);
+		rt2800_register_write(rt2x00dev, offset, reg);
+	} else {
+		rt2800_register_write(rt2x00dev, offset, 0);
+	}
 
 	offset = MAC_IVEIV_ENTRY(key->hw_key_idx);
 
-- 
1.6.6.1

