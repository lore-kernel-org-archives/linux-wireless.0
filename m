Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:1349 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbYAAASR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Dec 2007 19:18:17 -0500
Received: by ug-out-1314.google.com with SMTP id z38so2349171ugc.16
        for <linux-wireless@vger.kernel.org>; Mon, 31 Dec 2007 16:18:17 -0800 (PST)
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] b44: power down PHY when interface down
Date: Tue, 1 Jan 2008 01:17:54 +0100
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mb@bu3sch.de
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200801010117.54411.mboton@gmail.com> (sfid-20080101_001837_170889_C20CE6DD)
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is just this patch (http://lkml.org/lkml/2007/7/1/51) but adapted
to the 'b44' ssb driver.

Signed-off-by: Miguel Bot=C3=B3n <mboton@gmail.com>

diff --git a/drivers/net/b44.c b/drivers/net/b44.c
index 49e9172..ea2a2b5 100644
--- a/drivers/net/b44.c
+++ b/drivers/net/b44.c
@@ -128,6 +128,8 @@ static void b44_init_rings(struct b44 *);
 #define B44_FULL_RESET		1
 #define B44_FULL_RESET_SKIP_PHY	2
 #define B44_PARTIAL_RESET	3
+#define B44_CHIP_RESET_FULL	4
+#define B44_CHIP_RESET_PARTIAL	5
=20
 static void b44_init_hw(struct b44 *, int);
=20
@@ -1259,7 +1261,7 @@ static void b44_clear_stats(struct b44 *bp)
 }
=20
 /* bp->lock is held. */
-static void b44_chip_reset(struct b44 *bp)
+static void b44_chip_reset(struct b44 *bp, int reset_kind)
 {
 	struct ssb_device *sdev =3D bp->sdev;
=20
@@ -1281,6 +1283,13 @@ static void b44_chip_reset(struct b44 *bp)
 	ssb_device_enable(bp->sdev, 0);
 	b44_clear_stats(bp);
=20
+	/*
+	 * Don't enable PHY if we are doing a partial reset
+	 * we are probably going to power down
+	 */
+	if (reset_kind =3D=3D B44_CHIP_RESET_PARTIAL)
+		return;
+
 	switch (sdev->bus->bustype) {
 	case SSB_BUSTYPE_SSB:
 		bw32(bp, B44_MDIO_CTRL, (MDIO_CTRL_PREAMBLE |
@@ -1316,7 +1325,14 @@ static void b44_chip_reset(struct b44 *bp)
 static void b44_halt(struct b44 *bp)
 {
 	b44_disable_ints(bp);
-	b44_chip_reset(bp);
+	/* reset PHY */
+	b44_phy_reset(bp);
+	/* power down PHY */
+	printk(KERN_INFO PFX "%s: powering down PHY\n", bp->dev->name);
+	bw32(bp, B44_MAC_CTRL, MAC_CTRL_PHY_PDOWN);
+	/* now reset the chip, but without enabling the MAC&PHY
+	 * part of it. This has to be done _after_ we shut down the PHY */
+	b44_chip_reset(bp, B44_CHIP_RESET_PARTIAL);
 }
=20
 /* bp->lock is held. */
@@ -1365,7 +1381,7 @@ static void b44_init_hw(struct b44 *bp, int reset=
_kind)
 {
 	u32 val;
=20
-	b44_chip_reset(bp);
+	b44_chip_reset(bp, B44_CHIP_RESET_FULL);
 	if (reset_kind =3D=3D B44_FULL_RESET) {
 		b44_phy_reset(bp);
 		b44_setup_phy(bp);
@@ -1422,7 +1438,7 @@ static int b44_open(struct net_device *dev)
 	err =3D request_irq(dev->irq, b44_interrupt, IRQF_SHARED, dev->name, =
dev);
 	if (unlikely(err < 0)) {
 		napi_disable(&bp->napi);
-		b44_chip_reset(bp);
+		b44_chip_reset(bp, B44_CHIP_RESET_PARTIAL);
 		b44_free_rings(bp);
 		b44_free_consistent(bp);
 		goto out;
@@ -2188,7 +2204,7 @@ static int __devinit b44_init_one(struct ssb_devi=
ce *sdev,
 	/* Chip reset provides power to the b44 MAC & PCI cores, which
 	 * is necessary for MAC register access.
 	 */
-	b44_chip_reset(bp);
+	b44_chip_reset(bp, B44_CHIP_RESET_FULL);
=20
 	printk(KERN_INFO "%s: Broadcom 44xx/47xx 10/100BaseT Ethernet %s\n",
 	       dev->name, print_mac(mac, dev->dev_addr));
@@ -2212,6 +2228,7 @@ static void __devexit b44_remove_one(struct ssb_d=
evice *sdev)
 	unregister_netdev(dev);
 	ssb_bus_may_powerdown(sdev->bus);
 	free_netdev(dev);
+	ssb_pcihost_set_power_state(sdev, PCI_D3hot);
 	ssb_set_drvdata(sdev, NULL);
 }
=20
@@ -2240,6 +2257,7 @@ static int b44_suspend(struct ssb_device *sdev, p=
m_message_t state)
 		b44_setup_wol(bp);
 	}
=20
+	ssb_pcihost_set_power_state(sdev, PCI_D3hot);
 	return 0;
 }
=20

--=20
	Miguel Bot=C3=B3n
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
