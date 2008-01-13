Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:42831 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYAMUKB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 15:10:01 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Add boardflags_hi field to the sprom data structure
Date: Sun, 13 Jan 2008 21:08:24 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801132108.24556.mb@bu3sch.de> (sfid-20080113_201014_858733_8DD11795)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add boardflags-high.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

For 2.6.25

Index: wireless-2.6/drivers/ssb/pci.c
===================================================================
--- wireless-2.6.orig/drivers/ssb/pci.c	2008-01-09 16:59:33.000000000 +0100
+++ wireless-2.6/drivers/ssb/pci.c	2008-01-13 21:01:14.000000000 +0100
@@ -374,12 +374,14 @@ static void sprom_extract_r123(struct ss
 	     SSB_SPROM1_MAXPWR_A_SHIFT);
 	SPEX(maxpwr_bg, SSB_SPROM1_MAXPWR, SSB_SPROM1_MAXPWR_BG, 0);
 	SPEX(itssi_a, SSB_SPROM1_ITSSI, SSB_SPROM1_ITSSI_A,
 	     SSB_SPROM1_ITSSI_A_SHIFT);
 	SPEX(itssi_bg, SSB_SPROM1_ITSSI, SSB_SPROM1_ITSSI_BG, 0);
 	SPEX(boardflags_lo, SSB_SPROM1_BFLLO, 0xFFFF, 0);
+	if (out->revision >= 2)
+		SPEX(boardflags_hi, SSB_SPROM2_BFLHI, 0xFFFF, 0);
 
 	/* Extract the antenna gain values. */
 	gain = r123_extract_antgain(out->revision, in,
 				    SSB_SPROM1_AGAIN_BG,
 				    SSB_SPROM1_AGAIN_BG_SHIFT);
 	out->antenna_gain.ghz24.a0 = gain;
@@ -415,12 +417,13 @@ static void sprom_extract_r4(struct ssb_
 	}
 	SPEX(et0phyaddr, SSB_SPROM4_ETHPHY, SSB_SPROM4_ETHPHY_ET0A, 0);
 	SPEX(et1phyaddr, SSB_SPROM4_ETHPHY, SSB_SPROM4_ETHPHY_ET1A,
 	     SSB_SPROM4_ETHPHY_ET1A_SHIFT);
 	SPEX(country_code, SSB_SPROM4_CCODE, 0xFFFF, 0);
 	SPEX(boardflags_lo, SSB_SPROM4_BFLLO, 0xFFFF, 0);
+	SPEX(boardflags_hi, SSB_SPROM4_BFLHI, 0xFFFF, 0);
 	SPEX(ant_available_a, SSB_SPROM4_ANTAVAIL, SSB_SPROM4_ANTAVAIL_A,
 	     SSB_SPROM4_ANTAVAIL_A_SHIFT);
 	SPEX(ant_available_bg, SSB_SPROM4_ANTAVAIL, SSB_SPROM4_ANTAVAIL_BG,
 	     SSB_SPROM4_ANTAVAIL_BG_SHIFT);
 	SPEX(maxpwr_bg, SSB_SPROM4_MAXP_BG, SSB_SPROM4_MAXP_BG_MASK, 0);
 	SPEX(itssi_bg, SSB_SPROM4_MAXP_BG, SSB_SPROM4_ITSSI_BG,
Index: wireless-2.6/include/linux/ssb/ssb.h
===================================================================
--- wireless-2.6.orig/include/linux/ssb/ssb.h	2008-01-09 16:59:33.000000000 +0100
+++ wireless-2.6/include/linux/ssb/ssb.h	2008-01-13 21:00:39.000000000 +0100
@@ -40,12 +40,13 @@ struct ssb_sprom {
 	u8 gpio3;		/* GPIO pin 3 */
 	u16 maxpwr_a;		/* A-PHY Amplifier Max Power (in dBm Q5.2) */
 	u16 maxpwr_bg;		/* B/G-PHY Amplifier Max Power (in dBm Q5.2) */
 	u8 itssi_a;		/* Idle TSSI Target for A-PHY */
 	u8 itssi_bg;		/* Idle TSSI Target for B/G-PHY */
 	u16 boardflags_lo;	/* Boardflags (low 16 bits) */
+	u16 boardflags_hi;	/* Boardflags (high 16 bits) */
 
 	/* Antenna gain values for up to 4 antennas
 	 * on each band. Values in dBm/4 (Q5.2). Negative gain means the
 	 * loss in the connectors is bigger than the gain. */
 	struct {
 		struct {
