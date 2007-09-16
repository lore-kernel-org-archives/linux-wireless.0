Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:38346 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXIPMIN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:08:13 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1643781wah
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:08:13 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/24] rt2x00: Fix system freeze on device removal
Date: Sun, 16 Sep 2007 14:18:49 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161418.51894.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a PCI device is unplugged reading from the
register will return the value from the state of just
before the device is unplugged.

When a rt61pci device was removed while the txdone
handler was running it ended in a endless loop because
it would run the txdone handler from the same frame
(the one last indicated by STA_CSR4) over and over again.

Check in the loop if the freshly read register value is
the same as the previously one and bail out if this is the case.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 6199606..0c53b61 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1801,23 +1801,37 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 	struct data_desc *txd;
 	u32 word;
 	u32 reg;
+	u32 old_reg;
+	int type;
 	int index;
 	int tx_status;
 	int retry;
 
+	/*
+	 * During each loop we will compare the freshly read
+	 * STA_CSR4 register value with the value read from
+	 * the previous loop. If the 2 values are equal then
+	 * we should stop processing because the chance it
+	 * quite big that the device has been unplugged and
+	 * we risk going into an endless loop.
+	 */
+	old_reg = 0;
+
 	while (1) {
 		rt2x00pci_register_read(rt2x00dev, STA_CSR4, &reg);
 		if (!rt2x00_get_field32(reg, STA_CSR4_VALID))
 			break;
 
+		if (old_reg == reg)
+			break;
+		old_reg = reg;
+
 		/*
 		 * Skip this entry when it contains an invalid
 		 * ring identication number.
 		 */
-		ring =
-		    rt2x00lib_get_ring(rt2x00dev,
-				       rt2x00_get_field32(reg,
-							  STA_CSR4_PID_TYPE));
+		type = rt2x00_get_field32(reg, STA_CSR4_PID_TYPE);
+		ring = rt2x00lib_get_ring(rt2x00dev, type);
 		if (unlikely(!ring))
 			continue;
 
-- 
1.5.3
