Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:49509 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbdAMV0d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:26:33 -0500
Date: Fri, 13 Jan 2017 22:26:10 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 17/40] rt2x00: rt2800lib: add RFCSR initialization for RT3883
Message-ID: <20170113212606.GA3488@makrotopia.org> (sfid-20170113_222636_972249_E23220A4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
[daniel@makrotopia.org: use usleep_range instead of msleep, fixed comment]
---
 drivers/net/wireless/ralink/rt2x00/rt2800.h    |  13 +++
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 141 +++++++++++++++++++++++++
 2 files changed, 154 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800.h b/drivers/net/wireless/ralink/rt2x00/rt2800.h
index 2190bf07d004..33a3b33c9a0b 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800.h
@@ -1588,6 +1588,18 @@
 #define TX_PWR_CFG_9_STBC7_CH2		FIELD32(0x00000f00)
 
 /*
+ * TX_TXBF_CFG:
+ */
+#define TX_TXBF_CFG_0			0x138c
+#define TX_TXBF_CFG_1			0x13a4
+#define TX_TXBF_CFG_2			0x13a8
+#define TX_TXBF_CFG_3			0x13ac
+
+/* TX_FBK_CFG_3S */
+#define TX_FBK_CFG_3S_0			0x13c4
+#define TX_FBK_CFG_3S_1			0x13c8
+
+/*
  * RX_FILTER_CFG: RX configuration register.
  */
 #define RX_FILTER_CFG			0x1400
@@ -2157,6 +2169,7 @@ struct mac_iveiv_entry {
 /*
  * RFCSR 2:
  */
+#define RFCSR2_RESCAL_BP		FIELD8(0x40)
 #define RFCSR2_RESCAL_EN		FIELD8(0x80)
 
 /*
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index df0c6dd90735..870e2da20d47 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -6865,6 +6865,144 @@ static void rt2800_init_rfcsr_3593(struct rt2x00_dev *rt2x00dev)
 	/* TODO: enable stream mode support */
 }
 
+static void rt2800_init_rfcsr_3883(struct rt2x00_dev *rt2x00dev)
+{
+	u8 rfcsr;
+
+	/* TODO: get the actual ECO value from the SoC */
+	const unsigned int eco = 5;
+
+	rt2800_rf_init_calibration(rt2x00dev, 2);
+
+	rt2800_rfcsr_write(rt2x00dev, 0, 0xe0);
+	rt2800_rfcsr_write(rt2x00dev, 1, 0x03);
+	rt2800_rfcsr_write(rt2x00dev, 2, 0x50);
+	rt2800_rfcsr_write(rt2x00dev, 3, 0x20);
+	rt2800_rfcsr_write(rt2x00dev, 4, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 5, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 6, 0x40);
+	rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 8, 0x5b);
+	rt2800_rfcsr_write(rt2x00dev, 9, 0x08);
+	rt2800_rfcsr_write(rt2x00dev, 10, 0xd3);
+	rt2800_rfcsr_write(rt2x00dev, 11, 0x48);
+	rt2800_rfcsr_write(rt2x00dev, 12, 0x1a);
+	rt2800_rfcsr_write(rt2x00dev, 13, 0x12);
+	rt2800_rfcsr_write(rt2x00dev, 14, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 15, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 16, 0x00);
+
+	/* RFCSR 17 will be initialized later based on the
+	 * frequency offset stored in the EEPROM
+	 */
+
+	rt2800_rfcsr_write(rt2x00dev, 18, 0x40);
+	rt2800_rfcsr_write(rt2x00dev, 19, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 20, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 21, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
+	rt2800_rfcsr_write(rt2x00dev, 23, 0xc0);
+	rt2800_rfcsr_write(rt2x00dev, 24, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 25, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 26, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 27, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 29, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
+	rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 33, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 34, 0x20);
+	rt2800_rfcsr_write(rt2x00dev, 35, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 37, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 38, 0x86);
+	rt2800_rfcsr_write(rt2x00dev, 39, 0x23);
+	rt2800_rfcsr_write(rt2x00dev, 40, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 41, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 42, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 43, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 44, 0x93);
+	rt2800_rfcsr_write(rt2x00dev, 45, 0xbb);
+	rt2800_rfcsr_write(rt2x00dev, 46, 0x60);
+	rt2800_rfcsr_write(rt2x00dev, 47, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 48, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 49, 0x8e);
+	rt2800_rfcsr_write(rt2x00dev, 50, 0x86);
+	rt2800_rfcsr_write(rt2x00dev, 51, 0x51);
+	rt2800_rfcsr_write(rt2x00dev, 52, 0x05);
+	rt2800_rfcsr_write(rt2x00dev, 53, 0x76);
+	rt2800_rfcsr_write(rt2x00dev, 54, 0x76);
+	rt2800_rfcsr_write(rt2x00dev, 55, 0x76);
+	rt2800_rfcsr_write(rt2x00dev, 56, 0xdb);
+	rt2800_rfcsr_write(rt2x00dev, 57, 0x3e);
+	rt2800_rfcsr_write(rt2x00dev, 58, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 59, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 60, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 61, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 62, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
+
+	/* TODO: rx filter calibration? */
+
+	rt2800_bbp_write(rt2x00dev, 137, 0x0f);
+
+	rt2800_bbp_write(rt2x00dev, 163, 0x9d);
+
+	rt2800_bbp_write(rt2x00dev, 105, 0x05);
+
+	rt2800_bbp_write(rt2x00dev, 179, 0x02);
+	rt2800_bbp_write(rt2x00dev, 180, 0x00);
+	rt2800_bbp_write(rt2x00dev, 182, 0x40);
+	rt2800_bbp_write(rt2x00dev, 180, 0x01);
+	rt2800_bbp_write(rt2x00dev, 182, 0x9c);
+
+	rt2800_bbp_write(rt2x00dev, 179, 0x00);
+
+	rt2800_bbp_write(rt2x00dev, 142, 0x04);
+	rt2800_bbp_write(rt2x00dev, 143, 0x3b);
+	rt2800_bbp_write(rt2x00dev, 142, 0x06);
+	rt2800_bbp_write(rt2x00dev, 143, 0xa0);
+	rt2800_bbp_write(rt2x00dev, 142, 0x07);
+	rt2800_bbp_write(rt2x00dev, 143, 0xa1);
+	rt2800_bbp_write(rt2x00dev, 142, 0x08);
+	rt2800_bbp_write(rt2x00dev, 143, 0xa2);
+	rt2800_bbp_write(rt2x00dev, 148, 0xc8);
+
+	if (eco == 5) {
+		rt2800_rfcsr_write(rt2x00dev, 32, 0xd8);
+		rt2800_rfcsr_write(rt2x00dev, 33, 0x32);
+	}
+
+	rt2800_rfcsr_read(rt2x00dev, 2, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_BP, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 1);
+	rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
+	usleep_range(1000, 1500);
+	rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 0);
+	rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RF_BLOCK_EN, 1);
+	rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
+	rfcsr |= 0xc0;
+	rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
+	rfcsr |= 0x20;
+	rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 46, &rfcsr);
+	rfcsr |= 0x20;
+	rt2800_rfcsr_write(rt2x00dev, 46, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 20, &rfcsr);
+	rfcsr &= ~0xee;
+	rt2800_rfcsr_write(rt2x00dev, 20, rfcsr);
+}
+
 static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
 {
 	rt2800_rf_init_calibration(rt2x00dev, 2);
@@ -7096,6 +7234,9 @@ static void rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	case RT3390:
 		rt2800_init_rfcsr_3390(rt2x00dev);
 		break;
+	case RT3883:
+		rt2800_init_rfcsr_3883(rt2x00dev);
+		break;
 	case RT3572:
 		rt2800_init_rfcsr_3572(rt2x00dev);
 		break;
-- 
2.11.0
