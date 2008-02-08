Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:51167 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933157AbYBHFdI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 00:33:08 -0500
Date: Fri, 8 Feb 2008 06:31:10 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [PATCH 1/4] b43legacy: add definitions for MAC control register
Message-ID: <20080208063110.19abd0e6@morte> (sfid-20080208_053339_531486_0D97A873)
In-Reply-To: <20080208051650.372197299@polimi.it>
References: <20080208051650.372197299@polimi.it>>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds some definitions for the MAC control register and uses them. This is
basically no functional change.

The patch by Michael Buesch has been ported to b43legacy.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
Index: wireless-2.6/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/b43legacy.h
+++ wireless-2.6/drivers/net/wireless/b43legacy/b43legacy.h
@@ -195,6 +195,13 @@
 #define B43legacy_MACCTL_TBTTHOLD	0x10000000 /* TBTT Hold */
 #define B43legacy_MACCTL_GMODE		0x80000000 /* G Mode */

+/* MAC Command bitfield */
+#define B43legacy_MACCMD_BEACON0_VALID	0x00000001 /* Beacon 0 in template RAM is busy/valid */
+#define B43legacy_MACCMD_BEACON1_VALID	0x00000002 /* Beacon 1 in template RAM is busy/valid */
+#define B43legacy_MACCMD_DFQ_VALID	0x00000004 /* Directed frame queue valid (IBSS PS mode, ATIM) */
+#define B43legacy_MACCMD_CCA		0x00000008 /* Clear channel assessment */
+#define B43legacy_MACCMD_BGNOISE	0x00000010 /* Background noise */
+
 /* 802.11 core specific TM State Low flags */
 #define B43legacy_TMSLOW_GMODE		0x20000000 /* G Mode Enable */
 #define B43legacy_TMSLOW_PLLREFSEL	0x00200000 /* PLL Freq Ref Select */
@@ -641,7 +648,7 @@ struct b43legacy_wldev {

 	bool __using_pio;	/* Using pio rather than dma. */
 	bool bad_frames_preempt;/* Use "Bad Frames Preemption". */
-	bool reg124_set_0x4;	/* Variable to keep track of IRQ. */
+	bool dfq_valid;		/* Directed frame queue valid (IBSS PS mode, ATIM). */
 	bool short_preamble;	/* TRUE if using short preamble. */
 	bool short_slot;	/* TRUE if using short slot timing. */
 	bool radio_hw_enable;	/* State of radio hardware enable bit. */
Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c
@@ -803,9 +803,8 @@ static void b43legacy_generate_noise_sam
 {
 	b43legacy_jssi_write(dev, 0x7F7F7F7F);
 	b43legacy_write32(dev, B43legacy_MMIO_MACCMD,
-			  b43legacy_read32(dev,
-			  B43legacy_MMIO_MACCMD)
-			  | (1 << 4));
+			  b43legacy_read32(dev, B43legacy_MMIO_MACCMD)
+			  | B43legacy_MACCMD_BGNOISE);
 	B43legacy_WARN_ON(dev->noisecalc.channel_at_start !=
 			    dev->phy.channel);
 }
@@ -894,18 +893,18 @@ static void handle_irq_tbtt_indication(s
 		if (1/*FIXME: the last PSpoll frame was sent successfully */)
 			b43legacy_power_saving_ctl_bits(dev, -1, -1);
 	}
-	dev->reg124_set_0x4 = 0;
 	if (b43legacy_is_mode(dev->wl, IEEE80211_IF_TYPE_IBSS))
-		dev->reg124_set_0x4 = 1;
+		dev->dfq_valid = 1;
 }

 static void handle_irq_atim_end(struct b43legacy_wldev *dev)
 {
-	if (!dev->reg124_set_0x4) /*FIXME rename this variable*/
-		return;
-	b43legacy_write32(dev, B43legacy_MMIO_MACCMD,
-			  b43legacy_read32(dev, B43legacy_MMIO_MACCMD)
-			  | 0x4);
+	if (dev->dfq_valid) {
+		b43legacy_write32(dev, B43legacy_MMIO_MACCMD,
+				  b43legacy_read32(dev, B43legacy_MMIO_MACCMD)
+				  | B43legacy_MACCMD_DFQ_VALID);
+		dev->dfq_valid = 0;
+	}
 }

 static void handle_irq_pmq(struct b43legacy_wldev *dev)
@@ -1105,7 +1104,7 @@ static int b43legacy_refresh_cached_beac

 static void b43legacy_update_templates(struct b43legacy_wldev *dev)
 {
-	u32 status;
+	u32 cmd;

 	B43legacy_WARN_ON(!dev->cached_beacon);

@@ -1116,9 +1115,9 @@ static void b43legacy_update_templates(s
 	b43legacy_write_probe_resp_template(dev, 0x268, 0x4A,
 					    &b43legacy_b_ratetable[0]);

-	status = b43legacy_read32(dev, B43legacy_MMIO_MACCMD);
-	status |= 0x03;
-	b43legacy_write32(dev, B43legacy_MMIO_MACCMD, status);
+	cmd = b43legacy_read32(dev, B43legacy_MMIO_MACCMD);
+	cmd |= B43legacy_MACCMD_BEACON0_VALID | B43legacy_MACCMD_BEACON1_VALID;
+	b43legacy_write32(dev, B43legacy_MMIO_MACCMD, cmd);
 }

 static void b43legacy_refresh_templates(struct b43legacy_wldev *dev,
@@ -2925,7 +2924,7 @@ static void setup_struct_phy_for_init(st
 static void setup_struct_wldev_for_init(struct b43legacy_wldev *dev)
 {
 	/* Flags */
-	dev->reg124_set_0x4 = 0;
+	dev->dfq_valid = 0;

 	/* Stats */
 	memset(&dev->stats, 0, sizeof(dev->stats));

-- 
Ciao
Stefano
