Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f12.google.com ([209.85.219.12]:61541 "EHLO
	mail-ew0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764765AbZAQTty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jan 2009 14:49:54 -0500
Received: by ewy5 with SMTP id 5so347359ewy.13
        for <linux-wireless@vger.kernel.org>; Sat, 17 Jan 2009 11:49:51 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 2/3] rt2x00: conf_tx() only need register access for WMM queues
Date: Sat, 17 Jan 2009 20:42:58 +0100
Cc: linux-wireless@vger.kernel.org
References: <200901172042.32618.IvDoorn@gmail.com>
In-Reply-To: <200901172042.32618.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901172042.58545.IvDoorn@gmail.com> (sfid-20090117_205003_595383_4F8F1D87)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

conf_tx() in rt61pci and rt73usb only have to check once
if the queue_idx indicates a non-WMM queue and break of
the function immediately if that is the case.

Only the WMM queues need to have the TX configuration written
to the registers.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |   30 +++++++++++++++---------------
 drivers/net/wireless/rt2x00/rt73usb.c |   30 +++++++++++++++---------------
 2 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index b07b41f..760821f 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2659,6 +2659,7 @@ static int rt61pci_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 	struct rt2x00_field32 field;
 	int retval;
 	u32 reg;
+	u32 offset;
 
 	/*
 	 * First pass the configuration through rt2x00lib, that will
@@ -2670,24 +2671,23 @@ static int rt61pci_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 	if (retval)
 		return retval;
 
+	/*
+	 * We only need to perform additional register initialization
+	 * for WMM queues/
+	 */
+	if (queue_idx >= 4)
+		return 0;
+
 	queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
 
 	/* Update WMM TXOP register */
-	if (queue_idx < 2) {
-		field.bit_offset = queue_idx * 16;
-		field.bit_mask = 0xffff << field.bit_offset;
-
-		rt2x00pci_register_read(rt2x00dev, AC_TXOP_CSR0, &reg);
-		rt2x00_set_field32(&reg, field, queue->txop);
-		rt2x00pci_register_write(rt2x00dev, AC_TXOP_CSR0, reg);
-	} else if (queue_idx < 4) {
-		field.bit_offset = (queue_idx - 2) * 16;
-		field.bit_mask = 0xffff << field.bit_offset;
-
-		rt2x00pci_register_read(rt2x00dev, AC_TXOP_CSR1, &reg);
-		rt2x00_set_field32(&reg, field, queue->txop);
-		rt2x00pci_register_write(rt2x00dev, AC_TXOP_CSR1, reg);
-	}
+	offset = AC_TXOP_CSR0 + (sizeof(u32) * (!!(queue_idx & 2)));
+	field.bit_offset = (queue_idx & 1) * 16;
+	field.bit_mask = 0xffff << field.bit_offset;
+
+	rt2x00pci_register_read(rt2x00dev, offset, &reg);
+	rt2x00_set_field32(&reg, field, queue->txop);
+	rt2x00pci_register_write(rt2x00dev, offset, reg);
 
 	/* Update WMM registers */
 	field.bit_offset = queue_idx * 4;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index d64c7cf..48057d8 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2182,6 +2182,7 @@ static int rt73usb_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 	struct rt2x00_field32 field;
 	int retval;
 	u32 reg;
+	u32 offset;
 
 	/*
 	 * First pass the configuration through rt2x00lib, that will
@@ -2193,24 +2194,23 @@ static int rt73usb_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 	if (retval)
 		return retval;
 
+	/*
+	 * We only need to perform additional register initialization
+	 * for WMM queues/
+	 */
+	if (queue_idx >= 4)
+		return 0;
+
 	queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
 
 	/* Update WMM TXOP register */
-	if (queue_idx < 2) {
-		field.bit_offset = queue_idx * 16;
-		field.bit_mask = 0xffff << field.bit_offset;
-
-		rt2x00usb_register_read(rt2x00dev, AC_TXOP_CSR0, &reg);
-		rt2x00_set_field32(&reg, field, queue->txop);
-		rt2x00usb_register_write(rt2x00dev, AC_TXOP_CSR0, reg);
-	} else if (queue_idx < 4) {
-		field.bit_offset = (queue_idx - 2) * 16;
-		field.bit_mask = 0xffff << field.bit_offset;
-
-		rt2x00usb_register_read(rt2x00dev, AC_TXOP_CSR1, &reg);
-		rt2x00_set_field32(&reg, field, queue->txop);
-		rt2x00usb_register_write(rt2x00dev, AC_TXOP_CSR1, reg);
-	}
+	offset = AC_TXOP_CSR0 + (sizeof(u32) * (!!(queue_idx & 2)));
+	field.bit_offset = (queue_idx & 1) * 16;
+	field.bit_mask = 0xffff << field.bit_offset;
+
+	rt2x00usb_register_read(rt2x00dev, offset, &reg);
+	rt2x00_set_field32(&reg, field, queue->txop);
+	rt2x00usb_register_write(rt2x00dev, offset, reg);
 
 	/* Update WMM registers */
 	field.bit_offset = queue_idx * 4;
-- 
1.5.6.1

