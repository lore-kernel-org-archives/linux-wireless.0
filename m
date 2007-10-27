Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:3327 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbXJ0LZ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 07:25:27 -0400
Received: by nf-out-0910.google.com with SMTP id g13so973056nfb
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 04:25:27 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 17/21] rt2x00: Rework rt73 antenna selection
Date: Sat, 27 Oct 2007 13:42:37 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710271334.34192.IvDoorn@gmail.com>
In-Reply-To: <200710271334.34192.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710271342.37504.IvDoorn@gmail.com> (sfid-20071027_124131_528310_2672CC2D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mattias Nissler <mattias.nissler@gmx.de>

This patch changes rt73 antenna selection to what I believe is the correct way.
It also fixes a small selection bug that switched the antennas by accident.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt73usb.c |   78 ++++++++++----------------------
 drivers/net/wireless/rt2x00/rt73usb.h |   10 +++-
 2 files changed, 33 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 57fa18d..1c44081 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -399,6 +399,7 @@ static void rt73usb_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 	u8 r3;
 	u8 r4;
 	u8 r77;
+	u8 temp;
 
 	rt73usb_bbp_read(rt2x00dev, 3, &r3);
 	rt73usb_bbp_read(rt2x00dev, 4, &r4);
@@ -407,37 +408,22 @@ static void rt73usb_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE, 0);
 
 	/*
-	 * Configure the TX antenna.
-	 */
-	switch (ant->tx) {
-	case ANTENNA_A:
-		rt2x00_set_field8(&r77, BBP_R77_TX_ANTENNA, 0);
-		break;
-	case ANTENNA_SW_DIVERSITY:
-	case ANTENNA_HW_DIVERSITY:
-		/*
-		 * NOTE: We should never come here because rt2x00lib is
-		 * supposed to catch this and send us the correct antenna
-		 * explicitely. However we are nog going to bug about this.
-		 * Instead, just default to antenna B.
-		 */
-	case ANTENNA_B:
-		rt2x00_set_field8(&r77, BBP_R77_TX_ANTENNA, 3);
-		break;
-	}
-
-	/*
 	 * Configure the RX antenna.
 	 */
 	switch (ant->rx) {
 	case ANTENNA_HW_DIVERSITY:
-		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
-		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
-				  (rt2x00dev->curr_hwmode != HWMODE_A));
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 2);
+		temp = !test_bit(CONFIG_FRAME_TYPE, &rt2x00dev->flags)
+		       && (rt2x00dev->curr_hwmode != HWMODE_A);
+		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, temp);
 		break;
 	case ANTENNA_A:
-		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
+		if (rt2x00dev->curr_hwmode == HWMODE_A)
+			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 0);
+		else
+			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 3);
 		break;
 	case ANTENNA_SW_DIVERSITY:
 		/*
@@ -447,8 +433,12 @@ static void rt73usb_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 		 * Instead, just default to antenna B.
 		 */
 	case ANTENNA_B:
-		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
+		if (rt2x00dev->curr_hwmode == HWMODE_A)
+			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 3);
+		else
+			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 0);
 		break;
 	}
 
@@ -473,34 +463,15 @@ static void rt73usb_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
 			  !test_bit(CONFIG_FRAME_TYPE, &rt2x00dev->flags));
 
 	/*
-	 * Configure the TX antenna.
-	 */
-	switch (ant->tx) {
-	case ANTENNA_A:
-		rt2x00_set_field8(&r77, BBP_R77_TX_ANTENNA, 0);
-		break;
-	case ANTENNA_SW_DIVERSITY:
-	case ANTENNA_HW_DIVERSITY:
-		/*
-		 * NOTE: We should never come here because rt2x00lib is
-		 * supposed to catch this and send us the correct antenna
-		 * explicitely. However we are nog going to bug about this.
-		 * Instead, just default to antenna B.
-		 */
-	case ANTENNA_B:
-		rt2x00_set_field8(&r77, BBP_R77_TX_ANTENNA, 3);
-		break;
-	}
-
-	/*
 	 * Configure the RX antenna.
 	 */
 	switch (ant->rx) {
 	case ANTENNA_HW_DIVERSITY:
-		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 2);
 		break;
 	case ANTENNA_A:
-		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
+		rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 3);
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		break;
 	case ANTENNA_SW_DIVERSITY:
 		/*
@@ -510,7 +481,8 @@ static void rt73usb_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
 		 * Instead, just default to antenna B.
 		 */
 	case ANTENNA_B:
-		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
+		rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 0);
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		break;
 	}
 
@@ -558,8 +530,6 @@ static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 	unsigned int i;
 	u32 reg;
 
-	rt73usb_register_read(rt2x00dev, PHY_CSR0, &reg);
-
 	if (rt2x00dev->curr_hwmode == HWMODE_A) {
 		sel = antenna_sel_a;
 		lna = test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags);
@@ -568,15 +538,17 @@ static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 		lna = test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags);
 	}
 
+	for (i = 0; i < ARRAY_SIZE(antenna_sel_a); i++)
+		rt73usb_bbp_write(rt2x00dev, sel[i].word, sel[i].value[lna]);
+
+	rt73usb_register_read(rt2x00dev, PHY_CSR0, &reg);
+
 	rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG,
 			   (rt2x00dev->curr_hwmode == HWMODE_B ||
 			    rt2x00dev->curr_hwmode == HWMODE_G));
 	rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A,
 			   (rt2x00dev->curr_hwmode == HWMODE_A));
 
-	for (i = 0; i < ARRAY_SIZE(antenna_sel_a); i++)
-		rt73usb_bbp_write(rt2x00dev, sel[i].word, sel[i].value[lna]);
-
 	rt73usb_register_write(rt2x00dev, PHY_CSR0, reg);
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF5226) ||
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index 13f479c..b967df2 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -713,13 +713,19 @@ struct hw_pairwise_ta_entry {
  * R4: RX antenna control
  * FRAME_END: 1 - DPDT, 0 - SPDT (Only valid for 802.11G, RF2527 & RF2529)
  */
-#define BBP_R4_RX_ANTENNA		FIELD8(0x03)
+
+/*
+ * ANTENNA_CONTROL semantics (guessed):
+ * 0x1: Software controlled antenna switching (fixed or SW diversity)
+ * 0x2: Hardware diversity.
+ */
+#define BBP_R4_RX_ANTENNA_CONTROL	FIELD8(0x03)
 #define BBP_R4_RX_FRAME_END		FIELD8(0x20)
 
 /*
  * R77
  */
-#define BBP_R77_TX_ANTENNA		FIELD8(0x03)
+#define BBP_R77_RX_ANTENNA		FIELD8(0x03)
 
 /*
  * RF registers
-- 
1.5.3.4

