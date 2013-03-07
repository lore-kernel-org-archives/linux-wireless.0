Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:61543 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933034Ab3CGPsE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 10:48:04 -0500
Received: by mail-ee0-f52.google.com with SMTP id b15so442183eek.11
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2013 07:48:03 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 10/13] b43: HT-PHY: implement playing sample tone
Date: Thu,  7 Mar 2013 16:47:24 +0100
Message-Id: <1362671247-10766-11-git-send-email-zajec5@gmail.com> (sfid-20130307_171304_325691_302187C2)
In-Reply-To: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
References: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c |   69 +++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/phy_ht.h |    5 +++
 2 files changed, 74 insertions(+)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 8e5d5bd..363c64c 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -321,6 +321,70 @@ static void b43_phy_ht_stop_playback(struct b43_wldev *dev)
 		}
 	}
 }
+
+static u16 b43_phy_ht_load_samples(struct b43_wldev *dev)
+{
+	int i;
+	u16 len = 20 << 3;
+
+	b43_phy_write(dev, B43_PHY_HT_TABLE_ADDR, 0x4400);
+
+	for (i = 0; i < len; i++) {
+		b43_phy_write(dev, B43_PHY_HT_TABLE_DATAHI, 0);
+		b43_phy_write(dev, B43_PHY_HT_TABLE_DATALO, 0);
+	}
+
+	return len;
+}
+
+static void b43_phy_ht_run_samples(struct b43_wldev *dev, u16 samps, u16 loops,
+				   u16 wait)
+{
+	struct b43_phy_ht *phy_ht = dev->phy.ht;
+	u16 save_seq_mode;
+	int i;
+
+	for (i = 0; i < 3; i++) {
+		if (phy_ht->bb_mult_save[i] < 0)
+			phy_ht->bb_mult_save[i] = b43_httab_read(dev, B43_HTTAB16(13, 0x63 + i * 4));
+	}
+
+	b43_phy_write(dev, B43_PHY_HT_SAMP_DEP_CNT, samps - 1);
+	if (loops != 0xFFFF)
+		loops--;
+	b43_phy_write(dev, B43_PHY_HT_SAMP_LOOP_CNT, loops);
+	b43_phy_write(dev, B43_PHY_HT_SAMP_WAIT_CNT, wait);
+
+	save_seq_mode = b43_phy_read(dev, B43_PHY_HT_RF_SEQ_MODE);
+	b43_phy_set(dev, B43_PHY_HT_RF_SEQ_MODE,
+		    B43_PHY_HT_RF_SEQ_MODE_CA_OVER);
+
+	/* TODO: find out mask bits! Do we need more function arguments? */
+	b43_phy_mask(dev, B43_PHY_HT_SAMP_CMD, ~0);
+	b43_phy_mask(dev, B43_PHY_HT_SAMP_CMD, ~0);
+	b43_phy_mask(dev, B43_PHY_HT_IQLOCAL_CMDGCTL, ~0);
+	b43_phy_set(dev, B43_PHY_HT_SAMP_CMD, 0x1);
+
+	for (i = 0; i < 100; i++) {
+		if (!(b43_phy_read(dev, B43_PHY_HT_RF_SEQ_STATUS) & 1)) {
+			i = 0;
+			break;
+		}
+		udelay(10);
+	}
+	if (i)
+		b43err(dev->wl, "run samples timeout\n");
+
+	b43_phy_write(dev, B43_PHY_HT_RF_SEQ_MODE, save_seq_mode);
+}
+
+static void b43_phy_ht_tx_tone(struct b43_wldev *dev)
+{
+	u16 samp;
+
+	samp = b43_phy_ht_load_samples(dev);
+	b43_phy_ht_run_samples(dev, samp, 0xFFFF, 0);
+}
 #endif
 
 /**************************************************
@@ -391,7 +455,12 @@ static void b43_phy_ht_tx_power_ctl(struct b43_wldev *dev, bool enable)
 static void b43_phy_ht_tx_power_ctl_idle_tssi(struct b43_wldev *dev)
 {
 	/* TODO */
+
+	b43_phy_ht_tx_tone(dev);
+	udelay(20);
+	/* TODO: poll RSSI */
 	b43_phy_ht_stop_playback(dev);
+
 	/* TODO */
 }
 #endif
diff --git a/drivers/net/wireless/b43/phy_ht.h b/drivers/net/wireless/b43/phy_ht.h
index 7ec794b..c517958 100644
--- a/drivers/net/wireless/b43/phy_ht.h
+++ b/drivers/net/wireless/b43/phy_ht.h
@@ -19,6 +19,9 @@
 #define B43_PHY_HT_IQLOCAL_CMDGCTL		0x0C2	/* I/Q LO cal command G control */
 #define B43_PHY_HT_SAMP_CMD			0x0C3	/* Sample command */
 #define  B43_PHY_HT_SAMP_CMD_STOP		0x0002	/* Stop */
+#define B43_PHY_HT_SAMP_LOOP_CNT		0x0C4	/* Sample loop count */
+#define B43_PHY_HT_SAMP_WAIT_CNT		0x0C5	/* Sample wait count */
+#define B43_PHY_HT_SAMP_DEP_CNT			0x0C6	/* Sample depth count */
 #define B43_PHY_HT_SAMP_STAT			0x0C7	/* Sample status */
 #define B43_PHY_HT_BW1				0x1CE
 #define B43_PHY_HT_BW2				0x1CF
@@ -39,6 +42,8 @@
 #define B43_PHY_HT_C3_CLIP1THRES		B43_PHY_OFDM(0x08E)
 
 #define B43_PHY_HT_RF_SEQ_MODE			B43_PHY_EXTG(0x000)
+#define  B43_PHY_HT_RF_SEQ_MODE_CA_OVER		0x0001	/* Core active override */
+#define  B43_PHY_HT_RF_SEQ_MODE_TR_OVER		0x0002	/* Trigger override */
 #define B43_PHY_HT_RF_SEQ_TRIG			B43_PHY_EXTG(0x003)
 #define  B43_PHY_HT_RF_SEQ_TRIG_RX2TX		0x0001 /* RX2TX */
 #define  B43_PHY_HT_RF_SEQ_TRIG_TX2RX		0x0002 /* TX2RX */
-- 
1.7.10.4

