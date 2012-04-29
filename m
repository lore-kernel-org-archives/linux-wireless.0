Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44613 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882Ab2D2AF0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:05:26 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	arend@broadcom.com, m@bues.ch, ralf@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 6/8] ssb: fill board_rev attribute from sprom
Date: Sun, 29 Apr 2012 02:04:11 +0200
Message-Id: <1335657853-23925-7-git-send-email-hauke@hauke-m.de> (sfid-20120429_020534_958793_66AD91C3)
In-Reply-To: <1335657853-23925-1-git-send-email-hauke@hauke-m.de>
References: <1335657853-23925-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This attribute is now used in b43 driver and should be filled for all
sprom versions.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/pci.c            |    2 ++
 include/linux/ssb/ssb_regs.h |    1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index 82589d4..2cb604d 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -458,6 +458,7 @@ static void sprom_extract_r45(struct ssb_sprom *out, const u16 *in)
 	SPEX(et0phyaddr, SSB_SPROM4_ETHPHY, SSB_SPROM4_ETHPHY_ET0A, 0);
 	SPEX(et1phyaddr, SSB_SPROM4_ETHPHY, SSB_SPROM4_ETHPHY_ET1A,
 	     SSB_SPROM4_ETHPHY_ET1A_SHIFT);
+	SPEX(board_rev, SSB_SPROM4_BOARDREV, 0xFFFF, 0);
 	if (out->revision == 4) {
 		SPEX(alpha2[0], SSB_SPROM4_CCODE, 0xff00, 8);
 		SPEX(alpha2[1], SSB_SPROM4_CCODE, 0x00ff, 0);
@@ -530,6 +531,7 @@ static void sprom_extract_r8(struct ssb_sprom *out, const u16 *in)
 		v = in[SPOFF(SSB_SPROM8_IL0MAC) + i];
 		*(((__be16 *)out->il0mac) + i) = cpu_to_be16(v);
 	}
+	SPEX(board_rev, SSB_SPROM8_BOARDREV, 0xFFFF, 0);
 	SPEX(alpha2[0], SSB_SPROM8_CCODE, 0xff00, 8);
 	SPEX(alpha2[1], SSB_SPROM8_CCODE, 0x00ff, 0);
 	SPEX(boardflags_lo, SSB_SPROM8_BFLLO, 0xFFFF, 0);
diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
index d33bd8f..543795f 100644
--- a/include/linux/ssb/ssb_regs.h
+++ b/include/linux/ssb/ssb_regs.h
@@ -268,6 +268,7 @@
 #define  SSB_SPROM3_OFDMGPO		0x107A	/* G-PHY OFDM Power Offset (4 bytes, BigEndian) */
 
 /* SPROM Revision 4 */
+#define SSB_SPROM4_BOARDREV		0x0042	/* Board revision */
 #define SSB_SPROM4_BFLLO		0x0044	/* Boardflags (low 16 bits) */
 #define SSB_SPROM4_BFLHI		0x0046  /* Board Flags Hi */
 #define SSB_SPROM4_BFL2LO		0x0048	/* Board flags 2 (low 16 bits) */
-- 
1.7.9.5

