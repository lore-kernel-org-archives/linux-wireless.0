Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:14484 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbXJ0LY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 07:24:58 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1035387fkz
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 04:24:57 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/21] rt2x00: SW diversity should default to antenna B
Date: Sat, 27 Oct 2007 13:36:56 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710271334.34192.IvDoorn@gmail.com>
In-Reply-To: <200710271334.34192.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710271336.56387.IvDoorn@gmail.com> (sfid-20071027_122507_651545_359694A7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Although ANTENNA_SW_DIVERSITY should never be send
to the driver, we should still handle it to prevent bugs.
But instead of defaulting to ANTENNA_HW_DIVERSITY we
should default to ANTENNA_B instead.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |   16 ++++++++++++++--
 drivers/net/wireless/rt2x00/rt2500pci.c |   26 ++++++++++++++++----------
 drivers/net/wireless/rt2x00/rt2500usb.c |   16 ++++++++++++++--
 drivers/net/wireless/rt2x00/rt61pci.c   |   16 ++++++++++++++--
 drivers/net/wireless/rt2x00/rt73usb.c   |   16 ++++++++++++++--
 5 files changed, 72 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 2284cb3..5b3adba 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -409,13 +409,19 @@ static void rt2400pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 * Configure the TX antenna.
 	 */
 	switch (ant->tx) {
-	case ANTENNA_SW_DIVERSITY:
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r1, BBP_R1_TX_ANTENNA, 1);
 		break;
 	case ANTENNA_A:
 		rt2x00_set_field8(&r1, BBP_R1_TX_ANTENNA, 0);
 		break;
+	case ANTENNA_SW_DIVERSITY:
+		/*
+		 * NOTE: We should never come here because rt2x00lib is
+		 * supposed to catch this and send us the correct antenna
+		 * explicitely. However we are nog going to bug about this.
+		 * Instead, just default to antenna B.
+		 */
 	case ANTENNA_B:
 		rt2x00_set_field8(&r1, BBP_R1_TX_ANTENNA, 2);
 		break;
@@ -425,13 +431,19 @@ static void rt2400pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 * Configure the RX antenna.
 	 */
 	switch (ant->rx) {
-	case ANTENNA_SW_DIVERSITY:
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
 		break;
 	case ANTENNA_A:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 0);
 		break;
+	case ANTENNA_SW_DIVERSITY:
+		/*
+		 * NOTE: We should never come here because rt2x00lib is
+		 * supposed to catch this and send us the correct antenna
+		 * explicitely. However we are nog going to bug about this.
+		 * Instead, just default to antenna B.
+		 */
 	case ANTENNA_B:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
 		break;
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index a004cd9..b6d7462 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -438,17 +438,19 @@ static void rt2500pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 * Configure the TX antenna.
 	 */
 	switch (ant->tx) {
-	case ANTENNA_SW_DIVERSITY:
-	case ANTENNA_HW_DIVERSITY:
-		rt2x00_set_field8(&r2, BBP_R2_TX_ANTENNA, 2);
-		rt2x00_set_field32(&reg, BBPCSR1_CCK, 2);
-		rt2x00_set_field32(&reg, BBPCSR1_OFDM, 2);
-		break;
 	case ANTENNA_A:
 		rt2x00_set_field8(&r2, BBP_R2_TX_ANTENNA, 0);
 		rt2x00_set_field32(&reg, BBPCSR1_CCK, 0);
 		rt2x00_set_field32(&reg, BBPCSR1_OFDM, 0);
 		break;
+	case ANTENNA_HW_DIVERSITY:
+	case ANTENNA_SW_DIVERSITY:
+		/*
+		 * NOTE: We should never come here because rt2x00lib is
+		 * supposed to catch this and send us the correct antenna
+		 * explicitely. However we are nog going to bug about this.
+		 * Instead, just default to antenna B.
+		 */
 	case ANTENNA_B:
 		rt2x00_set_field8(&r2, BBP_R2_TX_ANTENNA, 2);
 		rt2x00_set_field32(&reg, BBPCSR1_CCK, 2);
@@ -460,13 +462,17 @@ static void rt2500pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 * Configure the RX antenna.
 	 */
 	switch (ant->rx) {
-	case ANTENNA_SW_DIVERSITY:
-	case ANTENNA_HW_DIVERSITY:
-		rt2x00_set_field8(&r14, BBP_R14_RX_ANTENNA, 2);
-		break;
 	case ANTENNA_A:
 		rt2x00_set_field8(&r14, BBP_R14_RX_ANTENNA, 0);
 		break;
+	case ANTENNA_HW_DIVERSITY:
+	case ANTENNA_SW_DIVERSITY:
+		/*
+		 * NOTE: We should never come here because rt2x00lib is
+		 * supposed to catch this and send us the correct antenna
+		 * explicitely. However we are nog going to bug about this.
+		 * Instead, just default to antenna B.
+		 */
 	case ANTENNA_B:
 		rt2x00_set_field8(&r14, BBP_R14_RX_ANTENNA, 2);
 		break;
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 4b92f10..02f1731 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -401,7 +401,6 @@ static void rt2500usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 * Configure the TX antenna.
 	 */
 	switch (ant->tx) {
-	case ANTENNA_SW_DIVERSITY:
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r2, BBP_R2_TX_ANTENNA, 1);
 		rt2x00_set_field16(&csr5, PHY_CSR5_CCK, 1);
@@ -412,6 +411,13 @@ static void rt2500usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field16(&csr5, PHY_CSR5_CCK, 0);
 		rt2x00_set_field16(&csr6, PHY_CSR6_OFDM, 0);
 		break;
+	case ANTENNA_SW_DIVERSITY:
+		/*
+		 * NOTE: We should never come here because rt2x00lib is
+		 * supposed to catch this and send us the correct antenna
+		 * explicitely. However we are nog going to bug about this.
+		 * Instead, just default to antenna B.
+		 */
 	case ANTENNA_B:
 		rt2x00_set_field8(&r2, BBP_R2_TX_ANTENNA, 2);
 		rt2x00_set_field16(&csr5, PHY_CSR5_CCK, 2);
@@ -423,13 +429,19 @@ static void rt2500usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 * Configure the RX antenna.
 	 */
 	switch (ant->rx) {
-	case ANTENNA_SW_DIVERSITY:
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r14, BBP_R14_RX_ANTENNA, 1);
 		break;
 	case ANTENNA_A:
 		rt2x00_set_field8(&r14, BBP_R14_RX_ANTENNA, 0);
 		break;
+	case ANTENNA_SW_DIVERSITY:
+		/*
+		 * NOTE: We should never come here because rt2x00lib is
+		 * supposed to catch this and send us the correct antenna
+		 * explicitely. However we are nog going to bug about this.
+		 * Instead, just default to antenna B.
+		 */
 	case ANTENNA_B:
 		rt2x00_set_field8(&r14, BBP_R14_RX_ANTENNA, 2);
 		break;
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index f96a77c..86fa07a 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -425,7 +425,6 @@ static void rt61pci_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 			  !rt2x00_rf(&rt2x00dev->chip, RF5225));
 
 	switch (ant->rx) {
-	case ANTENNA_SW_DIVERSITY:
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
@@ -440,6 +439,13 @@ static void rt61pci_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 		else
 			rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
 		break;
+	case ANTENNA_SW_DIVERSITY:
+		/*
+		 * NOTE: We should never come here because rt2x00lib is
+		 * supposed to catch this and send us the correct antenna
+		 * explicitely. However we are nog going to bug about this.
+		 * Instead, just default to antenna B.
+		 */
 	case ANTENNA_B:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
@@ -473,7 +479,6 @@ static void rt61pci_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
 			  !test_bit(CONFIG_FRAME_TYPE, &rt2x00dev->flags));
 
 	switch (ant->rx) {
-	case ANTENNA_SW_DIVERSITY:
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
 		break;
@@ -481,6 +486,13 @@ static void rt61pci_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
 		rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
 		break;
+	case ANTENNA_SW_DIVERSITY:
+		/*
+		 * NOTE: We should never come here because rt2x00lib is
+		 * supposed to catch this and send us the correct antenna
+		 * explicitely. However we are nog going to bug about this.
+		 * Instead, just default to antenna B.
+		 */
 	case ANTENNA_B:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
 		rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index a1d915f..07224c0 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -409,7 +409,6 @@ static void rt73usb_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE, 0);
 
 	switch (ant->rx) {
-	case ANTENNA_SW_DIVERSITY:
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
@@ -424,6 +423,13 @@ static void rt73usb_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 		else
 			rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
 		break;
+	case ANTENNA_SW_DIVERSITY:
+		/*
+		 * NOTE: We should never come here because rt2x00lib is
+		 * supposed to catch this and send us the correct antenna
+		 * explicitely. However we are nog going to bug about this.
+		 * Instead, just default to antenna B.
+		 */
 	case ANTENNA_B:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
@@ -456,7 +462,6 @@ static void rt73usb_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
 			  !test_bit(CONFIG_FRAME_TYPE, &rt2x00dev->flags));
 
 	switch (ant->rx) {
-	case ANTENNA_SW_DIVERSITY:
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
 		break;
@@ -464,6 +469,13 @@ static void rt73usb_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
 		rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
 		break;
+	case ANTENNA_SW_DIVERSITY:
+		/*
+		 * NOTE: We should never come here because rt2x00lib is
+		 * supposed to catch this and send us the correct antenna
+		 * explicitely. However we are nog going to bug about this.
+		 * Instead, just default to antenna B.
+		 */
 	case ANTENNA_B:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
 		rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
-- 
1.5.3.4

