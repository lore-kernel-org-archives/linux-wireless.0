Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:53844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbYCIVvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:51:11 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1676623fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:51:11 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 14/24] rt2x00: Start bugging when rt2x00lib doesn't filter SW diversity
Date: Sun, 9 Mar 2008 22:45:21 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092245.21463.IvDoorn@gmail.com> (sfid-20080309_222403_249642_267E0834)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00lib should filter SW diversity out before sending any configuration
changes to the driver. When rt2x00lib fails to do this, it is important
that such events are reported because it _must_ be fixed.
So upgrading the error level to a BUG_ON() which will make sure
this bug gets noticed whenever it happens.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |   23 +++++++------------
 drivers/net/wireless/rt2x00/rt2500pci.c |   25 +++++++-------------
 drivers/net/wireless/rt2x00/rt2500usb.c |   23 +++++++------------
 drivers/net/wireless/rt2x00/rt61pci.c   |   36 +++++++++++-------------------
 drivers/net/wireless/rt2x00/rt73usb.c   |   23 +++++++------------
 5 files changed, 49 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index a1c38a1..0ac0c6e 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -417,6 +417,13 @@ static void rt2400pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	u8 r1;
 	u8 r4;
 
+	/*
+	 * We should never come here because rt2x00lib is supposed
+	 * to catch this and send us the correct antenna explicitely.
+	 */
+	BUG_ON(ant->rx == ANTENNA_SW_DIVERSITY ||
+	       ant->tx == ANTENNA_SW_DIVERSITY);
+
 	rt2400pci_bbp_read(rt2x00dev, 4, &r4);
 	rt2400pci_bbp_read(rt2x00dev, 1, &r1);
 
@@ -430,14 +437,8 @@ static void rt2400pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	case ANTENNA_A:
 		rt2x00_set_field8(&r1, BBP_R1_TX_ANTENNA, 0);
 		break;
-	case ANTENNA_SW_DIVERSITY:
-		/*
-		 * NOTE: We should never come here because rt2x00lib is
-		 * supposed to catch this and send us the correct antenna
-		 * explicitely. However we are nog going to bug about this.
-		 * Instead, just default to antenna B.
-		 */
 	case ANTENNA_B:
+	default:
 		rt2x00_set_field8(&r1, BBP_R1_TX_ANTENNA, 2);
 		break;
 	}
@@ -452,14 +453,8 @@ static void rt2400pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	case ANTENNA_A:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 0);
 		break;
-	case ANTENNA_SW_DIVERSITY:
-		/*
-		 * NOTE: We should never come here because rt2x00lib is
-		 * supposed to catch this and send us the correct antenna
-		 * explicitely. However we are nog going to bug about this.
-		 * Instead, just default to antenna B.
-		 */
 	case ANTENNA_B:
+	default:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
 		break;
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 0962327..d85e1a4 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -444,6 +444,13 @@ static void rt2500pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	u8 r14;
 	u8 r2;
 
+	/*
+	 * We should never come here because rt2x00lib is supposed
+	 * to catch this and send us the correct antenna explicitely.
+	 */
+	BUG_ON(ant->rx == ANTENNA_SW_DIVERSITY ||
+	       ant->tx == ANTENNA_SW_DIVERSITY);
+
 	rt2x00pci_register_read(rt2x00dev, BBPCSR1, &reg);
 	rt2500pci_bbp_read(rt2x00dev, 14, &r14);
 	rt2500pci_bbp_read(rt2x00dev, 2, &r2);
@@ -457,15 +464,8 @@ static void rt2500pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, BBPCSR1_CCK, 0);
 		rt2x00_set_field32(&reg, BBPCSR1_OFDM, 0);
 		break;
-	case ANTENNA_HW_DIVERSITY:
-	case ANTENNA_SW_DIVERSITY:
-		/*
-		 * NOTE: We should never come here because rt2x00lib is
-		 * supposed to catch this and send us the correct antenna
-		 * explicitely. However we are nog going to bug about this.
-		 * Instead, just default to antenna B.
-		 */
 	case ANTENNA_B:
+	default:
 		rt2x00_set_field8(&r2, BBP_R2_TX_ANTENNA, 2);
 		rt2x00_set_field32(&reg, BBPCSR1_CCK, 2);
 		rt2x00_set_field32(&reg, BBPCSR1_OFDM, 2);
@@ -479,15 +479,8 @@ static void rt2500pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	case ANTENNA_A:
 		rt2x00_set_field8(&r14, BBP_R14_RX_ANTENNA, 0);
 		break;
-	case ANTENNA_HW_DIVERSITY:
-	case ANTENNA_SW_DIVERSITY:
-		/*
-		 * NOTE: We should never come here because rt2x00lib is
-		 * supposed to catch this and send us the correct antenna
-		 * explicitely. However we are nog going to bug about this.
-		 * Instead, just default to antenna B.
-		 */
 	case ANTENNA_B:
+	default:
 		rt2x00_set_field8(&r14, BBP_R14_RX_ANTENNA, 2);
 		break;
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index b9e2f3a..7ea4247 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -437,6 +437,13 @@ static void rt2500usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 	u16 csr5;
 	u16 csr6;
 
+	/*
+	 * We should never come here because rt2x00lib is supposed
+	 * to catch this and send us the correct antenna explicitely.
+	 */
+	BUG_ON(ant->rx == ANTENNA_SW_DIVERSITY ||
+	       ant->tx == ANTENNA_SW_DIVERSITY);
+
 	rt2500usb_bbp_read(rt2x00dev, 2, &r2);
 	rt2500usb_bbp_read(rt2x00dev, 14, &r14);
 	rt2500usb_register_read(rt2x00dev, PHY_CSR5, &csr5);
@@ -456,14 +463,8 @@ static void rt2500usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field16(&csr5, PHY_CSR5_CCK, 0);
 		rt2x00_set_field16(&csr6, PHY_CSR6_OFDM, 0);
 		break;
-	case ANTENNA_SW_DIVERSITY:
-		/*
-		 * NOTE: We should never come here because rt2x00lib is
-		 * supposed to catch this and send us the correct antenna
-		 * explicitely. However we are nog going to bug about this.
-		 * Instead, just default to antenna B.
-		 */
 	case ANTENNA_B:
+	default:
 		rt2x00_set_field8(&r2, BBP_R2_TX_ANTENNA, 2);
 		rt2x00_set_field16(&csr5, PHY_CSR5_CCK, 2);
 		rt2x00_set_field16(&csr6, PHY_CSR6_OFDM, 2);
@@ -480,14 +481,8 @@ static void rt2500usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 	case ANTENNA_A:
 		rt2x00_set_field8(&r14, BBP_R14_RX_ANTENNA, 0);
 		break;
-	case ANTENNA_SW_DIVERSITY:
-		/*
-		 * NOTE: We should never come here because rt2x00lib is
-		 * supposed to catch this and send us the correct antenna
-		 * explicitely. However we are nog going to bug about this.
-		 * Instead, just default to antenna B.
-		 */
 	case ANTENNA_B:
+	default:
 		rt2x00_set_field8(&r14, BBP_R14_RX_ANTENNA, 2);
 		break;
 	}
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 9f5838b..96fde43 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -481,14 +481,8 @@ static void rt61pci_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 		else
 			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 3);
 		break;
-	case ANTENNA_SW_DIVERSITY:
-		/*
-		 * NOTE: We should never come here because rt2x00lib is
-		 * supposed to catch this and send us the correct antenna
-		 * explicitely. However we are nog going to bug about this.
-		 * Instead, just default to antenna B.
-		 */
 	case ANTENNA_B:
+	default:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
 		if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ)
@@ -530,14 +524,8 @@ static void rt61pci_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 3);
 		break;
-	case ANTENNA_SW_DIVERSITY:
-		/*
-		 * NOTE: We should never come here because rt2x00lib is
-		 * supposed to catch this and send us the correct antenna
-		 * explicitely. However we are nog going to bug about this.
-		 * Instead, just default to antenna B.
-		 */
 	case ANTENNA_B:
+	default:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 0);
 		break;
@@ -575,10 +563,6 @@ static void rt61pci_config_antenna_2529(struct rt2x00_dev *rt2x00dev,
 	rt61pci_bbp_read(rt2x00dev, 4, &r4);
 	rt61pci_bbp_read(rt2x00dev, 77, &r77);
 
-	/* FIXME: Antenna selection for the rf 2529 is very confusing in the
-	 * legacy driver. The code below should be ok for non-diversity setups.
-	 */
-
 	/*
 	 * Configure the RX antenna.
 	 */
@@ -588,15 +572,14 @@ static void rt61pci_config_antenna_2529(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 0);
 		rt61pci_config_antenna_2529_rx(rt2x00dev, 0, 0);
 		break;
-	case ANTENNA_SW_DIVERSITY:
 	case ANTENNA_HW_DIVERSITY:
 		/*
-		 * NOTE: We should never come here because rt2x00lib is
-		 * supposed to catch this and send us the correct antenna
-		 * explicitely. However we are nog going to bug about this.
-		 * Instead, just default to antenna B.
+		 * FIXME: Antenna selection for the rf 2529 is very confusing
+		 * in the legacy driver. Just default to antenna B until the
+		 * legacy code can be properly translated into rt2x00 code.
 		 */
 	case ANTENNA_B:
+	default:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 3);
 		rt61pci_config_antenna_2529_rx(rt2x00dev, 1, 1);
@@ -647,6 +630,13 @@ static void rt61pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	unsigned int i;
 	u32 reg;
 
+	/*
+	 * We should never come here because rt2x00lib is supposed
+	 * to catch this and send us the correct antenna explicitely.
+	 */
+	BUG_ON(ant->rx == ANTENNA_SW_DIVERSITY ||
+	       ant->tx == ANTENNA_SW_DIVERSITY);
+
 	if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ) {
 		sel = antenna_sel_a;
 		lna = test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 3a2499a..7729ac2 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -497,14 +497,8 @@ static void rt73usb_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 		else
 			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 3);
 		break;
-	case ANTENNA_SW_DIVERSITY:
-		/*
-		 * NOTE: We should never come here because rt2x00lib is
-		 * supposed to catch this and send us the correct antenna
-		 * explicitely. However we are nog going to bug about this.
-		 * Instead, just default to antenna B.
-		 */
 	case ANTENNA_B:
+	default:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
 		if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ)
@@ -545,14 +539,8 @@ static void rt73usb_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 3);
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		break;
-	case ANTENNA_SW_DIVERSITY:
-		/*
-		 * NOTE: We should never come here because rt2x00lib is
-		 * supposed to catch this and send us the correct antenna
-		 * explicitely. However we are nog going to bug about this.
-		 * Instead, just default to antenna B.
-		 */
 	case ANTENNA_B:
+	default:
 		rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 0);
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		break;
@@ -602,6 +590,13 @@ static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 	unsigned int i;
 	u32 reg;
 
+	/*
+	 * We should never come here because rt2x00lib is supposed
+	 * to catch this and send us the correct antenna explicitely.
+	 */
+	BUG_ON(ant->rx == ANTENNA_SW_DIVERSITY ||
+	       ant->tx == ANTENNA_SW_DIVERSITY);
+
 	if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ) {
 		sel = antenna_sel_a;
 		lna = test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags);
-- 
1.5.4.3

