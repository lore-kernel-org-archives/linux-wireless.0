Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36123 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab0IHS6U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 14:58:20 -0400
Received: by mail-ew0-f46.google.com with SMTP id 23so343042ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 11:58:19 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/06] rt2x00: Enable missing interrupts in rt61pci
Date: Wed, 8 Sep 2010 20:57:10 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201009082055.38033.IvDoorn@gmail.com> <201009082056.33182.IvDoorn@gmail.com> <201009082056.53759.IvDoorn@gmail.com>
In-Reply-To: <201009082056.53759.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009082057.11427.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

We're handling both, the CSR_BEACON_DONE and the CSR_TWAKEUP interrupts
in rt61pci. However, these interrupts are masked out by default. Fix
this.

Found via pure code inspection.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 042cfbe..4aec344 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1654,6 +1654,7 @@ static void rt61pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_read(rt2x00dev, INT_MASK_CSR, &reg);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_TXDONE, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_RXDONE, mask);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_BEACON_DONE, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_ENABLE_MITIGATION, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_MITIGATION_PERIOD, 0xff);
 	rt2x00pci_register_write(rt2x00dev, INT_MASK_CSR, reg);
@@ -1667,6 +1668,7 @@ static void rt61pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, MCU_INT_MASK_CSR_5, mask);
 	rt2x00_set_field32(&reg, MCU_INT_MASK_CSR_6, mask);
 	rt2x00_set_field32(&reg, MCU_INT_MASK_CSR_7, mask);
+	rt2x00_set_field32(&reg, MCU_INT_MASK_CSR_TWAKEUP, mask);
 	rt2x00pci_register_write(rt2x00dev, MCU_INT_MASK_CSR, reg);
 }
 
-- 
1.7.2.2

