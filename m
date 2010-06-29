Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:37088 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab0F2TvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:51:16 -0400
Received: by mail-ww0-f46.google.com with SMTP id 18so553wwb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 12:51:15 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 15/21] rt2x00: Fix beacon updates in rt61pci
Date: Tue, 29 Jun 2010 21:47:10 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006292138.13509.IvDoorn@gmail.com> <201006292145.32554.IvDoorn@gmail.com> <201006292146.44952.IvDoorn@gmail.com>
In-Reply-To: <201006292146.44952.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006292147.11774.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Fix rt61pci beacon updates in the same way as rt2800pci. rt61pci didn't
update the beacon template after each beacon interval, resulting in the
DTIM count being incorrect (if DTIM period > 1). Fix this by calling
rt2x00lib_beacondone after the current beacon was sent out.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 1e74f8c..0123fbc 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2200,6 +2200,12 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 	if (rt2x00_get_field32(reg_mcu, MCU_INT_SOURCE_CSR_TWAKEUP))
 		rt61pci_wakeup(rt2x00dev);
 
+	/*
+	 * 5 - Beacon done interrupt.
+	 */
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_BEACON_DONE))
+		rt2x00lib_beacondone(rt2x00dev);
+
 	return IRQ_HANDLED;
 }
 
-- 
1.6.6.1

