Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63981 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab1IUTEc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 15:04:32 -0400
Received: by wyg34 with SMTP id 34so2223980wyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 12:04:30 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] b43: add missing MMIO defines
Date: Wed, 21 Sep 2011 21:44:13 +0200
Message-Id: <1316634255-3116-1-git-send-email-zajec5@gmail.com> (sfid-20110921_210436_235558_B2685BA1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h  |   40 ++++++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/b43/main.c |   38 ++++++++++++++++++++----------------
 2 files changed, 60 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index f8615cd..447a230 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -107,6 +107,40 @@
 #define B43_MMIO_RADIO_HWENABLED_LO	0x49A
 #define B43_MMIO_GPIO_CONTROL		0x49C
 #define B43_MMIO_GPIO_MASK		0x49E
+#define B43_MMIO_TXE0_CTL		0x500
+#define B43_MMIO_TXE0_AUX		0x502
+#define B43_MMIO_TXE0_TS_LOC		0x504
+#define B43_MMIO_TXE0_TIME_OUT		0x506
+#define B43_MMIO_TXE0_WM_0		0x508
+#define B43_MMIO_TXE0_WM_1		0x50A
+#define B43_MMIO_TXE0_PHYCTL		0x50C
+#define B43_MMIO_TXE0_STATUS		0x50E
+#define B43_MMIO_TXE0_MMPLCP0		0x510
+#define B43_MMIO_TXE0_MMPLCP1		0x512
+#define B43_MMIO_TXE0_PHYCTL1		0x514
+#define B43_MMIO_XMTFIFODEF		0x520
+#define B43_MMIO_XMTFIFO_FRAME_CNT	0x522	/* core rev>= 16 only */
+#define B43_MMIO_XMTFIFO_BYTE_CNT	0x524	/* core rev>= 16 only */
+#define B43_MMIO_XMTFIFO_HEAD		0x526	/* core rev>= 16 only */
+#define B43_MMIO_XMTFIFO_RD_PTR		0x528	/* core rev>= 16 only */
+#define B43_MMIO_XMTFIFO_WR_PTR		0x52A	/* core rev>= 16 only */
+#define B43_MMIO_XMTFIFODEF1		0x52C	/* core rev>= 16 only */
+#define B43_MMIO_XMTFIFOCMD		0x540
+#define B43_MMIO_XMTFIFOFLUSH		0x542
+#define B43_MMIO_XMTFIFOTHRESH		0x544
+#define B43_MMIO_XMTFIFORDY		0x546
+#define B43_MMIO_XMTFIFOPRIRDY		0x548
+#define B43_MMIO_XMTFIFORQPRI		0x54A
+#define B43_MMIO_XMTTPLATETXPTR		0x54C
+#define B43_MMIO_XMTTPLATEPTR		0x550
+#define B43_MMIO_SMPL_CLCT_STRPTR	0x552	/* core rev>= 22 only */
+#define B43_MMIO_SMPL_CLCT_STPPTR	0x554	/* core rev>= 22 only */
+#define B43_MMIO_SMPL_CLCT_CURPTR	0x556	/* core rev>= 22 only */
+#define B43_MMIO_XMTTPLATEDATALO	0x560
+#define B43_MMIO_XMTTPLATEDATAHI	0x562
+#define B43_MMIO_XMTSEL			0x568
+#define B43_MMIO_XMTTXCNT		0x56A
+#define B43_MMIO_XMTTXSHMADDR		0x56C
 #define B43_MMIO_TSF_CFP_START_LOW	0x604
 #define B43_MMIO_TSF_CFP_START_HIGH	0x606
 #define B43_MMIO_TSF_CFP_PRETBTT	0x612
@@ -118,12 +152,16 @@
 #define B43_MMIO_TSF_3			0x638	/* core rev < 3 only */
 #define B43_MMIO_RNG			0x65A
 #define B43_MMIO_IFSSLOT		0x684	/* Interframe slot time */
-#define B43_MMIO_IFSCTL			0x688 /* Interframe space control */
+#define B43_MMIO_IFSCTL			0x688	/* Interframe space control */
+#define B43_MMIO_IFSSTAT		0x690
+#define B43_MMIO_IFSMEDBUSYCTL		0x692
+#define B43_MMIO_IFTXDUR		0x694
 #define  B43_MMIO_IFSCTL_USE_EDCF	0x0004
 #define B43_MMIO_POWERUP_DELAY		0x6A8
 #define B43_MMIO_BTCOEX_CTL		0x6B4 /* Bluetooth Coexistence Control */
 #define B43_MMIO_BTCOEX_STAT		0x6B6 /* Bluetooth Coexistence Status */
 #define B43_MMIO_BTCOEX_TXCTL		0x6B8 /* Bluetooth Coexistence Transmit Control */
+#define B43_MMIO_WEPCTL			0x7C0
 
 /* SPROM boardflags_lo values */
 #define B43_BFL_BTCOEXIST		0x0001	/* implements Bluetooth coexistance */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 56fa3a3..9437c9a 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -729,52 +729,56 @@ void b43_dummy_transmission(struct b43_wldev *dev, bool ofdm, bool pa_on)
 	for (i = 0; i < 5; i++)
 		b43_ram_write(dev, i * 4, buffer[i]);
 
-	b43_write16(dev, 0x0568, 0x0000);
+	b43_write16(dev, B43_MMIO_XMTSEL, 0x0000);
+
 	if (dev->dev->core_rev < 11)
-		b43_write16(dev, 0x07C0, 0x0000);
+		b43_write16(dev, B43_MMIO_WEPCTL, 0x0000);
 	else
-		b43_write16(dev, 0x07C0, 0x0100);
+		b43_write16(dev, B43_MMIO_WEPCTL, 0x0100);
+
 	value = (ofdm ? 0x41 : 0x40);
-	b43_write16(dev, 0x050C, value);
+	b43_write16(dev, B43_MMIO_TXE0_PHYCTL, value);
 	if ((phy->type == B43_PHYTYPE_N) || (phy->type == B43_PHYTYPE_LP))
-		b43_write16(dev, 0x0514, 0x1A02);
-	b43_write16(dev, 0x0508, 0x0000);
-	b43_write16(dev, 0x050A, 0x0000);
-	b43_write16(dev, 0x054C, 0x0000);
-	b43_write16(dev, 0x056A, 0x0014);
-	b43_write16(dev, 0x0568, 0x0826);
-	b43_write16(dev, 0x0500, 0x0000);
+		b43_write16(dev, B43_MMIO_TXE0_PHYCTL1, 0x1A02);
+
+	b43_write16(dev, B43_MMIO_TXE0_WM_0, 0x0000);
+	b43_write16(dev, B43_MMIO_TXE0_WM_1, 0x0000);
+
+	b43_write16(dev, B43_MMIO_XMTTPLATETXPTR, 0x0000);
+	b43_write16(dev, B43_MMIO_XMTTXCNT, 0x0014);
+	b43_write16(dev, B43_MMIO_XMTSEL, 0x0826);
+	b43_write16(dev, B43_MMIO_TXE0_CTL, 0x0000);
 	if (!pa_on && (phy->type == B43_PHYTYPE_N)) {
 		//SPEC TODO
 	}
 
 	switch (phy->type) {
 	case B43_PHYTYPE_N:
-		b43_write16(dev, 0x0502, 0x00D0);
+		b43_write16(dev, B43_MMIO_TXE0_AUX, 0x00D0);
 		break;
 	case B43_PHYTYPE_LP:
-		b43_write16(dev, 0x0502, 0x0050);
+		b43_write16(dev, B43_MMIO_TXE0_AUX, 0x0050);
 		break;
 	default:
-		b43_write16(dev, 0x0502, 0x0030);
+		b43_write16(dev, B43_MMIO_TXE0_AUX, 0x0030);
 	}
 
 	if (phy->radio_ver == 0x2050 && phy->radio_rev <= 0x5)
 		b43_radio_write16(dev, 0x0051, 0x0017);
 	for (i = 0x00; i < max_loop; i++) {
-		value = b43_read16(dev, 0x050E);
+		value = b43_read16(dev, B43_MMIO_TXE0_STATUS);
 		if (value & 0x0080)
 			break;
 		udelay(10);
 	}
 	for (i = 0x00; i < 0x0A; i++) {
-		value = b43_read16(dev, 0x050E);
+		value = b43_read16(dev, B43_MMIO_TXE0_STATUS);
 		if (value & 0x0400)
 			break;
 		udelay(10);
 	}
 	for (i = 0x00; i < 0x19; i++) {
-		value = b43_read16(dev, 0x0690);
+		value = b43_read16(dev, B43_MMIO_IFSSTAT);
 		if (!(value & 0x0100))
 			break;
 		udelay(10);
-- 
1.7.3.4

