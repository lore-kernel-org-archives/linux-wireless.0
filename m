Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:48336 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbYK2Vfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 16:35:46 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 4/6] p54: include support for 2.13.24.0 USB LM87 Firmwares
Date: Sat, 29 Nov 2008 22:35:43 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200811292235.44293.chunkeey@web.de> (sfid-20081129_223550_055911_A282A1A8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Those firmwares are probably capable of reprogramming the device's eeprom.
We better support them officially, before all the accidents happen.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-11-29 21:34:07.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-11-29 21:34:12.000000000 +0100
@@ -740,7 +740,13 @@ static void p54_rx_eeprom_readback(struc
 	if (!priv->eeprom)
 		return ;
 
-	memcpy(priv->eeprom, eeprom->data, le16_to_cpu(eeprom->len));
+	if (priv->fw_var >= 0x509) {
+		memcpy(priv->eeprom, eeprom->v2.data,
+		       le16_to_cpu(eeprom->v2.len));
+	} else {
+		memcpy(priv->eeprom, eeprom->v1.data,
+		       le16_to_cpu(eeprom->v1.len));
+	}
 
 	complete(&priv->eeprom_comp);
 }
@@ -941,12 +947,18 @@ int p54_read_eeprom(struct ieee80211_hw 
 	struct p54_hdr *hdr = NULL;
 	struct p54_eeprom_lm86 *eeprom_hdr;
 	struct sk_buff *skb;
-	size_t eeprom_size = 0x2020, offset = 0, blocksize;
+	size_t eeprom_size = 0x2020, offset = 0, blocksize, maxblocksize;
 	int ret = -ENOMEM;
 	void *eeprom = NULL;
 
-	skb = p54_alloc_skb(dev, 0x8000, sizeof(*hdr) + sizeof(*eeprom_hdr) +
-			    EEPROM_READBACK_LEN,
+	maxblocksize = EEPROM_READBACK_LEN;
+	if (priv->fw_var >= 0x509)
+		maxblocksize -= 0xc;
+	else
+		maxblocksize -= 0x4;
+
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL, sizeof(*hdr) +
+			    sizeof(*eeprom_hdr) + maxblocksize,
 			    P54_CONTROL_TYPE_EEPROM_READBACK, GFP_KERNEL);
 	if (!skb)
 		goto free;
@@ -958,12 +970,19 @@ int p54_read_eeprom(struct ieee80211_hw 
 		goto free;
 
 	eeprom_hdr = (struct p54_eeprom_lm86 *) skb_put(skb,
-		     sizeof(*eeprom_hdr) + EEPROM_READBACK_LEN);
+		     sizeof(*eeprom_hdr) + maxblocksize);
 
 	while (eeprom_size) {
-		blocksize = min(eeprom_size, (size_t)EEPROM_READBACK_LEN);
-		eeprom_hdr->offset = cpu_to_le16(offset);
-		eeprom_hdr->len = cpu_to_le16(blocksize);
+		blocksize = min(eeprom_size, maxblocksize);
+		if (priv->fw_var < 0x509) {
+			eeprom_hdr->v1.offset = cpu_to_le16(offset);
+			eeprom_hdr->v1.len = cpu_to_le16(blocksize);
+		} else {
+			eeprom_hdr->v2.offset = cpu_to_le32(offset);
+			eeprom_hdr->v2.len = cpu_to_le16(blocksize);
+			eeprom_hdr->v2.magic2 = 0xf;
+			memcpy(eeprom_hdr->v2.magic, (const char *)"LOCK", 4);
+		}
 		priv->tx(dev, skb, 0);
 
 		if (!wait_for_completion_interruptible_timeout(&priv->eeprom_comp, HZ)) {
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-11-28 21:48:03.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.h	2008-11-28 21:49:25.000000000 +0100
@@ -246,9 +246,21 @@ struct memrecord {
 };
 
 struct p54_eeprom_lm86 {
-	__le16 offset;
-	__le16 len;
-	u8 data[0];
+	union {
+		struct {
+			__le16 offset;
+			__le16 len;
+			u8 data[0];
+		} v1;
+		struct {
+			__le32 offset;
+			__le16 len;
+			u8 magic2;
+			u8 pad;
+			u8 magic[4];
+			u8 data[0];
+		} v2;
+	}  __attribute__ ((packed));
 } __attribute__ ((packed));
 
 enum p54_rx_decrypt_status {
