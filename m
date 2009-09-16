Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:56613 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758905AbZIPT1N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 15:27:13 -0400
Received: by bwz19 with SMTP id 19so3736574bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 12:27:15 -0700 (PDT)
Subject: [PATCH 1/2] b43: Add lpphy_update_tx_power_npt function to improve
 TX power handling on LP PHYs
From: Thomas Ilnseher <illth@gmx.de>
To: John Linville <linville@tuxdriver.com>
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	=?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 21:27:16 +0200
Message-Id: <1253129236.2989.37.camel@note>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The lpphy_update_tx_power_npt routine is currently missing in the code.

I added the routine according to the specs.

Signed-off-by: Thomas Ilnseher <illth@gmx.de>
---
diff -uNr compat-wireless-2009-09-15/drivers/net/wireless/b43/b43.h compat-wireless-2009-09-15.mod/drivers/net/wireless/b43/b43.h
--- compat-wireless-2009-09-15/drivers/net/wireless/b43/b43.h	2009-09-15 06:13:53.000000000 +0200
+++ compat-wireless-2009-09-15.mod/drivers/net/wireless/b43/b43.h	2009-09-15 23:35:02.651859159 +0200
@@ -255,7 +255,10 @@
 #define B43_SHM_SH_MAXBFRAMES		0x0080	/* Maximum number of frames in a burst */
 #define B43_SHM_SH_SPUWKUP		0x0094	/* pre-wakeup for synth PU in us */
 #define B43_SHM_SH_PRETBTT		0x0096	/* pre-TBTT in us */
-
+/* MAC Statistics */
+#define B43_SHM_SH_TX_FRAMES_SENT	0x00E0	/* # TX Frames sent */
+#define B43_SHM_SH_TX_RTS		0x00E2	/* # TX RTS */
+#define B43_SHM_SH_TX_CTS		0x00E4	/* # TX CTS */
 /* SHM_SCRATCH offsets */
 #define B43_SHM_SC_MINCONT		0x0003	/* Minimum contention window */
 #define B43_SHM_SC_MAXCONT		0x0004	/* Maximum contention window */
diff -uNr compat-wireless-2009-09-15/drivers/net/wireless/b43/phy_lp.c compat-wireless-2009-09-15.mod/drivers/net/wireless/b43/phy_lp.c
--- compat-wireless-2009-09-15/drivers/net/wireless/b43/phy_lp.c	2009-09-15 06:13:53.000000000 +0200
+++ compat-wireless-2009-09-15.mod/drivers/net/wireless/b43/phy_lp.c	2009-09-16 00:00:20.712857949 +0200
@@ -1103,6 +1103,28 @@
 			(u16)~B43_LPPHY_TX_PWR_CTL_CMD_MODE, ctl);
 }
 
+static void lpphy_update_tx_power_npt(struct b43_wldev *dev)
+{
+	u16 tx_cnt;
+	u16 npt;
+	u16 s3;
+
+	s3 = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_TX_FRAMES_SENT);
+	tx_cnt = s3 - dev->phy.lp->tssi_tx_count;
+	npt = (b43_phy_read(dev, B43_LPPHY_TX_PWR_CTL_NNUM) & 0x700) >> 8;
+
+	if ((1 << (npt & 0x1F)) >= tx_cnt)
+		return;
+	/* NB: Spec says do the stuff if xxx < tx_cnt, so return on xxx > txcnt */
+	dev->phy.lp->tssi_tx_count = s3;
+	if (npt < 7) {
+		npt++;
+		b43_phy_maskset(dev, B43_LPPHY_TX_PWR_CTL_NNUM, 0xF8FF, (npt << 8));
+	}
+	dev->phy.lp->tssi_npt = npt;
+	dev->phy.lp->tssi_idx = (b43_phy_read(dev, B43_LPPHY_TX_PWR_CTL_STAT) & 0x7F00) >> 8;
+}
+
 static void lpphy_set_tx_power_control(struct b43_wldev *dev,
 				       enum b43_lpphy_txpctl_mode mode)
 {
@@ -1116,7 +1138,7 @@
 	lpphy->txpctl_mode = mode;
 
 	if (oldmode == B43_LPPHY_TXPCTL_HW) {
-		//TODO Update TX Power NPT
+		lpphy_update_tx_power_npt(dev);
 		//TODO Clear all TX Power offsets
 	} else {
 		if (mode == B43_LPPHY_TXPCTL_HW) {


