Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:62118 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407Ab3CGPsC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 10:48:02 -0500
Received: by mail-ea0-f179.google.com with SMTP id d12so1577744eaa.10
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2013 07:48:00 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 09/13] b43: HT-PHY: implement stopping sample tone playback
Date: Thu,  7 Mar 2013 16:47:23 +0100
Message-Id: <1362671247-10766-10-git-send-email-zajec5@gmail.com> (sfid-20130307_171304_027796_471AE039)
In-Reply-To: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
References: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was another sequence I recognized in HT-PHY dump:
 phy_read(0x00c7) -> 0x0001
 phy_read(0x00c3) -> 0x0000
phy_write(0x00c3) <- 0x0002
 phy_read(0x00c3) -> 0x0000
phy_write(0x00c3) <- 0x0000
The difference to N-PHY is that it writes to 6 tables instead of a one
(after above).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c |   41 +++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/phy_ht.h |    6 ++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 4300867..8e5d5bd 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -294,6 +294,36 @@ static void b43_phy_ht_bphy_init(struct b43_wldev *dev)
 }
 
 /**************************************************
+ * Samples
+ **************************************************/
+
+#if 0
+static void b43_phy_ht_stop_playback(struct b43_wldev *dev)
+{
+	struct b43_phy_ht *phy_ht = dev->phy.ht;
+	u16 tmp;
+	int i;
+
+	tmp = b43_phy_read(dev, B43_PHY_HT_SAMP_STAT);
+	if (tmp & 0x1)
+		b43_phy_set(dev, B43_PHY_HT_SAMP_CMD, B43_PHY_HT_SAMP_CMD_STOP);
+	else if (tmp & 0x2)
+		b43_phy_mask(dev, B43_PHY_HT_IQLOCAL_CMDGCTL, 0x7FFF);
+
+	b43_phy_mask(dev, B43_PHY_HT_SAMP_CMD, ~0x0004);
+
+	for (i = 0; i < 3; i++) {
+		if (phy_ht->bb_mult_save[i] >= 0) {
+			b43_httab_write(dev, B43_HTTAB16(13, 0x63 + i * 4),
+					phy_ht->bb_mult_save[i]);
+			b43_httab_write(dev, B43_HTTAB16(13, 0x67 + i * 4),
+					phy_ht->bb_mult_save[i]);
+		}
+	}
+}
+#endif
+
+/**************************************************
  * Tx/Rx
  **************************************************/
 
@@ -357,6 +387,13 @@ static void b43_phy_ht_tx_power_ctl(struct b43_wldev *dev, bool enable)
 
 	phy_ht->tx_pwr_ctl = enable;
 }
+
+static void b43_phy_ht_tx_power_ctl_idle_tssi(struct b43_wldev *dev)
+{
+	/* TODO */
+	b43_phy_ht_stop_playback(dev);
+	/* TODO */
+}
 #endif
 
 /**************************************************
@@ -502,6 +539,9 @@ static void b43_phy_ht_op_prepare_structs(struct b43_wldev *dev)
 	phy_ht->tx_pwr_ctl = true;
 	for (i = 0; i < 3; i++)
 		phy_ht->tx_pwr_idx[i] = B43_PHY_HT_TXPCTL_CMD_C1_INIT + 1;
+
+	for (i = 0; i < 3; i++)
+		phy_ht->bb_mult_save[i] = -1;
 }
 
 static int b43_phy_ht_op_init(struct b43_wldev *dev)
@@ -640,6 +680,7 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
 	b43_phy_ht_tx_power_fix(dev);
 #if 0
 	b43_phy_ht_tx_power_ctl(dev, false);
+	b43_phy_ht_tx_power_ctl_idle_tssi(dev);
 	/* TODO */
 	b43_phy_ht_tx_power_ctl(dev, saved_tx_pwr_ctl);
 #endif
diff --git a/drivers/net/wireless/b43/phy_ht.h b/drivers/net/wireless/b43/phy_ht.h
index bc7a43f..7ec794b 100644
--- a/drivers/net/wireless/b43/phy_ht.h
+++ b/drivers/net/wireless/b43/phy_ht.h
@@ -16,6 +16,10 @@
 #define  B43_PHY_HT_CLASS_CTL_CCK_EN		0x0001 /* CCK enable */
 #define  B43_PHY_HT_CLASS_CTL_OFDM_EN		0x0002 /* OFDM enable */
 #define  B43_PHY_HT_CLASS_CTL_WAITED_EN		0x0004 /* Waited enable */
+#define B43_PHY_HT_IQLOCAL_CMDGCTL		0x0C2	/* I/Q LO cal command G control */
+#define B43_PHY_HT_SAMP_CMD			0x0C3	/* Sample command */
+#define  B43_PHY_HT_SAMP_CMD_STOP		0x0002	/* Stop */
+#define B43_PHY_HT_SAMP_STAT			0x0C7	/* Sample status */
 #define B43_PHY_HT_BW1				0x1CE
 #define B43_PHY_HT_BW2				0x1CF
 #define B43_PHY_HT_BW3				0x1D0
@@ -80,6 +84,8 @@ struct b43_phy_ht {
 
 	bool tx_pwr_ctl;
 	u8 tx_pwr_idx[3];
+
+	s32 bb_mult_save[3];
 };
 
 
-- 
1.7.10.4

