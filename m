Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50049 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab3CUTZ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 15:25:29 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org, m@bues.ch,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] ssb: read additional sprom v2 and v3 attributes.
Date: Thu, 21 Mar 2013 20:25:21 +0100
Message-Id: <1363893921-9208-1-git-send-email-hauke@hauke-m.de> (sfid-20130321_202533_410986_9757A567)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These attributes should be in the sprom for rev 2 and 3, but they were
not read out.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/pci.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index 63ff69f..d5d90cf 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -347,6 +347,21 @@ static s8 r123_extract_antgain(u8 sprom_revision, const u16 *in,
 	return (s8)gain;
 }
 
+static void sprom_extract_r23(struct ssb_sprom *out, const u16 *in)
+{
+	SPEX(boardflags_hi, SSB_SPROM2_BFLHI, 0xFFFF, 0);
+	SPEX(opo, SSB_SPROM2_OPO, SSB_SPROM2_OPO_VALUE, 0);
+	SPEX(pa1lob0, SSB_SPROM2_PA1LOB0, 0xFFFF, 0);
+	SPEX(pa1lob1, SSB_SPROM2_PA1LOB1, 0xFFFF, 0);
+	SPEX(pa1lob2, SSB_SPROM2_PA1LOB2, 0xFFFF, 0);
+	SPEX(pa1hib0, SSB_SPROM2_PA1HIB0, 0xFFFF, 0);
+	SPEX(pa1hib1, SSB_SPROM2_PA1HIB1, 0xFFFF, 0);
+	SPEX(pa1hib2, SSB_SPROM2_PA1HIB2, 0xFFFF, 0);
+	SPEX(maxpwr_ah, SSB_SPROM2_MAXP_A, SSB_SPROM2_MAXP_A_HI, 0);
+	SPEX(maxpwr_al, SSB_SPROM2_MAXP_A, SSB_SPROM2_MAXP_A_LO,
+	     SSB_SPROM2_MAXP_A_LO_SHIFT);
+}
+
 static void sprom_extract_r123(struct ssb_sprom *out, const u16 *in)
 {
 	u16 loc[3];
@@ -395,8 +410,7 @@ static void sprom_extract_r123(struct ssb_sprom *out, const u16 *in)
 	     SSB_SPROM1_ITSSI_A_SHIFT);
 	SPEX(itssi_bg, SSB_SPROM1_ITSSI, SSB_SPROM1_ITSSI_BG, 0);
 	SPEX(boardflags_lo, SSB_SPROM1_BFLLO, 0xFFFF, 0);
-	if (out->revision >= 2)
-		SPEX(boardflags_hi, SSB_SPROM2_BFLHI, 0xFFFF, 0);
+		
 	SPEX(alpha2[0], SSB_SPROM1_CCODE, 0xff00, 8);
 	SPEX(alpha2[1], SSB_SPROM1_CCODE, 0x00ff, 0);
 
@@ -407,6 +421,8 @@ static void sprom_extract_r123(struct ssb_sprom *out, const u16 *in)
 	out->antenna_gain.a1 = r123_extract_antgain(out->revision, in,
 						    SSB_SPROM1_AGAIN_A,
 						    SSB_SPROM1_AGAIN_A_SHIFT);
+	if (out->revision >= 2)
+		sprom_extract_r23(out, in);
 }
 
 /* Revs 4 5 and 8 have partially shared layout */
-- 
1.7.10.4

