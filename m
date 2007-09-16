Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:52973 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbXIPMId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:08:33 -0400
Received: by an-out-0708.google.com with SMTP id d31so189208and
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:08:33 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 20/24] rt2x00: Fix channel initialization
Date: Sun, 16 Sep 2007 14:19:29 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161419.30939.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the channel locking code of rt61 and rt73 into a seperate
function since both config_channel and config_txpower have exactly
the same code.

Use the BBP_R3_SMART_MODE define when we are working with the
BBP R3 register. Also optimize the code by removing the if-statement.

The BBP R94 must be initialized during the channel setup as well,
the value depends on the txpower.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |  104 +++++++++++++++------------------
 drivers/net/wireless/rt2x00/rt73usb.c |  104 +++++++++++++++------------------
 2 files changed, 94 insertions(+), 114 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index a2d852f..6baa651 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -452,58 +452,67 @@ static void rt61pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 	rt61pci_config_rate(rt2x00dev, rate->val2);
 }
 
-static void rt61pci_config_channel(struct rt2x00_dev *rt2x00dev,
-				   const int index, const int channel,
-				   const int txpower)
+static void rt61pci_config_lock_channel(struct rt2x00_dev *rt2x00dev,
+					struct rf_channel *rf,
+					const int txpower)
 {
-	struct rf_channel reg;
-	u8 bbp = 0;
+	u8 r3;
+	u8 r94;
+	u8 smart;
 
-	/*
-	 * Fill rf_reg structure.
-	 */
-	memcpy(&reg, &rt2x00dev->spec.channels[index], sizeof(reg));
+	rt2x00_set_field32(&rf->rf3, RF3_TXPOWER, TXPOWER_TO_DEV(txpower));
+	rt2x00_set_field32(&rf->rf4, RF4_FREQ_OFFSET, rt2x00dev->freq_offset);
 
-	/*
-	 * Set TXpower.
-	 */
-	rt2x00_set_field32(&reg.rf3, RF3_TXPOWER, TXPOWER_TO_DEV(txpower));
+	smart = !(rt2x00_rf(&rt2x00dev->chip, RF5225) ||
+		  rt2x00_rf(&rt2x00dev->chip, RF2527));
 
-	/*
-	 * Set Frequency offset.
-	 */
-	rt2x00_set_field32(&reg.rf4, RF4_FREQ_OFFSET, rt2x00dev->freq_offset);
+	rt61pci_bbp_read(rt2x00dev, 3, &r3);
+	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE, smart);
+	rt61pci_bbp_write(rt2x00dev, 3, r3);
+
+	r94 = 6;
+	if (txpower > MAX_TXPOWER && txpower <= (MAX_TXPOWER + r94))
+		r94 += txpower - MAX_TXPOWER;
+	else if (txpower < MIN_TXPOWER && txpower >= (MIN_TXPOWER - r94))
+		r94 += txpower;
+	rt61pci_bbp_write(rt2x00dev, 94, r94);
 
-	rt61pci_rf_write(rt2x00dev, 1, reg.rf1);
-	rt61pci_rf_write(rt2x00dev, 2, reg.rf2);
-	rt61pci_rf_write(rt2x00dev, 3, reg.rf3 & ~0x00000004);
-	rt61pci_rf_write(rt2x00dev, 4, reg.rf4);
+	rt61pci_rf_write(rt2x00dev, 1, rf->rf1);
+	rt61pci_rf_write(rt2x00dev, 2, rf->rf2);
+	rt61pci_rf_write(rt2x00dev, 3, rf->rf3 & ~0x00000004);
+	rt61pci_rf_write(rt2x00dev, 4, rf->rf4);
 
 	udelay(200);
 
-	rt61pci_rf_write(rt2x00dev, 1, reg.rf1);
-	rt61pci_rf_write(rt2x00dev, 2, reg.rf2);
-	rt61pci_rf_write(rt2x00dev, 3, reg.rf3 | 0x00000004);
-	rt61pci_rf_write(rt2x00dev, 4, reg.rf4);
+	rt61pci_rf_write(rt2x00dev, 1, rf->rf1);
+	rt61pci_rf_write(rt2x00dev, 2, rf->rf2);
+	rt61pci_rf_write(rt2x00dev, 3, rf->rf3 | 0x00000004);
+	rt61pci_rf_write(rt2x00dev, 4, rf->rf4);
 
 	udelay(200);
 
-	rt61pci_rf_write(rt2x00dev, 1, reg.rf1);
-	rt61pci_rf_write(rt2x00dev, 2, reg.rf2);
-	rt61pci_rf_write(rt2x00dev, 3, reg.rf3 & ~0x00000004);
-	rt61pci_rf_write(rt2x00dev, 4, reg.rf4);
-
-	rt61pci_bbp_read(rt2x00dev, 3, &bbp);
-	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF2527))
-		bbp &= ~0x01;
-	else
-		bbp |= 0x01;
-	rt61pci_bbp_write(rt2x00dev, 3, bbp);
+	rt61pci_rf_write(rt2x00dev, 1, rf->rf1);
+	rt61pci_rf_write(rt2x00dev, 2, rf->rf2);
+	rt61pci_rf_write(rt2x00dev, 3, rf->rf3 & ~0x00000004);
+	rt61pci_rf_write(rt2x00dev, 4, rf->rf4);
 
 	msleep(1);
 }
 
+static void rt61pci_config_channel(struct rt2x00_dev *rt2x00dev,
+				   const int index, const int channel,
+				   const int txpower)
+{
+	struct rf_channel rf;
+
+	/*
+	 * Fill rf_reg structure.
+	 */
+	memcpy(&rf, &rt2x00dev->spec.channels[index], sizeof(rf));
+
+	rt61pci_config_lock_channel(rt2x00dev, &rf, txpower);
+}
+
 static void rt61pci_config_txpower(struct rt2x00_dev *rt2x00dev,
 				   const int txpower)
 {
@@ -514,26 +523,7 @@ static void rt61pci_config_txpower(struct rt2x00_dev *rt2x00dev,
 	rt2x00_rf_read(rt2x00dev, 3, &rf.rf3);
 	rt2x00_rf_read(rt2x00dev, 4, &rf.rf4);
 
-	rt2x00_set_field32(&rf.rf3, RF3_TXPOWER, TXPOWER_TO_DEV(txpower));
-
-	rt61pci_rf_write(rt2x00dev, 1, rf.rf1);
-	rt61pci_rf_write(rt2x00dev, 2, rf.rf2);
-	rt61pci_rf_write(rt2x00dev, 3, rf.rf3 & ~0x00000004);
-	rt61pci_rf_write(rt2x00dev, 4, rf.rf4);
-
-	udelay(200);
-
-	rt61pci_rf_write(rt2x00dev, 1, rf.rf1);
-	rt61pci_rf_write(rt2x00dev, 2, rf.rf2);
-	rt61pci_rf_write(rt2x00dev, 3, rf.rf3 | 0x00000004);
-	rt61pci_rf_write(rt2x00dev, 4, rf.rf4);
-
-	udelay(200);
-
-	rt61pci_rf_write(rt2x00dev, 1, rf.rf1);
-	rt61pci_rf_write(rt2x00dev, 2, rf.rf2);
-	rt61pci_rf_write(rt2x00dev, 3, rf.rf3 & ~0x00000004);
-	rt61pci_rf_write(rt2x00dev, 4, rf.rf4);
+	rt61pci_config_lock_channel(rt2x00dev, &rf, txpower);
 }
 
 static void rt61pci_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 67a6644..f7017a8 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -428,52 +428,61 @@ static void rt73usb_config_phymode(struct rt2x00_dev *rt2x00dev,
 	rt73usb_config_rate(rt2x00dev, rate->val2);
 }
 
+static void rt73usb_config_lock_channel(struct rt2x00_dev *rt2x00dev,
+					struct rf_channel *rf,
+					const int txpower)
+{
+	u8 r3;
+	u8 r94;
+	u8 smart;
+
+	rt2x00_set_field32(&rf->rf3, RF3_TXPOWER, TXPOWER_TO_DEV(txpower));
+	rt2x00_set_field32(&rf->rf4, RF4_FREQ_OFFSET, rt2x00dev->freq_offset);
+
+	smart = !(rt2x00_rf(&rt2x00dev->chip, RF5225) ||
+		  rt2x00_rf(&rt2x00dev->chip, RF2527));
+
+	rt73usb_bbp_read(rt2x00dev, 3, &r3);
+	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE, smart);
+	rt73usb_bbp_write(rt2x00dev, 3, r3);
+
+	r94 = 6;
+	if (txpower > MAX_TXPOWER && txpower <= (MAX_TXPOWER + r94))
+		r94 += txpower - MAX_TXPOWER;
+	else if (txpower < MIN_TXPOWER && txpower >= (MIN_TXPOWER - r94))
+		r94 += txpower;
+	rt73usb_bbp_write(rt2x00dev, 94, r94);
+
+	rt73usb_rf_write(rt2x00dev, 1, rf->rf1);
+	rt73usb_rf_write(rt2x00dev, 2, rf->rf2);
+	rt73usb_rf_write(rt2x00dev, 3, rf->rf3 & ~0x00000004);
+	rt73usb_rf_write(rt2x00dev, 4, rf->rf4);
+
+	rt73usb_rf_write(rt2x00dev, 1, rf->rf1);
+	rt73usb_rf_write(rt2x00dev, 2, rf->rf2);
+	rt73usb_rf_write(rt2x00dev, 3, rf->rf3 | 0x00000004);
+	rt73usb_rf_write(rt2x00dev, 4, rf->rf4);
+
+	rt73usb_rf_write(rt2x00dev, 1, rf->rf1);
+	rt73usb_rf_write(rt2x00dev, 2, rf->rf2);
+	rt73usb_rf_write(rt2x00dev, 3, rf->rf3 & ~0x00000004);
+	rt73usb_rf_write(rt2x00dev, 4, rf->rf4);
+
+	udelay(10);
+}
+
 static void rt73usb_config_channel(struct rt2x00_dev *rt2x00dev,
 				   const int index, const int channel,
 				   const int txpower)
 {
-	struct rf_channel reg;
-	u8 bbp = 0;
+	struct rf_channel rf;
 
 	/*
 	 * Fill rf_reg structure.
 	 */
-	memcpy(&reg, &rt2x00dev->spec.channels[index], sizeof(reg));
+	memcpy(&rf, &rt2x00dev->spec.channels[index], sizeof(rf));
 
-	/*
-	 * Set TXpower.
-	 */
-	rt2x00_set_field32(&reg.rf3, RF3_TXPOWER, TXPOWER_TO_DEV(txpower));
-
-	/*
-	 * Set Frequency offset.
-	 */
-	rt2x00_set_field32(&reg.rf4, RF4_FREQ_OFFSET, rt2x00dev->freq_offset);
-
-	rt73usb_bbp_read(rt2x00dev, 3, &bbp);
-	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF2527))
-		bbp &= ~0x01;
-	else
-		bbp |= 0x01;
-	rt73usb_bbp_write(rt2x00dev, 3, bbp);
-
-	rt73usb_rf_write(rt2x00dev, 1, reg.rf1);
-	rt73usb_rf_write(rt2x00dev, 2, reg.rf2);
-	rt73usb_rf_write(rt2x00dev, 3, reg.rf3 & ~0x00000004);
-	rt73usb_rf_write(rt2x00dev, 4, reg.rf4);
-
-	rt73usb_rf_write(rt2x00dev, 1, reg.rf1);
-	rt73usb_rf_write(rt2x00dev, 2, reg.rf2);
-	rt73usb_rf_write(rt2x00dev, 3, reg.rf3 | 0x00000004);
-	rt73usb_rf_write(rt2x00dev, 4, reg.rf4);
-
-	rt73usb_rf_write(rt2x00dev, 1, reg.rf1);
-	rt73usb_rf_write(rt2x00dev, 2, reg.rf2);
-	rt73usb_rf_write(rt2x00dev, 3, reg.rf3 & ~0x00000004);
-	rt73usb_rf_write(rt2x00dev, 4, reg.rf4);
-
-	msleep(1);
+	rt73usb_config_lock_channel(rt2x00dev, &rf, txpower);
 }
 
 static void rt73usb_config_txpower(struct rt2x00_dev *rt2x00dev,
@@ -486,26 +495,7 @@ static void rt73usb_config_txpower(struct rt2x00_dev *rt2x00dev,
 	rt2x00_rf_read(rt2x00dev, 3, &rf.rf3);
 	rt2x00_rf_read(rt2x00dev, 4, &rf.rf4);
 
-	rt2x00_set_field32(&rf.rf3, RF3_TXPOWER, TXPOWER_TO_DEV(txpower));
-
-	rt73usb_rf_write(rt2x00dev, 1, rf.rf1);
-	rt73usb_rf_write(rt2x00dev, 2, rf.rf2);
-	rt73usb_rf_write(rt2x00dev, 3, rf.rf3 & ~0x00000004);
-	rt73usb_rf_write(rt2x00dev, 4, rf.rf4);
-
-	udelay(200);
-
-	rt73usb_rf_write(rt2x00dev, 1, rf.rf1);
-	rt73usb_rf_write(rt2x00dev, 2, rf.rf2);
-	rt73usb_rf_write(rt2x00dev, 3, rf.rf3 | 0x00000004);
-	rt73usb_rf_write(rt2x00dev, 4, rf.rf4);
-
-	udelay(200);
-
-	rt73usb_rf_write(rt2x00dev, 1, rf.rf1);
-	rt73usb_rf_write(rt2x00dev, 2, rf.rf2);
-	rt73usb_rf_write(rt2x00dev, 3, rf.rf3 & ~0x00000004);
-	rt73usb_rf_write(rt2x00dev, 4, rf.rf4);
+	rt73usb_config_lock_channel(rt2x00dev, &rf, txpower);
 }
 
 static void rt73usb_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
-- 
1.5.3
