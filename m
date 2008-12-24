Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:59536 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbYLXXkg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 18:40:36 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43/ssb: Add SPROM8 extraction and LP-PHY detection
Date: Thu, 25 Dec 2008 00:39:28 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812250039.28824.mb@bu3sch.de> (sfid-20081225_004044_707129_A1975627)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds detection code for the LP-PHY and SPROM
extraction code for version 8, which is needed by the LP-PHY and
newer N-PHY.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Please queue for 2.6.29


Index: wireless-testing/drivers/ssb/b43_pci_bridge.c
===================================================================
--- wireless-testing.orig/drivers/ssb/b43_pci_bridge.c
+++ wireless-testing/drivers/ssb/b43_pci_bridge.c
@@ -21,6 +21,7 @@ static const struct pci_device_id b43_pc
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4307) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4311) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4312) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4315) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4318) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4319) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4320) },
Index: wireless-testing/drivers/ssb/pci.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pci.c
+++ wireless-testing/drivers/ssb/pci.c
@@ -467,6 +467,51 @@ static void sprom_extract_r45(struct ssb
 	/* TODO - get remaining rev 4 stuff needed */
 }
 
+static void sprom_extract_r8(struct ssb_sprom *out, const u16 *in)
+{
+	int i;
+	u16 v;
+
+	/* extract the MAC address */
+	for (i = 0; i < 3; i++) {
+		v = in[SPOFF(SSB_SPROM1_IL0MAC) + i];
+		*(((__be16 *)out->il0mac) + i) = cpu_to_be16(v);
+	}
+	SPEX(country_code, SSB_SPROM8_CCODE, 0xFFFF, 0);
+	SPEX(boardflags_lo, SSB_SPROM8_BFLLO, 0xFFFF, 0);
+	SPEX(boardflags_hi, SSB_SPROM8_BFLHI, 0xFFFF, 0);
+	SPEX(ant_available_a, SSB_SPROM8_ANTAVAIL, SSB_SPROM8_ANTAVAIL_A,
+	     SSB_SPROM8_ANTAVAIL_A_SHIFT);
+	SPEX(ant_available_bg, SSB_SPROM8_ANTAVAIL, SSB_SPROM8_ANTAVAIL_BG,
+	     SSB_SPROM8_ANTAVAIL_BG_SHIFT);
+	SPEX(maxpwr_bg, SSB_SPROM8_MAXP_BG, SSB_SPROM8_MAXP_BG_MASK, 0);
+	SPEX(itssi_bg, SSB_SPROM8_MAXP_BG, SSB_SPROM8_ITSSI_BG,
+	     SSB_SPROM8_ITSSI_BG_SHIFT);
+	SPEX(maxpwr_a, SSB_SPROM8_MAXP_A, SSB_SPROM8_MAXP_A_MASK, 0);
+	SPEX(itssi_a, SSB_SPROM8_MAXP_A, SSB_SPROM8_ITSSI_A,
+	     SSB_SPROM8_ITSSI_A_SHIFT);
+	SPEX(gpio0, SSB_SPROM8_GPIOA, SSB_SPROM8_GPIOA_P0, 0);
+	SPEX(gpio1, SSB_SPROM8_GPIOA, SSB_SPROM8_GPIOA_P1,
+	     SSB_SPROM8_GPIOA_P1_SHIFT);
+	SPEX(gpio2, SSB_SPROM8_GPIOB, SSB_SPROM8_GPIOB_P2, 0);
+	SPEX(gpio3, SSB_SPROM8_GPIOB, SSB_SPROM8_GPIOB_P3,
+	     SSB_SPROM8_GPIOB_P3_SHIFT);
+
+	/* Extract the antenna gain values. */
+	SPEX(antenna_gain.ghz24.a0, SSB_SPROM8_AGAIN01,
+	     SSB_SPROM8_AGAIN0, SSB_SPROM8_AGAIN0_SHIFT);
+	SPEX(antenna_gain.ghz24.a1, SSB_SPROM8_AGAIN01,
+	     SSB_SPROM8_AGAIN1, SSB_SPROM8_AGAIN1_SHIFT);
+	SPEX(antenna_gain.ghz24.a2, SSB_SPROM8_AGAIN23,
+	     SSB_SPROM8_AGAIN2, SSB_SPROM8_AGAIN2_SHIFT);
+	SPEX(antenna_gain.ghz24.a3, SSB_SPROM8_AGAIN23,
+	     SSB_SPROM8_AGAIN3, SSB_SPROM8_AGAIN3_SHIFT);
+	memcpy(&out->antenna_gain.ghz5, &out->antenna_gain.ghz24,
+	       sizeof(out->antenna_gain.ghz5));
+
+	/* TODO - get remaining rev 8 stuff needed */
+}
+
 static int sprom_extract(struct ssb_bus *bus, struct ssb_sprom *out,
 			 const u16 *in, u16 size)
 {
@@ -487,15 +532,25 @@ static int sprom_extract(struct ssb_bus
 		out->revision = 4;
 		sprom_extract_r45(out, in);
 	} else {
-		if (out->revision == 0)
-			goto unsupported;
-		if (out->revision >= 1 && out->revision <= 3) {
+		switch (out->revision) {
+		case 1:
+		case 2:
+		case 3:
 			sprom_extract_r123(out, in);
-		}
-		if (out->revision == 4 || out->revision == 5)
+			break;
+		case 4:
+		case 5:
 			sprom_extract_r45(out, in);
-		if (out->revision > 5)
-			goto unsupported;
+			break;
+		case 8:
+			sprom_extract_r8(out, in);
+			break;
+		default:
+			ssb_printk(KERN_WARNING PFX "Unsupported SPROM"
+				   "  revision %d detected. Will extract"
+				   " v1\n", out->revision);
+			sprom_extract_r123(out, in);
+		}
 	}
 
 	if (out->boardflags_lo == 0xFFFF)
@@ -504,11 +559,6 @@ static int sprom_extract(struct ssb_bus
 		out->boardflags_hi = 0;  /* per specs */
 
 	return 0;
-unsupported:
-	ssb_printk(KERN_WARNING PFX "Unsupported SPROM revision %d "
-		   "detected. Will extract v1\n", out->revision);
-	sprom_extract_r123(out, in);
-	return 0;
 }
 
 static int ssb_pci_sprom_get(struct ssb_bus *bus,
Index: wireless-testing/include/linux/ssb/ssb_regs.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb_regs.h
+++ wireless-testing/include/linux/ssb/ssb_regs.h
@@ -326,6 +326,42 @@
 #define  SSB_SPROM5_GPIOB_P3		0xFF00	/* Pin 3 */
 #define  SSB_SPROM5_GPIOB_P3_SHIFT	8
 
+/* SPROM Revision 8 */
+#define SSB_SPROM8_BFLLO		0x1084	/* Boardflags (low 16 bits) */
+#define SSB_SPROM8_BFLHI		0x1086	/* Boardflags Hi */
+#define SSB_SPROM8_IL0MAC		0x108C	/* 6 byte MAC address */
+#define SSB_SPROM8_CCODE		0x1092	/* 2 byte country code */
+#define SSB_SPROM8_ANTAVAIL		0x109C  /* Antenna available bitfields*/
+#define SSB_SPROM8_ANTAVAIL_A		0xFF00	/* A-PHY bitfield */
+#define SSB_SPROM8_ANTAVAIL_A_SHIFT	8
+#define SSB_SPROM8_ANTAVAIL_BG		0x00FF	/* B-PHY and G-PHY bitfield */
+#define SSB_SPROM8_ANTAVAIL_BG_SHIFT	0
+#define SSB_SPROM8_AGAIN01		0x109E	/* Antenna Gain (in dBm Q5.2) */
+#define  SSB_SPROM8_AGAIN0		0x00FF	/* Antenna 0 */
+#define  SSB_SPROM8_AGAIN0_SHIFT	0
+#define  SSB_SPROM8_AGAIN1		0xFF00	/* Antenna 1 */
+#define  SSB_SPROM8_AGAIN1_SHIFT	8
+#define SSB_SPROM8_AGAIN23		0x10A0
+#define  SSB_SPROM8_AGAIN2		0x00FF	/* Antenna 2 */
+#define  SSB_SPROM8_AGAIN2_SHIFT	0
+#define  SSB_SPROM8_AGAIN3		0xFF00	/* Antenna 3 */
+#define  SSB_SPROM8_AGAIN3_SHIFT	8
+#define SSB_SPROM8_GPIOA		0x1096	/*Gen. Purpose IO # 0 and 1 */
+#define  SSB_SPROM8_GPIOA_P0		0x00FF	/* Pin 0 */
+#define  SSB_SPROM8_GPIOA_P1		0xFF00	/* Pin 1 */
+#define  SSB_SPROM8_GPIOA_P1_SHIFT	8
+#define SSB_SPROM8_GPIOB		0x1098	/* Gen. Purpose IO # 2 and 3 */
+#define  SSB_SPROM8_GPIOB_P2		0x00FF	/* Pin 2 */
+#define  SSB_SPROM8_GPIOB_P3		0xFF00	/* Pin 3 */
+#define  SSB_SPROM8_GPIOB_P3_SHIFT	8
+#define SSB_SPROM8_MAXP_BG		0x10C0  /* Max Power BG in path 1 */
+#define  SSB_SPROM8_MAXP_BG_MASK	0x00FF  /* Mask for Max Power BG */
+#define  SSB_SPROM8_ITSSI_BG		0xFF00	/* Mask for path 1 itssi_bg */
+#define  SSB_SPROM8_ITSSI_BG_SHIFT	8
+#define SSB_SPROM8_MAXP_A		0x10C8  /* Max Power A in path 1 */
+#define  SSB_SPROM8_MAXP_A_MASK		0x00FF  /* Mask for Max Power A */
+#define  SSB_SPROM8_ITSSI_A		0xFF00	/* Mask for path 1 itssi_a */
+#define  SSB_SPROM8_ITSSI_A_SHIFT	8
 
 /* Values for SSB_SPROM1_BINF_CCODE */
 enum {
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -97,6 +97,7 @@ static const struct ssb_device_id b43_ss
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 10),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 11),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 13),
+	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 15),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 16),
 	SSB_DEVTABLE_END
 };
@@ -3757,6 +3758,12 @@ static int b43_phy_versioning(struct b43
 			unsupported = 1;
 		break;
 #endif
+#ifdef CONFIG_B43_PHY_LP
+	case B43_PHYTYPE_LP:
+		if (phy_rev > 1)
+			unsupported = 1;
+		break;
+#endif
 	default:
 		unsupported = 1;
 	};
@@ -3809,6 +3816,10 @@ static int b43_phy_versioning(struct b43
 		if (radio_ver != 0x2055 && radio_ver != 0x2056)
 			unsupported = 1;
 		break;
+	case B43_PHYTYPE_LP:
+		if (radio_ver != 0x2062)
+			unsupported = 1;
+		break;
 	default:
 		B43_WARN_ON(1);
 	}
@@ -4403,6 +4414,7 @@ static int b43_wireless_core_attach(stru
 			break;
 		case B43_PHYTYPE_G:
 		case B43_PHYTYPE_N:
+		case B43_PHYTYPE_LP:
 			have_2ghz_phy = 1;
 			break;
 		default:

-- 
Greetings, Michael.
