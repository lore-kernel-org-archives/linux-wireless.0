Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54056 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab1HXJu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 05:50:27 -0400
Received: by bke11 with SMTP id 11so751897bke.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 02:50:26 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: HT-PHY: use separated function for forcing RF sequence
Date: Wed, 24 Aug 2011 11:52:34 +0200
Message-Id: <1314179555-8188-1-git-send-email-zajec5@gmail.com> (sfid-20110824_115030_776554_9F1C9C8F)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Comparison of the HT and N code has shown similarities in the ops
performed after b43_mac_phy_clock_set. That way we understood what is
happening in the HT-PHY code.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c |   32 +++++++++++++++++++++++---------
 drivers/net/wireless/b43/phy_ht.h |   11 +++++++++++
 2 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 62a9084..c0e436c 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -191,6 +191,27 @@ static void b43_phy_ht_afe_unk1(struct b43_wldev *dev)
 	}
 }
 
+static void b43_phy_ht_force_rf_sequence(struct b43_wldev *dev, u16 rf_seq)
+{
+	u8 i;
+
+	u16 save_seq_mode = b43_phy_read(dev, B43_PHY_HT_RF_SEQ_MODE);
+	b43_phy_set(dev, B43_PHY_HT_RF_SEQ_MODE, 0x3);
+
+	b43_phy_set(dev, B43_PHY_HT_RF_SEQ_TRIG, rf_seq);
+	for (i = 0; i < 200; i++) {
+		if (!(b43_phy_read(dev, B43_PHY_HT_RF_SEQ_STATUS) & rf_seq)) {
+			i = 0;
+			break;
+		}
+		msleep(1);
+	}
+	if (i)
+		b43err(dev->wl, "Forcing RF sequence timeout\n");
+
+	b43_phy_write(dev, B43_PHY_HT_RF_SEQ_MODE, save_seq_mode);
+}
+
 static void b43_phy_ht_bphy_init(struct b43_wldev *dev)
 {
 	unsigned int i;
@@ -313,7 +334,6 @@ static void b43_phy_ht_op_prepare_structs(struct b43_wldev *dev)
 
 static int b43_phy_ht_op_init(struct b43_wldev *dev)
 {
-	u8 i;
 	u16 tmp;
 
 	b43_phy_ht_tables_init(dev);
@@ -418,14 +438,8 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
 
 	b43_mac_phy_clock_set(dev, true);
 
-	for (i = 0; i < 2; i++) {
-		tmp = b43_phy_read(dev, B43_PHY_EXTG(0));
-		b43_phy_set(dev, B43_PHY_EXTG(0), 0x3);
-		b43_phy_set(dev, B43_PHY_EXTG(3), i ? 0x20 : 0x1);
-		/* FIXME: wait for some bit to be cleared (find out which) */
-		b43_phy_read(dev, B43_PHY_EXTG(4));
-		b43_phy_write(dev, B43_PHY_EXTG(0), tmp);
-	}
+	b43_phy_ht_force_rf_sequence(dev, B43_PHY_HT_RF_SEQ_TRIG_RX2TX);
+	b43_phy_ht_force_rf_sequence(dev, B43_PHY_HT_RF_SEQ_TRIG_RST2RX);
 
 	/* TODO: PHY op on reg 0xb0 */
 
diff --git a/drivers/net/wireless/b43/phy_ht.h b/drivers/net/wireless/b43/phy_ht.h
index f70af0c..0661ae2 100644
--- a/drivers/net/wireless/b43/phy_ht.h
+++ b/drivers/net/wireless/b43/phy_ht.h
@@ -19,6 +19,17 @@
 #define B43_PHY_HT_BW5				0x1D2
 #define B43_PHY_HT_BW6				0x1D3
 
+#define B43_PHY_HT_RF_SEQ_MODE			B43_PHY_EXTG(0x000)
+#define B43_PHY_HT_RF_SEQ_TRIG			B43_PHY_EXTG(0x003)
+#define  B43_PHY_HT_RF_SEQ_TRIG_RX2TX		0x0001 /* RX2TX */
+#define  B43_PHY_HT_RF_SEQ_TRIG_TX2RX		0x0002 /* TX2RX */
+#define  B43_PHY_HT_RF_SEQ_TRIG_UPGH		0x0004 /* Update gain H */
+#define  B43_PHY_HT_RF_SEQ_TRIG_UPGL		0x0008 /* Update gain L */
+#define  B43_PHY_HT_RF_SEQ_TRIG_UPGU		0x0010 /* Update gain U */
+#define  B43_PHY_HT_RF_SEQ_TRIG_RST2RX		0x0020 /* Reset to RX */
+#define B43_PHY_HT_RF_SEQ_STATUS		B43_PHY_EXTG(0x004)
+/* Values for the status are the same as for the trigger */
+
 #define B43_PHY_HT_RF_CTL1			B43_PHY_EXTG(0x010)
 
 #define B43_PHY_HT_AFE_CTL1			B43_PHY_EXTG(0x110)
-- 
1.7.3.4

