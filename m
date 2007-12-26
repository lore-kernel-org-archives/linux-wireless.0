Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:45241 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbXLZP10 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Dec 2007 10:27:26 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH v2] b43: Add definitions for MAC Control register
Date: Wed, 26 Dec 2007 16:26:36 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Message-Id: <200712261626.36956.mb@bu3sch.de> (sfid-20071226_152729_810715_595D42CB)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds some definitions for the MAC Control register
and uses them.
This basically is no functional change.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This is patch version 2.
Forgot to run a quilt refresh. Sorry.

John, this can probably be applied for 2.6.25. I don't care much.
This is some pre-work to get to get AP and IBSS working better, which
won't happen earlier than 2.6.25 anyway.

Index: wireless-2.6/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/b43.h	2007-12-26 15:24:53.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/b43.h	2007-12-26 16:12:38.000000000 +0100
@@ -35,8 +35,8 @@
 #define B43_MMIO_DMA4_IRQ_MASK		0x44
 #define B43_MMIO_DMA5_REASON		0x48
 #define B43_MMIO_DMA5_IRQ_MASK		0x4C
-#define B43_MMIO_MACCTL			0x120
-#define B43_MMIO_STATUS2_BITFIELD	0x124
+#define B43_MMIO_MACCTL			0x120	/* MAC control */
+#define B43_MMIO_MACCMD			0x124	/* MAC command */
 #define B43_MMIO_GEN_IRQ_REASON		0x128
 #define B43_MMIO_GEN_IRQ_MASK		0x12C
 #define B43_MMIO_RAM_CONTROL		0x130
@@ -320,6 +320,13 @@ enum {
 #define B43_MACCTL_DISCPMQ		0x40000000	/* Discard Power Management Queue */
 #define B43_MACCTL_GMODE		0x80000000	/* G Mode */
 
+/* MAC Command bitfield */
+#define B43_MACCMD_BEACON0_VALID	0x00000001	/* Beacon 0 in template RAM is busy/valid */
+#define B43_MACCMD_BEACON1_VALID	0x00000002	/* Beacon 1 in template RAM is busy/valid */
+#define B43_MACCMD_DFQ_VALID		0x00000004	/* Directed frame queue valid (IBSS PS mode, ATIM) */
+#define B43_MACCMD_CCA			0x00000008	/* Clear channel assessment */
+#define B43_MACCMD_BGNOISE		0x00000010	/* Background noise */
+
 /* 802.11 core specific TM State Low flags */
 #define B43_TMSLOW_GMODE		0x20000000	/* G Mode Enable */
 #define B43_TMSLOW_PLLREFSEL		0x00200000	/* PLL Frequency Reference Select */
@@ -689,7 +696,7 @@ struct b43_wldev {
 	int suspend_init_status;
 
 	bool bad_frames_preempt;	/* Use "Bad Frames Preemption" (default off) */
-	bool reg124_set_0x4;	/* Some variable to keep track of IRQ stuff. */
+	bool dfq_valid;		/* Directed frame queue valid (IBSS PS mode, ATIM) */
 	bool short_preamble;	/* TRUE, if short preamble is enabled. */
 	bool short_slot;	/* TRUE, if short slot timing is enabled. */
 	bool radio_hw_enable;	/* saved state of radio hardware enabled state */
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2007-12-26 15:33:22.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-12-26 16:09:05.000000000 +0100
@@ -993,9 +993,8 @@ static void b43_jssi_write(struct b43_wl
 static void b43_generate_noise_sample(struct b43_wldev *dev)
 {
 	b43_jssi_write(dev, 0x7F7F7F7F);
-	b43_write32(dev, B43_MMIO_STATUS2_BITFIELD,
-		    b43_read32(dev, B43_MMIO_STATUS2_BITFIELD)
-		    | (1 << 4));
+	b43_write32(dev, B43_MMIO_MACCMD,
+		    b43_read32(dev, B43_MMIO_MACCMD) | B43_MACCMD_BGNOISE);
 	B43_WARN_ON(dev->noisecalc.channel_at_start != dev->phy.channel);
 }
 
@@ -1081,18 +1080,18 @@ static void handle_irq_tbtt_indication(s
 		if (1 /*FIXME: the last PSpoll frame was sent successfully */ )
 			b43_power_saving_ctl_bits(dev, 0);
 	}
-	dev->reg124_set_0x4 = 0;
 	if (b43_is_mode(dev->wl, IEEE80211_IF_TYPE_IBSS))
-		dev->reg124_set_0x4 = 1;
+		dev->dfq_valid = 1;
 }
 
 static void handle_irq_atim_end(struct b43_wldev *dev)
 {
-	if (!dev->reg124_set_0x4 /*FIXME rename this variable */ )
-		return;
-	b43_write32(dev, B43_MMIO_STATUS2_BITFIELD,
-		    b43_read32(dev, B43_MMIO_STATUS2_BITFIELD)
-		    | 0x4);
+	if (dev->dfq_valid) {
+		b43_write32(dev, B43_MMIO_MACCMD,
+			    b43_read32(dev, B43_MMIO_MACCMD)
+			    | B43_MACCMD_DFQ_VALID);
+		dev->dfq_valid = 0;
+	}
 }
 
 static void handle_irq_pmq(struct b43_wldev *dev)
@@ -1271,7 +1270,7 @@ static int b43_refresh_cached_beacon(str
 
 static void b43_update_templates(struct b43_wldev *dev)
 {
-	u32 status;
+	u32 cmd;
 
 	B43_WARN_ON(!dev->cached_beacon);
 
@@ -1279,9 +1278,9 @@ static void b43_update_templates(struct 
 	b43_write_beacon_template(dev, 0x468, 0x1A, B43_CCK_RATE_1MB);
 	b43_write_probe_resp_template(dev, 0x268, 0x4A, B43_CCK_RATE_11MB);
 
-	status = b43_read32(dev, B43_MMIO_STATUS2_BITFIELD);
-	status |= 0x03;
-	b43_write32(dev, B43_MMIO_STATUS2_BITFIELD, status);
+	cmd = b43_read32(dev, B43_MMIO_MACCMD);
+	cmd |= B43_MACCMD_BEACON0_VALID | B43_MACCMD_BEACON1_VALID;
+	b43_write32(dev, B43_MMIO_MACCMD, cmd);
 }
 
 static void b43_refresh_templates(struct b43_wldev *dev, struct sk_buff *beacon)
@@ -1333,7 +1332,7 @@ static void handle_irq_beacon(struct b43
 		return;
 
 	dev->irq_savedstate &= ~B43_IRQ_BEACON;
-	status = b43_read32(dev, B43_MMIO_STATUS2_BITFIELD);
+	status = b43_read32(dev, B43_MMIO_MACCMD);
 
 	if (!dev->cached_beacon || ((status & 0x1) && (status & 0x2))) {
 		/* ACK beacon IRQ. */
@@ -1347,12 +1346,12 @@ static void handle_irq_beacon(struct b43
 	if (!(status & 0x1)) {
 		b43_write_beacon_template(dev, 0x68, 0x18, B43_CCK_RATE_1MB);
 		status |= 0x1;
-		b43_write32(dev, B43_MMIO_STATUS2_BITFIELD, status);
+		b43_write32(dev, B43_MMIO_MACCMD, status);
 	}
 	if (!(status & 0x2)) {
 		b43_write_beacon_template(dev, 0x468, 0x1A, B43_CCK_RATE_1MB);
 		status |= 0x2;
-		b43_write32(dev, B43_MMIO_STATUS2_BITFIELD, status);
+		b43_write32(dev, B43_MMIO_MACCMD, status);
 	}
 }
 
@@ -3177,8 +3176,8 @@ static void setup_struct_phy_for_init(st
 
 static void setup_struct_wldev_for_init(struct b43_wldev *dev)
 {
-	/* Flags */
-	dev->reg124_set_0x4 = 0;
+	dev->dfq_valid = 0;
+
 	/* Assume the radio is enabled. If it's not enabled, the state will
 	 * immediately get fixed on the first periodic work run. */
 	dev->radio_hw_enable = 1;
